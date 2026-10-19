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
    procedure LlenarAsesor(const AAsesorId: Integer; const ADesde: TDateTime;
      const ADatos: TDashboardAsesorDTO);
    procedure LlenarAsistente(const AUsuarioId: Integer;
      const ADatos: TDashboardAsistenteDTO);
    procedure LlenarSupervisor(const ADatos: TDashboardSupervisorDTO);
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
  System.Math,
  System.Generics.Collections,
  MVCFramework.Nullables,
  MVCFramework.ActiveRecord,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas,
  Anovo.Mapeo,
  Anovo.Services.Cotizaciones,
  Anovo.Textos;

const
  ESTADO_SEG_DESCARTADA = 'descartada';
  AVISOS_MAXIMO = 6;
  FORMATO_MONTO = '#,##0';
  DIAS_ESTANCADA = 5;
  ETAPAS: array [0 .. 4] of string = (ESTADO_BORRADOR, ESTADO_PENDIENTE,
    ESTADO_DEVUELTA, ESTADO_VISTO_BUENO, ESTADO_ENVIADA);

function TextoEstado(const AEstado: string): string;
begin
  if AEstado = ESTADO_BORRADOR then
    Result := SEstBorrador
  else if AEstado = ESTADO_PENDIENTE then
    Result := SEstPendiente
  else if AEstado = ESTADO_DEVUELTA then
    Result := SEstDevuelta
  else if AEstado = ESTADO_VISTO_BUENO then
    Result := SEstVistoBueno
  else if AEstado = ESTADO_ENVIADA then
    Result := SEstEnviada
  else if AEstado = ESTADO_APROBADA then
    Result := SEstAprobada
  else if AEstado = ESTADO_RECHAZADA then
    Result := SEstRechazada
  else
    Result := AEstado;
end;

function GrupoDe(const AEstado: string; const AConCotizacion: Boolean): string;
var
  lEstado: string;
begin
  lEstado := AEstado;
  if (lEstado = ESTADO_SEG_DESCARTADA) and AConCotizacion then
    Exit(SGrupoSinRespuesta);
  if (lEstado = ESTADO_BORRADOR) or (lEstado = ESTADO_PENDIENTE) or
    (lEstado = ESTADO_DEVUELTA) or (lEstado = ESTADO_VISTO_BUENO) then
    Exit(SGrupoElaboracion);
  if lEstado = ESTADO_ENVIADA then
    Exit(SEstEnviada);
  if lEstado = ESTADO_APROBADA then
    Exit(SEstAprobada);
  if (lEstado = ESTADO_RECHAZADA) or (lEstado = ESTADO_SEG_DESCARTADA) then
    Exit(SEstRechazada);
  Result := SGrupoEsperando;
end;

procedure SumarBarra(const ALista: TObjectList<TDashboardBarraDTO>;
  const AClave, AEtiqueta: string; const ACantidad: Integer = 1);
var
  lBarra: TDashboardBarraDTO;
begin
  for lBarra in ALista do
    if lBarra.Clave = AClave then
    begin
      lBarra.Cantidad := lBarra.Cantidad + ACantidad;
      Exit;
    end;
  lBarra := TDashboardBarraDTO.Create;
  lBarra.Clave := AClave;
  lBarra.Etiqueta := AEtiqueta;
  lBarra.Cantidad := ACantidad;
  ALista.Add(lBarra);
end;

function Aviso(const AId, ANumero: Integer; const ACliente, AEstado,
  ADetalle: string; const ADias: Integer): TDashboardAvisoDTO;
begin
  Result := TDashboardAvisoDTO.Create;
  Result.CotizacionId := AId;
  Result.Numero := ANumero;
  Result.ClienteNombre := ACliente;
  Result.Estado := AEstado;
  Result.Detalle := ADetalle;
  Result.Dias := ADias;
end;

function Dato(const AConcepto, AValor: string): TDashboardDatoDTO;
begin
  Result := TDashboardDatoDTO.Create;
  Result.Concepto := AConcepto;
  Result.Valor := AValor;
end;

function Tasa(const AAprobadas, ARechazadas: Integer): Integer;
begin
  if AAprobadas + ARechazadas = 0 then
    Exit(0);
  Result := Round(AAprobadas * 100 / (AAprobadas + ARechazadas));
end;

function ValorDe(const APasos: TPasosDeUsuario;
  const ACampo: NullableInt32): Integer;
begin
  if APasos = nil then
    Exit(0);
  Result := ACampo.ValueOrDefault;
end;

function MontoDe(const APasos: TPasosDeUsuario): Currency;
begin
  if APasos = nil then
    Exit(0);
  Result := APasos.MontoAprobado.ValueOrDefault;
end;
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

procedure TDashboardService.LlenarAsesor(const AAsesorId: Integer;
  const ADesde: TDateTime; const ADatos: TDashboardAsesorDTO);
var
  lEstados: TObjectList<TEstadoDelAsesor>;
  lEstado: TEstadoDelAsesor;
  lMes: TSolicitudesDelMes;
  lEnviadas: TObjectList<TEnviadaSinRespuesta>;
  lEnviada: TEnviadaSinRespuesta;
  lGrupo: string;
  lAnterior: TDateTime;
  lAprobadas, lRechazadas: Integer;
begin
  lAprobadas := 0;
  lRechazadas := 0;
  lEstados := fRepo.EstadoDelAsesor(AAsesorId);
  try
    for lEstado in lEstados do
    begin
      lGrupo := GrupoDe(lEstado.Estado.ValueOrDefault,
        lEstado.ConCotizacion.ValueOrDefault);
      SumarBarra(ADatos.PorEstado, lGrupo, lGrupo,
        lEstado.Cantidad.ValueOrDefault);
      if lGrupo = SEstAprobada then
        Inc(lAprobadas, lEstado.Cantidad.ValueOrDefault)
      else if lGrupo = SEstRechazada then
        Inc(lRechazadas, lEstado.Cantidad.ValueOrDefault)
      else if lGrupo = SGrupoEsperando then
        ADatos.DiasMasAntigua := Max(ADatos.DiasMasAntigua,
          lEstado.DiasMasAntigua.ValueOrDefault);
    end;
  finally
    lEstados.Free;
  end;
  ADatos.TasaAprobacion := Tasa(lAprobadas, lRechazadas);

  lAnterior := IncMonth(ADesde, -1);
  lMes := fRepo.SolicitudesDelMes(AAsesorId, YearOf(lAnterior),
    MonthOf(lAnterior));
  if lMes <> nil then
    try
      ADatos.SolicitudesMesAnterior := lMes.Cantidad.ValueOrDefault;
    finally
      lMes.Free;
    end;

  lEnviadas := fRepo.EnviadasDeAsesor(AAsesorId, AVISOS_MAXIMO);
  try
    for lEnviada in lEnviadas do
      ADatos.PorLlamar.Add(Aviso(lEnviada.CotizacionId.ValueOrDefault,
        lEnviada.Numero.ValueOrDefault, lEnviada.ClienteNombre.ValueOrDefault,
        ESTADO_ENVIADA, '', lEnviada.Dias.ValueOrDefault));
  finally
    lEnviadas.Free;
  end;
end;

procedure TDashboardService.LlenarAsistente(const AUsuarioId: Integer;
  const ADatos: TDashboardAsistenteDTO);
var
  lEtapas: TObjectList<TEtapaDeUsuario>;
  lEtapa: TEtapaDeUsuario;
  lEnCurso: TObjectList<TCotizacionEnCurso>;
  lFila: TCotizacionEnCurso;
  lEnviadas: TObjectList<TEnviadaSinRespuesta>;
  lEnviada: TEnviadaSinRespuesta;
  lPasos: TPasosDeUsuario;
  lSolicitud: TSolicitudPorCotizarDTO;
  lDetalle, lClave: string;
  lDesde, lHasta: TDateTime;
begin
  for lClave in ETAPAS do
    SumarBarra(ADatos.PorEtapa, lClave, TextoEstado(lClave), 0);
  for lSolicitud in ADatos.Cola do
    ADatos.DiasMasAntigua := Max(ADatos.DiasMasAntigua,
      lSolicitud.DiasEspera.ValueOrDefault);

  lEtapas := fRepo.EtapasDe(AUsuarioId);
  try
    for lEtapa in lEtapas do
    begin
      lClave := lEtapa.Estado.ValueOrDefault;
      SumarBarra(ADatos.PorEtapa, lClave, TextoEstado(lClave),
        lEtapa.Cantidad.ValueOrDefault);
      if lClave = ESTADO_DEVUELTA then
        ADatos.Devueltas := lEtapa.Cantidad.ValueOrDefault;
    end;
  finally
    lEtapas.Free;
  end;

  lEnCurso := fRepo.ParaHoy(AUsuarioId, AVISOS_MAXIMO);
  try
    for lFila in lEnCurso do
    begin
      if lFila.Estado.ValueOrDefault = ESTADO_DEVUELTA then
        lDetalle := lFila.MotivoRechazo.ValueOrDefault
      else
        lDetalle := SAvisoPorEnviar;
      ADatos.ParaHoy.Add(Aviso(lFila.CotizacionId.ValueOrDefault,
        lFila.Numero.ValueOrDefault, lFila.ClienteNombre.ValueOrDefault,
        lFila.Estado.ValueOrDefault, lDetalle, lFila.Dias.ValueOrDefault));
    end;
  finally
    lEnCurso.Free;
  end;

  lEnviadas := fRepo.EnviadasDeElaborador(AUsuarioId);
  try
    for lEnviada in lEnviadas do
      if lEnviada.Dias.ValueOrDefault > lEnviada.DiasSinRespuesta.ValueOrDefault
      then
        ADatos.SinRespuesta := ADatos.SinRespuesta + 1;
  finally
    lEnviadas.Free;
  end;

  Periodo(lDesde, lHasta);
  lPasos := fRepo.PasosDe(AUsuarioId, YearOf(lDesde), MonthOf(lDesde));
  try
    ADatos.MiMes.Add(Dato(SDatoPresentadas,
      ValorDe(lPasos, lPasos.Presentadas).ToString));
    ADatos.MiMes.Add(Dato(SDatoAprobadas,
      ValorDe(lPasos, lPasos.Aprobadas).ToString));
    ADatos.MiMes.Add(Dato(SDatoRechazadas,
      ValorDe(lPasos, lPasos.Rechazadas).ToString));
    ADatos.MiMes.Add(Dato(SDatoTasa, Format(SDatoTasaValor,
      [Tasa(ValorDe(lPasos, lPasos.Aprobadas),
      ValorDe(lPasos, lPasos.Rechazadas))])));
    ADatos.MiMes.Add(Dato(SDatoMonto, Format(SDatoMontoValor,
      [FormatFloat(FORMATO_MONTO, MontoDe(lPasos))])));
  finally
    lPasos.Free;
  end;
end;

procedure TDashboardService.LlenarSupervisor(const ADatos
  : TDashboardSupervisorDTO);
var
  lMes, lAntes: TPasosDelEquipo;
  lCarga: TObjectList<TCargaDePersona>;
  lPersona: TCargaDePersona;
  lEstancadas: TObjectList<TCotizacionEnCurso>;
  lFila: TCotizacionEnCurso;
  lDesde, lHasta, lAnterior: TDateTime;
begin
  Periodo(lDesde, lHasta);
  lAnterior := IncMonth(lDesde, -1);
  lMes := fRepo.PasosDelEquipo(YearOf(lDesde), MonthOf(lDesde));
  lAntes := fRepo.PasosDelEquipo(YearOf(lAnterior), MonthOf(lAnterior));
  try
    if lMes <> nil then
    begin
      ADatos.VistoBuenoMes := lMes.VistoBueno.ValueOrDefault;
      ADatos.DevueltasMes := lMes.Devueltas.ValueOrDefault;
      ADatos.AprobadasMes := lMes.Aprobadas.ValueOrDefault;
      ADatos.RechazadasMes := lMes.Rechazadas.ValueOrDefault;
      ADatos.MontoAprobadoMes := lMes.MontoAprobado.ValueOrDefault;
      ADatos.TasaAprobacion := Tasa(ADatos.AprobadasMes, ADatos.RechazadasMes);
    end;
    if lAntes <> nil then
      ADatos.MontoAprobadoAnterior := lAntes.MontoAprobado.ValueOrDefault;
  finally
    lAntes.Free;
    lMes.Free;
  end;

  lCarga := fRepo.Carga;
  try
    for lPersona in lCarga do
      SumarBarra(ADatos.Carga, lPersona.ElaboradaPorNombre.ValueOrDefault,
        lPersona.ElaboradaPorNombre.ValueOrDefault,
        lPersona.Cantidad.ValueOrDefault);
  finally
    lCarga.Free;
  end;

  lEstancadas := fRepo.Estancadas(DIAS_ESTANCADA, AVISOS_MAXIMO);
  try
    for lFila in lEstancadas do
      ADatos.Estancadas.Add(Aviso(lFila.CotizacionId.ValueOrDefault,
        lFila.Numero.ValueOrDefault, lFila.ClienteNombre.ValueOrDefault,
        lFila.Estado.ValueOrDefault, lFila.ElaboradaPorNombre.ValueOrDefault,
        lFila.Dias.ValueOrDefault));
  finally
    lEstancadas.Free;
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
    LlenarAsesor(AAsesorId, lDesde, Result);

    lFilas := fRepo.RecientesAsesor(AAsesorId, StartOfTheWeek(Date),
      IncDay(StartOfTheWeek(Date), 7));
    try
      FreeAndNil(Result.Recientes);
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
      FreeAndNil(Result.Cola);
      Result.Cola := TMapeo.AListaDto<TColaSolicitudes,
        TSolicitudPorCotizarDTO>(lFilas);
    finally
      lFilas.Free;
    end;
    LlenarAsistente(AUsuarioId, Result);
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
    LlenarSupervisor(Result);

    lFilas := fRepo.ColaPorAprobar(AUsuarioId);
    try
      FreeAndNil(Result.Cola);
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
      FreeAndNil(Result.Productividad);
      Result.Productividad := TMapeo.AListaDto<TAsesoresMes,
        TProductividadAsesorDTO>(lProductividad);
    finally
      lProductividad.Free;
    end;

    lEstados := fRepo.CotizacionesPorEstado;
    try
      FreeAndNil(Result.Estados);
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
      FreeAndNil(Result.Cambios);
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
