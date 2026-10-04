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
    function TieneAlguno(const APermisos: IPermisoService;
      const AUsuarioId: Integer; UserRoles: TList<string>;
      const ACodigos: TArray<string>): Boolean;
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
  Anovo.Auth.Permisos,
  Anovo.Services.Intf.Sesion;

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

function UsuarioDe(const AContext: TWebContext): Integer;
var
  lTexto: string;
begin
  lTexto := '';
  if Assigned(AContext.LoggedUser.CustomData) then
    AContext.LoggedUser.CustomData.TryGetValue('USUARIO_ID', lTexto);
  if not TryStrToInt(lTexto, Result) then
    Result := 0;
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
      if not TieneAlguno(lPermisos, UsuarioDe(AContext), UserRoles,
        MVCRequiresPermisoAttribute(lAtributo).GetPermisos) then
        Exit(False);
    end;
end;

function TAuthentication.TieneAlguno(const APermisos: IPermisoService;
  const AUsuarioId: Integer; UserRoles: TList<string>;
  const ACodigos: TArray<string>): Boolean;
var
  lRol, lCodigo: string;
begin
  for lRol in UserRoles do
    for lCodigo in ACodigos do
      if APermisos.Tiene(AUsuarioId, lRol, lCodigo) then
        Exit(True);
  Result := False;
end;

procedure TAuthentication.OnAuthentication(const AContext: TWebContext;
  const UserName: string; const Password: string; UserRoles: TList<string>;
  var IsValid: Boolean; const SessionData: TDictionary<string, string>);
var
  lSesion: ISesionService;
  lResultado: TAutenticacion;
begin
  IsValid := False;
  UserRoles.Clear;

  lSesion := AContext.ServiceContainerResolver.Resolve(
    TypeInfo(ISesionService)) as ISesionService;
  lResultado := lSesion.Autenticar(UserName, Password);
  if not lResultado.Valido then
    Exit;

  UserRoles.Add(lResultado.Rol);
  SessionData.AddOrSetValue('USUARIO_ID', lResultado.UsuarioId.ToString);
  SessionData.AddOrSetValue('NOMBRE', lResultado.Nombre);
  SessionData.AddOrSetValue('DEBE_CAMBIAR_CLAVE',
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

  lTipo := fRtti.FindType(ControllerQualifiedClassName);
  if not CumplePermisos(AContext, UserRoles, lTipo.GetAttributes) then
  begin
    IsAuthorized := False;
    Exit;
  end;

  lMetodo := lTipo.GetMethod(ActionName);
  if (lMetodo <> nil) and not CumplePermisos(AContext, UserRoles,
    lMetodo.GetAttributes) then
    IsAuthorized := False;
end;

end.
