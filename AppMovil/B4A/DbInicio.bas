B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Lecturas de SQLite para la hoja de Inicio: las solicitudes recientes del asesor
' con su estado de subida. No escribe nada.
Sub Process_Globals
	Private Const SQL_RECIENTES As String = "SELECT COALESCE(NULLIF(TRIM(s.nombre_proyecto), ''), s.descripcion) AS proyecto, COALESCE(c.nombre, '') AS cliente, s.fecha_captura, CASE WHEN EXISTS (SELECT 1 FROM cola_sync q WHERE q.estado = 'error' AND (q.uuid_local IN (s.uuid_local, s.cliente_uuid) OR q.uuid_local IN (SELECT a.uuid_local FROM adjuntos a JOIN piezas p ON p.uuid_local = a.pieza_uuid WHERE p.solicitud_uuid = s.uuid_local))) THEN 'error' WHEN s.estado_sync <> 'confirmado' OR EXISTS (SELECT 1 FROM cola_sync q JOIN adjuntos a ON a.uuid_local = q.uuid_local JOIN piezas p ON p.uuid_local = a.pieza_uuid WHERE p.solicitud_uuid = s.uuid_local) THEN 'pendiente' ELSE 'confirmado' END AS estado FROM solicitudes s LEFT JOIN clientes c ON c.uuid_local = s.cliente_uuid WHERE s.fecha_captura >= ? OR s.estado_sync <> 'confirmado' ORDER BY s.fecha_captura DESC LIMIT 20"
End Sub

Public Sub Recientes (Desde As String) As List
	Dim res As List
	res.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_RECIENTES, Array As String(Desde))
	Do While rs.NextRow
		Dim r As SolicitudReciente
		r.Initialize
		r.Proyecto = rs.GetString("proyecto")
		r.Cliente = rs.GetString("cliente")
		r.Fecha = rs.GetString("fecha_captura")
		r.EstadoSync = rs.GetString("estado")
		res.Add(r)
	Loop
	rs.Close
	Return res
End Sub
