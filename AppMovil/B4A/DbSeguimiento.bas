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
	Public Const ESTADO_CAPTURADA As String = "capturada"
	Public Const ESTADO_RECIBIDA As String = "recibida"
	Public Const ESTADO_EN_COTIZACION As String = "en_cotizacion"
	Public Const ESTADO_DESCARTADA As String = "descartada"
	Public Const ESTADO_BORRADOR As String = "borrador"
	Public Const ESTADO_PENDIENTE As String = "pendiente"
	Public Const ESTADO_DEVUELTA As String = "devuelta"
	Public Const ESTADO_VISTO_BUENO As String = "visto_bueno"
	Public Const ESTADO_APROBADA As String = "aprobada"
	Public Const ESTADO_RECHAZADA As String = "rechazada"
	Public Const ESTADO_ENVIADA As String = "enviada"
	Private Const SQL_LISTA As String = "SELECT uuid_local, proyecto, cliente, fecha, estado, monto FROM (SELECT g.uuid_local, COALESCE(NULLIF(TRIM(g.nombre_proyecto), ''), g.descripcion, '') AS proyecto, COALESCE(g.cliente_nombre, '') AS cliente, g.fecha_captura AS fecha, g.estado, g.monto_aprobado AS monto FROM seguimiento g UNION ALL SELECT s.uuid_local, COALESCE(NULLIF(TRIM(s.nombre_proyecto), ''), s.descripcion), COALESCE(c.nombre, ''), s.fecha_captura, CASE WHEN s.estado_sync = 'confirmado' THEN 'recibida' ELSE 'por_subir' END, NULL FROM solicitudes s LEFT JOIN clientes c ON c.uuid_local = s.cliente_uuid WHERE NOT EXISTS (SELECT 1 FROM seguimiento g WHERE g.uuid_local = s.uuid_local)) WHERE fecha >= ? AND fecha < ? ORDER BY fecha DESC"
End Sub

Public Sub Lista (Desde As String, Hasta As String) As List
	Dim res As List
	res.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_LISTA, Array As String(Desde, Hasta))
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
