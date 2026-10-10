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
	Private Const ERROR_SERVIDOR As String = "El servidor respondió con un error ($1)."
End Sub

Public Sub ErrorServidor (Codigo As Int) As String
	Return ERROR_SERVIDOR.Replace("$1", Codigo)
End Sub
