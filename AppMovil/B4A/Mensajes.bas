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
	Private Const ERROR_SERVIDOR As String = "El servidor respondió con un error ($1)."
End Sub

Public Sub ErrorServidor (Codigo As Int) As String
	Return ERROR_SERVIDOR.Replace("$1", Codigo)
End Sub
