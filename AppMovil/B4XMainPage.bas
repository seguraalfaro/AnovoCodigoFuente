B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

#Macro: Title, Export B4XPages, ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Public ime As IME
	Private Phome As B4XPHome
	Private PCotizacion As B4XCotizacion
	Private PEspecificaciones As B4XEspecificaciones
	Private PCLientes As B4XClientes
	
	Private indicator As WaitIndicator
	Private TextUsername As B4XFloatTextField
	Private Textpassword As B4XFloatTextField


End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Layouts.Inicializar
	indicator.Initialize(Root,150dip,150dip)
	
	ime.Initialize("ime")
	
	SetTopBarColorAndTitle(0xFF1A3A5C, xui.Color_White, "")
	InicializarPaginas
	Root.LoadLayout("PageLogin")
	UI.AplicarTema(Root)
End Sub

Private Sub InicializarPaginas
	Phome.Initialize
	PCotizacion.Initialize
	PEspecificaciones.Initialize
	PCLientes.Initialize
	B4XPages.AddPageAndCreate("Phome", Phome)
	B4XPages.AddPageAndCreate("Pcotizacion", PCotizacion)
	B4XPages.AddPageAndCreate("PEspecificaciones", PEspecificaciones)
	B4XPages.AddPageAndCreate("PCLientes", PCLientes)
	
End Sub

'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.
Private Sub btnIngresar_Click
	
		B4XPages.ShowPageAndRemovePreviousPages("Phome")

	
End Sub


Private Sub SetTopBarColorAndTitle(BackgroundColor As Int, TitleColor As String, Title As String)
	Dim top As B4XView = xui.CreatePanel("")
	top.Color = BackgroundColor
	Dim act As Activity = B4XPages.GetNativeParent(Me) 'Activity with non-B4XPages
	Dim r As Rect = ime.GetContentRect
	act.AddView(top, 0, 0, act.Width, r.Top)
	Dim cs As CSBuilder
	cs.Initialize.Color(TitleColor).Append(Title).Pop
	B4XPages.SetTitle(Me, cs) 'Activity.Title = cs with non-B4XPages
	
End Sub




