B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private Menu As WobbleMenu
	Private AHViewHOme As AHViewPager
	Private pagecont As AHPageContainer
	
	Private BtnNuevo As Button
	Private ClvClientes As CustomListView
	Private lblVacioIcono As Label
	Private lblVacioTexto As Label
	Private lblVacioTitulo As Label
	Private pnvacio As Panel
End Sub

'You can add more parameters here.
Public Sub Initialize As Object
	Return Me
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageHome")
	B4XPages.SetTitle(Me, "Anovo")
	B4XPages.AddMenuItem(Me, "Sincronizar")
	B4XPages.AddMenuItem(Me, "Cerrar sesión")
	
	InitializePageContainer
	
	InitializeMenu
	MostrarVacio(True, Chr(0xF0C0), "Sin clientes", "Todavía no hay clientes registrados.")
	'MostrarVacio(True, Chr(0xF002), "Sin coincidencias", "No hay clientes que coincidan con la búsqueda.")
End Sub
#Region Menu
Private Sub InitializeMenu
	Menu.SetTabTextIcon(1, "Inicio",       Chr(0xF015), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(2, "Clientes",     Chr(0xF0C0), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(3, "Nueva",        Chr(0xF067), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(4, "Cotizaciones", Chr(0xF15C), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(5, "Perfil",       Chr(0xF007), Typeface.FONTAWESOME)
	Menu.SetCurrentTab2(1, False)
End Sub


#End Region
#Region pageCliente
 
Private Sub MostrarVacio (visible As Boolean, glifo As String, titulo As String, texto As String)
	If pnvacio.NumberOfViews = 0 Then
		 pnvacio.LoadLayout("ItemVacio")
		UI.AplicarTema(pnvacio)
	End If
	lblVacioIcono.Text = glifo
	lblVacioTitulo.Text = titulo
	lblVacioTexto.Text = texto
	pnvacio.Visible = visible
	ClvClientes.AsView.Visible = Not(visible)
End Sub
#Region EventClick
Private Sub BtnNuevo_Click
	B4XPages.ShowPage("PCLientes")
End Sub

#End Region
#End Region
#Region Page Container
Private Sub InitializePageContainer
	pagecont.Initialize
	
	LoadPages
	ConfigureViewPager
End Sub

Private Sub ConfigureViewPager
	AHViewHOme.PageContainer = pagecont
	AHViewHOme.PagingEnabled = False
	AHViewHOme.CurrentPage = 0
End Sub

Private Sub LoadPages
	For i = 0 To 4
		Dim page As B4XView = CreatePage(i)
		pagecont.AddPage(page, "page" & i)
	Next
End Sub

Private Sub CreatePage(index As Int) As B4XView
	Dim page As B4XView = xui.CreatePanel("")
	page.Height = AHViewHOme.Height
	page.Width = AHViewHOme.Width
	
	Select index
		Case 0: page.LoadLayout("itemvacio")
		Case 1: page.LoadLayout("Pageclientes")
		Case 2: page.LoadLayout("PageCotizacion3")
		Case 3: page.LoadLayout("PageEspecificaciones")
		Case 4: page.LoadLayout("PageNuevoCliente")
	End Select
	UI.AplicarTema(page)
	Return page
End Sub


#End Region
#Region Event Handlers
Private Sub Menu_Tab1Click
	AHViewHOme.GotoPage(0, True)
End Sub

Private Sub Menu_Tab2Click
	AHViewHOme.GotoPage(1, True)
	
End Sub

Private Sub Menu_Tab3Click
	
	B4XPages.ShowPage("Pcotizacion")
End Sub

Private Sub Menu_Tab4Click
	AHViewHOme.GotoPage(3, True)
End Sub

Private Sub Menu_Tab5Click
	AHViewHOme.GotoPage(4, True)
End Sub


#End Region

