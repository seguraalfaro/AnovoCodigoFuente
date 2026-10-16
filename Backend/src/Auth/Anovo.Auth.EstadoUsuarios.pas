unit Anovo.Auth.EstadoUsuarios;

// Estado vigente de cada cuenta (activa, rol, ultimo cambio de clave) y de
// cada telefono, con un cache corto: un token deja de servir en cuanto cambia.

interface

uses
  MVCFramework;

type
  TEstadoUsuarios = class
  public
    class constructor Create;
    class destructor Destroy;
    class function SesionVigente(const AContext: TWebContext;
      const AUsuarioId: Integer; const ARol: string; const AEmitido: TDateTime;
      const ADebeCambiar: Boolean; const ADispositivoId: Integer): Boolean;
    class procedure Olvidar(const AUsuarioId: Integer);
    class procedure OlvidarDispositivo(const ADispositivoId: Integer);
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.SyncObjs,
  System.Generics.Collections,
  MVCFramework.Commons,
  Anovo.Entities.Consultas,
  Anovo.Entities.Usuarios,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Services.Intf.Sesion;

type
  TEstadoCuenta = record
    Existe: Boolean;
    Activo: Boolean;
    DebeCambiar: Boolean;
    Rol: string;
    FechaClave: TDateTime;
    Leido: TDateTime;
  end;

  TEstadoTelefono = record
    Activo: Boolean;
    Leido: TDateTime;
  end;

var
  gBloqueo: TCriticalSection;
  gEstados: TDictionary<Integer, TEstadoCuenta>;
  gTelefonos: TDictionary<Integer, TEstadoTelefono>;

const
  SEGUNDOS_TOLERANCIA = 1;

function SegundosCache: Integer;
begin
  Result := dotEnv.Env('anovo.sesion.revision_segundos', 30);
end;

function Leer(const AContext: TWebContext;
  const AUsuarioId: Integer): TEstadoCuenta;
var
  lRepo: IUsuarioRepository;
  lVista: TUsuariosBuscados;
begin
  Result := Default(TEstadoCuenta);
  lRepo := AContext.ServiceContainerResolver.Resolve(
    TypeInfo(IUsuarioRepository)) as IUsuarioRepository;
  lVista := lRepo.Vista(AUsuarioId);
  try
    Result.Existe := lVista <> nil;
    if Result.Existe then
    begin
      Result.Activo := lVista.Activo.ValueOrDefault;
      Result.DebeCambiar := lVista.DebeCambiarClave.ValueOrDefault;
      Result.Rol := lVista.Rol.ValueOrDefault;
      Result.FechaClave := lVista.FechaClave.ValueOrDefault;
    end;
  finally
    lVista.Free;
  end;
  Result.Leido := Now;
end;

function LeerTelefono(const AContext: TWebContext;
  const ADispositivoId: Integer): TEstadoTelefono;
var
  lRepo: IDispositivoRepository;
  lFila: TUsuariosDispositivos;
begin
  lRepo := AContext.ServiceContainerResolver.Resolve(
    TypeInfo(IDispositivoRepository)) as IDispositivoRepository;
  lFila := lRepo.GetByPK(ADispositivoId, False);
  try
    Result.Activo := (lFila <> nil) and lFila.Activo.ValueOrDefault;
  finally
    lFila.Free;
  end;
  Result.Leido := Now;
end;

function TelefonoActivo(const AContext: TWebContext;
  const ADispositivoId: Integer): Boolean;
var
  lEstado: TEstadoTelefono;
  lEnCache: Boolean;
begin
  gBloqueo.Enter;
  try
    lEnCache := gTelefonos.TryGetValue(ADispositivoId, lEstado) and
      (SecondsBetween(Now, lEstado.Leido) < SegundosCache);
  finally
    gBloqueo.Leave;
  end;

  if not lEnCache then
  begin
    lEstado := LeerTelefono(AContext, ADispositivoId);
    gBloqueo.Enter;
    try
      gTelefonos.AddOrSetValue(ADispositivoId, lEstado);
    finally
      gBloqueo.Leave;
    end;
  end;
  Result := lEstado.Activo;
end;

class constructor TEstadoUsuarios.Create;
begin
  gBloqueo := TCriticalSection.Create;
  gEstados := TDictionary<Integer, TEstadoCuenta>.Create;
  gTelefonos := TDictionary<Integer, TEstadoTelefono>.Create;
end;

class destructor TEstadoUsuarios.Destroy;
begin
  gTelefonos.Free;
  gEstados.Free;
  gBloqueo.Free;
end;

class function TEstadoUsuarios.SesionVigente(const AContext: TWebContext;
  const AUsuarioId: Integer; const ARol: string; const AEmitido: TDateTime;
  const ADebeCambiar: Boolean; const ADispositivoId: Integer): Boolean;
var
  lEstado: TEstadoCuenta;
  lEnCache: Boolean;
begin
  gBloqueo.Enter;
  try
    lEnCache := gEstados.TryGetValue(AUsuarioId, lEstado) and
      (SecondsBetween(Now, lEstado.Leido) < SegundosCache);
  finally
    gBloqueo.Leave;
  end;

  if not lEnCache then
  begin
    lEstado := Leer(AContext, AUsuarioId);
    gBloqueo.Enter;
    try
      gEstados.AddOrSetValue(AUsuarioId, lEstado);
    finally
      gBloqueo.Leave;
    end;
  end;

  Result := lEstado.Existe and lEstado.Activo and
    (SameText(lEstado.Rol, ARol) or (lEstado.DebeCambiar and
    SameText(ARol, ROL_CLAVE_VENCIDA))) and
    (lEstado.FechaClave <= IncSecond(AEmitido, SEGUNDOS_TOLERANCIA)) and
    (ADebeCambiar or not lEstado.DebeCambiar) and
    ((ADispositivoId = 0) or TelefonoActivo(AContext, ADispositivoId));
end;

class procedure TEstadoUsuarios.OlvidarDispositivo(const ADispositivoId
  : Integer);
begin
  gBloqueo.Enter;
  try
    gTelefonos.Remove(ADispositivoId);
  finally
    gBloqueo.Leave;
  end;
end;

class procedure TEstadoUsuarios.Olvidar(const AUsuarioId: Integer);
begin
  gBloqueo.Enter;
  try
    gEstados.Remove(AUsuarioId);
  finally
    gBloqueo.Leave;
  end;
end;

end.
