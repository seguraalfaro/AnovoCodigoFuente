unit Anovo.Servidor;

// Servidor HTTPS: arma el motor, el certificado y el puerto.

interface

uses
  MVCFramework.Server.Intf;

function PuertoConfigurado: Integer;

function BaseConfigurada: string;
function UsuarioDeBase: string;

procedure PrepararServicios;

function CrearServidor: IMVCServer;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Server.Factory,
  MVCFramework.Server.HTTPS.TaurusTLS,
  MVCFramework.DotEnv,
  MVCFramework.Container,
  Anovo.Config.Engine,
  Anovo.Config.Servicios,
  Anovo.Auth.Token,
  Anovo.Textos;

var
  gServiciosListos: Boolean = False;

function PuertoConfigurado: Integer;
begin
  Result := dotEnv.Env('dmvc.server.port', 443);
end;

function BaseConfigurada: string;
begin
  Result := dotEnv.Env('firebird.database', SSinDefinirEnv);
end;

function UsuarioDeBase: string;
begin
  Result := dotEnv.Env('firebird.user', SSinDefinirEnv);
end;

procedure PrepararServicios;
begin
  if gServiciosListos then
    Exit;
  RegisterServices(DefaultMVCServiceContainer);
  DefaultMVCServiceContainer.Build;
  gServiciosListos := True;
end;

function CrearServidor: IMVCServer;
var
  lEngine: TMVCEngine;
begin
  SecretoJWT;
  lEngine := TMVCEngine.Create(
    procedure(Config: TMVCConfig)
    begin
      Config[TMVCConfigKey.DefaultContentType] :=
        dotEnv.Env('dmvc.default.content_type',
        TMVCConstants.DEFAULT_CONTENT_TYPE);
      Config[TMVCConfigKey.DefaultContentCharset] :=
        dotEnv.Env('dmvc.default.content_charset',
        TMVCConstants.DEFAULT_CONTENT_CHARSET);
      Config[TMVCConfigKey.AllowUnhandledAction] :=
        dotEnv.Env('dmvc.allow_unhandled_actions', 'false');
      Config[TMVCConfigKey.LoadSystemControllers] :=
        dotEnv.Env('dmvc.load_system_controllers', 'false');
      Config[TMVCConfigKey.DefaultViewFileExtension] :=
        dotEnv.Env('dmvc.default.view_file_extension', 'html');
      Config[TMVCConfigKey.ViewPath] := dotEnv.Env('dmvc.view_path',
        TPath.Combine(AppPath, 'templates'));
      Config[TMVCConfigKey.MaxEntitiesRecordCount] :=
        dotEnv.Env('dmvc.max_entities_record_count',
        IntToStr(TMVCConstants.MAX_RECORD_COUNT));
      Config[TMVCConfigKey.ExposeServerSignature] :=
        dotEnv.Env('dmvc.expose_server_signature', 'false');
      Config[TMVCConfigKey.ExposeXPoweredBy] :=
        dotEnv.Env('dmvc.expose_x_powered_by', 'false');
      Config[TMVCConfigKey.MaxRequestSize] :=
        dotEnv.Env('dmvc.max_request_size',
        IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE));
    end);

  try
    ConfigureEngine(lEngine);
    Result := TMVCServerFactory.CreateIndyDirect(lEngine);
    Result.HTTPSConfigurator := TaurusTLSIndyConfigurator();
    Result.UseHTTPS := True;
    Result.CertFile := dotEnv.Env('https.cert.cacert',
      'certificates\localhost.crt');
    Result.KeyFile := dotEnv.Env('https.cert.privkey',
      'certificates\localhost.key');
    Result.CertPassword := dotEnv.Env('https.cert.password', '');
  except
    lEngine.Free;
    raise;
  end;
end;

end.
