B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Crea la base local leyendo esquema_sqlite.sql (Files) y la lleva a VERSION_ESQUEMA con
' migracion_sqlite_N.sql, sin borrar datos. Si algo falla lo deja en ErrorEsquema.

Sub Process_Globals
	Public Const DB_NOMBRE As String = "anovo.db"
	Public Const DB_ESQUEMA As String = "esquema_sqlite.sql"
	Public Const BORRAR_BASE As Boolean = False
	Public Const VERSION_ESQUEMA As Int = 1
	Private Const VERSION_BASE As Int = 1
	Private Const PREFIJO_MIGRACION As String = "migracion_sqlite_"
	Private Const EXTENSION_MIGRACION As String = ".sql"
	Public ExisteBaseDatos As Boolean
	Public ErrorEsquema As String
	Private Const SQL_TABLA_EXISTE As String = "SELECT count(*) FROM sqlite_master WHERE type = 'table' AND name = ?"
	Private TABLAS() As String = Array As String( _
		"clientes", "cliente_contactos", "consentimiento_firmas", "consentimiento_texto", _
		"solicitudes", "piezas", "adjuntos", "medidas", _
		"tipos_trabajo", "tipos_material", "acabados", _
		"seguimiento", "cola_sync", "config", "sync_historial")
End Sub

#Region Apertura
Public Sub Abrir As SQL
	ErrorEsquema = ""
	If BORRAR_BASE Then BorrarBase
	ExisteBaseDatos = (File.Exists(File.DirInternal, DB_NOMBRE) = False) Or _
		(File.Size(File.DirInternal, DB_NOMBRE) = 0)
	Dim s As SQL
	Try
		s.Initialize(File.DirInternal, DB_NOMBRE, True)
	Catch
		Log("DbEsquema: no se pudo abrir la base -> " & LastException)
		ErrorEsquema = Mensajes.BASE_NO_PREPARADA
		Return s
	End Try
	AplicarPragmas(s)
	If CrearEsquema(s) And Migrar(s) Then ValidarEsquema(s)
	Log("DbEsquema: base lista.")
	Return s
End Sub

Private Sub BorrarBase
	For Each nombre As String In Array As String(DB_NOMBRE, DB_NOMBRE & "-wal", DB_NOMBRE & "-shm")
		If File.Exists(File.DirInternal, nombre) Then File.Delete(File.DirInternal, nombre)
	Next
	Log("DbEsquema: base borrada por BORRAR_BASE.")
End Sub

Private Sub AplicarPragmas (s As SQL)
	Dim modo As String = s.ExecQuerySingleResult("PRAGMA journal_mode = WAL")
	If modo.ToLowerCase <> "wal" Then Log("DbEsquema: WAL no aplicado, el modo quedo en '" & modo & "'")
	s.ExecNonQuery("PRAGMA synchronous = FULL")
	s.ExecNonQuery("PRAGMA foreign_keys = ON")
	If s.ExecQuerySingleResult("PRAGMA foreign_keys") <> 1 Then Log("DbEsquema: claves foraneas NO activas.")
End Sub
#End Region

#Region Creación del esquema
Private Sub CrearEsquema (s As SQL) As Boolean
	s.BeginTransaction
	Try
		For Each sentencia As String In LeerSentencias(DB_ESQUEMA)
			s.ExecNonQuery(sentencia)
		Next
		s.TransactionSuccessful
	Catch
		Log("DbEsquema: no se pudo crear el esquema -> " & LastException)
		s.EndTransaction
		ErrorEsquema = Mensajes.BASE_NO_PREPARADA
		Return False
	End Try
	s.EndTransaction
	Return True
End Sub

Private Sub Migrar (s As SQL) As Boolean
	If ExisteBaseDatos Then
		FijarVersion(s, VERSION_ESQUEMA)
		Return True
	End If
	Dim actual As Int = Max(VERSION_BASE, s.ExecQuerySingleResult("PRAGMA user_version"))
	For v = actual + 1 To VERSION_ESQUEMA
		s.BeginTransaction
		Try
			For Each sentencia As String In LeerSentencias(PREFIJO_MIGRACION & v & EXTENSION_MIGRACION)
				s.ExecNonQuery(sentencia)
			Next
			s.TransactionSuccessful
		Catch
			Log("DbEsquema: no se pudo aplicar la migracion " & v & " -> " & LastException)
			s.EndTransaction
			ErrorEsquema = Mensajes.BASE_NO_PREPARADA
			Return False
		End Try
		s.EndTransaction
		FijarVersion(s, v)
	Next
	If actual > VERSION_ESQUEMA Then Return True
	FijarVersion(s, Max(actual, VERSION_ESQUEMA))
	Return True
End Sub

Private Sub FijarVersion (s As SQL, Version As Int)
	s.ExecNonQuery("PRAGMA user_version = " & Version)
End Sub

Private Sub LeerSentencias (NombreArchivo As String) As List
	Dim script As String = File.ReadString(File.DirAssets, NombreArchivo)
	Dim sb As StringBuilder
	sb.Initialize
	For Each linea As String In Regex.Split("\n", script)
		Dim p As Int = linea.IndexOf("--")
		If p >= 0 Then linea = linea.SubString2(0, p)
		sb.Append(linea).Append(Chr(10))
	Next
	Dim res As List
	res.Initialize
	For Each raw As String In Regex.Split(";", sb.ToString)
		Dim st As String = raw.Trim
		If st.Length = 0 Then Continue
		If st.ToUpperCase.StartsWith("PRAGMA") Then Continue
		res.Add(st)
	Next
	Return res
End Sub

Private Sub ValidarEsquema (s As SQL)
	Dim faltan As List
	faltan.Initialize
	For Each t As String In TABLAS
		If s.ExecQuerySingleResult2(SQL_TABLA_EXISTE, Array As String(t)) = 0 Then faltan.Add(t)
	Next
	If faltan.Size = 0 Then Return
	Log("DbEsquema: faltan tablas -> " & faltan)
	ErrorEsquema = Mensajes.BaseIncompleta(faltan)
End Sub
#End Region
