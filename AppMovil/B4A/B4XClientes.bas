B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' ============================================================
'  Página: Agregar cliente  (asistente de 3 hojas)
'  Hojas: 0 datos · 1 contactos · 2 consentimiento
'  Borrador en KVS vía Db.*Borrador (tipo "cliente").
'  La lógica de BD/red vive en Db y ApiClient, no aquí.
' ============================================================

Sub Class_Globals
	Private Root As B4XView                          'ignore
	Private xui As XUI                               'ignore

	Private const TIPO As String = "cliente"
	Private AltaEnCurso As Boolean                   ' hay un alta a medias (marca para persistir)

	' Asistente
	Private Pasos As ASDrawSteps
	Private AHView As AHViewPager
	Private pagecont As AHPageContainer
	Private const ULTIMO As Int = 2
	Private BtnSiguiente As Button

	' Hoja 0 - datos del cliente
	Private TextEmpresa As B4XFloatTextField
	Private TextIdentificacion As B4XFloatTextField
	Private TextTelefono As B4XFloatTextField
	Private TextDireccion As EditText

	' Hoja 1 - contactos
	Private Contactos As List                        ' List de Map: fuente de verdad
	Private CvContactos As CustomListView
	Private BtnAgregar As Button
	Private TextContactos As B4XFloatTextField
	Private TextPuesto As B4XFloatTextField
	Private TextNumero As B4XFloatTextField
	Private TextCorreo As B4XFloatTextField
	Private Ckprincipal As B4XView
	' vistas del layout "itemcontacto"
	Private LblNombre As Label
	Private LblDatos As Label
	Private LblChip As Label

	' Hoja 2 - consentimiento
	Private CkAcepto As CheckBox
	Private BtnAtras_sec As Button
	Private BtnCancelar As Button
	Private SignPad As SignPad
	Private HayFirma As Boolean
	Private TextContacto As B4XFloatTextField
	Private TextCelular As B4XFloatTextField
	Private TextCorreos As B4XFloatTextField
	Private TextNumeros As B4XFloatTextField
	Private UuidCliente As String
	Private LBlEliminar As Label
	Private PnDatos As B4XView
	Private pnConsetimiento As B4XView
	Private PnContactos As B4XView
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageIngresoDatos")
	B4XPages.SetTitle(Me, "Agregar cliente")
	Contactos.Initialize
	InicializarPasos
	InitializePageContainer
	UI.ConfigurarMemo(TextDireccion,"Dirección: Provincia, Cantón y Distrito")
	
	UI.AplicarTema(Root)
End Sub

#Region B4XPage Ciclo de vida

Private Sub B4XPage_Appear
		If Db.HayBorrador(TIPO) Then
		Dim sf As Object = xui.Msgbox2Async( _
			"Tiene un cliente sin terminar. ¿Desea retomarlo?", "Anovo", _
			"Sí", "", "No", Null)
		Wait For (sf) MsgBox_Result (Result As Int)
			If Result = xui.DialogResponse_Positive Then
			RestaurarBorrador
			Return
		Else
			Db.BorrarBorrador(TIPO)
		End If
	End If
	NuevoBorrador
End Sub

Private Sub B4XPage_Disappear	
	If AltaEnCurso Then PersistirBorrador
End Sub
Private Sub B4XPage_Background
	If AltaEnCurso Then PersistirBorrador
End Sub
#End Region

#Region Persistencia (borrador KVS)

Private Sub NuevoBorrador
	UuidCliente = Db.NuevoUuid
	LimpiarFormularioCliente
	LimpiarFormularioContacto
	LimpiarFormularioConsentimiento
	AHView.GotoPage(0, True)
End Sub

Private Sub RestaurarBorrador
	AltaEnCurso = True
	Dim b As Map = Db.LeerBorrador(TIPO)
	UuidCliente = b.GetDefault("uuid_cliente", "")
	TextEmpresa.Text         = b.GetDefault("nombre", "")
	TextIdentificacion.Text  = b.GetDefault("identificacion", "")
	TextTelefono.Text        = b.GetDefault("telefono", "")
	TextDireccion.Text       = b.GetDefault("direccion", "")
	TextContacto.Text        = b.GetDefault("contacto", "")
	TextCorreo.text                = b.GetDefault("correo", "")
	CkAcepto.Checked         = b.GetDefault("consiente", False)
	
	CvContactos.Clear
	Dim guardados As List = b.GetDefault("contactos", Contactos)
	For Each c As Map In guardados
		Contactos.Add(c)
		CvContactos.Add(CrearItem(c), c)
	Next
  
	AHView.GotoPage(b.GetDefault("page", 0), True)
End Sub

Private Sub PersistirBorrador
	Dim b As Map = LeerFormularioCliente
	b.Put("_tipo", TIPO)
	b.Put("page", AHView.CurrentPage)
	b.Put("uuid_cliente",UuidCliente)
	b.Put("nombre", TextEmpresa.Text )
	b.Put("identificacion",TextIdentificacion.Text)
	b.Put("telefono", TextTelefono.Text )
	b.Put("correo", TextCorreo.Text )
	b.Put("contacto", TextContacto.Text)
	b.Put("direccion", TextDireccion.Text)
	b.Put("consiente", CkAcepto.Checked)
	b.Put("contactos", Contactos)
	Db.GuardarBorrador(TIPO, b)
End Sub

#End Region

#Region Formulario cliente  <->  Map

Private Sub LeerFormularioCliente As Map
	Return CreateMap( _
		"nombre":        TextEmpresa.Text.Trim, _
		"identificacion": TextIdentificacion.Text.Trim, _
		"telefono":       TextTelefono.Text.Trim, _
		"correo":         TextCorreo.Text.Trim, _
		"contacto":      TextContacto.Text.Trim, _
		"direccion":      TextDireccion.Text.Trim)		
		
End Sub

Private Sub LimpiarFormularioCliente
	 UI.LimpiarFormulario(PnDatos)
End Sub

#End Region

#Region Formulario contacto  <->  Map

Private Sub LeerFormularioContacto As Map
	Return CreateMap( _
		"uuid_local":            Db.NuevoUuid, _
		"cliente_uuid":          UuidCliente, _
		"nombre":                TextContactos.Text.Trim, _
		"area":                  TextPuesto.Text.Trim, _
		"telefono":              TextNumeros.Text.Trim, _
		"celular":              TextCelular.Text.Trim, _
		"correo":                TextCorreos.Text.Trim, _
		"principal":             Ckprincipal.Checked, _
		"consentimiento_estado": "pendiente", _
		"estado_sync":           "pendiente")
End Sub

Private Sub LimpiarFormularioContacto 
	UI.LimpiarFormulario(PnContactos)
End Sub
Private Sub LimpiarFormularioConsentimiento
	UI.LimpiarFormulario(pnConsetimiento)
End Sub

#End Region

#Region pageIngresoDatos


#Region EventsClicks
Private Sub BtnSiguiente_Click
	Dim actual As Int = AHView.CurrentPage
	'If ValidarPaso(actual) = False Then Return
	If actual=0 Then PersistirBorrador
	If actual < ULTIMO Then
		AHView.GotoPage(actual + 1, True)
	Else
		Confirmar
	End If
End Sub

Private Sub BtnAtras_sec_Click
	If AHView.CurrentPage > 0 Then AHView.GotoPage(AHView.CurrentPage - 1, True)
End Sub

Private Sub AHView_PageChanged (Position As Int)
	Pasos.CurrentIndex = Position
	If Position = ULTIMO Then
		BtnSiguiente.Text = "Guardar"
		BtnCancelar.Visible=True
	Else
		BtnSiguiente.Text = "Siguiente"
		BtnCancelar.Visible=False
	End If
End Sub

Private Sub BtnCancelar_Click
	
End Sub
Private Sub lblBorrar_Click
	SignPad.clear
	HayFirma=False
End Sub
#End Region

#End Region

#Region PageContactos 

Private Sub BtnAgregar_Click
	NuevoBorrador
	If ValidarContacto = False Then Return
	AgregarTarjetaContacto
	
End Sub
Private Sub AgregarTarjetaContacto
    Dim c As Map = LeerFormularioContacto
	Contactos.Add(c)
	CvContactos.Add(CrearItem(c), c)
	LimpiarFormularioContacto
	PersistirBorrador
End Sub
Private Sub CrearItem (c As Map) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, CvContactos.AsView.Width, UI.GetCardHeight)
	p.LoadLayout("itemcontacto")            ' contiene btnBorrarContacto
	UI.AplicarTema(p)
	LblNombre.Text  = c.Get("nombre")
	LblDatos.Text   = c.Get("numero") & "  ·  " & c.Get("correo")
	LblChip.Visible = c.Get("principal")
	LBlEliminar.Tag=c.Get("uuid_local")
	Return p
End Sub
Private Sub LBlEliminar_Click
	Dim v As B4XView = Sender
	Dim uuid As String = v.Tag
	Dim i As Int = IndiceDe(uuid)
	If i < 0 Then Return
	CvContactos.RemoveAt(i)
	Contactos.RemoveAt(i)
	PersistirBorrador	
End Sub
Private Sub IndiceDe (Uuid As String) As Int
	For i = 0 To Contactos.Size - 1
		Dim c As Map = Contactos.Get(i)
		If c.Get("uuid_local") = Uuid Then Return i
	Next
	Return -1
End Sub



Private Sub ValidarContacto As Boolean
	UI.CampoNormal(TextContactos)
	UI.CampoNormal(TextNumeros)
	UI.CampoNormal(TextCorreos)

	'If Validar.TextoMinimo(TextContactos.Text, 3) = False Then
		'UI.CampoError(TextContactos)
	'	TextContactos.RequestFocusAndShowKeyboard
	'	Return False
	'End If
	'If Validar.Telefono(TextNumeros.Text) = False Then
	'	UI.CampoError(TextNumeros)
	'	TextNumeros.RequestFocusAndShowKeyboard
	'	Return False
	''End If
	'If Validar.Vacio(TextCorreos.Text) = False Or Validar.Correo(TextCorreos.Text) = False Then
	'	UI.CampoError(TextCorreo)
'	TextCorreos.RequestFocusAndShowKeyboard
'		Return False
'	End If
	Return True
End Sub

#End Region

#Region Pasos / navegación

Private Sub InicializarPasos
	UI.CargarIndicadorPasos(Pasos, Layouts.ClienteClaves, Layouts.ClienteTitulos)
End Sub

Private Sub Pasos_StepClick (Index As Int, Id As String)
	If Index < AHView.CurrentPage Then AHView.GotoPage(Index, True)
End Sub


#End Region

#Region Confirmar

Private Sub Confirmar
	If HayFirma Then
		Dim datos As Map = Db.LeerBorrador(TIPO)
		datos.Put("consiente", CkAcepto.Checked)
		Dim firma() As Byte
		firma = extDBUtils.Image2Blob(SignPad.TransparentSignatureBitmap, True)
		DbClientes.GuardarCliente(datos,  firma)
		Db.BorrarBorrador(TIPO)
		AltaEnCurso = False
		NuevoBorrador
		xui.MsgboxAsync("Cliente guardado.", "Anovo")
	Else	
		xui.MsgboxAsync("Deve primero firmar.", "Anovo")	
		
	End If
End Sub

#End Region

#Region Page container

Private Sub InitializePageContainer	
	UI.CargarPaginasContainer(Layouts.ClienteLayouts, AHView, pagecont)	
	
End Sub
#End Region


Private Sub SignPad_onSigned (sign As Object)
	HayFirma = True
End Sub







Private Sub TextTelefono_TextChanged (Old As String, New As String)
	
End Sub

Private Sub TextTelefono_FocusChanged (HasFocus As Boolean)
	
End Sub