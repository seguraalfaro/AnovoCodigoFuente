B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' ============================================================
'  DbEsquema — crea la base local leyendo esquema_sqlite.sql (Files).
'  Sin versiones. Si cambia el esquema: se reemplaza el .sql y se
'  pone BORRAR_BASE = True una vez (borra y recrea con datos de prueba).
' ============================================================
Sub Process_Globals
	Public Const DB_NOMBRE   As String = "anovo.db"
	Public Const DB_ESQUEMA  As String = "esquema_sqlite.sql"
	Public Const BORRAR_BASE As Boolean = False     ' True = borra y recrea al arrancar
	Public ExisteBaseDatos As Boolean
	Private TABLAS() As String = Array As String( _
        "clientes", "cliente_contactos", "consentimiento_firmas", _
        "solicitudes", "adjuntos", "medidas", _
        "cotizaciones_estado", "cola_sync", "config")
End Sub

' Abre (o crea) la base y devuelve la conexión lista.
Public Sub Abrir As SQL
	'If BORRAR_BASE Then File.Delete(File.DirInternal, DB_NOMBRE)

	ExisteBaseDatos = (File.Exists(File.DirInternal, DB_NOMBRE) = False) Or _
                  (File.Size(File.DirInternal, DB_NOMBRE) = 0)
   Try
	Dim s As SQL
		s.Initialize(File.DirInternal, DB_NOMBRE, True)
	
	
	
	Catch
		Log("DbEsquema: FALLÓ al crear el esquema -> " & LastException)
		Dim x As XUI
		x.MsgboxAsync("No se pudo preparar la base de datos local.", "Anovo")
	Return s        ' IsInitialized = False
	End Try
	AplicarPragmas(s)
    If ExisteBaseDatos Then
	CrearEsquema(s)
	ValidarEsquema(s)
	End If
	Log("DbEsquema: base lista.")
	Return s
End Sub
Private Sub AplicarPragmas(s As SQL)
	
	Dim modo As String = s.ExecQuerySingleResult("PRAGMA journal_mode = WAL")
	If modo.ToLowerCase <> "wal" Then
		Log("DbEsquema: WAL no aplicado, el modo quedo en '" & modo & "'")
	End If
	s.ExecNonQuery("PRAGMA synchronous = FULL")

	s.ExecNonQuery("PRAGMA foreign_keys = ON")
	If s.ExecQuerySingleResult("PRAGMA foreign_keys") <> 1 Then
		Log("DbEsquema: claves foraneas NO activas.")
	End If
End Sub

Private Sub CrearEsquema (s As SQL)
	s.BeginTransaction
	Try
		For Each sentencia As String In LeerSentencias(DB_ESQUEMA)
			s.ExecNonQuery(sentencia)
		Next
		s.TransactionSuccessful
	Catch
		Log("DbEsquema: FALLÓ al crear el esquema -> " & LastException)
		s.EndTransaction
		Dim x As XUI
		x.MsgboxAsync("No se pudo preparar la base de datos local.", "Anovo")
		Return
	End Try
	s.EndTransaction
End Sub

' Lee el .sql de Files: corta cada línea en "--", junta, separa por ";",
' descarta vacías y PRAGMAs. Válido porque el DDL no tiene triggers ni
' ";"/"--" dentro de literales.
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

Private Sub  ValidarEsquema(s As SQL)
	Dim faltan As List
	faltan.Initialize
	For Each t As String In TABLAS
		If s.ExecQuerySingleResult2("SELECT count(*) FROM sqlite_master WHERE type='table' AND name=?", _
            Array As String(t)) = 0 Then faltan.Add(t)
	Next
	If faltan.Size > 0 Then
		Log("DbEsquema: faltan tablas -> " & faltan.As(List))
		Dim x As XUI
		x.MsgboxAsync("Base de datos incompleta: " & faltan.As(List), "Anovo")
	End If
End Sub