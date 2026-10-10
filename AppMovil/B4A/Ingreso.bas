B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Flujo del ingreso, como TPresentadorLogin del escritorio: valida, pide el
' token y decide si la persona puede usar el movil. Devuelve "" si entra.
Sub Class_Globals
	Private Const ESTADO_NO_AUTORIZADO As Int = 401
End Sub

Public Sub Initialize
End Sub

Public Sub Ingresar (Correo As String, Clave As String) As ResumableSub
	If Correo.Trim = "" Or Clave = "" Then Return Mensajes.FALTAN_CREDENCIALES
	If Api.UrlServidor = "" Then Return Mensajes.URL_VACIA

	Wait For (ApiAutenticacion.IniciarSesion(Correo, Clave)) Complete (Respuesta As RestRespuesta)
	If Respuesta.Success = False Then
		If Respuesta.StatusCode = ESTADO_NO_AUTORIZADO Then Return Mensajes.CREDENCIALES_INVALIDAS
		Return Api.MensajeDe(Respuesta)
	End If

	If Sesion.Abrir(Respuesta.Valor("token")) = False Then Return Mensajes.TOKEN_INVALIDO
	If Sesion.Rol = Sesion.ROL_ADMIN Then
		Sesion.Cerrar
		Return Mensajes.SIN_ACCESO_MOVIL
	End If
	If Sesion.DebeCambiarClave Then
		Sesion.Cerrar
		Return Mensajes.CLAVE_TEMPORAL
	End If
	Return ""
End Sub
