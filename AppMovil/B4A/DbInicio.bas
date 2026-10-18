B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' SQLite de la hoja de Inicio: las solicitudes recientes del asesor con su estado de subida y
' los indicadores del servidor, guardados en config para verlos sin conexion.
Sub Process_Globals
	Private Const CLAVE_INDICADORES As String = "indicadores"
	Private Const CLAVE_SOLICITUDES_MES As String = "solicitudes_mes"
	Private Const CLAVE_ESPERANDO As String = "esperando_cotizacion"
	Private Const CLAVE_APROBADAS_MES As String = "aprobadas_mes"
	Private Const CLAVE_MONTO_MES As String = "monto_aprobado_mes"
	Private Const SQL_RECIENTES As String = "SELECT COALESCE(NULLIF(TRIM(s.nombre_proyecto), ''), s.descripcion) AS proyecto, COALESCE(c.nombre, '') AS cliente, s.fecha_captura, CASE WHEN EXISTS (SELECT 1 FROM cola_sync q WHERE q.estado = 'error' AND (q.uuid_local IN (s.uuid_local, s.cliente_uuid) OR q.uuid_local IN (SELECT a.uuid_local FROM adjuntos a JOIN piezas p ON p.uuid_local = a.pieza_uuid WHERE p.solicitud_uuid = s.uuid_local))) THEN 'error' WHEN s.estado_sync <> 'confirmado' OR EXISTS (SELECT 1 FROM cola_sync q JOIN adjuntos a ON a.uuid_local = q.uuid_local JOIN piezas p ON p.uuid_local = a.pieza_uuid WHERE p.solicitud_uuid = s.uuid_local) THEN 'pendiente' ELSE 'confirmado' END AS estado FROM solicitudes s LEFT JOIN clientes c ON c.uuid_local = s.cliente_uuid WHERE s.fecha_captura >= ? OR s.estado_sync <> 'confirmado' ORDER BY s.fecha_captura DESC LIMIT 20"
End Sub

Public Sub GuardarIndicadores (Datos As Map)
	Dim jg As JSONGenerator
	jg.Initialize(Datos)
	Db.GuardarConfig(CLAVE_INDICADORES, jg.ToString)
End Sub

Public Sub Indicadores As IndicadoresAsesor
	Dim r As IndicadoresAsesor
	r.Initialize
	Dim texto As String = Db.LeerConfig(CLAVE_INDICADORES)
	If texto = "" Then Return r
	Try
		Dim jp As JSONParser
		jp.Initialize(texto)
		Dim m As Map = jp.NextObject
		r.SolicitudesMes = m.GetDefault(CLAVE_SOLICITUDES_MES, 0)
		r.EsperandoCotizacion = m.GetDefault(CLAVE_ESPERANDO, 0)
		r.AprobadasMes = m.GetDefault(CLAVE_APROBADAS_MES, 0)
		r.MontoAprobadoMes = m.GetDefault(CLAVE_MONTO_MES, 0)
		r.HayDatos = m.Size > 0
	Catch
		Log("DbInicio.Indicadores: " & LastException.Message)
	End Try
	Return r
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
