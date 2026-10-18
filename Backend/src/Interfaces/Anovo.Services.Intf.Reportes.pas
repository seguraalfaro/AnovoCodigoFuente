unit Anovo.Services.Intf.Reportes;

// Contrato del servicio de reportes.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones,
  Anovo.DTOs.Reportes;

type
  IReporteService = interface
    ['{0DE852C1-FB19-430E-837B-EC42C313C7E8}']
    function Cotizaciones(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer; const ARoles: TArray<string>)
      : TReporteCotizacionesDTO;
    function Detalle(const ADesde, AHasta: TDateTime;
      const AVista, AClave: string; const AUsuarioId: Integer;
      const ARoles: TArray<string>): TObjectList<TCotizacionDTO>;
  end;

implementation

end.
