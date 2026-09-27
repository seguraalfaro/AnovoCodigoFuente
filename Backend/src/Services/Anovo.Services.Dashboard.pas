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
    function DelAsistente(const AUsuarioId: Integer): TDashboardAsistenteDTO;
    function DelSupervisor(const AUsuarioId: Integer)
      : TDashboardSupervisorDTO;
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
  lCifras: TCifrasAsesorVista;
  lFilas: TObjectList<TSolicitudAsesorVista>;
begin
  Result := TDashboardAsesorDTO.Create;
  try
    Result.Desde := StartOfTheMonth(Date);
    Result.Hasta := IncMonth(Result.Desde, 1);

    lCifras := fRepo.CifrasAsesor(AAsesorId, Result.Desde, Result.Hasta);
    try
      TMapeo.Copiar(lCifras, Result);
    finally
      lCifras.Free;
    end;

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

function TDashboardService.DelAsistente(const AUsuarioId: Integer)
  : TDashboardAsistenteDTO;
var
  lCifras: TCifrasAsistenteVista;
  lFilas: TObjectList<TSolicitudPorCotizarVista>;
begin
  Result := TDashboardAsistenteDTO.Create;
  try
    lCifras := fRepo.CifrasAsistente(AUsuarioId);
    try
      TMapeo.Copiar(lCifras, Result);
    finally
      lCifras.Free;
    end;

    lFilas := fRepo.ColaPorCotizar;
    try
      Result.Cola.Free;
      Result.Cola := TMapeo.AListaDto<TSolicitudPorCotizarVista,
        TSolicitudPorCotizarDTO>(lFilas);
    finally
      lFilas.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TDashboardService.DelSupervisor(const AUsuarioId: Integer)
  : TDashboardSupervisorDTO;
var
  lCifras: TCifrasSupervisorVista;
  lFilas: TObjectList<TCotizacionPorAprobarVista>;
begin
  Result := TDashboardSupervisorDTO.Create;
  try
    Result.Desde := StartOfTheMonth(Date);
    Result.Hasta := IncMonth(Result.Desde, 1);

    lCifras := fRepo.CifrasSupervisor(AUsuarioId, Result.Desde, Result.Hasta);
    try
      TMapeo.Copiar(lCifras, Result);
    finally
      lCifras.Free;
    end;

    lFilas := fRepo.ColaPorAprobar(AUsuarioId);
    try
      Result.Cola.Free;
      Result.Cola := TMapeo.AListaDto<TCotizacionPorAprobarVista,
        TCotizacionPorAprobarDTO>(lFilas);
    finally
      lFilas.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

end.
