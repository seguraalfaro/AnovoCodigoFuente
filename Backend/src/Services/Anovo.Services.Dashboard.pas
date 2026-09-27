unit Anovo.Services.Dashboard;

// Servicio de dashboards: arma las cifras y la lista de cada rol.

interface

uses
  MVCFramework,
  Anovo.DTOs.Dashboard,
  Anovo.Repositories.Intf.Dashboard,
  Anovo.Services.Intf.Dashboard;

type
  TDashboardService = class(TInterfacedObject, IDashboardService)
  private
    fRepo: IDashboardRepository;
  public
    [MVCInject]
    constructor Create(ARepo: IDashboardRepository); reintroduce;
    function DelAsesor(const AAsesorId: Integer): TDashboardAsesorDTO;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections,
  Anovo.Entities.Vistas.Dashboard,
  Anovo.Mapeo;

constructor TDashboardService.Create(ARepo: IDashboardRepository);
begin
  inherited Create;
  fRepo := ARepo;
end;

function TDashboardService.DelAsesor(const AAsesorId: Integer)
  : TDashboardAsesorDTO;
var
  lCifras: TCifrasAsesor;
  lFilas: TObjectList<TSolicitudAsesorVista>;
begin
  Result := TDashboardAsesorDTO.Create;
  try
    Result.Desde := StartOfTheMonth(Date);
    Result.Hasta := IncMonth(Result.Desde, 1);

    lCifras := fRepo.CifrasAsesor(AAsesorId, Result.Desde, Result.Hasta);
    Result.SolicitudesMes := lCifras.SolicitudesMes;
    Result.EsperandoCotizacion := lCifras.EsperandoCotizacion;
    Result.AprobadasMes := lCifras.AprobadasMes;
    Result.MontoAprobadoMes := lCifras.MontoAprobadoMes;

    lFilas := fRepo.RecientesAsesor(AAsesorId, StartOfTheWeek(Date),
      IncDay(StartOfTheWeek(Date), 7));
    try
      Result.Recientes.Free;
      Result.Recientes := TMapeo.AListaDto<TSolicitudAsesorVista,
        TSolicitudAsesorDTO>(lFilas);
    finally
      lFilas.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

end.
