// ***************************************************************************
//
// Delphi MVC Framework
//
// Copyright (c) 2010-2026 Daniele Teti and the DMVCFramework Team
//
// https://github.com/danieleteti/delphimvcframework
//
// ***************************************************************************

program AnovoAPI;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  MVCFramework,
  MVCFramework.Logger,
  MVCFramework.DotEnv,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  MVCFramework.Signal,
  MVCFramework.Server.Intf,
  MVCFramework.Server.Factory,
  MVCFramework.Server.HTTPS.TaurusTLS,
  MVCFramework.Container,
  Anovo.Controllers.Home in 'src\Controllers\Anovo.Controllers.Home.pas',
  Anovo.Config.Servicios in 'src\Bootstrap\Anovo.Config.Servicios.pas',
  Anovo.Auth.RoleHandler in 'src\Auth\Anovo.Auth.RoleHandler.pas',
  Anovo.Bootstrap in 'src\Bootstrap\Anovo.Bootstrap.pas',
  Anovo.Config.Engine in 'src\Bootstrap\Anovo.Config.Engine.pas';

{$R *.res}

procedure RunServer(aPort: Integer);
var
  LEngine: TMVCEngine;
  LServer: IMVCServer;
begin
  LEngine := TMVCEngine.Create(
    procedure(Config: TMVCConfig)
    begin
      //default content-type
      Config[TMVCConfigKey.DefaultContentType] := dotEnv.Env('dmvc.default.content_type', TMVCConstants.DEFAULT_CONTENT_TYPE);
      //default content charset
      Config[TMVCConfigKey.DefaultContentCharset] := dotEnv.Env('dmvc.default.content_charset', TMVCConstants.DEFAULT_CONTENT_CHARSET);
      //unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := dotEnv.Env('dmvc.allow_unhandled_actions', 'false');
      //enables or not system controllers loading (available only from localhost requests)
      Config[TMVCConfigKey.LoadSystemControllers] := dotEnv.Env('dmvc.load_system_controllers', 'true');
      //default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := dotEnv.Env('dmvc.default.view_file_extension', 'html');
      //view path
      Config[TMVCConfigKey.ViewPath] := dotEnv.Env('dmvc.view_path', TPath.Combine(AppPath, 'templates'));
      //Max Record Count for automatic Entities CRUD
      Config[TMVCConfigKey.MaxEntitiesRecordCount] := dotEnv.Env('dmvc.max_entities_record_count', IntToStr(TMVCConstants.MAX_RECORD_COUNT));
      //Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := dotEnv.Env('dmvc.expose_server_signature', 'false');
      //Enable X-Powered-By Header in response
      Config[TMVCConfigKey.ExposeXPoweredBy] := dotEnv.Env('dmvc.expose_x_powered_by', 'false');
      // Max request size in bytes
      Config[TMVCConfigKey.MaxRequestSize] := dotEnv.Env('dmvc.max_request_size', IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE));
    end);
  try
    ConfigureEngine(LEngine);
    LServer := TMVCServerFactory.CreateIndyDirect(LEngine);
    // TaurusTLS (OpenSSL 1.1.1+). Replace MVCFramework.Server.HTTPS.TaurusTLS to switch TLS stack.
    LServer.HTTPSConfigurator := TaurusTLSIndyConfigurator();
    LServer.UseHTTPS := True;
    LServer.CertFile := dotEnv.Env('https.cert.cacert', 'certificates\localhost.crt');
    LServer.KeyFile := dotEnv.Env('https.cert.privkey', 'certificates\localhost.key');
    LServer.CertPassword := dotEnv.Env('https.cert.password', '');
    LogI('Starting on https://localhost:' + APort.ToString +
      ' (Indy Direct + TaurusTLS). Press Ctrl+C to shut down.');
    // RunAndWait: Listen + signal wait + shutdown. For non-console hosts use Listen() + Stop().
    LServer.RunAndWait(APort);
    LServer := nil;
  finally
    LEngine.Free;
  end;
end;

begin
  { Enable ReportMemoryLeaksOnShutdown during debug }
  // ReportMemoryLeaksOnShutdown := True;
  IsMultiThread := True;

  MVCSerializeNulls := True;
  Boot; // dotEnv + logger + profiler; must run before any LogI call

  LogI('** DMVCFramework Server ** build ' + DMVCFRAMEWORK_VERSION);

  try

    RegisterServices(DefaultMVCServiceContainer);
    DefaultMVCServiceContainer.Build;

    RunServer(dotEnv.Env('dmvc.server.port', 443));
  except
    on E: Exception do
      LogF(E.ClassName + ': ' + E.Message);
  end;
end.
