B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Public Const CONSENT_VERSION As String = "v1"
End Sub

Public Sub GuardarCliente(Datos As Map,  firma() As Byte) As String
	Dim s As SQL=Db.DbSQL
	Dim uCliente As String = Datos.Get("uuid_cliente")
	Dim ahora As String = Utils.AhoraBd	
	Dim Contactos As List = Datos.Get("contactos")
	Dim uFirma As String = Db.NuevoUuid
	Dim principal As Map = ContactoPrincipal(Contactos)
	Dim ok As Boolean = False
	
	s.BeginTransaction
	Try
		extDBUtils.InsertMapIn(s, "clientes", CreateMap( _
			"uuid_local":     uCliente, _
			"nombre":         Datos.GetDefault("empresa", ""), _
			"identificacion": Datos.GetDefault("identificacion", ""), _
			"tipo_identificacion": Datos.GetDefault("tipo_identificacion", ""), _
			"telefono":       Datos.GetDefault("telefono", ""), _
			"direccion":      Datos.GetDefault("direccion", ""), _
			"estado_sync":    "pendiente"))

		extDBUtils.InsertMapsIn(s, "cliente_contactos", Contactos)

		' el titular del consentimiento es el contacto principal
		extDBUtils.UpdateRecord2(s, "cliente_contactos", _
			CreateMap("consentimiento_estado": "firmado", _
			          "consentimiento_version": CONSENT_VERSION, _
			          "consentimiento_fecha": ahora), _
			CreateMap("uuid_local": principal.Get("uuid_local")))

		extDBUtils.InsertMapIn(s, "consentimiento_firmas", CreateMap( _
			"uuid_local": uFirma, _
			"cliente_uuid": uCliente, _
			"cliente_contacto_uuid": principal.Get("uuid_local"), _
			"accion": "otorgado", _
			"version_texto": CONSENT_VERSION, _
			"fecha": ahora, _
			"firmante_nombre": principal.Get("nombre"), _
			"firmante_identificacion": Datos.GetDefault("identificacion", ""), _
			"firma": firma, _
			"mime": "image/png", _
			"estado_sync": "pendiente"))

		Db.Encolar("cliente", uCliente)
		Db.EncolarFilas("contacto", Contactos)
		Db.Encolar("firma", uFirma)

		s.TransactionSuccessful
		ok = True
	Catch
		Log("DbClientes.GuardarCliente ERROR: " & LastException)
	End Try
	s.EndTransaction

	If ok = False Then Return ""
	Log("DbClientes: guardado " & uCliente & " con " & Contactos.Size & " contactos")
	Return uCliente
	
End Sub

Private Sub ContactoPrincipal (Contactos As List) As Map
	For Each c As Map In Contactos
		Dim esPrincipal As Boolean = c.GetDefault("principal", 0)
		If esPrincipal = True Then Return c
	Next
	Return Contactos.Get(0)
End Sub