unit Anovo.Repositories.Dashboard;

// Repositorio de dashboards: cifras y listas por rol.

interface

uses
  System.Generics.Collections,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Dashboard,
  Anovo.Entities.Solicitudes,
  Anovo.Entities.Vistas.Dashboard;

type
  TDashboardRepository = class(TAnovoRepository<TSolicitudes>,
    IDashboardRepository)
  public
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

uses
  Anovo.SQL.Dashboard;

function TDashboardRepository.CifrasAsesor(const AAsesorId: Integer;
  const ADesde, AHasta: TDateTime): TCifrasAsesorVista;
begin
  Result := SelectUnaVista<TCifrasAsesorVista>(DASHBOARD_ASESOR_CIFRAS,
    [AAsesorId, ADesde, AHasta, AAsesorId, AAsesorId, ADesde, AHasta,
    AAsesorId, ADesde, AHasta]);
end;

function TDashboardRepository.RecientesAsesor(const AAsesorId: Integer;
  const ADesde, AHasta: TDateTime): TObjectList<TSolicitudAsesorVista>;
begin
  Result := SelectVista<TSolicitudAsesorVista>
    (DASHBOARD_ASESOR_RECIENTES, [AAsesorId, ADesde, AHasta]);
end;

function TDashboardRepository.CifrasAsistente(const AUsuarioId: Integer)
  : TCifrasAsistenteVista;
begin
  Result := SelectUnaVista<TCifrasAsistenteVista>(DASHBOARD_ASISTENTE_CIFRAS,
    [AUsuarioId, AUsuarioId, AUsuarioId]);
end;

function TDashboardRepository.ColaPorCotizar
  : TObjectList<TSolicitudPorCotizarVista>;
begin
  Result := SelectVista<TSolicitudPorCotizarVista>
    (DASHBOARD_ASISTENTE_COLA, []);
end;

function TDashboardRepository.CifrasSupervisor(const AUsuarioId: Integer;
  const ADesde, AHasta: TDateTime): TCifrasSupervisorVista;
begin
  Result := SelectUnaVista<TCifrasSupervisorVista>(DASHBOARD_SUPERVISOR_CIFRAS,
    [AUsuarioId, AUsuarioId, ADesde, AHasta, ADesde, AHasta, ADesde, AHasta]);
end;

function TDashboardRepository.ColaPorAprobar(const AUsuarioId: Integer)
  : TObjectList<TCotizacionPorAprobarVista>;
begin
  Result := SelectVista<TCotizacionPorAprobarVista>
    (DASHBOARD_SUPERVISOR_COLA, [AUsuarioId]);
end;

end.
