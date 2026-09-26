unit Anovo.Textos;

// Todo el texto que lee una persona, en un solo sitio.
//
// Lo que entra aquí: mensajes de error, avisos, rótulos que el código arma o
// escoge en tiempo de ejecución, y los textos que el backend devuelve al
// cliente. Lo que NO entra: el SQL, las rutas, los nombres de columna, las
// claves JSON y las líneas de log. Nada de eso lo lee un usuario, y sacarlo de
// donde se usa costaría legibilidad sin ganar nada.
//
// Los Caption fijos de los .dfm tampoco entran: ya viven en un solo lugar cada
// uno y el diseñador los muestra al armar la pantalla.
//
// Es resourcestring y no const porque es la forma de Delphi para texto de
// interfaz: va a la tabla de recursos del ejecutable y se puede traducir sin
// tocar el fuente. Cuesta una cosa: un resourcestring no sirve en expresiones
// constantes, así que los arreglos indexados por catálogo se resuelven con
// funciones en vez de declararse const.
//
// ESTE ARCHIVO VA EN UTF-8 CON BOM. Es el único del proyecto que lleva acentos
// escritos como tales; los demás fuentes están en ASCII y escapan la á como
// #225. Aquí eso sobra, y el archivo que alguien va a editar para corregir una
// palabra se lee como español normal.
//
// Los textos con %s o %d se arman con Format. La frase va entera con su
// marcador y no partida en pedazos concatenados: así se corrige la oración
// completa de una vez, y una traducción puede cambiar el orden de las palabras
// sin tocar el código.
//
// Lo compilan los dos proyectos, igual que Anovo.DTOs.Catalogos. La app de
// B4A no compila Pascal, pero este archivo es la referencia de qué debe decir.

interface

resourcestring

  // ==========================================================================
  // VALIDACIONES DEL NEGOCIO
  // Las levanta el backend como EDatoInvalido y llegan al cliente tal cual, así
  // que están redactadas para que las lea quien usa el sistema, no un técnico.
  // ==========================================================================

  // Catálogos
  SFaltaPrecioUnitario = 'Falta el precio unitario.';
  SFaltaCostoUnitario = 'Falta el costo unitario.';
  SFaltaCostoPorHora = 'Falta el costo por hora.';
  SVigenciaAnterior = 'La fecha de vigencia no puede ser anterior a hoy.';
  // Ocho y no una con marcador: en español el artículo cambia con el género
  // y "otro" con el contexto, así que armarlas con Format daría frases mal
  // escritas. Ocho frases correctas valen más que una regla ingeniosa.
  SNombreDuplicadoMaterial = 'Ya existe un material con ese nombre en el ' +
    'catálogo.';
  SNombreDuplicadoOtroMaterial = 'Ya existe otro material con ese nombre en ' +
    'el catálogo.';
  SNombreDuplicadoMaquina = 'Ya existe una máquina con ese nombre.';
  SNombreDuplicadoOtraMaquina = 'Ya existe otra máquina con ese nombre.';
  SNombreDuplicadoManoObra = 'Ya existe una mano de obra con ese nombre.';
  SNombreDuplicadoOtraManoObra = 'Ya existe otra mano de obra con ese nombre.';
  SNombreDuplicadoTipoTrabajo = 'Ya existe un tipo de trabajo con ese ' +
    'nombre.';
  SNombreDuplicadoOtroTipoTrabajo = 'Ya existe otro tipo de trabajo con ese ' +
    'nombre.';

  // Clientes
  SClienteNoExiste = 'El cliente indicado no existe.';
  SRegistroSinContacto = 'El registro debe traer al menos un contacto.';
  SFirmaVacia = 'La imagen de la firma viene vacía.';

  // Solicitudes
  SSolicitudNoExiste = 'La solicitud indicada no existe.';
  SFaltaIdLocalSolicitud = 'Falta el identificador local de la solicitud.';
  SFaltaIdLocalAdjunto = 'Falta el identificador local del adjunto.';
  STipoAdjuntoInvalido = 'El tipo de adjunto debe ser croquis o foto.';

  // Cotizaciones
  SCantidadInvalida = 'La cantidad debe ser mayor que cero.';
  STipoLineaInvalido = 'El tipo de línea no es válido.';
  SLineaSinMaterial = 'Una línea de material necesita el material.';
  SLineaSinMaquina = 'Una línea de máquina necesita la máquina.';
  SAnularSinObservacion = 'Anular exige una observación.';
  SDevolverSinObservacion = 'Devolver exige una observación.';
  SRechazarSinMotivo = 'Rechazar exige indicar el motivo.';

  // Periodos
  SPeriodoInvertido = 'La fecha de inicio es posterior a la del fin.';

  // ==========================================================================
  // ERRORES DE LA API
  // Los arma Anovo.Errors y viajan en el JSON de error.
  // ==========================================================================

  // %s el recurso, %d el número.
  SRecursoNoExiste = 'No existe %s con el número %d.';
  SRecursoNoExisteGenerico = 'El recurso solicitado no existe.';
  SRutaNoExiste = 'La dirección solicitada no existe.';

  // %s la acción que se intentó.
  SSinPermiso = 'Su perfil no tiene permitido %s.';

  // %s el recurso, %d el número.
  SVersionVencida = 'Otra persona modificó %s %d mientras usted lo editaba. ' +
    'Recargue y vuelva a aplicar sus cambios.';
  SVersionVencidaGenerico = 'Otra persona modificó el registro mientras ' +
    'usted lo editaba. Recargue y vuelva a aplicar sus cambios.';

  SErrorInterno = 'Ocurrió un error inesperado. Intente de nuevo; ' +
    'si persiste, avise al administrador.';

  // ==========================================================================
  // COMUNICACIÓN CON EL SERVIDOR
  // Las ve la persona en el escritorio cuando la llamada no llega o no vuelve.
  // ==========================================================================

  SSinConexion = 'No se pudo conectar con el servidor de Anovo. ' +
    'Revise la red o avise al administrador.';
  SSesionVencida = 'Su sesión venció. Vuelva a ingresar.';
  SCertificadoInvalido = 'No se pudo verificar el certificado del servidor ' +
    'de Anovo. Avise al administrador.';
  // El mismo texto para correo inexistente y clave incorrecta. El servidor ya
  // responde igual en los dos casos para no delatar qué correos existen; la
  // pantalla no debe deshacerlo.
  SCredencialesInvalidas = 'El correo o la clave no son correctos.';
  SFaltanCredenciales = 'Escriba su correo y su clave.';
  SUsuarioSinPermisos = 'Su usuario no tiene permisos asignados en el ' +
    'sistema. Avise al administrador.';

  // Una sola frase para los siete sitios que antes la repetían palabra por
  // palabra. El %s es la acción, de las SAccion* de más abajo.
  SErrorInesperado = 'Ocurrió un error inesperado al %s. Intente de nuevo; ' +
    'si persiste, avise al administrador.';

  SAccionGuardar = 'guardar';
  SAccionIngresar = 'ingresar';
  SAccionCargarCatalogo = 'cargar el catálogo';
  SAccionCargarClientes = 'cargar los clientes';
  SAccionCargarFichaCliente = 'cargar la ficha del cliente';
  SAccionCargarBitacora = 'cargar la bitácora';

  // ==========================================================================
  // CATÁLOGOS
  // ==========================================================================

  // Nombres de cada catálogo. En plural para el encabezado de la pestaña y en
  // singular para las frases que hablan de un ítem.
  SCatalogoTodos = 'Todos';
  SCatalogoMateriales = 'Materiales';
  SCatalogoManoObra = 'Mano de obra';
  SCatalogoMaquinas = 'Máquinas';
  SCatalogoTiposTrabajo = 'Tipos de trabajo';

  // Lo que se lee en la columna Tipo de la pestaña Todos, en lugar del código
  // que viaja en el JSON (material, mano_obra, maquina).
  STipoMaterial = 'Material';
  STipoManoObra = 'Mano de obra';
  STipoMaquina = 'Máquina';

  SItemMaterial = 'material';
  SItemManoObra = 'mano de obra';
  SItemMaquina = 'máquina';
  SItemTipoTrabajo = 'tipo de trabajo';

  // %s el nombre en singular.
  STituloNuevoItem = 'Nuevo %s';
  STituloEditarItem = 'Editar %s';

  SNuevoMaterial = '+ Nuevo material';
  SNuevaManoObra = '+ Nueva mano de obra';
  SNuevaMaquina = '+ Nueva máquina';
  SNuevoTipoTrabajo = '+ Nuevo tipo de trabajo';

  SPistaBusquedaItem = 'Código, nombre o descripción';
  SPistaBusquedaNombre = 'Nombre';

  // Validaciones de la ventana de ítem. El %s del código es el prefijo que la
  // ventana propuso (MAT-, MO-, MAQ-).
  SCompleteCodigo = 'Complete el código después de %s';
  SNombreObligatorio = 'El nombre es obligatorio.';
  SEscojaUnidadMedida = 'Escoja la unidad de medida.';
  SEscojaCategoria = 'Escoja una categoría.';
  SFaltaPrecioVenta = 'Falta el precio de venta.';

  // Inactivar no borra: se pregunta antes igual, porque el ítem deja de
  // ofrecerse en las cotizaciones nuevas.
  SConfirmarInactivar = 'Se va a inactivar el registro seleccionado. ' +
    'No se borra: las cotizaciones anteriores lo siguen nombrando.' +
    sLineBreak + sLineBreak + '¿Continuar?';

  // Precios
  SPrecioInicial = 'Precio inicial (opcional, se puede cargar después)';
  SPrecioVigente = 'Precio vigente. Si lo cambia, el anterior queda en el ' +
    'historial';
  // %s la fecha desde la que rige el precio que se está viendo.
  SPrecioVigenteDesde = 'Precio vigente desde el %s. Si lo cambia, el ' +
    'anterior queda en el historial';

  STituloCambiarPrecio = 'Cambiar precio';
  STituloHistorialPrecios = 'Historial de precios';

  SPrecioUnitarioMayorCero = 'El precio unitario debe ser mayor que cero.';
  SCostoUnitarioMayorCero = 'El costo unitario debe ser mayor que cero.';
  SCostoHoraMayorCero = 'El costo por hora debe ser mayor que cero.';

  // Cambios programados
  SRigeDeUnaVez = 'El precio rige de una vez.';
  SProgramadoFechaInvalida = 'Para programar, la fecha tiene que ser ' +
    'posterior a hoy.';
  SProgramadoSinFecha = 'Para programar el precio, escoja una fecha ' +
    'posterior a hoy.';
  // %s la fecha en que empieza a regir.
  SProgramadoAviso = 'El precio de hoy no cambia. El nuevo empieza a regir ' +
    'el %s.';
  // %s la fecha del cambio que ya está en cola.
  SProgramadoExistente = 'Este ítem ya tiene un cambio programado para el %s.';

  // ==========================================================================
  // ESTADOS
  // El texto de las pastillas de la rejilla. En minúscula porque así los
  // dibuja TDBGridExtend y así los guarda la base.
  // ==========================================================================

  SEstadoActivo = 'activo';
  SEstadoInactivo = 'inactivo';
  SEstadoProgramado = 'programado';

  // ==========================================================================
  // MENÚ PRINCIPAL
  // Una entrada por sección de TSeccion. Si se agrega una sección, hay que
  // agregar aquí su rótulo y en Anovo.Forms.Principal su icono.
  // ==========================================================================

  SMenuDashboard = 'Dashboard';
  SMenuSolicitudes = 'Solicitudes';
  SMenuBandeja = 'Bandeja';
  SMenuCotizaciones = 'Cotizaciones';
  SMenuNuevaCotizacion = 'Nueva cotización';
  SMenuDetalle = 'Detalle';
  SMenuClientes = 'Clientes';
  SMenuMateriales = 'Materiales';
  SMenuReportes = 'Reportes';
  SMenuGerencia = 'Vista de gerencia';
  SMenuUsuarios = 'Usuarios';
  SMenuRoles = 'Roles';
  SMenuAuditoria = 'Auditoría';
  SMenuConfiguracion = 'Configuración';

  // ==========================================================================
  // LISTADOS
  // ==========================================================================

  // %s el nombre del catálogo en minúscula. Este sí lleva marcador porque el
  // sustantivo cambia con la pestaña; los otros dos van enteros.
  SCargandoCatalogo = 'Cargando %s...';
  SCargandoClientes = 'Cargando clientes...';
  SCargandoBitacora = 'Cargando la bitácora...';
  SSinClientes = 'No hay clientes que coincidan';
  SSinRegistros = 'No hay registros que coincidan';

  // El · es un punto medio, no un guión. %d el total, %d la página actual y
  // %d el total de páginas.
  SPaginacionRegistros = '%d registros · página %d de %d';
  SPaginacionClientes = '%d clientes · página %d de %d';
  SPaginacionMovimientos = '%d movimientos · página %d de %d';
  SRegistrosTotal = '%d registros';

  STodasLasCategorias = 'Todas las categorías';
  SSinMovimientos = 'No hay movimientos en ese periodo';

  // ==========================================================================
  // GENÉRICOS
  // ==========================================================================

  SOpcionPendiente = 'Esta opción todavía no está disponible.';
  // %s el rótulo del campo, que sale del DisplayLabel.
  SCampoObligatorio = '%s es obligatorio.';
  SSinDato = '-';
  SCerrar = 'Cerrar';

  // ==========================================================================
  // AUDITORÍA
  // Estos se guardan en AUDITORIA.DETALLE, así que cambiar uno afecta lo que
  // se escriba de aquí en adelante; las filas viejas conservan su texto.
  // ==========================================================================

  // %s el nombre del ítem.
  SDetalleCambioPrecioMaterial = 'Cambio de precio del material %s';
  SDetalleCambioCostoManoObra = 'Cambio de costo de la mano de obra %s';
  SDetalleCambioCostoMaquina = 'Cambio de costo por hora de la máquina %s';
  SDetallePrecioProgramadoMaterial = 'Precio programado del material %s';
  SDetallePrecioProgramadoManoObra = 'Precio programado de la mano de obra %s';
  SDetallePrecioProgramadoMaquina = 'Precio programado por hora de la ' +
    'máquina %s';
  SDetalleRelevoAplicado = 'Cambio de precio programado aplicado';

implementation

end.
