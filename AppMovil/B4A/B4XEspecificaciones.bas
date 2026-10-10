B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private pagecont As AHPageContainer
	Private AHViewEspecificaciones As AHViewPager

	'--- croquis ---
	Private ASDrawIso1   As ASDrawIso
	Private BtnLapiz     As Button
	Private btnborrador  As Button
	Private BtnDeshacer  As Button
	Private BtnColor1    As Button
	Private BtnColor2    As Button
	Private BtnColor3    As Button
	Private btnOpciones  As Button

	Private menu As ASPopupMenuAdvanced

	Private dlgCroquis As B4XDialog
	Private plantillaTexto As B4XInputTemplate
	Private pnlMedida As B4XView
	Private spnMedida As Spinner
	Private spnUnidad As Spinner
	Private txtValor As EditText
	Private txtCantidad As EditText
	Private TIPOS_MEDIDA() As String = Array As String("Largo", "Ancho", "Alto", "Profundidad", _
		"Diámetro", "Radio", "Espesor", "Ángulo")
	Private UNIDADES() As String = Array As String("cm", "mm", "m", "pulg", "grados")
	Private PLANOS() As String = Array As String("", "superior", "izquierda", "derecha", "frente")
	Private NOMBRES_PLANO() As String = Array As String("automática", "arriba", "izquierda", "derecha", "de frente")
	Private idxPlano As Int = 0

	'Grupo de herramientas con un solo elemento activo.
	Private herramientas() As B4XView

	'Deben coincidir con los colores puestos en el Designer a BtnColor1..3.
	'El modulo UI no los toca porque llevan el tag _raw.
	Private COLORES_LAPIZ() As Int

	Private GROSORES() As Float
	Private NOMBRES_GROSOR() As String
	Private idxGrosor As Int = 1
	Private idxColor  As Int = 0

	'--- navegacion entre subpaginas ---
	Private navegacion() As B4XView
	Private BtnCroquis  As Button
	Private BtnDetalles As Button
	Private BtnGuardar  As Button
	Private BtnCamera   As Button

	Private PageDetalles As Int = 0
	Private PageCROQUIS  As Int = 1
	Private PageFOTOS    As Int = 2
	
	
	Private SvHOme As ScrollView

    'Variables pageespecificaconesFoto
	Private BtnDisparar As Button
	Private BtnFlash As Button
	Private BtnRotar As Button
	Private camEx As CameraExClass
	Private camaraLista, disparando, conFlash, camFrontal,permisoBloqueado,tieneFlash As Boolean
	Private CvFoto As CustomListView
	Private pnPreview As Panel
	
	Private pnSinCamara As Panel
	Private lblSinCamIcono As Label
	Private lblSinCamTexto As Label
	Private lblSinCamTitulo As Label
	Private BtnPermitirCamara As Button
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageespecificacionesHome")
	B4XPages.SetTitle(Me, "Agregar piezas")

	InitializePageContainer
	UI.AplicarTema(Root)

	
	navegacion = Array As B4XView(BtnDetalles, BtnCamera, BtnCroquis)
End Sub
Private Sub B4XPage_Disappear
	CerrarCamara
End Sub

#Region pageEspecificacionesHome

#Region EventsClick
Private Sub BtnDetalles_Click
	AHViewEspecificaciones.GotoPage(PageDetalles, True)
End Sub

Private Sub BtnCroquis_Click
	AHViewEspecificaciones.GotoPage(PageCROQUIS, True)
End Sub

Private Sub BtnCamera_Click
	AHViewEspecificaciones.GotoPage(PageFOTOS, True)
End Sub

Private Sub BtnCancelar_Click
	
End Sub

Private Sub BtnGuardar_Click
	
End Sub
#End Region

#Region EventsChanged
Private Sub AHViewEspecificaciones_PageChanged (Position As Int)
	If Position <> PageCROQUIS Then
		If ASDrawIso1.IsInitialized Then ASDrawIso1.TerminarCadena(False)
		If menu.IsInitialized Then menu.CloseMenu
	Else
		Refrescar
	End If
	
	If Position = PageFOTOS Then
		AbrirCamara
	Else
		CerrarCamara
	End If
	If Position = PageCROQUIS Then
		InicializarCroquis
		If Not( menu.IsInitialized) Then 
			InicializarMenu			
		End If
		 		
	End If
	UI.MarcarGrupo(navegacion, Position)
End Sub
#End Region

#Region Page Container
Private Sub InitializePageContainer
	pagecont.Initialize
	
	LoadPages
	ConfigureViewPager
End Sub

Private Sub ConfigureViewPager
	AHViewEspecificaciones.PageContainer = pagecont
	AHViewEspecificaciones.PagingEnabled = False
	AHViewEspecificaciones.CurrentPage = PageDetalles
	UI.MarcarGrupo(navegacion, PageDetalles)
End Sub

Private Sub LoadPages
	For i = 0 To 2
		Dim page As B4XView = CreatePage(i)
		pagecont.AddPage(page, "page" & i)
	Next
End Sub

Private Sub CreatePage(index As Int) As B4XView
	Dim page As B4XView = xui.CreatePanel("")
	page.Height = AHViewEspecificaciones.Height
	page.Width = AHViewEspecificaciones.Width

	Select index
		Case 0: page.LoadLayout("PageEspecificaciones")
		Case 1: page.LoadLayout("PageEspecificacionesCroquis")
		Case 2: page.LoadLayout("PageEspecificacionesfoto")
	End Select
	
	UI.AplicarTema(page)
	
  Return page
End Sub


#End Region

#End Region

#Region pageEspecificacionesCroquis

#Region EventosClick
Private Sub BtnLapiz_Click
	ASDrawIso1.setModo("libre")
	Refrescar
End Sub

Private Sub btnborrador_Click
	ASDrawIso1.setModo("borrar")
	Refrescar
End Sub

Private Sub BtnDeshacer_Click
	ASDrawIso1.Undo
	Refrescar
End Sub

Private Sub BtnColor1_Click
	MarcarColor(0)
End Sub

Private Sub BtnColor2_Click
	MarcarColor(1)
End Sub

Private Sub BtnColor3_Click
	MarcarColor(2)
End Sub

Private Sub btnOpciones_Click
	ConstruirMenu
	menu.OpenMenuOnView(btnOpciones, 210dip, 430dip)
End Sub

Private Sub menu_ItemClick (Index As Int, Tag As Object)
	menu.CloseMenu

	Select Tag
		Case "puntos", "linea", "circulo", "agujero", "arco", "texto", "hueco", "cota", "angulo"
			ASDrawIso1.setModo(Tag)

		Case "llenar"
			LlenarPendientes
			Return

		Case "plano"
			idxPlano = (idxPlano + 1) Mod PLANOS.Length
			ASDrawIso1.setPlanoCirculo(PLANOS(idxPlano))

		Case "tipo_rejilla"
			If ASDrawIso1.getTipoRejilla = "iso" Then
				ASDrawIso1.setTipoRejilla("cuadrada")
			Else
				ASDrawIso1.setTipoRejilla("iso")
			End If
			ASDrawIso1.Rejilla = True

		Case "terminar"
			If ASDrawIso1.EnCadena Then ASDrawIso1.TerminarCadena(False)

		Case "cerrar"
			If ASDrawIso1.PuedeCerrar Then ASDrawIso1.TerminarCadena(True)

		Case "descartar"
			If ASDrawIso1.EnCadena Or ASDrawIso1.TrazoPendiente Then ASDrawIso1.Cancelar

		Case "rejilla"
			ASDrawIso1.Rejilla = Not(ASDrawIso1.Rejilla)

		Case "iman"
			ASDrawIso1.Iman = Not(ASDrawIso1.Iman)

		Case "rotulos"
			ASDrawIso1.Rotulos = Not(ASDrawIso1.Rotulos)

		Case "grosor"
			idxGrosor = (idxGrosor + 1) Mod GROSORES.Length
			ASDrawIso1.setGrosorLapiz(GROSORES(idxGrosor))

		Case "limpiar"
			If Not(ASDrawIso1.Vacio) Then
				ConfirmarLimpiar
				Return
			End If
	End Select

	Refrescar
End Sub
#End Region

#Region EventsChanged
Private Sub ASDrawIso1_Cambio
	Refrescar
End Sub

Private Sub ASDrawIso1_Medida (Id As Int)
	Wait For (PedirMedida(Id)) Complete (Listo As Boolean)
	Refrescar
End Sub

Private Sub ASDrawIso1_Texto (Id As Int)
	Wait For (PedirTexto(Id)) Complete (Listo As Boolean)
	Refrescar
End Sub
#End Region

#Region Metodos Menu
Private Sub InicializarMenu
	menu.Initialize(Root, Me, "menu")
	menu.ActivityHasActionBar = True
	menu.OrientationVertical = menu.OrientationVertical_TOP
	menu.CornerRadius = 10dip
	menu.MenuViewGap = 6dip
	menu.BackgroundPanel.Color = 0x52000000

	menu.TitleLabelProperties.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
	menu.TitleLabelProperties.xFont = xui.CreateDefaultFont(11)
	menu.TitleLabelProperties.BackgroundColor = Colores.COLOR_SUPERFICIE
	menu.TitleLabelProperties.LeftRightPadding = 12dip

	menu.SeparatorProperties.BackgroundColor = Colores.COLOR_BORDE
	menu.SeparatorProperties.Height = 1dip
End Sub

Private Sub ConstruirMenu
	menu.Clear
	Dim m As String = ASDrawIso1.getModo

	menu.AddTitle("HERRAMIENTAS", 26dip)
	menu.AddItem(Fila(Chr(0xF192), "Puntos",      m = "puntos",  False), "puntos")
	menu.AddItem(Fila(Chr(0xF068), "Línea recta", m = "linea",   False), "linea")
	menu.AddItem(Fila(Chr(0xF192), "Agujero",     m = "agujero", False), "agujero")
	menu.AddItem(Fila(Chr(0xF10C), "Círculo",     m = "circulo", False), "circulo")
	menu.AddItem(Fila(Chr(0xF1CE), "Arco",        m = "arco",    False), "arco")
	menu.AddItem(Fila(Chr(0xF031), "Texto",       m = "texto",   False), "texto")
	menu.AddItem(Fila(Chr(0xF1DB), "Marcar abertura", m = "hueco", False), "hueco")

	menu.AddSeparator
	menu.AddTitle("MEDIDAS", 26dip)
	menu.AddItem(Fila(Chr(0xF07E), "Cota",        m = "cota",    False), "cota")
	menu.AddItem(Fila(Chr(0xF1FE), "Ángulo",      m = "angulo",  False), "angulo")
	Dim faltan As Int = ASDrawIso1.getMedidasPendientes
	menu.AddItem(Fila(Chr(0xF044), "Llenar medidas (" & faltan & ")", False, faltan = 0), "llenar")

	menu.AddSeparator
	menu.AddTitle("FIGURA", 26dip)
	menu.AddItem(Fila(Chr(0xF00C), "Terminar figura", False, _
		Not(ASDrawIso1.EnCadena)), "terminar")
	menu.AddItem(Fila(Chr(0xF096), "Cerrar figura", False, _
		Not(ASDrawIso1.PuedeCerrar)), "cerrar")
	menu.AddItem(Fila(Chr(0xF00D), "Descartar figura", False, _
		Not(ASDrawIso1.EnCadena Or ASDrawIso1.TrazoPendiente)), "descartar")

	menu.AddSeparator
	menu.AddTitle("VISTA", 26dip)
	menu.AddItem(Fila(Chr(0xF00A), "Rejilla", ASDrawIso1.Rejilla, False), "rejilla")
	menu.AddItem(Fila(Chr(0xF0CE), "Rejilla cuadrada", ASDrawIso1.getTipoRejilla = "cuadrada", False), "tipo_rejilla")
	menu.AddItem(Fila(Chr(0xF1B2), "Cara: " & NOMBRES_PLANO(idxPlano), False, False), "plano")
	menu.AddItem(Fila(Chr(0xF076), "Imán",    ASDrawIso1.Iman,    False), "iman")
	menu.AddItem(Fila(Chr(0xF02B), "Medidas", ASDrawIso1.Rotulos, False), "rotulos")

	menu.AddSeparator
	menu.AddItem(Fila(Chr(0xF111), "Trazo: " & NOMBRES_GROSOR(idxGrosor), _
		False, False), "grosor")
	menu.AddItem(Fila(Chr(0xF1F8), "Limpiar todo", False, _
		ASDrawIso1.Vacio), "limpiar")
End Sub


Private Sub Fila (glifo As String, texto As String, marcada As Boolean, atenuada As Boolean) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, 210dip, 38dip)
	p.Color = Colores.COLOR_SUPERFICIE

	Dim colorTexto As Int = Colores.COLOR_TEXTO_PRIMARIO
	Dim colorIcono As Int = Colores.COLOR_PRIMARIO
	If atenuada Then
		colorTexto = Colores.COLOR_DESHABILITADO
		colorIcono = Colores.COLOR_DESHABILITADO
	End If

	Dim ico As Label
	ico.Initialize("")
	ico.Typeface = Typeface.FONTAWESOME
	ico.Text = glifo
	ico.TextSize = 14
	ico.TextColor = colorIcono
	ico.Gravity = Gravity.CENTER
	p.AddView(ico, 10dip, 0, 24dip, 38dip)

	Dim lbl As Label
	lbl.Initialize("")
	lbl.Text = texto
	lbl.TextSize = 14
	lbl.TextColor = colorTexto
	lbl.Gravity = Bit.Or(Gravity.LEFT, Gravity.CENTER_VERTICAL)
	p.AddView(lbl, 40dip, 0, 140dip, 38dip)

	If marcada Then
		Dim chk As Label
		chk.Initialize("")
		chk.Typeface = Typeface.FONTAWESOME
		chk.Text = Chr(0xF00C)
		chk.TextSize = 12
		chk.TextColor = Colores.COLOR_PRIMARIO
		chk.Gravity = Gravity.CENTER
		p.AddView(chk, 182dip, 0, 20dip, 38dip)
	End If

	Return p
End Sub




#End Region

#Region Metodos Croquis
Private Sub InicializarCroquis
	COLORES_LAPIZ = Array As Int( _
		Colores.COLOR_TEXTO_PRIMARIO, _
		Colores.COLOR_PRIMARIO, _
		Colores.COLOR_ERROR)

	GROSORES = Array As Float(2dip, 4dip, 7dip)
	NOMBRES_GROSOR = Array As String("Fino", "Medio", "Grueso")

	herramientas = Array As B4XView(BtnLapiz, btnborrador)

	'RF-004 pide dibujo a mano alzada: ese es el modo de entrada. La reticula
	'isometrica queda disponible desde el menu.
	ASDrawIso1.setModo("libre")
	ASDrawIso1.Rejilla = False
	ASDrawIso1.Iman = False
	ASDrawIso1.setGrosorLapiz(GROSORES(idxGrosor))
	ASDrawIso1.setColorLapiz(COLORES_LAPIZ(idxColor))

	MarcarColor(0)
	Refrescar
End Sub

Private Sub MarcarColor (indice As Int)
	idxColor = indice
	Dim botones() As Button = Array As Button(BtnColor1, BtnColor2, BtnColor3)

	For i = 0 To 2
		Dim v As B4XView = botones(i)
		Dim ancho As Int = 0
		If i = indice Then ancho = 3dip
		v.SetColorAndBorder(COLORES_LAPIZ(i), ancho, _
			Colores.COLOR_TEXTO_PRIMARIO, v.Height / 2)
	Next

	ASDrawIso1.setColorLapiz(COLORES_LAPIZ(indice))
End Sub
Private Sub Refrescar
	Dim m As String = ASDrawIso1.getModo
	Dim indice As Int = -1
	If m = "libre"  Then indice = 0
	If m = "borrar" Then indice = 1
	UI.MarcarGrupo(herramientas, indice)

	UI.Habilitar(BtnDeshacer, ASDrawIso1.PuedeUndo)
End Sub
Private Sub ConfirmarLimpiar
	Wait For (xui.Msgbox2Async("¿Borrar todo el croquis?", "Confirmar", _
		"Borrar", "", "Cancelar", Null)) Msgbox_Result (Resultado As Int)
	If Resultado = xui.DialogResponse_Positive Then ASDrawIso1.Limpiar
End Sub

Private Sub PrepararDialogos
	If dlgCroquis.IsInitialized Then Return
	dlgCroquis.Initialize(Root)
	UI.EstilizarDialogo(dlgCroquis)
	plantillaTexto.Initialize
	plantillaTexto.lblTitle.Text = "Nota"
	UI.EstilizarPlantillaTexto(plantillaTexto)

	pnlMedida = xui.CreatePanel("")
	pnlMedida.Tag = Utils.TAG_RAW
	pnlMedida.Color = Colores.COLOR_SUPERFICIE
	pnlMedida.SetLayoutAnimated(0, 0, 0, 300dip, 236dip)
	spnMedida.Initialize("")
	spnMedida.Tag = Utils.TAG_RAW
	spnMedida.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	spnMedida.DropdownBackgroundColor = Colores.COLOR_SUPERFICIE
	spnMedida.AddAll(TIPOS_MEDIDA)
	spnUnidad.Initialize("")
	spnUnidad.Tag = Utils.TAG_RAW
	spnUnidad.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	spnUnidad.DropdownBackgroundColor = Colores.COLOR_SUPERFICIE
	spnUnidad.AddAll(UNIDADES)
	txtValor.Initialize("")
	txtValor.InputType = txtValor.INPUT_TYPE_DECIMAL_NUMBERS
	txtValor.SingleLine = True
	txtCantidad.Initialize("")
	txtCantidad.InputType = txtCantidad.INPUT_TYPE_NUMBERS
	txtCantidad.SingleLine = True

	AgregarRotulo("Tipo de medida", 12dip)
	pnlMedida.AddView(spnMedida, 16dip, 32dip, 268dip, 44dip)
	AgregarRotulo("Valor", 84dip)
	pnlMedida.AddView(txtValor, 16dip, 104dip, 156dip, 44dip)
	pnlMedida.AddView(spnUnidad, 184dip, 104dip, 100dip, 44dip)
	AgregarRotulo("Cantidad de piezas iguales", 156dip)
	pnlMedida.AddView(txtCantidad, 16dip, 176dip, 100dip, 44dip)
	UI.AplicarTema(pnlMedida)
End Sub

Private Sub AgregarRotulo (Texto As String, Arriba As Int)
	Dim l As Label
	l.Initialize("")
	l.Tag = Utils.TAG_SUB
	l.Text = Texto
	l.TextSize = 12
	pnlMedida.AddView(l, 16dip, Arriba, 268dip, 20dip)
End Sub

Private Sub PedirMedida (Id As Int) As ResumableSub
	Dim m As Map = ASDrawIso1.getMedida(Id)
	If m.Size = 0 Then Return False
	PrepararDialogos
	spnMedida.SelectedIndex = Max(0, spnMedida.IndexOf(m.Get("medida")))
	spnUnidad.SelectedIndex = Max(0, spnUnidad.IndexOf(m.Get("unidad")))
	Dim valor As Double = m.Get("valor")
	If valor > 0 Then txtValor.Text = NumberFormat2(valor, 1, 2, 0, False) Else txtValor.Text = ""
	txtCantidad.Text = m.Get("cantidad")
	dlgCroquis.Title = "Medida " & m.Get("etiqueta")
	Wait For (dlgCroquis.ShowCustom(pnlMedida, "Guardar", "Quitar", "Cancelar")) Complete (Resultado As Int)
	If Resultado = xui.DialogResponse_Negative Then
		ASDrawIso1.QuitarTrazo(Id)
		Return True
	End If
	If Resultado <> xui.DialogResponse_Positive Then Return False
	Dim texto As String = txtValor.Text.Trim.Replace(",", ".")
	If IsNumber(texto) = False Or texto = "" Then
		xui.MsgboxAsync("Escriba el valor de la medida.", "Medida " & m.Get("etiqueta"))
		Return False
	End If
	Dim cantidad As Int = 1
	If IsNumber(txtCantidad.Text.Trim) Then cantidad = Max(1, txtCantidad.Text.Trim)
	ASDrawIso1.FijarMedida(Id, spnMedida.SelectedItem, texto, spnUnidad.SelectedItem, cantidad)
	Return True
End Sub

Private Sub LlenarPendientes
	For Each m As Map In ASDrawIso1.getMedidas
		Dim valor As Double = m.Get("valor")
		If valor > 0 Then Continue
		Wait For (PedirMedida(m.Get("id"))) Complete (Listo As Boolean)
		If Listo = False Then Exit
	Next
	Refrescar
End Sub

Private Sub PedirTexto (Id As Int) As ResumableSub
	PrepararDialogos
	plantillaTexto.Text = ASDrawIso1.getTextoDe(Id)
	Dim borrar As String = ""
	If Id > 0 Then borrar = "Borrar"
	dlgCroquis.Title = "Nota del croquis"
	Wait For (dlgCroquis.ShowTemplate(plantillaTexto, "Guardar", borrar, "Cancelar")) Complete (Resultado As Int)
	If Resultado = xui.DialogResponse_Positive Then ASDrawIso1.PonerTexto(Id, plantillaTexto.Text)
	If Resultado = xui.DialogResponse_Negative Then ASDrawIso1.PonerTexto(Id, "")
	Return True
End Sub
#End Region

#Region Persistencia Croquis
Public Sub ObtenerCroquisJSON As String
	If ASDrawIso1.IsInitialized = False Then Return ""
	ASDrawIso1.TerminarCadena(False)
	If ASDrawIso1.Vacio Then Return ""
	Return ASDrawIso1.ExportarJSON
End Sub
Public Sub CargarCroquis (json As String) As Boolean
	If ASDrawIso1.IsInitialized = False Then Return False
	If json = "" Then Return False
	If ASDrawIso1.ImportarJSON(json) = False Then
		'Log("Croquis no cargado: " & ASDrawIso1.UltimoError)
		Return False
	End If
	Refrescar
	Return True
End Sub

Public Sub getCroquisVacio As Boolean
	If ASDrawIso1.IsInitialized = False Then Return True
	Return ASDrawIso1.Vacio
End Sub

Public Sub getMedidasCroquis As List
	If ASDrawIso1.IsInitialized = False Then
		Dim vacia As List
		vacia.Initialize
		Return vacia
	End If
	Return ASDrawIso1.Medidas
End Sub

Public Sub getMedidasPendientes As Int
	If ASDrawIso1.IsInitialized = False Then Return 0
	Return ASDrawIso1.MedidasPendientes
End Sub
#End Region

#End Region

#Region EspeficacionesFoto

#Region EventosClick
Private Sub BtnRotar_Click
	If Not(camaraLista) Then Return
	If Not(Adjuntos.getPuedeRotar) Then Return

	CerrarCamara
	camFrontal = Not(camFrontal)
	InicializarCamara
End Sub

Private Sub BtnFlash_Click
	If Not(camaraLista) Then Return
	If Not(tieneFlash) Then Return

	conFlash = Not(conFlash)
	camEx.SetFlashMode(IIf(conFlash, "on", "off"))

	If Not(camEx.CommitParameters) Then
		'setParameters es todo o nada: si el bloque fue rechazado hay que
		'devolver la camara a un estado valido o el siguiente commit falla.
		conFlash = False
		tieneFlash = False
		camEx.SetFlashMode("off")
		camEx.CommitParameters
		UI.Habilitar(BtnFlash, False)
	End If

	UI.MarcarGrupo(Array As B4XView(BtnFlash), IIf(conFlash, 0, -1))
End Sub

Private Sub BtnDisparar_Click
	If Not(camaraLista) Then Return
	If disparando Then Return          'TakePicture no admite reentrada

	disparando = True
	UI.Habilitar(BtnDisparar, False)
	camEx.TakePicture
End Sub

'Reintento desde el panel de aviso. Si el permiso quedo bloqueado, el
'unico camino es la ficha de la aplicacion en los ajustes del sistema.
Private Sub BtnPermitirCamara_Click
	If permisoBloqueado Then
		AbrirAjustesApp
	Else
		AbrirCamara
	End If
End Sub
#End Region

#Region MetodosCamara

'Orden: primero el hardware, despues el permiso. Android concede el permiso
'de camara aunque el equipo no tenga ninguna, asi que preguntar al reves
'termina en un CamEx_Ready fallido sin explicacion para el usuario.
Private Sub AbrirCamara
	If camaraLista Then Return

	If Not(Adjuntos.getTieneCamara) Then
		SinCamara(Adjuntos.ESTADO_SIN_HARDWARE)
		Return
	End If

	Dim rp As RuntimePermissions

	'Si ya esta concedido no hay dialogo que esperar
	If rp.Check(rp.PERMISSION_CAMERA) Then
		ConCamara
		InicializarCamara
		Return
	End If

	rp.CheckAndRequest(rp.PERMISSION_CAMERA)
	Wait For Activity_PermissionResult (Permission As String, Result As Boolean)
	If Permission <> rp.PERMISSION_CAMERA Then Return

	If Result Then
		ConCamara
		InicializarCamara
	Else If Adjuntos.PermisoBloqueado(rp.PERMISSION_CAMERA) Then
		SinCamara(Adjuntos.ESTADO_BLOQUEADO)
	Else
		SinCamara(Adjuntos.ESTADO_DENEGADO)
	End If
End Sub


Private Sub InicializarCamara
	If Not(Adjuntos.getHayTrasera) Then camFrontal = True
	If Not(Adjuntos.getHayFrontal) Then camFrontal = False

	camEx.Initialize(pnPreview, camFrontal, Me, "CamEx")
	camFrontal = camEx.Front
End Sub

Private Sub CerrarCamara
	If camaraLista Then
		camEx.StopPreview
		camEx.Release
		camaraLista = False
	End If
End Sub

'motivo: una de las constantes Adjuntos.ESTADO_*
Private Sub SinCamara (motivo As String)
	camaraLista = False
	tieneFlash  = False
	conFlash    = False
	permisoBloqueado = (motivo = Adjuntos.ESTADO_BLOQUEADO)

	pnPreview.Visible   = False
	pnSinCamara.Visible = True

	UI.Habilitar(BtnDisparar, False)
	UI.Habilitar(BtnFlash, False)
	UI.Habilitar(BtnRotar, False)
	UI.MarcarGrupo(Array As B4XView(BtnFlash), -1)

	BtnPermitirCamara.Visible = True

	Select motivo
		Case Adjuntos.ESTADO_SIN_HARDWARE
			lblSinCamIcono.Text = Chr(0xF030)
			lblSinCamIcono.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
			lblSinCamTitulo.Text = "Este equipo no tiene cámara"
			lblSinCamTexto.Text = "Podés seguir usando el croquis y adjuntar " & _
				"fotografías desde la galería."
			BtnPermitirCamara.Visible = False    'no hay nada que reintentar

		Case Adjuntos.ESTADO_BLOQUEADO
			lblSinCamIcono.Text = Chr(0xF023)
			lblSinCamIcono.TextColor = Colores.COLOR_ERROR
			lblSinCamTitulo.Text = "Permiso bloqueado"
			lblSinCamTexto.Text = "El permiso de cámara está bloqueado. Podés " & _
				"activarlo desde los ajustes del sistema."
			BtnPermitirCamara.Text = "Abrir ajustes"

		Case Adjuntos.ESTADO_FALLO
			lblSinCamIcono.Text = Chr(0xF071)
			lblSinCamIcono.TextColor = Colores.COLOR_ERROR
			lblSinCamTitulo.Text = "No se pudo abrir la cámara"
			lblSinCamTexto.Text = "Puede que otra aplicación la esté usando. " & _
				"Cerrala e intentá de nuevo."
			BtnPermitirCamara.Text = "Reintentar"

		Case Else                                'ESTADO_DENEGADO
			lblSinCamIcono.Text = Chr(0xF030)
			lblSinCamIcono.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
			lblSinCamTitulo.Text = "Cámara no disponible"
			lblSinCamTexto.Text = "Podés seguir usando el croquis y adjuntar " & _
				"fotografías desde la galería."
			BtnPermitirCamara.Text = "Permitir cámara"
	End Select
End Sub


Private Sub ConCamara
	permisoBloqueado = False
	pnSinCamara.Visible = False
	pnPreview.Visible = True
	UI.Habilitar(BtnFlash, False)
	UI.Habilitar(BtnRotar, Adjuntos.getPuedeRotar)
End Sub

'Lleva al usuario a la ficha de la aplicacion en los ajustes de Android.
'Al volver, B4XPage_Appear reintenta abrir la camara sin que tenga que
'tocar nada mas.
Private Sub AbrirAjustesApp
	Dim i As Intent
	i.Initialize("android.settings.APPLICATION_DETAILS_SETTINGS", _
		"package:" & Application.PackageName)
	i.Flags = 0x10000000                'FLAG_ACTIVITY_NEW_TASK
	Try
		StartActivity(i)
	Catch
		Log("AbrirAjustesApp: " & LastException.Message)
		xui.MsgboxAsync("No se pudieron abrir los ajustes de la aplicación.", "Anovo")
	End Try
End Sub

Sub CamEx_Ready (Success As Boolean)
	If Not(Success) Then
		SinCamara(Adjuntos.ESTADO_FALLO)
	Else
		camaraLista = True
		camEx.SetJpegQuality(Adjuntos.CALIDAD)
		camEx.SetContinuousAutoFocus
		camEx.CommitParameters
		camEx.StartPreview

		'El flash se consulta al hardware una sola vez por apertura: la lista
		'no cambia mientras la instancia viva. Si el equipo no lo soporta el
		'boton queda deshabilitado, no oculto, para que se vea que existe.
		conFlash = False
		tieneFlash = (camEx.GetSupportedFlashModes.IndexOf("on") > -1)
		UI.Habilitar(BtnFlash, tieneFlash)
		UI.MarcarGrupo(Array As B4XView(BtnFlash), -1)

		UI.Habilitar(BtnDisparar, True)
		UI.Habilitar(BtnRotar, Adjuntos.getPuedeRotar)
	End If
End Sub

Sub CamEx_PictureTaken (Data() As Byte)
'	Adjuntos.Guardar(Data)

	disparando = False
	UI.Habilitar(BtnDisparar, True)

	If camaraLista Then camEx.StartPreview
End Sub
#End Region

#End Region