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
  Anovo.Controllers.Base,
  Anovo.Services.Intf.Cotizaciones,
  Anovo.Services.Intf.Documento,
  Anovo.Services.Intf.EnvioCotizacion,
  Anovo.DTOs.Correo,
  Anovo.Permisos;

const

  PERMISO_VER = PERMISO_COTIZACIONES_VER_APROBADAS_PROPIAS + SEPARADOR_PERMISOS +
    PERMISO_COTIZACIONES_VER_PROPIAS + SEPARADOR_PERMISOS +
    PERMISO_COTIZACIONES_VER_TODAS;



type

  [MVCPath('/api/cotizaciones')]
  [MVCRequiresPermiso(PERMISO_VER)]
  TCotizacionesController = class(TControllerBase)
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
    [MVCSwagParam(plQuery, 'elaboradas', 'propias: solo las que elaboro ' +
      'quien consulta', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagResponses(200, 'Pagina de cotizaciones', TCotizacionesPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Listar([MVCInject] AServicio: ICotizacionService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('estado', '')] AEstado: string;
      const [MVCFromQueryString('cliente_id', 0)] AClienteId: Integer;
      const [MVCFromQueryString('desde', '')] ADesde: string;
      const [MVCFromQueryString('hasta', '')] AHasta: string;
      const [MVCFromQueryString('elaboradas', '')] AElaboradas: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer): TCotizacionesPaginaDTO;

    [MVCPath('/bandeja')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_APROBAR)]
    [MVCSwagSummary('Cotizaciones', 'Pendientes que el usuario del token ' +
      'puede revisar, la mas antigua primero, con el resumen de la bandeja',
      'bandejaCotizaciones')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en el cliente o la ' +
      'descripcion', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'desde', 'Fecha desde, aaaa-mm-dd', ptString,
      False)]
    [MVCSwagParam(plQuery, 'hasta', 'Fecha hasta, aaaa-mm-dd, incluida',
      ptString, False)]
    [MVCSwagResponses(200, 'Pagina de la bandeja', TBandejaPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Bandeja([MVCInject] AServicio: ICotizacionService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('desde', '')] AFiltroDesde: string;
      const [MVCFromQueryString('hasta', '')] AFiltroHasta: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer): TBandejaPaginaDTO;

    [MVCPath('/sin-respuesta')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_RESPONDER)]
    [MVCSwagSummary('Cotizaciones', 'Enviadas hace mas de los dias ' +
      'configurados en la empresa y sin respuesta del cliente',
      'cotizacionesSinRespuesta')]
    [MVCSwagResponses(200, 'Las que llevan mas dias esperando')]
    [MVCSwagResponses(403, 'Sin el permiso de elaborar cotizaciones')]
    function SinRespuesta([MVCInject] AServicio: ICotizacionService)
      : IMVCResponse;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Cotizaciones', 'Obtiene una cotizacion por su numero ' +
      'interno', 'obtenerCotizacion')]
    [MVCSwagResponses(200, 'La cotizacion', TCotizacionDTO)]
    [MVCSwagResponses(404, 'No existe cotizacion con ese numero, o es de ' +
      'una solicitud de otro asesor')]
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
    [MVCRequiresPermiso(PERMISO_SOLICITUDES_TOMAR)]
    [MVCSwagSummary('Cotizaciones', 'Crea una cotizacion desde una solicitud. ' +
      'Nace en borrador con su consecutivo', 'crearCotizacion')]
    [MVCSwagResponses(201, 'Creada. Location apunta a la cotizacion')]
    [MVCSwagResponses(422, 'La solicitud indicada no existe')]
    function Crear([MVCInject] AServicio: ICotizacionService;
      const [MVCFromBody] ADto: TCotizacionNuevaDTO): IMVCResponse;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_ELABORAR + SEPARADOR_PERMISOS +
      PERMISO_COTIZACIONES_ELABORAR_PROPIAS)]
    [MVCSwagSummary('Cotizaciones', 'Actualiza la cabecera y recalcula',
      'actualizarCotizacion')]
    [MVCSwagResponses(204, 'Actualizada')]
    [MVCSwagResponses(409, 'Ya fue enviada, o otra persona la modifico')]
    function Actualizar([MVCInject] AServicio: ICotizacionService;
      const AId: Integer;
      const [MVCFromBody] ADto: TCotizacionEdicionDTO): IMVCResponse;

    [MVCPath('/($AId)/estados')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Cotizaciones', 'Historial de estados: cada paso con ' +
      'fecha, usuario y motivo, el mas reciente primero (HU-07)',
      'historialCotizacion')]
    [MVCSwagResponses(200, 'Los pasos de la cotizacion')]
    [MVCSwagResponses(404, 'No existe, o es de una solicitud de otro asesor')]
    function Estados([MVCInject] AServicio: ICotizacionService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/detalle')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Cotizaciones', 'Las lineas de la cotizacion',
      'listarDetalle')]
    [MVCSwagResponses(200, 'El detalle, en su orden')]
    function Detalle([MVCInject] AServicio: ICotizacionService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/envio-correo')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_RESPONDER)]
    [MVCSwagSummary('Cotizaciones', 'Envia la cotizacion con visto bueno al ' +
      'cliente por correo, con el PDF adjunto, y la marca como enviada',
      'enviarCotizacionPorCorreo')]
    [MVCSwagResponses(204, 'Enviada')]
    [MVCSwagResponses(409, 'No tiene visto bueno, o el correo no esta ' +
      'configurado')]
    [MVCSwagResponses(422, 'Destinatario, asunto o PDF no validos')]
    [MVCSwagResponses(502, 'El servidor de correo rechazo el envio')]
    function EnviarPorCorreo([MVCInject] AServicio: IEnvioCotizacionService;
      const AId: Integer;
      const [MVCFromBody] ADto: TEnvioCorreoDTO): IMVCResponse;

    [MVCPath('/($AId)/documento')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_ELABORAR + SEPARADOR_PERMISOS +
      PERMISO_COTIZACIONES_ELABORAR_PROPIAS + SEPARADOR_PERMISOS +
      PERMISO_COTIZACIONES_APROBAR + SEPARADOR_PERMISOS +
      PERMISO_COTIZACIONES_RESPONDER)]
    [MVCSwagSummary('Cotizaciones', 'Datos del documento que se envia al ' +
      'cliente: encabezado de la empresa, cliente, condiciones y totales',
      'obtenerDocumento')]
    [MVCSwagResponses(200, 'El documento de la cotizacion')]
    [MVCSwagResponses(403, 'Solo quien elabora o aprueba cotizaciones')]
    [MVCSwagResponses(404, 'No existe o no es de las solicitudes del asesor')]
    function Documento([MVCInject] AServicio: ICotizacionDocumentoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/detalle')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_ELABORAR + SEPARADOR_PERMISOS +
      PERMISO_COTIZACIONES_ELABORAR_PROPIAS)]
    [MVCSwagSummary('Cotizaciones', 'Agrega una linea. El precio se copia ' +
      'del catalogo si no viene en el cuerpo', 'agregarLinea')]
    [MVCSwagResponses(201, 'Creada')]
    [MVCSwagResponses(422, 'Falta el item, la cantidad o el precio vigente')]
    function AgregarLinea([MVCInject] AServicio: ICotizacionService;
      const AId: Integer;
      const [MVCFromBody] ADto: TLineaNuevaDTO): IMVCResponse;

    [MVCPath('/($AId)/detalle/($ALineaId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_ELABORAR + SEPARADOR_PERMISOS +
      PERMISO_COTIZACIONES_ELABORAR_PROPIAS)]
    [MVCSwagSummary('Cotizaciones', 'Actualiza una linea y recalcula',
      'actualizarLinea')]
    [MVCSwagResponses(204, 'Actualizada')]
    function ActualizarLinea([MVCInject] AServicio: ICotizacionService;
      const AId: Integer; const ALineaId: Integer;
      const [MVCFromBody] ADto: TLineaNuevaDTO): IMVCResponse;

    [MVCPath('/($AId)/detalle/($ALineaId)')]
    [MVCHTTPMethods([httpDELETE])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_ELABORAR + SEPARADOR_PERMISOS +
      PERMISO_COTIZACIONES_ELABORAR_PROPIAS)]
    [MVCSwagSummary('Cotizaciones', 'Elimina una linea y recalcula',
      'eliminarLinea')]
    [MVCSwagResponses(204, 'Eliminada')]
    function EliminarLinea([MVCInject] AServicio: ICotizacionService;
      const AId: Integer; const ALineaId: Integer): IMVCResponse;

    [MVCPath('/($AId)/ajuste')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_ELABORAR + SEPARADOR_PERMISOS +
      PERMISO_COTIZACIONES_ELABORAR_PROPIAS)]
    [MVCSwagSummary('Cotizaciones', 'Aplica el ajuste comercial. Con ' +
      'porcentaje distinto de cero el motivo es obligatorio', 'aplicarAjuste')]
    [MVCSwagResponses(204, 'Ajuste aplicado')]
    [MVCSwagResponses(422, 'Ajuste sin motivo')]
    function AplicarAjuste([MVCInject] AServicio: ICotizacionService;
      const AId: Integer;
      const [MVCFromBody] ADto: TAjusteDTO): IMVCResponse;

    [MVCPath('/($AId)/presentacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_ELABORAR + SEPARADOR_PERMISOS +
      PERMISO_COTIZACIONES_ELABORAR_PROPIAS)]
    [MVCSwagSummary('Cotizaciones', 'Presenta la cotizacion a revision. ' +
      'Desde aqui ya no se modifica', 'presentarCotizacion')]
    [MVCSwagResponses(204, 'Pendiente de aprobacion')]
    [MVCSwagResponses(409, 'No tiene lineas, o no esta en borrador')]
    function Presentar([MVCInject] AServicio: ICotizacionService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/envio')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_RESPONDER)]
    [MVCSwagSummary('Cotizaciones', 'Registra que la cotizacion con visto ' +
      'bueno se envio al cliente', 'enviarCotizacion')]
    [MVCSwagResponses(204, 'Enviada al cliente')]
    [MVCSwagResponses(409, 'No tiene el visto bueno')]
    function Enviar([MVCInject] AServicio: ICotizacionService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/descarte')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_RESPONDER)]
    [MVCSwagSummary('Cotizaciones', 'Descarta el aviso de una cotizacion ' +
      'enviada sin respuesta del cliente. La respuesta se puede registrar ' +
      'despues', 'descartarCotizacion')]
    [MVCSwagResponses(204, 'Descartada')]
    [MVCSwagResponses(409, 'No esta enviada al cliente')]
    function Descartar([MVCInject] AServicio: ICotizacionService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/visto-bueno')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_APROBAR)]
    [MVCSwagSummary('Cotizaciones', 'Da el visto bueno a la cotizacion en ' +
      'revision: queda lista para enviar al cliente', 'vistoBuenoCotizacion')]
    [MVCSwagResponses(204, 'Con visto bueno')]
    [MVCSwagResponses(409, 'No esta en revision, o la elaboro quien revisa')]
    function DarVistoBueno([MVCInject] AServicio: ICotizacionService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/respuesta')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_RESPONDER)]
    [MVCSwagSummary('Cotizaciones', 'Registra la respuesta del cliente a la ' +
      'cotizacion enviada: aceptada queda aprobada; si no, rechazada',
      'respuestaCotizacion')]
    [MVCSwagResponses(204, 'Respuesta registrada')]
    [MVCSwagResponses(409, 'No esta enviada al cliente ni descartada')]
    function RegistrarRespuesta([MVCInject] AServicio: ICotizacionService;
      const AId: Integer;
      const [MVCFromBody] ADto: TRespuestaClienteDTO): IMVCResponse;

    [MVCPath('/($AId)/devolucion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_APROBAR)]
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
  System.SysUtils,
  System.Generics.Collections;

const
  ELABORADAS_PROPIAS = 'propias';

function TCotizacionesController.Listar(AServicio: ICotizacionService;
  const ABusqueda, AEstado: string;
  const AClienteId: Integer; const ADesde, AHasta, AElaboradas: string;
  const APagina, APorPagina: Integer): TCotizacionesPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDatos: TObjectList<TCotizacionDTO>;
begin
  lPagina := PaginaValida(APagina);
  lPorPagina := PorPaginaValida(APorPagina);

  lDatos := AServicio.Buscar(ABusqueda, AEstado, AClienteId,
    ComoFecha(ADesde), ComoFecha(AHasta),
    SameText(AElaboradas, ELABORADAS_PROPIAS), Roles, UsuarioId,
    lPagina, lPorPagina, lTotal);

  Result := TCotizacionesPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
end;

function TCotizacionesController.Bandeja(AServicio: ICotizacionService;
  const ABusqueda, AFiltroDesde, AFiltroHasta: string;
  const APagina, APorPagina: Integer): TBandejaPaginaDTO;
begin
  Result := AServicio.Bandeja(UsuarioId, ABusqueda, ComoFecha(AFiltroDesde),
    ComoFecha(AFiltroHasta), PaginaValida(APagina), PorPaginaValida(APorPagina));
end;

function TCotizacionesController.SinRespuesta(AServicio: ICotizacionService)
  : IMVCResponse;
begin
  Result := OKResponse(AServicio.EnviadasSinRespuesta);
end;

function TCotizacionesController.Obtener(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Obtener(AId, UsuarioId, Roles));
end;

function TCotizacionesController.ObtenerPorNumero(AServicio: ICotizacionService;
  const ANumero: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.ObtenerPorNumero(ANumero, UsuarioId,
    Roles));
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
  AServicio.Actualizar(AId, ADto, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TCotizacionesController.Estados(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Estados(AId, UsuarioId, Roles));
end;

function TCotizacionesController.Detalle(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Detalle(AId, UsuarioId, Roles));
end;

function TCotizacionesController.EnviarPorCorreo(AServicio
  : IEnvioCotizacionService; const AId: Integer;
  const ADto: TEnvioCorreoDTO): IMVCResponse;
begin
  AServicio.Enviar(AId, UsuarioId, Roles, ADto);
  Result := NoContentResponse;
end;

function TCotizacionesController.Documento(AServicio
  : ICotizacionDocumentoService; const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Documento(AId, UsuarioId, Roles));
end;

function TCotizacionesController.AgregarLinea(AServicio: ICotizacionService;
  const AId: Integer; const ADto: TLineaNuevaDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/cotizaciones/' + AId.ToString + '/detalle/' +
    AServicio.AgregarLinea(AId, ADto, UsuarioId, Roles).ToString);
end;

function TCotizacionesController.ActualizarLinea(AServicio: ICotizacionService;
  const AId, ALineaId: Integer; const ADto: TLineaNuevaDTO): IMVCResponse;
begin
  AServicio.ActualizarLinea(AId, ALineaId, ADto, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TCotizacionesController.EliminarLinea(AServicio: ICotizacionService;
  const AId, ALineaId: Integer): IMVCResponse;
begin
  AServicio.EliminarLinea(AId, ALineaId, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TCotizacionesController.AplicarAjuste(AServicio: ICotizacionService;
  const AId: Integer; const ADto: TAjusteDTO): IMVCResponse;
begin
  AServicio.AplicarAjuste(AId, ADto, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TCotizacionesController.Presentar(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.Presentar(AId, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TCotizacionesController.Enviar(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.Enviar(AId, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TCotizacionesController.Descartar(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.Descartar(AId, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TCotizacionesController.DarVistoBueno(AServicio: ICotizacionService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.DarVistoBueno(AId, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TCotizacionesController.RegistrarRespuesta(
  AServicio: ICotizacionService; const AId: Integer;
  const ADto: TRespuestaClienteDTO): IMVCResponse;
begin
  AServicio.RegistrarRespuesta(AId, ADto, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TCotizacionesController.Devolver(AServicio: ICotizacionService;
  const AId: Integer; const ADto: TMotivoDTO): IMVCResponse;
begin
  AServicio.Devolver(AId, ADto, UsuarioId, Roles);
  Result := NoContentResponse;
end;

end.
