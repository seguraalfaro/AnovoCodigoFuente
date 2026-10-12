unit Anovo.Services.Solicitudes;

// Servicio de solicitudes: captura idempotente desde el movil,
// alcance por asesor y cambios de estado.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  MVCFramework.Nullables,
  Anovo.DTOs.Solicitudes,
  Anovo.Entities.Solicitudes,
  Anovo.Repositories.Intf.Catalogos,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Repositories.Intf.Solicitudes,
  Anovo.Services.Intf.Solicitudes,
  Anovo.Services.Intf.Permisos,
  Anovo.DTOs.Dashboard;

const
  ESTADO_CAPTURADA = 'capturada';
  ESTADO_RECIBIDA = 'recibida';
  ESTADO_EN_COTIZACION = 'en_cotizacion';
  ESTADO_DESCARTADA = 'descartada';

  ADJUNTO_MAXIMO_BYTES = 3145728;

  CANTIDAD_MINIMA = 1;
  CANTIDAD_MAXIMA = 9999;

  ADJUNTO_CROQUIS = 'croquis';
  ADJUNTO_FOTO = 'foto';
  MIME_JPEG = 'image/jpeg';
  MIME_PNG = 'image/png';

type
  TSolicitudService = class(TInterfacedObject, ISolicitudService)
  private
    fRepo: ISolicitudRepository;
    fMedidas: ISolicitudMedidaRepository;
    fAdjuntos: ISolicitudAdjuntoRepository;
    fClientes: IClienteRepository;
    fTipos: ITipoTrabajoRepository;
    fPermisos: IPermisoService;

    function TraerVigente(const AId: Integer): TSolicitudes;
    procedure ExigirAlcance(const ASolicitud: TSolicitudes;
      const AUsuarioId: Integer; const ARoles: TArray<string>;
      const APermisoTodas: string);
    procedure ExigirAlcanceDe(const AId, AUsuarioId: Integer;
      const ARoles: TArray<string>; const APermisoTodas: string);
    function TraerMedida(const AId, AMedidaId: Integer): TSolicitudMedidas;
    function TraerAdjunto(const AId, AAdjuntoId: Integer)
      : TSolicitudAdjuntos;
    function ADto(const ASolicitud: TSolicitudes): TSolicitudDTO;
    procedure ValidarTransicion(const ADesde, AHacia: string);
    procedure ValidarCliente(const AClienteId: Integer);
    procedure ValidarTipoTrabajo(const ATipoId, AActual: NullableInt32);
    function InsertarMedida(const ASolicitudId: Integer;
      const ADto: TMedidaNuevaDTO): Integer;
    function InsertarAdjunto(const ASolicitudId: Integer;
      const ADto: TAdjuntoNuevoDTO): Integer;
  public
    [MVCInject]
    constructor Create(ARepo: ISolicitudRepository;
      AMedidas: ISolicitudMedidaRepository;
      AAdjuntos: ISolicitudAdjuntoRepository;
      AClientes: IClienteRepository; ATipos: ITipoTrabajoRepository;
      APermisos: IPermisoService); reintroduce;

    function Buscar(const ATexto, AEstado: string;
      const ADesde, AHasta: TDateTime; const ARoles: TArray<string>;
      const AAsesorId, APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudDTO>;
    function Obtener(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>): TSolicitudDTO;
    function Crear(const ADto: TSolicitudNuevaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;
    procedure Actualizar(const AId: Integer; const ADto: TSolicitudEdicionDTO; const AUsuarioId: Integer; const ARoles: TArray<string>);
    function RegistrarCompleta(const ADto: TSolicitudCompletaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;
    procedure MarcarRecibida(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>);
    procedure CambiarEstado(const AId: Integer; const ADto: TCambioEstadoDTO; const AUsuarioId: Integer; const ARoles: TArray<string>);    function Seguimiento(const AAsesorId: Integer; const ATexto: string;
      const ASoloMes: Boolean; const APagina, APorPagina: Integer;
      out ADesde, AHasta: TDateTime; out ATotal: Int64)
      : TObjectList<TSolicitudAsesorDTO>;

    function Cola(const ATexto: string; const APagina, APorPagina: Integer;
      out ATotal: Int64): TObjectList<TSolicitudPorCotizarDTO>;
    function EnTrabajo(const AUsuarioId: Integer; const ATexto: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudEnTrabajoDTO>;
    function Medidas(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>): TObjectList<TMedidaDTO>;
    function AgregarMedida(const AId: Integer;
      const ADto: TMedidaNuevaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;
    procedure ActualizarMedida(const AId, AMedidaId: Integer;
      const ADto: TMedidaNuevaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>);
    procedure EliminarMedida(const AId, AMedidaId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>);

    function Adjuntos(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>): TObjectList<TAdjuntoDTO>;
    function ObtenerAdjunto(const AId, AAdjuntoId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>)
      : TAdjuntoContenidoDTO;
    function AgregarAdjunto(const AId: Integer;
      const ADto: TAdjuntoNuevoDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;
    procedure InactivarAdjunto(const AId, AAdjuntoId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>);
  end;

implementation

uses
  System.Classes,
  System.NetEncoding,
  System.SysUtils,
  JsonDataObjects,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Entities.Catalogos,
  Anovo.Entities.Clientes,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Permisos,
  Anovo.Textos,
  System.DateUtils,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas;

constructor TSolicitudService.Create(ARepo: ISolicitudRepository;
  AMedidas: ISolicitudMedidaRepository;
  AAdjuntos: ISolicitudAdjuntoRepository; AClientes: IClienteRepository;
  ATipos: ITipoTrabajoRepository; APermisos: IPermisoService);
begin
  inherited Create;
  fRepo := ARepo;
  fMedidas := AMedidas;
  fAdjuntos := AAdjuntos;
  fClientes := AClientes;
  fTipos := ATipos;
  fPermisos := APermisos;
end;

procedure TSolicitudService.ValidarTipoTrabajo(const ATipoId,
  AActual: NullableInt32);
var
  lTipo: TTiposTrabajo;
begin
  if not ATipoId.HasValue then
    Exit;
  if AActual.HasValue and (AActual.Value = ATipoId.Value) then
    Exit;

  lTipo := fTipos.GetByPK(ATipoId.Value, False);
  try
    if (lTipo = nil) or not lTipo.Activo.ValueOrDefault then
      raise EDatoInvalido.Create(STipoTrabajoNoDisponible);
  finally
    lTipo.Free;
  end;
end;

function TSolicitudService.TraerVigente(const AId: Integer): TSolicitudes;
begin
  Result := fRepo.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoSolicitud, AId);
end;

procedure TSolicitudService.ExigirAlcance(const ASolicitud: TSolicitudes;
  const AUsuarioId: Integer; const ARoles: TArray<string>;
  const APermisoTodas: string);
begin
  if ASolicitud.AsesorId = AUsuarioId then
    Exit;
  if fPermisos.TieneAlguno(AUsuarioId, ARoles, [APermisoTodas]) then
    Exit;
  raise ERecursoNoEncontrado.Create(SRecursoSolicitud,
    ASolicitud.ID.ValueOrDefault);
end;

procedure TSolicitudService.ExigirAlcanceDe(const AId, AUsuarioId: Integer;
  const ARoles: TArray<string>; const APermisoTodas: string);
var
  lSolicitud: TSolicitudes;
begin
  lSolicitud := TraerVigente(AId);
  try
    ExigirAlcance(lSolicitud, AUsuarioId, ARoles, APermisoTodas);
  finally
    lSolicitud.Free;
  end;
end;

function TSolicitudService.TraerMedida(const AId, AMedidaId: Integer)
  : TSolicitudMedidas;
begin
  Result := fMedidas.MedidaDe(AId, AMedidaId);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoMedida, AMedidaId);
end;

function TSolicitudService.TraerAdjunto(const AId, AAdjuntoId: Integer)
  : TSolicitudAdjuntos;
begin
  Result := fAdjuntos.AdjuntoDe(AId, AAdjuntoId);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoAdjunto, AAdjuntoId);
end;

function TSolicitudService.ADto(const ASolicitud: TSolicitudes): TSolicitudDTO;
var
  lCliente: TClientes;
begin
  Result := TMapeo.ADto<TSolicitudDTO>(ASolicitud);
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
  if AHacia = ESTADO_DESCARTADA then
    lValida := ADesde <> ESTADO_EN_COTIZACION
  else if ADesde = ESTADO_CAPTURADA then
    lValida := AHacia = ESTADO_RECIBIDA
  else if ADesde = ESTADO_RECIBIDA then
    lValida := AHacia = ESTADO_EN_COTIZACION
  else
    lValida := False;

  if not lValida then
    raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
      Format(SSolicitudTransicionInvalida,
      [ADesde, AHacia]));
end;

procedure TSolicitudService.ValidarCliente(const AClienteId: Integer);
var
  lCliente: TClientes;
begin
  lCliente := fClientes.GetByPK(AClienteId, False);
  if lCliente = nil then
    raise EDatoInvalido.Create(SClienteNoExiste);
  lCliente.Free;
end;

function TSolicitudService.Buscar(const ATexto, AEstado: string;
  const ADesde, AHasta: TDateTime; const ARoles: TArray<string>;
  const AAsesorId, APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TSolicitudDTO>;
var
  lFiltroAsesor: Integer;
  lFilas: TObjectList<TSolicitudes>;
  lFila: TSolicitudes;
begin
  if fPermisos.TieneAlguno(AAsesorId, ARoles,
    [PERMISO_SOLICITUDES_VER_TODAS]) then
    lFiltroAsesor := 0
  else
    lFiltroAsesor := AAsesorId;

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

function TSolicitudService.Obtener(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>): TSolicitudDTO;
var
  lSolicitud: TSolicitudes;
begin
  lSolicitud := TraerVigente(AId);
  try
    ExigirAlcance(lSolicitud, AUsuarioId, ARoles,
      PERMISO_SOLICITUDES_VER_TODAS);
    Result := ADto(lSolicitud);
  finally
    lSolicitud.Free;
  end;
end;

function TSolicitudService.Crear(const ADto: TSolicitudNuevaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if ADto.UuidLocal.IsEmpty then
    raise EDatoInvalido.Create(SFaltaIdLocalSolicitud);
  ExigirLargoUuid(ADto.UuidLocal);

  Result := fRepo.ExisteUuidLocal(ADto.UuidLocal);
  if Result > 0 then
    Exit;

  ValidarCliente(ADto.ClienteId);
  ValidarTipoTrabajo(ADto.TipoTrabajoId, nil);

  lSolicitud := TSolicitudes.Create;
  try
    TMapeo.Copiar(ADto, lSolicitud);
    if not fPermisos.TieneAlguno(AUsuarioId, ARoles,
      [PERMISO_SOLICITUDES_VER_TODAS]) then
      lSolicitud.AsesorId := AUsuarioId;
    if ADto.FechaCaptura.HasValue then
      lSolicitud.FechaCaptura := ADto.FechaCaptura.Value
    else
      lSolicitud.FechaCaptura := Now;
    lSolicitud.Estado := ESTADO_RECIBIDA;
    lSolicitud.FechaRecepcion := Now;
    FijarDetalle(Format(SDetalleRegistroSolicitud, [ADto.Descripcion]));
    fRepo.Insert(lSolicitud);
    Result := lSolicitud.ID.ValueOrDefault;
  finally
    lSolicitud.Free;
  end;
end;

procedure TSolicitudService.Actualizar(const AId: Integer;
  const ADto: TSolicitudEdicionDTO; const AUsuarioId: Integer; const ARoles: TArray<string>);
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create(Format(SFaltaVersion, [SRecursoSolicitud]));

  lSolicitud := TraerVigente(AId);
  try
    ExigirAlcance(lSolicitud, AUsuarioId, ARoles,
      PERMISO_SOLICITUDES_EDITAR_TODAS);
    if lSolicitud.Estado = ESTADO_EN_COTIZACION then
      raise EConflictoDeEstado.Create('SOLICITUD_COTIZADA',
        SSolicitudCotizada);

    if lSolicitud.Objversion.ValueOrDefault <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create(SRecursoSolicitud, AId);

    ValidarTipoTrabajo(ADto.TipoTrabajoId, lSolicitud.TipoTrabajoId);
    TMapeo.Copiar(ADto, lSolicitud);
    FijarDetalle(Format(SDetalleCambioSolicitud, [AId]));
    fRepo.Update(lSolicitud);
  finally
    lSolicitud.Free;
  end;
end;

function TSolicitudService.RegistrarCompleta(const ADto
  : TSolicitudCompletaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;
var
  lMedida: TMedidaNuevaDTO;
  lAdjunto: TAdjuntoNuevoDTO;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  Result := Crear(ADto.Solicitud, AUsuarioId, ARoles);

  for lMedida in ADto.Medidas do
    InsertarMedida(Result, lMedida);

  for lAdjunto in ADto.Adjuntos do
    InsertarAdjunto(Result, lAdjunto);
end;

procedure TSolicitudService.MarcarRecibida(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>);
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lSolicitud := TraerVigente(AId);
  try
    ExigirAlcance(lSolicitud, AUsuarioId, ARoles,
      PERMISO_SOLICITUDES_EDITAR_TODAS);
    if (lSolicitud.Estado <> ESTADO_CAPTURADA) and
      lSolicitud.FechaRecepcion.HasValue then
      Exit;

    if lSolicitud.Estado = ESTADO_CAPTURADA then
      lSolicitud.Estado := ESTADO_RECIBIDA;
    if not lSolicitud.FechaRecepcion.HasValue then
      lSolicitud.FechaRecepcion := Now;
    FijarDetalle(Format(SDetalleRecepcionSolicitud, [AId]));
    fRepo.Update(lSolicitud);
  finally
    lSolicitud.Free;
  end;
end;

procedure TSolicitudService.CambiarEstado(const AId: Integer;
  const ADto: TCambioEstadoDTO; const AUsuarioId: Integer; const ARoles: TArray<string>);
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lSolicitud := TraerVigente(AId);
  try
    ExigirAlcance(lSolicitud, AUsuarioId, ARoles,
      PERMISO_SOLICITUDES_EDITAR_TODAS);
    ValidarTransicion(lSolicitud.Estado, ADto.Estado);

    if (ADto.Estado = ESTADO_DESCARTADA) and
      (not ADto.Observacion.HasValue or ADto.Observacion.Value.IsEmpty) then
      raise EDatoInvalido.Create(SDescartarSinMotivo);

    lSolicitud.Estado := ADto.Estado;
    if ADto.Observacion.HasValue then
      lSolicitud.Observaciones := ADto.Observacion;

    FijarDetalle(Format(SDetalleCambioEstadoSolicitud, [AId, ADto.Estado]));
    fRepo.Update(lSolicitud);
  finally
    lSolicitud.Free;
  end;
end;

function TSolicitudService.Medidas(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>): TObjectList<TMedidaDTO>;
var
  lFilas: TObjectList<TSolicitudMedidas>;
begin
  ExigirAlcanceDe(AId, AUsuarioId, ARoles, PERMISO_SOLICITUDES_VER_TODAS);
  lFilas := fMedidas.MedidasDe(AId);
  try
    Result := TMapeo.AListaDto<TSolicitudMedidas, TMedidaDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

procedure ValidarCantidad(const ADto: TMedidaNuevaDTO);
begin
  if (ADto.Cantidad < CANTIDAD_MINIMA) or (ADto.Cantidad > CANTIDAD_MAXIMA) then
    raise EDatoInvalido.Create(SCantidadMedidaInvalida);
end;

function TSolicitudService.InsertarMedida(const ASolicitudId: Integer;
  const ADto: TMedidaNuevaDTO): Integer;
var
  lMedida: TSolicitudMedidas;
  lExistente: TSolicitudMedidas;
begin
  if ADto.UuidLocal.HasValue and not ADto.UuidLocal.Value.IsEmpty then
  begin
    ExigirLargoUuid(ADto.UuidLocal.Value);
    lExistente := fMedidas.ObtenerPorUuidLocal(ADto.UuidLocal.Value);
    if lExistente <> nil then
      try
        Exit(lExistente.ID.ValueOrDefault);
      finally
        lExistente.Free;
      end;
  end;

  ValidarCantidad(ADto);
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
  const ADto: TMedidaNuevaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lSolicitud := TraerVigente(AId);
  try
    ExigirAlcance(lSolicitud, AUsuarioId, ARoles,
      PERMISO_SOLICITUDES_EDITAR_TODAS);
    FijarDetalle(Format(SDetalleMedidaAgregada, [AId]));
    Result := InsertarMedida(AId, ADto);
  finally
    lSolicitud.Free;
  end;
end;

procedure TSolicitudService.ActualizarMedida(const AId, AMedidaId: Integer;
  const ADto: TMedidaNuevaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>);
var
  lMedida: TSolicitudMedidas;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  ExigirAlcanceDe(AId, AUsuarioId, ARoles, PERMISO_SOLICITUDES_EDITAR_TODAS);
  ValidarCantidad(ADto);
  lMedida := TraerMedida(AId, AMedidaId);
  try
    TMapeo.Copiar(ADto, lMedida);
    lMedida.SolicitudId := AId;
    FijarDetalle(Format(SDetalleCambioMedida, [AId]));
    fMedidas.Update(lMedida);
  finally
    lMedida.Free;
  end;
end;

procedure TSolicitudService.EliminarMedida(const AId, AMedidaId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>);
var
  lMedida: TSolicitudMedidas;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  ExigirAlcanceDe(AId, AUsuarioId, ARoles, PERMISO_SOLICITUDES_EDITAR_TODAS);
  lMedida := TraerMedida(AId, AMedidaId);
  try
    FijarDetalle(Format(SDetalleMedidaEliminada, [AId]));
    fMedidas.Delete(lMedida);
  finally
    lMedida.Free;
  end;
end;

function TSolicitudService.Adjuntos(const AId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>)
  : TObjectList<TAdjuntoDTO>;
var
  lFilas: TObjectList<TAdjuntosDeSolicitud>;
begin
  ExigirAlcanceDe(AId, AUsuarioId, ARoles, PERMISO_SOLICITUDES_VER_TODAS);
  lFilas := fAdjuntos.AdjuntosDe(AId);
  try
    Result := TMapeo.AListaDto<TAdjuntosDeSolicitud, TAdjuntoDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TSolicitudService.ObtenerAdjunto(const AId, AAdjuntoId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>)
  : TAdjuntoContenidoDTO;
var
  lAdjunto: TSolicitudAdjuntos;
  lBytes: TBytes;
begin
  ExigirAlcanceDe(AId, AUsuarioId, ARoles, PERMISO_SOLICITUDES_VER_TODAS);
  lAdjunto := TraerAdjunto(AId, AAdjuntoId);
  try
    Result := TMapeo.ADto<TAdjuntoContenidoDTO>(lAdjunto);
    Result.ContenidoJson := lAdjunto.ContenidoJson;

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

function MimeDeImagen(const ABytes: TBytes): string;
begin
  Result := '';
  if (Length(ABytes) >= 3) and (ABytes[0] = $FF) and (ABytes[1] = $D8) and
    (ABytes[2] = $FF) then
    Result := MIME_JPEG
  else if (Length(ABytes) >= 8) and (ABytes[0] = $89) and (ABytes[1] = $50) and
    (ABytes[2] = $4E) and (ABytes[3] = $47) and (ABytes[4] = $0D) and
    (ABytes[5] = $0A) and (ABytes[6] = $1A) and (ABytes[7] = $0A) then
    Result := MIME_PNG;
end;

function JsonValido(const ATexto: string): Boolean;
var
  lJson: TJsonBaseObject;
begin
  try
    lJson := TJsonBaseObject.Parse(ATexto);
    lJson.Free;
    Result := True;
  except
    Result := False;
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
    raise EDatoInvalido.Create(SFaltaIdLocalAdjunto);
  ExigirLargoUuid(ADto.UuidLocal);

  if (ADto.Tipo <> ADJUNTO_CROQUIS) and (ADto.Tipo <> ADJUNTO_FOTO) then
    raise EDatoInvalido.Create(STipoAdjuntoInvalido);

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
    if ADto.ContenidoJson.HasValue and not JsonValido(ADto.ContenidoJson.Value) then
      raise EDatoInvalido.Create(SAdjuntoJsonInvalido);
    lAdjunto.ContenidoJson := ADto.ContenidoJson;
    lAdjunto.Activo := True;
    lAdjunto.FechaCreacion := Now;

    if ADto.Contenido.HasValue and not ADto.Contenido.Value.IsEmpty then
    begin
      try
        lBytes := TNetEncoding.Base64.DecodeStringToBytes(ADto.Contenido.Value);
      except
        raise EDatoInvalido.Create(SAdjuntoFormatoInvalido);
      end;

      if Length(lBytes) > ADJUNTO_MAXIMO_BYTES then
        raise EDatoInvalido.Create(SAdjuntoMuyGrande);

      lAdjunto.Mime := MimeDeImagen(lBytes);
      if lAdjunto.Mime.Value.IsEmpty then
        raise EDatoInvalido.Create(SAdjuntoFormatoInvalido);

      lStream := TMemoryStream.Create;
      lStream.WriteBuffer(lBytes[0], Length(lBytes));
      lStream.Position := 0;
      lAdjunto.Contenido := lStream;
      lAdjunto.TamanoBytes := Length(lBytes);
    end
    else if not ADto.ContenidoJson.HasValue then
      raise EDatoInvalido.Create(SAdjuntoVacio);

    fAdjuntos.Insert(lAdjunto);
    Result := lAdjunto.ID.ValueOrDefault;
  finally
    lAdjunto.Free;
  end;
end;

function TSolicitudService.AgregarAdjunto(const AId: Integer;
  const ADto: TAdjuntoNuevoDTO; const AUsuarioId: Integer; const ARoles: TArray<string>): Integer;
var
  lSolicitud: TSolicitudes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lSolicitud := TraerVigente(AId);
  try
    ExigirAlcance(lSolicitud, AUsuarioId, ARoles,
      PERMISO_SOLICITUDES_EDITAR_TODAS);
    FijarDetalle(Format(SDetalleAdjuntoAgregado, [AId]));
    Result := InsertarAdjunto(AId, ADto);
  finally
    lSolicitud.Free;
  end;
end;

procedure TSolicitudService.InactivarAdjunto(const AId, AAdjuntoId: Integer; const AUsuarioId: Integer; const ARoles: TArray<string>);
var
  lAdjunto: TSolicitudAdjuntos;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  ExigirAlcanceDe(AId, AUsuarioId, ARoles, PERMISO_SOLICITUDES_EDITAR_TODAS);
  lAdjunto := TraerAdjunto(AId, AAdjuntoId);
  try
    lAdjunto.Activo := False;
    FijarDetalle(Format(SDetalleAdjuntoInactivado, [AId]));
    fAdjuntos.Update(lAdjunto);
  finally
    lAdjunto.Free;
  end;
end;

function TSolicitudService.Cola(const ATexto: string;
  const APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TSolicitudPorCotizarDTO>;
var
  lFilas: TObjectList<TColaSolicitudes>;
begin
  ATotal := fRepo.ContarCola(ATexto);
  lFilas := fRepo.Cola(ATexto, APagina, APorPagina);
  try
    Result := TMapeo.AListaDto<TColaSolicitudes,
      TSolicitudPorCotizarDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TSolicitudService.EnTrabajo(const AUsuarioId: Integer;
  const ATexto: string; const APagina, APorPagina: Integer;
  out ATotal: Int64): TObjectList<TSolicitudEnTrabajoDTO>;
var
  lFilas: TObjectList<TCotizacionesEnTrabajo>;
begin
  ATotal := fRepo.ContarEnTrabajo(AUsuarioId, ATexto);
  lFilas := fRepo.EnTrabajo(AUsuarioId, ATexto, APagina, APorPagina);
  try
    Result := TMapeo.AListaDto<TCotizacionesEnTrabajo,
      TSolicitudEnTrabajoDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TSolicitudService.Seguimiento(const AAsesorId: Integer;
  const ATexto: string; const ASoloMes: Boolean;
  const APagina, APorPagina: Integer; out ADesde, AHasta: TDateTime;
  out ATotal: Int64): TObjectList<TSolicitudAsesorDTO>;
var
  lFilas: TObjectList<TSeguimientoAsesor>;
begin
  ADesde := 0;
  AHasta := 0;
  if ASoloMes then
  begin
    ADesde := StartOfTheMonth(Date);
    AHasta := IncMonth(ADesde, 1);
  end;

  ATotal := fRepo.ContarSeguimiento(AAsesorId, ATexto, ADesde, AHasta);
  lFilas := fRepo.Seguimiento(AAsesorId, ATexto, ADesde, AHasta, APagina,
    APorPagina);
  try
    Result := TMapeo.AListaDto<TSeguimientoAsesor,
      TSolicitudAsesorDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

end.
