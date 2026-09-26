unit Anovo.Services.Cotizaciones;

// Servicio de cotizaciones: el nucleo del negocio del sistema.
//
// Cuatro reglas viven aqui y en ningun otro sitio.
//
// El consecutivo sale del generador de Firebird, no de un max(NUMERO): dos
// asistentes que graben a la vez no pueden recibir el mismo numero, y la HU-04
// pide que sea unico e irrepetible.
//
// El precio se copia del catalogo al agregar la linea; no se referencia. Si
// manana sube el material, la cotizacion ya aprobada conserva el precio con
// el que se calculo.
//
// Los totales los calcula el servidor a partir del detalle, cada vez que el
// detalle cambia. Nunca llegan desde el cliente.
//
// La maquina de estados. La base no la impone -ESTADO es un VARCHAR sin
// CHECK-, asi que las transiciones validas y la regla de que una cotizacion
// enviada ya no se modifica estan aqui.

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
  Anovo.Services.Intf.Cotizaciones;

const
  ESTADO_BORRADOR = 'borrador';
  ESTADO_EN_PROCESO = 'en_proceso';
  ESTADO_ENVIADA = 'enviada';
  ESTADO_APROBADA = 'aprobada';
  ESTADO_RECHAZADA = 'rechazada';

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
      AMaquinas: IMaquinaPrecioRepository); reintroduce;

    function Buscar(const ATexto, AEstado: string; const AClienteId: Integer;
      const ADesde, AHasta: TDateTime; const ASoloPropias: Boolean;
      const AUsuarioId, APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TCotizacionDTO>;
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

    procedure Enviar(const AId: Integer);
    procedure Aprobar(const AId: Integer);
    procedure Rechazar(const AId: Integer; const ADto: TMotivoDTO);
    procedure Devolver(const AId: Integer; const ADto: TMotivoDTO);

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
  Anovo.Errors,
  Anovo.Mapeo;

constructor TCotizacionService.Create(ARepo: ICotizacionRepository;
  ADetalle: ICotizacionDetalleRepository; ASolicitudes: ISolicitudRepository;
  AClientes: IClienteRepository; AMateriales: IMaterialPrecioRepository;
  AManoObra: IManoObraPrecioRepository; AMaquinas: IMaquinaPrecioRepository);
begin
  inherited Create;
  fRepo := ARepo;
  fDetalle := ADetalle;
  fSolicitudes := ASolicitudes;
  fClientes := AClientes;
  fMateriales := AMateriales;
  fManoObra := AManoObra;
  fMaquinas := AMaquinas;
end;

// Apoyo

function TCotizacionService.TraerVigente(const AId: Integer): TCotizaciones;
begin
  Result := fRepo.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('la cotizacion', AId);
end;

function TCotizacionService.TraerLinea(const AId, ALineaId: Integer)
  : TCotizacionDetalle;
begin
  Result := fDetalle.LineaDe(AId, ALineaId);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('la linea', ALineaId);
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
  // Una cotizacion no puede modificarse una vez enviada al cliente. Es
  // condicion de aceptacion de la HU-04 y la unica forma de que el papel que
  // recibio el cliente y lo que guarda el sistema digan lo mismo.
  if (ACotizacion.Estado <> ESTADO_BORRADOR) and
    (ACotizacion.Estado <> ESTADO_EN_PROCESO) then
    raise EConflictoDeEstado.Create('COTIZACION_NO_EDITABLE',
      Format('Una cotizacion en estado %s ya no admite cambios.',
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
        Result := lMaterial.PrecioUnitario.ValueOrDefault;
      finally
        lMaterial.Free;
      end;
  end
  else if (ADto.Tipo = TIPO_MANO_OBRA) and ADto.ManoObraId.HasValue then
  begin
    lManoObra := fManoObra.PrecioVigenteDe(ADto.ManoObraId.Value);
    if lManoObra <> nil then
      try
        Result := lManoObra.CostoUnitario.ValueOrDefault;
      finally
        lManoObra.Free;
      end;
  end
  else if (ADto.Tipo = TIPO_MAQUINA) and ADto.MaquinaId.HasValue then
  begin
    lMaquina := fMaquinas.PrecioVigenteDe(ADto.MaquinaId.Value);
    if lMaquina <> nil then
      try
        Result := lMaquina.CostoHora.ValueOrDefault;
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
  // CK_DETALLE_TIPO exige que el id que corresponde al tipo venga lleno y los
  // otros dos vacios. Se comprueba antes para dar un mensaje util.
  if (ADto.Tipo = TIPO_MATERIAL) and not ADto.MaterialId.HasValue then
    raise EDatoInvalido.Create('Una linea de material necesita el material.');
  if (ADto.Tipo = TIPO_MANO_OBRA) and not ADto.ManoObraId.HasValue then
    raise EDatoInvalido.Create
      ('Una linea de mano de obra necesita la mano de obra.');
  if (ADto.Tipo = TIPO_MAQUINA) and not ADto.MaquinaId.HasValue then
    raise EDatoInvalido.Create('Una linea de maquina necesita la maquina.');

  if (ADto.Tipo <> TIPO_MATERIAL) and (ADto.Tipo <> TIPO_MANO_OBRA) and
    (ADto.Tipo <> TIPO_MAQUINA) and (ADto.Tipo <> TIPO_NOTA) then
    raise EDatoInvalido.Create('El tipo de linea no es valido.');

  ALinea.Tipo := ADto.Tipo;
  ALinea.Descripcion := ADto.Descripcion;
  ALinea.UnidadMedida := ADto.UnidadMedida;

  // Solo el id que corresponde al tipo; los otros dos en null, o el CHECK
  // rechaza la fila.
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

  // Una nota no suma: es texto que el cliente lee en el documento.
  if ADto.Tipo = TIPO_NOTA then
  begin
    ALinea.Cantidad := 0;
    ALinea.PrecioUnitario := 0;
    ALinea.Subtotal := 0;
    Exit;
  end;

  lCantidad := ADto.Cantidad.ValueOrDefault;
  if lCantidad <= 0 then
    raise EDatoInvalido.Create('La cantidad debe ser mayor que cero.');

  // El precio que manda el asistente gana; si no manda ninguno, se copia el
  // vigente del catalogo. Copiado, no referenciado.
  if ADto.PrecioUnitario.HasValue then
    lPrecio := ADto.PrecioUnitario.Value
  else
    lPrecio := PrecioDeCatalogo(ADto);

  if lPrecio <= 0 then
    raise EDatoInvalido.Create
      ('El item no tiene precio vigente en el catalogo. Cargue el precio o ' +
      'indiquelo en la linea.');

  ALinea.Cantidad := lCantidad;
  ALinea.PrecioUnitario := lPrecio;
  ALinea.Subtotal := lCantidad * lPrecio;
end;

// Cotizaciones

function TCotizacionService.Buscar(const ATexto, AEstado: string;
  const AClienteId: Integer; const ADesde, AHasta: TDateTime;
  const ASoloPropias: Boolean; const AUsuarioId, APagina, APorPagina: Integer;
  out ATotal: Int64): TObjectList<TCotizacionDTO>;
var
  lFiltroUsuario: Integer;
  lFilas: TObjectList<TCotizaciones>;
  lFila: TCotizaciones;
begin
  if ASoloPropias then
    lFiltroUsuario := AUsuarioId
  else
    lFiltroUsuario := 0;

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

function TCotizacionService.Obtener(const AId: Integer): TCotizacionDTO;
var
  lCotizacion: TCotizaciones;
begin
  lCotizacion := TraerVigente(AId);
  try
    Result := ADto(lCotizacion);
  finally
    lCotizacion.Free;
  end;
end;

function TCotizacionService.ObtenerPorNumero(const ANumero: Integer)
  : TCotizacionDTO;
var
  lCotizacion: TCotizaciones;
begin
  lCotizacion := fRepo.ObtenerPorNumero(ANumero);
  if lCotizacion = nil then
    raise ERecursoNoEncontrado.Create('la cotizacion numero', ANumero);
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
    raise EDatoInvalido.Create('La solicitud indicada no existe.');

  try
    lCotizacion := TCotizaciones.Create;
    try
      lCotizacion.SolicitudId := lSolicitud.ID.ValueOrDefault;
      // El cliente se arrastra de la solicitud y no se recibe: son la misma
      // visita, y recibirlo abriria la puerta a cotizarle a otro.
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

      FijarDetalle(Format('Cotizacion %d desde la solicitud %d',
        [lCotizacion.Numero, lSolicitud.ID.ValueOrDefault]));
      fRepo.Insert(lCotizacion);
      Result := lCotizacion.ID.ValueOrDefault;
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
    raise EDatoInvalido.Create
      ('Falta la version del registro. Recargue la cotizacion y vuelva a editarla.');

  lCotizacion := TraerVigente(AId);
  try
    ExigirEditable(lCotizacion);

    if lCotizacion.Objversion.ValueOrDefault <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create('la cotizacion', AId);

    lCotizacion.TipoTrabajoId := ADto.TipoTrabajoId;
    lCotizacion.DescripcionTrabajo := ADto.DescripcionTrabajo;
    lCotizacion.PorcentajeIva := ADto.PorcentajeIva;
    FijarDetalle('Cambio en la cotizacion ' + lCotizacion.Numero.ToString);
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;

  // El IVA pudo cambiar: el total tiene que reflejarlo.
  Recalcular(AId);
end;

// Detalle

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
      FijarDetalle('Linea agregada a la cotizacion ' +
        lCotizacion.Numero.ToString);
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
      FijarDetalle('Cambio en una linea de la cotizacion ' +
        lCotizacion.Numero.ToString);
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
      FijarDetalle('Linea eliminada de la cotizacion ' +
        lCotizacion.Numero.ToString);
      fDetalle.Delete(lLinea);
    finally
      lLinea.Free;
    end;
  finally
    lCotizacion.Free;
  end;

  Recalcular(AId);
end;

// Totales

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

    // El ajuste va sobre el costo y el impuesto sobre el costo ya ajustado,
    // que es como se factura en Costa Rica.
    lAjustado := lCosto + (lCosto * lCotizacion.PorcentajeAjuste / 100);
    lImpuesto := lAjustado * lCotizacion.PorcentajeIva / 100;

    lCotizacion.MontoImpuesto := lImpuesto;
    lCotizacion.MontoTotal := lAjustado + lImpuesto;

    FijarDetalle('Recalculo de totales de la cotizacion ' +
      lCotizacion.Numero.ToString);
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

    // Lo exige CK_COTIZ_MOTIVO_AJUSTE; se comprueba antes para devolver un 422
    // con mensaje en lugar del error del motor.
    if (ADto.PorcentajeAjuste <> 0) and
      (not ADto.MotivoAjuste.HasValue or ADto.MotivoAjuste.Value.IsEmpty) then
      raise EDatoInvalido.Create
        ('Un ajuste distinto de cero exige indicar el motivo.');

    lCotizacion.PorcentajeAjuste := ADto.PorcentajeAjuste;
    if ADto.PorcentajeAjuste = 0 then
      lCotizacion.MotivoAjuste.Clear
    else
      lCotizacion.MotivoAjuste := ADto.MotivoAjuste;

    FijarDetalle(Format('Ajuste de %s%% en la cotizacion %d',
      [CurrToStr(ADto.PorcentajeAjuste), lCotizacion.Numero]));
    fRepo.Update(lCotizacion);
  finally
    lCotizacion.Free;
  end;

  Recalcular(AId);
end;

// Estados

procedure TCotizacionService.Enviar(const AId: Integer);
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

    // Enviar una cotizacion sin lineas manda al cliente un documento en cero.
    // Se trae el detalle en lugar de contarlo: son unas pocas filas y evita
    // otra consulta con nombre propio en el repositorio.
    lLineas := fDetalle.DetalleDe(AId);
    try
      lVacia := lLineas.Count = 0;
    finally
      lLineas.Free;
    end;
    if lVacia then
      raise EConflictoDeEstado.Create('COTIZACION_SIN_DETALLE',
        'La cotizacion no tiene lineas: no hay nada que enviar.');

    lCotizacion.Estado := ESTADO_ENVIADA;
    lCotizacion.FechaEnvio := Now;
    FijarDetalle('Envio de la cotizacion ' + lCotizacion.Numero.ToString);
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
    // Solo se aprueba lo que se envio a revision.
    if lCotizacion.Estado <> ESTADO_ENVIADA then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format('Una cotizacion en estado %s no se puede aprobar.',
        [lCotizacion.Estado]));

    lCotizacion.Estado := ESTADO_APROBADA;
    lCotizacion.AprobadaPor := UsuarioActual;
    lCotizacion.FechaAprobacion := Now;
    FijarDetalle('Aprobacion de la cotizacion ' +
      lCotizacion.Numero.ToString);
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

  // Lo exige CK_COTIZ_MOTIVO_RECHAZO, y ademas es condicion de aceptacion de
  // la HU-07: un rechazo sin motivo no le dice nada a quien la rehace.
  if ADto.Motivo.IsEmpty then
    raise EDatoInvalido.Create('Rechazar exige indicar el motivo.');

  lCotizacion := TraerVigente(AId);
  try
    if lCotizacion.Estado <> ESTADO_ENVIADA then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format('Una cotizacion en estado %s no se puede rechazar.',
        [lCotizacion.Estado]));

    lCotizacion.Estado := ESTADO_RECHAZADA;
    lCotizacion.MotivoRechazo := ADto.Motivo;
    FijarDetalle('Rechazo de la cotizacion ' + lCotizacion.Numero.ToString);
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
    raise EDatoInvalido.Create('Devolver exige una observacion.');

  lCotizacion := TraerVigente(AId);
  try
    // Devolver no es rechazar: vuelve al asistente para corregirla, y por eso
    // regresa a un estado editable en lugar de cerrarse.
    if lCotizacion.Estado <> ESTADO_ENVIADA then
      raise EConflictoDeEstado.Create('TRANSICION_INVALIDA',
        Format('Una cotizacion en estado %s no se puede devolver.',
        [lCotizacion.Estado]));

    lCotizacion.Estado := ESTADO_EN_PROCESO;
    lCotizacion.MotivoRechazo := ADto.Motivo;
    lCotizacion.FechaEnvio.Clear;
    FijarDetalle('Devolucion de la cotizacion ' +
      lCotizacion.Numero.ToString);
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
