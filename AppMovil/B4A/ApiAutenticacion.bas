B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Ingreso contra el middleware JWT de DMVC: correo y clave van en los
' encabezados jwtusername y jwtpassword; la respuesta trae solo el token.
Sub Process_Globals
	Private Const RUTA_LOGIN As String = "/api/auth/login"
	Private Const ENCABEZADO_USUARIO As String = "jwtusername"
	Private Const ENCABEZADO_CLAVE As String = "jwtpassword"
End Sub

Public Sub IniciarSesion (Correo As String, Clave As String) As ResumableSub
	Dim cliente As RestCliente = Api.NuevoCliente(False)
	cliente.AddHeader(ENCABEZADO_USUARIO, Correo.Trim).AddHeader(ENCABEZADO_CLAVE, Clave)
	Return cliente.Post(RUTA_LOGIN)
End Sub
