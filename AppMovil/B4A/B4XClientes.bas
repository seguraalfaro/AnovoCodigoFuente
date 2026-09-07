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

#Region Declaraciones

Sub Class_Globals
	Private Root As B4XView                       
	Private xui As XUI                             

	Private const TIPO As String = "cliente"
	Private RestaurandoBorrador As Boolean

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
	Private Contactos As List                        
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
	Private CbTipoIdentificacion As B4XComboBox
	Private IME1 As IME
	Private Cbfirmante As B4XComboBox
	Private TextCedulaConsentimiento As B4XFloatTextField
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

#End Region

#Region B4XPage Ciclo de vida

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageIngresoDatos")
	B4XPages.SetTitle(Me, "Agregar cliente")
	Contactos.Initialize
	InicializarPasos
	InitializePageContainer
	UI.ConfigurarMemo(TextDireccion,"Dirección: Provincia, Cantón y Distrito")
	Utils.AsignarItemsCombo(CbTipoIdentificacion,Utils.TiposIdent)
	IME1.Initialize("IME1")
	IME1.AddHeightChangedEvent
	IME1.AddHandleActionEvent(TextDireccion)
	UI.AplicarTema(Root)
End Sub

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
	PersistirBorrador
End Sub

Private Sub B4XPage_Background
	PersistirBorrador
End Sub

#End Region

#Region Eventos globales de campos

' Enganchados por nombre desde el UI, sirven a las tres hojas.
Private Sub EditText_TextChanged (Old As String, New As String)
	If RestaurandoBorrador Then Return
	Formato.EventoCambioText( Sender, Old, New)
End Sub

Private Sub  EditText_FocusChanged (HasFocus As Boolean)
	If HasFocus Or RestaurandoBorrador Then Return
	If Formato.EventoCambioFocusText(Sender) Then  PersistirBorrador
End Sub

#End Region

#Region Persistencia (borrador KVS)

Private Sub NuevoBorrador
	UuidCliente = Db.NuevoUuid
	If  Contactos.Size > 0 Then Contactos.Clear
	If   CvContactos.Size > 0 Then CvContactos.Clear
	LimpiarFormularioCliente
	LimpiarFormularioContacto
	LimpiarFormularioConsentimiento
	AHView.GotoPage(0, True)
End Sub

Private Sub RestaurarBorrador
	RestaurandoBorrador = True
	Dim b As Map = Db.LeerBorrador(TIPO)
	UuidCliente = b.GetDefault("uuid_cliente", "")
	TextEmpresa.Text         = b.GetDefault("nombre", "")
	TextIdentificacion.Text  = b.GetDefault("identificacion", "")
	CbTipoIdentificacion.SelectedIndex = b.GetDefault("tipo_identificacion", 0)
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
	RestaurandoBorrador=False
	AHView.GotoPage(b.GetDefault("page", 0), True)
End Sub

Private Sub PersistirBorrador
	Dim b As Map = CreateMap( _
		"_tipo":                TIPO, _
		"page":                 AHView.CurrentPage, _
		"uuid_cliente":         UuidCliente, _
		"nombre":               TextEmpresa.Text.Trim, _
		"identificacion":       TextIdentificacion.Text.Trim, _
		"tipo_identificacion":  CbTipoIdentificacion.SelectedIndex, _
		"telefono":             TextTelefono.Text.Trim, _
		"correo":               TextCorreo.Text.Trim, _
		"contacto":             TextContacto.Text.Trim, _
		"direccion":            TextDireccion.Text.Trim, _
		"consiente":            CkAcepto.Checked, _
		"direccion":            TextDireccion.Text.Trim, _
		"contactos":            Contactos, _
		"firmante":            Cbfirmante.SelectedItem.Trim, _
		"Cedulafirmante":      TextCedulaConsentimiento.Text.Trim)
	Db.GuardarBorrador(TIPO, b)
End Sub

#End Region

#Region Navegación del asistente

Private Sub InicializarPasos
	UI.CargarIndicadorPasos(Pasos, Layouts.ClienteClaves, Layouts.ClienteTitulos)
End Sub

Private Sub InitializePageContainer
	UI.CargarPaginasContainer(Layouts.ClienteLayouts, AHView, pagecont)
	
End Sub

Private Sub BtnSiguiente_Click
	Dim actual As Int = AHView.CurrentPage
	If ValidarPaso(actual) = False Then Return
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
		LlenarFirmantes
		BtnSiguiente.Text = "Guardar"
		BtnCancelar.Visible=True
	Else
		BtnSiguiente.Text = "Siguiente"
		BtnCancelar.Visible=False
	End If
End Sub

Private Sub Pasos_StepClick (Index As Int, Id As String)
	If Index < AHView.CurrentPage Then AHView.GotoPage(Index, True)
End Sub

Private Sub ValidarPaso (Indice As Int) As Boolean
	Select Indice
		Case 0
			If Not ( Validacion.ValidarFormulario(PnDatos)) Then
			 xui.MsgboxAsync("Complete los campos marcados en rojo.", "Faltan datos")
				Return False
			End If
		Case 1
			If Contactos.Size = 0 Then
				xui.MsgboxAsync("Debe agregar al menos un contacto.", "Sin contactos")
				Return False
			End If
	End Select
		
 Return True
	
End Sub

#End Region

#Region Hoja 0 - Datos del cliente

Private Sub CbTipoIdentificacion_SelectedIndexChanged (Index As Int)
	If RestaurandoBorrador Then Return
	Formato.SetTipoIdentificacion(Index,TextIdentificacion)
End Sub


Private Sub LimpiarFormularioCliente
	UI.LimpiarFormulario(PnDatos)
End Sub

#End Region

#Region Hoja 1 - Contactos

Private Sub BtnAgregar_Click
	
	If Validacion.ValidarFormulario(PnContactos) Then	
		AgregarTarjetaContacto
		LimpiarFormularioContacto
	End If
	
	
End Sub

Private Sub AgregarTarjetaContacto
	Dim c As Map = LeerFormularioContacto
	Contactos.Add(c)
	CvContactos.Add(CrearItem(c), c)
	PersistirBorrador
	LimpiarFormularioContacto
	
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

#End Region

#Region Hoja 2 - Consentimiento
'La hoja 2 se arma con lo que hay en las dos anteriores, asi que la lista se
'rehace al entrar en ella y no al crear la pagina: para entonces no hay nada.
Private Sub LlenarFirmantes
	Dim nombres As List
	nombres.Initialize
	nombres.Add("")                       'item guia: el indice 0 cuenta como vacio
	For Each c As Map In Contactos
		AgregarNombre(nombres, c.Get("nombre"))
	Next
	Cbfirmante.SetItems(nombres)
	Cbfirmante.SelectedIndex = 0
End Sub

'Sin repetidos: el contacto de la hoja 0 suele volver a escribir.
Private Sub AgregarNombre (Lista As List, Nombre As String)
	Dim n As String = Nombre.Trim
	If n <> "" And Lista.IndexOf(n) < 0 Then Lista.Add(n)
End Sub

Private Sub SignPad_onSigned (sign As Object)
	HayFirma = True
End Sub

Private Sub lblBorrar_Click
	SignPad.clear
	HayFirma=False
End Sub

Private Sub LimpiarFormularioConsentimiento
	UI.LimpiarFormulario(pnConsetimiento)
End Sub

#End Region

#Region Confirmar

Private Sub Confirmar
	If HayFirma Then
		Dim datos As Map = Db.LeerBorrador(TIPO)
		datos.Put("consiente", CkAcepto.Checked)
		datos.Put("firmante",  Cbfirmante.SelectedItem.Trim)
		datos.Put("Cedulafirmante",TextCedulaConsentimiento.Text.Trim)
		Dim firma() As Byte
		firma = extDBUtils.Image2Blob(SignPad.TransparentSignatureBitmap, True)
		DbClientes.GuardarCliente(datos,  firma)
		Db.BorrarBorrador(TIPO)
	
		NuevoBorrador
		xui.MsgboxAsync("Cliente guardado.", "Anovo")
	Else
		xui.MsgboxAsync("Deve primero firmar.", "Anovo")
		
	End If
End Sub

Private Sub BtnCancelar_Click
	
End Sub

#End Region
#Region Teclado
Private Sub IME1_HeightChanged (NewHeight As Int, OldHeight As Int)
	If Root.Parent.IsInitialized = False Then Return
	If NewHeight > OldHeight Then UI.SoltarFoco(TextDireccion)
End Sub


#End Region