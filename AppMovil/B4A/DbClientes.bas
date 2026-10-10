B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Unico modulo que escribe clientes, contactos y firmas de consentimiento en
' SQLite. Todo en una transaccion: si algo falla, no queda nada a medias.
Sub Process_Globals
	Public Const CONSENT_VERSION As String = "v1"
	Private Const SQL_CLIENTE As String = "INSERT INTO clientes (uuid_local, nombre, identificacion, tipo_identificacion, telefono, correo, contacto, direccion, estado_sync) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pendiente')"
	Private Const SQL_CONTACTO As String = "INSERT INTO cliente_contactos (uuid_local, cliente_uuid, nombre, area, telefono, celular, correo, principal, consentimiento_estado, estado_sync) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pendiente', 'pendiente')"
	Private Const SQL_FIRMAR_CONTACTO As String = "UPDATE cliente_contactos SET consentimiento_estado = 'firmado', consentimiento_version = ?, consentimiento_fecha = ? WHERE uuid_local = ?"
	Private Const SQL_FIRMA As String = "INSERT INTO consentimiento_firmas (uuid_local, cliente_uuid, cliente_contacto_uuid, accion, version_texto, fecha, firmante_nombre, firmante_identificacion, firma, mime, estado_sync) VALUES (?, ?, ?, 'otorgado', ?, ?, ?, ?, ?, 'image/png', 'pendiente')"
	Private Const TIPOS_IDENTIFICACION As Int = 3
End Sub

Public Sub Guardar (c As Cliente, Contactos As List, Permiso As Consentimiento) As String
	Dim s As SQL = Db.DbSQL
	Dim ahora As String = Utils.AhoraBd
	Dim uFirma As String = Db.NuevoUuid
	Dim titular As Object = UuidDeFirmante(Contactos, Permiso.Firmante)
	Dim uuids As List
	uuids.Initialize
	Dim ok As Boolean = False

	s.BeginTransaction
	Try
		s.ExecNonQuery2(SQL_CLIENTE, Array As Object(c.UuidLocal, c.Nombre, c.Identificacion, _
			TipoIdentificacion(c.TipoIdentificacion), c.Telefono, c.CorreoCobro, c.ContactoCobro, c.Direccion))
		For Each k As Contacto In Contactos
			s.ExecNonQuery2(SQL_CONTACTO, Array As Object(k.UuidLocal, c.UuidLocal, k.Nombre, k.Puesto, _
				k.Telefono, k.Celular, k.Correo, IIf(k.Principal, 1, 0)))
			uuids.Add(k.UuidLocal)
		Next
		If titular <> Null Then s.ExecNonQuery2(SQL_FIRMAR_CONTACTO, Array As Object(CONSENT_VERSION, ahora, titular))
		s.ExecNonQuery2(SQL_FIRMA, Array As Object(uFirma, c.UuidLocal, titular, CONSENT_VERSION, ahora, _
			Permiso.Firmante, Permiso.CedulaFirmante, Permiso.Firma))
		Db.Encolar("cliente", c.UuidLocal)
		Db.EncolarVarios("contacto", uuids)
		Db.Encolar("firma", uFirma)
		s.TransactionSuccessful
		ok = True
	Catch
		Log("DbClientes.Guardar: " & LastException.Message)
	End Try
	s.EndTransaction

	If ok = False Then Return ""
	Return c.UuidLocal
End Sub

Private Sub UuidDeFirmante (Contactos As List, Nombre As String) As Object
	Dim buscado As String = Nombre.Trim.ToLowerCase
	If buscado = "" Then Return Null
	For Each k As Contacto In Contactos
		If k.Nombre.Trim.ToLowerCase = buscado Then Return k.UuidLocal
	Next
	Return Null
End Sub

Private Sub TipoIdentificacion (IndiceCombo As Int) As Object
	If IndiceCombo < 0 Or IndiceCombo >= TIPOS_IDENTIFICACION Then Return Null
	Return IndiceCombo + 1
End Sub
