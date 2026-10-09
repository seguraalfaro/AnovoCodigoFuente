unit Anovo.Config.Engine;

// Configura el motor DMVC: controllers, middlewares, JWT,
// manejador de errores y conexion a la base.

interface

uses
  MVCFramework;

procedure ConfigureEngine(AEngine: TMVCEngine);

implementation

uses

  Anovo.Middleware.Actividad,
  Anovo.Controllers.Auditoria,
  Anovo.Controllers.Catalogos,
  Anovo.Controllers.Solicitudes,
  Anovo.Controllers.Cotizaciones,
  Anovo.Controllers.Dashboard,
  Anovo.Controllers.Reportes,
  Anovo.Controllers.Clientes,
  Anovo.Controllers.Sesion,
  Anovo.Controllers.Version,
  Anovo.Controllers.Roles,
  Anovo.Controllers.Usuarios,
  Anovo.Controllers.Empresa,
  Anovo.Controllers.Correo,
  Anovo.Red,
  Anovo.Middleware.Documentacion,
  Anovo.Middleware.Token,
  Anovo.Auth.RoleHandler,
  Anovo.Errors,
  Anovo.Middleware.ContextoAuditoria,
  MVCFramework.JWT,
  MVCFramework.Middleware.JWT,
  System.IOUtils,
  System.DateUtils,
  MVCFramework.Commons,
  MVCFramework.Logger,
  MVCFramework.Middleware.ActiveRecord,
  MVCFramework.Middleware.CORS,
  MVCFramework.Middleware.ETag,
  MVCFramework.Middleware.RateLimit,
  MVCFramework.Middleware.Compression,
  MVCFramework.Middleware.StaticFiles,
  MVCFramework.Swagger.Commons,
  MVCFramework.Middleware.Swagger,
  MVCFramework.OpenAPI3,
  MVCFramework.Middleware.OpenAPI3,
  System.SysUtils;

procedure ConfigureEngine(AEngine: TMVCEngine);
var
  LRateLimitMiddleware: TMVCRateLimitMiddleware;
  LJWTMiddleware: IMVCMiddleware;
  LOrigenesCORS: string;
  LJWTClaimsSetup: TJWTClaimsSetup;
  LSwaggerInfo: TMVCSwaggerInfo;
  LOpenAPIInfo: TMVCOpenAPIInfo;
begin

  AEngine.AddController(TClientesController);
  AEngine.AddController(TSesionController);
  AEngine.AddController(TAuditoriaController);
  AEngine.AddController(TCatalogosController);
  AEngine.AddController(TSolicitudesController);
  AEngine.AddController(TCotizacionesController);
  AEngine.AddController(TDashboardController);
  AEngine.AddController(TReportesController);
  AEngine.AddController(TVersionController);
  AEngine.AddController(TRolesController);
  AEngine.AddController(TUsuariosController);
  AEngine.AddController(TEmpresaController);
  AEngine.AddController(TCorreoController);

  AEngine.SetExceptionHandler(ManejadorDeErrores());

  LRateLimitMiddleware := TMVCRateLimitMiddleware.Create(300,
    60,
    rlkCustom);
  LRateLimitMiddleware.SetKeyExtractor(IpCliente);
  LRateLimitMiddleware.AddExcludedPath('/health');
  LRateLimitMiddleware.SetOnRateLimitExceeded(
    procedure(const AContext: TWebContext; const AKey: string;
      const ALimit: Integer; const AWindowSeconds: Integer)
    begin
      LogW(Format
        ('Rate limit exceeded for key: %s (Limit: %d requests per %d seconds)',
        [AKey, ALimit, AWindowSeconds]));
    end);

  LJWTClaimsSetup := procedure(const JWT: TJWT)
    begin
      JWT.Claims.Issuer := dotEnv.Env('JWT_ISSUER', 'AnovoAPI');
      JWT.Claims.ExpirationTime := Now + OneHour;
      JWT.Claims.NotBefore := Now - OneMinute * 5;
      JWT.Claims.IssuedAt := Now;
      JWT.CustomClaims['app'] := 'AnovoAPI';
    end;

  LSwaggerInfo.Title := 'Anovo - API de Cotizaciones';
  LSwaggerInfo.Version := 'v1';
  LSwaggerInfo.Description := 'Backend del sistema de cotizaciones de Anovo. ' +
    'Lo consumen la aplicacion de escritorio (VCL) y la aplicacion movil (B4A).';
  LSwaggerInfo.ContactName := 'Marcos Segura';
  LSwaggerInfo.ContactEmail := 'segura.alfaro@gmail.com';

  LOpenAPIInfo.Title := LSwaggerInfo.Title;
  LOpenAPIInfo.Version := LSwaggerInfo.Version;
  LOpenAPIInfo.Description := LSwaggerInfo.Description;
  LOpenAPIInfo.ContactName := LSwaggerInfo.ContactName;
  LOpenAPIInfo.ContactEmail := LSwaggerInfo.ContactEmail;

  LOrigenesCORS := dotEnv.Env('anovo.cors.origenes', '').Trim;
  if not LOrigenesCORS.IsEmpty then
    AEngine.AddMiddleware(TMVCCORSMiddleware.Create(LOrigenesCORS, False,
      TMVCCORSDefaults.EXPOSE_HEADERS, TMVCCORSDefaults.ALLOWS_HEADERS));

  AEngine.AddMiddleware(LRateLimitMiddleware);

  AEngine.AddMiddleware(TMVCActiveRecordMiddleware.Create
    (dotEnv.Env('firedac.connection_definition_name', 'AnovoDef'),
    dotEnv.Env('firedac.connection_definitions_filename', TPath.Combine(AppPath,
    'FDConnectionDefs.ini'))));

  AEngine.AddMiddleware(TDocumentacionMiddleware.Create);

  AEngine.AddMiddleware(TMVCStaticFilesMiddleware.Create('/swagger',
    TPath.Combine(AppPath, 'swaggerui'), 'index.html'));

  AEngine.AddMiddleware(TMVCSwaggerMiddleware.Create(AEngine, LSwaggerInfo,
    '/api/swagger.json',
    'Autenticacion por JSON Web Token (JWT). Escribir la palabra Bearer, un ' +
    'espacio, y el token que devolvio /api/auth/login. Sin el prefijo Bearer ' +
    'el servidor no lee la cabecera y responde 401.', False,
    '',
    '',
    '',
    [psHTTPS]));

  AEngine.AddMiddleware(TMVCOpenAPI3Middleware.Create(AEngine, LOpenAPIInfo,
    '/api/openapi.json'));


  LJWTMiddleware := UseJWTMiddleware(TAuthentication.Create,
    LJWTClaimsSetup, dotEnv.Env('JWT_SECRET'),
    '/api/auth/login',
    [TJWTCheckableClaim.ExpirationTime, TJWTCheckableClaim.NotBefore,
    TJWTCheckableClaim.IssuedAt], 300
    );
  (LJWTMiddleware as TMVCJWTAuthenticationMiddleware)
    .AuthorizationAccessTokenParamName := '';
  AEngine.AddMiddleware(TTokenFormatoMiddleware.Create);
  AEngine.AddMiddleware(LJWTMiddleware);

  AEngine.AddMiddleware(TContextoAuditoriaMiddleware.Create);
  AEngine.AddMiddleware(TActividadMiddleware.Create);
  AEngine.AddMiddleware(TMVCCompressionMiddleware.Create);
  AEngine.AddMiddleware(TMVCETagMiddleware.Create);
end;

end.
