unit Anovo.Api.Clientes;

// Clientes contra el servidor: GET /api/clientes.

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

end.
