unit Anovo.Services.Solicitudes;

// Servicio de solicitudes: captura idempotente desde el movil con sus
// piezas, alcance por asesor y cambios de estado.

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
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Entities.Usuarios,
  Anovo.Services.Intf.Solicitudes,
  Anovo.Services.Intf.Permisos,
  Anovo.DTOs.Dashboard;

const
  ESTADO_CAPTURADA = 'capturada';
  ESTADO_RECIBIDA = 'recibida';
  ESTADO_EN_COTIZACION = 'en_cotizacion';
  CONSENTIMIENTO_REVOCADO = 'revocado';
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
    fPiezas: ISolicitudPiezaRepository;
    fMedidas: ISolicitudMedidaRepository;
    fAdjuntos: ISolicitudAdjuntoRepository;
    fClientes: IClienteRepository;
    fContactos: IClienteContactoRepository;
    fTipos: ITipoTrabajoRepository;
    fTiposMaterial: ITipoMaterialRepository;
    fAcabados: IAcabadoRepository;
    fPermisos: IPermisoService;
    fUsuarios: IUsuarioRepository;

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
    procedure ExigirEditable(const ASolicitud: TSolicitudes);
    procedure ExigirEditableDe(const AId: Integer);
    function AsesorValido(const AAsesorId, AUsuarioId: Integer): Integer;
    function ResolverCliente(const ADto: TSolicitudNuevaDTO): Integer;
    function ResolverContacto(const ADto: TSolicitudNuevaDTO;
      const AClienteId: Integer): NullableInt32;
    function ResolverPieza(const ASolicitudId: Integer;
      const APiezaId: NullableInt32; const APiezaUuid: NullableString): Integer;
    procedure ValidarCatalogos(const ADto: TPiezaNuevaDTO);
    function InsertarPieza(const ASolicitudId: Integer;
      const ADto: TPiezaNuevaDTO): Integer;
    function InsertarMedida(const APiezaId: Integer;
      const ADto: TMedidaNuevaDTO): Integer;
    function InsertarAdjunto(const APiezaId: Integer;
      const ADto: TAdjuntoNuevoDTO): Integer;
  public
    [MVCInject]
    constructor Create(ARepo: ISolicitudRepository;
      APiezas: ISolicitudPiezaRepository;
      AMedidas: ISolicitudMedidaRepository;
      AAdjuntos: ISolicitudAdjuntoRepository;
      AClientes: IClienteRepository; AContactos: IClienteContactoRepository;
      ATipos: ITipoTrabajoRepository; ATiposMaterial: ITipoMaterialRepository;
      AAcabados: IAcabadoRepository; APermisos: IPermisoService;
      AUsuarios: IUsuarioRepository); reintroduce;

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
      const ASoloMes: Boolean; const AFiltroDesde, AFiltroHasta: TDateTime;
      const APagina, APorPagina: Integer; out ADesde, AHasta: TDateTime;
      out ATotal: Int64): TObjectList<TSolicitudAsesorDTO>;

    function Cola(const ATexto: string; const APagina, APorPagina: Integer;
      out ATotal: Int64): TObjectList<TSolicitudPorCotizarDTO>;
    function EnTrabajo(const AUsuarioId: Integer; const ATexto: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudEnTrabajoDTO>;
    function Piezas(const AId: Integer; const AUsuarioId: Integer;
      const ARoles: TArray<string>): TObjectList<TPiezaDTO>;
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
  System.Hash,
  System.SysUtils,
  JsonDataObjects,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Entities.Catalogos,
  Anovo.Entities.Clientes,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Periodo,
  Anovo.Permisos,
  Anovo.Textos,
  System.DateUtils,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas;

constructor TSolicitudService.Create(ARepo: ISolicitudRepository;
  APiezas: ISolicitudPiezaRepository; AMedidas: ISolicitudMedidaRepository;
  AAdjuntos: ISolicitudAdjuntoRepository; AClientes: IClienteRepository;
  AContactos: IClienteContactoRepository; ATipos: ITipoTrabajoRepository;
  ATiposMaterial: ITipoMaterialRepository; AAcabados: IAcabadoRepository;
  APermisos: IPermisoService; AUsuarios: IUsuarioRepository);
begin
  inherited Create;
  fRepo := ARepo;
  fPiezas := APiezas;
  fMedidas := AMedidas;
  fAdjuntos := AAdjuntos;
  fClientes := AClientes;
  fContactos := AContactos;
  fTipos := ATipos;
  fTiposMaterial := ATiposMaterial;
  fAcabados := AAcabados;
  fPermisos := APermisos;
  fUsuarios := AUsuarios;
end;

procedure TSolicitudService.ValidarCatalogos(const ADto: TPiezaNuevaDTO);
var
  lTipo: TTiposTrabajo;
  lMaterial: TTiposMaterial;
  lAcabado: TAcabados;
begin
  if not ADto.TipoTrabajoId.HasValue then
    raise EDatoInvalido.Create(SFaltaTipoTrabajo);
  if not ADto.TipoMaterialId.HasValue then
    raise EDatoInvalido.Create(SFaltaTipoMaterial);
  if not ADto.AcabadoId.HasValue then
    raise EDatoInvalido.Create(SFaltaAcabado);

  lTipo := fTipos.GetByPK(ADto.TipoTrabajoId.Value, False);
  try
    if (lTipo = nil) or not lTipo.Activo.ValueOrDefault then
      raise EDatoInvalido.Create(STipoTrabajoNoDisponible);
  finally
    lTipo.Free;
  end;
  lMaterial := fTiposMaterial.GetByPK(ADto.TipoMaterialId.Value, False);
  try
    if (lMaterial = nil) or not lMaterial.Activo.ValueOrDefault then
      raise EDatoInvalido.Create(STipoMaterialNoDisponible);
  finally
    lMaterial.Free;
  end;
  lAcabado := fAcabados.GetByPK(ADto.AcabadoId.Value, False);
  try
    if (lAcabado = nil) or not lAcabado.Activo.ValueOrDefault then
      raise EDatoInvalido.Create(SAcabadoNoDisponible);
  finally
    lAcabado.Free;
  end;
end;

function TSolicitudService.ResolverCliente(const ADto: TSolicitudNuevaDTO)
  : Integer;
begin
  Result := ADto.ClienteId;
  if (Result = 0) and ADto.ClienteUuid.HasValue and
    not ADto.ClienteUuid.Value.IsEmpty then
    Result := fClientes.ExitsUuidLocal(ADto.ClienteUuid.Value);
  if Result = 0 then
    raise EDatoInvalido.Create(SClienteNoExiste);
  ValidarCliente(Result);
end;

function TSolicitudService.ResolverContacto(const ADto: TSolicitudNuevaDTO;
  const AClienteId: Integer): NullableInt32;
var
  lContacto: TClienteContactos;
begin
  Result := nil;
  if ADto.ClienteContactoId.HasValue then
    lContacto := fContactos.ContactoDe(AClienteId, ADto.ClienteContactoId.Value)
  else if ADto.ClienteContactoUuid.HasValue and
    not ADto.ClienteContactoUuid.Value.IsEmpty then
    lContacto := fContactos.PorUuidLocal(ADto.ClienteContactoUuid.Value)
  else
    Exit;
  try
    if (lContacto = nil) or (lContacto.ClienteId <> AClienteId) then
      raise EDatoInvalido.Create(SContactoNoEsDelCliente);
    if lContacto.Anonimizado or not lContacto.Activo.ValueOrDefault then
      raise EDatoInvalido.Create(SContactoNoDisponible);
    Result := lContacto.ID.Value;
  finally
    lContacto.Free;
  end;
end;

function TSolicitudService.ResolverPieza(const ASolicitudId: Integer;
  const APiezaId: NullableInt32; const APiezaUuid: NullableString): Integer;
var
  lPieza: TSolicitudPiezas;
  lPiezas: TObjectList<TPiezasDeSolicitud>;
begin
  if APiezaId.HasValue then
    lPieza := fPiezas.PiezaDe(ASolicitudId, APiezaId.Value)
  else if APiezaUuid.HasValue and not APiezaUuid.Value.IsEmpty then
    lPieza := fPiezas.ObtenerPorUuidLocal(APiezaUuid.Value)
  else
  begin
    lPiezas := fPiezas.PiezasDe(ASolicitudId);
    try
      if lPiezas.Count <> 1 then
        raise EDatoInvalido.Create(SFaltaPieza);
      Exit(lPiezas[0].ID.Value);
    finally
      lPiezas.Free;
    end;
  end;
  try
    if (lPieza = nil) or (lPieza.SolicitudId <> ASolicitudId) then
      raise ERecursoNoEncontrado.Create(SRecursoPieza,
        APiezaId.ValueOrDefault);
    Result := lPieza.ID.Value;
  finally
    lPieza.Free;
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
  try
    if lCliente.Anonimizado or not lCliente.Activo.ValueOrDefault then
      raise EDatoInvalido.Create(SClienteNoDisponible);
    if lCliente.ConsentimientoEstado = CONSENTIMIENTO_REVOCADO then
      raise EDatoInvalido.Create(SClienteConsentimientoRevocado);
  finally
    lCliente.Free;
  end;
end;

procedure TSolicitudService.ExigirEditable(const ASolicitud: TSolicitudes);
begin
  if ASolicitud.Estado = ESTADO_EN_COTIZACION then
    raise EConflictoDeEstado.Create('SOLICITUD_COTIZADA', SSolicitudCotizada);
end;

procedure TSolicitudService.ExigirEditableDe(const AId: Integer);
var
  lSolicitud: TSolicitudes;
begin
  lSolicitud := TraerVigente(AId);
  try
    ExigirEditable(lSolicitud);
  finally
    lSolicitud.Free;
  end;
end;

function TSolicitudService.AsesorValido(const AAsesorId,
  AUsuarioId: Integer): Integer;
var
  lAsesor: TUsuarios;
begin
  if AAsesorId <= 0 then
    Exit(AUsuarioId);
  lAsesor := fUsuarios.GetByPK(AAsesorId, False);
  try
    if (lAsesor = nil) or not lAsesor.Activo.ValueOrDefault then
      raise EDatoInvalido.Create(SAsesorNoValido);
    Result := AAsesorId;
  finally
    lAsesor.Free;
  end;
end;

function TSolicitudService.Buscar(const ATexto, AEstado: string;
  const ADesde, AHasta: TDateTime; const ARoles: TArray<string>;
  const AAsesorId, APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TSolicitudDTO>;
var
  lFiltroAsesor: Integer;
  lPeriodo: TPeriodo;
  lFilas: TObjectList<TSolicitudes>;
  lFila: TSolicitudes;
begin
  if fPermisos.TieneAlguno(AAsesorId, ARoles,
    [PERMISO_SOLICITUDES_VER_TODAS]) then
    lFiltroAsesor := 0
  else
    lFiltroAsesor := AAsesorId;
  lPeriodo := TPeriodo.De(ADesde, AHasta);

  ATotal := fRepo.ContarBusqueda(ATexto, lFiltroAsesor, AEstado,
    lPeriodo.Inicio, lPeriodo.Fin);

  lFilas := fRepo.Buscar(ATexto, APagina, APorPagina, lFiltroAsesor,
    AEstado, lPeriodo.Inicio, lPeriodo.Fin);
  try
    Result := TObjectList<TSolicitudDTO>.Create(True);
    try
      for lFila in lFilas do
        Result.Add(ADto(lFila));
    except
      Result.Free;
      raise;
    end;
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
  lClienteId: Integer;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if ADto.UuidLocal.IsEmpty then
    raise EDatoInvalido.Create(SFaltaIdLocalSolicitud);
  ExigirLargoUuid(ADto.UuidLocal);

  Result := fRepo.ExisteUuidLocal(ADto.UuidLocal);
  if Result > 0 then
    Exit;

  lClienteId := ResolverCliente(ADto);

  lSolicitud := TSolicitudes.Create;
  try
    TMapeo.Copiar(ADto, lSolicitud);
    lSolicitud.ClienteId := lClienteId;
    lSolicitud.ClienteContactoId := ResolverContacto(ADto, lClienteId);
    if not fPermisos.TieneAlguno(AUsuarioId, ARoles,
      [PERMISO_SOLICITUDES_VER_TODAS]) then
      lSolicitud.AsesorId := AUsuarioId
    else
      lSolicitud.AsesorId := AsesorValido(lSolicitud.AsesorId, AUsuarioId);
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
    ExigirEditable(lSolicitud);

    if lSolicitud.Objversion <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create(SRecursoSolicitud, AId);

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
  lPieza: TPiezaNuevaDTO;
  lMedida: TMedidaNuevaDTO;
  lAdjunto: TAdjuntoNuevoDTO;
  lPiezaId: Integer;
  lAdjuntos: TDictionary<string, Integer>;
  lCroquisId: Integer;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if ADto.Piezas.Count = 0 then
    raise EDatoInvalido.Create(SSolicitudSinPiezas);

  Result := Crear(ADto.Solicitud, AUsuarioId, ARoles);

  lAdjuntos := TDictionary<string, Integer>.Create;
  try
    for lPieza in ADto.Piezas do
    begin
      lPiezaId := InsertarPieza(Result, lPieza);
      lAdjuntos.Clear;
      for lAdjunto in lPieza.Adjuntos do
        lAdjuntos.AddOrSetValue(lAdjunto.UuidLocal,
          InsertarAdjunto(lPiezaId, lAdjunto));
      for lMedida in lPieza.Medidas do
      begin
        if lMedida.CroquisUuid.HasValue then
        begin
          if not lAdjuntos.TryGetValue(lMedida.CroquisUuid.Value, lCroquisId)
          then
            raise EDatoInvalido.Create(SCroquisNoEsDeLaPieza);
          lMedida.CroquisId := lCroquisId;
        end;
        InsertarMedida(lPiezaId, lMedida);
      end;
    end;
  finally
    lAdjuntos.Free;
  end;
end;

function TSolicitudService.InsertarPieza(const ASolicitudId: Integer;
  const ADto: TPiezaNuevaDTO): Integer;
var
  lPieza: TSolicitudPiezas;
begin
  if ADto.UuidLocal.IsEmpty then
    raise EDatoInvalido.Create(SFaltaUuidLocal);
  ExigirLargoUuid(ADto.UuidLocal);

  lPieza := fPiezas.ObtenerPorUuidLocal(ADto.UuidLocal);
  if lPieza <> nil then
    try
      Exit(lPieza.ID.Value);
    finally
      lPieza.Free;
    end;

  ValidarCatalogos(ADto);
  lPieza := TSolicitudPiezas.Create;
  try
    TMapeo.Copiar(ADto, lPieza);
    lPieza.SolicitudId := ASolicitudId;
    lPieza.Activo := True;
    fPiezas.Insert(lPieza);
    Result := lPieza.ID.Value;
  finally
    lPieza.Free;
  end;
end;

function TSolicitudService.Piezas(const AId: Integer; const AUsuarioId: Integer;
  const ARoles: TArray<string>): TObjectList<TPiezaDTO>;
var
  lFilas: TObjectList<TPiezasDeSolicitud>;
begin
  ExigirAlcanceDe(AId, AUsuarioId, ARoles, PERMISO_SOLICITUDES_VER_TODAS);
  lFilas := fPiezas.PiezasDe(AId);
  try
    Result := TMapeo.AListaDto<TPiezasDeSolicitud, TPiezaDTO>(lFilas);
  finally
    lFilas.Free;
  end;
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
  lFilas: TObjectList<TMedidasDeSolicitud>;
begin
  ExigirAlcanceDe(AId, AUsuarioId, ARoles, PERMISO_SOLICITUDES_VER_TODAS);
  lFilas := fMedidas.MedidasDe(AId);
  try
    Result := TMapeo.AListaDto<TMedidasDeSolicitud, TMedidaDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

procedure ValidarCantidad(const ADto: TMedidaNuevaDTO);
begin
  if (ADto.Cantidad < CANTIDAD_MINIMA) or (ADto.Cantidad > CANTIDAD_MAXIMA) then
    raise EDatoInvalido.Create(SCantidadMedidaInvalida);
end;

function TSolicitudService.InsertarMedida(const APiezaId: Integer;
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
    lMedida.PiezaId := APiezaId;
    lMedida.Activo := True;
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
    ExigirEditable(lSolicitud);
    FijarDetalle(Format(SDetalleMedidaAgregada, [AId]));
    Result := InsertarMedida(ResolverPieza(AId, ADto.PiezaId, ADto.PiezaUuid),
      ADto);
  finally
    lSolicitud.Free;
  end;
end;

procedure TSolicitudService.ActualizarMedida(const AId, AMedidaId: Integer;
  const ADto: TMedidaNuevaDTO; const AUsuarioId: Integer; const ARoles: TArray<string>);
var
  lMedida: TSolicitudMedidas;
  lPiezaId: Integer;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  ExigirAlcanceDe(AId, AUsuarioId, ARoles, PERMISO_SOLICITUDES_EDITAR_TODAS);
  ExigirEditableDe(AId);
  ValidarCantidad(ADto);
  lMedida := TraerMedida(AId, AMedidaId);
  try
    lPiezaId := lMedida.PiezaId;
    TMapeo.Copiar(ADto, lMedida);
    lMedida.PiezaId := lPiezaId;
    lMedida.Activo := True;
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
  ExigirEditableDe(AId);
  lMedida := TraerMedida(AId, AMedidaId);
  try
    FijarDetalle(Format(SDetalleMedidaEliminada, [AId]));
    lMedida.Activo := False;
    fMedidas.Update(lMedida);
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

function HuellaDe(const ABytes: TBytes): string;
var
  lHash: THashSHA2;
begin
  lHash := THashSHA2.Create(THashSHA2.TSHA2Version.SHA256);
  lHash.Update(ABytes);
  Result := lHash.HashAsString.ToLower;
end;

function TSolicitudService.InsertarAdjunto(const APiezaId: Integer;
  const ADto: TAdjuntoNuevoDTO): Integer;
var
  lAdjunto: TSolicitudAdjuntos;
  lExistente: TSolicitudAdjuntos;
  lBytes: TBytes;
  lHuella: string;
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
    lAdjunto.PiezaId := APiezaId;
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

      lHuella := HuellaDe(lBytes);
      if ADto.HashSha256.HasValue and not ADto.HashSha256.Value.Trim.IsEmpty and
        not SameText(ADto.HashSha256.Value.Trim, lHuella) then
        raise EDatoInvalido.Create(SAdjuntoHuellaDistinta);
      lAdjunto.HashSha256 := lHuella;

      lAdjunto.Contenido.Size := 0;
      lAdjunto.Contenido.WriteBuffer(lBytes[0], Length(lBytes));
      lAdjunto.Contenido.Position := 0;
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
    ExigirEditable(lSolicitud);
    FijarDetalle(Format(SDetalleAdjuntoAgregado, [AId]));
    Result := InsertarAdjunto(ResolverPieza(AId, ADto.PiezaId, ADto.PiezaUuid),
      ADto);
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
  ExigirEditableDe(AId);
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
  const AFiltroDesde, AFiltroHasta: TDateTime;
  const APagina, APorPagina: Integer; out ADesde, AHasta: TDateTime;
  out ATotal: Int64): TObjectList<TSolicitudAsesorDTO>;
var
  lFilas: TObjectList<TSeguimientoAsesor>;
  lPeriodo: TPeriodo;
begin
  lPeriodo := TPeriodo.De(AFiltroDesde, AFiltroHasta);
  ADesde := lPeriodo.Inicio;
  AHasta := lPeriodo.Fin;
  if not lPeriodo.Activo and ASoloMes then
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
