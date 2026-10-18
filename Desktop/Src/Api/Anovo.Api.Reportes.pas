unit Anovo.Api.Reportes;

// Cliente de la API de reportes.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.Api.Intf.Reportes,
  Anovo.DTOs.Cotizaciones,
  Anovo.DTOs.Reportes;

type
  TApiReportes = class(TApiBase, IApiReportes)
  public
    function Cotizaciones(const ADesde, AHasta: TDateTime)
      : TReporteCotizacionesDTO;
    function Detalle(const ADesde, AHasta: TDateTime;
      const AVista, AClave: string): TObjectList<TCotizacionDTO>;
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.RESTClient.Intf;

const
  RUTA_REPORTE_COTIZACIONES = '/api/reportes/cotizaciones';
  RUTA_DETALLE_REPORTE = '/api/reportes/cotizaciones/detalle';

function TApiReportes.Cotizaciones(const ADesde, AHasta: TDateTime)
  : TReporteCotizacionesDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente
        .AddQueryStringParam('desde', FechaParaApi(ADesde))
        .AddQueryStringParam('hasta', FechaParaApi(AHasta))
        .Get(RUTA_REPORTE_COTIZACIONES);
    end);

  Result := TReporteCotizacionesDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiReportes.Detalle(const ADesde, AHasta: TDateTime;
  const AVista, AClave: string): TObjectList<TCotizacionDTO>;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente
        .AddQueryStringParam('desde', FechaParaApi(ADesde))
        .AddQueryStringParam('hasta', FechaParaApi(AHasta))
        .AddQueryStringParam('vista', AVista)
        .AddQueryStringParam('clave', AClave)
        .Get(RUTA_DETALLE_REPORTE);
    end);

  Result := TObjectList<TCotizacionDTO>.Create(True);
  try
    lRespuesta.BodyForListOf(Result, TCotizacionDTO, 'data');
  except
    Result.Free;
    raise;
  end;
end;

end.
