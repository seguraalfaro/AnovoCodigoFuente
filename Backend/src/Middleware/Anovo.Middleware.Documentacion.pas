unit Anovo.Middleware.Documentacion;

// Protege Swagger y OpenAPI: sin la cookie de acceso de TI, la pagina lleva al
// formulario de ingreso y los .json responden 401. La API no usa esta cookie.

interface

uses
  MVCFramework;

type
  TDocumentacionMiddleware = class(TInterfacedObject, IMVCMiddleware)
  private
    procedure Responder(const AContext: TWebContext; const AEstado: Integer;
      const ATipo, AContenido: string);
    procedure Redirigir(const AContext: TWebContext; const ARuta: string);
    procedure MostrarAcceso(const AContext: TWebContext;
      const AMensaje: string);
    procedure Acceder(const AContext: TWebContext);
    procedure Salir(const AContext: TWebContext);
    function CookieValida(const AContext: TWebContext): Boolean;
  public
    procedure OnBeforeRouting(AContext: TWebContext; var AHandled: Boolean);
    procedure OnBeforeControllerAction(AContext: TWebContext;
      const AControllerQualifiedClassName: string; const AActionName: string;
      var AHandled: Boolean);
    procedure OnAfterControllerAction(AContext: TWebContext;
      const AControllerQualifiedClassName: string; const AActionName: string;
      const AHandled: Boolean);
    procedure OnAfterRouting(AContext: TWebContext; const AHandled: Boolean);
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.NetEncoding,
  MVCFramework.Commons,
  MVCFramework.JWT,
  MVCFramework.Logger,
  Anovo.Auth.Intentos,
  Anovo.Permisos,
  Anovo.Red,
  Anovo.Services.Intf.Permisos,
  Anovo.Services.Intf.Sesion,
  Anovo.Textos;

const
  RUTA_ACCESO = '/docs/acceso';
  RUTA_SALIR = '/docs/salir';
  RUTA_SWAGGER = '/swagger';
  RUTA_INICIO_SWAGGER = '/swagger/';
  RUTAS_JSON: array [0 .. 1] of string = ('/api/swagger.json',
    '/api/openapi.json');
  NOMBRE_COOKIE = 'anovo_docs';
  APLICACION_DOCS = 'AnovoDocs';
  MINUTOS_VIGENCIA = 30;
  TIPO_HTML = 'text/html; charset=utf-8';
  TIPO_JSON = 'application/json; charset=utf-8';
  CAMPO_CORREO = 'correo';
  CAMPO_CLAVE = 'clave';
  ESTADO_REDIRECCION = 303;

  PAGINA_ACCESO =
    '<!doctype html><html lang="es"><head><meta charset="utf-8">' +
    '<meta name="viewport" content="width=device-width, initial-scale=1">' +
    '<title>%s</title><style>' +
    'body{font-family:Segoe UI,Arial,sans-serif;background:#f5f6f8;margin:0;' +
    'display:flex;align-items:center;justify-content:center;min-height:100vh}' +
    'form{background:#fff;border:1px solid #dde1e6;border-radius:10px;' +
    'padding:28px 32px;width:320px}h1{font-size:20px;margin:0 0 4px}' +
    'p{color:#5c6470;font-size:13px;margin:0 0 18px}' +
    'label{display:block;font-size:13px;margin:12px 0 4px}' +
    'input{width:100%%;box-sizing:border-box;padding:8px;border:1px solid #c7ccd3;' +
    'border-radius:6px;font-size:14px}button{margin-top:20px;width:100%%;' +
    'padding:10px;border:0;border-radius:6px;background:#1f4e8c;color:#fff;' +
    'font-size:14px;cursor:pointer}.error{color:#b42318;font-size:13px;' +
    'margin-top:14px}</style></head><body>' +
    '<form method="post" action="' + RUTA_ACCESO + '" autocomplete="off">' +
    '<h1>%s</h1><p>%s</p>' +
    '<label for="correo">%s</label>' +
    '<input id="correo" name="correo" type="email" required autofocus>' +
    '<label for="clave">%s</label>' +
    '<input id="clave" name="clave" type="password" required>' +
    '<button type="submit">%s</button>%s</form></body></html>';

function Habilitada: Boolean;
begin
  Result := dotEnv.Env('anovo.swagger.habilitado', True);
end;

function EsJson(const ARuta: string): Boolean;
var
  lRuta: string;
begin
  for lRuta in RUTAS_JSON do
    if SameText(ARuta, lRuta) then
      Exit(True);
  Result := False;
end;

function EsPagina(const ARuta: string): Boolean;
begin
  Result := SameText(ARuta, RUTA_SWAGGER) or
    ARuta.ToLower.StartsWith(RUTA_INICIO_SWAGGER);
end;

function Html(const ATexto: string): string;
begin
  Result := TNetEncoding.HTML.Encode(ATexto);
end;

procedure TDocumentacionMiddleware.Responder(const AContext: TWebContext;
  const AEstado: Integer; const ATipo, AContenido: string);
begin
  AContext.Response.StatusCode := AEstado;
  AContext.Response.ContentType := ATipo;
  AContext.Response.SetCustomHeader('Cache-Control', 'no-store');
  AContext.Response.Content := AContenido;
end;

procedure TDocumentacionMiddleware.Redirigir(const AContext: TWebContext;
  const ARuta: string);
begin
  AContext.Response.StatusCode := ESTADO_REDIRECCION;
  AContext.Response.SetCustomHeader('Location', ARuta);
  AContext.Response.Content := '';
end;

procedure TDocumentacionMiddleware.MostrarAcceso(const AContext: TWebContext;
  const AMensaje: string);
var
  lError: string;
begin
  lError := '';
  if not AMensaje.IsEmpty then
    lError := '<div class="error">' + Html(AMensaje) + '</div>';
  Responder(AContext, HTTP_STATUS.OK, TIPO_HTML, Format(PAGINA_ACCESO,
    [Html(SDocsTitulo), Html(SDocsTitulo), Html(SDocsSubtitulo),
    Html(SDocsCorreo), Html(SDocsClave), Html(SDocsEntrar), lError]));
end;

function TDocumentacionMiddleware.CookieValida(const AContext
  : TWebContext): Boolean;
var
  lToken, lError: string;
  lJwt: TJWT;
begin
  lToken := AContext.Request.Cookie(NOMBRE_COOKIE).Trim;
  if lToken.IsEmpty then
    Exit(False);
  lJwt := TJWT.Create(dotEnv.Env('JWT_SECRET'), 0);
  try
    lJwt.RegClaimsToChecks := [TJWTCheckableClaim.ExpirationTime,
      TJWTCheckableClaim.NotBefore, TJWTCheckableClaim.IssuedAt];
    try
      Result := lJwt.LoadToken(lToken, lError) and
        (lJwt.CustomClaims['app'] = APLICACION_DOCS);
    except
      Result := False;
    end;
  finally
    lJwt.Free;
  end;
end;

procedure TDocumentacionMiddleware.Acceder(const AContext: TWebContext);
var
  lCorreo, lClave, lIp: string;
  lMinutos: Integer;
  lSesion: ISesionService;
  lPermisos: IPermisoService;
  lResultado: TAutenticacion;
  lJwt: TJWT;
begin
  lCorreo := AContext.Request.ContentParam(CAMPO_CORREO).Trim;
  lClave := AContext.Request.ContentParam(CAMPO_CLAVE);
  lIp := IpCliente(AContext);

  if TIntentosIngreso.Bloqueado(lCorreo, lIp, lMinutos) then
  begin
    MostrarAcceso(AContext, Format(SIngresoBloqueado, [lMinutos]));
    Exit;
  end;

  lSesion := AContext.ServiceContainerResolver.Resolve(
    TypeInfo(ISesionService)) as ISesionService;
  lResultado := lSesion.Autenticar(lCorreo, lClave);
  if not lResultado.Valido then
  begin
    if TIntentosIngreso.RegistrarFallo(lCorreo, lIp) then
      LogW(Format('Acceso a la documentacion bloqueado desde %s', [lIp]));
    MostrarAcceso(AContext, SDocsInvalido);
    Exit;
  end;
  TIntentosIngreso.RegistrarExito(lCorreo);

  lPermisos := AContext.ServiceContainerResolver.Resolve(
    TypeInfo(IPermisoService)) as IPermisoService;
  if not lPermisos.TieneAlguno(lResultado.UsuarioId, [lResultado.Rol],
    [PERMISO_USUARIOS_ADMINISTRAR]) then
  begin
    LogW(Format('Acceso a la documentacion sin permiso: usuario %d',
      [lResultado.UsuarioId]));
    MostrarAcceso(AContext, SDocsSinPermiso);
    Exit;
  end;

  lJwt := TJWT.Create(dotEnv.Env('JWT_SECRET'), 0);
  try
    lJwt.Claims.Issuer := dotEnv.Env('JWT_ISSUER', 'AnovoAPI');
    lJwt.Claims.Subject := lResultado.UsuarioId.ToString;
    lJwt.Claims.IssuedAt := Now;
    lJwt.Claims.NotBefore := IncMinute(Now, -1);
    lJwt.Claims.ExpirationTime := IncMinute(Now, MINUTOS_VIGENCIA);
    lJwt.CustomClaims['app'] := APLICACION_DOCS;
    AContext.Response.SetCustomHeader('Set-Cookie', Format(
      '%s=%s; Path=/; Max-Age=%d; HttpOnly; Secure; SameSite=Strict',
      [NOMBRE_COOKIE, lJwt.GetToken, MINUTOS_VIGENCIA * 60]));
  finally
    lJwt.Free;
  end;
  LogI(Format('Acceso a la documentacion: usuario %d desde %s',
    [lResultado.UsuarioId, lIp]));
  Redirigir(AContext, RUTA_INICIO_SWAGGER);
end;

procedure TDocumentacionMiddleware.Salir(const AContext: TWebContext);
begin
  AContext.Response.SetCustomHeader('Set-Cookie', NOMBRE_COOKIE +
    '=; Path=/; Max-Age=0; HttpOnly; Secure; SameSite=Strict');
  Redirigir(AContext, RUTA_ACCESO);
end;

procedure TDocumentacionMiddleware.OnBeforeRouting(AContext: TWebContext;
  var AHandled: Boolean);
var
  lRuta: string;
begin
  lRuta := AContext.Request.PathInfo;
  if SameText(lRuta, RUTA_ACCESO) or SameText(lRuta, RUTA_SALIR) or
    EsPagina(lRuta) or EsJson(lRuta) then
  begin
    if not Habilitada then
    begin
      Responder(AContext, HTTP_STATUS.NotFound, TIPO_JSON, '{}');
      AHandled := True;
      Exit;
    end;
  end
  else
    Exit;

  if SameText(lRuta, RUTA_ACCESO) then
  begin
    if AContext.Request.HTTPMethod = httpPOST then
      Acceder(AContext)
    else
      MostrarAcceso(AContext, '');
    AHandled := True;
    Exit;
  end;

  if SameText(lRuta, RUTA_SALIR) then
  begin
    Salir(AContext);
    AHandled := True;
    Exit;
  end;

  if CookieValida(AContext) then
    Exit;

  if EsPagina(lRuta) then
    Redirigir(AContext, RUTA_ACCESO)
  else
    Responder(AContext, HTTP_STATUS.Unauthorized, TIPO_JSON,
      '{"error":{"codigo":"DOCUMENTACION_SIN_ACCESO","mensaje":"' +
      SDocsSinAcceso + '","detalles":[]}}');
  AHandled := True;
end;

procedure TDocumentacionMiddleware.OnBeforeControllerAction(
  AContext: TWebContext; const AControllerQualifiedClassName: string;
  const AActionName: string; var AHandled: Boolean);
begin
end;

procedure TDocumentacionMiddleware.OnAfterControllerAction(
  AContext: TWebContext; const AControllerQualifiedClassName: string;
  const AActionName: string; const AHandled: Boolean);
begin
end;

procedure TDocumentacionMiddleware.OnAfterRouting(AContext: TWebContext;
  const AHandled: Boolean);
begin
end;

end.
