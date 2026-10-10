B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador del login, como TPresentadorLogin del escritorio: valida, pide el
' token, decide si la persona usa el movil y guarda la direccion del servidor.
Sub Class_Globals
	Public Const PROBAR_SIN_SERVIDOR As Boolean = True
	Private Const ESTADO_NO_AUTORIZADO As Int = 401
End Sub

Public Sub Initialize
End Sub

Public Sub Ingresar (Correo As String, Clave As String) As ResumableSub
	If Correo.Trim = "" Or Clave = "" Then Return Tipos.Falla(Mensajes.FALTAN_CREDENCIALES)
	If Api.UrlServidor = "" Then Return Tipos.Falla(Mensajes.URL_VACIA)

	Wait For (ApiAutenticacion.IniciarSesion(Correo, Clave)) Complete (Respuesta As RestRespuesta)
	If Respuesta.Success = False Then
		If Respuesta.StatusCode = ESTADO_NO_AUTORIZADO Then Return Tipos.Falla(Mensajes.CREDENCIALES_INVALIDAS)
		Return Tipos.Falla(Api.MensajeDe(Respuesta))
	End If

	If Sesion.Abrir(Respuesta.Valor("token")) = False Then Return Tipos.Falla(Mensajes.TOKEN_INVALIDO)
	If Sesion.Rol = Sesion.ROL_ADMIN Then
		Sesion.Cerrar
		Return Tipos.Falla(Mensajes.SIN_ACCESO_MOVIL)
	End If
	If Sesion.DebeCambiarClave Then
		Sesion.Cerrar
		Return Tipos.Falla(Mensajes.CLAVE_TEMPORAL)
	End If
	Return Tipos.Correcto(Null)
End Sub

Public Sub getFaltaServidor As Boolean
	Return Api.UrlServidor = ""
End Sub

Public Sub getTextoServidor As String
	Dim url As String = Api.UrlServidor
	If url = "" Then Return Mensajes.SERVIDOR_SIN_CONFIGURAR
	Return Mensajes.ROTULO_SERVIDOR & url
End Sub

Public Sub GuardarServidor (Url As String) As Resultado
	Dim error As String = Api.ValidarUrl(Url)
	If error <> "" Then Return Tipos.Falla(error)
	Api.GuardarUrl(Url)
	Return Tipos.Correcto(Null)
End Sub
