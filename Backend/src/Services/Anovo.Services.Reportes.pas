unit Anovo.Services.Reportes;

// Servicio de reportes: suma por estado, asesor, tipo y mes las filas por
// dia del periodo y calcula las tasas de aprobacion.

interface

uses
  MVCFramework,
  Anovo.DTOs.Reportes,
  Anovo.Repositories.Intf.Reportes,
  Anovo.Services.Intf.Reportes;

type
  TReporteService = class(TInterfacedObject, IReporteService)
  private
    fRepo: IReporteRepository;
  public
    [MVCInject]
    constructor Create(ARepo: IReporteRepository); reintroduce;
    function Cotizaciones(const ADesde, AHasta: TDateTime)
      : TReporteCotizacionesDTO;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  Anovo.DTOs.Dashboard,
  Anovo.Entities.Consultas,
  Anovo.Errors,
  Anovo.Services.Cotizaciones,
  Anovo.Textos;

const
  ORDEN_ESTADOS: array [0 .. 3] of string = (ESTADO_BORRADOR,
    ESTADO_PENDIENTE, ESTADO_APROBADA, ESTADO_ENVIADA);

function Tasa(const AAprobadas, ARechazadas: Integer): Integer;
begin
  if AAprobadas + ARechazadas = 0 then
    Exit(0);
  Result := Round(AAprobadas * 100 / (AAprobadas + ARechazadas));
end;

function OrdenEstado(const AEstado: string): Integer;
begin
  for Result := Low(ORDEN_ESTADOS) to High(ORDEN_ESTADOS) do
    if ORDEN_ESTADOS[Result] = AEstado then
      Exit;
  Result := Length(ORDEN_ESTADOS);
end;

function CompararMonto(const A, B: Currency): Integer;
begin
  if A < B then
    Result := -1
  else if A > B then
    Result := 1
  else
    Result := 0;
end;

procedure SumarEstados(const AFilas: TObjectList<TCotizacionesDia>;
  const ALista: TObjectList<TCotizacionesPorEstadoDTO>);
var
  lFila: TCotizacionesDia;
  lPorClave: TDictionary<string, TCotizacionesPorEstadoDTO>;
  lEstado: TCotizacionesPorEstadoDTO;
begin
  lPorClave := TDictionary<string, TCotizacionesPorEstadoDTO>.Create;
  try
    for lFila in AFilas do
    begin
      if not lPorClave.TryGetValue(lFila.Estado.ValueOrDefault, lEstado) then
      begin
        lEstado := TCotizacionesPorEstadoDTO.Create;
        ALista.Add(lEstado);
        lEstado.Estado := lFila.Estado.ValueOrDefault;
        lPorClave.Add(lEstado.Estado, lEstado);
      end;
      lEstado.Cantidad := lEstado.Cantidad + lFila.Cantidad.ValueOrDefault;
      lEstado.Monto := lEstado.Monto.ValueOrDefault +
        lFila.MontoTotal.ValueOrDefault;
    end;
  finally
    lPorClave.Free;
  end;
  ALista.Sort(TComparer<TCotizacionesPorEstadoDTO>.Construct(
    function(const A, B: TCotizacionesPorEstadoDTO): Integer
    begin
      Result := OrdenEstado(A.Estado) - OrdenEstado(B.Estado);
    end));
end;

procedure SumarAsesores(const AFilas: TObjectList<TCotizacionesDia>;
  const ALista: TObjectList<TReporteAsesorDTO>);
var
  lFila: TCotizacionesDia;
  lPorClave: TDictionary<Integer, TReporteAsesorDTO>;
  lAsesor: TReporteAsesorDTO;
begin
  lPorClave := TDictionary<Integer, TReporteAsesorDTO>.Create;
  try
    for lFila in AFilas do
    begin
      if not lPorClave.TryGetValue(lFila.AsesorId.ValueOrDefault, lAsesor) then
      begin
        lAsesor := TReporteAsesorDTO.Create;
        ALista.Add(lAsesor);
        lAsesor.AsesorId := lFila.AsesorId.ValueOrDefault;
        lAsesor.AsesorNombre := lFila.AsesorNombre.ValueOrDefault;
        lPorClave.Add(lAsesor.AsesorId, lAsesor);
      end;
      lAsesor.Cantidad := lAsesor.Cantidad + lFila.Cantidad.ValueOrDefault;
      lAsesor.Aprobadas := lAsesor.Aprobadas + lFila.Aprobadas.ValueOrDefault;
      lAsesor.Rechazadas := lAsesor.Rechazadas +
        lFila.Rechazadas.ValueOrDefault;
      lAsesor.MontoAprobado := lAsesor.MontoAprobado.ValueOrDefault +
        lFila.MontoAprobado.ValueOrDefault;
      lAsesor.MontoTotal := lAsesor.MontoTotal.ValueOrDefault +
        lFila.MontoTotal.ValueOrDefault;
    end;
  finally
    lPorClave.Free;
  end;
  for lAsesor in ALista do
    lAsesor.TasaAprobacion := Tasa(lAsesor.Aprobadas, lAsesor.Rechazadas);
  ALista.Sort(TComparer<TReporteAsesorDTO>.Construct(
    function(const A, B: TReporteAsesorDTO): Integer
    begin
      Result := CompararMonto(B.MontoAprobado.ValueOrDefault,
        A.MontoAprobado.ValueOrDefault);
      if Result = 0 then
        Result := CompareText(A.AsesorNombre, B.AsesorNombre);
    end));
end;

procedure SumarTipos(const AFilas: TObjectList<TCotizacionesDia>;
  const ALista: TObjectList<TReporteTipoDTO>);
var
  lFila: TCotizacionesDia;
  lPorClave: TDictionary<Integer, TReporteTipoDTO>;
  lTipo: TReporteTipoDTO;
begin
  lPorClave := TDictionary<Integer, TReporteTipoDTO>.Create;
  try
    for lFila in AFilas do
    begin
      if not lPorClave.TryGetValue(lFila.TipoTrabajoId.ValueOrDefault,
        lTipo) then
      begin
        lTipo := TReporteTipoDTO.Create;
        ALista.Add(lTipo);
        lTipo.TipoTrabajoId := lFila.TipoTrabajoId;
        lTipo.TipoTrabajoNombre := lFila.TipoTrabajoNombre.ValueOrDefault;
        lPorClave.Add(lFila.TipoTrabajoId.ValueOrDefault, lTipo);
      end;
      lTipo.Cantidad := lTipo.Cantidad + lFila.Cantidad.ValueOrDefault;
      lTipo.Aprobadas := lTipo.Aprobadas + lFila.Aprobadas.ValueOrDefault;
      lTipo.MontoTotal := lTipo.MontoTotal.ValueOrDefault +
        lFila.MontoTotal.ValueOrDefault;
    end;
  finally
    lPorClave.Free;
  end;
  ALista.Sort(TComparer<TReporteTipoDTO>.Construct(
    function(const A, B: TReporteTipoDTO): Integer
    begin
      Result := B.Cantidad - A.Cantidad;
      if Result = 0 then
        Result := CompareText(A.TipoTrabajoNombre, B.TipoTrabajoNombre);
    end));
  for lTipo in ALista do
    if lTipo.TipoTrabajoNombre.IsEmpty then
      lTipo.TipoTrabajoNombre := SSinTipoTrabajo;
end;

procedure SumarMeses(const AFilas: TObjectList<TCotizacionesDia>;
  const ALista: TObjectList<TReporteMesDTO>);
var
  lFila: TCotizacionesDia;
  lPorClave: TDictionary<Integer, TReporteMesDTO>;
  lMes: TReporteMesDTO;
  lClave: Integer;
begin
  lPorClave := TDictionary<Integer, TReporteMesDTO>.Create;
  try
    for lFila in AFilas do
    begin
      lClave := lFila.Anio.ValueOrDefault * 100 + lFila.Mes.ValueOrDefault;
      if not lPorClave.TryGetValue(lClave, lMes) then
      begin
        lMes := TReporteMesDTO.Create;
        ALista.Add(lMes);
        lMes.Anio := lFila.Anio.ValueOrDefault;
        lMes.Mes := lFila.Mes.ValueOrDefault;
        lPorClave.Add(lClave, lMes);
      end;
      lMes.Cantidad := lMes.Cantidad + lFila.Cantidad.ValueOrDefault;
      lMes.Aprobadas := lMes.Aprobadas + lFila.Aprobadas.ValueOrDefault;
      lMes.Rechazadas := lMes.Rechazadas + lFila.Rechazadas.ValueOrDefault;
      lMes.MontoTotal := lMes.MontoTotal.ValueOrDefault +
        lFila.MontoTotal.ValueOrDefault;
    end;
  finally
    lPorClave.Free;
  end;
  for lMes in ALista do
    lMes.TasaAprobacion := Tasa(lMes.Aprobadas, lMes.Rechazadas);
  ALista.Sort(TComparer<TReporteMesDTO>.Construct(
    function(const A, B: TReporteMesDTO): Integer
    begin
      Result := (A.Anio * 100 + A.Mes) - (B.Anio * 100 + B.Mes);
    end));
end;

constructor TReporteService.Create(ARepo: IReporteRepository);
begin
  inherited Create;
  fRepo := ARepo;
end;

function TReporteService.Cotizaciones(const ADesde, AHasta: TDateTime)
  : TReporteCotizacionesDTO;
var
  lFilas: TObjectList<TCotizacionesDia>;
  lFila: TCotizacionesDia;
  lSumaDias, lConRespuesta: Integer;
begin
  if DateOf(ADesde) > DateOf(AHasta) then
    raise EDatoInvalido.Create(SReporteRangoInvalido);

  Result := TReporteCotizacionesDTO.Create;
  try
    Result.Desde := DateOf(ADesde);
    Result.Hasta := DateOf(AHasta);

    lFilas := fRepo.DiasEntre(Result.Desde, IncDay(Result.Hasta, 1));
    try
      lSumaDias := 0;
      lConRespuesta := 0;
      for lFila in lFilas do
      begin
        Result.Total := Result.Total + lFila.Cantidad.ValueOrDefault;
        Result.MontoTotal := Result.MontoTotal +
          lFila.MontoTotal.ValueOrDefault;
        Result.Aprobadas := Result.Aprobadas + lFila.Aprobadas.ValueOrDefault;
        Result.Rechazadas := Result.Rechazadas +
          lFila.Rechazadas.ValueOrDefault;
        Inc(lSumaDias, lFila.SumaDiasRespuesta.ValueOrDefault);
        Inc(lConRespuesta, lFila.ConRespuesta.ValueOrDefault);
      end;
      if lConRespuesta > 0 then
        Result.RespuestaMedia := lSumaDias div lConRespuesta;
      Result.TasaAprobacion := Tasa(Result.Aprobadas, Result.Rechazadas);

      SumarEstados(lFilas, Result.PorEstado);
      SumarAsesores(lFilas, Result.PorAsesor);
      SumarTipos(lFilas, Result.PorTipo);
      SumarMeses(lFilas, Result.PorMes);
    finally
      lFilas.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

end.
