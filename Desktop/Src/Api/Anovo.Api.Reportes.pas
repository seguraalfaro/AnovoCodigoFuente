unit Anovo.Api.Reportes;

// Cliente de la API de reportes.

interface

uses
  Anovo.Api.Base,
  Anovo.Api.Intf.Reportes,
  Anovo.DTOs.Reportes;

type
  TApiReportes = class(TApiBase, IApiReportes)
  public
    function Cotizaciones(const ADesde, AHasta: TDateTime)
      : TReporteCotizacionesDTO;
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.RESTClient.Intf;

const
  RUTA_REPORTE_COTIZACIONES = '/api/reportes/cotizaciones';

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

end.
