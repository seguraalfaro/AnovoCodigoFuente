B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Textos para la persona, iguales a los del escritorio (Anovo.Textos). Las subs arman los que
' llevan datos y van agrupadas por pantalla.

Sub Process_Globals
	Public Const TITULO As String = "Anovo"
	Public Const SIN_CONEXION As String = "No se pudo conectar con el servidor de Anovo. Revise la red o avise al administrador."
	Public Const CERTIFICADO_INVALIDO As String = "No se pudo verificar el certificado del servidor de Anovo. Avise al administrador."
	Public Const SESION_VENCIDA As String = "Su sesión venció. Vuelva a ingresar."
	Public Const CREDENCIALES_INVALIDAS As String = "El correo o la clave no son correctos."
	Public Const FALTAN_CREDENCIALES As String = "Escriba su correo y su clave."
	Public Const DEMASIADAS_PETICIONES As String = "Se hicieron demasiadas consultas en poco tiempo. Espere un minuto e intente de nuevo."
	Public Const TOKEN_INVALIDO As String = "El servidor devolvió un token con formato inválido."
	Public Const URL_VACIA As String = "Escriba la dirección del servidor."
	Public Const URL_SIN_HTTPS As String = "La dirección del servidor debe empezar por https://"
	Public Const SIN_ACCESO_MOVIL As String = "Su usuario no usa la aplicación móvil."
	Public Const CLAVE_TEMPORAL As String = "Su clave es temporal. Cámbiela en la aplicación de escritorio y vuelva a ingresar."
	Public Const TITULO_SERVIDOR As String = "Dirección del servidor"
	Public Const SERVIDOR_EN As String = "Servidor: "
	Public Const SERVIDOR_SIN_CONFIGURAR As String = "Configurar el servidor"
	Public Const GUARDAR As String = "Guardar"
	Public Const CANCELAR As String = "Cancelar"
	Public Const SIGUIENTE As String = "Siguiente"
	Public Const QUITAR As String = "Quitar"
	Public Const BORRAR As String = "Borrar"
	Public Const NOTA As String = "Nota"
	Public Const NOTA_CROQUIS As String = "Nota del croquis"
	Public Const ROTULO_TIPO_MEDIDA As String = "Tipo de medida"
	Public Const ROTULO_VALOR As String = "Valor"
	Public Const ROTULO_CANTIDAD_IGUALES As String = "Cantidad de piezas iguales"
	Public Const FALTA_VALOR_MEDIDA As String = "Escriba el valor de la medida."
	Private Const TITULO_MEDIDA As String = "Medida $1"
	Public Const SI As String = "Sí"
	Public Const NO As String = "No"
	Public Const TITULO_CLIENTE As String = "Agregar cliente"
	Public Const AYUDA_DIRECCION As String = "Dirección: provincia, cantón y distrito"
	Public Const RETOMAR_CLIENTE As String = "Tiene un cliente sin terminar. ¿Desea retomarlo?"
	Public Const CAMPOS_INCOMPLETOS As String = "Complete los campos marcados en rojo."
	Public Const SIN_CONTACTOS As String = "Agregue al menos un contacto."
	Public Const FALTA_ACEPTAR As String = "Falta marcar que el cliente acepta el tratamiento de sus datos."
	Public Const FALTA_FIRMA As String = "Falta la firma del cliente."
	Public Const FALTA_FIRMANTE As String = "Escoja quién firma el consentimiento."
	Public Const FALTA_CEDULA_FIRMANTE As String = "Falta la cédula o el DIMEX de quien firma."
	Public Const DESCARTAR_CLIENTE As String = "¿Descartar este cliente? Se pierden los datos, los contactos y la firma."
	Public Const SIN_TEXTO_PERMISO As String = "El texto del permiso todavía no llegó a este teléfono. Sincronice con el servidor antes de registrar al cliente."
	Private Const VERSION_TEXTO_PERMISO As String = "Versión del texto: $1"
	Private Const CLIENTE_REPETIDO As String = "Ya existe un cliente con el nombre «$1». Búsquelo en la lista en lugar de registrarlo otra vez."
	Private Const IDENTIFICACION_REPETIDA As String = "La identificación $1 ya es del cliente «$2». Búsquelo en la lista en lugar de registrarlo otra vez."
	Public Const CLIENTE_NO_GUARDADO As String = "No se pudo guardar el cliente en el teléfono. Intente de nuevo."
	Public Const CLIENTE_GUARDADO As String = "Cliente guardado."
	Public Const MENU_SINCRONIZAR As String = "Sincronizar"
	Public Const SYNC_TITULO As String = "Anovo: sincronización"
	Public Const SYNC_SUBIENDO As String = "Subiendo lo capturado en el teléfono…"
	Public Const SYNC_LISTO As String = "Todo lo capturado quedó en el servidor."
	Public Const SYNC_CON_ERRORES As String = "Algunos registros no se pudieron subir: revíselos en Inicio."
	Public Const SYNC_SIN_CONEXION As String = "Sin conexión con el servidor. Se reintenta más tarde."
	Public Const SYNC_SESION As String = "La sesión venció. Ingrese de nuevo para terminar de subir."
	Public Const BASE_NO_PREPARADA As String = "No se pudo preparar la base de datos del teléfono. Cierre la aplicación y vuelva a abrirla; si sigue igual, avise a soporte."
	Private Const BASE_INCOMPLETA As String = "La base de datos del teléfono está incompleta (faltan: $1). Avise a soporte."
	Public Const SYNC_CONFLICTO As String = "Alguien cambió este registro en el servidor. Revíselo en el escritorio."
	Public Const SYNC_BAJADA_FALLO As String = "Lo capturado subió, pero no se pudo traer lo nuevo del servidor. Se reintenta más tarde."
	Public Const SYNC_OCUPADO As String = "El servidor está ocupado. La sincronización se reintenta más tarde."
	Public Const MENU_CERRAR_SESION As String = "Cerrar sesión"
	Public Const TAB_INICIO As String = "Inicio"
	Public Const TAB_CLIENTES As String = "Clientes"
	Public Const TAB_NUEVA As String = "Nueva"
	Public Const TAB_SOLICITUDES As String = "Solicitudes"
	Public Const MIS_SOLICITUDES As String = "Mis solicitudes"
	Public Const FILTRO_MES As String = "Este mes"
	Public Const FILTRO_TODAS As String = "Todas"
	Public Const FILTRO_FECHAS As String = "Fechas…"
	Public Const FECHA_DESDE As String = "Desde"
	Public Const FECHA_HASTA As String = "Hasta"
	Public Const ELEGIR As String = "Elegir"
	Public Const PERIODO_INVERTIDO As String = "La fecha de inicio es posterior a la del fin."
	Public Const SIN_SOLICITUDES_FILTRO As String = "No hay solicitudes con estos filtros."
	Private Const TEXTO_RANGO As String = "$1 – $2"
	Public Const SIN_SOLICITUDES_MES As String = "No hay solicitudes este mes."
	Public Const SIN_SOLICITUDES As String = "Todavía no hay solicitudes."
	Public Const SEG_POR_SUBIR As String = "Por subir"
	Public Const SEG_ESPERANDO As String = "Esperando cotización"
	Public Const SEG_ELABORACION As String = "En elaboración"
	Public Const SEG_ENVIADA As String = "Enviada al cliente"
	Public Const SEG_APROBADA As String = "Aprobada"
	Public Const SEG_RECHAZADA As String = "Rechazada"
	Private Const EST_CAPTURADA As String = "Capturada"
	Private Const EST_RECIBIDA As String = "Recibida"
	Private Const EST_EN_COTIZACION As String = "En cotización"
	Private Const EST_DESCARTADA As String = "Descartada"
	Private Const EST_BORRADOR As String = "Borrador"
	Private Const EST_PENDIENTE As String = "Enviada a revisión"
	Private Const EST_DEVUELTA As String = "Devuelta"
	Private Const EST_VISTO_BUENO As String = "Con visto bueno"
	Private Const EST_APROBADA As String = "Aprobada"
	Private Const EST_RECHAZADA As String = "Rechazada"
	Private Const EST_ENVIADA As String = "Enviada al cliente"
	Public Const TAB_PERFIL As String = "Perfil"
	Public Const SIN_CLIENTES_TITULO As String = "Sin clientes"
	Public Const SIN_CLIENTES_TEXTO As String = "Todavía no hay clientes registrados."
	Public Const TITULO_COTIZACION As String = "Nueva cotización"
	Public Const GUARDAR_COTIZACION As String = "Guardar cotización"
	Public Const AYUDA_OBSERVACIONES As String = "Observaciones del proyecto"
	Public Const RETOMAR_COTIZACION As String = "Tiene una cotización sin terminar. ¿Desea retomarla?"
	Public Const RETOMAR_PIEZA As String = "Hay una pieza sin terminar. ¿Desea retomarla?"
	Public Const RETOMAR_PIEZA_NOMBRE As String = "La pieza «$1» quedó sin terminar. ¿Desea retomarla?"
	Public Const INICIO_RETOMAR_TITULO As String = "Cotización sin terminar"
	Public Const INICIO_RETOMAR_VACIA As String = "Todavía sin cliente ni piezas"
	Public Const INICIO_RETOMAR As String = "Retomar"
	Public Const INICIO_DESCARTAR As String = "Descartar"
	Public Const INICIO_CONFIRMAR_DESCARTE As String = "¿Descartar la cotización sin terminar? Se pierden sus piezas y fotos."
	Public Const INICIO_ULTIMAS As String = "Mis últimas solicitudes"
	Public Const INICIO_SIN_RECIENTES As String = "No hay solicitudes de los últimos 7 días."
	Public Const KPI_SIN_DATO As String = "—"
	Public Const SYNC_AL_DIA As String = "Todo está en el servidor"
	Public Const SYNC_REINTENTAR As String = "Reintentar"
	Public Const TITULO_CLIENTE As String = "Cliente"
	Public Const NUEVA_SOLICITUD As String = "+  Nueva solicitud"
	Public Const ROTULO_TELEFONO As String = "Teléfono"
	Public Const SYNC_PANTALLA As String = "Sincronización"
	Public Const SYNC_EN_LINEA As String = "● En línea"
	Public Const SYNC_FUERA_DE_LINEA As String = "○ Sin conexión"
	Public Const SYNC_NUNCA As String = "Todavía no"
	Public Const SYNC_ULTIMA_EXITOSA As String = "Última exitosa"
	Public Const SYNC_ACTUALIZADO As String = "Actualizado"
	Public Const SYNC_POR_SUBIR_TITULO As String = "Por subir"
	Public Const SYNC_CLIENTES As String = "Clientes"
	Public Const SYNC_SOLICITUDES As String = "Solicitudes"
	Public Const SYNC_HISTORIAL As String = "Historial"
	Public Const SYNC_SIN_HISTORIAL As String = "Todavía no hay intentos de sincronización."
	Public Const SYNC_TODO_AL_DIA As String = "✓  Todo lo capturado está en el servidor"
	Public Const SYNC_AHORA As String = "Sincronizar ahora"
	Public Const SYNC_SINCRONIZANDO As String = "Sincronizando..."
	Public Const UBICACION_BUSCANDO As String = "Buscando la ubicación del cliente..."
	Public Const UBICACION_SIN As String = "Sin ubicación: no hay permiso o señal."
	Public Const REVISION_TITULO As String = "Revisión final"
	Public Const REVISION_SUBTITULO As String = "Revise antes de guardar. Queda en el teléfono y sube al sincronizar."
	Public Const REVISION_CLIENTE As String = "Cliente y proyecto"
	Public Const REVISION_CAMBIAR As String = "Cambiar ›"
	Public Const ROTULO_CLIENTE As String = "Cliente"
	Public Const ROTULO_CONTACTO As String = "Contacto"
	Public Const ROTULO_PROYECTO As String = "Proyecto"
	Public Const ROTULO_UBICACION As String = "Ubicación"
	Public Const REVISION_RESUMEN As String = "Resumen"
	Public Const RESUMEN_PIEZAS As String = "Piezas"
	Public Const RESUMEN_MEDIDAS As String = "Medidas"
	Public Const RESUMEN_FOTOS As String = "Fotos"
	Public Const RESUMEN_CROQUIS As String = "Croquis"
	Public Const OBSERVACIONES_OPCIONAL As String = "Observaciones (opcional)"
	Public Const ROTULO_DIRECCION As String = "Dirección"
	Public Const ROTULO_COBROS As String = "Cobros"
	Public Const FICHA_SIN_CONTACTOS As String = "Sin contactos registrados"
	Public Const FICHA_PRINCIPAL As String = "Principal"
	Public Const FICHA_PERMISO As String = "Permiso de datos (Ley 8968)"
	Public Const MIS_CLIENTES As String = "Mis clientes"
	Public Const DESBLOQUEO_TITULO As String = "Entrar a Anovo"
	Public Const PERFIL_MI_CUENTA As String = "Mi cuenta"
	Public Const PERFIL_CONEXION As String = "Conexión"
	Public Const PERFIL_ACERCA_DE As String = "Acerca de"
	Public Const ROTULO_PERMISOS As String = "Permisos propios"
	Public Const ROTULO_CLAVE As String = "Clave cambiada"
	Public Const ROTULO_SERVIDOR As String = "Servidor"
	Public Const ROTULO_ESTADO As String = "Estado"
	Public Const ROTULO_RESPUESTA As String = "Respuesta"
	Public Const ROTULO_APP As String = "App instalada"
	Public Const ROTULO_MOVIL_DISPONIBLE As String = "Móvil disponible"
	Public Const ROTULO_BASE As String = "Base de datos"
	Public Const ROTULO_AVISO As String = "Aviso de privacidad"
	Public Const CAMBIAR_MI_CLAVE As String = "Cambiar mi clave"
	Public Const PROBAR_CONEXION As String = "Probar conexión"
	Public Const PROBANDO As String = "Probando..."
	Public Const CONECTADO As String = "Conectado"
	Public Const SIN_RESPUESTA As String = "Sin respuesta"
	Public Const CLAVE_ACTUAL As String = "Clave actual"
	Public Const CLAVE_NUEVA As String = "Clave nueva"
	Public Const CLAVE_REPETIR As String = "Repetir clave nueva"
	Public Const FALTA_CLAVE_ACTUAL As String = "Escriba su clave actual."
	Public Const CLAVE_SIN_LETRAS_NUMEROS As String = "La clave nueva debe tener letras y números."
	Public Const CLAVE_NO_COINCIDE As String = "La clave nueva y su repetición no coinciden."
	Public Const CLAVE_IGUAL As String = "La clave nueva debe ser distinta de la actual."
	Public Const CLAVE_SIN_CONEXION As String = "Para cambiar la clave se necesita conexión con el servidor."
	Public Const CLAVE_CAMBIADA As String = "Su clave quedó cambiada."
	Public Const TELEFONO_NO_REGISTRADO As String = "Este teléfono no quedó registrado en el servidor. Podrá trabajar, pero al vencer la sesión tendrá que ingresar de nuevo con su clave."
	Public Const CLAVE_CAMBIADA_REINGRESO As String = "Su clave quedó cambiada. Vuelva a ingresar con la clave nueva."
	Public Const DESBLOQUEO_ENTRAR As String = "Entrar con huella o PIN"
	Public Const DESBLOQUEO_ACTIVAR As String = "Confirme que es usted para activar el ingreso sin conexión"
	Public Const PERFIL_SIN_CONEXION_TITULO As String = "Entrar sin conexión"
	Public Const PERFIL_SIN_CONEXION_TEXTO As String = "Con esto activado, la app se abre con su huella o el PIN del teléfono aunque no haya internet. Deja de servir si pasan 30 días sin conectarse."
	Public Const PERFIL_SIN_REGISTRO As String = "Ingrese una vez con conexión para registrar este teléfono."
	Public Const PERFIL_SIN_BLOQUEO As String = "El teléfono no tiene huella ni bloqueo de pantalla. Configure uno en Ajustes, Seguridad."
	Public Const PERFIL_NO_SOPORTADO As String = "Este teléfono no permite entrar con huella o PIN."
	Public Const CONFIRMAR_CIERRE As String = "¿Cerrar la sesión en este teléfono? Lo que falte por subir queda guardado y sube cuando vuelva a ingresar."
	Public Const SIN_PIEZAS As String = "Agregue al menos una pieza."
	Public Const SIN_PIEZAS_TITULO As String = "Todavía no hay piezas"
	Public Const SIN_PIEZAS_TEXTO As String = "Toque «Nueva pieza» para registrar la primera. Cada pieza lleva medidas, cantidad, croquis y fotos."
	Public Const PIEZA_SIN_ADJUNTOS As String = "Sin croquis ni fotos"
	Public Const PIEZA_SIN_CROQUIS As String = "Sin croquis"
	Public Const PIEZA_SIN_FOTOS As String = "Sin fotos"
	Public Const SIN_RESULTADOS As String = "No hay coincidencias."
	Public Const FALTA_CLIENTE As String = "Elija el cliente."
	Public Const FALTA_CONTACTO As String = "Elija el contacto del proyecto."
	Public Const SIN_MEDIDAS As String = "Las cotas que dibuje en el croquis aparecen aquí."
	Public Const TITULO_PIEZA As String = "Agregar pieza"
	Public Const TITULO_EDITAR_PIEZA As String = "Editar pieza"
	Public Const DESCARTAR_CAMBIOS_PIEZA As String = "¿Descartar los cambios de esta pieza? La pieza queda como estaba."
	Public Const SOLICITUD_GUARDADA As String = "Solicitud guardada en el teléfono. Se enviará a Anovo al sincronizar."
	Public Const SOLICITUD_NO_GUARDADA As String = "No se pudo guardar la solicitud en el teléfono. Intente de nuevo."
	Public Const FALTA_NOMBRE_PIEZA As String = "Escriba el nombre de la pieza."
	Public Const FALTA_TIPO_TRABAJO As String = "Elija el tipo de trabajo."
	Public Const FALTA_MATERIAL As String = "Elija el tipo de material."
	Public Const FALTA_ACABADO As String = "Elija el acabado."
	Public Const FOTOS_MAXIMO As String = "Llegó al máximo de fotos para esta pieza."
	Public Const ELEGIR_FOTO As String = "Elegir foto"
	Public Const FOTO_NO_VALIDA As String = "No se pudo leer la imagen elegida. Elija otra."
	Public Const FOTO_NO_GUARDADA As String = "No se pudo guardar la foto en el teléfono. Intente de nuevo."
	Private Const FOTO_CHICA As String = "La foto mide $1×$2. Se necesita al menos 800×600 para que se vean los detalles."
	Public Const DESCARTAR_PIEZA As String = "¿Descartar esta pieza? Se pierden los datos, el croquis y las fotos."
	Public Const MEDIDA_SIN_VALOR As String = "Sin valor: toque para llenarla"
	Private Const MEDIDA_CANTIDAD As String = " · cant. $1"
	Public Const CONFIRMAR As String = "Confirmar"
	Public Const REINTENTAR As String = "Reintentar"
	Public Const ABRIR_AJUSTES As String = "Abrir ajustes"
	Public Const PERMITIR_CAMARA As String = "Permitir cámara"
	Public Const BORRAR_CROQUIS As String = "¿Borrar todo el croquis?"
	Public Const SIN_AJUSTES As String = "No se pudieron abrir los ajustes de la aplicación."
	Public Const CAMARA_SIN_EQUIPO As String = "Este equipo no tiene cámara"
	Public Const CAMARA_BLOQUEADA As String = "Permiso bloqueado"
	Public Const CAMARA_BLOQUEADA_TEXTO As String = "El permiso de cámara está bloqueado. Puede activarlo en los ajustes del sistema."
	Public Const CAMARA_FALLO As String = "No se pudo abrir la cámara"
	Public Const CAMARA_FALLO_TEXTO As String = "Puede que otra aplicación la esté usando. Ciérrela e intente de nuevo."
	Public Const CAMARA_NO_DISPONIBLE As String = "Cámara no disponible"
	Public Const CAMARA_SEGUIR As String = "Puede seguir usando el croquis y adjuntar fotografías desde la galería."
	Public Const CROQUIS_HERRAMIENTAS As String = "HERRAMIENTAS"
	Public Const CROQUIS_PUNTOS As String = "Puntos"
	Public Const CROQUIS_LINEA As String = "Línea recta"
	Public Const CROQUIS_AGUJERO As String = "Agujero"
	Public Const CROQUIS_CIRCULO As String = "Círculo"
	Public Const CROQUIS_ARCO As String = "Arco"
	Public Const CROQUIS_TEXTO As String = "Texto"
	Public Const CROQUIS_ABERTURA As String = "Marcar abertura"
	Public Const CROQUIS_MEDIDAS As String = "MEDIDAS"
	Public Const CROQUIS_COTA As String = "Cota"
	Public Const CROQUIS_ANGULO As String = "Ángulo"
	Public Const CROQUIS_FIGURA As String = "FIGURA"
	Public Const CROQUIS_TERMINAR As String = "Terminar figura"
	Public Const CROQUIS_CERRAR As String = "Cerrar figura"
	Public Const CROQUIS_DESCARTAR As String = "Descartar figura"
	Public Const CROQUIS_VISTA As String = "VISTA"
	Public Const CROQUIS_REJILLA As String = "Rejilla"
	Public Const CROQUIS_REJILLA_CUADRADA As String = "Rejilla cuadrada"
	Public Const CROQUIS_IMAN As String = "Imán"
	Public Const CROQUIS_ROTULOS As String = "Medidas"
	Public Const CROQUIS_LIMPIAR As String = "Limpiar todo"
	Private Const CROQUIS_LLENAR As String = "Llenar medidas ($1)"
	Private Const CROQUIS_CARA As String = "Cara: $1"
	Private Const CROQUIS_TRAZO As String = "Trazo: $1"
	Private Const ERROR_SERVIDOR As String = "El servidor respondió con un error ($1)."
	Private Const PIEZA_MEDIDAS As String = "$1 medidas"
	Private Const PIEZA_ADJUNTOS As String = "Croquis · $1 fotos"
	Private Const INICIO_SALUDO As String = "Hola"
	Private Const INICIO_SALUDO_NOMBRE As String = "Hola, $1"
	Private Const SYNC_POR_SUBIR_UNO As String = "1 registro por subir"
	Private Const SYNC_POR_SUBIR As String = "$1 registros por subir"
	Private Const SYNC_CON_ERROR_UNO As String = "1 registro con error"
	Private Const SYNC_CON_ERROR As String = "$1 registros con error"
	Private Const PIEZAS_UNA As String = "1 pieza"
	Private Const PIEZAS_VARIAS As String = "$1 piezas"
	Private Const FICHA_CONTACTOS As String = "Contactos ($1)"
	Private Const CLIENTES_UNO As String = "1 cliente"
	Private Const SYNC_ERRORES As String = "Con error ($1)"
	Private Const SYNC_ERROR_CLIENTE As String = "Cliente · $1"
	Private Const SYNC_ERROR_SOLICITUD As String = "Solicitud · $1"
	Private Const SYNC_ERROR_FOTO As String = "Foto · $1"
	Private Const RESULTADO_EXITOSA As String = "Exitosa"
	Private Const RESULTADO_PARCIAL As String = "Parcial"
	Private Const RESULTADO_SIN_CONEXION As String = "Sin conexión"
	Private Const RESULTADO_SESION As String = "Sesión vencida"
	Private Const INTENTO_SUBIDOS As String = "$1 subidos"
	Private Const INTENTO_BAJADOS As String = "$1 actualizados"
	Private Const INTENTO_ERRORES As String = "$1 con error"
	Private Const INTENTO_PENDIENTES As String = "$1 pendientes"
	Private Const UBICACION_CAPTURADA As String = "Ubicación capturada (± $1 m)"
	Private Const UBICACION_COORDENADAS As String = "$1, $2"
	Private Const TEXTO_CONTADOR As String = "$1/$2"
	Private Const DESBLOQUEO_ACTIVADO As String = "Activado"
	Private Const PERMISOS_SOLO_ROL As String = "Solo los del rol"
	Private Const PERMISOS_PROPIOS As String = "$1 adicionales · $2 quitados"
	Private Const TEXTO_MILISEGUNDOS As String = "$1 ms"
	Private Const CLAVE_CORTA As String = "Mínimo $1 caracteres, con letras y números."
	Private Const DESBLOQUEO_DESACTIVADO As String = "Desactivado"
	Private Const DESBLOQUEO_ACCION_ACTIVAR As String = "Activar"
	Private Const DESBLOQUEO_ACCION_DESACTIVAR As String = "Desactivar"
	Private Const CLIENTES_VARIOS As String = "$1 clientes"
	Private Const PASTILLA_SUBIDO As String = "✓ Subido"
	Private Const PASTILLA_POR_SUBIR As String = "↑ Por subir"
	Private Const PASTILLA_ERROR As String = "! Con error"
	Private Const PASTILLA_SUBIDA As String = "✓ Subida"
	Private Const PERMISO_OTORGADO As String = "Otorgado por $1"
	Private Const PERMISO_REVOCADO As String = "Revocado por $1"
	Private Const PERMISO_SIN_FIRMANTE As String = "Otorgado"
	Private Const PERMISO_NINGUNO As String = "Sin permiso registrado"
	Private Const PERMISO_DETALLE As String = "$1 · texto $2"
End Sub

#Region Generales
Public Sub ErrorServidor (Codigo As Int) As String
	Return ERROR_SERVIDOR.Replace("$1", Codigo)
End Sub
#End Region

#Region Ingreso y perfil
Public Sub EstadoDesbloqueo (Activo As Boolean) As String
	If Activo Then Return DESBLOQUEO_ACTIVADO
	Return DESBLOQUEO_DESACTIVADO
End Sub

Public Sub AccionDesbloqueo (Activo As Boolean) As String
	If Activo Then Return DESBLOQUEO_ACCION_DESACTIVAR
	Return DESBLOQUEO_ACCION_ACTIVAR
End Sub

Public Sub NombreDeRol (Codigo As String) As String
	Select Codigo
		Case "asesor"
			Return "Asesor comercial"
		Case "asistente"
			Return "Asistente de cotizaciones"
		Case "supervisor"
			Return "Supervisor"
		Case "gerencia"
			Return "Gerencia"
		Case "admin"
			Return "Administrador del sistema"
		Case Else
			Return "Sin rol"
	End Select
End Sub

Public Sub PermisosPropios (Adicionales As Int, Quitados As Int) As String
	If Adicionales = 0 And Quitados = 0 Then Return PERMISOS_SOLO_ROL
	Return PERMISOS_PROPIOS.Replace("$1", Adicionales).Replace("$2", Quitados)
End Sub

Public Sub Milisegundos (Cantidad As Long) As String
	Return TEXTO_MILISEGUNDOS.Replace("$1", Cantidad)
End Sub

Public Sub ClaveCorta (Largo As Int) As String
	Return CLAVE_CORTA.Replace("$1", Largo)
End Sub
#End Region

#Region Inicio
Public Sub Saludo (Nombre As String) As String
	If Nombre = "" Then Return INICIO_SALUDO
	Return INICIO_SALUDO_NOMBRE.Replace("$1", Nombre)
End Sub

Public Sub TextoEstado (Estado As String) As String
	Select Estado
		Case DbSeguimiento.ESTADO_POR_SUBIR: Return SEG_POR_SUBIR
		Case DbSeguimiento.ESTADO_CAPTURADA: Return EST_CAPTURADA
		Case DbSeguimiento.ESTADO_RECIBIDA: Return EST_RECIBIDA
		Case DbSeguimiento.ESTADO_EN_COTIZACION: Return EST_EN_COTIZACION
		Case DbSeguimiento.ESTADO_DESCARTADA: Return EST_DESCARTADA
		Case DbSeguimiento.ESTADO_BORRADOR: Return EST_BORRADOR
		Case DbSeguimiento.ESTADO_PENDIENTE: Return EST_PENDIENTE
		Case DbSeguimiento.ESTADO_DEVUELTA: Return EST_DEVUELTA
		Case DbSeguimiento.ESTADO_VISTO_BUENO: Return EST_VISTO_BUENO
		Case DbSeguimiento.ESTADO_APROBADA: Return EST_APROBADA
		Case DbSeguimiento.ESTADO_RECHAZADA: Return EST_RECHAZADA
		Case DbSeguimiento.ESTADO_ENVIADA: Return EST_ENVIADA
	End Select
	Return Estado
End Sub

Public Sub EstadoSolicitud (Estado As String) As String
	Select Estado
		Case DbSync.ESTADO_ERROR
			Return PASTILLA_ERROR
		Case DbSync.ESTADO_PENDIENTE
			Return PASTILLA_POR_SUBIR
		Case Else
			Return PASTILLA_SUBIDA
	End Select
End Sub

Public Sub KpisAsesor As List
	Return Array("Solicitudes del mes", "Esperando cotización", "Aprobadas del mes", "Monto aprobado")
End Sub
#End Region

#Region Clientes
Public Sub UbicacionCapturada (Metros As Int) As String
	Return UBICACION_CAPTURADA.Replace("$1", Metros)
End Sub

Public Sub CuentaClientes (Cantidad As Int) As String
	If Cantidad = 1 Then Return CLIENTES_UNO
	Return CLIENTES_VARIOS.Replace("$1", Cantidad)
End Sub

Public Sub PastillaCliente (Estado As String) As String
	Select Estado
		Case DbSync.ESTADO_ERROR
			Return PASTILLA_ERROR
		Case DbSync.ESTADO_PENDIENTE
			Return PASTILLA_POR_SUBIR
		Case Else
			Return PASTILLA_SUBIDO
	End Select
End Sub

Public Sub TipoCorto (Indice As Int) As String
	Select Indice
		Case 0
			Return "Física"
		Case 1
			Return "Jurídica"
		Case 2
			Return "DIMEX"
		Case Else
			Return ""
	End Select
End Sub

Public Sub FichaContactos (Cantidad As Int) As String
	Return FICHA_CONTACTOS.Replace("$1", Cantidad)
End Sub

Public Sub TextoPermiso (Accion As String, Firmante As String) As String
	If Accion = "" Then Return PERMISO_NINGUNO
	If Accion = "revocado" Then Return PERMISO_REVOCADO.Replace("$1", Firmante)
	If Firmante = "" Then Return PERMISO_SIN_FIRMANTE
	Return PERMISO_OTORGADO.Replace("$1", Firmante)
End Sub

Public Sub FotoChica (Ancho As Int, Alto As Int) As String
	Return FOTO_CHICA.Replace("$1", Ancho).Replace("$2", Alto)
End Sub

Public Sub TextoRango (Desde As String, Hasta As String) As String
	Return TEXTO_RANGO.Replace("$1", Desde).Replace("$2", Hasta)
End Sub

Public Sub ClienteRepetido (Nombre As String) As String
	Return CLIENTE_REPETIDO.Replace("$1", Nombre)
End Sub

Public Sub IdentificacionRepetida (Numero As String, Dueno As String) As String
	Return IDENTIFICACION_REPETIDA.Replace("$1", Numero).Replace("$2", Dueno)
End Sub

Public Sub VersionTextoPermiso (Version As String) As String
	Return VERSION_TEXTO_PERMISO.Replace("$1", Version)
End Sub

Public Sub PermisoDetalle (Fecha As String, Version As String) As String
	Return PERMISO_DETALLE.Replace("$1", Fecha).Replace("$2", Version)
End Sub
#End Region

#Region Solicitud y piezas
Public Sub PiezaMedidas (Cantidad As Int) As String
	Return PIEZA_MEDIDAS.Replace("$1", Cantidad)
End Sub

Public Sub TiposMedida As List
	Return Array As String("Largo", "Ancho", "Alto", "Profundidad", "Diámetro", "Radio", "Espesor", "Ángulo")
End Sub

Public Sub RetomarPieza (Nombre As String) As String
	If Nombre.Trim = "" Then Return RETOMAR_PIEZA
	Return RETOMAR_PIEZA_NOMBRE.Replace("$1", Nombre.Trim)
End Sub

Public Sub TituloMedida (Etiqueta As String) As String
	Return TITULO_MEDIDA.Replace("$1", Etiqueta)
End Sub

Public Sub DetalleMedida (Valor As Double, Unidad As String, Cantidad As Int) As String
	Dim texto As String = NumberFormat2(Valor, 1, 2, 0, False) & " " & Unidad
	If Cantidad > 1 Then texto = texto & MEDIDA_CANTIDAD.Replace("$1", Cantidad)
	Return texto
End Sub

Public Sub PiezaAdjuntos (Fotos As Int) As String
	Return PIEZA_ADJUNTOS.Replace("$1", Fotos)
End Sub

Public Sub CuentaPiezas (Cantidad As Int) As String
	If Cantidad = 1 Then Return PIEZAS_UNA
	Return PIEZAS_VARIAS.Replace("$1", Cantidad)
End Sub
#End Region

#Region Croquis
Public Sub NombrePlano (Indice As Int) As String
	Dim nombres() As String = Array As String("automática", "arriba", "izquierda", "derecha", "de frente")
	Return nombres(Indice)
End Sub

Public Sub NombreGrosor (Indice As Int) As String
	Dim nombres() As String = Array As String("Fino", "Medio", "Grueso")
	Return nombres(Indice)
End Sub

Public Sub CroquisLlenar (Faltan As Int) As String
	Return CROQUIS_LLENAR.Replace("$1", Faltan)
End Sub

Public Sub CroquisCara (IndicePlano As Int) As String
	Return CROQUIS_CARA.Replace("$1", NombrePlano(IndicePlano))
End Sub

Public Sub CroquisTrazo (IndiceGrosor As Int) As String
	Return CROQUIS_TRAZO.Replace("$1", NombreGrosor(IndiceGrosor))
End Sub
#End Region

#Region Sincronización
Public Sub SyncPorSubir (Cantidad As Int) As String
	If Cantidad = 1 Then Return SYNC_POR_SUBIR_UNO
	Return SYNC_POR_SUBIR.Replace("$1", Cantidad)
End Sub

Public Sub SyncConError (Cantidad As Int) As String
	If Cantidad = 1 Then Return SYNC_CON_ERROR_UNO
	Return SYNC_CON_ERROR.Replace("$1", Cantidad)
End Sub

Public Sub SyncErrores (Cantidad As Int) As String
	Return SYNC_ERRORES.Replace("$1", Cantidad)
End Sub

Public Sub TituloErrorSync (Entidad As String, Asunto As String) As String
	Select Entidad
		Case "cliente"
			Return SYNC_ERROR_CLIENTE.Replace("$1", Asunto)
		Case "solicitud"
			Return SYNC_ERROR_SOLICITUD.Replace("$1", Asunto)
		Case Else
			Return SYNC_ERROR_FOTO.Replace("$1", Asunto)
	End Select
End Sub

Public Sub ResultadoSync (Resultado As String) As String
	Select Resultado
		Case DbSync.RESULTADO_EXITOSA
			Return RESULTADO_EXITOSA
		Case DbSync.RESULTADO_PARCIAL
			Return RESULTADO_PARCIAL
		Case DbSync.RESULTADO_SESION
			Return RESULTADO_SESION
		Case Else
			Return RESULTADO_SIN_CONEXION
	End Select
End Sub

Public Sub SyncAlDia (Hora As String) As String
	If Hora = "" Then Return SYNC_AL_DIA
	Return SYNC_AL_DIA & " · actualizado " & Hora
End Sub

Public Sub DetalleIntento (Subidos As Int, Bajados As Int, ConError As Int, Pendientes As Int) As String
	Dim partes As List
	partes.Initialize
	partes.Add(INTENTO_SUBIDOS.Replace("$1", Subidos))
	If Bajados > 0 Then partes.Add(INTENTO_BAJADOS.Replace("$1", Bajados))
	If ConError > 0 Then partes.Add(INTENTO_ERRORES.Replace("$1", ConError))
	If Pendientes > 0 Then partes.Add(INTENTO_PENDIENTES.Replace("$1", Pendientes))
	Dim sb As StringBuilder
	sb.Initialize
	For Each p As String In partes
		If sb.Length > 0 Then sb.Append(" · ")
		sb.Append(p)
	Next
	Return sb.ToString
End Sub
#End Region

#Region Formatos
Public Sub Coordenadas (u As UbicacionGps) As String
	If u.Ok = False Then Return UBICACION_SIN
	Return UBICACION_COORDENADAS.Replace("$1", NumberFormat2(u.Latitud, 1, 5, 5, False)).Replace("$2", NumberFormat2(u.Longitud, 1, 5, 5, False))
End Sub

Public Sub Contador (Cantidad As Int, Maximo As Int) As String
	Return TEXTO_CONTADOR.Replace("$1", Cantidad).Replace("$2", Maximo)
End Sub

Public Sub BaseIncompleta (Faltan As List) As String
	Dim sb As StringBuilder
	sb.Initialize
	For Each t As String In Faltan
		If sb.Length > 0 Then sb.Append(", ")
		sb.Append(t)
	Next
	Return BASE_INCOMPLETA.Replace("$1", sb.ToString)
End Sub

Public Sub ConDetalles (Mensaje As String, Detalles As List) As String
	If Detalles.IsInitialized = False Or Detalles.Size < 2 Then Return Mensaje
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append(Mensaje)
	For Each d As String In Detalles
		sb.Append(CRLF).Append("• ").Append(d)
	Next
	Return sb.ToString
End Sub

Public Sub Colones (Monto As Double) As String
	Return "₡ " & NumberFormat2(Monto, 1, 0, 0, True)
End Sub
#End Region
