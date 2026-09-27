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
      const ADesde, AHasta: TDateTime): TCifrasAsesor;
    function RecientesAsesor(const AAsesorId: Integer;
      const ADesde, AHasta: TDateTime): TObjectList<TSolicitudAsesorVista>;
  end;

implementation

uses
  Data.DB,
  MVCFramework.ActiveRecord,
  Anovo.SQL.Dashboard;

function TDashboardRepository.CifrasAsesor(const AAsesorId: Integer;
  const ADesde, AHasta: TDateTime): TCifrasAsesor;
var
  lDatos: TDataSet;
begin
  lDatos := TMVCActiveRecord.SelectDataSet(DASHBOARD_ASESOR_CIFRAS,
    [AAsesorId, ADesde, AHasta, AAsesorId, AAsesorId, ADesde, AHasta,
    AAsesorId, ADesde, AHasta]);
  try
    Result.SolicitudesMes := lDatos.FieldByName('SOLICITUDES_MES').AsInteger;
    Result.EsperandoCotizacion :=
      lDatos.FieldByName('ESPERANDO_COTIZACION').AsInteger;
    Result.AprobadasMes := lDatos.FieldByName('APROBADAS_MES').AsInteger;
    Result.MontoAprobadoMes :=
      lDatos.FieldByName('MONTO_APROBADO_MES').AsCurrency;
  finally
    lDatos.Free;
  end;
end;

function TDashboardRepository.RecientesAsesor(const AAsesorId: Integer;
  const ADesde, AHasta: TDateTime): TObjectList<TSolicitudAsesorVista>;
begin
  Result := TMVCActiveRecord.Select<TSolicitudAsesorVista>
    (DASHBOARD_ASESOR_RECIENTES, [AAsesorId, ADesde, AHasta]);
end;

end.
