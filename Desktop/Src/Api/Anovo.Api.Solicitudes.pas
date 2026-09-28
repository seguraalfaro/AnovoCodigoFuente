unit Anovo.Api.Solicitudes;

// Cliente de la API de solicitudes.

interface

uses
  System.Generics.Collections,
  MVCFramework.RESTClient.Intf,
  Anovo.Api.Base,
  Anovo.Api.Intf.Solicitudes,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes;

type
  TApiSolicitudes = class(TApiBase, IApiSolicitudes)
  public
    function Seguimiento(const ATexto: string; const AHistorial: Boolean;
      const APagina, APorPagina: Integer; out ATotal: Int64;
      out ADesde: TDateTime): TObjectList<TSolicitudAsesorDTO>;
    function Cola(const ATexto: string; const APagina, APorPagina: Integer;
      out ATotal: Int64): TObjectList<TSolicitudPorCotizarDTO>;
    function EnTrabajo(const ATexto: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudEnTrabajoDTO>;
  private
    function Pagina(const ARuta, ATexto: string;
      const APagina, APorPagina: Integer; out ATotal: Int64;
      const ALista: TObject; const AClase: TClass): IMVCRESTResponse;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  JsonDataObjects;

const
  RUTA_SEGUIMIENTO = '/api/solicitudes/seguimiento';
  RUTA_COLA = '/api/solicitudes/cola';
  RUTA_EN_TRABAJO = '/api/solicitudes/en-trabajo';
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

function TApiSolicitudes.Pagina(const ARuta, ATexto: string;
  const APagina, APorPagina: Integer; out ATotal: Int64;
  const ALista: TObject; const AClase: TClass): IMVCRESTResponse;
var
  lJson: TJsonObject;
begin
  Result := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente
        .AddQueryStringParam('q', ATexto)
        .AddQueryStringParam('pagina', APagina)
        .AddQueryStringParam('por_pagina', APorPagina)
        .Get(ARuta);
    end);

  Result.BodyForListOf(ALista, AClase, 'data');
  lJson := TJsonObject.Parse(Result.Content) as TJsonObject;
  try
    ATotal := lJson.L['total'];
  finally
    lJson.Free;
  end;
end;

function TApiSolicitudes.Cola(const ATexto: string;
  const APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TSolicitudPorCotizarDTO>;
begin
  Result := TObjectList<TSolicitudPorCotizarDTO>.Create(True);
  try
    Pagina(RUTA_COLA, ATexto, APagina, APorPagina, ATotal, Result,
      TSolicitudPorCotizarDTO);
  except
    Result.Free;
    raise;
  end;
end;

function TApiSolicitudes.EnTrabajo(const ATexto: string;
  const APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TSolicitudEnTrabajoDTO>;
begin
  Result := TObjectList<TSolicitudEnTrabajoDTO>.Create(True);
  try
    Pagina(RUTA_EN_TRABAJO, ATexto, APagina, APorPagina, ATotal, Result,
      TSolicitudEnTrabajoDTO);
  except
    Result.Free;
    raise;
  end;
end;

end.
