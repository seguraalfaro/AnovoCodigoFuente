unit Anovo.Services.Dispositivos;

// Llave de dispositivo: se entrega al registrar el telefono, se guarda solo su
// hash, rota en cada renovacion y un reuso inactiva el dispositivo.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  Anovo.DTOs.Dispositivos,
  Anovo.Entities.Usuarios,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Services.Intf.Dispositivos,
  Anovo.Services.Intf.Permisos,
  Anovo.Services.Intf.Sesion;

type
  TDispositivoService = class(TInterfacedObject, IDispositivoService)
  private
    fDispositivos: IDispositivoRepository;
    fClaves: IUsuarioClaveRepository;
    fSesion: ISesionService;
    fPermisos: IPermisoService;
    function NuevaLlave: string;
    function Hash(const ALlave: string): string;
    function Vence: TDateTime;
    procedure ValidarPedido(const AUuidDispositivo, ALlave: string);
    function Buscar(const AUuidDispositivo, ALlaveHash: string)
      : TUsuariosDispositivos;
    function Rechazo(const ADispositivo: TUsuariosDispositivos;
      out ASesion: TAutenticacion): string;
    function ClaveCambiadaDespues(const ADispositivo
      : TUsuariosDispositivos): Boolean;
    procedure Inactivar(const ADispositivo: TUsuariosDispositivos;
      const AMotivo: string);
    procedure RevisarReuso(const AUuidDispositivo, ALlaveHash: string);
    function InactivarEnTransaccion(const AUsuarioId,
      ADispositivoId: Integer): Boolean;
  public
    [MVCInject]
    constructor Create(ADispositivos: IDispositivoRepository;
      AClaves: IUsuarioClaveRepository; ASesion: ISesionService;
      APermisos: IPermisoService); reintroduce;
    function Registrar(const AUsuarioId: Integer;
      const ADto: TDispositivoNuevoDTO): TLlaveDispositivoDTO;
    function Renovar(const ADto: TRenovacionDTO): TSesionRenovadaDTO;
    procedure Cerrar(const ADto: TRenovacionDTO);
    function DeUsuario(const AUsuarioId: Integer): TObjectList<TDispositivoDTO>;
    procedure InactivarPorAdmin(const AUsuarioId, ADispositivoId: Integer);
  end;

implementation

uses
  System.SysUtils,
  System.Hash,
  MVCFramework.Commons,
  MVCFramework.Logger,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Auth.EstadoUsuarios,
  Anovo.Auth.Token,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Permisos,
  Anovo.Textos;

const
  DIAS_SIN_USO = 30;
  LARGO_NOMBRE = 120;

constructor TDispositivoService.Create(ADispositivos: IDispositivoRepository;
  AClaves: IUsuarioClaveRepository; ASesion: ISesionService;
  APermisos: IPermisoService);
begin
  inherited Create;
  fDispositivos := ADispositivos;
  fClaves := AClaves;
  fSesion := ASesion;
  fPermisos := APermisos;
end;

function TDispositivoService.NuevaLlave: string;
var
  lParte: TGUID;
  i: Integer;
begin
  Result := '';
  for i := 1 to 2 do
  begin
    CreateGUID(lParte);
    Result := Result + GUIDToString(lParte).Replace('{', '').Replace('}', '')
      .Replace('-', '').ToLower;
  end;
end;

function TDispositivoService.Hash(const ALlave: string): string;
begin
  Result := THashSHA2.GetHashString(ALlave).ToLower;
end;

function TDispositivoService.Vence: TDateTime;
begin
  Result := Now + dotEnv.Env('anovo.dispositivos.dias_sin_uso', DIAS_SIN_USO);
end;

procedure TDispositivoService.ValidarPedido(const AUuidDispositivo,
  ALlave: string);
begin
  if AUuidDispositivo.Trim.IsEmpty or ALlave.Trim.IsEmpty then
    raise EAnovoError.Create('DISPOSITIVO_INVALIDO', SDispositivoInvalido,
      HTTP_STATUS.Unauthorized);
  ExigirLargoUuid(AUuidDispositivo);
end;

function TDispositivoService.Buscar(const AUuidDispositivo, ALlaveHash: string)
  : TUsuariosDispositivos;
var
  lActivos: TObjectList<TUsuariosDispositivos>;
  i: Integer;
begin
  Result := nil;
  lActivos := fDispositivos.ActivosDe(AUuidDispositivo);
  try
    for i := 0 to lActivos.Count - 1 do
      if lActivos[i].LlaveHash = ALlaveHash then
        Exit(lActivos.Extract(lActivos[i]));
  finally
    lActivos.Free;
  end;
end;

procedure TDispositivoService.Inactivar(const ADispositivo
  : TUsuariosDispositivos; const AMotivo: string);
begin
  FijarUsuario(ADispositivo.UsuarioId);
  try
    ADispositivo.Activo := False;
    ADispositivo.Motivo := AMotivo;
    fDispositivos.Update(ADispositivo);
  finally
    LimpiarUsuario;
  end;
  TEstadoUsuarios.OlvidarDispositivo(ADispositivo.ID.Value);
  LogW(Format('Dispositivo %d inactivado: %s', [ADispositivo.ID.Value,
    AMotivo]));
end;

procedure TDispositivoService.RevisarReuso(const AUuidDispositivo,
  ALlaveHash: string);
var
  lCopiado: TUsuariosDispositivos;
begin
  lCopiado := fDispositivos.PorLlaveAnterior(ALlaveHash);
  if lCopiado = nil then
    Exit;
  try
    if lCopiado.UuidDispositivo = AUuidDispositivo then
      Inactivar(lCopiado, MOTIVO_REUSO);
  finally
    lCopiado.Free;
  end;
end;

function TDispositivoService.ClaveCambiadaDespues(const ADispositivo
  : TUsuariosDispositivos): Boolean;
var
  lClave: TUsuariosClaves;
begin
  lClave := fClaves.ClaveActivaDe(ADispositivo.UsuarioId);
  if lClave = nil then
    Exit(True);
  try
    Result := lClave.FechaCambio.HasValue and
      (lClave.FechaCambio.Value > ADispositivo.FechaCreacion.ValueOrDefault);
  finally
    lClave.Free;
  end;
end;

function TDispositivoService.Rechazo(const ADispositivo: TUsuariosDispositivos;
  out ASesion: TAutenticacion): string;
begin
  Result := '';
  ASesion := Default(TAutenticacion);
  if ADispositivo.FechaVence < Now then
    Exit(MOTIVO_VENCIDO);
  ASesion := fSesion.SesionDe(ADispositivo.UsuarioId);
  if not ASesion.Valido or not fPermisos.Tiene(ASesion.UsuarioId, ASesion.Rol,
    PERMISO_ADJUNTOS_CREAR) then
    Exit(MOTIVO_USUARIO);
  if ASesion.DebeCambiarClave or ClaveCambiadaDespues(ADispositivo) then
    Exit(MOTIVO_CLAVE);
end;

function TDispositivoService.Registrar(const AUsuarioId: Integer;
  const ADto: TDispositivoNuevoDTO): TLlaveDispositivoDTO;
var
  lAnteriores: TObjectList<TUsuariosDispositivos>;
  lAnterior: TUsuariosDispositivos;
  lNuevo: TUsuariosDispositivos;
  lLlave: string;
  lReemplazados: TArray<Integer>;
  lId: Integer;
begin
  if ADto.UuidDispositivo.Trim.IsEmpty then
    raise EDatoInvalido.Create(SFaltaUuidDispositivo);
  ExigirLargoUuid(ADto.UuidDispositivo);

  lLlave := NuevaLlave;
  Result := TLlaveDispositivoDTO.Create;
  try
    var
    lTx := TMVCRepository.UseTransactionContext;

    lAnteriores := fDispositivos.ActivosDe(ADto.UuidDispositivo.Trim);
    try
      for lAnterior in lAnteriores do
      begin
        lAnterior.Activo := False;
        lAnterior.Motivo := MOTIVO_REEMPLAZO;
        fDispositivos.Update(lAnterior);
        lReemplazados := lReemplazados + [lAnterior.ID.Value];
      end;
    finally
      lAnteriores.Free;
    end;

    lNuevo := TUsuariosDispositivos.Create;
    try
      lNuevo.UsuarioId := AUsuarioId;
      lNuevo.UuidDispositivo := ADto.UuidDispositivo.Trim;
      if not ADto.Nombre.Trim.IsEmpty then
        lNuevo.Nombre := ADto.Nombre.Trim.Substring(0, LARGO_NOMBRE);
      lNuevo.LlaveHash := Hash(lLlave);
      lNuevo.FechaVence := Vence;
      lNuevo.Activo := True;
      fDispositivos.Insert(lNuevo);
      Result.Llave := lLlave;
      Result.Vence := lNuevo.FechaVence;
      Result.Token := EmitirToken(fSesion.SesionDe(AUsuarioId),
        lNuevo.ID.Value);
    finally
      lNuevo.Free;
    end;
  except
    Result.Free;
    raise;
  end;
  for lId in lReemplazados do
    TEstadoUsuarios.OlvidarDispositivo(lId);
end;

function TDispositivoService.Renovar(const ADto: TRenovacionDTO)
  : TSesionRenovadaDTO;
var
  lDispositivo: TUsuariosDispositivos;
  lSesion: TAutenticacion;
  lMotivo, lHash, lLlave: string;
begin
  ValidarPedido(ADto.UuidDispositivo, ADto.Llave);
  lHash := Hash(ADto.Llave.Trim);
  lDispositivo := Buscar(ADto.UuidDispositivo.Trim, lHash);
  if lDispositivo = nil then
  begin
    RevisarReuso(ADto.UuidDispositivo.Trim, lHash);
    raise EAnovoError.Create('DISPOSITIVO_INVALIDO', SDispositivoInvalido,
      HTTP_STATUS.Unauthorized);
  end;

  try
    lMotivo := Rechazo(lDispositivo, lSesion);
    if not lMotivo.IsEmpty then
    begin
      Inactivar(lDispositivo, lMotivo);
      raise EAnovoError.Create('DISPOSITIVO_INVALIDO', SDispositivoInvalido,
        HTTP_STATUS.Unauthorized);
    end;

    lLlave := NuevaLlave;
    FijarUsuario(lDispositivo.UsuarioId);
    try
      lDispositivo.LlaveAnteriorHash := lDispositivo.LlaveHash;
      lDispositivo.LlaveHash := Hash(lLlave);
      lDispositivo.FechaUltimoUso := Now;
      lDispositivo.FechaVence := Vence;
      fDispositivos.Update(lDispositivo);
    finally
      LimpiarUsuario;
    end;

    Result := TSesionRenovadaDTO.Create;
    Result.Token := EmitirToken(lSesion, lDispositivo.ID.Value);
    Result.Llave := lLlave;
    Result.Vence := lDispositivo.FechaVence;
  finally
    lDispositivo.Free;
  end;
end;

function TDispositivoService.DeUsuario(const AUsuarioId: Integer)
  : TObjectList<TDispositivoDTO>;
var
  lFilas: TObjectList<TUsuariosDispositivos>;
begin
  lFilas := fDispositivos.DeUsuario(AUsuarioId);
  try
    Result := TMapeo.AListaDto<TUsuariosDispositivos, TDispositivoDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TDispositivoService.InactivarEnTransaccion(const AUsuarioId,
  ADispositivoId: Integer): Boolean;
var
  lFila: TUsuariosDispositivos;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lFila := fDispositivos.GetByPK(ADispositivoId, False);
  if (lFila <> nil) and (lFila.UsuarioId <> AUsuarioId) then
    FreeAndNil(lFila);
  if lFila = nil then
    raise ERecursoNoEncontrado.Create(SRecursoDispositivo, ADispositivoId);
  try
    if not lFila.Activo.ValueOrDefault then
      Exit(False);
    lFila.Activo := False;
    lFila.Motivo := MOTIVO_ADMIN;
    FijarDetalle(Format(SDetalleInactivacionDispositivo,
      [lFila.Nombre.ValueOrDefault, AUsuarioId]));
    fDispositivos.Update(lFila);
    Result := True;
  finally
    lFila.Free;
  end;
end;

procedure TDispositivoService.InactivarPorAdmin(const AUsuarioId,
  ADispositivoId: Integer);
begin
  if InactivarEnTransaccion(AUsuarioId, ADispositivoId) then
    TEstadoUsuarios.OlvidarDispositivo(ADispositivoId);
end;

procedure TDispositivoService.Cerrar(const ADto: TRenovacionDTO);
var
  lDispositivo: TUsuariosDispositivos;
begin
  if ADto.UuidDispositivo.Trim.IsEmpty or ADto.Llave.Trim.IsEmpty then
    Exit;
  ExigirLargoUuid(ADto.UuidDispositivo);
  lDispositivo := Buscar(ADto.UuidDispositivo.Trim, Hash(ADto.Llave.Trim));
  if lDispositivo = nil then
    Exit;
  try
    Inactivar(lDispositivo, MOTIVO_CIERRE);
  finally
    lDispositivo.Free;
  end;
end;

end.
