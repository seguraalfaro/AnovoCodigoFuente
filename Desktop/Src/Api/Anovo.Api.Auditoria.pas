unit Anovo.Api.Auditoria;

// Cliente de la API de auditoria: bitacora completa y de cuentas.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.Api.Intf.Auditoria,
  Anovo.DTOs.Auditoria;

type
  TApiAuditoria = class(TApiBase, IApiAuditoria)
  public
    function Buscar(const ASoloCuentas: Boolean;
      const ADesde, AHasta: TDateTime;
      const AEntidad, AAccion, ATexto: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TAuditoriaDTO>;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  JsonDataObjects,
  MVCFramework.RESTClient.Intf;

const
  RUTA_AUDITORIA = '/api/auditoria';
  RUTA_CUENTAS = '/api/auditoria/cuentas';

function TApiAuditoria.Buscar(const ASoloCuentas: Boolean;
  const ADesde, AHasta: TDateTime; const AEntidad, AAccion, ATexto: string;
  const APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TAuditoriaDTO>;
var
  lRespuesta: IMVCRESTResponse;
  lJson: TJsonObject;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    var
      lCliente: IMVCRESTClient;
    begin
      lCliente := NuevoCliente
        .AddQueryStringParam('desde', FechaParaApi(ADesde))
        .AddQueryStringParam('hasta', FechaParaApi(AHasta))
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina);
      if AEntidad <> '' then
        lCliente.AddQueryStringParam('entidad', AEntidad);
      if AAccion <> '' then
        lCliente.AddQueryStringParam('accion', AAccion);
      if ATexto <> '' then
        lCliente.AddQueryStringParam('q', ATexto);

      if ASoloCuentas then
        Result := lCliente.Get(RUTA_CUENTAS)
      else
        Result := lCliente.Get(RUTA_AUDITORIA);
    end);

  Result := TObjectList<TAuditoriaDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TAuditoriaDTO, 'data');

    lJson := TJsonObject.Parse(lRespuesta.Content) as TJsonObject;
    try
      ATotal := lJson.L['total'];
    finally
      lJson.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

end.
