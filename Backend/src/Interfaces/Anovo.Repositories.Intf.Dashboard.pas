unit Anovo.Repositories.Intf.Dashboard;

// Contrato del repositorio de dashboards.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Solicitudes,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas;

type
  IDashboardRepository = interface(IMVCRepository<TSolicitudes>)
    ['{13AD56E7-B2B7-49C8-A1FB-3DFFA6145C3A}']
    function Periodo: TVPeriodoActual;
    function ResumenMes: TVResumenMes;
    function TrabajoDe(const AUsuarioId: Integer): TTrabajoUsuario;
    function AsesorMes(const AAsesorId: Integer): TAsesoresMes;
    function Productividad: TObjectList<TAsesoresMes>;
    function RecientesAsesor(const AAsesorId: Integer;
      const ADesde, AHasta: TDateTime): TObjectList<TSeguimientoAsesor>;
    function ColaPorCotizar: TObjectList<TColaSolicitudes>;
    function ColaPorAprobar(const AUsuarioId: Integer)
      : TObjectList<TBandejaCotizaciones>;
    function CotizacionesPorEstado: TObjectList<TCotizacionesPorEstado>;
    function CuentasResumen: TVCuentasResumen;
    function CambiosCuentas: TObjectList<TCambiosDeCuentas>;
  end;

implementation

end.
