unit Anovo.Vistas.Intf.Reportes;

// Contrato de la vista de reportes.

interface

uses
  Anovo.DTOs.Reportes;

type
  TVistaReporte = (vrEstado, vrAsesor, vrTipo, vrMes);
  TPeriodoReporte = (prEsteMes, prMesAnterior, prTrimestre, prAnio);

  IVistaReportes = interface
    ['{C4E8A2B7-5D19-4F63-8A0E-7B3D91F2C658}']
    procedure MostrarVistas(const ARotulos: TArray<string>);
    procedure MostrarVista(const AVista: TVistaReporte);
    procedure MostrarPeriodo(const ADesde, AHasta: TDateTime;
      const APeriodo: Integer);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarReporte(const ADatos: TReporteCotizacionesDTO;
      const AMaximoMes: Integer);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
