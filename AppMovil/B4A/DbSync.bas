B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Unico modulo que lee y escribe la cola de sincronizacion en SQLite: arma cada unidad
' (cliente, solicitud con sus piezas, foto), confirma lo aceptado y marca errores y reintentos.
Sub Process_Globals
	Public Const CLASE_CLIENTE As String = "cliente"
	Public Const CLASE_SOLICITUD As String = "solicitud"
	Public Const CLASE_FOTO As String = "foto"
	Public Const ESTADO_PENDIENTE As String = "pendiente"
	Public Const ESTADO_ERROR As String = "error"
	Public Const ESTADO_CONFIRMADO As String = "confirmado"
	Private Const ENTIDAD_ADJUNTO As String = "adjunto"
	Private Const ORIGEN_MOVIL As String = "movil"
	Private Const NOMBRE_CROQUIS As String = "croquis.json"
	Private Const MINUTOS_MAXIMOS As Int = 60

	Private Const SQL_PENDIENTES As String = "SELECT count(*) FROM cola_sync q LEFT JOIN adjuntos a ON a.uuid_local = q.uuid_local WHERE q.estado = ? AND (q.entidad IN ('cliente', 'solicitud') OR (q.entidad = 'adjunto' AND a.tipo = 'foto'))"
	Private Const SQL_CLIENTES_LISTOS As String = "SELECT uuid_local FROM cola_sync WHERE entidad = 'cliente' AND estado = 'pendiente' AND (proximo_intento IS NULL OR proximo_intento <= ?) ORDER BY id"
	Private Const SQL_SOLICITUDES_LISTAS As String = "SELECT q.uuid_local FROM cola_sync q JOIN solicitudes s ON s.uuid_local = q.uuid_local WHERE q.entidad = 'solicitud' AND q.estado = 'pendiente' AND (q.proximo_intento IS NULL OR q.proximo_intento <= ?) AND NOT EXISTS (SELECT 1 FROM cola_sync c WHERE c.entidad = 'cliente' AND c.uuid_local = s.cliente_uuid) ORDER BY q.id"
	Private Const SQL_FOTOS_LISTAS As String = "SELECT q.uuid_local, s.id_servidor, p.uuid_local AS pieza_uuid, a.ruta_archivo, a.mime FROM cola_sync q JOIN adjuntos a ON a.uuid_local = q.uuid_local JOIN piezas p ON p.uuid_local = a.pieza_uuid JOIN solicitudes s ON s.uuid_local = p.solicitud_uuid WHERE q.entidad = 'adjunto' AND a.tipo = 'foto' AND q.estado = 'pendiente' AND (q.proximo_intento IS NULL OR q.proximo_intento <= ?) AND s.id_servidor IS NOT NULL ORDER BY q.id"

	Private Const SQL_CLIENTE As String = "SELECT uuid_local, nombre, identificacion, tipo_identificacion, contacto, telefono, correo, direccion, latitud, longitud FROM clientes WHERE uuid_local = ?"
	Private Const SQL_CONTACTOS As String = "SELECT uuid_local, nombre, area, telefono, celular, correo, principal FROM cliente_contactos WHERE cliente_uuid = ? ORDER BY principal DESC, nombre"
	Private Const SQL_FIRMA As String = "SELECT cliente_contacto_uuid, accion, version_texto, fecha, firmante_nombre, firmante_identificacion, firma, mime FROM consentimiento_firmas WHERE cliente_uuid = ? ORDER BY fecha DESC LIMIT 1"
	Private Const SQL_SOLICITUD As String = "SELECT uuid_local, cliente_uuid, cliente_contacto_uuid, nombre_proyecto, descripcion, observaciones, fecha_captura FROM solicitudes WHERE uuid_local = ?"
	Private Const SQL_PIEZAS As String = "SELECT uuid_local, nombre, orden, tipo_trabajo_id, tipo_material_id, acabado_id FROM piezas WHERE solicitud_uuid = ? ORDER BY orden"
	Private Const SQL_MEDIDAS As String = "SELECT uuid_local, etiqueta, tipo_medida, valor, unidad_medida, cantidad, orden FROM medidas WHERE pieza_uuid = ? ORDER BY orden"
	Private Const SQL_CROQUIS As String = "SELECT uuid_local, contenido_json FROM adjuntos WHERE pieza_uuid = ? AND tipo = 'croquis'"

	Private Const SQL_CONFIRMAR_CLIENTE As String = "UPDATE clientes SET id_servidor = ?, estado_sync = 'confirmado' WHERE uuid_local = ?"
	Private Const SQL_CONFIRMAR_CONTACTOS As String = "UPDATE cliente_contactos SET estado_sync = 'confirmado' WHERE cliente_uuid = ?"
	Private Const SQL_CONFIRMAR_FIRMAS As String = "UPDATE consentimiento_firmas SET estado_sync = 'confirmado' WHERE cliente_uuid = ?"
	Private Const SQL_SACAR_CLIENTE As String = "DELETE FROM cola_sync WHERE (entidad = 'cliente' AND uuid_local = ?) OR (entidad = 'contacto' AND uuid_local IN (SELECT uuid_local FROM cliente_contactos WHERE cliente_uuid = ?)) OR (entidad = 'firma' AND uuid_local IN (SELECT uuid_local FROM consentimiento_firmas WHERE cliente_uuid = ?))"
	Private Const SQL_CONFIRMAR_SOLICITUD As String = "UPDATE solicitudes SET id_servidor = ?, estado_sync = 'confirmado' WHERE uuid_local = ?"
	Private Const SQL_CONFIRMAR_PIEZAS As String = "UPDATE piezas SET estado_sync = 'confirmado' WHERE solicitud_uuid = ?"
	Private Const SQL_CONFIRMAR_MEDIDAS As String = "UPDATE medidas SET estado_sync = 'confirmado' WHERE pieza_uuid IN (SELECT uuid_local FROM piezas WHERE solicitud_uuid = ?)"
	Private Const SQL_CONFIRMAR_CROQUIS As String = "UPDATE adjuntos SET estado_sync = 'confirmado' WHERE tipo = 'croquis' AND pieza_uuid IN (SELECT uuid_local FROM piezas WHERE solicitud_uuid = ?)"
	Private Const SQL_SACAR_SOLICITUD As String = "DELETE FROM cola_sync WHERE (entidad = 'solicitud' AND uuid_local = ?) OR (entidad = 'pieza' AND uuid_local IN (SELECT uuid_local FROM piezas WHERE solicitud_uuid = ?)) OR (entidad = 'medida' AND uuid_local IN (SELECT m.uuid_local FROM medidas m JOIN piezas p ON p.uuid_local = m.pieza_uuid WHERE p.solicitud_uuid = ?)) OR (entidad = 'adjunto' AND uuid_local IN (SELECT a.uuid_local FROM adjuntos a JOIN piezas p ON p.uuid_local = a.pieza_uuid WHERE a.tipo = 'croquis' AND p.solicitud_uuid = ?))"
	Private Const SQL_CONFIRMAR_FOTO As String = "UPDATE adjuntos SET estado_sync = 'confirmado' WHERE uuid_local = ?"
	Private Const SQL_SACAR_FOTO As String = "DELETE FROM cola_sync WHERE entidad = 'adjunto' AND uuid_local = ?"
	Private Const SQL_ERROR As String = "UPDATE cola_sync SET estado = 'error', ultimo_error = ? WHERE entidad = ? AND uuid_local = ?"
	Private Const SQL_REPROGRAMAR As String = "UPDATE cola_sync SET intentos = intentos + 1, proximo_intento = ? WHERE entidad = ? AND uuid_local = ?"
	Private Const SQL_INTENTOS As String = "SELECT intentos FROM cola_sync WHERE entidad = ? AND uuid_local = ?"
	Private Const SQL_REINTENTAR_ERRORES As String = "UPDATE cola_sync SET estado = 'pendiente', proximo_intento = NULL WHERE estado = 'error'"
	Private Const SQL_LIBERAR_ESPERAS As String = "UPDATE cola_sync SET proximo_intento = NULL WHERE estado = 'pendiente'"
End Sub

Public Sub Pendientes As Int
	Return Db.DbSQL.ExecQuerySingleResult2(SQL_PENDIENTES, Array As String("pendiente"))
End Sub

Public Sub ConError As Int
	Return Db.DbSQL.ExecQuerySingleResult2(SQL_PENDIENTES, Array As String("error"))
End Sub

Public Sub ReintentarTodo
	Db.DbSQL.ExecNonQuery(SQL_REINTENTAR_ERRORES)
	Db.DbSQL.ExecNonQuery(SQL_LIBERAR_ESPERAS)
End Sub

Public Sub Listas (Clase As String) As List
	Dim res As List
	res.Initialize
	Dim ahora As String = Utils.AhoraBd
	Select Clase
		Case CLASE_CLIENTE
			For Each u As String In Uuids(SQL_CLIENTES_LISTOS, ahora)
				res.Add(Unidad(Clase, u, PaqueteCliente(u), 0, ""))
			Next
		Case CLASE_SOLICITUD
			For Each u As String In Uuids(SQL_SOLICITUDES_LISTAS, ahora)
				res.Add(Unidad(Clase, u, PaqueteSolicitud(u), 0, ""))
			Next
		Case CLASE_FOTO
			Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_FOTOS_LISTAS, Array As String(ahora))
			Do While rs.NextRow
				Dim uuid As String = rs.GetString("uuid_local")
				Dim ruta As String = Texto(rs.GetString("ruta_archivo"))
				Dim paquete As Map = CreateMap("uuid_local": uuid, "pieza_uuid": rs.GetString("pieza_uuid"), _
					"tipo": CLASE_FOTO, "nombre_archivo": NombreDe(ruta), "mime": rs.GetString("mime"))
				res.Add(Unidad(Clase, uuid, paquete, rs.GetInt("id_servidor"), ruta))
			Loop
			rs.Close
	End Select
	Return res
End Sub

Private Sub Unidad (Clase As String, Uuid As String, Paquete As Map, SolicitudId As Int, Ruta As String) As UnidadSync
	Dim u As UnidadSync
	u.Initialize
	u.Clase = Clase
	u.Uuid = Uuid
	u.Paquete = Paquete
	u.SolicitudId = SolicitudId
	u.Ruta = Ruta
	Return u
End Sub

Private Sub Uuids (Consulta As String, Ahora As String) As List
	Dim res As List
	res.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(Consulta, Array As String(Ahora))
	Do While rs.NextRow
		res.Add(rs.GetString("uuid_local"))
	Loop
	rs.Close
	Return res
End Sub

Private Sub PaqueteCliente (Uuid As String) As Map
	Dim datosCliente As Map
	datosCliente.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_CLIENTE, Array As String(Uuid))
	If rs.NextRow Then
		For Each col As String In Array As String("uuid_local", "nombre", "identificacion", "contacto", "telefono", "correo", "direccion")
			datosCliente.Put(col, rs.GetString(col))
		Next
		datosCliente.Put("tipo_identificacion", Entero(rs, "tipo_identificacion"))
		datosCliente.Put("latitud", Real(rs, "latitud"))
		datosCliente.Put("longitud", Real(rs, "longitud"))
	End If
	rs.Close

	Dim contactos As List
	contactos.Initialize
	rs = Db.DbSQL.ExecQuery2(SQL_CONTACTOS, Array As String(Uuid))
	Do While rs.NextRow
		contactos.Add(CreateMap("uuid_local": rs.GetString("uuid_local"), "nombre": rs.GetString("nombre"), _
			"area": rs.GetString("area"), "telefono": rs.GetString("telefono"), "celular": rs.GetString("celular"), _
			"correo": rs.GetString("correo"), "principal": rs.GetInt("principal") = 1))
	Loop
	rs.Close

	Dim datosFirma As Map
	datosFirma.Initialize
	rs = Db.DbSQL.ExecQuery2(SQL_FIRMA, Array As String(Uuid))
	If rs.NextRow Then
		Dim su As StringUtils
		datosFirma.Put("cliente_contacto_uuid", rs.GetString("cliente_contacto_uuid"))
		datosFirma.Put("accion", rs.GetString("accion"))
		datosFirma.Put("version_texto", rs.GetString("version_texto"))
		datosFirma.Put("fecha", Utils.BdAApi(rs.GetString("fecha")))
		datosFirma.Put("firmante_nombre", Texto(rs.GetString("firmante_nombre")))
		datosFirma.Put("firmante_identificacion", Texto(rs.GetString("firmante_identificacion")))
		datosFirma.Put("firma_base_64", su.EncodeBase64(rs.GetBlob("firma")))
		datosFirma.Put("firma_mime", rs.GetString("mime"))
		datosFirma.Put("origen", ORIGEN_MOVIL)
	End If
	rs.Close

	Return CreateMap("cliente": datosCliente, "contactos": contactos, "firma": datosFirma)
End Sub

Private Sub PaqueteSolicitud (Uuid As String) As Map
	Dim datosSolicitud As Map
	datosSolicitud.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_SOLICITUD, Array As String(Uuid))
	If rs.NextRow Then
		For Each col As String In Array As String("uuid_local", "cliente_uuid", "cliente_contacto_uuid", "nombre_proyecto", "descripcion", "observaciones")
			datosSolicitud.Put(col, rs.GetString(col))
		Next
		datosSolicitud.Put("fecha_captura", Utils.BdAApi(rs.GetString("fecha_captura")))
	End If
	rs.Close

	Dim piezas As List
	piezas.Initialize
	rs = Db.DbSQL.ExecQuery2(SQL_PIEZAS, Array As String(Uuid))
	Do While rs.NextRow
		Dim uPieza As String = rs.GetString("uuid_local")
		piezas.Add(CreateMap("uuid_local": uPieza, "nombre": rs.GetString("nombre"), "orden": rs.GetInt("orden"), _
			"tipo_trabajo_id": Entero(rs, "tipo_trabajo_id"), "tipo_material_id": Entero(rs, "tipo_material_id"), _
			"acabado_id": Entero(rs, "acabado_id"), "medidas": MedidasDe(uPieza), "adjuntos": CroquisDe(uPieza)))
	Loop
	rs.Close

	Return CreateMap("solicitud": datosSolicitud, "piezas": piezas)
End Sub

Private Sub MedidasDe (Pieza As String) As List
	Dim res As List
	res.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_MEDIDAS, Array As String(Pieza))
	Do While rs.NextRow
		res.Add(CreateMap("uuid_local": rs.GetString("uuid_local"), "etiqueta": rs.GetString("etiqueta"), _
			"tipo_medida": rs.GetString("tipo_medida"), "valor": rs.GetDouble("valor"), _
			"unidad_medida": rs.GetString("unidad_medida"), "cantidad": rs.GetInt("cantidad"), "orden": rs.GetInt("orden")))
	Loop
	rs.Close
	Return res
End Sub

Private Sub CroquisDe (Pieza As String) As List
	Dim res As List
	res.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_CROQUIS, Array As String(Pieza))
	Do While rs.NextRow
		res.Add(CreateMap("uuid_local": rs.GetString("uuid_local"), "tipo": "croquis", _
			"nombre_archivo": NOMBRE_CROQUIS, "contenido_json": rs.GetString("contenido_json")))
	Loop
	rs.Close
	Return res
End Sub

Public Sub Confirmar (u As UnidadSync, IdServidor As Int)
	Dim s As SQL = Db.DbSQL
	s.BeginTransaction
	Try
		Select u.Clase
			Case CLASE_CLIENTE
				s.ExecNonQuery2(SQL_CONFIRMAR_CLIENTE, Array As Object(IdServidor, u.Uuid))
				s.ExecNonQuery2(SQL_CONFIRMAR_CONTACTOS, Array As Object(u.Uuid))
				s.ExecNonQuery2(SQL_CONFIRMAR_FIRMAS, Array As Object(u.Uuid))
				s.ExecNonQuery2(SQL_SACAR_CLIENTE, Array As Object(u.Uuid, u.Uuid, u.Uuid))
			Case CLASE_SOLICITUD
				s.ExecNonQuery2(SQL_CONFIRMAR_SOLICITUD, Array As Object(IdServidor, u.Uuid))
				s.ExecNonQuery2(SQL_CONFIRMAR_PIEZAS, Array As Object(u.Uuid))
				s.ExecNonQuery2(SQL_CONFIRMAR_MEDIDAS, Array As Object(u.Uuid))
				s.ExecNonQuery2(SQL_CONFIRMAR_CROQUIS, Array As Object(u.Uuid))
				s.ExecNonQuery2(SQL_SACAR_SOLICITUD, Array As Object(u.Uuid, u.Uuid, u.Uuid, u.Uuid))
			Case CLASE_FOTO
				s.ExecNonQuery2(SQL_CONFIRMAR_FOTO, Array As Object(u.Uuid))
				s.ExecNonQuery2(SQL_SACAR_FOTO, Array As Object(u.Uuid))
		End Select
		s.TransactionSuccessful
	Catch
		Log("DbSync.Confirmar: " & LastException.Message)
	End Try
	s.EndTransaction
End Sub

Public Sub MarcarError (u As UnidadSync, Mensaje As String)
	Db.DbSQL.ExecNonQuery2(SQL_ERROR, Array As Object(Mensaje, EntidadDe(u), u.Uuid))
End Sub

Public Sub Reprogramar (u As UnidadSync)
	Dim intentos As Int = Db.DbSQL.ExecQuerySingleResult2(SQL_INTENTOS, Array As String(EntidadDe(u), u.Uuid))
	Dim minutos As Int = Min(MINUTOS_MAXIMOS, Power(2, intentos))
	Dim proximo As String = Utils.Formatear(DateTime.Now + minutos * DateTime.TicksPerMinute, Utils.FORMATO_BD)
	Db.DbSQL.ExecNonQuery2(SQL_REPROGRAMAR, Array As Object(proximo, EntidadDe(u), u.Uuid))
End Sub

Private Sub EntidadDe (u As UnidadSync) As String
	If u.Clase = CLASE_FOTO Then Return ENTIDAD_ADJUNTO
	Return u.Clase
End Sub

Private Sub Entero (rs As ResultSet, Columna As String) As Object
	Dim v As String = rs.GetString(Columna)
	If v = Null Or v = "" Then Return Null
	Return rs.GetInt(Columna)
End Sub

Private Sub Real (rs As ResultSet, Columna As String) As Object
	Dim v As String = rs.GetString(Columna)
	If v = Null Or v = "" Then Return Null
	Return rs.GetDouble(Columna)
End Sub

Private Sub Texto (Valor As String) As String
	If Valor = Null Then Return ""
	Return Valor
End Sub

Private Sub NombreDe (Ruta As String) As String
	Dim i As Int = Ruta.LastIndexOf("/")
	If i < 0 Then Return Ruta
	Return Ruta.SubString(i + 1)
End Sub
