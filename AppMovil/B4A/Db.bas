B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.

Sub Process_Globals
	Private kvsBorradores As KeyValueStore
	Public DbSQL As SQL
	Private Const SQL_FOTOS_SUBIDAS As String = "SELECT ruta_archivo FROM adjuntos WHERE tipo = 'foto' AND ruta_archivo IS NOT NULL AND pieza_uuid IN (SELECT uuid_local FROM piezas WHERE solicitud_uuid IN (SELECT s.uuid_local FROM solicitudes s WHERE s.estado_sync = 'confirmado' AND NOT EXISTS (SELECT 1 FROM piezas p WHERE p.solicitud_uuid = s.uuid_local AND p.estado_sync <> 'confirmado') AND NOT EXISTS (SELECT 1 FROM piezas p JOIN adjuntos a ON a.pieza_uuid = p.uuid_local WHERE p.solicitud_uuid = s.uuid_local AND a.estado_sync <> 'confirmado')))"
	Private Const SQL_BORRAR_MEDIDAS As String = "DELETE FROM medidas WHERE pieza_uuid IN (SELECT uuid_local FROM piezas WHERE solicitud_uuid IN (SELECT s.uuid_local FROM solicitudes s WHERE s.estado_sync = 'confirmado' AND NOT EXISTS (SELECT 1 FROM piezas p WHERE p.solicitud_uuid = s.uuid_local AND p.estado_sync <> 'confirmado') AND NOT EXISTS (SELECT 1 FROM piezas p JOIN adjuntos a ON a.pieza_uuid = p.uuid_local WHERE p.solicitud_uuid = s.uuid_local AND a.estado_sync <> 'confirmado')))"
	Private Const SQL_BORRAR_ADJUNTOS As String = "DELETE FROM adjuntos WHERE pieza_uuid IN (SELECT uuid_local FROM piezas WHERE solicitud_uuid IN (SELECT s.uuid_local FROM solicitudes s WHERE s.estado_sync = 'confirmado' AND NOT EXISTS (SELECT 1 FROM piezas p WHERE p.solicitud_uuid = s.uuid_local AND p.estado_sync <> 'confirmado') AND NOT EXISTS (SELECT 1 FROM piezas p JOIN adjuntos a ON a.pieza_uuid = p.uuid_local WHERE p.solicitud_uuid = s.uuid_local AND a.estado_sync <> 'confirmado')))"
	Private Const SQL_BORRAR_PIEZAS As String = "DELETE FROM piezas WHERE solicitud_uuid IN (SELECT s.uuid_local FROM solicitudes s WHERE s.estado_sync = 'confirmado' AND NOT EXISTS (SELECT 1 FROM piezas p WHERE p.solicitud_uuid = s.uuid_local AND p.estado_sync <> 'confirmado') AND NOT EXISTS (SELECT 1 FROM piezas p JOIN adjuntos a ON a.pieza_uuid = p.uuid_local WHERE p.solicitud_uuid = s.uuid_local AND a.estado_sync <> 'confirmado'))"
	Private Const SQL_BORRAR_SOLICITUDES As String = "DELETE FROM solicitudes WHERE uuid_local IN (SELECT s.uuid_local FROM solicitudes s WHERE s.estado_sync = 'confirmado' AND NOT EXISTS (SELECT 1 FROM piezas p WHERE p.solicitud_uuid = s.uuid_local AND p.estado_sync <> 'confirmado') AND NOT EXISTS (SELECT 1 FROM piezas p JOIN adjuntos a ON a.pieza_uuid = p.uuid_local WHERE p.solicitud_uuid = s.uuid_local AND a.estado_sync <> 'confirmado'))"
	Private Const SQL_BORRAR_SEGUIMIENTO As String = "DELETE FROM seguimiento"
	Private Const SQL_BORRAR_CLIENTES As String = "DELETE FROM clientes WHERE estado_sync = 'confirmado' AND NOT EXISTS (SELECT 1 FROM cola_sync q WHERE q.entidad = 'cliente' AND q.uuid_local = clientes.uuid_local) AND NOT EXISTS (SELECT 1 FROM cliente_contactos k WHERE k.cliente_uuid = clientes.uuid_local AND k.estado_sync <> 'confirmado') AND NOT EXISTS (SELECT 1 FROM consentimiento_firmas f WHERE f.cliente_uuid = clientes.uuid_local AND f.estado_sync <> 'confirmado') AND NOT EXISTS (SELECT 1 FROM solicitudes s WHERE s.cliente_uuid = clientes.uuid_local)"
	Private Const SQL_BORRAR_CONTACTOS As String = "DELETE FROM cliente_contactos WHERE NOT EXISTS (SELECT 1 FROM clientes c WHERE c.uuid_local = cliente_contactos.cliente_uuid)"
	Private Const SQL_BORRAR_FIRMAS As String = "DELETE FROM consentimiento_firmas WHERE NOT EXISTS (SELECT 1 FROM clientes c WHERE c.uuid_local = consentimiento_firmas.cliente_uuid)"
	Private Const SQL_BORRAR_BAJADA As String = "DELETE FROM config WHERE clave IN ('bajada_desde', 'bajada_hora')"
End Sub

#Region Apertura
'Llamado una vez desde Main.B4XPage_Created / arranque
Public Sub Inicializar
	kvsBorradores.Initialize(File.DirInternal, "borradores.dat")
	DbSQL = DbEsquema.Abrir
	DbPrueba.Cargar
End Sub
#End Region

#Region Borradores
'Tipo: "cliente" | "cotizacion" | "encargado" ...
Public Sub HayBorrador (Tipo As String) As Boolean
	Return kvsBorradores.ContainsKey(Tipo)
End Sub

Public Sub LeerBorrador (Tipo As String) As Map
	Return kvsBorradores.GetDefault(Tipo, CreateMap())
End Sub

Public Sub GuardarBorrador (Tipo As String, Datos As Map)
	Datos.Put("_guardado", DateTime.Now)
	kvsBorradores.Put(Tipo, Datos)
End Sub

Public Sub BorrarBorrador (Tipo As String)
	If kvsBorradores.ContainsKey(Tipo) Then kvsBorradores.Remove(Tipo)
End Sub
#End Region

#Region Cola de sincronización
'Marca una fila como pendiente de enviar al servidor.
'Entidad: cliente|contacto|firma|solicitud|adjunto|medida (CHECK de cola_sync).
Public Sub Encolar (Entidad As String, Uuid As String)
	Dim uno As List
	uno.Initialize
	uno.Add(Uuid)
	EncolarVarios(Entidad, uno)
End Sub

'Varias filas de la misma entidad en una sola pasada.
'Usa InsertMapsIn (sin transaccion propia) para poder ir dentro de la
'transaccion del alta y revertirse con ella si algo falla.
Public Sub EncolarVarios (Entidad As String, Uuids As List)
	If Uuids.IsInitialized = False Or Uuids.Size = 0 Then Return
	Dim ahora As String = Utils.AhoraBd
	Dim filas As List
	filas.Initialize
	For Each u As String In Uuids
		filas.Add(CreateMap("entidad": Entidad, "uuid_local": u, "fecha_encolado": ahora))
	Next
	extDBUtils.InsertMapsIn(DbSQL, "cola_sync", filas)
End Sub
#End Region

#Region Cierre de sesión
Public Sub BorrarLoSubido As List
	Dim rutas As List
	rutas.Initialize
	Dim s As SQL = DbSQL
	s.BeginTransaction
	Try
		Dim rs As ResultSet = s.ExecQuery(SQL_FOTOS_SUBIDAS)
		Do While rs.NextRow
			rutas.Add(rs.GetString("ruta_archivo"))
		Loop
		rs.Close
		For Each sentencia As String In Array As String(SQL_BORRAR_MEDIDAS, SQL_BORRAR_ADJUNTOS, SQL_BORRAR_PIEZAS, _
			SQL_BORRAR_SOLICITUDES, SQL_BORRAR_SEGUIMIENTO, SQL_BORRAR_CLIENTES, SQL_BORRAR_CONTACTOS, _
			SQL_BORRAR_FIRMAS, SQL_BORRAR_BAJADA)
			s.ExecNonQuery(sentencia)
		Next
		s.TransactionSuccessful
	Catch
		Log("Db.BorrarLoSubido: " & LastException.Message)
		rutas.Clear
	End Try
	s.EndTransaction
	Return rutas
End Sub
#End Region

#Region Utilidades
'Identificador local de cada fila. El servidor asigna despues su id_servidor.
Public Sub NuevoUuid As String
	Dim ju As JavaObject
	ju.InitializeStatic("java.util.UUID")
	Return ju.RunMethod("randomUUID", Null)
End Sub

#End Region
