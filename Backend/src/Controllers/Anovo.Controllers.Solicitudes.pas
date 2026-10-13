unit Anovo.Controllers.Solicitudes;

// Solicitudes bajo /api/solicitudes: captura del movil,
// listado, seguimiento del asesor y cambios de estado.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.DTOs.Solicitudes,
  Anovo.Controllers.Base,
  Anovo.Services.Intf.Solicitudes,
  Anovo.DTOs.Dashboard,
  Anovo.Permisos;

const

  PERMISO_VER = PERMISO_SOLICITUDES_VER_PROPIAS + SEPARADOR_PERMISOS +
    PERMISO_SOLICITUDES_VER_TODAS;
  PERMISO_EDITAR = PERMISO_SOLICITUDES_EDITAR_PROPIAS + SEPARADOR_PERMISOS +
    PERMISO_SOLICITUDES_EDITAR_TODAS;

  POR_PAGINA_POR_DEFECTO = 50;
  POR_PAGINA_MAXIMO = 200;

  PERIODO_MES = 'mes';
  PERIODO_TODO = 'todo';

type

  [MVCPath('/api/solicitudes')]
  [MVCRequiresPermiso(PERMISO_VER)]
  TSolicitudesController = class(TControllerBase)
  public
    [MVCPath]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Solicitudes', 'Lista y busca solicitudes, paginado',
      'listarSolicitudes')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en descripcion u ' +
      'observaciones', ptString, False)]
    [MVCSwagParam(plQuery, 'estado', 'Filtra por estado', ptString, False)]
    [MVCSwagParam(plQuery, 'desde', 'Fecha de captura desde, aaaa-mm-dd',
      ptString, False)]
    [MVCSwagParam(plQuery, 'hasta', 'Fecha de captura hasta, aaaa-mm-dd',
      ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagResponses(200, 'Pagina de solicitudes', TSolicitudesPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Listar([MVCInject] AServicio: ISolicitudService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('estado', '')] AEstado: string;
      const [MVCFromQueryString('desde', '')] ADesde: string;
      const [MVCFromQueryString('hasta', '')] AHasta: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer): TSolicitudesPaginaDTO;

    [MVCPath('/cola')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_ELABORAR)]
    [MVCSwagSummary('Solicitudes', 'Cola comun: recibidas sin cotizacion, ' +
      'la mas antigua primero, paginada', 'colaSolicitudes')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en el cliente o la ' +
      'descripcion', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagResponses(200, 'Pagina de la cola', TColaPaginaDTO)]
    function Cola([MVCInject] AServicio: ISolicitudService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer): TColaPaginaDTO;

    [MVCPath('/en-trabajo')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_ELABORAR)]
    [MVCSwagSummary('Solicitudes', 'Las que el usuario del token tomo y ' +
      'siguen en curso: borrador, pendiente o aprobada sin enviar',
      'solicitudesEnTrabajo')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en el cliente o la ' +
      'descripcion', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagResponses(200, 'Pagina de las propias', TEnTrabajoPaginaDTO)]
    function EnTrabajo([MVCInject] AServicio: ISolicitudService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer): TEnTrabajoPaginaDTO;

    [MVCPath('/seguimiento')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_SOLICITUDES_VER_PROPIAS)]
    [MVCSwagSummary('Solicitudes', 'Las del asesor que consulta, con el ' +
      'estado como lo ve el: el de la cotizacion si esta aprobada o enviada ' +
      'al cliente, el de la solicitud si no (HU-03)', 'seguimientoSolicitudes')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en el cliente o la ' +
      'descripcion', ptString, False)]
    [MVCSwagParam(plQuery, 'periodo', 'mes (el mes en curso, por defecto) o ' +
      'todo (el historial completo)', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagResponses(200, 'Pagina del seguimiento', TSeguimientoPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Seguimiento([MVCInject] AServicio: ISolicitudService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('periodo', PERIODO_MES)] APeriodo: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer): TSeguimientoPaginaDTO;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Solicitudes', 'Obtiene una solicitud por su numero',
      'obtenerSolicitud')]
    [MVCSwagResponses(200, 'La solicitud', TSolicitudDTO)]
    [MVCSwagResponses(404, 'No existe solicitud con ese numero')]
    function Obtener([MVCInject] AServicio: ISolicitudService;
      const AId: Integer): IMVCResponse;

    [MVCPath]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_SOLICITUDES_CREAR)]
    [MVCSwagSummary('Solicitudes', 'Registra una solicitud. Idempotente por ' +
      'uuid_local', 'crearSolicitud')]
    [MVCSwagResponses(201, 'Creada. Location apunta a la solicitud')]
    [MVCSwagResponses(422, 'Falta el uuid local o el cliente no existe')]
    function Crear([MVCInject] AServicio: ISolicitudService;
      const [MVCFromBody] ADto: TSolicitudNuevaDTO): IMVCResponse;

    [MVCPath('/completa')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_SOLICITUDES_CREAR)]
    [MVCRequiresPermiso(PERMISO_ADJUNTOS_CREAR)]
    [MVCSwagSummary('Solicitudes', 'El envio del movil: solicitud, medidas y ' +
      'adjuntos en una transaccion', 'registrarSolicitudCompleta')]
    [MVCSwagResponses(201, 'Registrada. Location apunta a la solicitud')]
    [MVCSwagResponses(422, 'Algun dato del lote no es valido')]
    function RegistrarCompleta([MVCInject] AServicio: ISolicitudService;
      const [MVCFromBody] ADto: TSolicitudCompletaDTO): IMVCResponse;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_EDITAR)]
    [MVCSwagSummary('Solicitudes', 'Actualiza una solicitud',
      'actualizarSolicitud')]
    [MVCSwagResponses(204, 'Actualizada')]
    [MVCSwagResponses(409, 'Otra persona la modifico, o ya esta cotizada')]
    function Actualizar([MVCInject] AServicio: ISolicitudService;
      const AId: Integer;
      const [MVCFromBody] ADto: TSolicitudEdicionDTO): IMVCResponse;

    [MVCPath('/($AId)/recepcion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_EDITAR)]
    [MVCSwagSummary('Solicitudes', 'Sella la fecha de recepcion. Se hace una ' +
      'sola vez', 'marcarSolicitudRecibida')]
    [MVCSwagResponses(204, 'Recibida')]
    function Recibir([MVCInject] AServicio: ISolicitudService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/estado')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_EDITAR)]
    [MVCSwagSummary('Solicitudes', 'Cambia el estado de la solicitud',
      'cambiarEstadoSolicitud')]
    [MVCSwagResponses(204, 'Estado cambiado')]
    [MVCSwagResponses(409, 'La transicion no es valida desde el estado actual')]
    function CambiarEstado([MVCInject] AServicio: ISolicitudService;
      const AId: Integer;
      const [MVCFromBody] ADto: TCambioEstadoDTO): IMVCResponse;

    [MVCPath('/($AId)/piezas')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Solicitudes', 'Las piezas activas de la solicitud, ' +
      'con sus catalogos y cuantas medidas, fotos y croquis tiene cada una',
      'listarPiezas')]
    [MVCSwagResponses(200, 'Las piezas, en orden')]
    function Piezas([MVCInject] AServicio: ISolicitudService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/medidas')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Solicitudes', 'Las medidas de la solicitud',
      'listarMedidas')]
    [MVCSwagResponses(200, 'Las medidas, en el orden en que se capturaron')]
    function Medidas([MVCInject] AServicio: ISolicitudService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/medidas')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_EDITAR)]
    [MVCSwagSummary('Solicitudes', 'Agrega una medida', 'agregarMedida')]
    [MVCSwagResponses(201, 'Creada')]
    function AgregarMedida([MVCInject] AServicio: ISolicitudService;
      const AId: Integer;
      const [MVCFromBody] ADto: TMedidaNuevaDTO): IMVCResponse;

    [MVCPath('/($AId)/medidas/($AMedidaId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_EDITAR)]
    [MVCSwagSummary('Solicitudes', 'Actualiza una medida',
      'actualizarMedida')]
    [MVCSwagResponses(204, 'Actualizada')]
    function ActualizarMedida([MVCInject] AServicio: ISolicitudService;
      const AId: Integer; const AMedidaId: Integer;
      const [MVCFromBody] ADto: TMedidaNuevaDTO): IMVCResponse;

    [MVCPath('/($AId)/medidas/($AMedidaId)')]
    [MVCHTTPMethods([httpDELETE])]
    [MVCRequiresPermiso(PERMISO_EDITAR)]
    [MVCSwagSummary('Solicitudes', 'Elimina una medida. Es un dato de ' +
      'captura, no un registro historico', 'eliminarMedida')]
    [MVCSwagResponses(204, 'Eliminada')]
    function EliminarMedida([MVCInject] AServicio: ISolicitudService;
      const AId: Integer; const AMedidaId: Integer): IMVCResponse;

    [MVCPath('/($AId)/adjuntos')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_ADJUNTOS_VER)]
    [MVCSwagSummary('Solicitudes', 'Metadatos de los adjuntos. Sin el ' +
      'contenido', 'listarAdjuntos')]
    [MVCSwagResponses(200, 'Los adjuntos activos')]
    function Adjuntos([MVCInject] AServicio: ISolicitudService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/adjuntos/($AAdjuntoId)')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_ADJUNTOS_VER)]
    [MVCSwagSummary('Solicitudes', 'Un adjunto con su contenido en base64',
      'obtenerAdjunto')]
    [MVCSwagResponses(200, 'El adjunto', TAdjuntoContenidoDTO)]
    [MVCSwagResponses(404, 'No existe ese adjunto en la solicitud')]
    function ObtenerAdjunto([MVCInject] AServicio: ISolicitudService;
      const AId: Integer; const AAdjuntoId: Integer): IMVCResponse;

    [MVCPath('/($AId)/adjuntos')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_ADJUNTOS_CREAR)]
    [MVCSwagSummary('Solicitudes', 'Agrega un adjunto. Contenido en base64, ' +
      'maximo 3 MB', 'agregarAdjunto')]
    [MVCSwagResponses(201, 'Creado')]
    [MVCSwagResponses(422, 'Tipo invalido, adjunto vacio o mayor de 3 MB')]
    function AgregarAdjunto([MVCInject] AServicio: ISolicitudService;
      const AId: Integer;
      const [MVCFromBody] ADto: TAdjuntoNuevoDTO): IMVCResponse;

    [MVCPath('/($AId)/adjuntos/($AAdjuntoId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_ADJUNTOS_CREAR)]
    [MVCSwagSummary('Solicitudes', 'Inactiva un adjunto. No se borra: es la ' +
      'evidencia de lo que se midio', 'inactivarAdjunto')]
    [MVCSwagResponses(204, 'Inactivado')]
    function InactivarAdjunto([MVCInject] AServicio: ISolicitudService;
      const AId: Integer; const AAdjuntoId: Integer): IMVCResponse;
  end;

implementation

uses
  System.Math,
  System.SysUtils,
  System.Generics.Collections;

function TSolicitudesController.Listar(AServicio: ISolicitudService;
  const ABusqueda, AEstado, ADesde, AHasta: string;
  const APagina, APorPagina: Integer): TSolicitudesPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lHasta: TDateTime;
  lDatos: TObjectList<TSolicitudDTO>;
begin
  lPagina := Max(APagina, 1);
  lPorPagina := EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO);

  lHasta := HastaFinDelDia(ComoFecha(AHasta));

  lDatos := AServicio.Buscar(ABusqueda, AEstado, ComoFecha(ADesde), lHasta,
    Roles, UsuarioId, lPagina, lPorPagina, lTotal);

  Result := TSolicitudesPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
end;

function TSolicitudesController.Obtener(AServicio: ISolicitudService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Obtener(AId, UsuarioId, Roles));
end;

function TSolicitudesController.Crear(AServicio: ISolicitudService;
  const ADto: TSolicitudNuevaDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/solicitudes/' +
    AServicio.Crear(ADto, UsuarioId, Roles).ToString);
end;

function TSolicitudesController.RegistrarCompleta(AServicio: ISolicitudService;
  const ADto: TSolicitudCompletaDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/solicitudes/' +
    AServicio.RegistrarCompleta(ADto, UsuarioId, Roles).ToString);
end;

function TSolicitudesController.Actualizar(AServicio: ISolicitudService;
  const AId: Integer; const ADto: TSolicitudEdicionDTO): IMVCResponse;
begin
  AServicio.Actualizar(AId, ADto, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TSolicitudesController.Recibir(AServicio: ISolicitudService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.MarcarRecibida(AId, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TSolicitudesController.CambiarEstado(AServicio: ISolicitudService;
  const AId: Integer; const ADto: TCambioEstadoDTO): IMVCResponse;
begin
  AServicio.CambiarEstado(AId, ADto, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TSolicitudesController.Piezas(AServicio: ISolicitudService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Piezas(AId, UsuarioId, Roles));
end;

function TSolicitudesController.Medidas(AServicio: ISolicitudService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Medidas(AId, UsuarioId, Roles));
end;

function TSolicitudesController.AgregarMedida(AServicio: ISolicitudService;
  const AId: Integer; const ADto: TMedidaNuevaDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/solicitudes/' + AId.ToString + '/medidas/' +
    AServicio.AgregarMedida(AId, ADto, UsuarioId, Roles).ToString);
end;

function TSolicitudesController.ActualizarMedida(AServicio: ISolicitudService;
  const AId, AMedidaId: Integer; const ADto: TMedidaNuevaDTO): IMVCResponse;
begin
  AServicio.ActualizarMedida(AId, AMedidaId, ADto, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TSolicitudesController.EliminarMedida(AServicio: ISolicitudService;
  const AId, AMedidaId: Integer): IMVCResponse;
begin
  AServicio.EliminarMedida(AId, AMedidaId, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TSolicitudesController.Adjuntos(AServicio: ISolicitudService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Adjuntos(AId, UsuarioId, Roles));
end;

function TSolicitudesController.ObtenerAdjunto(AServicio: ISolicitudService;
  const AId, AAdjuntoId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.ObtenerAdjunto(AId, AAdjuntoId, UsuarioId, Roles));
end;

function TSolicitudesController.AgregarAdjunto(AServicio: ISolicitudService;
  const AId: Integer; const ADto: TAdjuntoNuevoDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/solicitudes/' + AId.ToString + '/adjuntos/' +
    AServicio.AgregarAdjunto(AId, ADto, UsuarioId, Roles).ToString);
end;

function TSolicitudesController.InactivarAdjunto(AServicio: ISolicitudService;
  const AId, AAdjuntoId: Integer): IMVCResponse;
begin
  AServicio.InactivarAdjunto(AId, AAdjuntoId, UsuarioId, Roles);
  Result := NoContentResponse;
end;

function TSolicitudesController.Cola(AServicio: ISolicitudService;
  const ABusqueda: string; const APagina, APorPagina: Integer)
  : TColaPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDatos: TObjectList<TSolicitudPorCotizarDTO>;
begin
  lPagina := Max(APagina, 1);
  lPorPagina := EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO);
  lDatos := AServicio.Cola(ABusqueda, lPagina, lPorPagina, lTotal);
  Result := TColaPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
end;

function TSolicitudesController.EnTrabajo(AServicio: ISolicitudService;
  const ABusqueda: string; const APagina, APorPagina: Integer)
  : TEnTrabajoPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDatos: TObjectList<TSolicitudEnTrabajoDTO>;
begin
  lPagina := Max(APagina, 1);
  lPorPagina := EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO);
  lDatos := AServicio.EnTrabajo(UsuarioId, ABusqueda, lPagina, lPorPagina,
    lTotal);
  Result := TEnTrabajoPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
end;

function TSolicitudesController.Seguimiento(AServicio: ISolicitudService;
  const ABusqueda, APeriodo: string; const APagina, APorPagina: Integer)
  : TSeguimientoPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDesde, lHasta: TDateTime;
  lDatos: TObjectList<TSolicitudAsesorDTO>;
begin
  lPagina := Max(APagina, 1);
  lPorPagina := EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO);

  lDatos := AServicio.Seguimiento(UsuarioId, ABusqueda,
    not SameText(APeriodo, PERIODO_TODO), lPagina, lPorPagina, lDesde,
    lHasta, lTotal);

  Result := TSeguimientoPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
  if lDesde > 0 then
  begin
    Result.Desde := lDesde;
    Result.Hasta := lHasta;
  end;
end;

end.
