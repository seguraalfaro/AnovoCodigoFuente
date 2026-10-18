unit Anovo.Services.Cotizaciones;

// Servicio de cotizaciones: consecutivo, precios copiados del
// catalogo, flujo de aprobacion y totales.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  MVCFramework.Nullables,
  Anovo.DTOs.Cotizaciones,
  Anovo.Entities.Cotizaciones,
  Anovo.Repositories.Intf.Catalogos,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Repositories.Intf.Cotizaciones,
  Anovo.Repositories.Intf.Empresa,
  Anovo.Repositories.Intf.Solicitudes,
  Anovo.Services.Intf.Cotizaciones,
  Anovo.Services.Intf.Permisos;

const
  ESTADO_BORRADOR = 'borrador';
  ESTADO_PENDIENTE = 'pendiente';
  DIAS_SIN_RESPUESTA_POR_DEFECTO = 7;
  ESTADO_DEVUELTA = 'devuelta';
  ESTADO_VISTO_BUENO = 'visto_bueno';
  ESTADO_ENVIADA = 'enviada';
  ESTADO_APROBADA = 'aprobada';
  ESTADO_RECHAZADA = 'rechazada';
  ESTADO_DESCARTADA = 'descartada';

  SOLICITUD_RECIBIDA = 'recibida';
  SOLICITUD_EN_COTIZACION = 'en_cotizacion';

  TIPO_MATERIAL = 'material';
  TIPO_MANO_OBRA = 'mano_obra';
  TIPO_MAQUINA = 'maquina';
  TIPO_NOTA = 'nota';

type
  TCotizacionService = class(TInterfacedObject, ICotizacionService)
  private
    fRepo: ICotizacionRepository;
    fDetalle: ICotizacionDetalleRepository;
    fSolicitudes: ISolicitudRepository;
    fPiezas: ISolicitudPiezaRepository;
    fClientes: IClienteRepository;
    fMateriales: IMaterialPrecioRepository;
    fManoObra: IManoObraPrecioRepository;
    fMaquinas: IMaquinaPrecioRepository;
    fTipos: ITipoTrabajoRepository;
    fEmpresa: IEmpresaRepository;
    fPermisos: IPermisoService;
    fFormasPago: IFormaPagoRepository;

    function TraerVigente(const AId: Integer): TCotizaciones;
    function TraerLinea(const AId, ALineaId: Integer): TCotizacionDetalle;
    function ADto(const ACotizacion: TCotizaciones): TCotizacionDTO;
    procedure CopiarCondiciones(const ACotizacion: TCotizaciones);
    procedure TomarCondiciones(const ACotizacion: TCotizaciones;
      const ADto: TCotizacionEdicionDTO);
    procedure ExigirEditable(const ACotizacion: TCotizaciones);
    procedure ExigirAlcance(const ACotizacion: TCotizaciones;
      const AUsuarioId: Integer; const ARoles: TArray<string>);
    procedure LlenarLinea(const ALinea: TCotizacionDetalle;
      const ADto: TLineaNuevaDTO; const APrecio: Currency);
    function MismoItem(const ALinea: TCotizacionDetalle;
      const ADto: TLineaNuevaDTO): Boolean;
    function PrecioDeCatalogo(const ADto: TLineaNuevaDTO): Currency;
    function IvaPara(const AClienteId: Integer): Currency;
    procedure ValidarTipoTrabajo(const ATipoId, AActual: NullableInt32);
    function TipoTrabajoDePiezas(const ASolicitudId: Integer): NullableInt32;
  public
    [MVCInject]
    constructor Create(ARepo: ICotizacionRepository;
      ADetalle: ICotizacionDetalleRepository;
      ASolicitudes: ISolicitudRepository; APiezas: ISolicitudPiezaRepository;
      AClientes: IClienteRepository; AMateriales: IMaterialPrecioRepository;
      AManoObra: IManoObraPrecioRepository;
      AMaquinas: IMaquinaPrecioRepository; ATipos: ITipoTrabajoRepository;
      AEmpresa: IEmpresaRepository; APermisos: IPermisoService;
      AFormasPago: IFormaPagoRepository); reintroduce;

    function Buscar(const ATexto, AEstado: string; const AClienteId: Integer;
      const ADesde, AHasta: TDateTime; const ARoles: TArray<string>;
      const AUsuarioId, APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TCotizacionDTO>;
    function Bandeja(const AUsuarioId: Integer; const ATexto: string;
      const AFiltroDesde, AFiltroHasta: TDateTime;
      const APagina, APorPagina: Integer): TBandejaPaginaDTO;
    function Obtener(const AId, AUsuarioId: Integer;
      const ARoles: TArray<string>): TCotizacionDTO;
    function ObtenerPorNumero(const ANumero, AUsuarioId: Integer;
      const ARoles: TArray<string>): TCotizacionDTO;
    function CrearDesdeSolicitud(const ADto: TCotizacionNuevaDTO): Integer;
    procedure Actualizar(const AId: Integer;
      const ADto: TCotizacionEdicionDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>);

    function Detalle(const AId, AUsuarioId: Integer;
      const ARoles: TArray<string>): TObjectList<TLineaDTO>;
    function Estados(const AId, AUsuarioId: Integer;
      const ARoles: TArray<string>): TObjectList<TEstadoCotizacionDTO>;
    function AgregarLinea(const AId: Integer;
      const ADto: TLineaNuevaDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>): Integer;
    procedure ActualizarLinea(const AId, ALineaId: Integer;
      const ADto: TLineaNuevaDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
    procedure EliminarLinea(const AId, ALineaId: Integer; const AUsuarioId: Integer;
      const ARoles: TArray<string>);

    procedure Recalcular(const AId: Integer);
    procedure AplicarAjuste(const AId: Integer; const ADto: TAjusteDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>);

    procedure Presentar(const AId: Integer; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
    procedure DarVistoBueno(const AId: Integer; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
    procedure RegistrarRespuesta(const AId: Integer;
      const ADto: TRespuestaClienteDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
    procedure Devolver(const AId: Integer; const ADto: TMotivoDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
    procedure Enviar(const AId: Integer; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
    procedure Descartar(const AId: Integer; const AUsuarioId: Integer;
      const ARoles: TArray<string>);

    function EnviadasSinRespuesta: TObjectList<TCotizacionDTO>;
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Condiciones,
  Anovo.Entities.Catalogos,
  Anovo.Entities.Clientes,
  Anovo.Entities.Empresa,
  Anovo.Entities.Solicitudes,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Periodo,
  Anovo.Permisos,
  Anovo.Textos;

constructor TCotizacionService.Create(ARepo: ICotizacionRepository;
  ADetalle: ICotizacionDetalleRepository; ASolicitudes: ISolicitudRepository;
  APiezas: ISolicitudPiezaRepository; AClientes: IClienteRepository;
  AMateriales: IMaterialPrecioRepository;
  AManoObra: IManoObraPrecioRepository; AMaquinas: IMaquinaPrecioRepository;
  ATipos: ITipoTrabajoRepository; AEmpresa: IEmpresaRepository;
  APermisos: IPermisoService; AFormasPago: IFormaPagoRepository);
begin
  inherited Create;
  fRepo := ARepo;
  fDetalle := ADetalle;
  fSolicitudes := ASolicitudes;
  fPiezas := APiezas;
  fClientes := AClientes;
  fMateriales := AMateriales;
  fManoObra := AManoObra;
  fMaquinas := AMaquinas;
  fTipos := ATipos;
  fEmpresa := AEmpresa;
  fPermisos := APermisos;
  fFormasPago := AFormasPago;
end;

function TCotizacionService.TipoTrabajoDePiezas(const ASolicitudId: Integer)
  : NullableInt32;
var
  lPiezas: TObjectList<TPiezasDeSolicitud>;
  lPieza: TPiezasDeSolicitud;
begin
  Result := nil;
  lPiezas := fPiezas.PiezasDe(ASolicitudId);
  try
    for lPieza in lPiezas do
      if lPieza.TipoTrabajoId.HasValue then
        Exit(lPieza.TipoTrabajoId);
  finally
    lPiezas.Free;
  end;
end;

procedure TCotizacionService.CopiarCondiciones(const ACotizacion
  : TCotizaciones);
var
  lEmpresa: TEmpresa;
  lForma: TFormasPago;
begin
  lEmpresa := fEmpresa.GetByPK(EMPRESA_ID, False);
  if lEmpresa = nil then
    Exit;
  try
    if lEmpresa.FormaPagoId.HasValue then
    begin
      lForma := fFormasPago.Activa(lEmpresa.FormaPagoId.Value);
      if lForma <> nil then
        try
          ACotizacion.FormaPagoId := lEmpresa.FormaPagoId;
          ACotizacion.FormaPago := lForma.Nombre;
        finally
          lForma.Free;
        end;
    end;
    ACotizacion.PlazoEntregaCantidad := lEmpresa.PlazoEntregaCantidad;
    ACotizacion.PlazoEntregaUnidad := lEmpresa.PlazoEntregaUnidad;
    ACotizacion.GarantiaCantidad := lEmpresa.GarantiaCantidad;
    ACotizacion.GarantiaUnidad := lEmpresa.GarantiaUnidad;
  finally
    lEmpresa.Free;
  end;
end;

procedure TCotizacionService.TomarCondiciones(const ACotizacion: TCotizaciones;
  const ADto: TCotizacionEdicionDTO);
var
  lError: string;
  lForma: TFormasPago;
begin
  lError := ErrorDePlazos(ADto.PlazoEntregaCantidad, ADto.PlazoEntregaUnidad,
    ADto.GarantiaCantidad, ADto.GarantiaUnidad);
  if not lError.IsEmpty then
    raise EDatoInvalido.Create(lError);

  if not ADto.FormaPagoId.HasValue then
  begin
    ACotizacion.FormaPagoId.Clear;
    ACotizacion.FormaPago.Clear;
  end
  else if ACotizacion.FormaPagoId.ValueOrDefault <> ADto.FormaPagoId.Value then
  begin
    lForma := fFormasPago.Activa(ADto.FormaPagoId.Value);
    if lForma = nil then
      raise EDatoInvalido.Create(SFormaPagoNoDisponible);
    try
      ACotizacion.FormaPagoId := ADto.FormaPagoId;
      ACotizacion.FormaPago := lForma.Nombre;
    finally
      lForma.Free;
    end;
  end;

  ACotizacion.PlazoEntregaCantidad := ACorto(ADto.PlazoEntregaCantidad);
  ACotizacion.PlazoEntregaUnidad := UnidadONula(ADto.PlazoEntregaUnidad);
  ACotizacion.GarantiaCantidad := ACorto(ADto.GarantiaCantidad);
  ACotizacion.GarantiaUnidad := UnidadONula(ADto.GarantiaUnidad);
end;

function TCotizacionService.IvaPara(const AClienteId: Integer): Currency;
var
  lCliente: TClientes;
  lEmpresa: TEmpresa;
begin
  lCliente := fClientes.GetByPK(AClienteId, False);
  try
    if (lCliente <> nil) and lCliente.Exonerado then
      Exit(0);
  finally
    lCliente.Free;
  end;

  lEmpresa := fEmpresa.GetByPK(EMPRESA_ID, False);
  if lEmpresa = nil then
    raise ERecursoNoEncontrado.Create(SRecursoEmpresa, EMPRESA_ID);
  try
    Result := lEmpresa.PorcentajeIva;
  finally
    lEmpresa.Free;
  end;
end;

procedure TCotizacionService.ValidarTipoTrabajo(const ATipoId,
  AActual: NullableInt32);
var
  lTipo: TTiposTrabajo;
begin
  if not ATipoId.HasValue then
    Exit;
  if AActual.HasValue and (AActual.Value = ATipoId.Value) then
    Exit;

  lTipo := fTipos.GetByPK(ATipoId.Value, False);
  try
    if (lTipo = nil) or not lTipo.Activo.ValueOrDefault then
      raise EDatoInvalido.Create(STipoTrabajoNoDisponible);
  finally
    lTipo.Free;
  end;
end;

function TCotizacionService.TraerVigente(const AId: Integer): TCotizaciones;
begin
  Result := fRepo.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoCotizacion, AId);
end;

function TCotizacionService.TraerLinea(const AId, ALineaId: Integer)
  : TCotizacionDetalle;
begin
  Result := fDetalle.LineaDe(AId, ALineaId);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoLinea, ALineaId);
end;

function TCotizacionService.ADto(const ACotizacion: TCotizaciones)
  : TCotizacionDTO;
var
  lCliente: TClientes;
begin
  Result := TMapeo.ADto<TCotizacionDTO>(ACotizacion);
  lCliente := fClientes.GetByPK(ACotizacion.ClienteId, False);
  if lCliente <> nil then
    try
      Result.ClienteNombre := lCliente.Nombre;
    finally
      lCliente.Free;
    end;
end;

procedure TCotizacionService.ExigirEditable(const ACotizacion: TCotizaciones);
begin
  if (ACotizacion.Estado <> ESTADO_BORRADOR) and
    (ACotizacion.Estado <> ESTADO_DEVUELTA) then
    raise EConflictoDeEstado.Create('COTIZACION_NO_EDITABLE',
      Format(SCotizacionNoEditable,
      [ACotizacion.Estado]));
  if not (ACotizacion.ElaboradaPor = UsuarioActual) then
    raise EConflictoDeEstado.Create('COTIZACION_DE_OTRO', SCotizacionDeOtro);
end;

procedure TCotizacionService.ExigirAlcance(const ACotizacion: TCotizaciones;
  const AUsuarioId: Integer; const ARoles: TArray<string>);
var
  lSolicitud: TSolicitudes;
  lPropia: Boolean;
begin
  if fPermisos.TieneAlguno(AUsuarioId, ARoles,
    [PERMISO_COTIZACIONES_VER_TODAS]) then
    Exit;

  lSolicitud := fSolicitudes.GetByPK(ACotizacion.SolicitudId, False);
  try
    lPropia := (lSolicitud <> nil) and (lSolicitud.AsesorId = AUsuarioId);
  finally
    lSolicitud.Free;
  end;
  if not lPropia then
    raise ERecursoNoEncontrado.Create(SRecursoCotizacion,
      ACotizacion.ID.ValueOrDefault);
end;

function TCotizacionService.PrecioDeCatalogo(const ADto: TLineaNuevaDTO)
  : Currency;
var
  lMaterial: TMaterialesPrecios;
  lManoObra: TManoObraPrecios;
  lMaquina: TMaquinasPrecios;
begin
  Result := 0;

  if (ADto.Tipo = TIPO_MATERIAL) and ADto.MaterialId.HasValue then
  begin
    lMaterial := fMateriales.PrecioVigenteDe(ADto.MaterialId.Value);
    if lMaterial <> nil then
      try
        Result := lMaterial.PrecioUnitario;
      finally
        lMaterial.Free;
      end;
  end
  else if (ADto.Tipo = TIPO_MANO_OBRA) and ADto.ManoObraId.HasValue then
  begin
    lManoObra := fManoObra.PrecioVigenteDe(ADto.ManoObraId.Value);
    if lManoObra <> nil then
      try
        Result := lManoObra.CostoUnitario;
      finally
        lManoObra.Free;
      end;
  end
  else if (ADto.Tipo = TIPO_MAQUINA) and ADto.MaquinaId.HasValue then
  begin
    lMaquina := fMaquinas.PrecioVigenteDe(ADto.MaquinaId.Value);
    if lMaquina <> nil then
      try
        Result := lMaquina.CostoHora;
      finally
        lMaquina.Free;
      end;
  end;
end;

function TCotizacionService.MismoItem(const ALinea: TCotizacionDetalle;
  const ADto: TLineaNuevaDTO): Boolean;
begin
  Result := (ALinea.Tipo = ADto.Tipo) and
    (ALinea.MaterialId.ValueOrDefault = ADto.MaterialId.ValueOrDefault) and
    (ALinea.ManoObraId.ValueOrDefault = ADto.ManoObraId.ValueOrDefault) and
    (ALinea.MaquinaId.ValueOrDefault = ADto.MaquinaId.ValueOrDefault);
end;

procedure TCotizacionService.LlenarLinea(const ALinea: TCotizacionDetalle;
  const ADto: TLineaNuevaDTO; const APrecio: Currency);
var
  lPrecio: Currency;
  lCantidad: Currency;
begin
  if (ADto.Tipo = TIPO_MATERIAL) and not ADto.MaterialId.HasValue then
    raise EDatoInvalido.Create(SLineaSinMaterial);
  if (ADto.Tipo = TIPO_MANO_OBRA) and not ADto.ManoObraId.HasValue then
    raise EDatoInvalido.Create(SLineaSinManoObra);
  if (ADto.Tipo = TIPO_MAQUINA) and not ADto.MaquinaId.HasValue then
    raise EDatoInvalido.Create(SLineaSinMaquina);

  if (ADto.Tipo <> TIPO_MATERIAL) and (ADto.Tipo <> TIPO_MANO_OBRA) and
    (ADto.Tipo <> TIPO_MAQUINA) and (ADto.Tipo <> TIPO_NOTA) then
    raise EDatoInvalido.Create(STipoLineaInvalido);

  ALinea.Tipo := ADto.Tipo;
  ALinea.Descripcion := ADto.Descripcion;
  ALinea.UnidadMedida := ADto.UnidadMedida;

  if ADto.Tipo = TIPO_MATERIAL then
    ALinea.MaterialId := ADto.MaterialId
  else
    ALinea.MaterialId.Clear;
  if ADto.Tipo = TIPO_MANO_OBRA then
    ALinea.ManoObraId := ADto.ManoObraId
  else
    ALinea.ManoObraId.Clear;
  if ADto.Tipo = TIPO_MAQUINA then
    ALinea.MaquinaId := ADto.MaquinaId
  else
    ALinea.MaquinaId.Clear;

  if ADto.Tipo = TIPO_NOTA then
  begin
    ALinea.Cantidad := 0;
    ALinea.PrecioUnitario := 0;
    ALinea.Subtotal := 0;
    Exit;
  end;

  lCantidad := ADto.Cantidad.ValueOrDefault;
  if lCantidad <= 0 then
    raise EDatoInvalido.Create(SCantidadInvalida);

  if APrecio > 0 then
    lPrecio := APrecio
  else
    lPrecio := PrecioDeCatalogo(ADto);

  if lPrecio <= 0 then
    raise EDatoInvalido.Create(SLineaSinPrecio);

  ALinea.Cantidad := lCantidad;
  ALinea.PrecioUnitario := lPrecio;
  ALinea.Subtotal := lCantidad * lPrecio;
end;

function TCotizacionService.Buscar(const ATexto, AEstado: string;
  const AClienteId: Integer; const ADesde, AHasta: TDateTime;
  const ARoles: TArray<string>; const AUsuarioId, APagina, APorPagina: Integer;
  out ATotal: Int64): TObjectList<TCotizacionDTO>;
var
  lFiltroUsuario: Integer;
  lPeriodo: TPeriodo;
  lFilas: TObjectList<TCotizaciones>;
  lFila: TCotizaciones;
begin
  if fPermisos.TieneAlguno(AUsuarioId, ARoles,
    [PERMISO_COTIZACIONES_VER_TODAS]) then
    lFiltroUsuario := 0
  else
    lFiltroUsuario := AUsuarioId;
  lPeriodo := TPeriodo.De(ADesde, AHasta);

  ATotal := fRepo.ContarBusqueda(ATexto, AEstado, AClienteId, lFiltroUsuario,
    lPeriodo.Inicio, lPeriodo.Fin);

  lFilas := fRepo.Buscar(ATexto, APagina, APorPagina, AEstado, AClienteId,
    lFiltroUsuario, lPeriodo.Inicio, lPeriodo.Fin);
  try
    Result := TObjectList<TCotizacionDTO>.Create(True);
    try
      for lFila in lFilas do
        Result.Add(ADto(lFila));
    except
      Result.Free;
      raise;
    end;
  finally
    lFilas.Free;
  end;
end;

function TCotizacionService.Bandeja(const AUsuarioId: Integer;
  const ATexto: string; const AFiltroDesde, AFiltroHasta: TDateTime;
  const APagina, APorPagina: Integer): TBandejaPaginaDTO;
var
  lResumen: TTrabajoUsuario;
  lFilas: TObjectList<TBandejaCotizaciones>;
  lPeriodo: TPeriodo;
begin
  lPeriodo := TPeriodo.De(AFiltroDesde, AFiltroHasta);
  Result := TBandejaPaginaDTO.Create;
  try
    Result.Pagina := APagina;
    Result.PorPagina := APorPagina;
    Result.Total := fRepo.ContarBandeja(AUsuarioId, ATexto, lPeriodo.Inicio,
      lPeriodo.Fin);

    lResumen := fRepo.ResumenBandeja(AUsuarioId);
    if lResumen <> nil then
      try
        TMapeo.Copiar(lResumen, Result);
      finally
        lResumen.Free;
      end;

    lFilas := fRepo.Bandeja(AUsuarioId, ATexto, lPeriodo.Inicio, lPeriodo.Fin,
      APagina, APorPagina);
    try
      FreeAndNil(Result.Data);
      Result.Data := TMapeo.AListaDto<TBandejaCotizaciones,
        TCotizacionBandejaDTO>(lFilas);
    finally
      lFilas.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TCotizacionService.Obtener(const AId, AUsuarioId: Integer;
  const ARoles: TArray<string>): TCotizacionDTO;
var
  lCotizacion: TCotizaciones;
  lVista: TCotizacionConNombres;
begin
  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    Result := ADto(lCotizacion);
  finally
    lCotizacion.Free;
  end;

  try
    lVista := fRepo.VistaDe(AId);
    if lVista <> nil then
      try
        TMapeo.Copiar(lVista, Result);
      finally
        lVista.Free;
      end;
  except
    Result.Free;
    raise;
  end;
end;

function TCotizacionService.ObtenerPorNumero(const ANumero,
  AUsuarioId: Integer; const ARoles: TArray<string>): TCotizacionDTO;
var
  lCotizacion: TCotizaciones;
begin
  lCotizacion := fRepo.ObtenerPorNumero(ANumero);
  if lCotizacion = nil then
    raise ERecursoNoEncontrado.Create(SRecursoCotizacion, ANumero);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    Result := ADto(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

function TCotizacionService.CrearDesdeSolicitud(const ADto
  : TCotizacionNuevaDTO): Integer;
var
  lSolicitud: TSolicitudes;
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lSolicitud := fSolicitudes.GetByPK(ADto.SolicitudId, False);
  if lSolicitud = nil then
    raise EDatoInvalido.Create(SSolicitudNoExiste);

  try
    if (lSolicitud.Estado <> SOLICITUD_RECIBIDA) and
      (lSolicitud.Estado <> SOLICITUD_EN_COTIZACION) then
      raise EConflictoDeEstado.Create('SOLICITUD_NO_COTIZABLE',
        Format(SSolicitudNoCotizable,
        [lSolicitud.Estado]));

    if fRepo.TieneEnCurso(lSolicitud.ID.ValueOrDefault) then
      raise EConflictoDeEstado.Create('SOLICITUD_TOMADA', SSolicitudTomada);

    lCotizacion := TCotizaciones.Create;
    try
      ValidarTipoTrabajo(ADto.TipoTrabajoId, nil);
      lCotizacion.SolicitudId := lSolicitud.ID.ValueOrDefault;
      lCotizacion.ClienteId := lSolicitud.ClienteId;
      if ADto.TipoTrabajoId.HasValue then
        lCotizacion.TipoTrabajoId := ADto.TipoTrabajoId
      else
        lCotizacion.TipoTrabajoId :=
          TipoTrabajoDePiezas(lSolicitud.ID.ValueOrDefault);

      if ADto.DescripcionTrabajo.IsEmpty then
        lCotizacion.DescripcionTrabajo := lSolicitud.Descripcion
      else
        lCotizacion.DescripcionTrabajo := ADto.DescripcionTrabajo;

      lCotizacion.Numero := fRepo.SiguienteNumero;
      lCotizacion.ElaboradaPor := UsuarioActual;
      lCotizacion.Estado := ESTADO_BORRADOR;
      lCotizacion.PorcentajeIva := IvaPara(lCotizacion.ClienteId);
      lCotizacion.PorcentajeAjuste := 0;
      lCotizacion.FechaElaboracion := Now;
      CopiarCondiciones(lCotizacion);

      FijarDetalle(Format(SDetalleCotizacionDesdeSolicitud,
        [lCotizacion.Numero, lSolicitud.ID.ValueOrDefault]));
      fRepo.Insert(lCotizacion);
      Result := lCotizacion.ID.ValueOrDefault;

      lSolicitud.Estado := SOLICITUD_EN_COTIZACION;
      fSolicitudes.Update(lSolicitud);
    finally
      lCotizacion.Free;
    end;
  finally
    lSolicitud.Free;
  end;
end;

procedure TCotizacionService.Actualizar(const AId: Integer;
  const ADto: TCotizacionEdicionDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create(Format(SFaltaVersion, [SRecursoCotizacion]));

  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    ExigirEditable(lCotizacion);

    if lCotizacion.Objversion <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create(SRecursoCotizacion, AId);

    ValidarTipoTrabajo(ADto.TipoTrabajoId, lCotizacion.TipoTrabajoId);
    lCotizacion.TipoTrabajoId := ADto.TipoTrabajoId;
    lCotizacion.DescripcionTrabajo := ADto.DescripcionTrabajo;
    TomarCondiciones(lCotizacion, ADto);
    lCotizacion.PorcentajeIva := IvaPara(lCotizacion.ClienteId);
    FijarDetalle(Format(SDetalleCambioCotizacion, [lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;

  Recalcular(AId);
end;

function TCotizacionService.Estados(const AId, AUsuarioId: Integer;
  const ARoles: TArray<string>): TObjectList<TEstadoCotizacionDTO>;
var
  lFilas: TObjectList<THistorialCotizacion>;
  lCotizacion: TCotizaciones;
begin
  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
  finally
    lCotizacion.Free;
  end;

  lFilas := fRepo.HistorialDe(AId);
  try
    Result := TMapeo.AListaDto<THistorialCotizacion,
      TEstadoCotizacionDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCotizacionService.Detalle(const AId, AUsuarioId: Integer;
  const ARoles: TArray<string>): TObjectList<TLineaDTO>;
var
  lFilas: TObjectList<TCotizacionDetalle>;
  lCotizacion: TCotizaciones;
begin
  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
  finally
    lCotizacion.Free;
  end;

  lFilas := fDetalle.DetalleDe(AId);
  try
    Result := TMapeo.AListaDto<TCotizacionDetalle, TLineaDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCotizacionService.AgregarLinea(const AId: Integer;
  const ADto: TLineaNuevaDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>): Integer;
var
  lCotizacion: TCotizaciones;
  lLinea: TCotizacionDetalle;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    ExigirEditable(lCotizacion);

    lLinea := TCotizacionDetalle.Create;
    lLinea.Activo := True;
    try
      lLinea.CotizacionId := AId;
      LlenarLinea(lLinea, ADto, 0);
      lLinea.Orden := fDetalle.SiguienteOrden(AId);
      FijarDetalle(Format(SDetalleLineaAgregada, [lCotizacion.Numero]));
      fDetalle.Insert(lLinea);
      Result := lLinea.ID.ValueOrDefault;
    finally
      lLinea.Free;
    end;
  finally
    lCotizacion.Free;
  end;

  Recalcular(AId);
end;

procedure TCotizacionService.ActualizarLinea(const AId, ALineaId: Integer;
  const ADto: TLineaNuevaDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
var
  lCotizacion: TCotizaciones;
  lLinea: TCotizacionDetalle;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    ExigirEditable(lCotizacion);

    lLinea := TraerLinea(AId, ALineaId);
    try
      if MismoItem(lLinea, ADto) then
        LlenarLinea(lLinea, ADto, lLinea.PrecioUnitario)
      else
        LlenarLinea(lLinea, ADto, 0);
      FijarDetalle(Format(SDetalleCambioLinea, [lCotizacion.Numero]));
      fDetalle.Update(lLinea);
    finally
      lLinea.Free;
    end;
  finally
    lCotizacion.Free;
  end;

  Recalcular(AId);
end;

procedure TCotizacionService.EliminarLinea(const AId, ALineaId: Integer; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
var
  lCotizacion: TCotizaciones;
  lLinea: TCotizacionDetalle;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    ExigirEditable(lCotizacion);

    lLinea := TraerLinea(AId, ALineaId);
    try
      FijarDetalle(Format(SDetalleLineaEliminada, [lCotizacion.Numero]));
      lLinea.Activo := False;
      fDetalle.Update(lLinea);
    finally
      lLinea.Free;
    end;
  finally
    lCotizacion.Free;
  end;

  Recalcular(AId);
end;

procedure TCotizacionService.Recalcular(const AId: Integer);
var
  lCotizacion: TCotizaciones;
  lMateriales, lManoObra, lMaquina: Currency;
  lCosto, lAjustado, lImpuesto: Currency;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  fDetalle.SubtotalesDe(AId, lMateriales, lManoObra, lMaquina);

  lCotizacion := TraerVigente(AId);
  try
    lCotizacion.SubtotalMateriales := lMateriales;
    lCotizacion.SubtotalManoObra := lManoObra;
    lCotizacion.SubtotalMaquina := lMaquina;

    lCosto := lMateriales + lManoObra + lMaquina;
    lCotizacion.CostoTotal := lCosto;

    lAjustado := lCosto + (lCosto * lCotizacion.PorcentajeAjuste / 100);
    lImpuesto := lAjustado * lCotizacion.PorcentajeIva / 100;

    lCotizacion.MontoImpuesto := lImpuesto;
    lCotizacion.MontoTotal := lAjustado + lImpuesto;

    FijarDetalle(Format(SDetalleRecalculoCotizacion, [lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

procedure TCotizacionService.AplicarAjuste(const AId: Integer;
  const ADto: TAjusteDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    ExigirEditable(lCotizacion);

    if (ADto.PorcentajeAjuste <> 0) and
      (not ADto.MotivoAjuste.HasValue or ADto.MotivoAjuste.Value.IsEmpty) then
      raise EDatoInvalido.Create(SAjusteSinMotivo);

    lCotizacion.PorcentajeAjuste := ADto.PorcentajeAjuste;
    if ADto.PorcentajeAjuste = 0 then
      lCotizacion.MotivoAjuste.Clear
    else
      lCotizacion.MotivoAjuste := ADto.MotivoAjuste;

    FijarDetalle(Format(SDetalleAjusteCotizacion,
      [CurrToStr(ADto.PorcentajeAjuste), lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;

  Recalcular(AId);
end;

procedure TCotizacionService.Presentar(const AId: Integer; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
var
  lCotizacion: TCotizaciones;
  lLineas: TObjectList<TCotizacionDetalle>;
  lVacia: Boolean;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    ExigirEditable(lCotizacion);

    lLineas := fDetalle.DetalleDe(AId);
    try
      lVacia := lLineas.Count = 0;
    finally
      lLineas.Free;
    end;
    if lVacia then
      raise EConflictoDeEstado.Create('COTIZACION_SIN_DETALLE',
        SCotizacionSinLineas);

    lCotizacion.Estado := ESTADO_PENDIENTE;
    FijarDetalle(Format(SDetalleCotizacionPresentada, [lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

procedure TCotizacionService.DarVistoBueno(const AId: Integer; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    if lCotizacion.Estado <> ESTADO_PENDIENTE then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format(SCotizacionNoAprobable,
        [lCotizacion.Estado]));

    if lCotizacion.ElaboradaPor = UsuarioActual then
      raise EConflictoDeEstado.Create('COTIZACION_PROPIA', SRevisarPropia);

    lCotizacion.Estado := ESTADO_VISTO_BUENO;
    lCotizacion.AprobadaPor := UsuarioActual;
    lCotizacion.FechaAprobacion := Now;
    FijarDetalle(Format(SDetalleAprobacionCotizacion, [lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

procedure TCotizacionService.RegistrarRespuesta(const AId: Integer;
  const ADto: TRespuestaClienteDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    if (lCotizacion.Estado <> ESTADO_ENVIADA) and
      (lCotizacion.Estado <> ESTADO_DESCARTADA) then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format(SCotizacionSinRespuesta,
        [lCotizacion.Estado]));

    if ADto.Aceptada then
    begin
      lCotizacion.Estado := ESTADO_APROBADA;
      FijarDetalle(Format(SDetalleAceptacionCotizacion, [lCotizacion.Numero]));
    end
    else
    begin
      lCotizacion.Estado := ESTADO_RECHAZADA;
      FijarDetalle(Format(SDetalleRechazoCotizacion, [lCotizacion.Numero]));
    end;
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

procedure TCotizacionService.Devolver(const AId: Integer;
  const ADto: TMotivoDTO; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if ADto.Motivo.IsEmpty then
    raise EDatoInvalido.Create(SDevolverSinObservacion);

  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    if lCotizacion.Estado <> ESTADO_PENDIENTE then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format(SCotizacionNoDevolvible,
        [lCotizacion.Estado]));

    if lCotizacion.ElaboradaPor = UsuarioActual then
      raise EConflictoDeEstado.Create('COTIZACION_PROPIA', SRevisarPropia);

    lCotizacion.Estado := ESTADO_DEVUELTA;
    lCotizacion.MotivoRechazo := ADto.Motivo;
    FijarDetalle(Format(SDetalleDevolucionCotizacion, [lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

procedure TCotizacionService.Enviar(const AId: Integer; const AUsuarioId: Integer;
      const ARoles: TArray<string>);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    if lCotizacion.Estado <> ESTADO_VISTO_BUENO then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format(SCotizacionNoEnviable,
        [lCotizacion.Estado]));

    lCotizacion.Estado := ESTADO_ENVIADA;
    lCotizacion.FechaEnvio := Now;
    FijarDetalle(Format(SDetalleEnvioCotizacion, [lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

procedure TCotizacionService.Descartar(const AId: Integer;
  const AUsuarioId: Integer; const ARoles: TArray<string>);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirAlcance(lCotizacion, AUsuarioId, ARoles);
    if lCotizacion.Estado <> ESTADO_ENVIADA then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format(SCotizacionNoDescartable,
        [lCotizacion.Estado]));

    lCotizacion.Estado := ESTADO_DESCARTADA;
    FijarDetalle(Format(SDetalleDescarteCotizacion, [lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

function TCotizacionService.EnviadasSinRespuesta: TObjectList<TCotizacionDTO>;
var
  lEmpresa: TEmpresa;
  lDias: Integer;
  lFilas: TObjectList<TCotizaciones>;
  lFila: TCotizaciones;
begin
  lDias := DIAS_SIN_RESPUESTA_POR_DEFECTO;
  lEmpresa := fEmpresa.GetByPK(EMPRESA_ID, False);
  if lEmpresa <> nil then
    try
      lDias := lEmpresa.DiasSinRespuesta;
    finally
      lEmpresa.Free;
    end;
  lFilas := fRepo.EnviadasSinRespuesta(lDias);
  try
    Result := TObjectList<TCotizacionDTO>.Create(True);
    try
      for lFila in lFilas do
        Result.Add(ADto(lFila));
    except
      Result.Free;
      raise;
    end;
  finally
    lFilas.Free;
  end;
end;

end.
