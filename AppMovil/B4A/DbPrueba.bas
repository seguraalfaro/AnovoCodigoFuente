B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Datos de demostracion tomados de la base central (datos_prueba.json): clientes, contactos y
' catalogos con el mismo uuid e id del servidor. Cada grupo carga solo si su tabla esta vacia.
Sub Process_Globals
	Public Const CARGAR_DATOS As Boolean = True
	Private Const ARCHIVO As String = "datos_prueba.json"
	Private Const SQL_HAY_CLIENTES As String = "SELECT count(*) FROM clientes"
	Private Const SQL_HAY_TIPOS_TRABAJO As String = "SELECT count(*) FROM tipos_trabajo"
	Private Const SQL_CLIENTE As String = "INSERT INTO clientes (uuid_local, id_servidor, nombre, identificacion, tipo_identificacion, telefono, correo, contacto, direccion, latitud, longitud, consentimiento_estado, estado_sync) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'confirmado')"
	Private Const SQL_CONTACTO As String = "INSERT INTO cliente_contactos (uuid_local, id_servidor, cliente_uuid, nombre, area, telefono, celular, correo, principal, consentimiento_estado, estado_sync) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'confirmado')"
	Private Const SQL_TIPO_TRABAJO As String = "INSERT INTO tipos_trabajo (id_servidor, nombre) VALUES (?, ?)"
	Private Const SQL_TIPO_MATERIAL As String = "INSERT INTO tipos_material (id_servidor, nombre) VALUES (?, ?)"
	Private Const SQL_ACABADO As String = "INSERT INTO acabados (id_servidor, nombre) VALUES (?, ?)"
End Sub

Public Sub Cargar
	If CARGAR_DATOS = False Then Return
	Dim s As SQL = Db.DbSQL
	If s.IsInitialized = False Then Return
	Dim datos As Map
	Try
		Dim jp As JSONParser
		jp.Initialize(File.ReadString(File.DirAssets, ARCHIVO))
		datos = jp.NextObject
	Catch
		Log("DbPrueba.Cargar: " & LastException.Message)
		Return
	End Try
	s.BeginTransaction
	Try
		If s.ExecQuerySingleResult(SQL_HAY_TIPOS_TRABAJO) = 0 Then
			CargarCatalogo(s, SQL_TIPO_TRABAJO, datos.Get("tipos_trabajo"))
			CargarCatalogo(s, SQL_TIPO_MATERIAL, datos.Get("tipos_material"))
			CargarCatalogo(s, SQL_ACABADO, datos.Get("acabados"))
		End If
		If s.ExecQuerySingleResult(SQL_HAY_CLIENTES) = 0 Then
			CargarClientes(s, datos.Get("clientes"))
			CargarContactos(s, datos.Get("contactos"))
		End If
		s.TransactionSuccessful
		Log("DbPrueba: datos de demostracion cargados.")
	Catch
		Log("DbPrueba.Cargar: " & LastException.Message)
	End Try
	s.EndTransaction
End Sub

Private Sub CargarCatalogo (s As SQL, Sentencia As String, Filas As List)
	For Each m As Map In Filas
		s.ExecNonQuery2(Sentencia, Array As Object(m.Get("id"), m.Get("nombre")))
	Next
End Sub

Private Sub CargarClientes (s As SQL, Filas As List)
	For Each m As Map In Filas
		s.ExecNonQuery2(SQL_CLIENTE, Array As Object(m.Get("uuid"), m.Get("id"), m.Get("nombre"), m.Get("identificacion"), _
			m.Get("tipo_identificacion"), m.Get("telefono"), m.Get("correo"), m.Get("contacto"), m.Get("direccion"), _
			m.Get("latitud"), m.Get("longitud"), m.Get("consentimiento")))
	Next
End Sub

Private Sub CargarContactos (s As SQL, Filas As List)
	For Each m As Map In Filas
		s.ExecNonQuery2(SQL_CONTACTO, Array As Object(m.Get("uuid"), m.Get("id"), m.Get("cliente_uuid"), m.Get("nombre"), _
			m.Get("area"), m.Get("telefono"), m.Get("celular"), m.Get("correo"), m.Get("principal"), m.Get("consentimiento")))
	Next
End Sub
