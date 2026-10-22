B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Registro de cliente en tres pasos: datos, contactos y permiso. La pagina lee
' los campos y pinta; el borrador, las reglas y el guardado son del presentador.

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private presentador As PresentadorCliente
	Private visible As Boolean
	Private restaurando As Boolean
	Private HayFirma As Boolean
	Private Const ULTIMO As Int = 2
	Private Const PASO_DATOS As Int = 0

	Private Pasos As ASDrawSteps
	Private AHView As AHViewPager
	Private pagecont As AHPageContainer
	Private BtnSiguiente As Button
	Private BtnAtras_sec As Button
	Private BtnCancelar As Button

	Private PnDatos As B4XView
	Private TextEmpresa As B4XFloatTextField
	Private CbTipoIdentificacion As B4XComboBox
	Private TextIdentificacion As B4XFloatTextField
	Private TextTelefono As B4XFloatTextField
	Private TextDireccion As EditText
	Private TextContacto As B4XFloatTextField
	Private TextCorreo As B4XFloatTextField

	Private PnContactos As B4XView
	Private CvContactos As CustomListView
	Private TextContactos As B4XFloatTextField
	Private TextPuesto As B4XFloatTextField
	Private TextNumeros As B4XFloatTextField
	Private TextCelular As B4XFloatTextField
	Private TextCorreos As B4XFloatTextField
	Private Ckprincipal As B4XView
	Private LblNombre As Label
	Private LblDatos As Label
	Private LblChip As Label
	Private LBlEliminar As Label

	Private pnConsetimiento As B4XView
	Private scvtexto As ScrollView
	Private Const MARGEN_TEXTO As Int = 8dip
	Private CkAcepto As CheckBox
	Private Cbfirmante As B4XComboBox
	Private TextCedulaConsentimiento As B4XFloatTextField
	Private SignPad As SignPad
	Private IME1 As IME
	Private gps As Ubicacion
	Private PnUbicacion, lblUbicacionIcono, lblUbicacion, lblUbicacionAccion As B4XView
	Private Const ESPERA_GPS As Int = 20000
	Private Const RADIO_UBICACION As Int = 10dip
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

#Region Ciclo y borrador
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageIngresoDatos")
	B4XPages.SetTitle(Me, Mensajes.TITULO_CLIENTE)
	presentador.Initialize
	gps.Initialize
	UI.CargarIndicadorPasos(Pasos, Layouts.ClienteClaves, Layouts.ClienteTitulos)
	Dim datos As B4XView = UI.PaginaVacia(AHView)
	datos.LoadLayout("PageClienteDatos")
	Dim contactos As B4XView = UI.PaginaVacia(AHView)
	contactos.LoadLayout("PageClienteContactos")
	Dim permiso As B4XView = UI.PaginaVacia(AHView)
	permiso.LoadLayout("PageClienteConsentimiento")
	UI.CargarContenedor(AHView, pagecont, Array As B4XView(datos, contactos, permiso))
	UI.ConfigurarMemo(TextDireccion, Mensajes.AYUDA_DIRECCION)
	Utils.AsignarItemsCombo(CbTipoIdentificacion, Utils.TiposIdent)
	IME1.Initialize("IME1")
	IME1.AddHeightChangedEvent
	IME1.AddHandleActionEvent(TextDireccion)
	UI.AplicarTema(Root)
End Sub

Private Sub B4XPage_Appear
	visible = True
	If presentador.HayBorrador Then
		Dim sf As Object = xui.Msgbox2Async(Mensajes.RETOMAR_CLIENTE, Mensajes.TITULO, Mensajes.SI, "", Mensajes.NO, Null)
		Wait For (sf) Msgbox_Result (Respuesta As Int)
		If visible = False Then Return
		If Respuesta = xui.DialogResponse_Positive And presentador.Restaurar Then
			Pintar
			PintarUbicacion
			Return
		End If
		presentador.DescartarBorrador
	Else
		presentador.Nuevo
	End If
	Limpiar
	PintarTexto
	CapturarUbicacion
End Sub

Private Sub B4XPage_Disappear
	visible = False
	Persistir
End Sub

Private Sub B4XPage_Background
	If visible Then Persistir
End Sub

Private Sub Persistir
	If restaurando Then Return
	presentador.GuardarBorrador(LeerCliente, LeerPermiso, AHView.CurrentPage)
End Sub

Private Sub LeerCliente As Cliente
	Dim c As Cliente = Tipos.ClienteVacio
	c.Nombre = TextEmpresa.Text.Trim
	c.TipoIdentificacion = CbTipoIdentificacion.SelectedIndex
	c.Identificacion = TextIdentificacion.Text.Trim
	c.Telefono = TextTelefono.Text.Trim
	c.Direccion = TextDireccion.Text.Trim
	c.ContactoCobro = TextContacto.Text.Trim
	c.CorreoCobro = TextCorreo.Text.Trim
	Return c
End Sub

Private Sub LeerContacto As Contacto
	Dim c As Contacto
	c.Initialize
	c.Nombre = TextContactos.Text.Trim
	c.Puesto = TextPuesto.Text.Trim
	c.Telefono = TextNumeros.Text.Trim
	c.Celular = TextCelular.Text.Trim
	c.Correo = TextCorreos.Text.Trim
	c.Principal = Ckprincipal.Checked
	Return c
End Sub

Private Sub LeerPermiso As Consentimiento
	Dim p As Consentimiento = Tipos.ConsentimientoVacio
	p.Acepta = CkAcepto.Checked
	If Cbfirmante.Size > 0 Then p.Firmante = Cbfirmante.SelectedItem.Trim
	p.CedulaFirmante = TextCedulaConsentimiento.Text.Trim
	If HayFirma Then p.Firma = extDBUtils.Image2Blob(SignPad.TransparentSignatureBitmap, True)
	Return p
End Sub

Private Sub Pintar
	restaurando = True
	Dim c As Cliente = presentador.Datos
	TextEmpresa.Text = c.Nombre
	CbTipoIdentificacion.SelectedIndex = c.TipoIdentificacion
	TextIdentificacion.Text = c.Identificacion
	TextTelefono.Text = c.Telefono
	TextDireccion.Text = c.Direccion
	TextContacto.Text = c.ContactoCobro
	TextCorreo.Text = c.CorreoCobro
	CvContactos.Clear
	For Each k As Contacto In presentador.Contactos
		CvContactos.Add(CrearItem(k), k.UuidLocal)
	Next
	CkAcepto.Checked = presentador.Permiso.Acepta
	TextCedulaConsentimiento.Text = presentador.Permiso.CedulaFirmante
	restaurando = False
	AHView.GotoPage(presentador.Pagina, True)
End Sub

Private Sub Limpiar
	CvContactos.Clear
	UI.LimpiarFormulario(PnDatos)
	UI.LimpiarFormulario(PnContactos)
	UI.LimpiarFormulario(pnConsetimiento)
	SignPad.clear
	HayFirma = False
	AHView.GotoPage(PASO_DATOS, True)
End Sub

Private Sub IME1_HeightChanged (NewHeight As Int, OldHeight As Int)
	If Root.Parent.IsInitialized = False Then Return
	If NewHeight > OldHeight Then UI.SoltarFoco(TextDireccion)
End Sub
#End Region

#Region Paso 1: datos
Private Sub EditText_TextChanged (Old As String, New As String)
	If restaurando Then Return
	UI.MascaraAlEscribir(Sender, New)
End Sub

Private Sub EditText_FocusChanged (HasFocus As Boolean)
	If HasFocus Or restaurando Then Return
	If UI.ValidarCampo(Sender) Then Persistir
End Sub

Private Sub CbTipoIdentificacion_SelectedIndexChanged (Index As Int)
	If restaurando Then Return
	UI.CambiarIdentificacion(Index, TextIdentificacion)
End Sub
#End Region

#Region Ubicación
Private Sub CapturarUbicacion
	presentador.BuscandoUbicacion
	PintarUbicacion
	Dim rp As RuntimePermissions
	If rp.Check(rp.PERMISSION_ACCESS_FINE_LOCATION) = False Then
		rp.CheckAndRequest(rp.PERMISSION_ACCESS_FINE_LOCATION)
		Wait For B4XPage_PermissionResult (Permission As String, Result As Boolean)
		If Result = False Then
			presentador.FijarUbicacion(Tipos.UbicacionVacia)
			PintarUbicacion
			Return
		End If
	End If
	Wait For (gps.Pedir(ESPERA_GPS)) Complete (Lugar As UbicacionGps)
	presentador.FijarUbicacion(Lugar)
	If visible = False Then Return
	PintarUbicacion
	Persistir
End Sub

Private Sub PintarUbicacion
	Dim f As FranjaSync = presentador.FranjaUbicacion
	PnUbicacion.SetColorAndBorder(f.Fondo, 1dip, f.Tinta, RADIO_UBICACION)
	lblUbicacionIcono.Text = f.Glifo
	lblUbicacionIcono.TextColor = f.Tinta
	lblUbicacion.Text = f.Texto
	lblUbicacion.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	lblUbicacionAccion.Text = f.Accion
	lblUbicacionAccion.TextColor = f.Tinta
End Sub

Private Sub lblUbicacionAccion_Click
	If presentador.PuedeReintentarUbicacion Then CapturarUbicacion
End Sub
#End Region

#Region Paso 2: contactos
Private Sub BtnAgregar_Click
	If UI.ValidarFormulario(PnContactos) = False Then Return
	Dim c As Contacto = presentador.AgregarContacto(LeerContacto)
	CvContactos.Add(CrearItem(c), c.UuidLocal)
	UI.LimpiarFormulario(PnContactos)
	Persistir
End Sub

Private Sub CrearItem (c As Contacto) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, CvContactos.AsView.Width, UI.GetCardHeight)
	p.LoadLayout("ItemContacto")
	UI.AplicarTema(p)
	LblNombre.Text = c.Nombre
	LblDatos.Text = presentador.DetalleContacto(c)
	LblChip.Visible = c.Principal
	LBlEliminar.Tag = c.UuidLocal
	Return p
End Sub

Private Sub LBlEliminar_Click
	Dim v As B4XView = Sender
	Dim i As Int = presentador.QuitarContacto(v.Tag)
	If i < 0 Then Return
	CvContactos.RemoveAt(i)
	Persistir
End Sub
#End Region

#Region Paso 3: consentimiento
Private Sub PintarTexto
	UI.PintarTextoLargo(scvtexto, Mensajes.CuerpoPermiso(presentador.TextoPermiso), MARGEN_TEXTO)
End Sub

Private Sub SignPad_onSigned (sign As Object)
	HayFirma = True
End Sub

Private Sub lblBorrar_Click
	SignPad.clear
	HayFirma = False
End Sub
#End Region

#Region Navegación entre pasos
Private Sub BtnSiguiente_Click
	Dim actual As Int = AHView.CurrentPage
	Dim completos As Boolean = True
	If actual = PASO_DATOS Then completos = UI.ValidarFormulario(PnDatos)
	Dim r As Resultado = presentador.ValidarPaso(actual, completos, LeerCliente)
	If r.Ok = False Then
		xui.MsgboxAsync(r.Mensaje, Mensajes.TITULO)
		Return
	End If
	If actual < ULTIMO Then
		Persistir
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
		Dim firmantes As List = presentador.Firmantes
		Cbfirmante.SetItems(firmantes)
		Cbfirmante.SelectedIndex = Max(0, firmantes.IndexOf(presentador.Permiso.Firmante))
		BtnSiguiente.Text = Mensajes.GUARDAR
		BtnCancelar.Visible = True
	Else
		BtnSiguiente.Text = Mensajes.SIGUIENTE
		BtnCancelar.Visible = False
	End If
End Sub

Private Sub Pasos_StepClick (Index As Int, Id As String)
	If Index < AHView.CurrentPage Then AHView.GotoPage(Index, True)
End Sub

Private Sub Confirmar
	Dim r As Resultado = presentador.Guardar(LeerPermiso)
	If r.Ok = False Then
		xui.MsgboxAsync(r.Mensaje, Mensajes.TITULO)
		Return
	End If
	Limpiar
	Sincronizacion.Pedir
	xui.MsgboxAsync(Mensajes.CLIENTE_GUARDADO, Mensajes.TITULO)
End Sub

Private Sub BtnCancelar_Click
	Dim sf As Object = xui.Msgbox2Async(Mensajes.DESCARTAR_CLIENTE, Mensajes.TITULO, Mensajes.SI, "", Mensajes.NO, Null)
	Wait For (sf) Msgbox_Result (Respuesta As Int)
	If Respuesta <> xui.DialogResponse_Positive Then Return
	presentador.DescartarBorrador
	Limpiar
	B4XPages.ClosePage(Me)
End Sub
#End Region
