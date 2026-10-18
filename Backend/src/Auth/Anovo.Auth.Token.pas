unit Anovo.Auth.Token;

// Configuracion y emision del JWT. La usan el middleware del login y la
// renovacion por dispositivo, para que los dos tokens salgan iguales.

interface

uses
  MVCFramework.JWT,
  Anovo.Services.Intf.Sesion;

const
  JWT_LEEWAY_SEGUNDOS = 300;
  DATO_NOMBRE = 'NOMBRE';
  DATO_DEBE_CAMBIAR_CLAVE = 'DEBE_CAMBIAR_CLAVE';

procedure ConfigurarClaims(const AJWT: TJWT);
function SecretoJWT: string;
function SecretoDocumentacion: string;
function EmisorJWT: string;
function EmitirToken(const AAutenticacion: TAutenticacion;
  const ADispositivoId: Integer = 0): string;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  MVCFramework.Commons,
  Anovo.Auth.Permisos,
  Anovo.Textos;

const
  EMISOR_POR_DEFECTO = 'AnovoAPI';
  SUFIJO_SECRETO_DOCUMENTACION = '|documentacion';

procedure ConfigurarClaims(const AJWT: TJWT);
begin
  AJWT.Claims.Issuer := EmisorJWT;
  AJWT.Claims.ExpirationTime := Now + OneHour;
  AJWT.Claims.NotBefore := Now - OneMinute * 5;
  AJWT.Claims.IssuedAt := Now;
  AJWT.CustomClaims['app'] := 'AnovoAPI';
end;

function SecretoJWT: string;
begin
  Result := dotEnv.Env('JWT_SECRET', '').Trim;
  if Result.IsEmpty then
    raise Exception.Create(SFaltaSecretoJWT);
end;

function SecretoDocumentacion: string;
begin
  Result := SecretoJWT + SUFIJO_SECRETO_DOCUMENTACION;
end;

function EmisorJWT: string;
begin
  Result := dotEnv.Env('JWT_ISSUER', EMISOR_POR_DEFECTO);
end;

function EmitirToken(const AAutenticacion: TAutenticacion;
  const ADispositivoId: Integer): string;
var
  lJWT: TJWT;
begin
  lJWT := TJWT.Create(SecretoJWT, JWT_LEEWAY_SEGUNDOS);
  try
    ConfigurarClaims(lJWT);
    lJWT.CustomClaims['username'] := AAutenticacion.Correo;
    lJWT.CustomClaims['roles'] := AAutenticacion.Rol;
    lJWT.CustomClaims[DATO_USUARIO_ID] := AAutenticacion.UsuarioId.ToString;
    lJWT.CustomClaims[DATO_NOMBRE] := AAutenticacion.Nombre;
    lJWT.CustomClaims[DATO_DEBE_CAMBIAR_CLAVE] :=
      BoolToStr(AAutenticacion.DebeCambiarClave, True);
    if ADispositivoId > 0 then
      lJWT.CustomClaims[DATO_DISPOSITIVO_ID] := ADispositivoId.ToString;
    Result := lJWT.GetToken;
  finally
    lJWT.Free;
  end;
end;

end.
