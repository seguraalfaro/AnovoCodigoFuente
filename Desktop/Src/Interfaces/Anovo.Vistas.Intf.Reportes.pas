unit Anovo.Vistas.Intf.Reportes;

// Contrato de la vista de reportes.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones,
  Anovo.DTOs.Reportes,
  Anovo.PeriodoBusqueda;

type
  TVistaReporte = (vrEstado, vrAsesor, vrTipo, vrMes, vrCliente);

  TCifraReporte = (crEnviadas, crMontoEnviado, crAprobadas, crMontoAprobado,
    crTasa, crRespuesta);

  TResumenReporte = record
    Valores: array [TCifraReporte] of string;
    Variaciones: array [TCifraReporte] of string;
    Rotulos: array [TCifraReporte] of string;
    Comparado: string;
    Periodo: string;
    Empresa: string;
    EmpresaDatos: string;
    Generado: string;
    TasaTotal: string;
  end;

  IVistaReportes = interface
    ['{C4E8A2B7-5D19-4F63-8A0E-7B3D91F2C658}']
    procedure MostrarVistas(const ARotulos: TArray<string>);
    procedure MostrarVista(const AVista: TVistaReporte);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarReporte(const ADatos: TReporteCotizacionesDTO;
      const AResumen: TResumenReporte; const AMaximoMes: Integer);
    procedure MostrarDetalle(const ATitulo, AAyuda: string;
      const AFilas: TObjectList<TCotizacionDTO>);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
