// ***************************************************************************
//
// Delphi MVC Framework
//
// Copyright (c) 2010-2026 Daniele Teti and the DMVCFramework Team
//
// https://github.com/danieleteti/delphimvcframework
//
// ***************************************************************************

unit EngineConfigU;

interface

uses
  MVCFramework;

procedure ConfigureEngine(AEngine: TMVCEngine);

implementation

uses
  Controllers.HomeU,
  AuthenticationU,
  MVCFramework.JWT,
  MVCFramework.Middleware.JWT,
  System.IOUtils,
  System.DateUtils,
  MVCFramework.Commons,
  MVCFramework.Logger,
  MVCFramework.Middleware.ActiveRecord,
  MVCFramework.Middleware.StaticFiles,
  MVCFramework.Middleware.CORS,
  MVCFramework.Middleware.RateLimit,
  MVCFramework.Middleware.Compression,
  System.SysUtils;

procedure ConfigureEngine(AEngine: TMVCEngine);
var
  LRateLimitMiddleware: TMVCRateLimitMiddleware;
  LJWTClaimsSetup: TJWTClaimsSetup;
  LWwwPath: string;
begin

  // Static files path (www folder at same level as executable)
  LWwwPath := TPath.Combine(AppPath, 'www');

  // Controllers
  AEngine.AddController(TAnovoController);
  // Controllers - END

  LRateLimitMiddleware := TMVCRateLimitMiddleware.Create(
    10,           // max requests
    60,           // window seconds
    rlkIPAddress
  );
  // LRateLimitMiddleware.AddExcludedPath('/health');
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
      JWT.Claims.Issuer := dotEnv.Env('JWT_ISSUER', 'DMVCFrameworkProject1');
      JWT.Claims.ExpirationTime := Now + OneHour;
      JWT.Claims.NotBefore := Now - OneMinute * 5;
      JWT.Claims.IssuedAt := Now;
      // JWT.CustomClaims['app'] := 'DMVCFrameworkProject1';
    end;

  // Middleware
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
  AEngine.AddMiddleware(TMVCStaticFilesMiddleware.Create('/static', LWwwPath));
  AEngine.AddMiddleware(TMVCCompressionMiddleware.Create);
  AEngine.AddMiddleware(TMVCCORSMiddleware.Create);
  AEngine.AddMiddleware(TMVCActiveRecordMiddleware.Create(
    dotEnv.Env('firedac.connection_definition_name', 'AvonoDef'),
    dotEnv.Env('firedac.connection_definitions_filename', TPath.Combine(AppPath, 'FDConnectionDefs.ini'))
  ));
  // Middleware - END

end;

end.
