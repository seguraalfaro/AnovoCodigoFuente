B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Ingreso contra el middleware JWT de DMVC (correo y clave en encabezados, responde solo
' el token) y llave del telefono: registro, renovacion de la sesion y cierre.
Sub Process_Globals
	Private Const RUTA_LOGIN As String = "/api/auth/login"
	Private Const ENCABEZADO_USUARIO As String = "jwtusername"
	Private Const ENCABEZADO_CLAVE As String = "jwtpassword"
	Private Const RUTA_DISPOSITIVOS As String = "/api/auth/dispositivos"
	Private Const RUTA_RENOVAR As String = "/api/auth/renovar"
	Private Const RUTA_CIERRE As String = "/api/auth/cierre"
	Private Const CAMPO_UUID As String = "uuid_dispositivo"
	Private Const CAMPO_NOMBRE As String = "nombre"
	Private Const CAMPO_LLAVE As String = "llave"
End Sub

Public Sub IniciarSesion (Correo As String, Clave As String) As RestCliente
	Dim cliente As RestCliente = Api.NuevoCliente(False)
	cliente.AddHeader(ENCABEZADO_USUARIO, Correo.Trim).AddHeader(ENCABEZADO_CLAVE, Clave)
	Return cliente.PrepararPost(RUTA_LOGIN)
End Sub

Public Sub RegistrarDispositivo (Uuid As String, Nombre As String) As RestCliente
	Return Api.NuevoCliente(True).AddBody(CreateMap(CAMPO_UUID: Uuid, CAMPO_NOMBRE: Nombre)).PrepararPost(RUTA_DISPOSITIVOS)
End Sub

Public Sub Renovar (Uuid As String, Llave As String) As RestCliente
	Return Api.NuevoCliente(False).AddBody(CreateMap(CAMPO_UUID: Uuid, CAMPO_LLAVE: Llave)).PrepararPost(RUTA_RENOVAR)
End Sub

Public Sub CerrarDispositivo (Uuid As String, Llave As String) As RestCliente
	Return Api.NuevoCliente(False).AddBody(CreateMap(CAMPO_UUID: Uuid, CAMPO_LLAVE: Llave)).PrepararPost(RUTA_CIERRE)
End Sub
