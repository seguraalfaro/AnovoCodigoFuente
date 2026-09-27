unit Anovo.Textos;

// Todo el texto que lee una persona, en un solo sitio.
// La comparten el backend y el escritorio.

interface

resourcestring

  SFaltaPrecioUnitario = 'Falta el precio unitario.';
  SFaltaCostoUnitario = 'Falta el costo unitario.';
  SFaltaCostoPorHora = 'Falta el costo por hora.';
  SVigenciaAnterior = 'La fecha de vigencia no puede ser anterior a hoy.';
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

  SClienteNoExiste = 'El cliente indicado no existe.';
  SRegistroSinContacto = 'El registro debe traer al menos un contacto.';
  SFirmaVacia = 'La imagen de la firma viene vacía.';

  SSolicitudNoExiste = 'La solicitud indicada no existe.';
  SFaltaIdLocalSolicitud = 'Falta el identificador local de la solicitud.';
  SFaltaIdLocalAdjunto = 'Falta el identificador local del adjunto.';
  STipoAdjuntoInvalido = 'El tipo de adjunto debe ser croquis o foto.';

  SCantidadInvalida = 'La cantidad debe ser mayor que cero.';
  STipoLineaInvalido = 'El tipo de línea no es válido.';
  SLineaSinMaterial = 'Una línea de material necesita el material.';
  SLineaSinMaquina = 'Una línea de máquina necesita la máquina.';
  SDescartarSinMotivo = 'Descartar una solicitud exige indicar el motivo.';
  SDevolverSinObservacion = 'Devolver exige una observación.';
  SRechazarSinMotivo = 'Rechazar exige indicar el motivo.';

  SPeriodoInvertido = 'La fecha de inicio es posterior a la del fin.';

  SFaltaClaveActual = 'Falta la clave actual.';
  SClaveActualIncorrecta = 'La clave actual no es correcta.';
  SClaveCorta = 'La clave nueva debe tener al menos %d caracteres.';
  SClaveSinLetrasONumeros = 'La clave nueva debe combinar letras y números.';
  SClaveIgualALaActual = 'La clave nueva debe ser distinta de la actual.';

  SRecursoNoExiste = 'No existe %s con el número %d.';
  SRecursoNoExisteGenerico = 'El recurso solicitado no existe.';
  SRutaNoExiste = 'La dirección solicitada no existe.';

  SSinPermiso = 'Su perfil no tiene permitido %s.';

  SVersionVencida = 'Otra persona modificó %s %d mientras usted lo editaba. ' +
    'Recargue y vuelva a aplicar sus cambios.';
  SVersionVencidaGenerico = 'Otra persona modificó el registro mientras ' +
    'usted lo editaba. Recargue y vuelva a aplicar sus cambios.';

  SErrorInterno = 'Ocurrió un error inesperado. Intente de nuevo; ' +
    'si persiste, avise al administrador.';

  SSinConexion = 'No se pudo conectar con el servidor de Anovo. ' +
    'Revise la red o avise al administrador.';
  SSesionVencida = 'Su sesión venció. Vuelva a ingresar.';
  SCertificadoInvalido = 'No se pudo verificar el certificado del servidor ' +
    'de Anovo. Avise al administrador.';
  SCredencialesInvalidas = 'El correo o la clave no son correctos.';
  SFaltanCredenciales = 'Escriba su correo y su clave.';
  SUsuarioSinPermisos = 'Su usuario no tiene permisos asignados en el ' +
    'sistema. Avise al administrador.';

  SErrorInesperado = 'Ocurrió un error inesperado al %s. Intente de nuevo; ' +
    'si persiste, avise al administrador.';

  SAccionGuardar = 'guardar';
  SAccionIngresar = 'ingresar';
  SAccionCargarCatalogo = 'cargar el catálogo';
  SAccionCargarClientes = 'cargar los clientes';
  SAccionCargarFichaCliente = 'cargar la ficha del cliente';
  SAccionCargarBitacora = 'cargar la bitácora';
  SAccionCargarDashboard = 'cargar el dashboard';
  SAccionCargarSolicitudes = 'cargar las solicitudes';
  SAccionCargarCuenta = 'cargar su cuenta';
  SAccionProbarConexion = 'probar la conexión';
  SAccionCambiarClave = 'cambiar la clave';

  SCatalogoTodos = 'Todos';
  SCatalogoMateriales = 'Materiales';
  SCatalogoManoObra = 'Mano de obra';
  SCatalogoMaquinas = 'Máquinas';
  SCatalogoTiposTrabajo = 'Tipos de trabajo';

  STipoMaterial = 'Material';
  STipoManoObra = 'Mano de obra';
  STipoMaquina = 'Máquina';

  SItemMaterial = 'material';
  SItemManoObra = 'mano de obra';
  SItemMaquina = 'máquina';
  SItemTipoTrabajo = 'tipo de trabajo';

  STituloNuevoItem = 'Nuevo %s';
  STituloEditarItem = 'Editar %s';

  SNuevoMaterial = '+ Nuevo material';
  SNuevaManoObra = '+ Nueva mano de obra';
  SNuevaMaquina = '+ Nueva máquina';
  SNuevoTipoTrabajo = '+ Nuevo tipo de trabajo';

  SPistaBusquedaItem = 'Código, nombre o descripción';
  SPistaBusquedaNombre = 'Nombre';

  SCompleteCodigo = 'Complete el código después de %s';
  SNombreObligatorio = 'El nombre es obligatorio.';
  SEscojaUnidadMedida = 'Escoja la unidad de medida.';
  SEscojaCategoria = 'Escoja una categoría.';
  SFaltaPrecioVenta = 'Falta el precio de venta.';

  SConfirmarInactivar = 'Se va a inactivar el registro seleccionado. ' +
    'No se borra: las cotizaciones anteriores lo siguen nombrando.' +
    sLineBreak + sLineBreak + '¿Continuar?';

  SPrecioInicial = 'Precio inicial (opcional, se puede cargar después)';
  SPrecioVigente = 'Precio vigente. Si lo cambia, el anterior queda en el ' +
    'historial';
  SPrecioVigenteDesde = 'Precio vigente desde el %s. Si lo cambia, el ' +
    'anterior queda en el historial';

  STituloCambiarPrecio = 'Cambiar precio';
  STituloHistorialPrecios = 'Historial de precios';

  SPrecioUnitarioMayorCero = 'El precio unitario debe ser mayor que cero.';
  SCostoUnitarioMayorCero = 'El costo unitario debe ser mayor que cero.';
  SCostoHoraMayorCero = 'El costo por hora debe ser mayor que cero.';

  SRigeDeUnaVez = 'El precio rige de una vez.';
  SProgramadoFechaInvalida = 'Para programar, la fecha tiene que ser ' +
    'posterior a hoy.';
  SProgramadoSinFecha = 'Para programar el precio, escoja una fecha ' +
    'posterior a hoy.';
  SProgramadoAviso = 'El precio de hoy no cambia. El nuevo empieza a regir ' +
    'el %s.';
  SProgramadoExistente = 'Este ítem ya tiene un cambio programado para el %s.';

  SEstadoActivo = 'activo';
  SEstadoInactivo = 'inactivo';
  SEstadoProgramado = 'programado';

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

  SEstCapturada = 'Capturada';
  SEstRecibida = 'Recibida';
  SEstEnCotizacion = 'En cotización';
  SEstDescartada = 'Descartada';
  SEstBorrador = 'Borrador';
  SEstPendiente = 'Pendiente de aprobación';
  SEstAprobada = 'Aprobada';
  SEstRechazada = 'Rechazada';
  SEstEnviada = 'Enviada al cliente';

  SMesEnero = 'Enero';
  SMesFebrero = 'Febrero';
  SMesMarzo = 'Marzo';
  SMesAbril = 'Abril';
  SMesMayo = 'Mayo';
  SMesJunio = 'Junio';
  SMesJulio = 'Julio';
  SMesAgosto = 'Agosto';
  SMesSetiembre = 'Setiembre';
  SMesOctubre = 'Octubre';
  SMesNoviembre = 'Noviembre';
  SMesDiciembre = 'Diciembre';
  SMesAnio = '%s %d';
  SColones = '₡ %s';

  SCargandoCatalogo = 'Cargando %s...';
  SCargandoClientes = 'Cargando clientes...';
  SCargandoSolicitudes = 'Cargando solicitudes...';
  SCargandoBitacora = 'Cargando la bitácora...';
  SSinClientes = 'No hay clientes que coincidan';
  SSinSolicitudes = 'No hay solicitudes que coincidan';
  SSinRegistros = 'No hay registros que coincidan';

  SPaginacionRegistros = '%d registros · página %d de %d';
  SPaginacionClientes = '%d clientes · página %d de %d';
  SPaginacionSolicitudes = '%d solicitudes · página %d de %d';
  SPaginacionMovimientos = '%d movimientos · página %d de %d';
  SRegistrosTotal = '%d registros';

  STodasLasCategorias = 'Todas las categorías';
  SSinMovimientos = 'No hay movimientos en ese periodo';

  SOpcionPendiente = 'Esta opción todavía no está disponible.';
  SCampoObligatorio = '%s es obligatorio.';
  SSinDato = '-';
  SCerrar = 'Cerrar';
  SHistorialCompleto = 'Historial completo';
  SSalir = 'Salir';

  SProbando = 'Probando...';
  SConectado = 'Conectado';
  SSinRespuesta = 'Sin respuesta';
  SMilisegundos = '%d ms';
  SRespondeEn = 'Responde en %d ms';
  SUrlVacia = 'Escriba la dirección del servidor.';
  SUrlSinHttps = 'La dirección del servidor debe empezar por https://';

  SReglaClave = 'Mínimo 10 caracteres, con letras y números.';
  SFaltaClaveNueva = 'Escriba la clave nueva.';
  SClavesNoCoinciden = 'La clave nueva y su repetición no coinciden.';
  SClaveCambiada = 'Su clave quedó cambiada.';
  SClaveCambiadaReingreso = 'Su clave quedó cambiada. Vuelva a ingresar ' +
    'con la clave nueva.';
  SClaveProvisional = 'Su clave es provisional: cámbiela para continuar';

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
