B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Rutas de la cuenta propia, como en Configuracion del escritorio: permisos, datos de
' la cuenta, cambio de clave y versiones. Devuelve el RestCliente armado; quien llama espera Enviar.
Sub Process_Globals
	Private Const RUTA_SESION As String = "/api/sesion"
	Private Const RUTA_CUENTA As String = "/api/sesion/cuenta"
	Private Const RUTA_CLAVE As String = "/api/sesion/clave"
	Private Const RUTA_VERSION As String = "/api/version"
	Private Const CAMPO_ACTUAL As String = "clave_actual"
	Private Const CAMPO_NUEVA As String = "clave_nueva"
End Sub

Public Sub Permisos As RestCliente
	Return Api.NuevoCliente(True).PrepararGet(RUTA_SESION)
End Sub

Public Sub Cuenta As RestCliente
	Return Api.NuevoCliente(True).PrepararGet(RUTA_CUENTA)
End Sub

Public Sub CambiarClave (Actual As String, Nueva As String) As RestCliente
	Return Api.NuevoCliente(True).AddBody(CreateMap(CAMPO_ACTUAL: Actual, CAMPO_NUEVA: Nueva)).PrepararPut(RUTA_CLAVE)
End Sub

Public Sub Version As RestCliente
	Return Api.NuevoCliente(False).PrepararGet(RUTA_VERSION)
End Sub
