B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Datos de prueba de clientes, contactos y catalogos para probar sin servidor. Cada
' grupo carga solo si CARGAR_DATOS = True y su tabla esta vacia; no encola nada.
Sub Process_Globals
	Public Const CARGAR_DATOS As Boolean = True
	Private Const SQL_HAY_CLIENTES As String = "SELECT count(*) FROM clientes"
	Private Const SQL_CLIENTE As String = "INSERT INTO clientes (uuid_local, nombre, identificacion, tipo_identificacion, telefono, correo, contacto, direccion, consentimiento_estado, estado_sync) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'firmado', 'confirmado')"
	Private Const SQL_CONTACTO As String = "INSERT INTO cliente_contactos (uuid_local, cliente_uuid, nombre, area, telefono, celular, correo, principal, consentimiento_estado, estado_sync) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'firmado', 'confirmado')"
	Private Const CONTACTOS_EMPRESA_GRANDE As Int = 20
	Private Const SQL_HAY_TIPOS_TRABAJO As String = "SELECT count(*) FROM tipos_trabajo"
	Private Const SQL_TIPO_TRABAJO As String = "INSERT INTO tipos_trabajo (id_servidor, nombre) VALUES (?, ?)"
	Private Const SQL_TIPO_MATERIAL As String = "INSERT INTO tipos_material (id_servidor, nombre) VALUES (?, ?)"
	Private Const SQL_ACABADO As String = "INSERT INTO acabados (id_servidor, nombre) VALUES (?, ?)"
End Sub

Public Sub Cargar
	If CARGAR_DATOS = False Then Return
	Dim s As SQL = Db.DbSQL
	If s.IsInitialized = False Then Return
	CargarCatalogos(s)
	If s.ExecQuerySingleResult(SQL_HAY_CLIENTES) > 0 Then Return

	s.BeginTransaction
	Try
		Dim grande As String = InsertarCliente(s, "Metalúrgica del Valle S.A.", "3-101-445566", 2, "2551-0000", "cobros@metvalle.example", "Ana Rojas", "Cartago, Oreamuno, San Rafael")
		ContactosEmpresaGrande(s, grande)

		Dim c As String = InsertarCliente(s, "Metales y Estructuras CR", "3-101-112233", 2, "2260-1100", "pagos@meycr.example", "Jorge Vargas", "Heredia, Heredia, San Francisco")
		InsertarContacto(s, c, "Jorge Vargas", "Gerencia", "2260-1101", "8810-2201", "jvargas@meycr.example", True)
		InsertarContacto(s, c, "Daniela Mora", "Compras", "2260-1102", "8810-2202", "dmora@meycr.example", False)
		InsertarContacto(s, c, "Esteban Solís", "Mantenimiento", "2260-1103", "8810-2203", "esolis@meycr.example", False)

		c = InsertarCliente(s, "Industrias Metalmecánicas del Norte", "3-101-554433", 2, "2443-2200", "cxc@imnorte.example", "Paola Jiménez", "Alajuela, Alajuela, San José")
		InsertarContacto(s, c, "Paola Jiménez", "Producción", "2443-2201", "8820-3301", "pjimenez@imnorte.example", True)
		InsertarContacto(s, c, "Ricardo Alfaro", "Ingeniería", "2443-2202", "8820-3302", "ralfaro@imnorte.example", False)

		c = InsertarCliente(s, "Taller Zamora e Hijos", "3-102-778899", 2, "2771-3300", "taller.zamora@correo.example", "Mario Zamora", "San José, Pérez Zeledón, San Isidro")
		InsertarContacto(s, c, "Mario Zamora", "Dueño", "2771-3300", "8830-4401", "mzamora@correo.example", True)

		c = InsertarCliente(s, "Luis Zamora Quesada", "1-0987-0654", 1, "8888-1234", "luis.zamora@correo.example", "Luis Zamora", "Cartago, Paraíso, Paraíso")
		InsertarContacto(s, c, "Luis Zamora Quesada", "", "", "8888-1234", "luis.zamora@correo.example", True)

		c = InsertarCliente(s, "Agroindustrial Los Santos", "3-101-998877", 2, "2546-4400", "finanzas@losantos.example", "Silvia Ureña", "San José, Tarrazú, San Marcos")
		InsertarContacto(s, c, "Silvia Ureña", "Administración", "2546-4401", "8840-5501", "surena@losantos.example", True)
		InsertarContacto(s, c, "Andrés Navarro", "Planta", "2546-4402", "8840-5502", "anavarro@losantos.example", False)

		c = InsertarCliente(s, "Empacadora Guanacaste", "3-101-334455", 2, "2666-5500", "pagos@empgte.example", "Karla Chaves", "Guanacaste, Liberia, Liberia")
		InsertarContacto(s, c, "Karla Chaves", "Operaciones", "2666-5501", "8850-6601", "kchaves@empgte.example", True)
		InsertarContacto(s, c, "Fabián Castro", "Mantenimiento", "2666-5502", "8850-6602", "fcastro@empgte.example", False)

		c = InsertarCliente(s, "Construcciones Pacífico Central", "3-101-667788", 2, "2643-6600", "cobros@cpc.example", "Rebeca Soto", "Puntarenas, Garabito, Jacó")
		InsertarContacto(s, c, "Rebeca Soto", "Proyectos", "2643-6601", "8860-7701", "rsoto@cpc.example", True)
		InsertarContacto(s, c, "Gustavo Méndez", "Obra", "2643-6602", "8860-7702", "gmendez@cpc.example", False)
		InsertarContacto(s, c, "Natalia Brenes", "Compras", "2643-6603", "8860-7703", "nbrenes@cpc.example", False)

		c = InsertarCliente(s, "Refrigeración Industrial Caribe", "3-101-221100", 2, "2758-7700", "admin@ricaribe.example", "Óscar Campos", "Limón, Limón, Limón")
		InsertarContacto(s, c, "Óscar Campos", "Técnico", "2758-7701", "8870-8801", "ocampos@ricaribe.example", True)

		s.TransactionSuccessful
		Log("DbPrueba: clientes y contactos de prueba cargados.")
	Catch
		Log("DbPrueba.Cargar: " & LastException.Message)
	End Try
	s.EndTransaction
End Sub

Private Sub CargarCatalogos (s As SQL)
	If s.ExecQuerySingleResult(SQL_HAY_TIPOS_TRABAJO) > 0 Then Return
	s.BeginTransaction
	Try
		InsertarCatalogo(s, SQL_TIPO_TRABAJO, Array As String("Fabricación de piezas", "Reparación", "Soldadura", "Torno y fresado", "Estructura metálica"))
		InsertarCatalogo(s, SQL_TIPO_MATERIAL, Array As String("Acero inoxidable", "Hierro negro", "Galvanizado", "Aluminio", "Bronce"))
		InsertarCatalogo(s, SQL_ACABADO, Array As String("Sin acabado", "Pintura anticorrosiva", "Pintura electrostática", "Galvanizado en caliente", "Pulido"))
		s.TransactionSuccessful
	Catch
		Log("DbPrueba.CargarCatalogos: " & LastException.Message)
	End Try
	s.EndTransaction
End Sub

Private Sub InsertarCatalogo (s As SQL, Sentencia As String, Nombres() As String)
	For i = 0 To Nombres.Length - 1
		s.ExecNonQuery2(Sentencia, Array As Object(i + 1, Nombres(i)))
	Next
End Sub

Private Sub InsertarCliente (s As SQL, Nombre As String, Identificacion As String, TipoIdent As Int, Telefono As String, _
	Correo As String, ContactoCobro As String, Direccion As String) As String
	Dim uuid As String = Db.NuevoUuid
	s.ExecNonQuery2(SQL_CLIENTE, Array As Object(uuid, Nombre, Identificacion, TipoIdent, Telefono, Correo, ContactoCobro, Direccion))
	Return uuid
End Sub

Private Sub InsertarContacto (s As SQL, ClienteUuid As String, Nombre As String, Area As String, Telefono As String, _
	Celular As String, Correo As String, Principal As Boolean)
	s.ExecNonQuery2(SQL_CONTACTO, Array As Object(Db.NuevoUuid, ClienteUuid, Nombre, Area, Telefono, Celular, Correo, IIf(Principal, 1, 0)))
End Sub

Private Sub ContactosEmpresaGrande (s As SQL, ClienteUuid As String)
	Dim nombres() As String = Array As String("Ana Rojas", "Bernardo Quesada", "Carolina Mora", "Diego Hernández", _
		"Elena Salas", "Felipe Araya", "Gabriela Vega", "Héctor Cordero", "Isabel Calderón", "José Pablo Arias", _
		"Karina Monge", "Leonardo Ramírez", "Marcela Chacón", "Néstor Madrigal", "Olga Villalobos", _
		"Pablo Fonseca", "Rocío Segura", "Sebastián Alvarado", "Tatiana Murillo", "Víctor Porras")
	Dim areas() As String = Array As String("Gerencia", "Compras", "Producción", "Mantenimiento", "Ingeniería")
	For i = 0 To CONTACTOS_EMPRESA_GRANDE - 1
		Dim sufijo As String = NumberFormat2(i + 1, 2, 0, 0, False)
		InsertarContacto(s, ClienteUuid, nombres(i), areas(i Mod areas.Length), "2551-00" & sufijo, "8800-00" & sufijo, _
			"contacto" & sufijo & "@metvalle.example", i = 0)
	Next
End Sub
