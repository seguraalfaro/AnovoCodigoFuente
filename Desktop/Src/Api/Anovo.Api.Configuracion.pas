unit Anovo.Api.Configuracion;

// Cliente de la API de Configuracion.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.Api.Intf.Configuracion,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Clientes,
  Anovo.DTOs.Empresa,
  Anovo.DTOs.Sesion;

type
  TApiConfiguracion = class(TApiBase, IApiConfiguracion)
  public
    function Cuenta: TCuentaDTO;
    procedure CambiarClave(const ADto: TCambioClaveDTO);
    function Version(const AUrl: string = ''): TVersionDTO;
    function Empresa: TEmpresaDTO;
    procedure GuardarEmpresa(const ADto: TEmpresaDTO);
    function FormasPago: TObjectList<TCatalogoSimpleDTO>;
    function VersionesConsentimiento: TObjectList<TConsentimientoTextoDTO>;
    procedure PublicarConsentimiento(const ADto: TConsentimientoTextoNuevoDTO);
  end;

implementation

uses
  MVCFramework.RESTClient.Intf;

const
  RUTA_CUENTA = '/api/sesion/cuenta';
  RUTA_CLAVE = '/api/sesion/clave';
  RUTA_VERSION = '/api/version';
  RUTA_EMPRESA = '/api/empresa';
  RUTA_FORMAS_PAGO = '/api/empresa/formas-pago';
  RUTA_CONSENTIMIENTOS = '/api/consentimiento/versiones';

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

function TApiConfiguracion.Empresa: TEmpresaDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_EMPRESA);
    end);

  Result := TEmpresaDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiConfiguracion.FormasPago: TObjectList<TCatalogoSimpleDTO>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_FORMAS_PAGO);
    end);

  Result := TObjectList<TCatalogoSimpleDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TCatalogoSimpleDTO, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiConfiguracion.VersionesConsentimiento
  : TObjectList<TConsentimientoTextoDTO>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_CONSENTIMIENTOS);
    end);

  Result := TObjectList<TConsentimientoTextoDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TConsentimientoTextoDTO, 'data');
  except
    Result.Free;
    raise;
  end;
end;

procedure TApiConfiguracion.PublicarConsentimiento(const ADto
  : TConsentimientoTextoNuevoDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Post(RUTA_CONSENTIMIENTOS);
    end);
end;

procedure TApiConfiguracion.GuardarEmpresa(const ADto: TEmpresaDTO);
begin
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Put(RUTA_EMPRESA);
    end);
end;

end.
