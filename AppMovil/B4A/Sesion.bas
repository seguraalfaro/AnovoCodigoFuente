B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Sesion en memoria, como TSesion del escritorio: token, cuenta y rol leidos
' del propio JWT. Nunca se guarda en disco.
Sub Process_Globals
	Public UsuarioId As Int
	Public Correo As String
	Public Nombre As String
	Public Rol As String
	Public DebeCambiarClave As Boolean
	Public Const ROL_ADMIN As String = "admin"
	Private mToken As String
	Private mVence As Long
End Sub

Public Sub Abrir (TokenRecibido As String) As Boolean
	Dim partes() As String = Regex.Split("\.", TokenRecibido)
	If partes.Length <> 3 Then Return False
	Dim carga As Map = LeerCarga(partes(1))
	If carga.Size = 0 Then Return False
	mToken = TokenRecibido
	Correo = carga.GetDefault("username", "")
	Nombre = carga.GetDefault("NOMBRE", "")
	Rol = carga.GetDefault("roles", "")
	Dim id As String = carga.GetDefault("USUARIO_ID", "0")
	If IsNumber(id) Then UsuarioId = id Else UsuarioId = 0
	DebeCambiarClave = "True".EqualsIgnoreCase(carga.GetDefault("DEBE_CAMBIAR_CLAVE", "False"))
	Dim segundos As Long = carga.GetDefault("exp", 0)
	mVence = segundos * DateTime.TicksPerSecond
	Return True
End Sub

Private Sub LeerCarga (Parte As String) As Map
	Dim vacio As Map
	vacio.Initialize
	Try
		Dim base64 As String = Parte.Replace("-", "+").Replace("_", "/")
		Do While base64.Length Mod 4 <> 0
			base64 = base64 & "="
		Loop
		Dim su As StringUtils
		Dim bytes() As Byte = su.DecodeBase64(base64)
		Dim parser As JSONParser
		parser.Initialize(BytesToString(bytes, 0, bytes.Length, "UTF8"))
		Return parser.NextObject
	Catch
		Return vacio
	End Try
End Sub

Public Sub Token As String
	Return mToken
End Sub

Public Sub Iniciada As Boolean
	Return mToken <> ""
End Sub

Public Sub Vigente As Boolean
	Return Iniciada And DateTime.Now < mVence
End Sub

Public Sub Cerrar
	mToken = ""
	mVence = 0
	UsuarioId = 0
	Correo = ""
	Nombre = ""
	Rol = ""
	DebeCambiarClave = False
End Sub
