unit Anovo.Api.Clientes;

// Clientes contra el servidor: el listado y la ficha (datos, contactos e
// historial de consentimiento).

interface

uses
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.Api.Intf.Clientes,
  Anovo.DTOs.Clientes;

type
  TApiClientes = class(TApiBase, IApiClientes)
  public
    function Buscar(const ATexto, AConsentimiento: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TClienteDTO>;
    function Obtener(const AId: Integer): TClienteDTO;
    function Contactos(const AId: Integer): TObjectList<TContactoDTO>;
    function Consentimientos(const AId: Integer)
      : TObjectList<TConsentimientoDTO>;
    procedure Actualizar(const AId: Integer; const ADto: TClienteEdicionDTO);
    function Crear(const ADto: TClienteNuevoDTO): Integer;
    function CrearContacto(const AId: Integer;
      const ADto: TContactoNuevoDTO): Integer;
  end;

implementation

uses
  System.SysUtils,
  JsonDataObjects,
  MVCFramework.RESTClient.Intf;

const
  RUTA_CLIENTES = '/api/clientes';

function TApiClientes.Buscar(const ATexto, AConsentimiento: string;
  const APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TClienteDTO>;
var
  lRespuesta: IMVCRESTResponse;
  lJson: TJsonObject;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    var
      lCliente: IMVCRESTClient;
    begin
      // Por parametro y no pegado a la ruta: el cliente REST codifica los
      // espacios y las tildes de lo que se escribio en el buscador.
      lCliente := NuevoCliente
        .AddQueryStringParam('q', ATexto)
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina);
      if AConsentimiento <> '' then
        lCliente.AddQueryStringParam('consentimiento', AConsentimiento);
      Result := lCliente.Get(RUTA_CLIENTES);
    end);

  Result := TObjectList<TClienteDTO>.Create(True);
  try
    // Coleccion del contrato: la lista en data, la paginacion en la raiz.
    lRespuesta.BodyForListOf(Result, TClienteDTO, 'data');

    lJson := TJsonObject.Parse(lRespuesta.Content) as TJsonObject;
    try
      ATotal := lJson.L['total'];
    finally
      lJson.Free;
    end;
  except
    // Si falla a mitad de la lectura, la lista no la recibe nadie que la
    // pueda liberar.
    Result.Free;
    raise;
  end;
end;

function TApiClientes.Obtener(const AId: Integer): TClienteDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format('%s/%d', [RUTA_CLIENTES, AId]));
    end);

  Result := TClienteDTO.Create;
  try
    // El objeto viene dentro de data, como en el resto del contrato.
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiClientes.Contactos(const AId: Integer)
  : TObjectList<TContactoDTO>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format('%s/%d/contactos',
        [RUTA_CLIENTES, AId]));
    end);

  Result := TObjectList<TContactoDTO>.Create(True);
  try
    // Sin paginar: un cliente tiene unos pocos contactos.
    lRespuesta.BodyForListOf(Result, TContactoDTO, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiClientes.Consentimientos(const AId: Integer)
  : TObjectList<TConsentimientoDTO>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(Format('%s/%d/consentimientos',
        [RUTA_CLIENTES, AId]));
    end);

  Result := TObjectList<TConsentimientoDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TConsentimientoDTO, 'data');
  except
    Result.Free;
    raise;
  end;
end;

// El numero del registro nuevo viene en Location: /api/clientes/42 o
// /api/clientes/7/contactos/42. Se toma lo que hay despues de la ultima
// barra.
function IdDeLocation(const ARespuesta: IMVCRESTResponse): Integer;
var
  lRuta: string;
begin
  lRuta := ARespuesta.HeaderValue('Location');
  Result := StrToIntDef(Copy(lRuta, LastDelimiter('/', lRuta) + 1, MaxInt), 0);
end;

procedure TApiClientes.Actualizar(const AId: Integer;
  const ADto: TClienteEdicionDTO);
begin
  // 204 sin cuerpo: no hay nada que leer, y Ejecutar ya convirtio cualquier
  // error del servidor en excepcion.
  Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Put(Format('%s/%d', [RUTA_CLIENTES, AId]));
    end);
end;

function TApiClientes.Crear(const ADto: TClienteNuevoDTO): Integer;
begin
  Result := IdDeLocation(Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False).Post(RUTA_CLIENTES);
    end));
end;

function TApiClientes.CrearContacto(const AId: Integer;
  const ADto: TContactoNuevoDTO): Integer;
begin
  Result := IdDeLocation(Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.AddBody(ADto, False)
        .Post(Format('%s/%d/contactos', [RUTA_CLIENTES, AId]));
    end));
end;

end.
