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
	Dim ok As Boolean = False

	Dim titular As Map = ContactoPorNombre(Contactos, Datos.GetDefault("firmante", ""))

	Dim uTitular As String = ""
	If titular <> Null Then uTitular = titular.GetDefault("uuid_local", "")

	s.BeginTransaction
	Try
		extDBUtils.InsertMapIn(s, "clientes", CreateMap( _
			"uuid_local":     uCliente, _
			"nombre":         Datos.GetDefault("nombre", ""), _
			"identificacion": Datos.GetDefault("identificacion", ""), _
			"tipo_identificacion": TipoIdentificacion(Datos), _
			"telefono":       Datos.GetDefault("telefono", ""), _
			"direccion":      Datos.GetDefault("direccion", ""), _
			"estado_sync":    "pendiente"))

		If Contactos.IsInitialized And Contactos.Size > 0 Then
			extDBUtils.InsertMapsIn(s, "cliente_contactos", Contactos)
		End If

		If uTitular <> "" Then
			extDBUtils.UpdateRecord2(s, "cliente_contactos", _
				CreateMap("consentimiento_estado": "firmado", _
				          "consentimiento_version": CONSENT_VERSION, _
				          "consentimiento_fecha": ahora), _
				CreateMap("uuid_local": uTitular))
		End If


		extDBUtils.InsertMapIn(s, "consentimiento_firmas", CreateMap( _
			"uuid_local": uFirma, _
			"cliente_uuid": uCliente, _
			"cliente_contacto_uuid": uTitular, _
			"accion": "otorgado", _
			"version_texto": CONSENT_VERSION, _
			"fecha": ahora, _
			"firmante_nombre": Datos.GetDefault("firmante", ""), _
			"firmante_identificacion": Datos.GetDefault("Cedulafirmante", ""), _
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
	Log("DbClientes: guardado " & uCliente & " con " & Cuantos(Contactos) & _
		" contactos, titular [" & uTitular & "]")
		
	Return uCliente
	
End Sub

'Devuelve la tarjeta cuyo nombre coincide con el del combo, o Null si el
'firmante no salio de la lista de contactos.
Private Sub ContactoPorNombre (Contactos As List, Nombre As String) As Map
	If Contactos.IsInitialized = False Then Return Null
	Dim buscado As String = Nombre.Trim.ToLowerCase
	If buscado = "" Then Return Null
	For Each c As Map In Contactos
		Dim n As String = c.GetDefault("nombre", "")
		If n.Trim.ToLowerCase = buscado Then Return c
	Next
	Return Null
End Sub

'El indice 0 del combo es la opcion vacia y la columna solo acepta 1, 2 o 3:
'sin tipo elegido se guarda NULL o el CHECK tumba la transaccion entera.
Private Sub TipoIdentificacion (Datos As Map) As Object
	Dim i As Int = Datos.GetDefault("tipo_identificacion", 0)
	If i < 1 Or i > 3 Then Return Null
	Return i
End Sub

Private Sub Cuantos (L As List) As Int
	If L.IsInitialized = False Then Return 0
	Return L.Size
End Sub
