B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Unico modulo que escribe solicitudes, piezas, adjuntos y medidas en SQLite.
' Todo en una transaccion y encolado para sincronizar: si algo falla, no queda nada.
Sub Process_Globals
	Private Const SQL_SOLICITUD As String = "INSERT INTO solicitudes (uuid_local, cliente_uuid, cliente_contacto_uuid, nombre_proyecto, descripcion, observaciones, fecha_captura, completa, estado_sync) VALUES (?, ?, ?, ?, ?, ?, ?, 1, 'pendiente')"
	Private Const SQL_PIEZA As String = "INSERT INTO piezas (uuid_local, solicitud_uuid, nombre, tipo_trabajo_id, tipo_material_id, acabado_id, orden, estado_sync) VALUES (?, ?, ?, ?, ?, ?, ?, 'pendiente')"
	Private Const SQL_ADJUNTO As String = "INSERT INTO adjuntos (uuid_local, pieza_uuid, tipo, ruta_archivo, contenido_json, mime, estado_sync) VALUES (?, ?, ?, ?, ?, ?, 'pendiente')"
	Private Const SQL_MEDIDA As String = "INSERT INTO medidas (uuid_local, pieza_uuid, croquis_uuid, etiqueta, tipo_medida, valor, cantidad, unidad_medida, orden, estado_sync) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'pendiente')"
	Private Const TIPO_CROQUIS As String = "croquis"
	Private Const TIPO_FOTO As String = "foto"
	Private Const MIME_CROQUIS As String = "application/json"
	Private Const MIME_FOTO As String = "image/jpeg"
	Private Const UNIDAD_POR_DEFECTO As String = "cm"
End Sub

Public Sub Guardar (s As Solicitud, Piezas As List) As String
	Dim conexion As SQL = Db.DbSQL
	Dim uPiezas, uAdjuntos, uMedidas As List
	uPiezas.Initialize
	uAdjuntos.Initialize
	uMedidas.Initialize
	Dim ok As Boolean = False

	conexion.BeginTransaction
	Try
		conexion.ExecNonQuery2(SQL_SOLICITUD, Array As Object(s.UuidLocal, s.ClienteUuid, Nulo(s.ContactoUuid), _
			Nulo(s.NombreProyecto), s.Descripcion, Nulo(s.Observaciones), Utils.AhoraBd))
		For i = 0 To Piezas.Size - 1
			Dim p As Pieza = Piezas.Get(i)
			conexion.ExecNonQuery2(SQL_PIEZA, Array As Object(p.UuidLocal, s.UuidLocal, p.Nombre, _
				IdONulo(p.TipoTrabajoId), IdONulo(p.TipoMaterialId), IdONulo(p.AcabadoId), i))
			uPiezas.Add(p.UuidLocal)

			Dim croquis As Object = Null
			If p.CroquisJson <> "" Then
				croquis = Db.NuevoUuid
				conexion.ExecNonQuery2(SQL_ADJUNTO, Array As Object(croquis, p.UuidLocal, TIPO_CROQUIS, Null, p.CroquisJson, MIME_CROQUIS))
				uAdjuntos.Add(croquis)
			End If
			For Each nombre As String In p.ListaFotos
				Dim uFoto As String = Db.NuevoUuid
				conexion.ExecNonQuery2(SQL_ADJUNTO, Array As Object(uFoto, p.UuidLocal, TIPO_FOTO, _
					File.Combine(Adjuntos.CarpetaFotos, nombre), Null, MIME_FOTO))
				uAdjuntos.Add(uFoto)
			Next
			For Each m As MedidaPieza In p.ListaMedidas
				Dim uMedida As String = Db.NuevoUuid
				Dim unidad As String = m.Unidad
				If unidad = "" Then unidad = UNIDAD_POR_DEFECTO
				conexion.ExecNonQuery2(SQL_MEDIDA, Array As Object(uMedida, p.UuidLocal, croquis, m.Etiqueta, _
					m.TipoMedida, m.Valor, Max(1, m.Cantidad), unidad, m.Orden))
				uMedidas.Add(uMedida)
			Next
		Next
		Db.Encolar("solicitud", s.UuidLocal)
		Db.EncolarVarios("pieza", uPiezas)
		Db.EncolarVarios("adjunto", uAdjuntos)
		Db.EncolarVarios("medida", uMedidas)
		conexion.TransactionSuccessful
		ok = True
	Catch
		Log("DbSolicitudes.Guardar: " & LastException.Message)
	End Try
	conexion.EndTransaction

	If ok = False Then Return ""
	Return s.UuidLocal
End Sub

Private Sub Nulo (Valor As String) As Object
	If Valor = "" Then Return Null
	Return Valor
End Sub

Private Sub IdONulo (Id As Int) As Object
	If Id <= 0 Then Return Null
	Return Id
End Sub
