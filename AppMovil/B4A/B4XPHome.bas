B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Pagina principal con el menu de cinco pestanas. Solo navega: no tiene reglas,
' por eso no lleva presentador.
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private Menu As WobbleMenu
	Private AHViewHOme As AHViewPager
	Private pagecont As AHPageContainer

	Private ClvClientes As CustomListView
	Private lblVacioIcono As Label
	Private lblVacioTexto As Label
	Private lblVacioTitulo As Label
	Private pnvacio As Panel

	Private Const PESTANAS As Int = 5
	Private Const HOJA_INICIO As Int = 0
	Private Const HOJA_CLIENTES As Int = 1
	Private Const HOJA_COTIZACIONES As Int = 3
	Private Const HOJA_PERFIL As Int = 4
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageHome")
	B4XPages.SetTitle(Me, Mensajes.TITULO)
	B4XPages.AddMenuItem(Me, Mensajes.MENU_SINCRONIZAR)
	B4XPages.AddMenuItem(Me, Mensajes.MENU_CERRAR_SESION)
	InicializarHojas
	InicializarMenu
	MostrarVacio(True, Chr(0xF0C0), Mensajes.SIN_CLIENTES_TITULO, Mensajes.SIN_CLIENTES_TEXTO)
End Sub

Private Sub InicializarMenu
	Menu.SetTabTextIcon(1, Mensajes.TAB_INICIO, Chr(0xF015), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(2, Mensajes.TAB_CLIENTES, Chr(0xF0C0), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(3, Mensajes.TAB_NUEVA, Chr(0xF067), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(4, Mensajes.TAB_COTIZACIONES, Chr(0xF15C), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(5, Mensajes.TAB_PERFIL, Chr(0xF007), Typeface.FONTAWESOME)
	Menu.SetCurrentTab2(1, False)
End Sub

Private Sub MostrarVacio (Mostrar As Boolean, Glifo As String, Titulo As String, Texto As String)
	If pnvacio.NumberOfViews = 0 Then
		pnvacio.LoadLayout("ItemVacio")
		UI.AplicarTema(pnvacio)
	End If
	lblVacioIcono.Text = Glifo
	lblVacioTitulo.Text = Titulo
	lblVacioTexto.Text = Texto
	pnvacio.Visible = Mostrar
	ClvClientes.AsView.Visible = Not(Mostrar)
End Sub

Private Sub BtnNuevo_Click
	B4XPages.ShowPage(Layouts.PAGINA_CLIENTES)
End Sub

Private Sub InicializarHojas
	pagecont.Initialize
	For i = 0 To PESTANAS - 1
		pagecont.AddPage(CrearHoja(i), "page" & i)
	Next
	AHViewHOme.PageContainer = pagecont
	AHViewHOme.PagingEnabled = False
	AHViewHOme.CurrentPage = HOJA_INICIO
End Sub

Private Sub CrearHoja (Indice As Int) As B4XView
	Dim hoja As B4XView = xui.CreatePanel("")
	hoja.Height = AHViewHOme.Height
	hoja.Width = AHViewHOme.Width
	Select Indice
		Case 0: hoja.LoadLayout("itemvacio")
		Case 1: hoja.LoadLayout("Pageclientes")
		Case 2: hoja.LoadLayout("PageCotizacion3")
		Case 3: hoja.LoadLayout("PageEspecificaciones")
		Case 4: hoja.LoadLayout("PageNuevoCliente")
	End Select
	UI.AplicarTema(hoja)
	Return hoja
End Sub

Private Sub Menu_Tab1Click
	AHViewHOme.GotoPage(HOJA_INICIO, True)
End Sub

Private Sub Menu_Tab2Click
	AHViewHOme.GotoPage(HOJA_CLIENTES, True)
End Sub

Private Sub Menu_Tab3Click
	B4XPages.ShowPage(Layouts.PAGINA_COTIZACION)
End Sub

Private Sub Menu_Tab4Click
	AHViewHOme.GotoPage(HOJA_COTIZACIONES, True)
End Sub

Private Sub Menu_Tab5Click
	AHViewHOme.GotoPage(HOJA_PERFIL, True)
End Sub
