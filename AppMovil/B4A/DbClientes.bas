B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Unico modulo que lee y escribe clientes, contactos y firmas de consentimiento
' en SQLite. Las escrituras van en una transaccion: si algo falla, no queda nada a medias.

Sub Process_Globals
	Private Const SQL_TEXTO_VIGENTE As String = "SELECT version, titulo, contenido FROM consentimiento_texto LIMIT 1"
	Private Const SQL_CLIENTE As String = "INSERT INTO clientes (uuid_local, nombre, identificacion, tipo_identificacion, telefono, correo, contacto, direccion, latitud, longitud, consentimiento_estado, estado_sync) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'firmado', 'pendiente')"
	Private Const SQL_CONSENTIMIENTO_DE As String = "SELECT consentimiento_estado FROM clientes WHERE uuid_local = ?"
	Private Const SQL_FIRMAR_CLIENTE As String = "UPDATE clientes SET consentimiento_estado = 'firmado' WHERE uuid_local = ?"
	Public Const CONSENTIMIENTO_FIRMADO As String = "firmado"
	Public Const CONSENTIMIENTO_PENDIENTE As String = "pendiente"
	Public Const CONSENTIMIENTO_REVOCADO As String = "revocado"
	Private Const SQL_UBICACION As String = "SELECT latitud, longitud FROM clientes WHERE uuid_local = ? AND latitud IS NOT NULL AND longitud IS NOT NULL"
	Private Const SQL_CONTACTO As String = "INSERT INTO cliente_contactos (uuid_local, cliente_uuid, nombre, area, telefono, celular, correo, principal, consentimiento_estado, estado_sync) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pendiente', 'pendiente')"
	Private Const SQL_FIRMAR_CONTACTO As String = "UPDATE cliente_contactos SET consentimiento_estado = 'firmado', consentimiento_version = ?, consentimiento_fecha = ? WHERE uuid_local = ?"
	Private Const SQL_FIRMA As String = "INSERT INTO consentimiento_firmas (uuid_local, cliente_uuid, cliente_contacto_uuid, accion, version_texto, fecha, firmante_nombre, firmante_identificacion, firma, mime, estado_sync) VALUES (?, ?, ?, 'otorgado', ?, ?, ?, ?, ?, 'image/png', 'pendiente')"
	Private Const SQL_ESTADO As String = "SELECT CASE WHEN EXISTS (SELECT 1 FROM cola_sync q WHERE q.entidad = 'cliente' AND q.uuid_local = c.uuid_local AND q.estado = 'error') THEN 'error' WHEN c.estado_sync <> 'confirmado' THEN 'pendiente' ELSE 'confirmado' END FROM clientes c WHERE c.uuid_local = ?"
	Private Const SQL_PERMISO As String = "SELECT accion, COALESCE(firmante_nombre, '') AS firmante, fecha, version_texto FROM consentimiento_firmas WHERE cliente_uuid = ? ORDER BY fecha DESC LIMIT 1"
	Private Const SQL_LISTA As String = "SELECT uuid_local, nombre, identificacion, tipo_identificacion, telefono, direccion, contacto, correo FROM clientes WHERE activo = 1 ORDER BY nombre COLLATE NOCASE"
	Private Const SQL_CONTACTOS_DE As String = "SELECT uuid_local, nombre, area, telefono, celular, correo, principal FROM cliente_contactos WHERE cliente_uuid = ? AND activo = 1 ORDER BY principal DESC, nombre COLLATE NOCASE"
	Private Const SQL_NOMBRE_REPETIDO As String = "SELECT 1 FROM clientes WHERE TRIM(nombre) = ? COLLATE NOCASE AND uuid_local <> ? LIMIT 1"
	Private Const SQL_IDENTIFICACION_REPETIDA As String = "SELECT nombre FROM clientes WHERE tipo_identificacion = ? AND REPLACE(REPLACE(identificacion, '-', ''), ' ', '') = ? AND uuid_local <> ? LIMIT 1"
	Private Const TIPOS_IDENTIFICACION As Int = 3
End Sub

#Region Lectura
Public Sub Lista As List
	Dim res As List
	res.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery(SQL_LISTA)
	Do While rs.NextRow
		Dim c As Cliente = Tipos.ClienteVacio
		c.UuidLocal = rs.GetString("uuid_local")
		c.Nombre = rs.GetString("nombre")
		c.Identificacion = Utils.TextoONada(rs.GetString("identificacion"))
		c.TipoIdentificacion = rs.GetInt("tipo_identificacion") - 1
		c.Telefono = Utils.TextoONada(rs.GetString("telefono"))
		c.Direccion = Utils.TextoONada(rs.GetString("direccion"))
		c.ContactoCobro = Utils.TextoONada(rs.GetString("contacto"))
		c.CorreoCobro = Utils.TextoONada(rs.GetString("correo"))
		res.Add(c)
	Loop
	rs.Close
	Return res
End Sub

Public Sub ListaConEstado As List
	Dim res As List
	res.Initialize
	For Each c As Cliente In Lista
		Dim f As ClienteFila
		f.Initialize
		f.Datos = c
		f.EstadoSync = EstadoDe(c.UuidLocal)
		res.Add(f)
	Next
	Return res
End Sub

Public Sub EstadoDe (ClienteUuid As String) As String
	Dim estado As String = Db.DbSQL.ExecQuerySingleResult2(SQL_ESTADO, Array As String(ClienteUuid))
	If estado = Null Then Return DbSync.ESTADO_PENDIENTE
	Return estado
End Sub

Public Sub ConsentimientoDe (ClienteUuid As String) As String
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_CONSENTIMIENTO_DE, Array As String(ClienteUuid))
	Dim estado As String = ""
	If rs.NextRow Then estado = Utils.TextoONada(rs.GetString("consentimiento_estado"))
	rs.Close
	Return estado
End Sub

Public Sub UltimoPermiso (ClienteUuid As String) As PermisoCliente
	Dim p As PermisoCliente
	p.Initialize
	p.Accion = ""
	p.Firmante = ""
	p.Fecha = ""
	p.Version = ""
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_PERMISO, Array As String(ClienteUuid))
	If rs.NextRow Then
		p.Accion = rs.GetString("accion")
		p.Firmante = rs.GetString("firmante")
		p.Fecha = Utils.TextoONada(rs.GetString("fecha"))
		p.Version = Utils.TextoONada(rs.GetString("version_texto"))
	End If
	rs.Close
	Return p
End Sub

Public Sub TextoVigente As TextoPermiso
	Dim t As TextoPermiso
	t.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery(SQL_TEXTO_VIGENTE)
	If rs.NextRow Then
		t.Version = rs.GetString("version")
		t.Titulo = rs.GetString("titulo")
		t.Contenido = rs.GetString("contenido")
	End If
	rs.Close
	Return t
End Sub

Public Sub UbicacionDe (ClienteUuid As String) As UbicacionGps
	Dim u As UbicacionGps = Tipos.UbicacionVacia
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_UBICACION, Array As String(ClienteUuid))
	If rs.NextRow Then
		u.Ok = True
		u.Latitud = rs.GetDouble("latitud")
		u.Longitud = rs.GetDouble("longitud")
	End If
	rs.Close
	Return u
End Sub

Public Sub ContactosDe (ClienteUuid As String) As List
	Dim res As List
	res.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_CONTACTOS_DE, Array As String(ClienteUuid))
	Do While rs.NextRow
		Dim k As Contacto
		k.Initialize
		k.UuidLocal = rs.GetString("uuid_local")
		k.Nombre = rs.GetString("nombre")
		k.Puesto = Utils.TextoONada(rs.GetString("area"))
		k.Telefono = Utils.TextoONada(rs.GetString("telefono"))
		k.Celular = Utils.TextoONada(rs.GetString("celular"))
		k.Correo = Utils.TextoONada(rs.GetString("correo"))
		k.Principal = rs.GetInt("principal") = 1
		res.Add(k)
	Loop
	rs.Close
	Return res
End Sub

Private Sub UuidDeFirmante (Contactos As List, Nombre As String) As Object
	Dim buscado As String = Nombre.Trim.ToLowerCase
	If buscado = "" Then Return Null
	For Each k As Contacto In Contactos
		If k.Nombre.Trim.ToLowerCase = buscado Then Return k.UuidLocal
	Next
	Return Null
End Sub
#End Region

#Region Escritura
Public Sub Guardar (c As Cliente, Contactos As List, Permiso As Consentimiento, Lugar As UbicacionGps) As String
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
			TipoIdentificacion(c.TipoIdentificacion), c.Telefono, c.CorreoCobro, c.ContactoCobro, c.Direccion, _
			Coordenada(Lugar, True), Coordenada(Lugar, False)))
		For Each k As Contacto In Contactos
			s.ExecNonQuery2(SQL_CONTACTO, Array As Object(k.UuidLocal, c.UuidLocal, k.Nombre, k.Puesto, _
				k.Telefono, k.Celular, k.Correo, IIf(k.Principal, 1, 0)))
			uuids.Add(k.UuidLocal)
		Next
		If titular <> Null Then s.ExecNonQuery2(SQL_FIRMAR_CONTACTO, Array As Object(Permiso.Version, ahora, titular))
		s.ExecNonQuery2(SQL_FIRMA, Array As Object(uFirma, c.UuidLocal, titular, Permiso.Version, ahora, _
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

Public Sub GuardarFirma (ClienteUuid As String, Contactos As List, Permiso As Consentimiento) As Boolean
	Dim s As SQL = Db.DbSQL
	Dim ahora As String = Utils.AhoraBd
	Dim uFirma As String = Db.NuevoUuid
	Dim titular As Object = UuidDeFirmante(Contactos, Permiso.Firmante)
	Dim ok As Boolean = False
	s.BeginTransaction
	Try
		If titular <> Null Then s.ExecNonQuery2(SQL_FIRMAR_CONTACTO, Array As Object(Permiso.Version, ahora, titular))
		s.ExecNonQuery2(SQL_FIRMA, Array As Object(uFirma, ClienteUuid, titular, Permiso.Version, ahora, _
			Permiso.Firmante, Permiso.CedulaFirmante, Permiso.Firma))
		s.ExecNonQuery2(SQL_FIRMAR_CLIENTE, Array As Object(ClienteUuid))
		Db.Encolar("firma", uFirma)
		s.TransactionSuccessful
		ok = True
	Catch
		Log("DbClientes.GuardarFirma: " & LastException.Message)
	End Try
	s.EndTransaction
	Return ok
End Sub
#End Region

#Region Ayudantes
Private Sub Coordenada (Lugar As UbicacionGps, EsLatitud As Boolean) As Object
	If Lugar.IsInitialized = False Or Lugar.Ok = False Then Return Null
	If EsLatitud Then Return Lugar.Latitud
	Return Lugar.Longitud
End Sub

Public Sub NombreRepetido (Nombre As String, UuidPropio As String) As Boolean
	If Nombre.Trim = "" Then Return False
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_NOMBRE_REPETIDO, Array As String(Nombre.Trim, UuidPropio))
	Dim hay As Boolean = rs.NextRow
	rs.Close
	Return hay
End Sub

Public Sub DuenoDeIdentificacion (IndiceTipo As Int, Numero As String, UuidPropio As String) As String
	Dim tipo As Object = TipoIdentificacion(IndiceTipo)
	Dim limpio As String = Numero.Replace("-", "").Replace(" ", "").Trim
	If tipo = Null Or limpio = "" Then Return ""
	Dim rs As ResultSet = Db.DbSQL.ExecQuery2(SQL_IDENTIFICACION_REPETIDA, Array As String(tipo, limpio, UuidPropio))
	Dim dueno As String = ""
	If rs.NextRow Then dueno = rs.GetString("nombre")
	rs.Close
	Return dueno
End Sub

Private Sub TipoIdentificacion (IndiceCombo As Int) As Object
	If IndiceCombo < 0 Or IndiceCombo >= TIPOS_IDENTIFICACION Then Return Null
	Return IndiceCombo + 1
End Sub
#End Region
