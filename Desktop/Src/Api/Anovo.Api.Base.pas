unit Anovo.Api.Base;

// Base de los clientes de la API: el unico sitio que habla HTTP.
// Traduce los fallos a EAnovoSinConexion, EAnovoSesionVencida y EAnovoApiError.

interface

uses
  System.SysUtils,
  MVCFramework.RESTClient.Intf;

type
  EAnovoCliente = class(Exception);
  EAnovoSinConexion = class(EAnovoCliente);
  EAnovoSesionVencida = class(EAnovoCliente);

  EAnovoApiError = class(EAnovoCliente)
  private
    FCodigo: string;
    FStatus: Integer;
  public
    constructor Create(const ACodigo, AMensaje: string;
      const AStatus: Integer); reintroduce;
    property Codigo: string read FCodigo;
    property Status: Integer read FStatus;
  end;

  TApiBase = class(TInterfacedObject)
  protected
    function NuevoCliente(const AConToken: Boolean = True;
      const AUrl: string = ''): IMVCRESTClient;
    function Ejecutar(const ALlamada: TFunc<IMVCRESTResponse>;
      const AEsLogin: Boolean = False): IMVCRESTResponse;

    function IdDeLocation(const ARespuesta: IMVCRESTResponse): Integer;
  end;

implementation

uses
  System.Net.URLClient,
  System.Net.HttpClient,
  JsonDataObjects,
  MVCFramework.RESTClient,
  MVCFramework.RESTClient.Commons,
  Anovo.Config,
  Anovo.Sesion,
  Anovo.Textos;

const

  TIEMPO_CONEXION_MS = 5000;

  TIEMPO_LECTURA_MS = 60000;

procedure ValidarCertificado(const aSender: TObject; const aRequest: TURLRequest;
  const aCertificate: TCertificate; var aAccepted: Boolean);
begin
  aAccepted := (aSender is THTTPClient) and
    (THTTPClient(aSender).SecureFailureReasons = []);
end;

constructor EAnovoApiError.Create(const ACodigo, AMensaje: string;
  const AStatus: Integer);
begin
  inherited Create(AMensaje);
  FCodigo := ACodigo;
  FStatus := AStatus;
end;

function TApiBase.NuevoCliente(const AConToken: Boolean;
  const AUrl: string): IMVCRESTClient;
var
  lUrl: string;
begin
  lUrl := AUrl;
  if lUrl.IsEmpty then
    lUrl := TConfig.UrlServidor;

  Result := TMVCRESTClient.New
    .BaseURL(lUrl)
    .ConnectTimeout(TIEMPO_CONEXION_MS)
    .ReadTimeout(TIEMPO_LECTURA_MS)
    .Accept('application/json')
    .SetValidateServerCertificateProc(ValidarCertificado);

  if AConToken then
  begin
    if not TSesion.EstaVigente then
      raise EAnovoSesionVencida.Create(SSesionVencida);
    Result.SetBearerAuthorization(TSesion.Token);
  end;
end;

function TApiBase.Ejecutar(const ALlamada: TFunc<IMVCRESTResponse>;
  const AEsLogin: Boolean): IMVCRESTResponse;
var
  lCuerpo: TJsonBaseObject;
  lCodigo, lMensaje: string;
begin
  try
    Result := ALlamada();
  except
    on E: EMVCRESTClientHttpException do
      if E.InnerException is ENetHTTPCertificateException then
        raise EAnovoSinConexion.Create(SCertificadoInvalido)
      else
        raise EAnovoSinConexion.Create(SSinConexion);
  end;

  if Result.Success then
    Exit;

  if (Result.StatusCode = 401) and not AEsLogin then
  begin
    TSesion.Cerrar;
    raise EAnovoSesionVencida.Create(SSesionVencida);
  end;

  lCodigo := 'ERROR';
  lMensaje := Format(SErrorServidor,
    [Result.StatusCode]);
  try
    lCuerpo := TJsonBaseObject.Parse(Result.Content);
    try
      if (lCuerpo is TJsonObject) and TJsonObject(lCuerpo).Contains('error') then
      begin
        lCodigo := TJsonObject(lCuerpo).O['error'].S['codigo'];
        lMensaje := TJsonObject(lCuerpo).O['error'].S['mensaje'];
      end;
    finally
      lCuerpo.Free;
    end;
  except
    on EJsonException do
      ;
  end;

  raise EAnovoApiError.Create(lCodigo, lMensaje, Result.StatusCode);
end;

function TApiBase.IdDeLocation(const ARespuesta: IMVCRESTResponse): Integer;
var
  lRuta: string;
begin
  lRuta := ARespuesta.HeaderValue('Location');
  Result := StrToIntDef(Copy(lRuta, LastDelimiter('/', lRuta) + 1, MaxInt), 0);
end;

end.
