unit Anovo.Api.Solicitudes;

// Cliente de la API de solicitudes.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.Api.Intf.Solicitudes,
  Anovo.DTOs.Dashboard;

type
  TApiSolicitudes = class(TApiBase, IApiSolicitudes)
  public
    function Seguimiento(const ATexto: string; const AHistorial: Boolean;
      const APagina, APorPagina: Integer; out ATotal: Int64;
      out ADesde: TDateTime): TObjectList<TSolicitudAsesorDTO>;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  JsonDataObjects,
  MVCFramework.RESTClient.Intf;

const
  RUTA_SEGUIMIENTO = '/api/solicitudes/seguimiento';
  PERIODO_MES = 'mes';
  PERIODO_TODO = 'todo';

function TApiSolicitudes.Seguimiento(const ATexto: string;
  const AHistorial: Boolean; const APagina, APorPagina: Integer;
  out ATotal: Int64; out ADesde: TDateTime): TObjectList<TSolicitudAsesorDTO>;
var
  lRespuesta: IMVCRESTResponse;
  lJson: TJsonObject;
  lPeriodo: string;
begin
  if AHistorial then
    lPeriodo := PERIODO_TODO
  else
    lPeriodo := PERIODO_MES;

  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente
        .AddQueryStringParam('q', ATexto)
        .AddQueryStringParam('periodo', lPeriodo)
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina)
        .Get(RUTA_SEGUIMIENTO);
    end);

  Result := TObjectList<TSolicitudAsesorDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TSolicitudAsesorDTO, 'data');

    lJson := TJsonObject.Parse(lRespuesta.Content) as TJsonObject;
    try
      ATotal := lJson.L['total'];
      ADesde := 0;
      if not lJson.IsNull('desde') then
        ADesde := ISO8601ToDate(lJson.S['desde'], False);
    finally
      lJson.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

end.
