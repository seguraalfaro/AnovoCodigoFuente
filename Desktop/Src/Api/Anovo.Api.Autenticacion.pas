unit Anovo.Api.Autenticacion;

{ Autenticacion contra el servidor: credenciales a cambio de un token. }

interface

uses
  Anovo.Api.Base,
  Anovo.Api.Intf.Autenticacion;

type
  TApiAutenticacion = class(TApiBase, IApiAutenticacion)
  public
    function IniciarSesion(const ACorreo, AClave: string): string;
    function ObtenerPermisos: TArray<string>;
  end;

implementation

uses
  System.SysUtils,
  JsonDataObjects,
  MVCFramework.RESTClient.Intf;

const
  RUTA_LOGIN = '/api/auth/login';
  RUTA_SESION = '/api/sesion';

function TApiAutenticacion.IniciarSesion(const ACorreo, AClave: string): string;
var
  lRespuesta: IMVCRESTResponse;
  lJson: TJsonObject;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      { El middleware JWT del framework lee las credenciales de dos cabeceras,
        no del cuerpo. Viajan cifradas porque la conexion es HTTPS. Sin token:
        todavia no hay sesion. }
      Result := NuevoCliente(False).AddHeader('jwtusername', ACorreo)
        .AddHeader('jwtpassword', AClave).Post(RUTA_LOGIN);
    end, True);

  lJson := TJsonObject.Parse(lRespuesta.Content) as TJsonObject;
  try
    Result := lJson.S['token'];
  finally
    lJson.Free;
  end;

  if Result.IsEmpty then
    raise EAnovoApiError.Create('ERROR',
      'El servidor no devolvio el token de sesion.', lRespuesta.StatusCode);
end;

function TApiAutenticacion.ObtenerPermisos: TArray<string>;
var
  lRespuesta: IMVCRESTResponse;
  lJson: TJsonObject;
  lLista: TJsonArray;
  I: Integer;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_SESION);
    end);

  { Esta si viene en el sobre del contrato, al reves que el login. }
  lJson := TJsonObject.Parse(lRespuesta.Content) as TJsonObject;
  try
    lLista := lJson.O['data'].A['permisos'];
    SetLength(Result, lLista.Count);
    for I := 0 to lLista.Count - 1 do
      Result[I] := lLista.S[I];
  finally
    lJson.Free;
  end;

end;

end.
