B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.01
@EndOfDesignText@
' ============================================================================
'  DBUtils (edición depurada para el TFG Anovo)
'  Base: DBUtils 1.20 de Erel (incluido con B4A).
'  Añadidos de imagen: adaptados de extDBUtils 7.01 de G. Becker (foro B4X).
'  Cambios respecto a extDBUtils 7.01:
'    - Solo B4A (se eliminan los guardas #If B4i/B4J).
'    - Se elimina el estado global (SQLDB, SQLWHERE, SQLValues) y la región "info".
'    - Se elimina calcValue / isUnique / getRowID (dependían del estado global;
'      isUnique tenía además la lógica invertida).
'    - DropTable: corregido el espacio que faltaba antes del nombre de tabla.
'    - Se vuelve al recorrido de Maps POR ÍNDICE (GetKeyAt/GetValueAt) del
'      DBUtils de Erel: "For Each col In m.Keys" lanza ClassCastException
'      (Map$MyMap no es java.util.Map) cuando el Map llega envuelto.
'    - InsertMaps partido en InsertMapsIn / InsertMapIn (sin transacción, el
'      llamador controla el rollback) e InsertMaps (con transacción, Boolean).
'    - Se elimina la región de fechas: la cubre Cadenas.bas, que además
'      restaura DateTime.DateFormat (aquí quedaba modificado globalmente).
'    - Todas las funciones son puras: reciben el objeto SQL como parámetro.
'  Módulo de código sin estado, al estilo de UI.bas / Colores.bas.
' ============================================================================

Sub Process_Globals
	Public DB_REAL As String = "REAL"
	Public DB_INTEGER As String = "INTEGER"
	Public DB_BLOB As String = "BLOB"
	Public DB_TEXT As String = "TEXT"

	Type DBFieldInfo(FieldName As String, DataType As String, _
		CanBeNull As Boolean, DefValue As Object)
End Sub

#Region --- Ubicación y copia de la base ---

'Devuelve la carpeta donde crear la base de datos (almacenamiento externo si es escribible).
Public Sub GetDBFolder As String
	Dim rp As RuntimePermissions
	If File.ExternalWritable Then
		Return rp.GetSafeDirDefaultExternal("")
	Else
		Return File.DirInternal
	End If
End Sub

'Copia una base incluida en la pestaña Files a una ubicación escribible.
'Si el archivo ya existe no se copia. Devuelve la carpeta destino.
Public Sub CopyDBFromAssets (FileName As String) As String
	Dim TargetDir As String = GetDBFolder
	If File.Exists(TargetDir, FileName) = False Then
		File.Copy(File.DirAssets, FileName, TargetDir, FileName)
	End If
	Return TargetDir
End Sub

#End Region

#Region --- Utilidades internas ---

Private Sub EscapeField(f As String) As String
	Return "[" & f & "]"
End Sub

#End Region

#Region --- Esquema ---

'Crea una tabla. FieldsAndTypes: claves = nombres de columna, valores = tipos (usar DB_...).
'PrimaryKey: columna clave primaria, o cadena vacía si no aplica.
Public Sub CreateTable(SQL As SQL, TableName As String, FieldsAndTypes As Map, PrimaryKey As String)
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append("(")
	For i = 0 To FieldsAndTypes.Size - 1
		Dim field As String = FieldsAndTypes.GetKeyAt(i)
		Dim ftype As String = FieldsAndTypes.GetValueAt(i)
		If i > 0 Then sb.Append(", ")
		sb.Append(EscapeField(field)).Append(" ").Append(ftype)
		If field = PrimaryKey Then sb.Append(" PRIMARY KEY")
	Next
	sb.Append(")")
	Dim query As String = "CREATE TABLE IF NOT EXISTS " & EscapeField(TableName) & " " & sb.ToString
	Log("CreateTable: " & query)
	SQL.ExecNonQuery(query)
End Sub

'Elimina la tabla indicada.
Public Sub DropTable(SQL As SQL, TableName As String)
	Dim query As String = "DROP TABLE IF EXISTS " & EscapeField(TableName)
	Log("DropTable: " & query)
	SQL.ExecNonQuery(query)
End Sub

'Indica si existe la tabla (sin distinguir mayúsculas).
Public Sub TableExists(SQL As SQL, TableName As String) As Boolean
	Dim count As Int = SQL.ExecQuerySingleResult2( _
		"SELECT count(name) FROM sqlite_master WHERE type='table' AND name=? COLLATE NOCASE", _
		Array As String(TableName))
	Return count > 0
End Sub

'Devuelve la lista de nombres de todas las tablas.
Public Sub GetTables(SQL As SQL) As List
	Return ExecuteList(SQL, "SELECT name FROM sqlite_master WHERE type='table'", Null, 0)
End Sub

'Devuelve una lista de DBFieldInfo con la información de cada columna de la tabla.
Public Sub GetFieldsInfo(SQL As SQL, TableName As String) As List
	Dim res As List
	res.Initialize
	Dim rows As List = ExecuteMemoryTable(SQL, "PRAGMA table_info(" & EscapeField(TableName) & ")", Null, 0)
	For Each values() As String In rows
		Dim fi As DBFieldInfo
		fi.Initialize
		fi.FieldName = values(1)
		fi.DataType = values(2)
		fi.CanBeNull = (values(3) = "0")
		fi.DefValue = values(4)
		res.Add(fi)
	Next
	Return res
End Sub

#End Region

#Region --- Versionado del esquema ---

'Devuelve la versión actual de la base. Si no existe la tabla DBVersion la crea con versión 1.
Public Sub GetDBVersion (SQL As SQL) As Int
	If TableExists(SQL, "DBVersion") Then
		Return SQL.ExecQuerySingleResult("SELECT version FROM DBVersion")
	Else
		Dim m As Map
		m.Initialize
		m.Put("version", DB_INTEGER)
		CreateTable(SQL, "DBVersion", m, "version")
		SQL.ExecNonQuery("INSERT INTO DBVersion VALUES (1)")
		Return 1
	End If
End Sub

'Fija la versión de la base.
Public Sub SetDBVersion (SQL As SQL, Version As Int)
	SQL.ExecNonQuery2("UPDATE DBVersion SET version = ?", Array As Object(Version))
End Sub

#End Region

#Region --- Escritura (CRUD por Map) ---

'Inserta VARIAS filas dentro de una transaccion YA abierta por el llamador.
'ListOfMaps: List cuyos elementos son Map. Para una sola fila usar InsertMapIn.
'No captura errores: deja que la excepcion suba para que el llamador haga rollback.
Public Sub InsertMapsIn (SQL As SQL, TableName As String, ListOfMaps As List)
	For i1 = 0 To ListOfMaps.Size - 1
		Dim sb, columns, values As StringBuilder
		sb.Initialize : columns.Initialize : values.Initialize
		Dim listOfValues As List
		listOfValues.Initialize
		sb.Append("INSERT INTO ").Append(EscapeField(TableName)).Append(" (")
		Dim m As Map = ListOfMaps.Get(i1)
		For i2 = 0 To m.Size - 1
			If i2 > 0 Then
				columns.Append(", ")
				values.Append(", ")
			End If
			columns.Append(EscapeField(m.GetKeyAt(i2)))
			values.Append("?")
			listOfValues.Add(m.GetValueAt(i2))
		Next
		sb.Append(columns.ToString).Append(") VALUES (").Append(values.ToString).Append(")")
		SQL.ExecNonQuery2(sb.ToString, listOfValues)
	Next
End Sub

'UNA sola fila, dentro de una transaccion ya abierta.
'Construye la List internamente: "Array As Map(...)" no sirve, deja wrappers.
Public Sub InsertMapIn (SQL As SQL, TableName As String, Fila As Map)
	Dim l As List
	l.Initialize
	l.Add(Fila)
	InsertMapsIn(SQL, TableName, l)
End Sub

'Version autonoma: abre su propia transaccion. Devuelve False si fallo.
'No usar dentro de otra transaccion: SQLite no admite anidarlas.
Public Sub InsertMaps (SQL As SQL, TableName As String, ListOfMaps As List) As Boolean
	SQL.BeginTransaction
	Dim ok As Boolean = False
	Try
		InsertMapsIn(SQL, TableName, ListOfMaps)
		SQL.TransactionSuccessful
		ok = True
	Catch
		Log("InsertMaps ERROR: " & LastException)
	End Try
	SQL.EndTransaction
	Return ok
End Sub

'Actualiza un solo campo de los registros que cumplan WhereFieldEquals (condiciones AND).
Public Sub UpdateRecord(SQL As SQL, TableName As String, Field As String, NewValue As Object, WhereFieldEquals As Map)
	Dim f As Map
	f.Initialize
	f.Put(Field, NewValue)
	UpdateRecord2(SQL, TableName, f, WhereFieldEquals)
End Sub

'Actualiza varios campos (Fields: clave = columna) de los registros que cumplan WhereFieldEquals.
Public Sub UpdateRecord2(SQL As SQL, TableName As String, Fields As Map, WhereFieldEquals As Map)
	If Fields.Size = 0 Then
		Log("UpdateRecord2: Fields vacío")
		Return
	End If
	If WhereFieldEquals.Size = 0 Then
		Log("UpdateRecord2: WhereFieldEquals vacío (se evita un UPDATE sin filtro)")
		Return
	End If
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append("UPDATE ").Append(EscapeField(TableName)).Append(" SET ")
	Dim args As List
	args.Initialize
	For i = 0 To Fields.Size - 1
		If i > 0 Then sb.Append(", ")
		sb.Append(EscapeField(Fields.GetKeyAt(i))).Append(" = ?")
		args.Add(Fields.GetValueAt(i))
	Next
	sb.Append(" WHERE ")
	For i = 0 To WhereFieldEquals.Size - 1
		If i > 0 Then sb.Append(" AND ")
		sb.Append(EscapeField(WhereFieldEquals.GetKeyAt(i))).Append(" = ?")
		args.Add(WhereFieldEquals.GetValueAt(i))
	Next
	Log("UpdateRecord2: " & sb.ToString)
	SQL.ExecNonQuery2(sb.ToString, args)
End Sub

'Borra los registros que cumplan WhereFieldEquals (condiciones AND). No permite borrado sin filtro.
Public Sub DeleteRecord(SQL As SQL, TableName As String, WhereFieldEquals As Map)
	If WhereFieldEquals.Size = 0 Then
		Log("DeleteRecord: WhereFieldEquals vacío (se evita un DELETE sin filtro)")
		Return
	End If
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append("DELETE FROM ").Append(EscapeField(TableName)).Append(" WHERE ")
	Dim args As List
	args.Initialize
	For i = 0 To WhereFieldEquals.Size - 1
		If i > 0 Then sb.Append(" AND ")
		sb.Append(EscapeField(WhereFieldEquals.GetKeyAt(i))).Append(" = ?")
		args.Add(WhereFieldEquals.GetValueAt(i))
	Next
	Log("DeleteRecord: " & sb.ToString)
	SQL.ExecNonQuery2(sb.ToString, args)
End Sub

#End Region

#Region --- Lectura ---

'Ejecuta la consulta y devuelve una lista de arrays de String (una por fila).
'StringArgs: valores para los "?" (Null si no hay). Limit: 0 = todas.
Public Sub ExecuteMemoryTable(SQL As SQL, Query As String, StringArgs() As String, Limit As Int) As List
	Dim cur As ResultSet
	If StringArgs = Null Then
		cur = SQL.ExecQuery(Query)
	Else
		cur = SQL.ExecQuery2(Query, StringArgs)
	End If
	Log("ExecuteMemoryTable: " & Query)
	Dim table As List
	table.Initialize
	Do While cur.NextRow
		Dim values(cur.ColumnCount) As String
		For col = 0 To cur.ColumnCount - 1
			values(col) = cur.GetString2(col)
		Next
		table.Add(values)
		If Limit > 0 And table.Size >= Limit Then Exit
	Loop
	cur.Close
	Return table
End Sub

'Ejecuta la consulta y devuelve un Map (columna en minúsculas -> valor) con la primera fila.
'Devuelve un Map sin inicializar si no hay resultados (comprobar con .IsInitialized).
Public Sub ExecuteMap(SQL As SQL, Query As String, StringArgs() As String) As Map
	Dim res As Map
	Dim cur As ResultSet
	If StringArgs = Null Then
		cur = SQL.ExecQuery(Query)
	Else
		cur = SQL.ExecQuery2(Query, StringArgs)
	End If
	Log("ExecuteMap: " & Query)
	If cur.NextRow = False Then
		cur.Close
		Log("ExecuteMap: sin resultados")
		Return res
	End If
	res.Initialize
	For i = 0 To cur.ColumnCount - 1
		res.Put(cur.GetColumnName(i).ToLowerCase, cur.GetString2(i))
	Next
	cur.Close
	Return res
End Sub

'Ejecuta la consulta y devuelve una lista con los valores de la primera columna.
Public Sub ExecuteList(SQL As SQL, Query As String, StringArgs() As String, Limit As Int) As List
	Dim res As List
	res.Initialize
	For Each cols() As String In ExecuteMemoryTable(SQL, Query, StringArgs, Limit)
		res.Add(cols(0))
	Next
	Return res
End Sub

'Rellena una lista existente con los valores de la primera columna.
Public Sub ExecuteList2(SQL As SQL, Query As String, StringArgs() As String, Limit As Int, TargetList As List)
	TargetList.Clear
	TargetList.AddAll(ExecuteList(SQL, Query, StringArgs, Limit))
End Sub

'Rellena un Spinner con los valores de la primera columna.
Public Sub ExecuteSpinner(SQL As SQL, Query As String, StringArgs() As String, Limit As Int, Spinner1 As Spinner)
	Spinner1.Clear
	For Each cols() As String In ExecuteMemoryTable(SQL, Query, StringArgs, Limit)
		Spinner1.Add(cols(0))
	Next
End Sub

#End Region

#Region --- Imágenes en columnas BLOB ---

'Convierte un Bitmap a bytes para guardar en una columna BLOB. PNG=True para PNG, False para JPEG(90).
Public Sub Image2Blob(Image As Bitmap, PNG As Boolean) As Byte()
	Dim out As OutputStream
	out.InitializeToBytesArray(1000)
	If PNG Then
		Image.WriteToStream(out, 100, "PNG")
	Else
		Image.WriteToStream(out, 90, "JPEG")
	End If
	Return out.ToBytesArray
End Sub

'Convierte los bytes de una columna BLOB a Bitmap.
Public Sub Blob2Image(Blob() As Byte) As Bitmap
	Dim in As InputStream
	in.InitializeFromBytesArray(Blob, 0, Blob.Length)
	Dim bmp As Bitmap
	bmp.Initialize2(in)
	in.Close
	Return bmp
End Sub

#End Region

#Region --- Mantenimiento ---

'Compacta el archivo de base de datos y libera el espacio de registros borrados.
'Devuelve "tamañoAntes/tamañoDespués" en bytes.
Public Sub VacuumDB(SQL As SQL, DBFolder As String, FileName As String) As String
	Dim before As Long = File.Size(DBFolder, FileName)
	SQL.ExecNonQuery("VACUUM")
	Dim after As Long = File.Size(DBFolder, FileName)
	Return before & "/" & after
End Sub

#End Region