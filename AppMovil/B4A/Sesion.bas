B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Sesion en memoria, como TSesion del escritorio: token, cuenta y rol leidos
' del propio JWT, y los permisos de /api/sesion. Nunca se guarda en disco.
Sub Process_Globals
	Public UsuarioId As Int
	Public Correo As String
	Public Nombre As String
	Public Rol As String
	Public DebeCambiarClave As Boolean
	Public Const PERMISO_ACCESO_MOVIL As String = "acceso.movil"
	Public Const PERMISO_CLIENTES_VER As String = "clientes.ver"
	Public Const PERMISO_CLIENTES_CREAR As String = "clientes.crear"
	Public Const PERMISO_CLIENTES_CONSENTIMIENTO As String = "clientes.consentimiento"
	Public Const PERMISO_SOLICITUDES_CREAR As String = "solicitudes.crear"
	Public Const PERMISO_SOLICITUDES_VER_PROPIAS As String = "solicitudes.ver_propias"
	Public Const PERMISO_ADJUNTOS_CREAR As String = "solicitudes.adjuntos.crear"
	Public Const PERMISO_VER_APROBADAS_PROPIAS As String = "cotizaciones.ver_aprobadas_propias"
	Private mPermisos As List
	Private mToken As String
	Private mVence As Long
	Private mLocal As Boolean
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
	Return mToken <> "" Or mLocal
End Sub

Public Sub AbrirLocal (p As PerfilLocal)
	mToken = ""
	mVence = 0
	mLocal = True
	UsuarioId = p.UsuarioId
	Correo = p.Correo
	Nombre = p.Nombre
	Rol = p.Rol
	AsignarPermisos(p.Permisos)
	DebeCambiarClave = False
End Sub

Public Sub AsignarPermisos (Lista As List)
	mPermisos.Initialize
	If Lista.IsInitialized Then mPermisos.AddAll(Lista)
End Sub

Public Sub Permisos As List
	If mPermisos.IsInitialized = False Then mPermisos.Initialize
	Return mPermisos
End Sub

Public Sub Tiene (Codigo As String) As Boolean
	Return Permisos.IndexOf(Codigo) > -1
End Sub

Public Sub VigentePor (Segundos As Int) As Boolean
	Return Iniciada And DateTime.Now + Segundos * DateTime.TicksPerSecond < mVence
End Sub

Public Sub Cerrar
	mLocal = False
	mToken = ""
	mVence = 0
	UsuarioId = 0
	Correo = ""
	Nombre = ""
	Rol = ""
	mPermisos.Initialize
	DebeCambiarClave = False
End Sub
