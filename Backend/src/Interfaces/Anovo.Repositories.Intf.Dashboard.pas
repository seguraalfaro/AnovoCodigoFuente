unit Anovo.Repositories.Intf.Dashboard;

// Contrato del repositorio de dashboards.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Solicitudes,
  Anovo.Entities.Vistas.Dashboard;

type
  TCifrasAsesor = record
    SolicitudesMes: Integer;
    EsperandoCotizacion: Integer;
    AprobadasMes: Integer;
    MontoAprobadoMes: Currency;
  end;

  IDashboardRepository = interface(IMVCRepository<TSolicitudes>)
    ['{13AD56E7-B2B7-49C8-A1FB-3DFFA6145C3A}']
    function CifrasAsesor(const AAsesorId: Integer;
      const ADesde, AHasta: TDateTime): TCifrasAsesor;
    function RecientesAsesor(const AAsesorId: Integer;
      const ADesde, AHasta: TDateTime): TObjectList<TSolicitudAsesorVista>;
  end;

implementation

end.
