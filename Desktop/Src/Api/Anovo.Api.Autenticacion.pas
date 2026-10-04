unit Anovo.Api.Autenticacion;

// Cliente de la API de autenticacion: login y permisos de la sesion.

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
  MVCFramework.RESTClient.Intf,
  Anovo.Textos;

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
      SSinTokenSesion, lRespuesta.StatusCode);
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
