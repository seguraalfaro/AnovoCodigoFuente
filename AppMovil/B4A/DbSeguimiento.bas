B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Lecturas de SQLite para la pestana Solicitudes: el seguimiento que bajo del servidor y las
' solicitudes del telefono que el servidor todavia no devolvio. No escribe nada.
Sub Process_Globals
	Public Const ESTADO_POR_SUBIR As String = "por_subir"
	Private Const SQL_LISTA As String = "SELECT uuid_local, proyecto, cliente, fecha, estado, monto FROM (SELECT g.uuid_local, COALESCE(NULLIF(TRIM(g.nombre_proyecto), ''), g.descripcion, '') AS proyecto, COALESCE(g.cliente_nombre, '') AS cliente, g.fecha_captura AS fecha, g.estado, g.monto_aprobado AS monto FROM seguimiento g UNION ALL SELECT s.uuid_local, COALESCE(NULLIF(TRIM(s.nombre_proyecto), ''), s.descripcion), COALESCE(c.nombre, ''), s.fecha_captura, CASE WHEN s.estado_sync = 'confirmado' THEN 'recibida' ELSE 'por_subir' END, NULL FROM solicitudes s LEFT JOIN clientes c ON c.uuid_local = s.cliente_uuid WHERE NOT EXISTS (SELECT 1 FROM seguimiento g WHERE g.uuid_local = s.uuid_local)) WHERE fecha >= ? ORDER BY fecha DESC"
End Sub

Public Sub Lista (Desde As String) As List
	Dim res As List
	res.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_LISTA, Array As String(Desde))
	Do While rs.NextRow
		Dim f As SeguimientoFila
		f.Initialize
		f.Uuid = rs.GetString("uuid_local")
		f.Proyecto = rs.GetString("proyecto")
		f.Cliente = rs.GetString("cliente")
		f.Fecha = rs.GetString("fecha")
		f.Estado = rs.GetString("estado")
		If rs.GetString("monto") <> Null Then f.Monto = rs.GetDouble("monto")
		res.Add(f)
	Loop
	rs.Close
	Return res
End Sub
