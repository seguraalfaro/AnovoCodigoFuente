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
	Private lblServidor As B4XView
	Private flujoIngreso As Ingreso
	Private dlgServidor As B4XDialog
	Private plantillaServidor As B4XInputTemplate
	Private Const MARGEN As Int = 16dip
	Private Const ALTO_SERVIDOR As Int = 40dip


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
	CrearOpcionServidor
	UI.AplicarTema(Root)
End Sub

Private Sub CrearOpcionServidor
	Dim l As Label
	l.Initialize("lblServidor")
	lblServidor = l
	lblServidor.Tag = Utils.TAG_LINK
	lblServidor.SetTextAlignment("CENTER", "CENTER")
	Root.AddView(lblServidor, MARGEN, Root.Height - ALTO_SERVIDOR - MARGEN, Root.Width - 2 * MARGEN, ALTO_SERVIDOR)
	MostrarServidor
	dlgServidor.Initialize(Root)
	UI.EstilizarDialogo(dlgServidor)
	dlgServidor.Title = Mensajes.TITULO_SERVIDOR
	plantillaServidor.Initialize
	plantillaServidor.lblTitle.Text = Mensajes.TITULO_SERVIDOR
	UI.EstilizarPlantillaTexto(plantillaServidor)
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	If lblServidor.IsInitialized Then lblServidor.SetLayoutAnimated(0, MARGEN, Height - ALTO_SERVIDOR - MARGEN, Width - 2 * MARGEN, ALTO_SERVIDOR)
End Sub

Private Sub MostrarServidor
	Dim url As String = Api.UrlServidor
	If url = "" Then lblServidor.Text = Mensajes.SERVIDOR_SIN_CONFIGURAR Else lblServidor.Text = Mensajes.ROTULO_SERVIDOR & url
End Sub

Private Sub lblServidor_Click
	PedirServidor
End Sub

Private Sub PedirServidor As ResumableSub
	plantillaServidor.Text = Api.UrlServidor
	Wait For (dlgServidor.ShowTemplate(plantillaServidor, Mensajes.GUARDAR, "", Mensajes.CANCELAR)) Complete (Resultado As Int)
	If Resultado <> xui.DialogResponse_Positive Then Return False
	Dim error As String = Api.ValidarUrl(plantillaServidor.Text)
	If error <> "" Then
		xui.MsgboxAsync(error, Mensajes.TITULO)
		Return False
	End If
	Api.GuardarUrl(plantillaServidor.Text)
	MostrarServidor
	Return True
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
	'If Api.UrlServidor = "" Then
	'	Wait For (PedirServidor) Complete (Guardada As Boolean)
	'	If Guardada = False Then Return
	'End If
	'indicator.show
'	If flujoIngreso.IsInitialized = False Then flujoIngreso.Initialize
	'Wait For (flujoIngreso.Ingresar(TextUsername.Text, Textpassword.Text)) Complete (Mensaje As String)
	'indicator.Hide
'	If Mensaje <> "" Then
	'	xui.MsgboxAsync(Mensaje, Mensajes.TITULO)
	'	Return
	'End If
	'Textpassword.Text = ""
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




