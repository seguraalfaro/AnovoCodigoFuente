unit Anovo.Services.Intf.Reportes;

// Contrato del servicio de reportes.

interface

uses
  Anovo.DTOs.Reportes;

type
  IReporteService = interface
    ['{0DE852C1-FB19-430E-837B-EC42C313C7E8}']
    function Cotizaciones(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer; const ARoles: TArray<string>)
      : TReporteCotizacionesDTO;
  end;

implementation

end.
