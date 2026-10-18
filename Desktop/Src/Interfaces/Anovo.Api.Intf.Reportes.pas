unit Anovo.Api.Intf.Reportes;

// Contrato de la API de reportes.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones,
  Anovo.DTOs.Reportes;

type
  IApiReportes = interface
    ['{6A1F3C52-8E07-4B9D-9C41-2D5E7B0A93F6}']
    function Cotizaciones(const ADesde, AHasta: TDateTime)
      : TReporteCotizacionesDTO;
    function Detalle(const ADesde, AHasta: TDateTime;
      const AVista, AClave: string): TObjectList<TCotizacionDTO>;
  end;

implementation

end.
