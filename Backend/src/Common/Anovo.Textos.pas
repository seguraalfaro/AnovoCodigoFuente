unit Anovo.Textos;

// Todo el texto que lee una persona, en un solo sitio.
// La comparten el backend y el escritorio.

interface

resourcestring

  SFaltaPrecioUnitario = 'Falta el precio unitario.';
  SEmpresaFaltaRazonSocial = 'Falta la razón social.';
  SEmpresaRazonSocialLarga = 'La razón social pasa de %d caracteres.';
  SEmpresaFaltaCedula = 'Falta la cédula jurídica.';
  SEmpresaCedulaLarga = 'La cédula jurídica pasa de %d caracteres.';
  SEmpresaIvaFueraDeRango = 'El IVA debe estar entre 0 y 100 %.';
  SEmpresaDiasFueraDeRango = 'El plazo sin respuesta debe estar entre %d y %d días.';
  SDetalleCambioEmpresa = 'Cambio en los datos de la empresa';
  SVersionBaseDatos = 'Migración %d';
  SImportacionVacia = 'La carga no trae filas para importar.';
  SImportacionDemasiadas = 'La carga trae %d filas; el máximo por carga es %d.';
  SImpSeparador = ' · ';
  SImpFaltaCodigo = 'Falta el código';
  SImpCodigoLargo = 'El código pasa de %d caracteres';
  SImpCodigoRepetido = 'Código repetido en la fila %d';
  SImpCodigoExiste = 'El código ya existe en el catálogo';
  SImpFaltaNombre = 'Falta el nombre';
  SImpNombreLargo = 'El nombre pasa de %d caracteres';
  SImpNombreRepetido = 'Nombre repetido en la fila %d';
  SImpNombreExiste = 'Ya hay un ítem con ese nombre';
  SImpDescripcionLarga = 'La descripción pasa de %d caracteres';
  SImpFaltaUnidad = 'Falta la unidad de medida';
  SImpUnidadNoExiste = 'La unidad «%s» no existe o está inactiva';
  SImpFaltaCategoria = 'Falta la categoría';
  SImpCategoriaNoExiste = 'La categoría «%s» no existe';
  SImpFaltaCosto = 'Falta el costo';
  SImpCostoNegativo = 'El costo no puede ser negativo';
  SImpFaltaPrecio = 'Falta el precio';
  SImpPrecioNegativo = 'El precio no puede ser negativo';
  SImpCostoNoNumero = 'El costo no es un número';
  SImpPrecioNoNumero = 'El precio no es un número';
  SImportarMateriales = 'Importar materiales nuevos';
  SImportarManoObra = 'Importar mano de obra nueva';
  SImportarMaquinas = 'Importar máquinas nuevas';
  SCampoCodigo = 'Código';
  SCampoNombre = 'Nombre';
  SCampoDescripcion = 'Descripción';
  SCampoUnidad = 'Unidad de medida';
  SCampoCategoria = 'Categoría';
  SCampoCosto = 'Costo';
  SCampoCostoHora = 'Costo por hora';
  SCampoPrecio = 'Precio';
  SSinColumna = '(sin columna)';
  SColumnaSinNombre = 'Columna %d';
  SFilaLista = 'Lista';
  SFilaRevisando = 'Revisando…';
  SAprobarCarga = 'Importar · %d';
  SFilasSaltadas = 'Se saltaron %d filas porque ya existen en el catálogo: %s.';
  SFilaSaltada = 'Se saltó 1 fila porque ya existe en el catálogo: %s.';
  SSeparadorFilas = ', ';
  SResumenCarga = 'Filas leídas: %d  ·  Listas: %d  ·  Con error: %d';
  SResumenRevisando = 'Filas leídas: %d  ·  Revisando con el servidor…';
  SConfirmarCarga = 'Se van a crear %d ítems nuevos en el catálogo. ¿Desea continuar?';
  SCargaCreada = 'Se crearon %d ítems nuevos.';
  SCargaConErrores = 'Algunas filas ya no pasan la revisión: quedaron marcadas y no se registró nada.';
  SArchivoNoExiste = 'El archivo no existe.';
  SArchivoFormato = 'Solo se aceptan archivos de Excel (.xlsx) o CSV.';
  SArchivoNoSeLee = 'No se pudo leer el archivo. Revise que sea un libro de Excel (.xlsx) válido y que no esté abierto con contraseña.';
  SArchivoSinDatos = 'La hoja no tiene datos.';
  SFiltroArchivosCarga = 'Excel o CSV (*.xlsx;*.csv)|*.xlsx;*.csv';
  SAccionLeerArchivo = 'leer el archivo';
  SAccionRevisarCarga = 'revisar la carga';
  SAccionAprobarCarga = 'registrar la carga';
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
  SNombreDuplicadoUnidadMedida = 'Ya existe una unidad de medida con ese ' +
    'nombre.';
  SNombreDuplicadoOtraUnidadMedida = 'Ya existe otra unidad de medida con ' +
    'ese nombre.';
  SMagnitudInvalida = 'La magnitud debe ser tiempo, peso, longitud, área, ' +
    'volumen o unidades.';
  SUnidadMedidaInactiva = 'La unidad de medida está inactiva. Escoja otra.';
  SMagnitudTiempo = 'Tiempo';
  SMagnitudPeso = 'Peso';
  SMagnitudLongitud = 'Longitud';
  SMagnitudArea = 'Área';
  SMagnitudVolumen = 'Volumen';
  SMagnitudUnidades = 'Unidades';

  SClienteNoExiste = 'El cliente indicado no existe.';
  SContactoNoEsDelCliente = 'El contacto indicado no existe o no es de ese ' +
    'cliente.';
  SSolicitudSinPiezas = 'La solicitud no trae ninguna pieza.';
  SFaltaPieza = 'Indique a qué pieza de la solicitud pertenece.';
  SRecursoPieza = 'la pieza';
  STipoMaterialNoDisponible = 'El tipo de material indicado no existe o ' +
    'está inactivo.';
  SAcabadoNoDisponible = 'El acabado indicado no existe o está inactivo.';
  SFaltaTipoTrabajo = 'Indique el tipo de trabajo de la pieza.';
  SFaltaTipoMaterial = 'Indique el tipo de material de la pieza.';
  SFaltaAcabado = 'Indique el acabado de la pieza.';
  SCroquisNoEsDeLaPieza = 'La medida apunta a un croquis que no viene en ' +
    'la misma pieza.';
  SRegistroSinContacto = 'El registro debe traer al menos un contacto.';
  SFirmaVacia = 'La imagen de la firma viene vacía.';

  SSolicitudNoExiste = 'La solicitud indicada no existe.';
  SFaltaIdLocalSolicitud = 'Falta el identificador local de la solicitud.';
  SFaltaIdLocalAdjunto = 'Falta el identificador local del adjunto.';
  SCantidadMedidaInvalida = 'La cantidad de la medida debe estar entre 1 y 9999.';
  STipoAdjuntoInvalido = 'El tipo de adjunto debe ser croquis o foto.';

  SCantidadInvalida = 'La cantidad debe ser mayor que cero.';
  STipoLineaInvalido = 'El tipo de línea no es válido.';
  SLineaSinMaterial = 'Una línea de material necesita el material.';
  SLineaSinMaquina = 'Una línea de máquina necesita la máquina.';
  SDescartarSinMotivo = 'Descartar una solicitud exige indicar el motivo.';
  SDevolverSinObservacion = 'Devolver exige una observación.';
  SRevisarPropia = 'Una cotización no la puede revisar quien la elaboró.';
  SSolicitudTomada = 'Esta solicitud ya la tomó otro usuario.';
  SFechaInvalida = 'La fecha %s no tiene la forma aaaa-mm-dd.';
  SFechaHoraInvalida = 'La fecha %s no tiene la forma ISO 8601 ' +
    '(aaaa-mm-ddThh:mm:ss).';
  SFiltroConsentimientoInvalido = 'El filtro de consentimiento debe ser ' +
    'pendiente, firmado o revocado.';
  SFaltaVersion = 'Falta la versión del registro. Recargue %s y vuelva a ' +
    'intentarlo.';
  SClienteAnonimizado = 'Este cliente fue anonimizado (Ley 8968) y ya no ' +
    'admite cambios.';
  SClienteAnonimizadoNombre = 'Cliente anonimizado %d';
  SContactoAnonimizadoNombre = 'Contacto anonimizado';
  SAnonimizarSoloFisica = 'La anonimización solo aplica a personas físicas: ' +
    'este cliente tiene cédula jurídica.';
  SAnonimizarSinTipo = 'Indique primero el tipo de identificación del ' +
    'cliente: la anonimización solo aplica a personas físicas.';
  SDetalleAnonimizacionCliente = 'Se anonimizó el cliente %d (Ley 8968): %s';
  SAccionAnonimizar = 'anonimizar al cliente';
  SAnonimizarTitulo = 'Anonimizar al cliente (derecho de supresión)';
  SAnonimizarAyuda = 'Borra los datos personales del cliente y de sus ' +
    'contactos, y vacía sus croquis y fotografías. Las cotizaciones quedan ' +
    'con sus montos, sin el nombre del titular. No se puede deshacer.';
  SAnonimizarBoton = 'Anonimizar';
  SFaltaUuidLocal = 'El registro no trae su identificador local (uuid_local).';
  SUuidLocalLargo = 'El identificador local (uuid_local) no puede pasar de %d ' +
    'caracteres.';
  SRegistroNoGuardado = 'No se pudo guardar el registro de %s: %s';
  SConsentimientoYaRevocado = 'El consentimiento de este cliente ya estaba ' +
    'revocado.';
  SCotizacionNoEditable = 'Una cotización en estado %s ya no admite cambios.';
  SLineaSinManoObra = 'Una línea de mano de obra necesita la mano de obra.';
  SLineaSinPrecio = 'El ítem no tiene precio vigente en el catálogo. Cargue ' +
    'el precio o indíquelo en la línea.';
  SSolicitudNoCotizable = 'Una solicitud en estado %s no se puede cotizar.';
  SAjusteSinMotivo = 'Un ajuste distinto de cero exige indicar el motivo.';
  SCotizacionSinLineas = 'La cotización no tiene líneas: no hay nada que ' +
    'revisar.';
  SCotizacionNoAprobable = 'Una cotización en estado %s no admite el visto bueno.';
  SCotizacionSinRespuesta = 'La respuesta del cliente se registra sobre una cotización enviada; esta está en estado %s.';
  SCotizacionNoDevolvible = 'Una cotización en estado %s no se puede devolver.';
  SCotizacionNoEnviable = 'Una cotización en estado %s no se puede enviar al ' +
    'cliente.';
  SSolicitudTransicionInvalida = 'Una solicitud en estado %s no puede pasar a ' +
    '%s.';
  SSolicitudCotizada = 'Esta solicitud ya tiene cotización y no admite cambios.';
  SAdjuntoMuyGrande = 'El adjunto supera el máximo de 3 MB permitido.';
  SAdjuntoVacio = 'El adjunto viene vacío: falta el contenido o los trazos.';
  SPendienteSinItem = 'El pendiente no apunta a ningún ítem del catálogo.';
  SClaveVaciaHash = 'No se puede calcular el hash de una clave vacía.';
  SUsuarioEliminado = 'Usuario eliminado';
  SUsuarioSistema = 'Sistema';
  SAccionEditar = 'Editar';
  SAccionHistorial = 'Historial';
  SAccionPrecio = 'Precio';
  SAccionInactivar = 'Inactivar';
  SAccionActivar = 'Activar';
  SAccionDetalles = 'Detalles';
  SAccionQuitar = 'Quitar';
  SAccionVer = 'Ver';
  SSinTokenSesion = 'El servidor no devolvió el token de sesión.';
  SErrorServidor = 'El servidor respondió con un error (%d).';
  STokenInvalido = 'El servidor devolvió un token con formato inválido.';
  SRolSinRol = 'Sin rol';
  SRolAsesor = 'Asesor comercial';
  SRolAsistente = 'Asistente de cotizaciones';
  SRolSupervisor = 'Supervisor';
  SRolGerencia = 'Gerencia';
  SRolAdmin = 'Administrador del sistema';
  STipoIdCedulaFisica = 'Cédula física';
  STipoIdCedulaJuridica = 'Cédula jurídica';
  STipoIdDimex = 'DIMEX';
  SReporteRangoInvalido = 'La fecha inicial no puede ser posterior a la final.';
  SSinTipoTrabajo = 'Sin tipo de trabajo';

  SPeriodoInvertido = 'La fecha de inicio es posterior a la del fin.';
  SFiltroTodo = 'Todo';
  SFiltroClientes = 'Clientes';
  SFiltroCotizaciones = 'Cotizaciones';
  SFiltroCuentas = 'Cuentas';
  SFiltroUsuarios = 'Usuarios';
  SFiltroClaves = 'Claves';
  SFiltroMatrizRoles = 'Matriz de roles';
  SFiltroPermisosPersona = 'Permisos por persona';
  SAccionAudRegistro = 'Registro';
  SAccionAudCambio = 'Cambio';
  SAccionAudBorrado = 'Borrado';
  SEntUsuario = 'Usuario';
  SEntClave = 'Clave';
  SEntPermisoRol = 'Permiso de rol';
  SEntPermisoPersona = 'Permiso de persona';
  SEntCliente = 'Cliente';
  SEntContacto = 'Contacto';
  SEntConsentimiento = 'Consentimiento';
  SEntCotizacion = 'Cotización';
  SEntSolicitud = 'Solicitud';
  SEntEmpresa = 'Empresa';
  SEntUnidadMedida = 'Unidad de medida';
  SEntPrecio = 'Precio';
  SEntPrecioProgramado = 'Precio programado';
  SEntCategoriaManoObra = 'Categoría de mano de obra';
  SAuditoriaSoloCuentas = 'consultar en la auditoría algo distinto de las ' +
    'cuentas: usuarios, claves, matriz de roles y permisos por persona';

  SFaltaClaveActual = 'Falta la clave actual.';
  SClaveActualIncorrecta = 'La clave actual no es correcta.';
  SClaveCorta = 'La clave nueva debe tener al menos %d caracteres.';
  SClaveSinLetrasONumeros = 'La clave nueva debe combinar letras y números.';
  SClaveIgualALaActual = 'La clave nueva debe ser distinta de la actual.';

  SRecursoNoExiste = 'No existe %s con el número %d.';
  SRecursoNoExisteGenerico = 'El recurso solicitado no existe.';
  SRecursoMaterial = 'el material';
  SRecursoRol = 'el rol';
  SRecursoPermiso = 'el permiso';
  SRecursoManoObra = 'la mano de obra';
  SRecursoMaquina = 'la máquina';
  SRecursoTipoTrabajo = 'el tipo de trabajo';
  SRecursoEmpresa = 'los datos de la empresa';
  STipoTrabajoNoDisponible =
    'El tipo de trabajo no existe o está inactivo.';
  SRecursoUnidadMedida = 'la unidad de medida';
  SRecursoCliente = 'el cliente';
  SRecursoContacto = 'el contacto';
  SRecursoCotizacion = 'la cotización';
  SRecursoLinea = 'la línea de cotización';
  SRecursoUsuario = 'el usuario';
  SRecursoSolicitud = 'la solicitud';
  SRecursoMedida = 'la medida';
  SRecursoAdjunto = 'el adjunto';
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
  SDemasiadasPeticiones = 'Se hicieron demasiadas consultas en poco tiempo. ' +
    'Espere un minuto e intente de nuevo.';
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
  SAccionCargarBandeja = 'cargar la bandeja';
  SAccionCargarCotizacion = 'cargar la cotización';
  SAccionRevisarCotizacion = 'registrar la revisión';
  SCotizacionNumero = 'Cotización Nº %d';
  SRevisionSubtitulo = '%s · Asesor: %s · Elaboró: %s';
  SConfirmarAprobar = '¿Dar el visto bueno a la cotización Nº %d? Queda lista para enviar al cliente.';
  SDevolverTitulo = 'Devolver la cotización Nº %d';
  SDevolverAyuda = 'Queda devuelta para que se corrija y se envíe de nuevo a revisión. Indique qué hay que corregir.';
  SBotonDevolver = 'Devolver';
  SMotivoFalta = 'Escriba el motivo.';
  SSinCambiosPermisos = 'No hay cambios de permisos que guardar.';
  SPermisoFueraDeAmbito = 'El permiso «%s» no corresponde al ámbito del ' +
    'rol %s.';
  SAccionCambiarPermisos = 'cambiar permisos';
  SAccionPermisosPropioRol = 'cambiar los permisos de su propio rol';
  SDetalleOtorgaPermisoRol = 'Se otorgó «%s» al rol %s: %s';
  SDetalleQuitaPermisoRol = 'Se quitó «%s» al rol %s: %s';
  SDetalleExcepcionSobrante = 'La excepción de «%s» quedó de más: el rol %s ' +
    'ya lo decide.';
  SAccionPermisosPropios = 'cambiar sus propios permisos';
  SAccionCambiarPropioRol = 'cambiar su propio rol';
  SAccionInactivarPropiaCuenta = 'inactivar su propia cuenta';
  SAccionRestablecerPropiaClave = 'restablecer su propia clave desde aquí; ' +
    'use el cambio de clave de su cuenta';
  SAccionPedirCambioPropiaClave = 'pedir el cambio de su propia clave desde ' +
    'aquí; use el cambio de clave de su cuenta';
  SClaveTemporalInvalida = 'La clave temporal debe tener al menos %d ' +
    'caracteres y no llevar espacios.';
  SFaltaNombreUsuario = 'Escriba el nombre de la persona.';
  SCorreoInvalido = 'Escriba un correo válido.';
  SCorreoDuplicado = 'Ya existe un usuario con el correo %s.';
  SEstadoUsuarioInvalido = 'El estado «%s» no existe. Use activos, ' +
    'inactivos, clave_pendiente o con_adicionales.';
  STipoExcepcionInvalido = 'El tipo «%s» no existe. Use otorgado, quitado ' +
    'o vacío para quitar la excepción.';
  SExcepcionSinEfecto = 'El rol %s ya %s «%s»: la excepción no cambiaría nada.';
  SRolYaTiene = 'tiene';
  SRolNoTiene = 'no tiene';
  SDetalleUsuarioCreado = 'Se registró la cuenta de %s con el rol %s.';
  SDetalleUsuarioEditado = 'Se actualizaron los datos de %s.';
  SDetalleUsuarioCambioRol = 'Cambio de rol de %s: %s a %s.';
  SDetalleExcepcionesPorCambioRol = 'Se inactivaron las excepciones de %s ' +
    'por el cambio de rol.';
  SDetalleUsuarioInactivado = 'Se inactivó la cuenta de %s.';
  SDetalleUsuarioActivado = 'Se activó la cuenta de %s.';
  SDetalleClaveRestablecida = 'Se restableció la clave de %s; debe ' +
    'cambiarla en su próximo ingreso.';
  SDetalleClaveAnterior = 'Clave anterior de %s desactivada por ' +
    'restablecimiento.';
  SDetalleCambioClavePedido = 'Se pidió a %s cambiar su clave en el ' +
    'próximo ingreso.';
  SDetalleOtorgaPermisoUsuario = 'Se otorgó «%s» a %s: %s';
  SDetalleQuitaPermisoUsuario = 'Se quitó «%s» a %s: %s';
  SDetalleRetiraExcepcionUsuario = 'Se retiró la excepción de «%s» de %s: %s';
  SAjustePorcentaje = 'Ajuste %s %%';
  SIvaPorcentaje = 'IVA %s %%';
  SAccionRevisar = 'Revisar';
  SAccionCargarFichaCliente = 'cargar la ficha del cliente';
  SAccionCargarBitacora = 'cargar la bitácora';
  SAccionCargarDashboard = 'cargar el dashboard';
  SAccionCargarReporte = 'cargar el reporte';
  SAccionCargarSolicitudes = 'cargar las solicitudes';
  SAccionTomarSolicitud = 'tomar la solicitud';
  SAccionTomar = 'Tomar';
  SConfirmarTomar = '¿Tomar la solicitud de %s? Se crea su cotización en ' +
    'borrador a su nombre y sale de la cola.';
  SAccionCargarCuenta = 'cargar su cuenta';
  SAccionProbarConexion = 'probar la conexión';
  SAccionCambiarClave = 'cambiar la clave';
  SAccionCargarEmpresa = 'cargar los datos de la empresa';
  SAccionGuardarEmpresa = 'guardar los datos de la empresa';
  SAccionGuardarParametros = 'guardar los parámetros';
  SEmpresaGuardada = 'Los datos de la empresa quedaron guardados.';
  SParametrosGuardados = 'Los parámetros quedaron guardados. El intervalo ' +
    'de los avisos rige desde su próximo ingreso.';
  SReparosEmpresa = 'No se pueden guardar los datos de la empresa. ' +
    'Corrija lo siguiente:';
  SMinutosAvisosFueraDeRango = 'Los avisos se revisan cada %d a %d minutos.';
  SPermisosSoloRol = 'Solo los del rol';
  SPermisosPropios = '%d adicionales · %d quitados';
  SAccionCargarDocumento = 'preparar el documento de la cotización';
  SDocumentoGuardado = 'El documento quedó guardado en %s';
  SFiltroPdf = 'Documento PDF (*.pdf)|*.pdf';
  SNombrePdfCotizacion = 'Cotizacion-%d.pdf';
  SColonesDocumento = '¢%s';
  SFechaLarga = '%d de %s de %d';
  SDocCotizacion = 'COTIZACIÓN';
  SDocProforma = 'Proforma #%d';
  SDocSenores = 'Señores:';
  SDocTelefono = 'Tel: %s';
  SDocAtencion = 'Atención:';
  SDocEstimado = 'Estimado(a) %s:';
  SDocEstimadoCliente = 'Estimado(a) cliente:';
  SDocIntroduccion = 'Nos complace presentarle la siguiente cotización ' +
    'correspondiente a los servicios solicitados, la cual ponemos a su amable ' +
    'consideración.';
  SDocServicio = 'Descripción del servicio o producto:';
  SDocColDescripcion = 'Descripción';
  SDocColCantidad = 'Cantidad';
  SDocColPrecio = 'Precio unitario';
  SDocColTotal = 'Total';
  SDocSubtotal = 'Subtotal';
  SDocIva = 'IVA %s %%';
  SDocTotal = 'Total';
  SDocFormaPago = 'Forma de pago: %s';
  SDocCuenta = 'Cuenta bancaria: %s';
  SDocEntrega = 'Entrega: %s';
  SDocGarantia = 'Garantía: %s';
  SDocSujetoCambio = 'SUJETO A CAMBIO DE PRECIOS SIN PREVIO AVISO.';
  SDocAtentamente = 'Atentamente:';
  SDocCedula = 'CED: %s';
  SDocTelefonos = 'TEL: %s';
  SDocAviso = 'Sus datos se tratan según nuestro aviso de privacidad v%s';
  SDocPagina = 'Página';
  SDocDe = 'de';
  SDocTitulo = 'Cotización %d - %s';
  SCorreoNoConfigurado = 'El envío por correo no está configurado en el ' +
    'servidor. Guarde el PDF y envíelo a mano.';
  SCorreoSinAutorizacion = 'La cuenta de correo no está autorizada (OAuth2). ' +
    'Autorícela desde la ventana del servidor.';
  SCorreoFaltaClienteOAuth = 'Falta la cuenta o el client ID de OAuth2 en el .env.';
  SCorreoAutorizacionFallida = 'No se pudo autorizar la cuenta de correo: %s';
  SCorreoCuentaDistinta = 'Se esperaba la cuenta %s y se inició sesión con %s.';
  SCorreoAutorizado = 'La cuenta %s quedó autorizada para enviar cotizaciones.';
  SCorreoFaltaDestinatario = 'Falta el correo del destinatario.';
  SCorreoDemasiadosDestinatarios = 'Se permiten hasta %d destinatarios por envío.';
  SCorreoDestinatarioInvalido = 'El correo %s no tiene una forma válida.';
  SCorreoFaltaAsunto = 'Falta el asunto del correo.';
  SCorreoAsuntoInvalido = 'El asunto debe tener una sola línea y hasta %d ' +
    'caracteres.';
  SCorreoAdjuntoGrande = 'El PDF pasa de %d MB.';
  SCorreoMensajeLargo = 'El mensaje pasa de %d caracteres.';
  SCorreoFaltaPdf = 'Falta el PDF de la cotización.';
  SCorreoPdfInvalido = 'El adjunto no es un PDF válido.';
  SCorreoClaveRechazada = 'El servidor de correo rechazó la contraseña de ' +
    'aplicación. Revísela en el .env del servidor o genere una nueva.';
  SCorreoOAuthRechazado = 'El servidor de correo rechazó la autorización ' +
    'OAuth2. Vuelva a autorizar la cuenta desde la ventana del servidor.';
  SCorreoDestinatarioRechazado = 'El servidor de correo rechazó el ' +
    'destinatario. Revise la dirección.';
  SCorreoSinConexion = 'No se pudo conectar con el servidor de correo. ' +
    'Revise la conexión a internet del servidor.';
  SCorreoFallido = 'El servidor de correo no aceptó el envío (código %d).';
  SDetalleEnvioCorreo = 'Envío por correo de la cotización %d a %s';
  SAccionEnviarCorreo = 'enviar la cotización por correo';
  SIngresoBloqueado = 'Demasiados intentos fallidos de ingreso. Intente de ' +
    'nuevo en %d minutos.';
  SCambioClavePendiente = 'Debe cambiar su clave antes de continuar.';
  STokenAccesoInvalido = 'El token de acceso no es válido. Vuelva a ingresar.';
  SAdjuntoFormatoInvalido = 'El adjunto debe ser una imagen JPEG o PNG.';
  SAdjuntoJsonInvalido = 'El croquis no tiene un formato válido.';
  SSesionRevocada = 'Su cuenta cambió (estado, rol o clave). Vuelva a ingresar.';
  SDispositivoInvalido = 'La sesión de este teléfono ya no es válida. Ingrese con su clave.';
  SFaltaUuidDispositivo = 'Falta el identificador del teléfono.';
  SDocsTitulo = 'Documentación de la API';
  SDocsSubtitulo = 'Acceso solo para el personal de TI de Anovo.';
  SDocsCorreo = 'Correo';
  SDocsClave = 'Clave';
  SDocsEntrar = 'Entrar';
  SDocsInvalido = 'El correo o la clave no son correctos.';
  SDocsSinPermiso = 'Su cuenta no tiene acceso a la documentación de la API.';
  SDocsSinAcceso = 'Inicie sesión en /docs/acceso para ver la documentación.';
  SAccionEstadoCorreo = 'consultar el correo del servidor';
  SEnvioAsunto = 'Cotización %d - %s';
  SEnvioMensaje = 'Estimado(a) %s:' + sLineBreak + sLineBreak +
    'Le adjuntamos la cotización Nº %d correspondiente a %s, para su ' +
    'consideración.' + sLineBreak + sLineBreak +
    'Quedamos atentos a sus comentarios.' + sLineBreak + sLineBreak +
    'Atentamente,' + sLineBreak + '%s' + sLineBreak + '%s';
  SEnvioClienteGenerico = 'cliente';
  SEnvioAdjunto = 'Adjunto: %s';
  SEnvioDesdeServidor = 'Desde el servidor sale con la cuenta de la empresa ' +
    '(%s). Manualmente, se guarda el PDF y se abre su programa de correo.';
  SEnvioServidorNoDisponible = 'El servidor no tiene configurado el correo. ' +
    'Use «Enviar manualmente»: se guarda el PDF y se abre su programa de correo.';
  SConfirmarEnvioServidor = '¿Enviar la cotización Nº %d a %s desde la cuenta ' +
    'de la empresa?';
  SConfirmarEnvioManual = 'Se guardó el PDF en %s y se abrió su programa de ' +
    'correo. Adjunte el PDF y envíe el correo.' + sLineBreak + sLineBreak +
    '¿Ya lo envió? La cotización Nº %d quedará marcada como enviada.';
  SCotizacionEnviadaCorreo = 'La cotización Nº %d se envió a %s.';
  SReparosEnvio = 'No se puede enviar. Corrija lo siguiente:';
  SValPara = 'Escriba al menos un correo de destinatario válido.';
  SValCopia = 'Uno de los correos en copia no tiene una forma válida.';
  SValAsunto = 'Escriba el asunto del correo.';

  SCatalogoTodos = 'Todos';
  SCatalogoMateriales = 'Materiales';
  SCatalogoManoObra = 'Mano de obra';
  SCatalogoMaquinas = 'Máquinas';
  SCatalogoTiposTrabajo = 'Tipos de trabajo';
  SCatalogoUnidadesMedida = 'Unidades de medida';

  STipoMaterial = 'Material';
  STipoManoObra = 'Mano de obra';
  STipoMaquina = 'Máquina';
  STipoNota = 'Nota';

  SItemMaterial = 'material';
  SItemManoObra = 'mano de obra';
  SItemMaquina = 'máquina';
  SItemTipoTrabajo = 'tipo de trabajo';
  SItemUnidadMedida = 'unidad de medida';

  STituloNuevoItem = 'Nuevo %s';
  STituloEditarItem = 'Editar %s';
  STituloNuevaUnidadMedida = 'Nueva unidad de medida';

  SNuevoMaterial = '+ Nuevo material';
  SNuevaManoObra = '+ Nueva mano de obra';
  SNuevaMaquina = '+ Nueva máquina';
  SNuevoTipoTrabajo = '+ Nuevo tipo de trabajo';
  SNuevaUnidadMedida = '+ Nueva unidad de medida';

  SPistaBusquedaItem = 'Código, nombre o descripción';
  SPistaBusquedaNombre = 'Nombre';

  SCompleteCodigo = 'Complete el código después de %s';
  SNombreObligatorio = 'El nombre es obligatorio.';
  SEscojaUnidadMedida = 'Escoja la unidad de medida.';
  SEscojaMagnitud = 'Escoja la magnitud.';
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
  SEstPendiente = 'Enviada a revisión';
  SEstDevuelta = 'Devuelta';
  SEstVistoBueno = 'Con visto bueno';
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
  SDiaUno = '1 día';
  SDias = '%d días';
  SPorcentaje = '%d %%';
  SVistaPorEstado = 'Por estado';
  SVistaPorAsesor = 'Por asesor';
  SVistaPorTipo = 'Por tipo de trabajo';
  SVistaPorMes = 'Por mes';
  STotalReporte = 'Total';
  SDecididasMes = '%d de %d decididas';

  SCargandoCatalogo = 'Cargando %s...';
  SCargandoClientes = 'Cargando clientes...';
  SCargandoBandeja = 'Cargando la bandeja...';
  SCargandoSolicitudes = 'Cargando solicitudes...';
  SCargandoBitacora = 'Cargando la bitácora...';
  SCargandoUsuarios = 'Cargando usuarios...';
  SSinClientes = 'No hay clientes que coincidan';
  SSinBandeja = 'No hay cotizaciones esperando revisión';
  SSinSolicitudes = 'No hay solicitudes que coincidan';
  SSinCola = 'No hay solicitudes sin procesar';
  SSinEnTrabajo = 'No tiene solicitudes en curso';
  SSinRegistros = 'No hay registros que coincidan';
  SSinUsuarios = 'No hay usuarios que coincidan';

  SPaginacionRegistros = '%d registros · página %d de %d';
  SPaginacionClientes = '%d clientes · página %d de %d';
  SPaginacionBandeja = '%d cotizaciones · página %d de %d';
  SPaginacionSolicitudes = '%d solicitudes · página %d de %d';
  SPaginacionMovimientos = '%d movimientos · página %d de %d';
  SPaginacionUsuarios = '%d usuarios · página %d de %d';

  SAccionCargarUsuarios = 'cargar los usuarios';
  SAccionCargarUsuario = 'cargar el usuario';
  SAccionRestablecerClave = 'restablecer la clave';
  SAccionCambiarEstadoUsuario = 'cambiar el estado de la cuenta';
  SConfirmarInactivarUsuario = '¿Inactivar la cuenta de %s? Ya no podrá ' +
    'ingresar; sus registros se conservan y se puede volver a activar.';
  SConfirmarActivarUsuario = '¿Activar la cuenta de %s?';
  SEstClavePendiente = 'Cambiar clave';
  SOrigenBasico = 'Paquete básico';
  SOrigenAdicional = 'Adicional';
  SOrigenQuitado = 'Quitado';
  SClaveTemporalTitulo = 'Clave temporal';
  SGenerarClave = 'Generar clave';
  SGenerarOtra = 'Generar otra';
  SPedirCambio = 'Pedir cambio al entrar';
  SNoPedirCambio = 'No pedir cambio';
  SSinGuardar = 'Sin guardar';
  SClaveVigente = 'Vigente';
  SClaveCambiadaEl = 'Cambiada el %s';
  SClaveDebeCambiar = 'Debe cambiarla al entrar';
  SClaveSeAplica = 'Se aplica al guardar. La persona deberá cambiarla al ' +
    'entrar. Désela en persona o por teléfono, no por correo ni WhatsApp.';
  SClaveNuevaNota = 'Se aplica al crear la cuenta. La persona deberá ' +
    'cambiarla al entrar. Désela en persona o por teléfono.';
  SCambioPedidoNota = 'Al guardar, se le pedirá cambiar su clave la próxima ' +
    'vez que entre.';
  SCopiar = 'Copiar';
  SCopiada = 'Copiada';
  SListo = 'Listo';
  SBotonGuardar = 'Guardar';
  SNuevoUsuarioTitulo = 'Nuevo usuario';
  SNuevoUsuarioAyuda = 'Se genera una clave temporal que la persona cambia ' +
    'en su primer ingreso';
  SUsuarioRegistrado = 'Registrado el %s';
  SFaltaRol = 'Escoja el rol de la persona.';
  SAvisoCambioRol = 'Al cambiar de rol se quitan sus permisos adicionales ' +
    'y quitados (%d). Quedará solo con el paquete básico del rol nuevo.';
  SPermisosTrasCambioRol = 'Guarde primero el cambio de rol; después se ' +
    'ajustan los permisos sobre el paquete básico del rol nuevo.';
  SPastillaDelRol = '%d del rol';
  SUnAdicional = '%d adicional';
  SVariosAdicionales = '%d adicionales';
  SUnQuitado = '%d quitado';
  SVariosQuitados = '%d quitados';
  SSinGuardarCantidad = '%d sin guardar';
  SSoloExcepciones = 'Solo adicionales y quitados';
  SSinResultados = 'Sin resultados';
  SValNombreCliente = 'El nombre o razón social debe tener al menos tres letras.';
  SValNombreContacto = 'El nombre del contacto debe tener al menos tres letras.';
  SValIdentificacion = 'La identificación no tiene el largo que corresponde al ' +
    'tipo seleccionado.';
  SValTelefono = 'El teléfono debe tener ocho dígitos.';
  SValTelefonoExt = 'El teléfono debe tener ocho dígitos, con extensión o ' +
    'sin ella.';
  SValCelular = 'El celular debe tener ocho dígitos.';
  SValCorreo = 'El correo no tiene una forma válida, por ejemplo ' +
    'nombre@dominio.cr';
  SValCodigoExoneracion = 'Un cliente exonerado necesita su código de ' +
    'exoneración.';
  SReparosCliente = 'No se puede guardar el cliente. Corrija lo siguiente:';
  SReparosContacto = 'No se puede guardar el contacto. Corrija lo siguiente:';
  SSinExcepciones = 'Esta persona no tiene permisos adicionales ni quitados.';
  SSinPermisosParaMostrar = 'No hay permisos para mostrar.';
  SPestanaPermisos = 'Permisos';
  SPestanaPermisosCon = 'Permisos · %s';
  SPaqueteBasico = 'Paquete básico del rol: %d permisos. Los adicionales se ' +
    'dan en la pestaña Permisos.';
  SIconoNuevo = '+';
  SCorreoYRol = '%s · %s';
  SEstActivo = 'Activo';
  SEstInactivo = 'Inactivo';
  SMotivoPermisosTitulo = 'Motivo del cambio de permisos';
  SModuloAdjuntos = 'Croquis y fotos';
  SModuloAuditoria = 'Auditoría';
  SModuloCatalogos = 'Catálogos';
  SModuloClientes = 'Clientes';
  SModuloCotizaciones = 'Cotizaciones';
  SModuloPermisos = 'Permisos';
  SModuloReportes = 'Reportes';
  SModuloSolicitudes = 'Solicitudes';
  SModuloUsuarios = 'Usuarios';
  SUsted = '%s (usted)';
  SSuRol = '%s (su rol)';
  SAccionCargarRoles = 'cargar los roles';
  SRolConUsuarios = '%s · %d';
  SSinCambiosRoles = 'Sin cambios pendientes';
  SCambiosRolesPendientes = '%d cambios sin guardar · su propio rol no se ' +
    'puede cambiar';
  SMotivoRolesTitulo = 'Motivo del cambio de paquete básico';
  SMotivoRolesAyuda = 'Rige para todas las personas del rol y queda en la ' +
    'auditoría. Indique quién lo autorizó y por qué.';
  SMotivoPermisosAyuda = 'Queda en la auditoría junto con quién lo hizo. ' +
    'Indique quién lo autorizó y por qué.';
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
  SDetalleRegistroMaterial = 'Registro del material %s';
  SDetalleCambioMaterial = 'Cambio en el material %s';
  SDetalleInactivacionMaterial = 'Inactivación del material %s';
  SDetalleRegistroManoObra = 'Registro de la mano de obra %s';
  SDetalleCambioManoObra = 'Cambio en la mano de obra %s';
  SDetalleInactivacionManoObra = 'Inactivación de la mano de obra %s';
  SDetalleRegistroMaquina = 'Registro de la máquina %s';
  SDetalleCambioMaquina = 'Cambio en la máquina %s';
  SDetalleInactivacionMaquina = 'Inactivación de la máquina %s';
  SDetalleRegistroTipoTrabajo = 'Registro del tipo de trabajo %s';
  SDetalleCambioTipoTrabajo = 'Cambio en el tipo de trabajo %s';
  SDetalleInactivacionTipoTrabajo = 'Inactivación del tipo de trabajo %s';
  SDetalleRegistroUnidadMedida = 'Registro de la unidad de medida %s';
  SDetalleCambioUnidadMedida = 'Cambio en la unidad de medida %s';
  SDetalleInactivacionUnidadMedida = 'Inactivación de la unidad de medida %s';
  SDetalleRegistroCliente = 'Registro del cliente %s';
  SDetalleEdicionCliente = 'Edición de los datos del cliente';
  SDetalleInactivacionCliente = 'Inactivación del cliente';
  SDetalleRegistroCompletoMovil = 'Registro con los datos completos desde el ' +
    'móvil';
  SDetalleContactoNuevo = 'Contacto nuevo del cliente %d';
  SDetalleEdicionContacto = 'Edición del contacto %d';
  SDetalleInactivacionContacto = 'Inactivación del contacto %d';
  SDetalleRevocacionConsentimiento = 'Revocación del consentimiento pedida ' +
    'por %s';
  SDetalleCotizacionDesdeSolicitud = 'Cotización %d desde la solicitud %d';
  SDetalleCambioCotizacion = 'Cambio en la cotización %d';
  SDetalleLineaAgregada = 'Línea agregada a la cotización %d';
  SDetalleCambioLinea = 'Cambio en una línea de la cotización %d';
  SDetalleLineaEliminada = 'Línea eliminada de la cotización %d';
  SDetalleRecalculoCotizacion = 'Recálculo de totales de la cotización %d';
  SDetalleAjusteCotizacion = 'Ajuste de %s%% en la cotización %d';
  SDetalleCotizacionPresentada = 'Cotización %d presentada a revisión';
  SDetalleAprobacionCotizacion = 'Visto bueno de la cotización %d';
  SDetalleRechazoCotizacion = 'El cliente rechazó la cotización %d';
  SDetalleAceptacionCotizacion = 'El cliente aprobó la cotización %d';
  SDetalleDevolucionCotizacion = 'Devolución de la cotización %d';
  SDetalleEnvioCotizacion = 'Envío al cliente de la cotización %d';
  SDetalleRegistroSolicitud = 'Registro de la solicitud %s';
  SDetalleCambioSolicitud = 'Cambio en la solicitud %d';
  SDetalleRecepcionSolicitud = 'Recepción de la solicitud %d';
  SDetalleCambioEstadoSolicitud = 'Cambio de estado de la solicitud %d a %s';
  SDetalleMedidaAgregada = 'Medida agregada a la solicitud %d';
  SDetalleCambioMedida = 'Cambio en una medida de la solicitud %d';
  SDetalleMedidaEliminada = 'Medida quitada (inactivada) de la solicitud %d';
  SDetalleAdjuntoAgregado = 'Adjunto agregado a la solicitud %d';
  SDetalleAdjuntoInactivado = 'Adjunto inactivado en la solicitud %d';

  SAccionAbrir = 'Abrir';
  SAccionEnviarCotizacion = 'enviar la cotización';
  SAccionPresentarCotizacion = 'presentar la cotización';
  SAccionCargarCotizaciones = 'cargar las cotizaciones';
  SAccionBuscarCatalogo = 'buscar en el catálogo';
  SCotizacionTitulo = 'Cotización Nº %d · %s';
  SCotizacionSubtitulo = 'Solicitud %d · Asesor: %s · Elaboró: %s';
  SCotizacionDevuelta = 'Devuelta por el supervisor: %s';
  SIvaExonerado = 'Cliente exonerado: IVA 0 %';
  SSinAjuste = 'Sin ajuste';
  SFotografias = 'Fotografías · %d';
  SSinCroquis = 'La pieza no tiene croquis';
  SSinFotos = 'Sin fotografías';
  SCargandoEvidencia = 'Cargando...';
  SPiezasTotal = 'Piezas · %d';
  SCroquisDePieza = 'Croquis · %s';
  SFotografiasDePieza = 'Fotografías · %s · %d';
  SMedidasDePieza = 'Medidas · %s';
  SSinProyecto = 'Sin nombre de proyecto';
  SSinContacto = 'Sin contacto';
  SContactoInactivo = 'El contacto ya no está activo';
  SAbrirEnVisor = 'Abrir en el visor de Windows';
  SConfirmarQuitarLinea = '¿Quitar la línea «%s»?';
  SConfirmarPresentar = '¿Enviar la cotización Nº %d a revisión? ' +
    'Mientras la revisan no se puede editar.';
  SConfirmarClienteAprobo = '¿Registrar que el cliente aprobó la cotización Nº %d?';
  SConfirmarClienteRechazo = '¿Registrar que el cliente rechazó la cotización Nº %d?';
  SAccionRegistrarRespuesta = 'registrar la respuesta del cliente';
  SAgregarMaterial = 'Agregar material';
  SAgregarManoObra = 'Agregar mano de obra';
  SAgregarMaquina = 'Agregar máquina';
  SAgregarNota = 'Agregar nota';
  SEditarLinea = 'Editar línea';
  SEditarNota = 'Editar nota';
  SBotonAgregarLinea = 'Agregar línea';
  SBotonGuardarCambio = 'Guardar cambio';
  SBotonAplicarAjuste = 'Aplicar ajuste';
  SEscojaItem = 'Escoja un elemento de la lista.';
  SNotaVacia = 'Escriba el texto de la nota.';
  SPrecioSeCopia = 'El precio se copia a la línea: si después cambia en el ' +
    'catálogo, esta cotización conserva el suyo.';
  SPrecioConservado = 'El precio es el que se copió al agregar la línea; no ' +
    'se vuelve a leer del catálogo.';
  SAjusteTitulo = 'Ajuste de la cotización';
  SAjusteAyuda = 'Vista previa; el total definitivo lo calcula el servidor. ' +
    'El ajuste y su motivo quedan en la auditoría.';
  SRecargo = 'Recargo %s %%';
  SDescuento = 'Descuento %s %%';
  SCargandoCotizaciones = 'Cargando cotizaciones...';
  SSinCotizaciones = 'No hay cotizaciones con ese filtro';
  SPaginacionCotizaciones = '%d cotizaciones · página %d de %d';
  SFiltroTodas = 'Todas';
  SFiltroBorrador = 'Borrador';
  SFiltroPendiente = 'Pendientes';
  SFiltroAprobada = 'Aprobadas';
  SFiltroEnviada = 'Enviadas';
  SFiltroRechazada = 'Rechazadas';

implementation

end.
