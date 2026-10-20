unit Anovo.Services.Dashboard;

// Servicio de dashboards: copia a los DTO las vistas de totales, que traen
// conteos, grupos, tasas y dias ya calculados; aqui solo van los textos.

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
    procedure LlenarAsesor(const AAsesorId: Integer;
      const ADatos: TDashboardAsesorDTO);
    procedure LlenarAsistente(const AUsuarioId: Integer;
      const ADatos: TDashboardAsistenteDTO);
    procedure LlenarSupervisor(const AUsuarioId: Integer;
      const ADatos: TDashboardSupervisorDTO);
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
  Anovo.Mapeo,
  Anovo.Services.Cotizaciones,
  Anovo.Textos;

const
  AVISOS_MAXIMO = 6;
  FORMATO_MONTO = '#,##0';
  FORMATO_TASA = '0.00';
  GRUPO_ESPERANDO = 'esperando';
  GRUPO_ELABORACION = 'elaboracion';
  GRUPO_SIN_RESPUESTA = 'sin_respuesta';

function TextoEstado(const AEstado: string): string;
begin
  if AEstado = ESTADO_BORRADOR then
    Result := SEstBorrador
  else if AEstado = ESTADO_EN_REVISION then
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

function EtiquetaGrupo(const AGrupo: string): string;
begin
  if AGrupo = GRUPO_ESPERANDO then
    Result := SGrupoEsperando
  else if AGrupo = GRUPO_ELABORACION then
    Result := SGrupoElaboracion
  else if AGrupo = GRUPO_SIN_RESPUESTA then
    Result := SGrupoSinRespuesta
  else
    Result := TextoEstado(AGrupo);
end;

function Barra(const AClave, AEtiqueta: string; const ACantidad: Integer)
  : TDashboardBarraDTO;
begin
  Result := TDashboardBarraDTO.Create;
  Result.Clave := AClave;
  Result.Etiqueta := AEtiqueta;
  Result.Cantidad := ACantidad;
end;

function Aviso(const AId, ANumero: Integer; const ACliente, AEstado,
  ADetalle: string; const ADias: Integer; const ANivel: string = '';
  const AEtiqueta: string = ''): TDashboardAvisoDTO;
begin
  Result := TDashboardAvisoDTO.Create;
  Result.CotizacionId := AId;
  Result.Numero := ANumero;
  Result.ClienteNombre := ACliente;
  Result.Estado := AEstado;
  Result.Detalle := ADetalle;
  Result.Dias := ADias;
  Result.Nivel := ANivel;
  Result.Etiqueta := AEtiqueta;
end;

function EtiquetaEtapa(const AEstado: string): string;
begin
  if AEstado = ESTADO_BORRADOR then
    Result := SEtapaBorrador
  else if AEstado = ESTADO_EN_REVISION then
    Result := SEtapaRevision
  else if AEstado = ESTADO_DEVUELTA then
    Result := SEtapaDevuelta
  else if AEstado = ESTADO_VISTO_BUENO then
    Result := SEtapaVistoBueno
  else if AEstado = ESTADO_ENVIADA then
    Result := SEtapaEnviada
  else if AEstado = ESTADO_APROBADA then
    Result := SEtapaAprobadaMes
  else
    Result := TextoEstado(AEstado);
end;

function Dato(const AConcepto, AValor: string): TDashboardDatoDTO;
begin
  Result := TDashboardDatoDTO.Create;
  Result.Concepto := AConcepto;
  Result.Valor := AValor;
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
  const ADatos: TDashboardAsesorDTO);
var
  lGrupos: TObjectList<TGruposDelAsesor>;
  lGrupo: TGruposDelAsesor;
  lEnviadas: TObjectList<TEnviadaSinRespuesta>;
  lEnviada: TEnviadaSinRespuesta;
begin
  Copiar(fRepo.ResumenDelAsesor(AAsesorId), ADatos);

  lGrupos := fRepo.GruposDelAsesor(AAsesorId);
  try
    for lGrupo in lGrupos do
      ADatos.PorEstado.Add(Barra(lGrupo.Grupo.ValueOrDefault,
        EtiquetaGrupo(lGrupo.Grupo.ValueOrDefault),
        lGrupo.Cantidad.ValueOrDefault));
  finally
    lGrupos.Free;
  end;

  lEnviadas := fRepo.EnviadasDeAsesor(AAsesorId, AVISOS_MAXIMO);
  try
    for lEnviada in lEnviadas do
      ADatos.PorLlamar.Add(Aviso(lEnviada.CotizacionId.ValueOrDefault,
        lEnviada.Numero.ValueOrDefault, lEnviada.ClienteNombre.ValueOrDefault,
        ESTADO_ENVIADA, '', lEnviada.Dias.ValueOrDefault,
        lEnviada.Nivel.ValueOrDefault));
  finally
    lEnviadas.Free;
  end;
end;

procedure TDashboardService.LlenarAsistente(const AUsuarioId: Integer;
  const ADatos: TDashboardAsistenteDTO);
var
  lResumen: TResumenDelAsistente;
  lEtapas: TObjectList<TEtapasDelUsuario>;
  lEtapa: TEtapasDelUsuario;
  lEnCurso: TObjectList<TCotizacionEnCurso>;
  lFila: TCotizacionEnCurso;
  lDetalle, lEtiqueta: string;
begin
  lEtapas := fRepo.EtapasDelUsuario(AUsuarioId);
  try
    for lEtapa in lEtapas do
      ADatos.PorEtapa.Add(Barra(lEtapa.Estado.ValueOrDefault,
        EtiquetaEtapa(lEtapa.Estado.ValueOrDefault),
        lEtapa.Cantidad.ValueOrDefault));
  finally
    lEtapas.Free;
  end;

  lEnCurso := fRepo.ParaHoy(AUsuarioId, AVISOS_MAXIMO);
  try
    for lFila in lEnCurso do
    begin
      if lFila.Estado.ValueOrDefault = ESTADO_DEVUELTA then
      begin
        lDetalle := lFila.MotivoRechazo.ValueOrDefault;
        lEtiqueta := SEtapaDevuelta;
      end
      else
      begin
        lDetalle := lFila.ClienteNombre.ValueOrDefault;
        lEtiqueta := SAvisoPorEnviar;
      end;
      ADatos.ParaHoy.Add(Aviso(lFila.CotizacionId.ValueOrDefault,
        lFila.Numero.ValueOrDefault, lFila.ClienteNombre.ValueOrDefault,
        lFila.Estado.ValueOrDefault, lDetalle, lFila.Dias.ValueOrDefault, '',
        lEtiqueta));
    end;
  finally
    lEnCurso.Free;
  end;

  lResumen := fRepo.ResumenDelAsistente(AUsuarioId);
  if lResumen = nil then
    Exit;
  try
    TMapeo.Copiar(lResumen, ADatos);
    ADatos.MiMes.Add(Dato(SDatoPresentadas,
      lResumen.PresentadasMes.ValueOrDefault.ToString));
    ADatos.MiMes.Add(Dato(SDatoAprobadas,
      lResumen.AprobadasMes.ValueOrDefault.ToString));
    ADatos.MiMes.Add(Dato(SDatoTasa, Format(SDatoTasaValor,
      [FormatFloat(FORMATO_TASA, lResumen.TasaMes.ValueOrDefault)])));
    ADatos.MiMes.Add(Dato(SDatoMonto, Format(SDatoMontoValor,
      [FormatFloat(FORMATO_MONTO, lResumen.MontoAprobadoMes.ValueOrDefault)])));
  finally
    lResumen.Free;
  end;
end;

procedure TDashboardService.LlenarSupervisor(const AUsuarioId: Integer;
  const ADatos: TDashboardSupervisorDTO);
var
  lCarga: TObjectList<TCargaDePersona>;
  lPersona: TCargaDePersona;
  lNombre: string;
  lEstancadas: TObjectList<TCotizacionEnCurso>;
  lFila: TCotizacionEnCurso;
begin
  Copiar(fRepo.ResumenDelSupervisor, ADatos);

  lCarga := fRepo.Carga;
  try
    for lPersona in lCarga do
    begin
      lNombre := lPersona.ElaboradaPorNombre.ValueOrDefault;
      if lPersona.ElaboradaPor.ValueOrDefault = AUsuarioId then
        lNombre := Format(SCargaUsted, [lNombre]);
      ADatos.Carga.Add(Barra(lPersona.ElaboradaPor.ValueOrDefault.ToString,
        lNombre, lPersona.Cantidad.ValueOrDefault));
    end;
  finally
    lCarga.Free;
  end;

  lEstancadas := fRepo.Estancadas(AVISOS_MAXIMO);
  try
    for lFila in lEstancadas do
      ADatos.Estancadas.Add(Aviso(lFila.CotizacionId.ValueOrDefault,
        lFila.Numero.ValueOrDefault, lFila.ClienteNombre.ValueOrDefault,
        lFila.Estado.ValueOrDefault, lFila.ElaboradaPorNombre.ValueOrDefault,
        lFila.Dias.ValueOrDefault, lFila.Nivel.ValueOrDefault,
        EtiquetaEtapa(lFila.Estado.ValueOrDefault)));
  finally
    lEstancadas.Free;
  end;
end;

function TDashboardService.DelAsesor(const AAsesorId: Integer)
  : TDashboardAsesorDTO;
var
  lPeriodo: TVPeriodoActual;
  lFilas: TObjectList<TSeguimientoAsesor>;
begin
  Result := TDashboardAsesorDTO.Create;
  try
    Copiar(fRepo.AsesorMes(AAsesorId), Result);
    LlenarAsesor(AAsesorId, Result);

    lPeriodo := fRepo.Periodo;
    try
      Result.Desde := lPeriodo.MesDesde.Value;
      Result.Hasta := lPeriodo.MesHasta.Value;
      lFilas := fRepo.RecientesAsesor(AAsesorId, lPeriodo.SemanaDesde.Value,
        lPeriodo.SemanaHasta.Value);
    finally
      lPeriodo.Free;
    end;
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
    LlenarSupervisor(AUsuarioId, Result);

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
begin
  Result := TDashboardGerenciaDTO.Create;
  try
    Copiar(fRepo.ResumenMes, Result);

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
