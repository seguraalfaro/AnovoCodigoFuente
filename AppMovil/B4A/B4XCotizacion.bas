B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private Pasos As ASDrawSteps
	Private AHView As AHViewPager
	Private pagecont As AHPageContainer
	Private BtnSiguiente As Button
	Private ULTIMO As Int = 2
	
	Private txtObservaciones As EditText
	Private ime As IME
	Private BtnAtras_sec As Button
	Private pn_fondo As Panel
	Private BtnAgregarPieza As Button
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageIngresoDatos")
	B4XPages.SetTitle(Me, "Nueva cotización")
	
	InicializarPasos
	InitializePageContainer	
	UI.ConfigurarMemo(txtObservaciones, "Observaciones del proyecto")
	ime.Initialize("IME")
	ime.AddHandleActionEvent(txtObservaciones)
	UI.AplicarTema(Root)
End Sub


Private Sub InicializarPasos
Pasos.BackgroundColor  = Colores.COLOR_FONDO_PANTALLA
	Pasos.ActiveColor      = Colores.COLOR_PRIMARIO
	Pasos.InactiveColor    = Colores.COLOR_DESHABILITADO
	Pasos.LineColor        = Colores.COLOR_BORDE
	Pasos.CircleTextColor  = Colores.COLOR_TEXTO_SOBRE_PRIMARIO
	Pasos.PendingTextColor = Colores.COLOR_TEXTO_SECUNDARIO
	Pasos.LabelColor       = Colores.COLOR_TEXTO_SECUNDARIO
	Pasos.SetSteps( _
		Array As String("cliente", "detalles", "revision"), _
		Array As String("Cliente", "Detalles", "Revisión"))
	Pasos.CurrentIndex = 0
End Sub
#Region Page Container
Private Sub InitializePageContainer
	pagecont.Initialize
	
	LoadPages
	ConfigureViewPager
End Sub

Private Sub ConfigureViewPager
	AHView.PageContainer = pagecont
	AHView.PagingEnabled = False
	AHView.CurrentPage = 0
End Sub

Private Sub LoadPages
	For i = 0 To 2
		Dim page As B4XView = CreatePage(i)
		pagecont.AddPage(page, "page" & i)
	Next
End Sub

Private Sub CreatePage(index As Int) As B4XView
	Dim page As B4XView = xui.CreatePanel("")
	page.Height = AHView.Height
	page.Width = AHView.Width
	page.LoadLayout(Flujo.CotizacionLayouts(index))
	UI.AplicarTema(page)
	Return page
End Sub


#End Region
'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.

Private Sub BtnSiguiente_Click
	Dim actual As Int = AHView.CurrentPage
	If ValidarPaso(actual) = False Then Return
	If actual < ULTIMO Then
		AHView.GotoPage(actual + 1, True)
	Else
		
	End If
End Sub

Private Sub ValidarPaso (Indice As Int) As Boolean
	Select Indice
		Case 0
		'	If cbCliente.SelectedIndex < 0 Then
			'	xui.MsgboxAsync("Seleccione un cliente antes de continuar.", "Datos incompletos")
			'	Return False
		'	End If
		Case 1
			'If lstPiezas.Size = 0 Then
			'	xui.MsgboxAsync("Agregue al menos una pieza.", "Datos incompletos")
			'	Return False
			'End If
	End Select
	Return True
End Sub

Private Sub Pasos_StepClick (Index As Int, Id As String)
	If Index < AHView.CurrentPage Then AHView.GotoPage(Index, True)
End Sub

Private Sub AHView_PageChanged (Position As Int)
	Pasos.CurrentIndex = Position
	'btnAtras.Visible = (Position > 0)
	If Position = ULTIMO Then
		BtnSiguiente.Text = "Guardar Cotizacion"
	Else
		BtnSiguiente.Text = "Siguiente"
	End If
End Sub


Private Sub txtObservaciones_TextChanged (Old As String, New As String)
	If New.Length > 500 Then txtObservaciones.Text = Old
End Sub

Private Sub txtObservaciones_FocusChanged (HasFocus As Boolean)
	If HasFocus = False Then ime.HideKeyboard
End Sub



Private Sub BtnAtras_sec_Click
	If AHView.CurrentPage > 0 Then AHView.GotoPage(AHView.CurrentPage - 1, True)
End Sub


Private Sub BtnAgregarPieza_Click
	B4XPages.ShowPage("PEspecificaciones")
End Sub