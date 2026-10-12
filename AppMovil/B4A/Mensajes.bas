B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Textos para la persona, iguales a los del escritorio (Anovo.Textos).
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
	Public Const ROTULO_SERVIDOR As String = "Servidor: "
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
	Public Const CLIENTE_NO_GUARDADO As String = "No se pudo guardar el cliente en el teléfono. Intente de nuevo."
	Public Const CLIENTE_GUARDADO As String = "Cliente guardado."
	Public Const MENU_SINCRONIZAR As String = "Sincronizar"
	Public Const MENU_CERRAR_SESION As String = "Cerrar sesión"
	Public Const TAB_INICIO As String = "Inicio"
	Public Const TAB_CLIENTES As String = "Clientes"
	Public Const TAB_NUEVA As String = "Nueva"
	Public Const TAB_COTIZACIONES As String = "Cotizaciones"
	Public Const TAB_PERFIL As String = "Perfil"
	Public Const SIN_CLIENTES_TITULO As String = "Sin clientes"
	Public Const SIN_CLIENTES_TEXTO As String = "Todavía no hay clientes registrados."
	Public Const TITULO_COTIZACION As String = "Nueva cotización"
	Public Const GUARDAR_COTIZACION As String = "Guardar cotización"
	Public Const AYUDA_OBSERVACIONES As String = "Observaciones del proyecto"
	Public Const RETOMAR_COTIZACION As String = "Tiene una cotización sin terminar. ¿Desea retomarla?"
	Public Const SIN_PIEZAS As String = "Agregue al menos una pieza."
	Public Const SIN_PIEZAS_TITULO As String = "Todavía no hay piezas"
	Public Const SIN_PIEZAS_TEXTO As String = "Toque «Nueva pieza» para registrar la primera. Cada pieza lleva medidas, cantidad, croquis y fotos."
	Public Const PIEZA_SIN_ADJUNTOS As String = "Sin croquis ni fotos"
	Public Const PIEZA_SIN_CROQUIS As String = "Sin croquis"
	Public Const PIEZA_SIN_FOTOS As String = "Sin fotos"
	Public Const SIN_RESULTADOS As String = "No hay coincidencias."
	Public Const ELEGIR_CLIENTE As String = "Elegir cliente"
	Public Const ELEGIR_CONTACTO As String = "Elegir contacto"
	Public Const AYUDA_BUSCAR_CLIENTE As String = "Nombre o cédula"
	Public Const AYUDA_BUSCAR_CONTACTO As String = "Nombre del contacto"
	Public Const FALTA_CLIENTE As String = "Elija el cliente."
	Public Const FALTA_CONTACTO As String = "Elija el contacto del proyecto."
	Public Const SIN_MEDIDAS As String = "Las cotas que dibuje en el croquis aparecen aquí."
	Public Const TITULO_PIEZA As String = "Agregar pieza"
	Public Const TITULO_EDITAR_PIEZA As String = "Editar pieza"
	Public Const ELEGIR_TIPO_TRABAJO As String = "Elegir tipo de trabajo"
	Public Const ELEGIR_MATERIAL As String = "Elegir material"
	Public Const ELEGIR_ACABADO As String = "Elegir acabado"
	Public Const AYUDA_BUSCAR_NOMBRE As String = "Nombre"
	Public Const DESCARTAR_CAMBIOS_PIEZA As String = "¿Descartar los cambios de esta pieza? La pieza queda como estaba."
	Public Const SOLICITUD_GUARDADA As String = "Solicitud guardada en el teléfono. Se enviará a Anovo al sincronizar."
	Public Const SOLICITUD_NO_GUARDADA As String = "No se pudo guardar la solicitud en el teléfono. Intente de nuevo."
	Public Const FALTA_NOMBRE_PIEZA As String = "Escriba el nombre de la pieza."
	Public Const FOTOS_MAXIMO As String = "Llegó al máximo de fotos para esta pieza."
	Public Const ELEGIR_FOTO As String = "Elegir foto"
	Public Const FOTO_NO_VALIDA As String = "No se pudo leer la imagen elegida. Elija otra."
	Public Const FOTO_NO_GUARDADA As String = "No se pudo guardar la foto en el teléfono. Intente de nuevo."
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
End Sub

Public Sub ErrorServidor (Codigo As Int) As String
	Return ERROR_SERVIDOR.Replace("$1", Codigo)
End Sub

Public Sub PiezaMedidas (Cantidad As Int) As String
	Return PIEZA_MEDIDAS.Replace("$1", Cantidad)
End Sub

Public Sub TiposMedida As List
	Return Array As String("Largo", "Ancho", "Alto", "Profundidad", "Diámetro", "Radio", "Espesor", "Ángulo")
End Sub

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
