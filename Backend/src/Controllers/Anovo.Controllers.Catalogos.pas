unit Anovo.Controllers.Catalogos;

// Catalogos bajo /api/catalogos: materiales, mano de obra,
// maquinas, tipos de trabajo, precios y la lista Todos.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Importacion,
  Anovo.Services.Intf.Catalogos,
  Anovo.Services.Intf.Importacion,
  Anovo.Permisos;

const

  POR_PAGINA_POR_DEFECTO = 50;
  POR_PAGINA_MAXIMO = 200;

type

  [MVCPath('/api/catalogos')]
  [MVCRequiresPermiso(PERMISO_CATALOGOS_VER)]
  TCatalogosController = class(TMVCController)
  public

    [MVCPath('')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Lista y busca materiales, mano de obra y ' +
      'maquinas juntos, con su precio vigente, paginado', 'listarTodos')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en codigo, nombre o ' +
      'descripcion', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'incluir_inactivos',
      'Incluir los items inactivos', ptBoolean, False)]
    [MVCSwagResponses(200, 'Pagina de items de los tres catalogos',
      TCatalogoItemsPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function ListarTodos([MVCInject] AServicio: ICatalogoService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer;
      const [MVCFromQueryString('incluir_inactivos', False)] AIncluirInactivos
      : Boolean): TCatalogoItemsPaginaDTO;

    [MVCPath('/materiales')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Lista y busca materiales con su precio ' +
      'vigente, paginado', 'listarMateriales')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en codigo, nombre o ' +
      'descripcion', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'incluir_inactivos',
      'Incluir los materiales inactivos', ptBoolean, False)]
    [MVCSwagResponses(200, 'Pagina de materiales', TMaterialesPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function ListarMateriales([MVCInject] AServicio: ICatalogoService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer;
      const [MVCFromQueryString('incluir_inactivos', False)] AIncluirInactivos
      : Boolean): TMaterialesPaginaDTO;

    [MVCPath('/materiales/($AId)')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Obtiene un material por su numero',
      'obtenerMaterial')]
    [MVCSwagResponses(200, 'El material', TMaterialDTO)]
    [MVCSwagResponses(404, 'No existe material con ese numero')]
    function ObtenerMaterial([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/materiales')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Registra un material', 'crearMaterial')]
    [MVCSwagResponses(201, 'Creado. Location apunta al material')]
    [MVCSwagResponses(422, 'Ya existe un material con ese nombre')]
    function CrearMaterial([MVCInject] AServicio: ICatalogoService;
      const [MVCFromBody] ADto: TMaterialNuevoDTO): IMVCResponse;

    [MVCPath('/materiales/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Actualiza un material',
      'actualizarMaterial')]
    [MVCSwagResponses(204, 'Actualizado')]
    [MVCSwagResponses(404, 'No existe material con ese numero')]
    [MVCSwagResponses(422, 'Ya existe otro material con ese nombre')]
    function ActualizarMaterial([MVCInject] AServicio: ICatalogoService;
      const AId: Integer;
      const [MVCFromBody] ADto: TMaterialEdicionDTO): IMVCResponse;

    [MVCPath('/materiales/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Inactiva un material. No se borra: las ' +
      'cotizaciones anteriores lo siguen nombrando', 'inactivarMaterial')]
    [MVCSwagResponses(204, 'Inactivado')]
    function InactivarMaterial([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/materiales/($AId)/precios')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Historial de precios del material',
      'historialPrecioMaterial')]
    [MVCSwagResponses(200, 'Historial, el mas reciente primero')]
    function HistorialPrecioMaterial([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/materiales/($AId)/precios')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Cambia el precio vigente del material. ' +
      'El anterior queda en el historial', 'cambiarPrecioMaterial')]
    [MVCSwagResponses(204, 'Precio cambiado')]
    [MVCSwagResponses(422, 'Falta el precio unitario')]
    function CambiarPrecioMaterial([MVCInject] AServicio: ICatalogoService;
      const AId: Integer;
      const [MVCFromBody] ADto: TPrecioNuevoDTO): IMVCResponse;

    [MVCPath('/mano-obra')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Lista y busca mano de obra con su costo ' +
      'vigente, paginado', 'listarManoObra')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en codigo o descripcion',
      ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'incluir_inactivos', 'Incluir los inactivos',
      ptBoolean, False)]
    [MVCSwagParam(plQuery, 'categoria_id', 'Filtra por categoria',
      ptInteger, False)]
    [MVCSwagResponses(200, 'Pagina de mano de obra', TManoObraPaginaDTO)]
    function ListarManoObra([MVCInject] AServicio: ICatalogoService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer;
      const [MVCFromQueryString('incluir_inactivos', False)] AIncluirInactivos
      : Boolean;
      const [MVCFromQueryString('categoria_id', 0)] ACategoriaId: Integer)
      : TManoObraPaginaDTO;

    [MVCPath('/mano-obra/categorias')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Categorias de mano de obra. Catalogo fijo',
      'listarCategorias')]
    [MVCSwagResponses(200, 'Las categorias')]
    function Categorias([MVCInject] AServicio: ICatalogoService): IMVCResponse;

    [MVCPath('/mano-obra/($AId)')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Obtiene una mano de obra por su numero',
      'obtenerManoObra')]
    [MVCSwagResponses(200, 'La mano de obra', TManoObraDTO)]
    [MVCSwagResponses(404, 'No existe con ese numero')]
    function ObtenerManoObra([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/mano-obra')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Registra una mano de obra',
      'crearManoObra')]
    [MVCSwagResponses(201, 'Creada. Location apunta al registro')]
    [MVCSwagResponses(422, 'Ya existe una con esa descripcion')]
    function CrearManoObra([MVCInject] AServicio: ICatalogoService;
      const [MVCFromBody] ADto: TManoObraNuevaDTO): IMVCResponse;

    [MVCPath('/mano-obra/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Actualiza una mano de obra',
      'actualizarManoObra')]
    [MVCSwagResponses(204, 'Actualizada')]
    function ActualizarManoObra([MVCInject] AServicio: ICatalogoService;
      const AId: Integer;
      const [MVCFromBody] ADto: TManoObraEdicionDTO): IMVCResponse;

    [MVCPath('/mano-obra/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Inactiva una mano de obra',
      'inactivarManoObra')]
    [MVCSwagResponses(204, 'Inactivada')]
    function InactivarManoObra([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/mano-obra/($AId)/precios')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Historial de costos de la mano de obra',
      'historialPrecioManoObra')]
    [MVCSwagResponses(200, 'Historial, el mas reciente primero')]
    function HistorialPrecioManoObra([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/mano-obra/($AId)/precios')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Cambia el costo vigente de la mano de obra',
      'cambiarPrecioManoObra')]
    [MVCSwagResponses(204, 'Costo cambiado')]
    [MVCSwagResponses(422, 'Falta el costo unitario')]
    function CambiarPrecioManoObra([MVCInject] AServicio: ICatalogoService;
      const AId: Integer;
      const [MVCFromBody] ADto: TPrecioNuevoDTO): IMVCResponse;

    [MVCPath('/maquinas')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Lista y busca maquinas con su costo por ' +
      'hora vigente, paginado', 'listarMaquinas')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en codigo, nombre o ' +
      'descripcion', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'incluir_inactivos', 'Incluir las inactivas',
      ptBoolean, False)]
    [MVCSwagResponses(200, 'Pagina de maquinas', TMaquinasPaginaDTO)]
    function ListarMaquinas([MVCInject] AServicio: ICatalogoService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer;
      const [MVCFromQueryString('incluir_inactivos', False)] AIncluirInactivos
      : Boolean): TMaquinasPaginaDTO;

    [MVCPath('/maquinas/($AId)')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Obtiene una maquina por su numero',
      'obtenerMaquina')]
    [MVCSwagResponses(200, 'La maquina', TMaquinaDTO)]
    [MVCSwagResponses(404, 'No existe maquina con ese numero')]
    function ObtenerMaquina([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/maquinas')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Registra una maquina', 'crearMaquina')]
    [MVCSwagResponses(201, 'Creada. Location apunta a la maquina')]
    function CrearMaquina([MVCInject] AServicio: ICatalogoService;
      const [MVCFromBody] ADto: TMaquinaNuevaDTO): IMVCResponse;

    [MVCPath('/maquinas/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Actualiza una maquina',
      'actualizarMaquina')]
    [MVCSwagResponses(204, 'Actualizada')]
    function ActualizarMaquina([MVCInject] AServicio: ICatalogoService;
      const AId: Integer;
      const [MVCFromBody] ADto: TMaquinaEdicionDTO): IMVCResponse;

    [MVCPath('/maquinas/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Inactiva una maquina', 'inactivarMaquina')]
    [MVCSwagResponses(204, 'Inactivada')]
    function InactivarMaquina([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/maquinas/($AId)/precios')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Historial de costos por hora de la maquina',
      'historialCostoMaquina')]
    [MVCSwagResponses(200, 'Historial, el mas reciente primero')]
    function HistorialCostoMaquina([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/maquinas/($AId)/precios')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Cambia el costo por hora vigente',
      'cambiarCostoMaquina')]
    [MVCSwagResponses(204, 'Costo cambiado')]
    [MVCSwagResponses(422, 'Falta el costo por hora')]
    function CambiarCostoMaquina([MVCInject] AServicio: ICatalogoService;
      const AId: Integer;
      const [MVCFromBody] ADto: TPrecioNuevoDTO): IMVCResponse;

    [MVCPath('/materiales/importacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Carga masiva de materiales nuevos. Con ' +
      'revisar=true solo revisa las filas; sin errores, los registra todos ' +
      'con su precio en una sola transaccion', 'importarMateriales')]
    [MVCSwagParam(plQuery, 'revisar', 'true: solo revisa, no registra nada',
      ptBoolean, False)]
    [MVCSwagResponses(200, 'Filas revisadas, creadas y errores por fila',
      TImportacionResultadoDTO)]
    [MVCSwagResponses(422, 'Carga vacia o con mas filas que el maximo')]
    function ImportarMateriales([MVCInject] AServicio: IImportacionService;
      const [MVCFromQueryString('revisar', False)] ARevisar: Boolean;
      const [MVCFromBody] ADto: TImportacionDTO): IMVCResponse;

    [MVCPath('/mano-obra/importacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Carga masiva de items de mano de obra nuevos. Con ' +
      'revisar=true solo revisa las filas; sin errores, los registra todos ' +
      'con su precio en una sola transaccion', 'importarManoObra')]
    [MVCSwagParam(plQuery, 'revisar', 'true: solo revisa, no registra nada',
      ptBoolean, False)]
    [MVCSwagResponses(200, 'Filas revisadas, creadas y errores por fila',
      TImportacionResultadoDTO)]
    [MVCSwagResponses(422, 'Carga vacia o con mas filas que el maximo')]
    function ImportarManoObra([MVCInject] AServicio: IImportacionService;
      const [MVCFromQueryString('revisar', False)] ARevisar: Boolean;
      const [MVCFromBody] ADto: TImportacionDTO): IMVCResponse;

    [MVCPath('/maquinas/importacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Carga masiva de maquinas nuevos. Con ' +
      'revisar=true solo revisa las filas; sin errores, los registra todos ' +
      'con su precio en una sola transaccion', 'importarMaquinas')]
    [MVCSwagParam(plQuery, 'revisar', 'true: solo revisa, no registra nada',
      ptBoolean, False)]
    [MVCSwagResponses(200, 'Filas revisadas, creadas y errores por fila',
      TImportacionResultadoDTO)]
    [MVCSwagResponses(422, 'Carga vacia o con mas filas que el maximo')]
    function ImportarMaquinas([MVCInject] AServicio: IImportacionService;
      const [MVCFromQueryString('revisar', False)] ARevisar: Boolean;
      const [MVCFromBody] ADto: TImportacionDTO): IMVCResponse;

    [MVCPath('/tipos-trabajo')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Tipos de trabajo. Lista corta, sin paginar',
      'listarTiposTrabajo')]
    [MVCSwagParam(plQuery, 'incluir_inactivos', 'Incluir los inactivos',
      ptBoolean, False)]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en el nombre', ptString, False)]
    [MVCSwagResponses(200, 'Los tipos de trabajo')]
    function ListarTiposTrabajo([MVCInject] AServicio: ICatalogoService;
      const [MVCFromQueryString('incluir_inactivos', False)] AIncluirInactivos
      : Boolean; const [MVCFromQueryString('q', '')] ABusqueda: string)
      : IMVCResponse;

    [MVCPath('/tipos-trabajo')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Registra un tipo de trabajo',
      'crearTipoTrabajo')]
    [MVCSwagResponses(201, 'Creado')]
    [MVCSwagResponses(422, 'Ya existe uno con ese nombre')]
    function CrearTipoTrabajo([MVCInject] AServicio: ICatalogoService;
      const [MVCFromBody] ADto: TTipoTrabajoNuevoDTO): IMVCResponse;

    [MVCPath('/tipos-trabajo/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Actualiza un tipo de trabajo',
      'actualizarTipoTrabajo')]
    [MVCSwagResponses(204, 'Actualizado')]
    function ActualizarTipoTrabajo([MVCInject] AServicio: ICatalogoService;
      const AId: Integer;
      const [MVCFromBody] ADto: TTipoTrabajoNuevoDTO): IMVCResponse;

    [MVCPath('/tipos-trabajo/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Inactiva un tipo de trabajo',
      'inactivarTipoTrabajo')]
    [MVCSwagResponses(204, 'Inactivado')]
    function InactivarTipoTrabajo([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/tipos-material')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Tipos de material. Lista corta, sin paginar',
      'listarTiposMaterial')]
    [MVCSwagParam(plQuery, 'incluir_inactivos', 'Incluir los inactivos',
      ptBoolean, False)]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en el nombre', ptString, False)]
    [MVCSwagResponses(200, 'Tipos de material')]
    function ListarTiposMaterial([MVCInject] AServicio: ICatalogoService;
      const [MVCFromQueryString('incluir_inactivos', False)] AIncluirInactivos
      : Boolean; const [MVCFromQueryString('q', '')] ABusqueda: string)
      : IMVCResponse;

    [MVCPath('/tipos-material')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Registra un tipo de material', 'crearTipoMaterial')]
    [MVCSwagResponses(201, 'Creado')]
    [MVCSwagResponses(422, 'Sin nombre o ya existe un con ese nombre')]
    function CrearTipoMaterial([MVCInject] AServicio: ICatalogoService;
      const [MVCFromBody] ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;

    [MVCPath('/tipos-material/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Actualiza un tipo de material', 'actualizarTipoMaterial')]
    [MVCSwagResponses(204, 'Actualizado')]
    [MVCSwagResponses(404, 'No existe')]
    function ActualizarTipoMaterial([MVCInject] AServicio: ICatalogoService;
      const AId: Integer;
      const [MVCFromBody] ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;

    [MVCPath('/tipos-material/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Inactiva un tipo de material', 'inactivarTipoMaterial')]
    [MVCSwagResponses(204, 'Inactivado')]
    [MVCSwagResponses(404, 'No existe')]
    function InactivarTipoMaterial([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/acabados')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Acabados. Lista corta, sin paginar',
      'listarAcabados')]
    [MVCSwagParam(plQuery, 'incluir_inactivos', 'Incluir los inactivos',
      ptBoolean, False)]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en el nombre', ptString, False)]
    [MVCSwagResponses(200, 'Acabados')]
    function ListarAcabados([MVCInject] AServicio: ICatalogoService;
      const [MVCFromQueryString('incluir_inactivos', False)] AIncluirInactivos
      : Boolean; const [MVCFromQueryString('q', '')] ABusqueda: string)
      : IMVCResponse;

    [MVCPath('/acabados')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Registra un acabado', 'crearAcabado')]
    [MVCSwagResponses(201, 'Creado')]
    [MVCSwagResponses(422, 'Sin nombre o ya existe un con ese nombre')]
    function CrearAcabado([MVCInject] AServicio: ICatalogoService;
      const [MVCFromBody] ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;

    [MVCPath('/acabados/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Actualiza un acabado', 'actualizarAcabado')]
    [MVCSwagResponses(204, 'Actualizado')]
    [MVCSwagResponses(404, 'No existe')]
    function ActualizarAcabado([MVCInject] AServicio: ICatalogoService;
      const AId: Integer;
      const [MVCFromBody] ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;

    [MVCPath('/acabados/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Inactiva un acabado', 'inactivarAcabado')]
    [MVCSwagResponses(204, 'Inactivado')]
    [MVCSwagResponses(404, 'No existe')]
    function InactivarAcabado([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/formas-pago')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Formas de pago. Lista corta, sin paginar',
      'listarFormasPago')]
    [MVCSwagParam(plQuery, 'incluir_inactivos', 'Incluir los inactivos',
      ptBoolean, False)]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en el nombre', ptString, False)]
    [MVCSwagResponses(200, 'Formas de pago')]
    function ListarFormasPago([MVCInject] AServicio: ICatalogoService;
      const [MVCFromQueryString('incluir_inactivos', False)] AIncluirInactivos
      : Boolean; const [MVCFromQueryString('q', '')] ABusqueda: string)
      : IMVCResponse;

    [MVCPath('/formas-pago')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Registra una forma de pago', 'crearFormaPago')]
    [MVCSwagResponses(201, 'Creado')]
    [MVCSwagResponses(422, 'Sin nombre o ya existe una con ese nombre')]
    function CrearFormaPago([MVCInject] AServicio: ICatalogoService;
      const [MVCFromBody] ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;

    [MVCPath('/formas-pago/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Actualiza una forma de pago', 'actualizarFormaPago')]
    [MVCSwagResponses(204, 'Actualizado')]
    [MVCSwagResponses(404, 'No existe')]
    function ActualizarFormaPago([MVCInject] AServicio: ICatalogoService;
      const AId: Integer;
      const [MVCFromBody] ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;

    [MVCPath('/formas-pago/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Inactiva una forma de pago', 'inactivarFormaPago')]
    [MVCSwagResponses(204, 'Inactivado')]
    [MVCSwagResponses(404, 'No existe')]
    function InactivarFormaPago([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/unidades-medida')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Catalogos', 'Unidades de medida. Lista corta, sin paginar',
      'listarUnidadesMedida')]
    [MVCSwagParam(plQuery, 'incluir_inactivos', 'Incluir las inactivas',
      ptBoolean, False)]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en nombre o abreviatura',
      ptString, False)]
    [MVCSwagResponses(200, 'Las unidades, por magnitud y nombre')]
    function ListarUnidadesMedida([MVCInject] AServicio: ICatalogoService;
      const [MVCFromQueryString('incluir_inactivos', False)] AIncluirInactivas
      : Boolean; const [MVCFromQueryString('q', '')] ABusqueda: string)
      : IMVCResponse;

    [MVCPath('/unidades-medida')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Registra una unidad de medida',
      'crearUnidadMedida')]
    [MVCSwagResponses(201, 'Creada')]
    [MVCSwagResponses(422, 'Nombre repetido o magnitud invalida')]
    function CrearUnidadMedida([MVCInject] AServicio: ICatalogoService;
      const [MVCFromBody] ADto: TUnidadMedidaNuevaDTO): IMVCResponse;

    [MVCPath('/unidades-medida/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Actualiza una unidad de medida',
      'actualizarUnidadMedida')]
    [MVCSwagResponses(204, 'Actualizada')]
    [MVCSwagResponses(422, 'Nombre repetido o magnitud invalida')]
    function ActualizarUnidadMedida([MVCInject] AServicio: ICatalogoService;
      const AId: Integer;
      const [MVCFromBody] ADto: TUnidadMedidaNuevaDTO): IMVCResponse;

    [MVCPath('/unidades-medida/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CATALOGOS_EDITAR)]
    [MVCSwagSummary('Catalogos', 'Inactiva una unidad de medida',
      'inactivarUnidadMedida')]
    [MVCSwagResponses(204, 'Inactivada')]
    function InactivarUnidadMedida([MVCInject] AServicio: ICatalogoService;
      const AId: Integer): IMVCResponse;
  end;

implementation

uses
  System.Math,
  System.SysUtils,
  System.Generics.Collections;

function TCatalogosController.ListarTodos(AServicio: ICatalogoService;
  const ABusqueda: string; const APagina, APorPagina: Integer;
  const AIncluirInactivos: Boolean): TCatalogoItemsPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDatos: TObjectList<TCatalogoItemDTO>;
begin
  lPagina := Max(APagina, 1);
  lPorPagina := EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO);

  lDatos := AServicio.BuscarTodos(ABusqueda, lPagina, lPorPagina,
    AIncluirInactivos, lTotal);
  Result := TCatalogoItemsPaginaDTO.Create(lDatos, lTotal, lPagina,
    lPorPagina);
end;

function TCatalogosController.ListarMateriales(AServicio: ICatalogoService;
  const ABusqueda: string; const APagina, APorPagina: Integer;
  const AIncluirInactivos: Boolean): TMaterialesPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDatos: TObjectList<TMaterialDTO>;
begin
  lPagina := Max(APagina, 1);
  lPorPagina := EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO);

  lDatos := AServicio.BuscarMateriales(ABusqueda, lPagina, lPorPagina,
    AIncluirInactivos, lTotal);

  Result := TMaterialesPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
end;

function TCatalogosController.ObtenerMaterial(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.ObtenerMaterial(AId));
end;

function TCatalogosController.CrearMaterial(AServicio: ICatalogoService;
  const ADto: TMaterialNuevoDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/catalogos/materiales/' +
    AServicio.CrearMaterial(ADto).ToString);
end;

function TCatalogosController.ActualizarMaterial(AServicio: ICatalogoService;
  const AId: Integer; const ADto: TMaterialEdicionDTO): IMVCResponse;
begin
  AServicio.ActualizarMaterial(AId, ADto);
  Result := NoContentResponse;
end;

function TCatalogosController.InactivarMaterial(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.InactivarMaterial(AId);
  Result := NoContentResponse;
end;

function TCatalogosController.HistorialPrecioMaterial
  (AServicio: ICatalogoService; const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.HistorialPrecioMaterial(AId));
end;

function TCatalogosController.CambiarPrecioMaterial(AServicio: ICatalogoService;
  const AId: Integer; const ADto: TPrecioNuevoDTO): IMVCResponse;
begin
  AServicio.CambiarPrecioMaterial(AId, ADto);
  Result := NoContentResponse;
end;

function TCatalogosController.ListarManoObra(AServicio: ICatalogoService;
  const ABusqueda: string; const APagina, APorPagina: Integer;
  const AIncluirInactivos: Boolean; const ACategoriaId: Integer)
  : TManoObraPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDatos: TObjectList<TManoObraDTO>;
begin
  lPagina := Max(APagina, 1);
  lPorPagina := EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO);

  lDatos := AServicio.BuscarManoObra(ABusqueda, lPagina, lPorPagina,
    AIncluirInactivos, ACategoriaId, lTotal);

  Result := TManoObraPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
end;

function TCatalogosController.Categorias(AServicio: ICatalogoService)
  : IMVCResponse;
begin
  Result := OKResponse(AServicio.Categorias);
end;

function TCatalogosController.ObtenerManoObra(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.ObtenerManoObra(AId));
end;

function TCatalogosController.CrearManoObra(AServicio: ICatalogoService;
  const ADto: TManoObraNuevaDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/catalogos/mano-obra/' +
    AServicio.CrearManoObra(ADto).ToString);
end;

function TCatalogosController.ActualizarManoObra(AServicio: ICatalogoService;
  const AId: Integer; const ADto: TManoObraEdicionDTO): IMVCResponse;
begin
  AServicio.ActualizarManoObra(AId, ADto);
  Result := NoContentResponse;
end;

function TCatalogosController.InactivarManoObra(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.InactivarManoObra(AId);
  Result := NoContentResponse;
end;

function TCatalogosController.HistorialPrecioManoObra
  (AServicio: ICatalogoService; const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.HistorialPrecioManoObra(AId));
end;

function TCatalogosController.CambiarPrecioManoObra(AServicio: ICatalogoService;
  const AId: Integer; const ADto: TPrecioNuevoDTO): IMVCResponse;
begin
  AServicio.CambiarPrecioManoObra(AId, ADto);
  Result := NoContentResponse;
end;

function TCatalogosController.ListarMaquinas(AServicio: ICatalogoService;
  const ABusqueda: string; const APagina, APorPagina: Integer;
  const AIncluirInactivos: Boolean): TMaquinasPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDatos: TObjectList<TMaquinaDTO>;
begin
  lPagina := Max(APagina, 1);
  lPorPagina := EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO);

  lDatos := AServicio.BuscarMaquinas(ABusqueda, lPagina, lPorPagina,
    AIncluirInactivos, lTotal);

  Result := TMaquinasPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
end;

function TCatalogosController.ObtenerMaquina(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.ObtenerMaquina(AId));
end;

function TCatalogosController.CrearMaquina(AServicio: ICatalogoService;
  const ADto: TMaquinaNuevaDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/catalogos/maquinas/' +
    AServicio.CrearMaquina(ADto).ToString);
end;

function TCatalogosController.ActualizarMaquina(AServicio: ICatalogoService;
  const AId: Integer; const ADto: TMaquinaEdicionDTO): IMVCResponse;
begin
  AServicio.ActualizarMaquina(AId, ADto);
  Result := NoContentResponse;
end;

function TCatalogosController.InactivarMaquina(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.InactivarMaquina(AId);
  Result := NoContentResponse;
end;

function TCatalogosController.HistorialCostoMaquina(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.HistorialCostoMaquina(AId));
end;

function TCatalogosController.CambiarCostoMaquina(AServicio: ICatalogoService;
  const AId: Integer; const ADto: TPrecioNuevoDTO): IMVCResponse;
begin
  AServicio.CambiarCostoMaquina(AId, ADto);
  Result := NoContentResponse;
end;

function TCatalogosController.ListarTiposTrabajo(AServicio: ICatalogoService;
  const AIncluirInactivos: Boolean; const ABusqueda: string): IMVCResponse;
begin
  Result := OKResponse(AServicio.TiposTrabajo(AIncluirInactivos, ABusqueda));
end;

function TCatalogosController.CrearTipoTrabajo(AServicio: ICatalogoService;
  const ADto: TTipoTrabajoNuevoDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/catalogos/tipos-trabajo/' +
    AServicio.CrearTipoTrabajo(ADto).ToString);
end;

function TCatalogosController.ActualizarTipoTrabajo(AServicio: ICatalogoService;
  const AId: Integer; const ADto: TTipoTrabajoNuevoDTO): IMVCResponse;
begin
  AServicio.ActualizarTipoTrabajo(AId, ADto);
  Result := NoContentResponse;
end;

function TCatalogosController.InactivarTipoTrabajo(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.InactivarTipoTrabajo(AId);
  Result := NoContentResponse;
end;

function TCatalogosController.ListarTiposMaterial(AServicio: ICatalogoService;
  const AIncluirInactivos: Boolean; const ABusqueda: string): IMVCResponse;
begin
  Result := OKResponse(AServicio.Simples(csTipoMaterial, AIncluirInactivos,
    ABusqueda));
end;

function TCatalogosController.CrearTipoMaterial(AServicio: ICatalogoService;
  const ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/catalogos/tipos-material/' +
    AServicio.CrearSimple(csTipoMaterial, ADto).ToString);
end;

function TCatalogosController.ActualizarTipoMaterial(AServicio: ICatalogoService;
  const AId: Integer; const ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;
begin
  AServicio.ActualizarSimple(csTipoMaterial, AId, ADto);
  Result := NoContentResponse;
end;

function TCatalogosController.InactivarTipoMaterial(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.InactivarSimple(csTipoMaterial, AId);
  Result := NoContentResponse;
end;

function TCatalogosController.ListarAcabados(AServicio: ICatalogoService;
  const AIncluirInactivos: Boolean; const ABusqueda: string): IMVCResponse;
begin
  Result := OKResponse(AServicio.Simples(csAcabado, AIncluirInactivos,
    ABusqueda));
end;

function TCatalogosController.CrearAcabado(AServicio: ICatalogoService;
  const ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/catalogos/acabados/' +
    AServicio.CrearSimple(csAcabado, ADto).ToString);
end;

function TCatalogosController.ActualizarAcabado(AServicio: ICatalogoService;
  const AId: Integer; const ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;
begin
  AServicio.ActualizarSimple(csAcabado, AId, ADto);
  Result := NoContentResponse;
end;

function TCatalogosController.InactivarAcabado(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.InactivarSimple(csAcabado, AId);
  Result := NoContentResponse;
end;

function TCatalogosController.ListarFormasPago(AServicio: ICatalogoService;
  const AIncluirInactivos: Boolean; const ABusqueda: string): IMVCResponse;
begin
  Result := OKResponse(AServicio.Simples(csFormaPago, AIncluirInactivos,
    ABusqueda));
end;

function TCatalogosController.CrearFormaPago(AServicio: ICatalogoService;
  const ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/catalogos/formas-pago/' +
    AServicio.CrearSimple(csFormaPago, ADto).ToString);
end;

function TCatalogosController.ActualizarFormaPago(AServicio: ICatalogoService;
  const AId: Integer; const ADto: TCatalogoSimpleNuevoDTO): IMVCResponse;
begin
  AServicio.ActualizarSimple(csFormaPago, AId, ADto);
  Result := NoContentResponse;
end;

function TCatalogosController.InactivarFormaPago(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.InactivarSimple(csFormaPago, AId);
  Result := NoContentResponse;
end;

function TCatalogosController.ListarUnidadesMedida(AServicio: ICatalogoService;
  const AIncluirInactivas: Boolean; const ABusqueda: string): IMVCResponse;
begin
  Result := OKResponse(AServicio.UnidadesMedida(AIncluirInactivas, ABusqueda));
end;

function TCatalogosController.CrearUnidadMedida(AServicio: ICatalogoService;
  const ADto: TUnidadMedidaNuevaDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/catalogos/unidades-medida/' +
    AServicio.CrearUnidadMedida(ADto).ToString);
end;

function TCatalogosController.ActualizarUnidadMedida(AServicio: ICatalogoService;
  const AId: Integer; const ADto: TUnidadMedidaNuevaDTO): IMVCResponse;
begin
  AServicio.ActualizarUnidadMedida(AId, ADto);
  Result := NoContentResponse;
end;

function TCatalogosController.InactivarUnidadMedida(AServicio: ICatalogoService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.InactivarUnidadMedida(AId);
  Result := NoContentResponse;
end;

function TCatalogosController.ImportarMateriales(AServicio: IImportacionService;
  const ARevisar: Boolean; const ADto: TImportacionDTO): IMVCResponse;
begin
  Result := OKResponse(AServicio.Importar(ciMateriales, ADto, ARevisar));
end;

function TCatalogosController.ImportarManoObra(AServicio: IImportacionService;
  const ARevisar: Boolean; const ADto: TImportacionDTO): IMVCResponse;
begin
  Result := OKResponse(AServicio.Importar(ciManoObra, ADto, ARevisar));
end;

function TCatalogosController.ImportarMaquinas(AServicio: IImportacionService;
  const ARevisar: Boolean; const ADto: TImportacionDTO): IMVCResponse;
begin
  Result := OKResponse(AServicio.Importar(ciMaquinas, ADto, ARevisar));
end;

end.
