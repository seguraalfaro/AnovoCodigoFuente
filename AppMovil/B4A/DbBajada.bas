B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Aplica en SQLite lo que baja del servidor en un solo lote: clientes, contactos y catalogos, y la
' fecha para la siguiente bajada. No pisa lo que el asesor tiene en la cola sin subir.

Sub Process_Globals
	Private Const CLAVE_DESDE As String = "bajada_desde"
	Private Const CLAVE_HORA As String = "bajada_hora"
	Private Const EVENTO_LOTE As String = "Lote"
	Private Const SQL_NUEVO_CLIENTE As String = "INSERT OR IGNORE INTO clientes (uuid_local, nombre) VALUES (?, ?)"
	Private Const SQL_CLIENTE As String = "UPDATE clientes SET id_servidor = ?, nombre = ?, identificacion = ?, tipo_identificacion = ?, telefono = ?, correo = ?, contacto = ?, direccion = ?, latitud = ?, longitud = ?, consentimiento_estado = ?, objversion = ?, activo = ?, estado_sync = 'confirmado' WHERE uuid_local = ? AND NOT EXISTS (SELECT 1 FROM cola_sync WHERE entidad = 'cliente' AND uuid_local = ?)"
	Private Const SQL_NUEVO_CONTACTO As String = "INSERT OR IGNORE INTO cliente_contactos (uuid_local, cliente_uuid, nombre) SELECT ?, ?, ? WHERE EXISTS (SELECT 1 FROM clientes WHERE uuid_local = ?)"
	Private Const SQL_CONTACTO As String = "UPDATE cliente_contactos SET id_servidor = ?, nombre = ?, area = ?, telefono = ?, celular = ?, correo = ?, principal = ?, consentimiento_estado = ?, consentimiento_version = ?, consentimiento_fecha = ?, objversion = ?, activo = ?, estado_sync = 'confirmado' WHERE uuid_local = ? AND NOT EXISTS (SELECT 1 FROM cola_sync WHERE entidad = 'contacto' AND uuid_local = ?)"
	Private Const SQL_NUEVO_TIPO_TRABAJO As String = "INSERT OR IGNORE INTO tipos_trabajo (id_servidor, nombre) VALUES (?, ?)"
	Private Const SQL_TIPO_TRABAJO As String = "UPDATE tipos_trabajo SET nombre = ?, activo = ? WHERE id_servidor = ?"
	Private Const SQL_NUEVO_TIPO_MATERIAL As String = "INSERT OR IGNORE INTO tipos_material (id_servidor, nombre) VALUES (?, ?)"
	Private Const SQL_TIPO_MATERIAL As String = "UPDATE tipos_material SET nombre = ?, activo = ? WHERE id_servidor = ?"
	Private Const SQL_NUEVO_ACABADO As String = "INSERT OR IGNORE INTO acabados (id_servidor, nombre) VALUES (?, ?)"
	Private Const SQL_ACABADO As String = "UPDATE acabados SET nombre = ?, activo = ? WHERE id_servidor = ?"
	Private Const SQL_BORRAR_TEXTO As String = "DELETE FROM consentimiento_texto"
	Private Const SQL_TEXTO As String = "INSERT INTO consentimiento_texto (version, titulo, contenido) VALUES (?, ?, ?)"
	Private Const SQL_SEGUIMIENTO As String = "INSERT OR REPLACE INTO seguimiento (uuid_local, id_servidor, nombre_proyecto, descripcion, cliente_nombre, fecha_captura, estado, cotizacion_numero, monto_aprobado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
End Sub

#Region Lectura de la configuración
Public Sub Desde As String
	Return Db.LeerConfig(CLAVE_DESDE)
End Sub

Public Sub Hora As String
	Return Db.LeerConfig(CLAVE_HORA)
End Sub
#End Region

#Region Aplicar la bajada
Public Sub Contar (Datos As Map) As Int
	Dim total As Int = 0
	For Each llave As String In Array As String("clientes", "contactos", "tipos_trabajo", "tipos_material", "acabados", "solicitudes")
		total = total + Lista(Datos, llave).Size
	Next
	Return total
End Sub

Public Sub Aplicar (Datos As Map) As Object
	Dim s As SQL = Db.DbSQL
	For Each m As Map In Lista(Datos, "clientes")
		Dim uuidCliente As String = m.Get("uuid_local")
		s.AddNonQueryToBatch(SQL_NUEVO_CLIENTE, Array(uuidCliente, m.Get("nombre")))
		s.AddNonQueryToBatch(SQL_CLIENTE, Array(m.Get("id"), m.Get("nombre"), m.Get("identificacion"), _
			m.Get("tipo_identificacion"), m.Get("telefono"), m.Get("correo"), m.Get("contacto"), m.Get("direccion"), _
			m.Get("latitud"), m.Get("longitud"), m.Get("consentimiento_estado"), m.Get("obj_version"), _
			Bandera(m, "activo"), uuidCliente, uuidCliente))
	Next
	For Each m As Map In Lista(Datos, "contactos")
		Dim uuidContacto As String = m.Get("uuid_local")
		Dim duenio As String = m.Get("cliente_uuid")
		s.AddNonQueryToBatch(SQL_NUEVO_CONTACTO, Array(uuidContacto, duenio, m.Get("nombre"), duenio))
		s.AddNonQueryToBatch(SQL_CONTACTO, Array(m.Get("id"), m.Get("nombre"), m.Get("area"), m.Get("telefono"), _
			m.Get("celular"), m.Get("correo"), Bandera(m, "principal"), m.Get("consentimiento_estado"), _
			m.Get("consentimiento_version"), m.Get("consentimiento_fecha"), m.Get("obj_version"), _
			Bandera(m, "activo"), uuidContacto, uuidContacto))
	Next
	AgregarCatalogo(s, Lista(Datos, "tipos_trabajo"), SQL_NUEVO_TIPO_TRABAJO, SQL_TIPO_TRABAJO)
	AgregarCatalogo(s, Lista(Datos, "tipos_material"), SQL_NUEVO_TIPO_MATERIAL, SQL_TIPO_MATERIAL)
	AgregarCatalogo(s, Lista(Datos, "acabados"), SQL_NUEVO_ACABADO, SQL_ACABADO)
	For Each m As Map In Lista(Datos, "solicitudes")
		Dim captura As String = Utils.Formatear(Utils.ApiAFecha(m.Get("fecha_captura")), Utils.FORMATO_BD)
		s.AddNonQueryToBatch(SQL_SEGUIMIENTO, Array(m.Get("uuid_local"), m.Get("id"), m.Get("nombre_proyecto"), _
			m.Get("descripcion"), m.Get("cliente_nombre"), captura, m.Get("estado"), m.Get("cotizacion_numero"), _
			m.Get("monto_aprobado")))
	Next
	Dim texto As Object = Datos.Get("consentimiento")
	If texto Is Map Then
		Dim vigente As Map = texto
		s.AddNonQueryToBatch(SQL_BORRAR_TEXTO, Array())
		s.AddNonQueryToBatch(SQL_TEXTO, Array(vigente.Get("version"), vigente.Get("titulo"), vigente.Get("contenido")))
	End If
	s.AddNonQueryToBatch(Db.SQL_GUARDAR_CONFIG, Array(CLAVE_DESDE, Datos.Get("servidor_ahora")))
	s.AddNonQueryToBatch(Db.SQL_GUARDAR_CONFIG, Array(CLAVE_HORA, Utils.AhoraBd))
	Return s.ExecNonQueryBatch(EVENTO_LOTE)
End Sub

Private Sub AgregarCatalogo (s As SQL, Filas As List, Nuevo As String, Cambio As String)
	For Each m As Map In Filas
		s.AddNonQueryToBatch(Nuevo, Array(m.Get("id"), m.Get("nombre")))
		s.AddNonQueryToBatch(Cambio, Array(m.Get("nombre"), Bandera(m, "activo"), m.Get("id")))
	Next
End Sub
#End Region

#Region Ayudantes
Private Sub Lista (Datos As Map, Llave As String) As List
	Dim v As Object = Datos.Get(Llave)
	If v Is List Then Return v
	Dim vacia As List
	vacia.Initialize
	Return vacia
End Sub

Private Sub Bandera (m As Map, Llave As String) As Int
	If m.GetDefault(Llave, False) = True Then Return 1
	Return 0
End Sub
#End Region
