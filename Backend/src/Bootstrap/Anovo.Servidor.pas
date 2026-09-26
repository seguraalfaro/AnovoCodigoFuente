unit Anovo.Servidor;

// El servidor HTTPS, armado en un solo sitio.
//
// Estaba dentro del .dpr, que servia mientras el programa era una consola.
// Ahora lo arrancan dos cosas -la ventana del servidor y, si algun dia hace
// falta, un servicio de Windows- y ninguna de las dos deberia repetir la
// configuracion del motor ni la del certificado.
//
// CrearServidor no escucha: devuelve el servidor listo y quien lo recibe
// decide cuando. La consola usaba RunAndWait, que bloquea el hilo hasta
// Ctrl+C; una ventana no puede hacer eso, asi que usa Listen y Stop.
//
// El motor lo libera el servidor al soltarse la interfaz.

interface

uses
  MVCFramework.Server.Intf;

// Puerto del .env, 443 si no esta.
function PuertoConfigurado: Integer;

// Ruta del .fdb y usuario con el que se conecta, para mostrarlos. No abre
// nada: solo lee la configuracion.
function BaseConfigurada: string;
function UsuarioDeBase: string;

// Registra los servicios y arma el contenedor. Una sola vez por proceso: el
// Build del contenedor no admite repeticion.
procedure PrepararServicios;

// El servidor con el motor ya configurado y HTTPS puesto. Todavia no escucha.
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
  Anovo.Config.Servicios;

var
  gServiciosListos: Boolean = False;

function PuertoConfigurado: Integer;
begin
  Result := dotEnv.Env('dmvc.server.port', 443);
end;

function BaseConfigurada: string;
begin
  Result := dotEnv.Env('firebird.database', '(sin definir en el .env)');
end;

function UsuarioDeBase: string;
begin
  Result := dotEnv.Env('firebird.user', '(sin definir en el .env)');
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
        dotEnv.Env('dmvc.load_system_controllers', 'true');
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
    // El motor todavia no es de nadie: si algo falla al configurarlo, aqui se
    // libera. Una vez que el servidor lo recibe, lo libera el.
    lEngine.Free;
    raise;
  end;
end;

end.
