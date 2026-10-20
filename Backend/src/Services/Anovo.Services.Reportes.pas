unit Anovo.Services.Reportes;

// Servicio de reportes: fija el periodo y copia las filas de las vistas
// V_REPORTE_*, que traen sumas, tasas y el periodo anterior ya calculados,
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
    procedure LlenarResumen(const AReporte: TReporteCotizacionesDTO);
    procedure LlenarListas(const AReporte: TReporteCotizacionesDTO);
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
  PERIODO_ACTUAL = 'actual';

function OrdenEstado(const AEstado: string): Integer;
begin
  for Result := Low(ORDEN_ESTADOS) to High(ORDEN_ESTADOS) do
    if ORDEN_ESTADOS[Result] = AEstado then
      Exit;
  Result := Length(ORDEN_ESTADOS);
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

procedure TReporteService.LlenarResumen(const AReporte
  : TReporteCotizacionesDTO);
var
  lFilas: TObjectList<TResumenDelReporte>;
  lFila: TResumenDelReporte;
begin
  lFilas := fRepo.Resumen;
  try
    for lFila in lFilas do
      if lFila.Periodo.ValueOrDefault = PERIODO_ACTUAL then
        TMapeo.Copiar(lFila, AReporte)
      else
        TMapeo.Copiar(lFila, AReporte.Anterior);
  finally
    lFilas.Free;
  end;
end;

procedure TReporteService.LlenarListas(const AReporte
  : TReporteCotizacionesDTO);
var
  lEstados: TObjectList<TReportePorEstado>;
  lAsesores: TObjectList<TReportePorAsesor>;
  lTipos: TObjectList<TReportePorTipo>;
  lMeses: TObjectList<TReportePorMes>;
  lClientes: TObjectList<TReportePorCliente>;
  lTipo: TReporteTipoDTO;
begin
  lEstados := fRepo.PorEstado;
  try
    FreeAndNil(AReporte.PorEstado);
    AReporte.PorEstado := TMapeo.AListaDto<TReportePorEstado,
      TCotizacionesPorEstadoDTO>(lEstados);
  finally
    lEstados.Free;
  end;

  lAsesores := fRepo.PorAsesor;
  try
    FreeAndNil(AReporte.PorAsesor);
    AReporte.PorAsesor := TMapeo.AListaDto<TReportePorAsesor,
      TReporteAsesorDTO>(lAsesores);
  finally
    lAsesores.Free;
  end;

  lTipos := fRepo.PorTipo;
  try
    FreeAndNil(AReporte.PorTipo);
    AReporte.PorTipo := TMapeo.AListaDto<TReportePorTipo,
      TReporteTipoDTO>(lTipos);
  finally
    lTipos.Free;
  end;
  for lTipo in AReporte.PorTipo do
    if lTipo.TipoTrabajoNombre.IsEmpty then
      lTipo.TipoTrabajoNombre := SSinTipoTrabajo;

  lMeses := fRepo.PorMes;
  try
    FreeAndNil(AReporte.PorMes);
    AReporte.PorMes := TMapeo.AListaDto<TReportePorMes,
      TReporteMesDTO>(lMeses);
  finally
    lMeses.Free;
  end;

  lClientes := fRepo.PorCliente;
  try
    FreeAndNil(AReporte.PorCliente);
    AReporte.PorCliente := TMapeo.AListaDto<TReportePorCliente,
      TReporteClienteDTO>(lClientes);
  finally
    lClientes.Free;
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
begin
  if DateOf(ADesde) > DateOf(AHasta) then
    raise EDatoInvalido.Create(SReporteRangoInvalido);

  Result := TReporteCotizacionesDTO.Create;
  try
    fRepo.FijarPeriodo(DateOf(ADesde), DateOf(AHasta),
      FiltroUsuario(AUsuarioId, ARoles));
    LlenarResumen(Result);
    LlenarListas(Result);
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
