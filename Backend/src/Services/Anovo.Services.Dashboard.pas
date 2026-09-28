unit Anovo.Services.Dashboard;

// Servicio de dashboards: copia las vistas de totales a los DTO y calcula
// la tasa de aprobacion, que es regla de negocio.

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
    procedure Periodo(out ADesde, AHasta: TDateTime);
  public
    [MVCInject]
    constructor Create(ARepo: IDashboardRepository); reintroduce;
    function DelAsesor(const AAsesorId: Integer): TDashboardAsesorDTO;
    function DelAsistente(const AUsuarioId: Integer): TDashboardAsistenteDTO;
    function DelSupervisor(const AUsuarioId: Integer)
      : TDashboardSupervisorDTO;
    function DelGerencia: TDashboardGerenciaDTO;
    function DelCuentas: TDashboardCuentasDTO;
    function DelAvisos(const AUsuarioId: Integer;
      const APuedeAprobar, APuedeElaborar: Boolean): TAvisosDTO;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections,
  MVCFramework.ActiveRecord,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas,
  Anovo.Mapeo;

constructor TDashboardService.Create(ARepo: IDashboardRepository);
begin
  inherited Create;
  fRepo := ARepo;
end;

procedure TDashboardService.Periodo(out ADesde, AHasta: TDateTime);
var
  lPeriodo: TVPeriodoActual;
begin
  lPeriodo := fRepo.Periodo;
  try
    ADesde := lPeriodo.MesDesde.Value;
    AHasta := lPeriodo.MesHasta.Value;
  finally
    lPeriodo.Free;
  end;
end;

procedure Copiar(const AOrigen: TMVCActiveRecord; const ADestino: TObject);
begin
  if AOrigen = nil then
    Exit;
  try
    TMapeo.Copiar(AOrigen, ADestino);
  finally
    AOrigen.Free;
  end;
end;

function TDashboardService.DelAsesor(const AAsesorId: Integer)
  : TDashboardAsesorDTO;
var
  lDesde, lHasta: TDateTime;
  lFilas: TObjectList<TSeguimientoAsesor>;
begin
  Result := TDashboardAsesorDTO.Create;
  try
    Periodo(lDesde, lHasta);
    Result.Desde := lDesde;
    Result.Hasta := lHasta;
    Copiar(fRepo.AsesorMes(AAsesorId), Result);

    lFilas := fRepo.RecientesAsesor(AAsesorId, StartOfTheWeek(Date),
      IncDay(StartOfTheWeek(Date), 7));
    try
      Result.Recientes.Free;
      Result.Recientes := TMapeo.AListaDto<TSeguimientoAsesor,
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
  lFilas: TObjectList<TColaSolicitudes>;
begin
  Result := TDashboardAsistenteDTO.Create;
  try
    Copiar(fRepo.TrabajoDe(AUsuarioId), Result);

    lFilas := fRepo.ColaPorCotizar;
    try
      Result.Cola.Free;
      Result.Cola := TMapeo.AListaDto<TColaSolicitudes,
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
  lFilas: TObjectList<TBandejaCotizaciones>;
begin
  Result := TDashboardSupervisorDTO.Create;
  try
    Copiar(fRepo.ResumenMes, Result);
    Copiar(fRepo.TrabajoDe(AUsuarioId), Result);

    lFilas := fRepo.ColaPorAprobar(AUsuarioId);
    try
      Result.Cola.Free;
      Result.Cola := TMapeo.AListaDto<TBandejaCotizaciones,
        TCotizacionPorAprobarDTO>(lFilas);
    finally
      lFilas.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TDashboardService.DelGerencia: TDashboardGerenciaDTO;
var
  lProductividad: TObjectList<TAsesoresMes>;
  lEstados: TObjectList<TCotizacionesPorEstado>;
  lDecididas: Integer;
begin
  Result := TDashboardGerenciaDTO.Create;
  try
    Copiar(fRepo.ResumenMes, Result);

    lDecididas := Result.AprobadasMes + Result.RechazadasMes;
    if lDecididas > 0 then
      Result.TasaAprobacion := Round(Result.AprobadasMes * 100 / lDecididas);

    lProductividad := fRepo.Productividad;
    try
      Result.Productividad.Free;
      Result.Productividad := TMapeo.AListaDto<TAsesoresMes,
        TProductividadAsesorDTO>(lProductividad);
    finally
      lProductividad.Free;
    end;

    lEstados := fRepo.CotizacionesPorEstado;
    try
      Result.Estados.Free;
      Result.Estados := TMapeo.AListaDto<TCotizacionesPorEstado,
        TCotizacionesPorEstadoDTO>(lEstados);
    finally
      lEstados.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TDashboardService.DelCuentas: TDashboardCuentasDTO;
var
  lDesde, lHasta: TDateTime;
  lCambios: TObjectList<TCambiosDeCuentas>;
begin
  Result := TDashboardCuentasDTO.Create;
  try
    Periodo(lDesde, lHasta);
    Result.Desde := lDesde;
    Result.Hasta := lHasta;
    Copiar(fRepo.CuentasResumen, Result);

    lCambios := fRepo.CambiosCuentas;
    try
      Result.Cambios.Free;
      Result.Cambios := TMapeo.AListaDto<TCambiosDeCuentas,
        TCambioCuentaDTO>(lCambios);
    finally
      lCambios.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TDashboardService.DelAvisos(const AUsuarioId: Integer;
  const APuedeAprobar, APuedeElaborar: Boolean): TAvisosDTO;
var
  lTrabajo: TTrabajoUsuario;
begin
  Result := TAvisosDTO.Create;
  try
    lTrabajo := fRepo.TrabajoDe(AUsuarioId);
    if lTrabajo = nil then
      Exit;
    try
      if APuedeAprobar then
        Result.PorAprobar := lTrabajo.PorAprobar.ValueOrDefault;
      if APuedeElaborar then
      begin
        Result.PorCotizar := lTrabajo.PorCotizar.ValueOrDefault;
        Result.MisBorradores := lTrabajo.MisBorradores.ValueOrDefault;
      end;
    finally
      lTrabajo.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

end.
