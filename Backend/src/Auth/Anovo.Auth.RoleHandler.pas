unit Anovo.Auth.RoleHandler;

// Autenticacion por el servicio de sesion y autorizacion por rol
// y por permiso.

interface

uses
  System.Generics.Collections,
  System.Rtti,
  MVCFramework,
  MVCFramework.Middleware.Authentication.RoleBasedAuthHandler,
  Anovo.Services.Intf.Permisos;

type
  TAuthentication = class(TRoleBasedAuthHandler)
  private
    fRtti: TRttiContext;
    function DebeCambiarClave(const AContext: TWebContext): Boolean;
    function CumplePermisos(const AContext: TWebContext;
      UserRoles: TList<string>;
      const AAtributos: TArray<TCustomAttribute>): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure OnAuthentication(const AContext: TWebContext;
      const UserName: string; const Password: string; UserRoles: TList<string>;
      var IsValid: Boolean;
      const SessionData: TDictionary<string, string>); override;
    procedure OnAuthorization(const AContext: TWebContext;
      UserRoles: TList<string>; const ControllerQualifiedClassName: string;
      const ActionName: string; var IsAuthorized: Boolean); override;
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Commons,
  MVCFramework.Logger,
  Anovo.Auth.EstadoUsuarios,
  Anovo.Auth.Intentos,
  Anovo.Auth.Permisos,
  Anovo.Auth.Token,
  Anovo.Errors,
  Anovo.Red,
  Anovo.Services.Intf.Sesion,
  Anovo.Textos;

const
  CONTROLLER_CUENTA_PROPIA = 'Anovo.Controllers.Sesion.TSesionController';

constructor TAuthentication.Create;
begin
  inherited Create;
  fRtti := TRttiContext.Create;
end;

destructor TAuthentication.Destroy;
begin
  fRtti.Free;
  inherited;
end;

function RolDelToken(const ARoles: TList<string>): string;
begin
  if ARoles.Count > 0 then
    Result := ARoles[0]
  else
    Result := '';
end;

function TAuthentication.DebeCambiarClave(const AContext: TWebContext)
  : Boolean;
var
  lValor: string;
begin
  lValor := '';
  if Assigned(AContext.LoggedUser.CustomData) then
    AContext.LoggedUser.CustomData.TryGetValue(DATO_DEBE_CAMBIAR_CLAVE, lValor);
  Result := SameText(lValor, BoolToStr(True, True));
end;

function TAuthentication.CumplePermisos(const AContext: TWebContext;
  UserRoles: TList<string>; const AAtributos: TArray<TCustomAttribute>)
  : Boolean;
var
  lAtributo: TCustomAttribute;
  lPermisos: IPermisoService;
begin
  Result := True;
  for lAtributo in AAtributos do
    if lAtributo is MVCRequiresPermisoAttribute then
    begin
      if lPermisos = nil then
        lPermisos := AContext.ServiceContainerResolver.Resolve(
          TypeInfo(IPermisoService)) as IPermisoService;
      if not lPermisos.TieneAlguno(UsuarioDelToken(AContext),
        UserRoles.ToArray, MVCRequiresPermisoAttribute(lAtributo).GetPermisos)
      then
        Exit(False);
    end;
end;

procedure TAuthentication.OnAuthentication(const AContext: TWebContext;
  const UserName: string; const Password: string; UserRoles: TList<string>;
  var IsValid: Boolean; const SessionData: TDictionary<string, string>);
var
  lSesion: ISesionService;
  lResultado: TAutenticacion;
  lIp: string;
  lMinutos: Integer;
begin
  IsValid := False;
  UserRoles.Clear;
  lIp := IpCliente(AContext);
  if TIntentosIngreso.Bloqueado(UserName, lIp, lMinutos) then
    raise EDemasiadosIntentos.Create(lMinutos);

  lSesion := AContext.ServiceContainerResolver.Resolve(
    TypeInfo(ISesionService)) as ISesionService;
  lResultado := lSesion.Autenticar(UserName, Password);
  if lResultado.CuentaInactiva then
    raise EAnovoError.Create('CUENTA_INACTIVA', SCuentaInactiva,
      HTTP_STATUS.Forbidden);
  if not lResultado.Valido then
  begin
    if TIntentosIngreso.RegistrarFallo(UserName, lIp) then
      LogW(Format('Ingreso bloqueado por intentos fallidos desde %s', [lIp]));
    raise EAnovoError.Create('CREDENCIALES_INVALIDAS', SCredencialesInvalidas,
      HTTP_STATUS.Unauthorized);
  end;
  TIntentosIngreso.RegistrarExito(UserName);

  UserRoles.Add(lResultado.Rol);
  SessionData.AddOrSetValue(DATO_USUARIO_ID, lResultado.UsuarioId.ToString);
  SessionData.AddOrSetValue(DATO_NOMBRE, lResultado.Nombre);
  SessionData.AddOrSetValue(DATO_DEBE_CAMBIAR_CLAVE,
    BoolToStr(lResultado.DebeCambiarClave, True));
  IsValid := True;
end;

procedure TAuthentication.OnAuthorization(const AContext: TWebContext;
  UserRoles: TList<string>; const ControllerQualifiedClassName,
  ActionName: string; var IsAuthorized: Boolean);
var
  lTipo: TRttiType;
  lMetodo: TRttiMethod;
begin
  inherited;
  if not IsAuthorized then
    Exit;

  if not TEstadoUsuarios.SesionVigente(AContext, UsuarioDelToken(AContext),
    RolDelToken(UserRoles), AContext.LoggedUser.LoggedSince,
    DebeCambiarClave(AContext), DispositivoDelToken(AContext)) then
    raise EAnovoError.Create('SESION_REVOCADA', SSesionRevocada,
      HTTP_STATUS.Unauthorized);

  if DebeCambiarClave(AContext) and
    not SameText(ControllerQualifiedClassName, CONTROLLER_CUENTA_PROPIA) then
    raise EAnovoError.Create('CAMBIO_CLAVE_PENDIENTE', SCambioClavePendiente,
      HTTP_STATUS.Forbidden);

  lTipo := fRtti.FindType(ControllerQualifiedClassName);
  lMetodo := lTipo.GetMethod(ActionName);
  if not CumplePermisos(AContext, UserRoles, lTipo.GetAttributes) or
    ((lMetodo <> nil) and not CumplePermisos(AContext, UserRoles,
    lMetodo.GetAttributes)) then
    raise EAnovoError.Create('SIN_PERMISO', SSinPermisoOperacion,
      HTTP_STATUS.Forbidden);
end;

end.
