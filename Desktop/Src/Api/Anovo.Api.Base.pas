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
      const AUrl: string = ''; const ALarga: Boolean = False): IMVCRESTClient;
    function Ejecutar(const ALlamada: TFunc<IMVCRESTResponse>;
      const AEsLogin: Boolean = False): IMVCRESTResponse;

    function IdDeLocation(const ARespuesta: IMVCRESTResponse): Integer;
  end;

function FechaParaApi(const AFecha: TDateTime): string;

implementation

uses
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Diagnostics,
  System.Math,
  JsonDataObjects,
  MVCFramework.RESTClient,
  MVCFramework.RESTClient.Commons,
  Anovo.Config,
  Anovo.Registro,
  Anovo.Sesion,
  Anovo.Textos;

const

  TIEMPO_CONEXION_MS = 5000;

  TIEMPO_LECTURA_MS = 15000;

  TIEMPO_LECTURA_LARGA_MS = 60000;

  ESTADO_DEMASIADAS_PETICIONES = 429;
  ESTADO_PASARELA_DESDE = 502;
  ESTADO_PASARELA_HASTA = 504;
  ESTADO_TUNEL_DESDE = 520;
  ESTADO_TUNEL_HASTA = 530;

  CODIGO_SESION_REVOCADA = 'SESION_REVOCADA';

  ESTADO_SIN_RESPUESTA = 0;

threadvar
  VerboActual: string;
  RutaActual: string;

procedure ValidarCertificado(const aSender: TObject; const aRequest: TURLRequest;
  const aCertificate: TCertificate; var aAccepted: Boolean);
begin
  aAccepted := (aSender is THTTPClient) and
    (THTTPClient(aSender).SecureFailureReasons = []);
end;

procedure AnotarPeticion(aRequest: IHTTPRequest);
begin
  VerboActual := aRequest.MethodString;
  RutaActual := aRequest.URL.Path;
  if aRequest.URL.Query <> '' then
    RutaActual := RutaActual + '?' + aRequest.URL.Query;
end;

constructor EAnovoApiError.Create(const ACodigo, AMensaje: string;
  const AStatus: Integer);
begin
  inherited Create(AMensaje);
  FCodigo := ACodigo;
  FStatus := AStatus;
end;

function TApiBase.NuevoCliente(const AConToken: Boolean;
  const AUrl: string; const ALarga: Boolean): IMVCRESTClient;
var
  lUrl: string;
  lLectura: Integer;
begin
  lUrl := AUrl;
  if lUrl.IsEmpty then
    lUrl := TConfig.UrlServidor;
  lLectura := TIEMPO_LECTURA_MS;
  if ALarga then
    lLectura := TIEMPO_LECTURA_LARGA_MS;

  Result := TMVCRESTClient.New
    .BaseURL(lUrl)
    .ConnectTimeout(TIEMPO_CONEXION_MS)
    .ReadTimeout(lLectura)
    .Accept('application/json')
    .SetValidateServerCertificateProc(ValidarCertificado)
    .SetBeforeRequestProc(AnotarPeticion);

  if AConToken then
  begin
    if not TSesion.EstaVigente then
    begin
      TSesion.Vencer(SSesionVencida);
      raise EAnovoSesionVencida.Create(SSesionVencida);
    end;
    Result.SetBearerAuthorization(TSesion.Token);
  end;
end;

function TApiBase.Ejecutar(const ALlamada: TFunc<IMVCRESTResponse>;
  const AEsLogin: Boolean): IMVCRESTResponse;
var
  lCuerpo: TJsonBaseObject;
  lCodigo, lMensaje: string;
  lReloj: TStopwatch;
begin
  VerboActual := '';
  RutaActual := '';
  lReloj := TStopwatch.StartNew;
  try
    Result := ALlamada();
  except
    on E: EMVCRESTClientHttpException do
    begin
      RegistrarLlamada(VerboActual, RutaActual, ESTADO_SIN_RESPUESTA,
        lReloj.ElapsedMilliseconds, E.Message);
      if E.InnerException is ENetHTTPCertificateException then
        raise EAnovoSinConexion.Create(SCertificadoInvalido)
      else
        raise EAnovoSinConexion.Create(SSinConexion);
    end;
    on E: Exception do
    begin
      RegistrarLlamada(VerboActual, RutaActual, ESTADO_SIN_RESPUESTA,
        lReloj.ElapsedMilliseconds, E.Message);
      raise;
    end;
  end;
  RegistrarLlamada(VerboActual, RutaActual, Result.StatusCode,
    lReloj.ElapsedMilliseconds);

  if Result.Success then
    Exit;

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

  if (Result.StatusCode = 401) and not AEsLogin then
  begin
    if lCodigo = CODIGO_SESION_REVOCADA then
      lMensaje := SSesionRevocada
    else
      lMensaje := SSesionVencida;
    TSesion.Vencer(lMensaje);
    raise EAnovoSesionVencida.Create(lMensaje);
  end;

  if (Result.StatusCode = ESTADO_DEMASIADAS_PETICIONES) and (lCodigo = 'ERROR') then
    lMensaje := SDemasiadasPeticiones;

  if (lCodigo = 'ERROR') and
    (InRange(Result.StatusCode, ESTADO_PASARELA_DESDE, ESTADO_PASARELA_HASTA) or
    InRange(Result.StatusCode, ESTADO_TUNEL_DESDE, ESTADO_TUNEL_HASTA)) then
    lMensaje := SServidorNoDisponible;

  raise EAnovoApiError.Create(lCodigo, lMensaje, Result.StatusCode);
end;

function TApiBase.IdDeLocation(const ARespuesta: IMVCRESTResponse): Integer;
var
  lRuta: string;
begin
  lRuta := ARespuesta.HeaderValue('Location');
  Result := StrToIntDef(Copy(lRuta, LastDelimiter('/', lRuta) + 1, MaxInt), 0);
end;

function FechaParaApi(const AFecha: TDateTime): string;
begin
  Result := '';
  if AFecha > 0 then
    Result := FormatDateTime('yyyy-mm-dd', AFecha, TFormatSettings.Invariant);
end;

end.
