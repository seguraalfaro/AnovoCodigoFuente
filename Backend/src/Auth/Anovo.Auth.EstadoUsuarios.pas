unit Anovo.Auth.EstadoUsuarios;

// Estado vigente de cada cuenta (activa, rol, ultimo cambio de clave) con un
// cache corto: un token deja de servir en cuanto cambia algo de la cuenta.

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
      const ADebeCambiar: Boolean): Boolean;
    class procedure Olvidar(const AUsuarioId: Integer);
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.SyncObjs,
  System.Generics.Collections,
  MVCFramework.Commons,
  Anovo.Entities.Consultas,
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

var
  gBloqueo: TCriticalSection;
  gEstados: TDictionary<Integer, TEstadoCuenta>;

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

class constructor TEstadoUsuarios.Create;
begin
  gBloqueo := TCriticalSection.Create;
  gEstados := TDictionary<Integer, TEstadoCuenta>.Create;
end;

class destructor TEstadoUsuarios.Destroy;
begin
  gEstados.Free;
  gBloqueo.Free;
end;

class function TEstadoUsuarios.SesionVigente(const AContext: TWebContext;
  const AUsuarioId: Integer; const ARol: string; const AEmitido: TDateTime;
  const ADebeCambiar: Boolean): Boolean;
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
    (ADebeCambiar or not lEstado.DebeCambiar);
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
