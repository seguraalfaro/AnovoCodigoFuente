unit Anovo.Services.Cotizaciones;

// Servicio de cotizaciones: consecutivo, precios copiados del
// catalogo, flujo de aprobacion y totales.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  Anovo.DTOs.Cotizaciones,
  Anovo.Entities.Cotizaciones,
  Anovo.Repositories.Intf.Catalogos,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Repositories.Intf.Cotizaciones,
  Anovo.Repositories.Intf.Solicitudes,
  Anovo.Services.Intf.Cotizaciones,
  Anovo.Services.Intf.Permisos;

const
  ESTADO_BORRADOR = 'borrador';
  ESTADO_PENDIENTE = 'pendiente';
  ESTADO_APROBADA = 'aprobada';
  ESTADO_RECHAZADA = 'rechazada';
  ESTADO_ENVIADA = 'enviada';

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
    fClientes: IClienteRepository;
    fMateriales: IMaterialPrecioRepository;
    fManoObra: IManoObraPrecioRepository;
    fMaquinas: IMaquinaPrecioRepository;
    fPermisos: IPermisoService;

    function TraerVigente(const AId: Integer): TCotizaciones;
    function TraerLinea(const AId, ALineaId: Integer): TCotizacionDetalle;
    function ADto(const ACotizacion: TCotizaciones): TCotizacionDTO;
    procedure ExigirEditable(const ACotizacion: TCotizaciones);
    procedure LlenarLinea(const ALinea: TCotizacionDetalle;
      const ADto: TLineaNuevaDTO);
    function PrecioDeCatalogo(const ADto: TLineaNuevaDTO): Currency;
  public
    [MVCInject]
    constructor Create(ARepo: ICotizacionRepository;
      ADetalle: ICotizacionDetalleRepository;
      ASolicitudes: ISolicitudRepository; AClientes: IClienteRepository;
      AMateriales: IMaterialPrecioRepository;
      AManoObra: IManoObraPrecioRepository;
      AMaquinas: IMaquinaPrecioRepository;
      APermisos: IPermisoService); reintroduce;

    function Buscar(const ATexto, AEstado: string; const AClienteId: Integer;
      const ADesde, AHasta: TDateTime; const ARoles: TArray<string>;
      const AUsuarioId, APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TCotizacionDTO>;
    function Bandeja(const AUsuarioId: Integer; const ATexto: string;
      const APagina, APorPagina: Integer): TBandejaPaginaDTO;
    function Obtener(const AId: Integer): TCotizacionDTO;
    function ObtenerPorNumero(const ANumero: Integer): TCotizacionDTO;
    function CrearDesdeSolicitud(const ADto: TCotizacionNuevaDTO): Integer;
    procedure Actualizar(const AId: Integer;
      const ADto: TCotizacionEdicionDTO);

    function Detalle(const AId: Integer): TObjectList<TLineaDTO>;
    function AgregarLinea(const AId: Integer;
      const ADto: TLineaNuevaDTO): Integer;
    procedure ActualizarLinea(const AId, ALineaId: Integer;
      const ADto: TLineaNuevaDTO);
    procedure EliminarLinea(const AId, ALineaId: Integer);

    procedure Recalcular(const AId: Integer);
    procedure AplicarAjuste(const AId: Integer; const ADto: TAjusteDTO);

    procedure Presentar(const AId: Integer);
    procedure Aprobar(const AId: Integer);
    procedure Rechazar(const AId: Integer; const ADto: TMotivoDTO);
    procedure Devolver(const AId: Integer; const ADto: TMotivoDTO);
    procedure Enviar(const AId: Integer);

    function EnviadasSinRespuesta(const ADias: Integer)
      : TObjectList<TCotizacionDTO>;
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Entities.Catalogos,
  Anovo.Entities.Clientes,
  Anovo.Entities.Solicitudes,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Permisos,
  Anovo.Textos;

constructor TCotizacionService.Create(ARepo: ICotizacionRepository;
  ADetalle: ICotizacionDetalleRepository; ASolicitudes: ISolicitudRepository;
  AClientes: IClienteRepository; AMateriales: IMaterialPrecioRepository;
  AManoObra: IManoObraPrecioRepository; AMaquinas: IMaquinaPrecioRepository;
  APermisos: IPermisoService);
begin
  inherited Create;
  fRepo := ARepo;
  fDetalle := ADetalle;
  fSolicitudes := ASolicitudes;
  fClientes := AClientes;
  fMateriales := AMateriales;
  fManoObra := AManoObra;
  fMaquinas := AMaquinas;
  fPermisos := APermisos;
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
  if ACotizacion.Estado <> ESTADO_BORRADOR then
    raise EConflictoDeEstado.Create('COTIZACION_NO_EDITABLE',
      Format(SCotizacionNoEditable,
      [ACotizacion.Estado]));
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

procedure TCotizacionService.LlenarLinea(const ALinea: TCotizacionDetalle;
  const ADto: TLineaNuevaDTO);
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

  if ADto.PrecioUnitario.HasValue then
    lPrecio := ADto.PrecioUnitario.Value
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
  lFilas: TObjectList<TCotizaciones>;
  lFila: TCotizaciones;
begin
  if fPermisos.TieneAlguno(AUsuarioId, ARoles,
    [PERMISO_COTIZACIONES_VER_TODAS]) then
    lFiltroUsuario := 0
  else
    lFiltroUsuario := AUsuarioId;

  ATotal := fRepo.ContarBusqueda(ATexto, AEstado, AClienteId, lFiltroUsuario,
    ADesde, AHasta);

  lFilas := fRepo.Buscar(ATexto, APagina, APorPagina, AEstado, AClienteId,
    lFiltroUsuario, ADesde, AHasta);
  try
    Result := TObjectList<TCotizacionDTO>.Create(True);
    for lFila in lFilas do
      Result.Add(ADto(lFila));
  finally
    lFilas.Free;
  end;
end;

function TCotizacionService.Bandeja(const AUsuarioId: Integer;
  const ATexto: string; const APagina, APorPagina: Integer)
  : TBandejaPaginaDTO;
var
  lResumen: TTrabajoUsuario;
  lFilas: TObjectList<TBandejaCotizaciones>;
begin
  Result := TBandejaPaginaDTO.Create;
  try
    Result.Pagina := APagina;
    Result.PorPagina := APorPagina;
    Result.Total := fRepo.ContarBandeja(AUsuarioId, ATexto);

    lResumen := fRepo.ResumenBandeja(AUsuarioId);
    if lResumen <> nil then
      try
        TMapeo.Copiar(lResumen, Result);
      finally
        lResumen.Free;
      end;

    lFilas := fRepo.Bandeja(AUsuarioId, ATexto, APagina, APorPagina);
    try
      Result.Data.Free;
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

function TCotizacionService.Obtener(const AId: Integer): TCotizacionDTO;
var
  lCotizacion: TCotizaciones;
  lVista: TCotizacionConNombres;
begin
  lCotizacion := TraerVigente(AId);
  try
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

function TCotizacionService.ObtenerPorNumero(const ANumero: Integer)
  : TCotizacionDTO;
var
  lCotizacion: TCotizaciones;
begin
  lCotizacion := fRepo.ObtenerPorNumero(ANumero);
  if lCotizacion = nil then
    raise ERecursoNoEncontrado.Create(SRecursoCotizacion, ANumero);
  try
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
      lCotizacion.SolicitudId := lSolicitud.ID.ValueOrDefault;
      lCotizacion.ClienteId := lSolicitud.ClienteId;
      lCotizacion.TipoTrabajoId := ADto.TipoTrabajoId;

      if ADto.DescripcionTrabajo.IsEmpty then
        lCotizacion.DescripcionTrabajo := lSolicitud.Descripcion
      else
        lCotizacion.DescripcionTrabajo := ADto.DescripcionTrabajo;

      lCotizacion.Numero := fRepo.SiguienteNumero;
      lCotizacion.ElaboradaPor := UsuarioActual;
      lCotizacion.Estado := ESTADO_BORRADOR;
      lCotizacion.PorcentajeIva := ADto.PorcentajeIva;
      lCotizacion.PorcentajeAjuste := 0;
      lCotizacion.FechaElaboracion := Now;

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
  const ADto: TCotizacionEdicionDTO);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create(Format(SFaltaVersion, [SRecursoCotizacion]));

  lCotizacion := TraerVigente(AId);
  try
    ExigirEditable(lCotizacion);

    if lCotizacion.Objversion.ValueOrDefault <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create(SRecursoCotizacion, AId);

    lCotizacion.TipoTrabajoId := ADto.TipoTrabajoId;
    lCotizacion.DescripcionTrabajo := ADto.DescripcionTrabajo;
    lCotizacion.PorcentajeIva := ADto.PorcentajeIva;
    FijarDetalle(Format(SDetalleCambioCotizacion, [lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;

  Recalcular(AId);
end;

function TCotizacionService.Detalle(const AId: Integer)
  : TObjectList<TLineaDTO>;
var
  lFilas: TObjectList<TCotizacionDetalle>;
begin
  lFilas := fDetalle.DetalleDe(AId);
  try
    Result := TMapeo.AListaDto<TCotizacionDetalle, TLineaDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCotizacionService.AgregarLinea(const AId: Integer;
  const ADto: TLineaNuevaDTO): Integer;
var
  lCotizacion: TCotizaciones;
  lLinea: TCotizacionDetalle;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirEditable(lCotizacion);

    lLinea := TCotizacionDetalle.Create;
    try
      lLinea.CotizacionId := AId;
      LlenarLinea(lLinea, ADto);
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
  const ADto: TLineaNuevaDTO);
var
  lCotizacion: TCotizaciones;
  lLinea: TCotizacionDetalle;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirEditable(lCotizacion);

    lLinea := TraerLinea(AId, ALineaId);
    try
      LlenarLinea(lLinea, ADto);
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

procedure TCotizacionService.EliminarLinea(const AId, ALineaId: Integer);
var
  lCotizacion: TCotizaciones;
  lLinea: TCotizacionDetalle;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    ExigirEditable(lCotizacion);

    lLinea := TraerLinea(AId, ALineaId);
    try
      FijarDetalle(Format(SDetalleLineaEliminada, [lCotizacion.Numero]));
      fDetalle.Delete(lLinea);
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
  const ADto: TAjusteDTO);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
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

procedure TCotizacionService.Presentar(const AId: Integer);
var
  lCotizacion: TCotizaciones;
  lLineas: TObjectList<TCotizacionDetalle>;
  lVacia: Boolean;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
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

procedure TCotizacionService.Aprobar(const AId: Integer);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    if lCotizacion.Estado <> ESTADO_PENDIENTE then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format(SCotizacionNoAprobable,
        [lCotizacion.Estado]));

    if lCotizacion.ElaboradaPor = UsuarioActual then
      raise EConflictoDeEstado.Create('COTIZACION_PROPIA', SRevisarPropia);

    lCotizacion.Estado := ESTADO_APROBADA;
    lCotizacion.AprobadaPor := UsuarioActual;
    lCotizacion.FechaAprobacion := Now;
    FijarDetalle(Format(SDetalleAprobacionCotizacion, [lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

procedure TCotizacionService.Rechazar(const AId: Integer;
  const ADto: TMotivoDTO);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if ADto.Motivo.IsEmpty then
    raise EDatoInvalido.Create(SRechazarSinMotivo);

  lCotizacion := TraerVigente(AId);
  try
    if lCotizacion.Estado <> ESTADO_PENDIENTE then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format(SCotizacionNoRechazable,
        [lCotizacion.Estado]));

    if lCotizacion.ElaboradaPor = UsuarioActual then
      raise EConflictoDeEstado.Create('COTIZACION_PROPIA', SRevisarPropia);

    lCotizacion.Estado := ESTADO_RECHAZADA;
    lCotizacion.MotivoRechazo := ADto.Motivo;
    FijarDetalle(Format(SDetalleRechazoCotizacion, [lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

procedure TCotizacionService.Devolver(const AId: Integer;
  const ADto: TMotivoDTO);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if ADto.Motivo.IsEmpty then
    raise EDatoInvalido.Create(SDevolverSinObservacion);

  lCotizacion := TraerVigente(AId);
  try
    if lCotizacion.Estado <> ESTADO_PENDIENTE then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format(SCotizacionNoDevolvible,
        [lCotizacion.Estado]));

    if lCotizacion.ElaboradaPor = UsuarioActual then
      raise EConflictoDeEstado.Create('COTIZACION_PROPIA', SRevisarPropia);

    lCotizacion.Estado := ESTADO_BORRADOR;
    lCotizacion.MotivoRechazo := ADto.Motivo;
    FijarDetalle(Format(SDetalleDevolucionCotizacion, [lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

procedure TCotizacionService.Enviar(const AId: Integer);
var
  lCotizacion: TCotizaciones;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCotizacion := TraerVigente(AId);
  try
    if lCotizacion.Estado <> ESTADO_APROBADA then
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

function TCotizacionService.EnviadasSinRespuesta(const ADias: Integer)
  : TObjectList<TCotizacionDTO>;
var
  lFilas: TObjectList<TCotizaciones>;
  lFila: TCotizaciones;
begin
  lFilas := fRepo.EnviadasSinRespuesta(ADias);
  try
    Result := TObjectList<TCotizacionDTO>.Create(True);
    for lFila in lFilas do
      Result.Add(ADto(lFila));
  finally
    lFilas.Free;
  end;
end;

end.
