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
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  MVCFramework.SQLGenerators.Firebird,
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
  Anovo.Config.Servicios in 'src\Bootstrap\Anovo.Config.Servicios.pas',
  Anovo.Auth.RoleHandler in 'src\Auth\Anovo.Auth.RoleHandler.pas',
  Anovo.Bootstrap in 'src\Bootstrap\Anovo.Bootstrap.pas',
  Anovo.Config.Engine in 'src\Bootstrap\Anovo.Config.Engine.pas',
  Anovo.Services.Clave in 'src\Services\Anovo.Services.Clave.pas',
  Anovo.Middleware.ContextoAuditoria in 'src\Middleware\Anovo.Middleware.ContextoAuditoria.pas',
  Anovo.Auditoria.Contexto in 'src\Common\Anovo.Auditoria.Contexto.pas',
  Anovo.DTOs.Clientes in 'src\DTOs\Anovo.DTOs.Clientes.pas',
  Anovo.Entities.Auditoria in 'src\Entities\Anovo.Entities.Auditoria.pas',
  Anovo.Entities.Catalogos in 'src\Entities\Anovo.Entities.Catalogos.pas',
  Anovo.Entities.Clientes in 'src\Entities\Anovo.Entities.Clientes.pas',
  Anovo.Entities.Cotizaciones in 'src\Entities\Anovo.Entities.Cotizaciones.pas',
  Anovo.Entities.Empresa in 'src\Entities\Anovo.Entities.Empresa.pas',
  Anovo.Entities.Solicitudes in 'src\Entities\Anovo.Entities.Solicitudes.pas',
  Anovo.Entities.Usuarios in 'src\Entities\Anovo.Entities.Usuarios.pas',
  Anovo.Errors in 'src\Common\Anovo.Errors.pas',
  Anovo.Repositories.Intf.Clientes in 'src\Interfaces\Anovo.Repositories.Intf.Clientes.pas',
  Anovo.Repositories.Clientes in 'src\Repositories\Anovo.Repositories.Clientes.pas',
  Anovo.SQL.Clientes in 'src\SQL\Anovo.SQL.Clientes.pas',
  Anovo.Services.Clientes in 'src\Services\Anovo.Services.Clientes.pas',
  Anovo.Services.Intf.Clientes in 'src\Interfaces\Anovo.Services.Intf.Clientes.pas',
  Anovo.Controllers.Clientes in 'src\Controllers\Anovo.Controllers.Clientes.pas',
  Anovo.Entities.Permisos in 'src\Entities\Anovo.Entities.Permisos.pas',
  Anovo.SQL.Permisos in 'src\SQL\Anovo.SQL.Permisos.pas',
  Anovo.Repositories.Intf.Permisos in 'src\Interfaces\Anovo.Repositories.Intf.Permisos.pas',
  Anovo.Repositories.Permisos in 'src\Repositories\Anovo.Repositories.Permisos.pas',
  Anovo.Services.Intf.Permisos in 'src\Interfaces\Anovo.Services.Intf.Permisos.pas',
  Anovo.Services.Permisos in 'src\Services\Anovo.Services.Permisos.pas',
  Anovo.Auth.Permisos in 'src\Auth\Anovo.Auth.Permisos.pas',
  Anovo.DTOs.Sesion in 'src\DTOs\Anovo.DTOs.Sesion.pas',
  Anovo.Controllers.Sesion in 'src\Controllers\Anovo.Controllers.Sesion.pas',
  Anovo.Mapeo in 'src\Common\Anovo.Mapeo.pas',
  Anovo.Repositories.Base in 'src\Repositories\Anovo.Repositories.Base.pas',
  Anovo.Repositories.Auditoria in 'src\Repositories\Anovo.Repositories.Auditoria.pas',
  Anovo.Repositories.Intf.Auditoria in 'src\Interfaces\Anovo.Repositories.Intf.Auditoria.pas',
  Anovo.SQL.Auditoria in 'src\SQL\Anovo.SQL.Auditoria.pas',
  Anovo.DTOs.Auditoria in 'src\DTOs\Anovo.DTOs.Auditoria.pas',
  Anovo.Services.Intf.Auditoria in 'src\Interfaces\Anovo.Services.Intf.Auditoria.pas',
  Anovo.Services.Auditoria in 'src\Services\Anovo.Services.Auditoria.pas',
  Anovo.Controllers.Auditoria in 'src\Controllers\Anovo.Controllers.Auditoria.pas',
  Anovo.SQL.Usuarios in 'src\SQL\Anovo.SQL.Usuarios.pas',
  Anovo.Repositories.Intf.Usuarios in 'src\Interfaces\Anovo.Repositories.Intf.Usuarios.pas',
  Anovo.Repositories.Usuarios in 'src\Repositories\Anovo.Repositories.Usuarios.pas';

{$R *.res}

procedure RunServer(aPort: Integer);
var
  LEngine: TMVCEngine;
  LServer: IMVCServer;
begin
  LEngine := TMVCEngine.Create(
    procedure(Config: TMVCConfig)
    begin
      // default content-type
      Config[TMVCConfigKey.DefaultContentType] :=
        DotEnv.Env('dmvc.default.content_type',
        TMVCConstants.DEFAULT_CONTENT_TYPE);
      // default content charset
      Config[TMVCConfigKey.DefaultContentCharset] :=
        DotEnv.Env('dmvc.default.content_charset',
        TMVCConstants.DEFAULT_CONTENT_CHARSET);
      // unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] :=
        DotEnv.Env('dmvc.allow_unhandled_actions', 'false');
      // enables or not system controllers loading (available only from localhost requests)
      Config[TMVCConfigKey.LoadSystemControllers] :=
        DotEnv.Env('dmvc.load_system_controllers', 'true');
      // default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] :=
        DotEnv.Env('dmvc.default.view_file_extension', 'html');
      // view path
      Config[TMVCConfigKey.ViewPath] := DotEnv.Env('dmvc.view_path',
        TPath.Combine(AppPath, 'templates'));
      // Max Record Count for automatic Entities CRUD
      Config[TMVCConfigKey.MaxEntitiesRecordCount] :=
        DotEnv.Env('dmvc.max_entities_record_count',
        IntToStr(TMVCConstants.MAX_RECORD_COUNT));
      // Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] :=
        DotEnv.Env('dmvc.expose_server_signature', 'false');
      // Enable X-Powered-By Header in response
      Config[TMVCConfigKey.ExposeXPoweredBy] :=
        DotEnv.Env('dmvc.expose_x_powered_by', 'false');
      // Max request size in bytes
      Config[TMVCConfigKey.MaxRequestSize] :=
        DotEnv.Env('dmvc.max_request_size',
        IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE));
    end);
  try
    ConfigureEngine(LEngine);
    LServer := TMVCServerFactory.CreateIndyDirect(LEngine);
    // TaurusTLS (OpenSSL 1.1.1+). Replace MVCFramework.Server.HTTPS.TaurusTLS to switch TLS stack.
    LServer.HTTPSConfigurator := TaurusTLSIndyConfigurator();
    LServer.UseHTTPS := True;
    LServer.CertFile := DotEnv.Env('https.cert.cacert',
      'certificates\localhost.crt');
    LServer.KeyFile := DotEnv.Env('https.cert.privkey',
      'certificates\localhost.key');
    LServer.CertPassword := DotEnv.Env('https.cert.password', '');
    LogI('Starting on https://localhost:' + aPort.ToString +
      ' (Indy Direct + TaurusTLS). Press Ctrl+C to shut down.');
    // RunAndWait: Listen + signal wait + shutdown. For non-console hosts use Listen() + Stop().
    LServer.RunAndWait(aPort);
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

    RunServer(DotEnv.Env('dmvc.server.port', 443));
  except
    on E: Exception do
      LogF(E.ClassName + ': ' + E.Message);
  end;

end.
