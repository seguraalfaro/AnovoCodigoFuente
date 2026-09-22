// ***************************************************************************
//
// Delphi MVC Framework
//
// Copyright (c) 2010-2026 Daniele Teti and the DMVCFramework Team
//
// https://github.com/danieleteti/delphimvcframework
//
// ***************************************************************************

unit Anovo.Config.Engine;

interface

uses
  MVCFramework;

procedure ConfigureEngine(AEngine: TMVCEngine);

implementation

uses
  Anovo.Controllers.Auditoria,
  Anovo.Controllers.Clientes,
  Anovo.Controllers.Sesion,
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
  LJWTClaimsSetup: TJWTClaimsSetup;
  LSwaggerInfo: TMVCSwaggerInfo;
  LOpenAPIInfo: TMVCOpenAPIInfo;
begin
  // Controllers

  AEngine.AddController(TClientesController);
  AEngine.AddController(TSesionController);
  AEngine.AddController(TAuditoriaController);
  // Controllers - END

  AEngine.SetExceptionHandler(ManejadorDeErrores());

  // 300 por minuto y por IP. En Anovo todos salen por la misma IP, asi que el
  // cupo es entre todos, no por persona: abrir una pantalla del escritorio
  // dispara varias consultas y con cinco personas a la vez un minuto ajetreado
  // ronda las cien. 300 deja margen y sigue frenando a un cliente en bucle.
  LRateLimitMiddleware := TMVCRateLimitMiddleware.Create(300, // max requests
    60, // window seconds
    rlkIPAddress);
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

  // Los dos emisores leen los mismos controllers por RTTI, asi que no hay que
  // escribir la documentacion a mano ni mantenerla al dia: se arma de los
  // atributos de cada accion.
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

  // Primero: un navegador manda un OPTIONS sin token antes de la peticion real.
  // Detras del JWT ese OPTIONS se rechazaria antes de que CORS lo conteste.
  AEngine.AddMiddleware(TMVCCORSMiddleware.Create
    (TMVCCORSDefaults.ALLOWS_ORIGIN_URL, TMVCCORSDefaults.ALLOWS_CREDENTIALS,
    TMVCCORSDefaults.EXPOSE_HEADERS, TMVCCORSDefaults.ALLOWS_HEADERS));

  // Antes del JWT a proposito: rechazar barato sale mas barato que validar un
  // token. Tambien deja el login bajo tope, que es donde hace falta.
  AEngine.AddMiddleware(LRateLimitMiddleware);

  // Swagger UI son archivos estaticos, no un middleware: la pagina que
  // renderiza el documento y deja probar cada endpoint. Vive en bin\swaggerui,
  // que git ignora por estar bajo bin\.
  AEngine.AddMiddleware(TMVCStaticFilesMiddleware.Create('/swagger',
    TPath.Combine(AppPath, 'swaggerui'), 'index.html'));

  // Swagger 2.0, el que la pagina apunta por defecto .
  AEngine.AddMiddleware(TMVCSwaggerMiddleware.Create(AEngine, LSwaggerInfo,
    '/api/swagger.json',
    'Autenticacion por JSON Web Token (JWT). Escribir la palabra Bearer, un ' +
    'espacio, y el token que devolvio /api/auth/login. Sin el prefijo Bearer ' +
    'el servidor no lee la cabecera y responde 401.', False,
    // AEnableBasicAuthentication
    '', // AHost: vacio = el del navegador
    '', // ABasePath
    '', // APathFilter
    [psHTTPS])); // solo HTTPS: el servidor no escucha en claro

  // OpenAPI 3.1 sobre los mismos controllers. Es el estandar vigente y el que
  // se cita en el informe; el 2.0 de arriba esta solo para la pagina.
  AEngine.AddMiddleware(TMVCOpenAPI3Middleware.Create(AEngine, LOpenAPIInfo,
    '/api/openapi.json'));

  // Antes del JWT: el login consulta USUARIOS, y sin conexion abierta falla.
  AEngine.AddMiddleware(TMVCActiveRecordMiddleware.Create
    (dotEnv.Env('firedac.connection_definition_name', 'AnovoDef'),
    dotEnv.Env('firedac.connection_definitions_filename', TPath.Combine(AppPath,
    'FDConnectionDefs.ini'))));

  // JWT Bearer auth (Authorization header, for API clients)
  AEngine.AddMiddleware(UseJWTMiddleware(TAuthentication.Create,
    LJWTClaimsSetup, dotEnv.Env('JWT_SECRET'),
    // no fallback: a missing key must fail, not sign with a public string
    '/api/auth/login', // Login URL (POST username & password here)
    [TJWTCheckableClaim.ExpirationTime, TJWTCheckableClaim.NotBefore,
    TJWTCheckableClaim.IssuedAt], 300 // Leeway seconds (5 minutes)
    ));

  // Despues del JWT y del de ActiveRecord porque necesita las dos cosas
  AEngine.AddMiddleware(TContextoAuditoriaMiddleware.Create);
  AEngine.AddMiddleware(TMVCCompressionMiddleware.Create);
  AEngine.AddMiddleware(TMVCETagMiddleware.Create);
  // Middleware - END
end;

end.
