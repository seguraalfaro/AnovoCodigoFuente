unit Anovo.Controllers.Cotizaciones;

// Cotizaciones bajo /api/cotizaciones: elaborar, enviar a
// aprobacion, aprobar, rechazar y enviar al cliente.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.DTOs.Cotizaciones,
  Anovo.Services.Intf.Cotizaciones,
  Anovo.Services.Intf.Permisos;

const
  PERMISO_VER_TODAS = 'cotizaciones.ver_todas';
  PERMISO_VER_PROPIAS = 'cotizaciones.ver_aprobadas_propias';
  PERMISO_ELABORAR = 'cotizaciones.elaborar';
  PERMISO_APROBAR = 'cotizaciones.aprobar';

  PERMISO_VER = PERMISO_VER_PROPIAS + ';' + PERMISO_VER_TODAS;

  POR_PAGINA_POR_DEFECTO = 50;
  POR_PAGINA_MAXIMO = 200;

  DIAS_SIN_RESPUESTA = 7;

type

  [MVCPath('/api/cotizaciones')]
  [MVCRequiresPermiso(PERMISO_VER)]
  TCotizacionesController = class(TMVCController)
  private
    function UsuarioId: Integer;
    function SoloPropias(const APermisos: IPermisoService): Boolean;
  public
    [MVCPath]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Cotizaciones', 'Lista y busca cotizaciones, paginado',
      'listarCotizaciones')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en la descripcion del trabajo',
      ptString, False)]
    [MVCSwagParam(plQuery, 'estado', 'Filtra por estado', ptString, False)]
    [MVCSwagParam(plQuery, 'cliente_id', 'Filtra por cliente',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'desde', 'Fecha de elaboracion desde, aaaa-mm-dd',
      ptString, False)]
    [MVCSwagParam(plQuery, 'hasta', 'Fecha de elaboracion hasta, aaaa-mm-dd',
      ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagResponses(200, 'Pagina de cotizaciones', TCotizacionesPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Listar([MVCInject] AServicio: ICotizacionService;
      [MVCInject] APermisos: IPermisoService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('estado', '')] AEstado: string;
      const [MVCFromQueryString('cliente_id', 0)] AClienteId: Integer;
      const [MVCFromQueryString('desde', '')] ADesde: string;
      const [MVCFromQueryString('hasta', '')] AHasta: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer): TCotizacionesPaginaDTO;

    [MVCPath('/bandeja')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_APROBAR)]
    [MVCSwagSummary('Cotizaciones', 'Pendientes que el usuario del token ' +
      'puede revisar, la mas antigua primero, con el resumen de la bandeja',
      'bandejaCotizaciones')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en el cliente o la ' +
      'descripcion', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagResponses(200, 'Pagina de la bandeja', TBandejaPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Bandeja([MVCInject] AServicio: ICotizacionService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer): TBandejaPaginaDTO;

    [MVCPath('/sin-respuesta')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Cotizaciones', 'Enviadas hace mas de siete dias y sin ' +
      'respuesta del cliente', 'cotizacionesSinRespuesta')]
    [MVCSwagResponses(200, 'Las que llevan mas dias esperando')]
    function SinRespuesta([MVCInject] AServicio: ICotizacionService)
      : IMVCResponse;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Cotizaciones', 'Obtiene una cotizacion por su numero ' +
      'interno', 'obtenerCotizacion')]
    [MVCSwagResponses(200, 'La cotizacion', TCotizacionDTO)]
    [MVCSwagResponses(404, 'No existe cotizacion con ese numero')]
    function Obtener([MVCInject] AServicio: ICotizacionService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/numero/($ANumero)')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Cotizaciones', 'Obtiene una cotizacion por el ' +
      'consecutivo que ve el cliente', 'obtenerCotizacionPorNumero')]
    [MVCSwagResponses(200, 'La cotizacion', TCotizacionDTO)]
    function ObtenerPorNumero([MVCInject] AServicio: ICotizacionService;
      const ANumero: Integer): IMVCResponse;

    [MVCPath]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_ELABORAR)]
    [MVCSwagSummary('Cotizaciones', 'Crea una cotizacion desde una solicitud. ' +
      'Nace en borrador con su consecutivo', 'crearCotizacion')]
    [MVCSwagResponses(201, 'Creada. Location apunta a la cotizacion')]
    [MVCSwagResponses(422, 'La solicitud indicada no existe')]
    function Crear([MVCInject] AServicio: ICotizacionService;
      const [MVCFromBody] ADto: TCotizacionNuevaDTO): IMVCResponse;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_ELABORAR)]
    [MVCSwagSummary('Cotizaciones', 'Actualiza la cabecera y recalcula',
      'actualizarCotizacion')]
    [MVCSwagResponses(204, 'Actualizada')]
    [MVCSwagResponses(409, 'Ya fue enviada, o otra persona la modifico')]
    function Actualizar([MVCInject] AServicio: ICotizacionService;
      const AId: Integer;
      const [MVCFromBody] ADto: TCotizacionEdicionDTO): IMVCResponse;

    [MVCPath('/($AId)/detalle')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Cotizaciones', 'Las lineas de la cotizacion',
      'listarDetalle')]
    [MVCSwagResponses(200, 'El detalle, en su orden')]
    function Detalle([MVCInject] AServicio: ICotizacionService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/detalle')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_ELABORAR)]
    [MVCSwagSummary('Cotizaciones', 'Agrega una linea. El precio se copia ' +
      'del catalogo si no viene en el cuerpo', 'agregarLinea')]
    [MVCSwagResponses(201, 'Creada')]
    [MVCSwagResponses(422, 'Falta el item, la cantidad o el precio vigente')]
    function AgregarLinea([MVCInject] AServicio: ICotizacionService;
      const AId: Integer;
      const [MVCFromBody] ADto: TLineaNuevaDTO): IMVCResponse;

    [MVCPath('/($AId)/detalle/($ALineaId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_ELABORAR)]
    [MVCSwagSummary('Cotizaciones', 'Actualiza una linea y recalcula',
      'actualizarLinea')]
    [MVCSwagResponses(204, 'Actualizada')]
    function ActualizarLinea([MVCInject] AServicio: ICotizacionService;
      const AId: Integer; const ALineaId: Integer;
      const [MVCFromBody] ADto: TLineaNuevaDTO): IMVCResponse;

    [MVCPath('/($AId)/detalle/($ALineaId)')]
    [MVCHTTPMethods([httpDELETE])]
    [MVCRequiresPermiso(PERMISO_ELABORAR)]
    [MVCSwagSummary('Cotizaciones', 'Elimina una linea y recalcula',
      'eliminarLinea')]
    [MVCSwagResponses(204, 'Eliminada')]
    function EliminarLinea([MVCInject] AServicio: ICotizacionService;
      const AId: Integer; const ALineaId: Integer): IMVCResponse;

    [MVCPath('/($AId)/ajuste')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_ELABORAR)]
    [MVCSwagSummary('Cotizaciones', 'Aplica el ajuste comercial. Con ' +
      'porcentaje distinto de cero el motivo es obligatorio', 'aplicarAjuste')]
    [MVCSwagResponses(204, 'Ajuste aplicado')]
    [MVCSwagResponses(422, 'Ajuste sin motivo')]
    function AplicarAjuste([MVCInject] AServicio: ICotizacionService;
      const AId: Integer;
      const [MVCFromBody] ADto: TAjusteDTO): IMVCResponse;

    [MVCPath('/($AId)/presentacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_ELABORAR)]
    [MVCSwagSummary('Cotizaciones', 'Presenta la cotizacion a revision. ' +
      'Desde aqui ya no se modifica', 'presentarCotizacion')]
    [MVCSwagResponses(204, 'Pendiente de aprobacion')]
    [MVCSwagResponses(409, 'No tiene lineas, o no esta en borrador')]
    function Presentar([MVCInject] AServicio: ICotizacionService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/envio')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_ELABORAR)]
    [MVCSwagSummary('Cotizaciones', 'Registra que la cotizacion aprobada se ' +
      'envio al cliente', 'enviarCotizacion')]
    [MVCSwagResponses(204, 'Enviada al cliente')]
    [MVCSwagResponses(409, 'No esta aprobada')]
    function Enviar([MVCInject] AServicio: ICotizacionService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/aprobacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_APROBAR)]
    [MVCSwagSummary('Cotizaciones', 'Aprueba la cotizacion',
      'aprobarCotizacion')]
    [MVCSwagResponses(204, 'Aprobada')]
    [MVCSwagResponses(409, 'No esta en un estado que permita aprobarla')]
    function Aprobar([MVCInject] AServicio: ICotizacionService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/rechazo')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_APROBAR)]
    [MVCSwagSummary('Cotizaciones', 'Rechaza la cotizacion. El motivo es ' +
      'obligatorio', 'rechazarCotizacion')]
    [MVCSwagResponses(204, 'Rechazada')]
    [MVCSwagResponses(422, 'Falta el motivo')]
    function Rechazar([MVCInject] AServicio: ICotizacionService;
      const AId: Integer;
      const [MVCFromBody] ADto: TMotivoDTO): IMVCResponse;

    [MVCPath('/($AId)/devolucion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_APROBAR)]
    [MVCSwagSummary('Cotizaciones', 'Devuelve la cotizacion al asistente con ' +
      'observaciones. Vuelve a ser editable', 'devolverCotizacion')]
    [MVCSwagResponses(204, 'Devuelta')]
    [MVCSwagResponses(422, 'Falta la observacion')]
    function Devolver([MVCInject] AServicio: ICotizacionService;
      const AId: Integer;
      const [MVCFromBody] ADto: TMotivoDTO): IMVCResponse;
  end;

implementation

uses
  System.Math,
  System.SysUtils,
  System.Generics.Collections;

function TCotizacionesController.UsuarioId: Integer;
var
  lTexto: string;
begin
  lTexto := '';
  if Assigned(Context.LoggedUser.CustomData) then
    Context.LoggedUser.CustomData.TryGetValue('USUARIO_ID', lTexto);
  if not TryStrToInt(lTexto, Result) then
    Result := 0;
end;

function TCotizacionesController.SoloPropias(const APermisos
  : IPermisoService): Boolean;
var
  lRol: string;
begin
  for lRol in Context.LoggedUser.Roles do
    if APermisos.Tiene(UsuarioId, lRol, PERMISO_VER_TODAS) then
      Exit(False);
  Result := True;
end;

function ComoFecha(const ATexto: string): TDateTime;
var
  lFormato: TFormatSettings;
begin
  if ATexto.IsEmpty then
    Exit(0);
  lFormato := TFormatSettings.Create;
  lFormato.DateSeparator := '-';
  lFormato.ShortDateFormat := 'yyyy-mm-dd';
  if not TryStrToDate(ATexto, Result, lFormato) then
    Result := 0;
end;

function TCotizacionesController.Listar(AServicio: ICotizacionService;
  APermisos: IPermisoService; const ABusqueda, AEstado: string;
  const AClienteId: Integer; const ADesde, AHasta: string;
  const APagina, APorPagina: Integer): TCotizacionesPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lHasta: TDateTime;
  lDatos: TObjectList<TCotizacionDTO>;
begin
  lPagina := Max(APagina, 1);
  lPorPagina := EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO);

  lHasta := ComoFecha(AHasta);
  if lHasta > 0 then
    lHasta := lHasta + 1 - (1 / SecsPerDay);

  lDatos := AServicio.Buscar(ABusqueda, AEstado, AClienteId,
    ComoFecha(ADesde), lHasta, SoloPropias(APermisos), UsuarioId,
    lPagina, lPorPagina, lTotal);

  Result := TCotizacionesPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
end;

function TCotizacionesController.Bandeja(AServicio: ICotizacionService;
  const ABusqueda: string; const APagina, APorPagina: Integer)
  : TBandejaPaginaDTO;
begin
  Result := AServicio.Bandeja(UsuarioId, ABusqueda, Max(APagina, 1),
    EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO));
end;

function TCotizacionesController.SinRespuesta(AServicio: ICotizacionService)
  : IMVCResponse;
begin
  Result := OKResponse(AServicio.EnviadasSinRespuesta(DIAS_SIN_RESPUESTA));
end;

function TCotizacionesController.Obtener(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Obtener(AId));
end;

function TCotizacionesController.ObtenerPorNumero(AServicio: ICotizacionService;
  const ANumero: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.ObtenerPorNumero(ANumero));
end;

function TCotizacionesController.Crear(AServicio: ICotizacionService;
  const ADto: TCotizacionNuevaDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/cotizaciones/' +
    AServicio.CrearDesdeSolicitud(ADto).ToString);
end;

function TCotizacionesController.Actualizar(AServicio: ICotizacionService;
  const AId: Integer; const ADto: TCotizacionEdicionDTO): IMVCResponse;
begin
  AServicio.Actualizar(AId, ADto);
  Result := NoContentResponse;
end;

function TCotizacionesController.Detalle(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Detalle(AId));
end;

function TCotizacionesController.AgregarLinea(AServicio: ICotizacionService;
  const AId: Integer; const ADto: TLineaNuevaDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/cotizaciones/' + AId.ToString + '/detalle/' +
    AServicio.AgregarLinea(AId, ADto).ToString);
end;

function TCotizacionesController.ActualizarLinea(AServicio: ICotizacionService;
  const AId, ALineaId: Integer; const ADto: TLineaNuevaDTO): IMVCResponse;
begin
  AServicio.ActualizarLinea(AId, ALineaId, ADto);
  Result := NoContentResponse;
end;

function TCotizacionesController.EliminarLinea(AServicio: ICotizacionService;
  const AId, ALineaId: Integer): IMVCResponse;
begin
  AServicio.EliminarLinea(AId, ALineaId);
  Result := NoContentResponse;
end;

function TCotizacionesController.AplicarAjuste(AServicio: ICotizacionService;
  const AId: Integer; const ADto: TAjusteDTO): IMVCResponse;
begin
  AServicio.AplicarAjuste(AId, ADto);
  Result := NoContentResponse;
end;

function TCotizacionesController.Presentar(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.Presentar(AId);
  Result := NoContentResponse;
end;

function TCotizacionesController.Enviar(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.Enviar(AId);
  Result := NoContentResponse;
end;

function TCotizacionesController.Aprobar(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.Aprobar(AId);
  Result := NoContentResponse;
end;

function TCotizacionesController.Rechazar(AServicio: ICotizacionService;
  const AId: Integer; const ADto: TMotivoDTO): IMVCResponse;
begin
  AServicio.Rechazar(AId, ADto);
  Result := NoContentResponse;
end;

function TCotizacionesController.Devolver(AServicio: ICotizacionService;
  const AId: Integer; const ADto: TMotivoDTO): IMVCResponse;
begin
  AServicio.Devolver(AId, ADto);
  Result := NoContentResponse;
end;

end.
