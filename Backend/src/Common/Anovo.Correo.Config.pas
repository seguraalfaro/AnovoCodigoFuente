unit Anovo.Correo.Config;

// Configuracion del correo saliente leida del .env: modo (contrasena de
// aplicacion u OAuth2), servidor SMTP, cuenta remitente y datos de OAuth2.

interface

type
  TModoCorreo = (mcNinguno, mcClave, mcOAuth2);
  TProveedorOAuth = (poGoogle, poMicrosoft);

  TConfigCorreo = record
    Modo: TModoCorreo;
    Servidor: string;
    Puerto: string;
    Implicito: Boolean;
    Cuenta: string;
    NombreRemitente: string;
    Clave: string;
    Proveedor: TProveedorOAuth;
    ClientId: string;
    ClientSecret: string;
    ArchivoToken: string;
    TimeoutSegundos: Integer;
    function Configurado: Boolean;
    function CodigoModo: string;
    class function Leer: TConfigCorreo; static;
  end;

const
  MODO_CORREO_CLAVE = 'clave';
  MODO_CORREO_OAUTH2 = 'oauth2';

implementation

uses
  System.SysUtils,
  MVCFramework.Commons;

const
  PROVEEDOR_MICROSOFT = 'microsoft';
  SEGURIDAD_EXPLICITA = 'explicito';
  SERVIDOR_GMAIL = 'smtp.gmail.com';
  SERVIDOR_MICROSOFT = 'smtp.office365.com';
  PUERTO_IMPLICITO = '465';
  PUERTO_EXPLICITO = '587';
  ARCHIVO_TOKEN = 'correo.token';
  TIMEOUT_POR_DEFECTO = 60;
  LARGO_CLAVE_APLICACION = 16;

function SinEspacios(const ATexto: string): string;
begin
  Result := ATexto.Replace(' ', '', [rfReplaceAll]).Trim;
end;

class function TConfigCorreo.Leer: TConfigCorreo;
var
  lModo, lSeguridad: string;
begin
  Result := Default(TConfigCorreo);
  lModo := dotEnv.Env('anovo.correo.modo', '').Trim.ToLower;
  if lModo = MODO_CORREO_CLAVE then
    Result.Modo := mcClave
  else if lModo = MODO_CORREO_OAUTH2 then
    Result.Modo := mcOAuth2
  else
    Result.Modo := mcNinguno;

  if dotEnv.Env('anovo.correo.oauth.proveedor', '').Trim.ToLower =
    PROVEEDOR_MICROSOFT then
    Result.Proveedor := poMicrosoft
  else
    Result.Proveedor := poGoogle;

  if (Result.Modo = mcOAuth2) and (Result.Proveedor = poMicrosoft) then
  begin
    Result.Servidor := dotEnv.Env('anovo.correo.servidor', SERVIDOR_MICROSOFT);
    lSeguridad := dotEnv.Env('anovo.correo.seguridad', SEGURIDAD_EXPLICITA);
  end
  else
  begin
    Result.Servidor := dotEnv.Env('anovo.correo.servidor', SERVIDOR_GMAIL);
    lSeguridad := dotEnv.Env('anovo.correo.seguridad', '');
  end;
  Result.Implicito := not SameText(lSeguridad.Trim, SEGURIDAD_EXPLICITA);
  if Result.Implicito then
    Result.Puerto := dotEnv.Env('anovo.correo.puerto', PUERTO_IMPLICITO)
  else
    Result.Puerto := dotEnv.Env('anovo.correo.puerto', PUERTO_EXPLICITO);

  Result.Cuenta := dotEnv.Env('anovo.correo.cuenta', '').Trim.ToLower;
  Result.NombreRemitente := dotEnv.Env('anovo.correo.nombre', '').Trim;
  Result.Clave := SinEspacios(dotEnv.Env('anovo.correo.clave', ''));
  Result.ClientId := dotEnv.Env('anovo.correo.oauth.client_id', '').Trim;
  Result.ClientSecret := dotEnv.Env('anovo.correo.oauth.client_secret', '').Trim;
  Result.ArchivoToken := dotEnv.Env('anovo.correo.oauth.archivo',
    ExtractFilePath(ParamStr(0)) + ARCHIVO_TOKEN);
  Result.TimeoutSegundos := StrToIntDef(dotEnv.Env('anovo.correo.timeout', ''),
    TIMEOUT_POR_DEFECTO);
end;

function TConfigCorreo.Configurado: Boolean;
begin
  case Modo of
    mcClave:
      Result := (not Cuenta.IsEmpty) and
        (Clave.Length = LARGO_CLAVE_APLICACION);
    mcOAuth2:
      Result := (not Cuenta.IsEmpty) and (not ClientId.IsEmpty) and
        FileExists(ArchivoToken);
  else
    Result := False;
  end;
end;

function TConfigCorreo.CodigoModo: string;
begin
  case Modo of
    mcClave:
      Result := MODO_CORREO_CLAVE;
    mcOAuth2:
      Result := MODO_CORREO_OAUTH2;
  else
    Result := '';
  end;
end;

end.
