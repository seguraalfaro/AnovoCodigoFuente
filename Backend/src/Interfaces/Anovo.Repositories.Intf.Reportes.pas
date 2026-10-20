unit Anovo.Repositories.Intf.Reportes;

// Contrato del repositorio de reportes.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Cotizaciones,
  Anovo.Entities.Consultas;

type
  TFiltroDetalleReporte = record
    Desde: TDateTime;
    Hasta: TDateTime;
    PorEnvio: Boolean;
    Estado: string;
    AsesorId: Integer;
    ClienteId: Integer;
    FiltraTipo: Boolean;
    TipoTrabajoId: Integer;
    UsuarioPropio: Integer;
  end;

  IReporteRepository = interface(IMVCRepository<TCotizaciones>)
    ['{40D3D0A7-BC12-4A39-A1C1-FEE94847A082}']
    procedure FijarPeriodo(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer);
    function Resumen: TObjectList<TResumenDelReporte>;
    function PorEstado: TObjectList<TReportePorEstado>;
    function PorAsesor: TObjectList<TReportePorAsesor>;
    function PorTipo: TObjectList<TReportePorTipo>;
    function PorMes: TObjectList<TReportePorMes>;
    function PorCliente: TObjectList<TReportePorCliente>;
    function Detalle(const AFiltro: TFiltroDetalleReporte;
      const ALimite: Integer): TObjectList<TCotizacionConNombres>;
  end;

implementation

end.
