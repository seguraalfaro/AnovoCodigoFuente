unit Anovo.Repositories.Intf.Dashboard;

// Contrato del repositorio de dashboards.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Solicitudes,
  Anovo.Entities.Vistas.Dashboard;

type
  IDashboardRepository = interface(IMVCRepository<TSolicitudes>)
    ['{13AD56E7-B2B7-49C8-A1FB-3DFFA6145C3A}']
    function CifrasAsesor(const AAsesorId: Integer;
      const ADesde, AHasta: TDateTime): TCifrasAsesorVista;
    function RecientesAsesor(const AAsesorId: Integer;
      const ADesde, AHasta: TDateTime): TObjectList<TSolicitudAsesorVista>;
    function CifrasAsistente(const AUsuarioId: Integer): TCifrasAsistenteVista;
    function ColaPorCotizar: TObjectList<TSolicitudPorCotizarVista>;
    function CifrasSupervisor(const AUsuarioId: Integer;
      const ADesde, AHasta: TDateTime): TCifrasSupervisorVista;
    function ColaPorAprobar(const AUsuarioId: Integer)
      : TObjectList<TCotizacionPorAprobarVista>;
  end;

implementation

end.
