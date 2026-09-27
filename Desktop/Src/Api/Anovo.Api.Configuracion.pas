unit Anovo.Api.Configuracion;

// Cliente de la API de Configuracion.

interface

uses
  Anovo.Api.Base,
  Anovo.Api.Intf.Configuracion,
  Anovo.DTOs.Sesion;

type
  TApiConfiguracion = class(TApiBase, IApiConfiguracion)
  public
    function Cuenta: TCuentaDTO;
    procedure CambiarClave(const ADto: TCambioClaveDTO);
    function Version(const AUrl: string = ''): TVersionDTO;
  end;

implementation

uses
  MVCFramework.RESTClient.Intf;

const
  RUTA_CUENTA = '/api/sesion/cuenta';
  RUTA_CLAVE = '/api/sesion/clave';
  RUTA_VERSION = '/api/version';

function TApiConfiguracion.Cuenta: TCuentaDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_CUENTA);
    end);

  Result := TCuentaDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

procedure TApiConfiguracion.CambiarClave(const ADto: TCambioClaveDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Put(RUTA_CLAVE);
    end);
end;

function TApiConfiguracion.Version(const AUrl: string): TVersionDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente(False, AUrl).Get(RUTA_VERSION);
    end);

  Result := TVersionDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

end.
