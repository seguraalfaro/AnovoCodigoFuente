unit Anovo.Services.Solicitudes;

// Servicio de solicitudes: donde vive el negocio de lo que captura el movil.
//
// Tres cosas pasan aqui y en ningun otro sitio.
//
// La idempotencia. El telefono guarda sin conexion y sube cuando puede; si la
// respuesta se pierde de vuelta, reintenta. Sin comprobar el uuid_local, cada
// reintento seria una solicitud nueva y el asesor terminaria con la misma
// visita tres veces sin haber hecho nada mal.
//
// La maquina de estados. La base no la impone -ESTADO es un VARCHAR sin
// CHECK-, asi que las transiciones validas estan aqui y solo aqui.
//
// El limite de los adjuntos. El tamano se calcula al decodificar, no se cree
// el que manda el cliente: la restriccion de 3 MB de la tabla se comprueba
// antes para devolver un mensaje util en lugar del error del motor.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  Anovo.DTOs.Solicitudes,
  Anovo.Entities.Solicitudes,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Repositories.Intf.Solicitudes,
  Anovo.Services.Intf.Solicitudes;

const
  // Los estados por los que pasa una solicitud. No estan en la base: si
  // manana se agrega uno, se agrega aqui y en TRANSICIONES.
  ESTADO_BORRADOR = 'borrador';
  ESTADO_ENVIADA = 'enviada';
  ESTADO_RECIBIDA = 'recibida';
  ESTADO_COTIZADA = 'cotizada';
  ESTADO_ANULADA = 'anulada';

  // El tope que ya impone CK_ADJUNTO_TAMANO.
  ADJUNTO_MAXIMO_BYTES = 3145728;

  ADJUNTO_CROQUIS = 'croquis';
  ADJUNTO_FOTO = 'foto';

type
  TSolicitudService = class(TInterfacedObject, ISolicitudService)
  private
    fRepo: ISolicitudRepository;
    fMedidas: ISolicitudMedidaRepository;
    fAdjuntos: ISolicitudAdjuntoRepository;
    fClientes: IClienteRepository;

    function TraerVigente(const AId: Integer): TSolicitudes;
    function TraerMedida(const AId, AMedidaId: Integer): TSolicitudMedidas;
    function TraerAdjunto(const AId, AAdjuntoId: Integer)
      : TSolicitudAdjuntos;
    function ADto(const ASolicitud: TSolicitudes): TSolicitudDTO;
    procedure ValidarTransicion(const ADesde, AHacia: string);
    procedure ValidarCliente(const AClienteId: Integer);
    function InsertarMedida(const ASolicitudId: Integer;
      const ADto: TMedidaNuevaDTO): Integer;
    function InsertarAdjunto(const ASolicitudId: Integer;
      const ADto: TAdjuntoNuevoDTO): Integer;
  public
    [MVCInject]
    constructor Create(ARepo: ISolicitudRepository;
      AMedidas: ISolicitudMedidaRepository;
      AAdjuntos: ISolicitudAdjuntoRepository;
      AClientes: IClienteRepository); reintroduce;

    function Buscar(const ATexto, AEstado: string;
      const ADesde, AHasta: TDateTime; const ASoloPropias: Boolean;
      const AAsesorId, APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudDTO>;
    function Obtener(const AId: Integer): TSolicitudDTO;
    function Crear(const ADto: TSolicitudNuevaDTO): Integer;
    procedure Actualizar(const AId: Integer; const ADto: TSolicitudEdicionDTO);
    function RegistrarCompleta(const ADto: TSolicitudCompletaDTO): Integer;
    procedure MarcarRecibida(const AId: Integer);
    procedure CambiarEstado(const AId: Integer; const ADto: TCambioEstadoDTO);
    function PendientesDeCotizar: TObjectList<TSolicitudDTO>;

    function Medidas(const AId: Integer): TObjectList<TMedidaDTO>;
    function AgregarMedida(const AId: Integer;
      const ADto: TMedidaNuevaDTO): Integer;
    procedure ActualizarMedida(const AId, AMedidaId: Integer;
      const ADto: TMedidaNuevaDTO);
    procedure EliminarMedida(const AId, AMedidaId: Integer);

    function Adjuntos(const AId: Integer): TObjectList<TAdjuntoDTO>;
    function ObtenerAdjunto(const AId, AAdjuntoId: Integer)
      : TAdjuntoContenidoDTO;
    function AgregarAdjunto(const AId: Integer;
      const ADto: TAdjuntoNuevoDTO): Integer;
    procedure InactivarAdjunto(const AId, AAdjuntoId: Integer);
  end;

implementation

uses
  System.Classes,
  System.NetEncoding,
  System.SysUtils,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Entities.Clientes,
  Anovo.Errors,
  Anovo.Mapeo;

constructor TSolicitudService.Create(ARepo: ISolicitudRepository;
  AMedidas: ISolicitudMedidaRepository;
  AAdjuntos: ISolicitudAdjuntoRepository; AClientes: IClienteRepository);
begin
  inherited Create;
  fRepo := ARepo;
  fMedidas := AMedidas;
  fAdjuntos := AAdjuntos;
  fClientes := AClientes;
end;

// Apoyo

function TSolicitudService.TraerVigente(const AId: Integer): TSolicitudes;
begin
  Result := fRepo.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('la solicitud', AId);
end;

function TSolicitudService.TraerMedida(const AId, AMedidaId: Integer)
  : TSolicitudMedidas;
begin
  Result := fMedidas.MedidaDe(AId, AMedidaId);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('la medida', AMedidaId);
end;

function TSolicitudService.TraerAdjunto(const AId, AAdjuntoId: Integer)
  : TSolicitudAdjuntos;
begin
  Result := fAdjuntos.AdjuntoDe(AId, AAdjuntoId);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('el adjunto', AAdjuntoId);
end;

function TSolicitudService.ADto(const ASolicitud: TSolicitudes): TSolicitudDTO;
var
  lCliente: TClientes;
begin
  Result := TMapeo.ADto<TSolicitudDTO>(ASolicitud);
  // El nombre del cliente no esta en la tabla y la pantalla lo necesita. En el
  // listado esto es una consulta por fila; si el listado llega a pesar, se
  // resuelve con una proyeccion como la de catalogos.
  lCliente := fClientes.GetByPK(ASolicitud.ClienteId, False);
  if lCliente <> nil then
    try
      Result.ClienteNombre := lCliente.Nombre;
    finally
      lCliente.Free;
    end;
end;

procedure TSolicitudService.ValidarTransicion(const ADesde, AHacia: string);
var
  lValida: Boolean;
begin
  // Borrador y enviada las pone el movil; recibida la pone el servidor al
  // recibirla; cotizada la pone el modulo de cotizaciones. Anular se puede
  // desde cualquier estado que no sea cotizada.
  if AHacia = ESTADO_ANULADA then
    lValida := ADesde <> ESTADO_COTIZADA
  else if ADesde = ESTADO_BORRADOR then
    lValida := AHacia = ESTADO_ENVIADA
  else if ADesde = ESTADO_ENVIADA then
    lValida := AHacia = ESTADO_RECIBIDA
  else if ADesde = ESTADO_RECIBIDA then
    lValida := AHacia = ESTADO_COTIZADA
  else
    lValida := False;

  if not lValida then
    raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
      Format('Una solicitud en estado %s no puede pasar a %s.',
      [ADesde, AHacia]));
end;

procedure TSolicitudService.ValidarCliente(const AClienteId: Integer);
var
  lCliente: TClientes;
begin
  // Se comprueba antes de insertar para devolver un 422 con mensaje en lugar
  // de la violacion de clave foranea, que sale como error del motor.
  lCliente := fClientes.GetByPK(AClienteId, False);
  if lCliente = nil then
    raise EDatoInvalido.Create('El cliente indicado no existe.');
  lCliente.Free;
end;

// Solicitudes

function TSolicitudService.Buscar(const ATexto, AEstado: string;
  const ADesde, AHasta: TDateTime; const ASoloPropias: Boolean;
  const AAsesorId, APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TSolicitudDTO>;
var
  lFiltroAsesor: Integer;
  lFilas: TObjectList<TSolicitudes>;
  lFila: TSolicitudes;
begin
  // 0 es "todos". El alcance lo decidio el controller con los permisos.
  if ASoloPropias then
    lFiltroAsesor := AAsesorId
  else
    lFiltroAsesor := 0;

  ATotal := fRepo.ContarBusqueda(ATexto, lFiltroAsesor, AEstado,
    ADesde, AHasta);

  lFilas := fRepo.Buscar(ATexto, APagina, APorPagina, lFiltroAsesor,
    AEstado, ADesde, AHasta);
  try
    Result := TObjectList<TSolicitudDTO>.Create(True);
    for lFila in lFilas do
      Result.Add(ADto(lFila));
  finally
    lFilas.Free;
  end;
end;

function TSolicitudService.Obtener(const AId: Integer): TSolicitudDTO;
var
  lSolicitud: TSolicitudes;
begin
  lSolicitud := TraerVigente(AId);
  try
    Result := ADto(lSolicitud);
  finally
    lSolicitud.Free;
  end;
end;

function TSolicitudService.Crear(const ADto: TSolicitudNuevaDTO): Integer;
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if ADto.UuidLocal.IsEmpty then
    raise EDatoInvalido.Create('Falta el identificador local de la solicitud.');

  // Idempotencia: si ya subio, se devuelve la que hay.
  Result := fRepo.ExisteUuidLocal(ADto.UuidLocal);
  if Result > 0 then
    Exit;

  ValidarCliente(ADto.ClienteId);

  lSolicitud := TSolicitudes.Create;
  try
    TMapeo.Copiar(ADto, lSolicitud);
    if ADto.FechaCaptura.HasValue then
      lSolicitud.FechaCaptura := ADto.FechaCaptura.Value
    else
      lSolicitud.FechaCaptura := Now;
    lSolicitud.Estado := ESTADO_ENVIADA;
    lSolicitud.FechaRecepcion := Now;
    FijarDetalle('Registro de la solicitud ' + ADto.Descripcion);
    fRepo.Insert(lSolicitud);
    Result := lSolicitud.ID.ValueOrDefault;
  finally
    lSolicitud.Free;
  end;
end;

procedure TSolicitudService.Actualizar(const AId: Integer;
  const ADto: TSolicitudEdicionDTO);
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create
      ('Falta la version del registro. Recargue la solicitud y vuelva a editarla.');

  lSolicitud := TraerVigente(AId);
  try
    if lSolicitud.Estado = ESTADO_COTIZADA then
      raise EConflictoDeEstado.Create('SOLICITUD_COTIZADA',
        'Esta solicitud ya tiene cotizacion y no admite cambios.');

    // La comparacion se hace aqui, y no se deja solo a foVersion, para que el
    // caso corriente salga con 409 y un mensaje que diga que hacer.
    if lSolicitud.Objversion.ValueOrDefault <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create('la solicitud', AId);

    TMapeo.Copiar(ADto, lSolicitud);
    FijarDetalle('Cambio en la solicitud ' + AId.ToString);
    fRepo.Update(lSolicitud);
  finally
    lSolicitud.Free;
  end;
end;

function TSolicitudService.RegistrarCompleta(const ADto
  : TSolicitudCompletaDTO): Integer;
var
  lMedida: TMedidaNuevaDTO;
  lAdjunto: TAdjuntoNuevoDTO;
begin
  // Una sola transaccion para las tres tablas: o entra la visita entera o no
  // entra. Una solicitud con la mitad de las fotos es peor que ninguna,
  // porque nadie sabe que falta.
  var
  lTx := TMVCRepository.UseTransactionContext;

  Result := Crear(ADto.Solicitud);

  for lMedida in ADto.Medidas do
    InsertarMedida(Result, lMedida);

  for lAdjunto in ADto.Adjuntos do
    InsertarAdjunto(Result, lAdjunto);
end;

procedure TSolicitudService.MarcarRecibida(const AId: Integer);
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lSolicitud := TraerVigente(AId);
  try
    // Se sella una sola vez: la primera recepcion es la que cuenta para medir
    // el tiempo entre la visita y la llegada.
    if lSolicitud.FechaRecepcion.HasValue then
      Exit;

    lSolicitud.FechaRecepcion := Now;
    if lSolicitud.Estado = ESTADO_ENVIADA then
      lSolicitud.Estado := ESTADO_RECIBIDA;
    FijarDetalle('Recepcion de la solicitud ' + AId.ToString);
    fRepo.Update(lSolicitud);
  finally
    lSolicitud.Free;
  end;
end;

procedure TSolicitudService.CambiarEstado(const AId: Integer;
  const ADto: TCambioEstadoDTO);
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lSolicitud := TraerVigente(AId);
  try
    ValidarTransicion(lSolicitud.Estado, ADto.Estado);

    // Anular sin decir por que deja un hueco que nadie puede explicar despues.
    if (ADto.Estado = ESTADO_ANULADA) and
      (not ADto.Observacion.HasValue or ADto.Observacion.Value.IsEmpty) then
      raise EDatoInvalido.Create('Anular exige una observacion.');

    lSolicitud.Estado := ADto.Estado;
    if ADto.Observacion.HasValue then
      lSolicitud.Observaciones := ADto.Observacion;

    FijarDetalle(Format('Cambio de estado de la solicitud %d a %s',
      [AId, ADto.Estado]));
    fRepo.Update(lSolicitud);
  finally
    lSolicitud.Free;
  end;
end;

function TSolicitudService.PendientesDeCotizar: TObjectList<TSolicitudDTO>;
var
  lFilas: TObjectList<TSolicitudes>;
  lFila: TSolicitudes;
begin
  lFilas := fRepo.PendientesDeCotizar(ESTADO_RECIBIDA);
  try
    Result := TObjectList<TSolicitudDTO>.Create(True);
    for lFila in lFilas do
      Result.Add(ADto(lFila));
  finally
    lFilas.Free;
  end;
end;

// Medidas

function TSolicitudService.Medidas(const AId: Integer): TObjectList<TMedidaDTO>;
var
  lFilas: TObjectList<TSolicitudMedidas>;
begin
  lFilas := fMedidas.MedidasDe(AId);
  try
    Result := TMapeo.AListaDto<TSolicitudMedidas, TMedidaDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TSolicitudService.InsertarMedida(const ASolicitudId: Integer;
  const ADto: TMedidaNuevaDTO): Integer;
var
  lMedida: TSolicitudMedidas;
  lExistente: TSolicitudMedidas;
begin
  // Idempotencia, igual que la solicitud: el telefono puede reenviar el lote.
  if ADto.UuidLocal.HasValue and not ADto.UuidLocal.Value.IsEmpty then
  begin
    lExistente := fMedidas.ObtenerPorUuidLocal(ADto.UuidLocal.Value);
    if lExistente <> nil then
      try
        Exit(lExistente.ID.ValueOrDefault);
      finally
        lExistente.Free;
      end;
  end;

  lMedida := TSolicitudMedidas.Create;
  try
    TMapeo.Copiar(ADto, lMedida);
    lMedida.SolicitudId := ASolicitudId;
    fMedidas.Insert(lMedida);
    Result := lMedida.ID.ValueOrDefault;
  finally
    lMedida.Free;
  end;
end;

function TSolicitudService.AgregarMedida(const AId: Integer;
  const ADto: TMedidaNuevaDTO): Integer;
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lSolicitud := TraerVigente(AId);
  try
    FijarDetalle('Medida agregada a la solicitud ' + AId.ToString);
    Result := InsertarMedida(AId, ADto);
  finally
    lSolicitud.Free;
  end;
end;

procedure TSolicitudService.ActualizarMedida(const AId, AMedidaId: Integer;
  const ADto: TMedidaNuevaDTO);
var
  lMedida: TSolicitudMedidas;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lMedida := TraerMedida(AId, AMedidaId);
  try
    TMapeo.Copiar(ADto, lMedida);
    // El uuid y la solicitud no se cambian: identifican la fila.
    lMedida.SolicitudId := AId;
    FijarDetalle('Cambio en una medida de la solicitud ' + AId.ToString);
    fMedidas.Update(lMedida);
  finally
    lMedida.Free;
  end;
end;

procedure TSolicitudService.EliminarMedida(const AId, AMedidaId: Integer);
var
  lMedida: TSolicitudMedidas;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lMedida := TraerMedida(AId, AMedidaId);
  try
    FijarDetalle('Medida eliminada de la solicitud ' + AId.ToString);
    fMedidas.Delete(lMedida);
  finally
    lMedida.Free;
  end;
end;

// Adjuntos

function TSolicitudService.Adjuntos(const AId: Integer)
  : TObjectList<TAdjuntoDTO>;
var
  lFilas: TObjectList<TSolicitudAdjuntos>;
begin
  lFilas := fAdjuntos.AdjuntosDe(AId);
  try
    Result := TMapeo.AListaDto<TSolicitudAdjuntos, TAdjuntoDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TSolicitudService.ObtenerAdjunto(const AId, AAdjuntoId: Integer)
  : TAdjuntoContenidoDTO;
var
  lAdjunto: TSolicitudAdjuntos;
  lBytes: TBytes;
begin
  lAdjunto := TraerAdjunto(AId, AAdjuntoId);
  try
    Result := TMapeo.ADto<TAdjuntoContenidoDTO>(lAdjunto);
    Result.ContenidoJson := lAdjunto.ContenidoJson;

    // JSON no lleva binario: los bytes salen en base64.
    if (lAdjunto.Contenido <> nil) and (lAdjunto.Contenido.Size > 0) then
    begin
      SetLength(lBytes, lAdjunto.Contenido.Size);
      lAdjunto.Contenido.Position := 0;
      lAdjunto.Contenido.ReadBuffer(lBytes[0], Length(lBytes));
      Result.Contenido := TNetEncoding.Base64.EncodeBytesToString(lBytes);
    end;
  finally
    lAdjunto.Free;
  end;
end;

function TSolicitudService.InsertarAdjunto(const ASolicitudId: Integer;
  const ADto: TAdjuntoNuevoDTO): Integer;
var
  lAdjunto: TSolicitudAdjuntos;
  lExistente: TSolicitudAdjuntos;
  lBytes: TBytes;
  lStream: TMemoryStream;
begin
  if ADto.UuidLocal.IsEmpty then
    raise EDatoInvalido.Create('Falta el identificador local del adjunto.');

  if (ADto.Tipo <> ADJUNTO_CROQUIS) and (ADto.Tipo <> ADJUNTO_FOTO) then
    raise EDatoInvalido.Create('El tipo de adjunto debe ser croquis o foto.');

  lExistente := fAdjuntos.ObtenerPorUuidLocal(ADto.UuidLocal);
  if lExistente <> nil then
    try
      Exit(lExistente.ID.ValueOrDefault);
    finally
      lExistente.Free;
    end;

  lAdjunto := TSolicitudAdjuntos.Create;
  try
    lAdjunto.SolicitudId := ASolicitudId;
    lAdjunto.UuidLocal := ADto.UuidLocal;
    lAdjunto.Tipo := ADto.Tipo;
    lAdjunto.NombreArchivo := ADto.NombreArchivo;
    lAdjunto.Mime := ADto.Mime;
    lAdjunto.ContenidoJson := ADto.ContenidoJson;
    lAdjunto.Activo := True;
    lAdjunto.FechaCreacion := Now;

    if ADto.Contenido.HasValue and not ADto.Contenido.Value.IsEmpty then
    begin
      lBytes := TNetEncoding.Base64.DecodeStringToBytes(ADto.Contenido.Value);

      // El tamano se mide, no se cree: un cliente que mienta en el tamano no
      // debe poder saltarse el limite.
      if Length(lBytes) > ADJUNTO_MAXIMO_BYTES then
        raise EDatoInvalido.Create
          ('El adjunto supera el maximo de 3 MB permitido.');

      lStream := TMemoryStream.Create;
      lStream.WriteBuffer(lBytes[0], Length(lBytes));
      lStream.Position := 0;
      // La entidad se queda con el stream y lo libera ella.
      lAdjunto.Contenido := lStream;
      lAdjunto.TamanoBytes := Length(lBytes);
    end
    else if not ADto.ContenidoJson.HasValue then
      // Un adjunto sin bytes y sin trazos no es nada: seria una fila que dice
      // que hay una foto que no existe.
      raise EDatoInvalido.Create
        ('El adjunto viene vacio: falta el contenido o los trazos.');

    fAdjuntos.Insert(lAdjunto);
    Result := lAdjunto.ID.ValueOrDefault;
  finally
    lAdjunto.Free;
  end;
end;

function TSolicitudService.AgregarAdjunto(const AId: Integer;
  const ADto: TAdjuntoNuevoDTO): Integer;
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lSolicitud := TraerVigente(AId);
  try
    FijarDetalle('Adjunto agregado a la solicitud ' + AId.ToString);
    Result := InsertarAdjunto(AId, ADto);
  finally
    lSolicitud.Free;
  end;
end;

procedure TSolicitudService.InactivarAdjunto(const AId, AAdjuntoId: Integer);
var
  lAdjunto: TSolicitudAdjuntos;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lAdjunto := TraerAdjunto(AId, AAdjuntoId);
  try
    lAdjunto.Activo := False;
    FijarDetalle('Adjunto inactivado en la solicitud ' + AId.ToString);
    fAdjuntos.Update(lAdjunto);
  finally
    lAdjunto.Free;
  end;
end;

end.
