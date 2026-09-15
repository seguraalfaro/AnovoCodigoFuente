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
  Anovo.Controllers.Home,
  Anovo.Auth.RoleHandler,
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
  MVCFramework.OpenAPI3,
  MVCFramework.Middleware.OpenAPI3,
  System.SysUtils;

procedure ConfigureEngine(AEngine: TMVCEngine);
var
  LRateLimitMiddleware: TMVCRateLimitMiddleware;
  LJWTClaimsSetup: TJWTClaimsSetup;
  LOpenAPIInfo: TMVCOpenAPIInfo;
begin

  // Controllers
  AEngine.AddController(TAnovoController);
  // Controllers - END

  // 300 por minuto y por IP. En Anovo todos salen por la misma IP, asi que el
  // cupo es entre todos, no por persona: abrir una pantalla del escritorio
  // dispara varias consultas y con cinco personas a la vez un minuto ajetreado
  // ronda las cien. 300 deja margen y sigue frenando a un cliente en bucle.
  LRateLimitMiddleware := TMVCRateLimitMiddleware.Create(
    300,          // max requests
    60,           // window seconds
    rlkIPAddress
  );
  LRateLimitMiddleware.AddExcludedPath('/health');
  LRateLimitMiddleware.SetOnRateLimitExceeded(
  procedure(const AContext: TWebContext; const AKey: string;
    const ALimit: Integer; const AWindowSeconds: Integer)
  begin
    LogW(Format('Rate limit exceeded for key: %s (Limit: %d requests per %d seconds)',
      [AKey, ALimit, AWindowSeconds]));
  end
  );

  LJWTClaimsSetup := procedure(const JWT: TJWT)
    begin
      JWT.Claims.Issuer := dotEnv.Env('JWT_ISSUER', 'AnovoAPI');
      JWT.Claims.ExpirationTime := Now + OneHour;
      JWT.Claims.NotBefore := Now - OneMinute * 5;
      JWT.Claims.IssuedAt := Now;
      JWT.CustomClaims['app'] := 'AnovoAPI';
    end;

  // Alimenta el documento de /openapi.json. Es el insumo del anexo de
  // documentacion de la API: se arma solo desde los atributos de los
  // controllers, asi que no se desactualiza al cambiar un endpoint.
  LOpenAPIInfo.Title := 'Anovo - API de Cotizaciones';
  LOpenAPIInfo.Version := 'v1';
  LOpenAPIInfo.Description := 'Backend del sistema de cotizaciones de Anovo. ' +
    'Lo consumen la aplicacion de escritorio (VCL) y la aplicacion movil (B4A).';
  LOpenAPIInfo.ContactName := 'Marcos Segura';

  // Middleware
  // El orden de estas lineas es el orden en que corren, y cada uno puede cortar
  // la cadena. Mover uno de sitio no cambia solo cuando corre: cambia que
  // informacion tiene disponible.

  // Primero: un navegador manda un OPTIONS sin token antes de la peticion real.
  // Detras del JWT ese OPTIONS se rechazaria antes de que CORS lo conteste.
  AEngine.AddMiddleware(TMVCCORSMiddleware.Create);

  // Antes del JWT a proposito: rechazar barato sale mas barato que validar un
  // token. Tambien deja el login bajo tope, que es donde hace falta.
  AEngine.AddMiddleware(LRateLimitMiddleware);

  // JWT Bearer auth (Authorization header, for API clients)
  AEngine.AddMiddleware(
    UseJWTMiddleware(
      TAuthentication.Create,
      LJWTClaimsSetup,
      dotEnv.Env('JWT_SECRET'),  // no fallback: a missing key must fail, not sign with a public string
      '/login',   // Login URL (POST username & password here)
      [TJWTCheckableClaim.ExpirationTime, TJWTCheckableClaim.NotBefore, TJWTCheckableClaim.IssuedAt],
      300  // Leeway seconds (5 minutes)
    )
  );

  // Detras del JWT: el documento queda protegido. La descripcion de la API no
  // tiene por que ser publica. El origen de los controllers clasicos lo agrega
  // el propio middleware, no hay que registrarlo.
  AEngine.AddMiddleware(TMVCOpenAPI3Middleware.Create(AEngine, LOpenAPIInfo));

  AEngine.AddMiddleware(TMVCCompressionMiddleware.Create);
  AEngine.AddMiddleware(TMVCETagMiddleware.Create);

  // Ultimo: abre la conexion por peticion, cuanto mas tarde mejor.
  // Aqui detras va a ir el middleware que fija RDB$SET_CONTEXT con el usuario
  // del token: necesita al usuario (del JWT) y la conexion ya abierta.
  AEngine.AddMiddleware(TMVCActiveRecordMiddleware.Create(
    dotEnv.Env('firedac.connection_definition_name', 'AnovoDef'),
    dotEnv.Env('firedac.connection_definitions_filename', TPath.Combine(AppPath, 'FDConnectionDefs.ini'))
  ));
  // Middleware - END

end;

end.
