unit Anovo.Services.Reportes;

// Servicio de reportes: cada paso del flujo cuenta en el dia en que ocurrio.
// Mismas columnas por asesor, tipo y mes, comparacion con el periodo anterior
// y las cotizaciones detras de cada fila. Sin reportes.ver, solo lo propio.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  Anovo.DTOs.Cotizaciones,
  Anovo.DTOs.Reportes,
  Anovo.Repositories.Intf.Empresa,
  Anovo.Repositories.Intf.Reportes,
  Anovo.Services.Intf.Permisos,
  Anovo.Services.Intf.Reportes;

type
  TReporteService = class(TInterfacedObject, IReporteService)
  private
    fRepo: IReporteRepository;
    fEmpresa: IEmpresaRepository;
    fPermisos: IPermisoService;
    function FiltroUsuario(const AUsuarioId: Integer;
      const ARoles: TArray<string>): Integer;
    procedure Resumir(const ADesde, AHasta: TDateTime;
      const AFiltroUsuario: Integer; const AResumen: TReporteResumenDTO);
    procedure LlenarEmpresa(const AReporte: TReporteCotizacionesDTO);
  public
    [MVCInject]
    constructor Create(ARepo: IReporteRepository; AEmpresa: IEmpresaRepository;
      APermisos: IPermisoService); reintroduce;
    function Cotizaciones(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer; const ARoles: TArray<string>)
      : TReporteCotizacionesDTO;
    function Detalle(const ADesde, AHasta: TDateTime;
      const AVista, AClave: string; const AUsuarioId: Integer;
      const ARoles: TArray<string>): TObjectList<TCotizacionDTO>;
  end;

const
  VISTA_ESTADO = 'estado';
  VISTA_ASESOR = 'asesor';
  VISTA_TIPO = 'tipo';
  VISTA_MES = 'mes';
  VISTA_CLIENTE = 'cliente';
  DETALLE_MAXIMO = 500;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  System.Math,
  System.Generics.Defaults,
  Anovo.DTOs.Dashboard,
  Anovo.Entities.Consultas,
  Anovo.Entities.Empresa,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Permisos,
  Anovo.Services.Cotizaciones,
  Anovo.Textos;

const
  ORDEN_ESTADOS: array [0 .. 7] of string = (ESTADO_BORRADOR,
    ESTADO_PENDIENTE, ESTADO_DEVUELTA, ESTADO_VISTO_BUENO, ESTADO_ENVIADA,
    ESTADO_APROBADA, ESTADO_RECHAZADA, ESTADO_DESCARTADA);
  MESES_SIN_HUECOS = 36;

function EsEnvio(const AFila: TCotizacionesDia): Boolean;
begin
  Result := AFila.Estado.ValueOrDefault = ESTADO_ENVIADA;
end;

function DescartadasDe(const AFila: TCotizacionesDia): Integer;
begin
  if AFila.Estado.ValueOrDefault = ESTADO_DESCARTADA then
    Result := AFila.Cantidad.ValueOrDefault
  else
    Result := 0;
end;

function EsDelCliente(const AFila: TCotizacionesDia): Boolean;
begin
  Result := EsEnvio(AFila) or (AFila.Aprobadas.ValueOrDefault > 0) or
    (AFila.Rechazadas.ValueOrDefault > 0) or (DescartadasDe(AFila) > 0);
end;

function EnviadasDe(const AFila: TCotizacionesDia): Integer;
begin
  if EsEnvio(AFila) then
    Result := AFila.Cantidad.ValueOrDefault
  else
    Result := 0;
end;

function MontoEnviadoDe(const AFila: TCotizacionesDia): Currency;
begin
  if EsEnvio(AFila) then
    Result := AFila.MontoTotal.ValueOrDefault
  else
    Result := 0;
end;

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

function ClaveMes(const AAnio, AMes: Integer): Integer;
begin
  Result := AAnio * 100 + AMes;
end;

procedure Acumular(const ADestino: TReporteFilaDTO;
  const AFila: TCotizacionesDia);
begin
  ADestino.Cantidad := ADestino.Cantidad + EnviadasDe(AFila);
  ADestino.Aprobadas := ADestino.Aprobadas + AFila.Aprobadas.ValueOrDefault;
  ADestino.Rechazadas := ADestino.Rechazadas + AFila.Rechazadas.ValueOrDefault;
  ADestino.Descartadas := ADestino.Descartadas + DescartadasDe(AFila);
  ADestino.MontoAprobado := ADestino.MontoAprobado.ValueOrDefault +
    AFila.MontoAprobado.ValueOrDefault;
  ADestino.MontoTotal := ADestino.MontoTotal.ValueOrDefault +
    MontoEnviadoDe(AFila);
end;

procedure CerrarTasa(const AFila: TReporteFilaDTO);
begin
  AFila.TasaAprobacion := Tasa(AFila.Aprobadas, AFila.Rechazadas);
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
      if not EsDelCliente(lFila) then
        Continue;
      if not lPorClave.TryGetValue(lFila.AsesorId.ValueOrDefault, lAsesor) then
      begin
        lAsesor := TReporteAsesorDTO.Create;
        ALista.Add(lAsesor);
        lAsesor.AsesorId := lFila.AsesorId.ValueOrDefault;
        lAsesor.AsesorNombre := lFila.AsesorNombre.ValueOrDefault;
        lPorClave.Add(lAsesor.AsesorId, lAsesor);
      end;
      Acumular(lAsesor, lFila);
    end;
  finally
    lPorClave.Free;
  end;
  for lAsesor in ALista do
    CerrarTasa(lAsesor);
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
      if not EsDelCliente(lFila) then
        Continue;
      if not lPorClave.TryGetValue(lFila.TipoTrabajoId.ValueOrDefault,
        lTipo) then
      begin
        lTipo := TReporteTipoDTO.Create;
        ALista.Add(lTipo);
        lTipo.TipoTrabajoId := lFila.TipoTrabajoId;
        lTipo.TipoTrabajoNombre := lFila.TipoTrabajoNombre.ValueOrDefault;
        lPorClave.Add(lFila.TipoTrabajoId.ValueOrDefault, lTipo);
      end;
      Acumular(lTipo, lFila);
    end;
  finally
    lPorClave.Free;
  end;
  for lTipo in ALista do
  begin
    CerrarTasa(lTipo);
    if lTipo.TipoTrabajoNombre.IsEmpty then
      lTipo.TipoTrabajoNombre := SSinTipoTrabajo;
  end;
  ALista.Sort(TComparer<TReporteTipoDTO>.Construct(
    function(const A, B: TReporteTipoDTO): Integer
    begin
      Result := B.Cantidad - A.Cantidad;
      if Result = 0 then
        Result := CompareText(A.TipoTrabajoNombre, B.TipoTrabajoNombre);
    end));
end;

procedure SumarMeses(const AFilas: TObjectList<TCotizacionesDia>;
  const ADesde, AHasta: TDateTime; const ALista: TObjectList<TReporteMesDTO>);
var
  lFila: TCotizacionesDia;
  lPorClave: TDictionary<Integer, TReporteMesDTO>;
  lMes: TReporteMesDTO;
  lClave, lPrimera, lUltima: Integer;
  lFecha: TDateTime;
begin
  lPorClave := TDictionary<Integer, TReporteMesDTO>.Create;
  try
    for lFila in AFilas do
    begin
      if not EsDelCliente(lFila) then
        Continue;
      lClave := ClaveMes(lFila.Anio.ValueOrDefault, lFila.Mes.ValueOrDefault);
      if not lPorClave.TryGetValue(lClave, lMes) then
      begin
        lMes := TReporteMesDTO.Create;
        ALista.Add(lMes);
        lMes.Anio := lFila.Anio.ValueOrDefault;
        lMes.Mes := lFila.Mes.ValueOrDefault;
        lPorClave.Add(lClave, lMes);
      end;
      Acumular(lMes, lFila);
    end;

    if (YearOf(AHasta) * 12 + MonthOf(AHasta)) -
      (YearOf(ADesde) * 12 + MonthOf(ADesde)) < MESES_SIN_HUECOS then
    begin
      lPrimera := ClaveMes(YearOf(ADesde), MonthOf(ADesde));
      lUltima := ClaveMes(YearOf(AHasta), MonthOf(AHasta));
    end
    else
    begin
      lPrimera := MaxInt;
      lUltima := 0;
      for lClave in lPorClave.Keys do
      begin
        lPrimera := Min(lPrimera, lClave);
        lUltima := Max(lUltima, lClave);
      end;
    end;
    if lUltima > 0 then
    begin
      lFecha := EncodeDate(lPrimera div 100, lPrimera mod 100, 1);
      while ClaveMes(YearOf(lFecha), MonthOf(lFecha)) <= lUltima do
      begin
        lClave := ClaveMes(YearOf(lFecha), MonthOf(lFecha));
        if not lPorClave.ContainsKey(lClave) then
        begin
          lMes := TReporteMesDTO.Create;
          ALista.Add(lMes);
          lMes.Anio := YearOf(lFecha);
          lMes.Mes := MonthOf(lFecha);
          lPorClave.Add(lClave, lMes);
        end;
        lFecha := IncMonth(lFecha);
      end;
    end;
  finally
    lPorClave.Free;
  end;
  for lMes in ALista do
    CerrarTasa(lMes);
  ALista.Sort(TComparer<TReporteMesDTO>.Construct(
    function(const A, B: TReporteMesDTO): Integer
    begin
      Result := ClaveMes(A.Anio, A.Mes) - ClaveMes(B.Anio, B.Mes);
    end));
end;

procedure SumarClientes(const AFilas: TObjectList<TClientesRespuesta>;
  const ALista: TObjectList<TReporteClienteDTO>);
var
  lFila: TClientesRespuesta;
  lPorClave: TDictionary<Integer, TReporteClienteDTO>;
  lCliente: TReporteClienteDTO;
  lEstado: string;
  lVencida: Boolean;
begin
  lPorClave := TDictionary<Integer, TReporteClienteDTO>.Create;
  try
    for lFila in AFilas do
    begin
      if not lPorClave.TryGetValue(lFila.ClienteId.ValueOrDefault, lCliente) then
      begin
        lCliente := TReporteClienteDTO.Create;
        ALista.Add(lCliente);
        lCliente.ClienteId := lFila.ClienteId.ValueOrDefault;
        lCliente.ClienteNombre := lFila.ClienteNombre.ValueOrDefault;
        lPorClave.Add(lCliente.ClienteId, lCliente);
      end;
      lCliente.Enviadas := lCliente.Enviadas + 1;
      if (not lCliente.UltimoEnvio.HasValue) or
        (lFila.FechaEnvio.ValueOrDefault > lCliente.UltimoEnvio.Value) then
        lCliente.UltimoEnvio := lFila.FechaEnvio;
      lEstado := lFila.Estado.ValueOrDefault;
      lVencida := (lEstado = ESTADO_ENVIADA) and
        (IncDay(lFila.FechaEnvio.ValueOrDefault,
        lFila.DiasSinRespuesta.ValueOrDefault) < Now);
      if lEstado = ESTADO_APROBADA then
        lCliente.Aprobadas := lCliente.Aprobadas + 1
      else if lEstado = ESTADO_RECHAZADA then
        lCliente.Rechazadas := lCliente.Rechazadas + 1
      else if (lEstado = ESTADO_DESCARTADA) or lVencida then
      begin
        lCliente.SinRespuesta := lCliente.SinRespuesta + 1;
        lCliente.MontoSinRespuesta := lCliente.MontoSinRespuesta.ValueOrDefault
          + lFila.MontoTotal.ValueOrDefault;
      end
      else
        lCliente.EnEspera := lCliente.EnEspera + 1;
    end;
  finally
    lPorClave.Free;
  end;
  for lCliente in ALista do
    lCliente.PorcentajeSinRespuesta :=
      Round(lCliente.SinRespuesta * 100 / lCliente.Enviadas);
  ALista.Sort(TComparer<TReporteClienteDTO>.Construct(
    function(const A, B: TReporteClienteDTO): Integer
    begin
      Result := B.SinRespuesta - A.SinRespuesta;
      if Result = 0 then
        Result := B.PorcentajeSinRespuesta - A.PorcentajeSinRespuesta;
      if Result = 0 then
        Result := CompareText(A.ClienteNombre, B.ClienteNombre);
    end));
end;

procedure PeriodoAnterior(const ADesde, AHasta: TDateTime;
  out AAntesDesde, AAntesHasta: TDateTime);
var
  lMeses: Integer;
begin
  if DayOf(ADesde) = 1 then
  begin
    lMeses := (YearOf(AHasta) * 12 + MonthOf(AHasta)) -
      (YearOf(ADesde) * 12 + MonthOf(ADesde)) + 1;
    AAntesDesde := IncMonth(ADesde, -lMeses);
    AAntesHasta := IncMonth(AHasta, -lMeses);
  end
  else
  begin
    AAntesHasta := IncDay(ADesde, -1);
    AAntesDesde := IncDay(AAntesHasta, -DaysBetween(ADesde, AHasta));
  end;
end;

constructor TReporteService.Create(ARepo: IReporteRepository;
  AEmpresa: IEmpresaRepository; APermisos: IPermisoService);
begin
  inherited Create;
  fRepo := ARepo;
  fEmpresa := AEmpresa;
  fPermisos := APermisos;
end;

function TReporteService.FiltroUsuario(const AUsuarioId: Integer;
  const ARoles: TArray<string>): Integer;
begin
  if fPermisos.TieneAlguno(AUsuarioId, ARoles, [PERMISO_REPORTES_VER]) then
    Result := 0
  else
    Result := AUsuarioId;
end;

procedure TReporteService.Resumir(const ADesde, AHasta: TDateTime;
  const AFiltroUsuario: Integer; const AResumen: TReporteResumenDTO);
var
  lFilas: TObjectList<TCotizacionesDia>;
  lFila: TCotizacionesDia;
  lSumaDias, lConRespuesta: Integer;
begin
  AResumen.Desde := ADesde;
  AResumen.Hasta := AHasta;
  lFilas := fRepo.DiasEntre(ADesde, IncDay(AHasta, 1), AFiltroUsuario);
  try
    lSumaDias := 0;
    lConRespuesta := 0;
    for lFila in lFilas do
    begin
      AResumen.Total := AResumen.Total + EnviadasDe(lFila);
      AResumen.MontoTotal := AResumen.MontoTotal + MontoEnviadoDe(lFila);
      AResumen.Aprobadas := AResumen.Aprobadas +
        lFila.Aprobadas.ValueOrDefault;
      AResumen.MontoAprobado := AResumen.MontoAprobado +
        lFila.MontoAprobado.ValueOrDefault;
      AResumen.Rechazadas := AResumen.Rechazadas +
        lFila.Rechazadas.ValueOrDefault;
      AResumen.Descartadas := AResumen.Descartadas + DescartadasDe(lFila);
      Inc(lSumaDias, lFila.SumaDiasRespuesta.ValueOrDefault);
      Inc(lConRespuesta, lFila.ConRespuesta.ValueOrDefault);
    end;
    if lConRespuesta > 0 then
      AResumen.RespuestaMedia := lSumaDias div lConRespuesta;
    AResumen.TasaAprobacion := Tasa(AResumen.Aprobadas, AResumen.Rechazadas);

    if AResumen is TReporteCotizacionesDTO then
    begin
      SumarEstados(lFilas, TReporteCotizacionesDTO(AResumen).PorEstado);
      SumarAsesores(lFilas, TReporteCotizacionesDTO(AResumen).PorAsesor);
      SumarTipos(lFilas, TReporteCotizacionesDTO(AResumen).PorTipo);
      SumarMeses(lFilas, ADesde, AHasta,
        TReporteCotizacionesDTO(AResumen).PorMes);
    end;
  finally
    lFilas.Free;
  end;
end;

procedure TReporteService.LlenarEmpresa(const AReporte
  : TReporteCotizacionesDTO);
var
  lEmpresa: TEmpresa;
  lTelefono: string;
begin
  lEmpresa := fEmpresa.GetByPK(EMPRESA_ID, False);
  if lEmpresa = nil then
    Exit;
  try
    AReporte.EmpresaRazonSocial := lEmpresa.RazonSocial;
    AReporte.EmpresaCedula := lEmpresa.CedulaJuridica;
    lTelefono := lEmpresa.TelefonoFijo.ValueOrDefault;
    if lTelefono.IsEmpty then
      lTelefono := lEmpresa.Celular.ValueOrDefault;
    AReporte.EmpresaTelefono := lTelefono;
    AReporte.EmpresaCorreo := lEmpresa.Correo.ValueOrDefault;
  finally
    lEmpresa.Free;
  end;
end;

function TReporteService.Cotizaciones(const ADesde, AHasta: TDateTime;
  const AUsuarioId: Integer; const ARoles: TArray<string>)
  : TReporteCotizacionesDTO;
var
  lEnviadas: TObjectList<TClientesRespuesta>;
  lFiltroUsuario: Integer;
  lAntesDesde, lAntesHasta: TDateTime;
begin
  if DateOf(ADesde) > DateOf(AHasta) then
    raise EDatoInvalido.Create(SReporteRangoInvalido);

  lFiltroUsuario := FiltroUsuario(AUsuarioId, ARoles);

  Result := TReporteCotizacionesDTO.Create;
  try
    Resumir(DateOf(ADesde), DateOf(AHasta), lFiltroUsuario, Result);
    PeriodoAnterior(Result.Desde, Result.Hasta, lAntesDesde, lAntesHasta);
    Resumir(lAntesDesde, lAntesHasta, lFiltroUsuario, Result.Anterior);

    lEnviadas := fRepo.EnviadasEntre(Result.Desde, IncDay(Result.Hasta, 1),
      lFiltroUsuario);
    try
      SumarClientes(lEnviadas, Result.PorCliente);
    finally
      lEnviadas.Free;
    end;
    LlenarEmpresa(Result);
  except
    Result.Free;
    raise;
  end;
end;

function TReporteService.Detalle(const ADesde, AHasta: TDateTime;
  const AVista, AClave: string; const AUsuarioId: Integer;
  const ARoles: TArray<string>): TObjectList<TCotizacionDTO>;
var
  lFiltro: TFiltroDetalleReporte;
  lClave: Integer;
  lInicioMes: TDateTime;
  lVistas: TObjectList<TCotizacionConNombres>;
  lVista: TCotizacionConNombres;
begin
  if DateOf(ADesde) > DateOf(AHasta) then
    raise EDatoInvalido.Create(SReporteRangoInvalido);

  lFiltro := Default(TFiltroDetalleReporte);
  lFiltro.Desde := DateOf(ADesde);
  lFiltro.Hasta := IncDay(DateOf(AHasta), 1);
  lFiltro.UsuarioPropio := FiltroUsuario(AUsuarioId, ARoles);

  if SameText(AVista, VISTA_ESTADO) then
  begin
    if OrdenEstado(AClave) = Length(ORDEN_ESTADOS) then
      raise EDatoInvalido.Create(SReporteClaveInvalida);
    lFiltro.Estado := AClave;
  end
  else if SameText(AVista, VISTA_TIPO) then
  begin
    if not TryStrToInt(AClave, lClave) then
      raise EDatoInvalido.Create(SReporteClaveInvalida);
    lFiltro.FiltraTipo := True;
    lFiltro.TipoTrabajoId := lClave;
  end
  else
  begin
    if not TryStrToInt(AClave, lClave) or (lClave <= 0) then
      raise EDatoInvalido.Create(SReporteClaveInvalida);
    if SameText(AVista, VISTA_ASESOR) then
      lFiltro.AsesorId := lClave
    else if SameText(AVista, VISTA_CLIENTE) then
    begin
      lFiltro.ClienteId := lClave;
      lFiltro.PorEnvio := True;
    end
    else if SameText(AVista, VISTA_MES) then
    begin
      if not TryEncodeDate(lClave div 100, lClave mod 100, 1, lInicioMes) then
        raise EDatoInvalido.Create(SReporteClaveInvalida);
      lFiltro.Desde := Max(lFiltro.Desde, lInicioMes);
      lFiltro.Hasta := Min(lFiltro.Hasta, IncMonth(lInicioMes));
    end
    else
      raise EDatoInvalido.Create(SReporteVistaInvalida);
  end;

  lVistas := fRepo.Detalle(lFiltro, DETALLE_MAXIMO);
  try
    Result := TObjectList<TCotizacionDTO>.Create(True);
    try
      for lVista in lVistas do
        Result.Add(TMapeo.ADto<TCotizacionDTO>(lVista));
      Result.Sort(TComparer<TCotizacionDTO>.Construct(
        function(const A, B: TCotizacionDTO): Integer
        begin
          Result := B.Numero - A.Numero;
        end));
    except
      Result.Free;
      raise;
    end;
  finally
    lVistas.Free;
  end;
end;

end.
