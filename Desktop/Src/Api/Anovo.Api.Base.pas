unit Anovo.Api.Base;

{ El unico sitio de la aplicacion que habla HTTP.

  Pantallas y presentadores no ven URLs, verbos ni codigos de estado: llaman a
  metodos de dominio de las clases que heredan de aqui, y cuando algo falla
  reciben siempre una de estas tres excepciones:

    EAnovoSinConexion     el servidor no respondio
    EAnovoSesionVencida   el token vencio o fue rechazado
    EAnovoApiError        el servidor respondio que no, con codigo y mensaje

  Los codigos son los del contrato de la API, los mismos que usa la app movil.
  Se compara siempre por Codigo, nunca por Mensaje. }

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
    function NuevoCliente(const AConToken: Boolean = True): IMVCRESTClient;
    function Ejecutar(const ALlamada: TFunc<IMVCRESTResponse>;
      const AEsLogin: Boolean = False): IMVCRESTResponse;
  end;

implementation

uses
  System.Net.URLClient,
  System.Net.HttpClient,
  JsonDataObjects,
  MVCFramework.RESTClient,
  MVCFramework.RESTClient.Commons,
  Anovo.Config,
  Anovo.Sesion;

const

  TIEMPO_CONEXION_MS = 5000;

  TIEMPO_LECTURA_MS = 60000;

  MENSAJE_SIN_CONEXION = 'No se pudo conectar con el servidor de Anovo. ' +
    'Revise la red o avise al administrador.';
  MENSAJE_SESION_VENCIDA = 'Su sesion vencio. Vuelva a ingresar.';
  MENSAJE_CERTIFICADO = 'No se pudo verificar el certificado del servidor ' +
    'de Anovo. Avise al administrador.';

{ Validacion del certificado del servidor }

procedure ValidarCertificado(const aSender: TObject; const aRequest: TURLRequest;
  const aCertificate: TCertificate; var aAccepted: Boolean);
begin
  { En Delphi 10.4 con WinHTTP este procedimiento se llama en DOS situaciones
    (System.Net.HttpClient.Win.pas, al enviar la peticion):

      - con el certificado VALIDO, SecureFailureReasons vacio: WinHTTP ya lo
        acepto y solo ofrece una validacion adicional;
      - con el certificado RECHAZADO por Windows, con el motivo en
        SecureFailureReasons.

    El cliente REST de DMVC asigna su propio validador y responde siempre
    MVCRESTClientAcceptInvalidCertificates, que es False: supone que solo lo
    llaman en el segundo caso, y en 10.4 rechaza tambien certificados validos.
    Por eso el login fallaba aunque Windows confiara en la CA.

    Aqui se acepta solo lo que Windows ya dio por bueno. Cualquier motivo de
    rechazo -CA desconocida, nombre, fecha- se mantiene: no se perdona nada que
    la plataforma haya rechazado. }
  aAccepted := (aSender is THTTPClient) and
    (THTTPClient(aSender).SecureFailureReasons = []);
end;

{ EAnovoApiError }

constructor EAnovoApiError.Create(const ACodigo, AMensaje: string;
  const AStatus: Integer);
begin
  inherited Create(AMensaje);
  FCodigo := ACodigo;
  FStatus := AStatus;
end;

{ TApiBase }

function TApiBase.NuevoCliente(const AConToken: Boolean): IMVCRESTClient;
begin
  Result := TMVCRESTClient.New
    .BaseURL(TConfig.UrlServidor)
    .ConnectTimeout(TIEMPO_CONEXION_MS)
    .ReadTimeout(TIEMPO_LECTURA_MS)
    .Accept('application/json')
    .SetValidateServerCertificateProc(ValidarCertificado);

  if AConToken then
  begin
    { Se comprueba antes de salir: no tiene sentido ir al servidor para que
      conteste 401 cuando ya se sabe que el token vencio. }
    if not TSesion.EstaVigente then
      raise EAnovoSesionVencida.Create(MENSAJE_SESION_VENCIDA);
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
    { El cliente REST del framework atrapa todo error de red y lo relanza
      envuelto en EMVCRESTClientHttpException, con el original guardado en
      InnerException (MVCFramework.RESTClient.pas, en Execute). Por eso no se
      pregunta por ENetException: nunca llega hasta aqui con ese tipo.

      Hay que mirar dentro para no mostrar "sin conexion" cuando si conecto y lo
      que fallo fue la confianza en el certificado: con ese mensaje nadie
      buscaria donde es.

      Solo se capturan errores de la llamada HTTP. Un fallo de programacion no
      se disfraza de "sin conexion", porque entonces nadie lo buscaria donde
      esta. }
    on E: EMVCRESTClientHttpException do
      if E.InnerException is ENetHTTPCertificateException then
        raise EAnovoSinConexion.Create(MENSAJE_CERTIFICADO)
      else
        raise EAnovoSinConexion.Create(MENSAJE_SIN_CONEXION);
  end;

  if Result.Success then
    Exit;

  { En el login, 401 significa clave incorrecta, no sesion vencida: todavia no
    hay sesion. Se deja seguir para que llegue con su codigo. }
  if (Result.StatusCode = 401) and not AEsLogin then
  begin
    TSesion.Cerrar;
    raise EAnovoSesionVencida.Create(MENSAJE_SESION_VENCIDA);
  end;

  lCodigo := 'ERROR';
  lMensaje := Format('El servidor respondio con un error (%d).',
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
    { Cuerpo vacio o que no es JSON: un proxy, un 502. Queda el generico. }
    on EJsonException do
      ;
  end;

  raise EAnovoApiError.Create(lCodigo, lMensaje, Result.StatusCode);
end;

end.
