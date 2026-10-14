B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
' Pagina de ingreso: lee correo y clave, llama a PresentadorIngreso y pinta lo
' que devuelve. Tambien registra las demas paginas de la app.
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
	Private PClienteDetalle As B4XClienteDetalle

	Private presentador As PresentadorIngreso
	Private huella As Desbloqueo
	Private lblDesbloqueo As B4XView
	Private ofrecido As Boolean
	Private visible As Boolean
	Private indicator As WaitIndicator
	Private TextUsername As B4XFloatTextField
	Private Textpassword As B4XFloatTextField
	Private lblServidor As B4XView
	Private dlgServidor As B4XDialog
	Private plantillaServidor As B4XInputTemplate
End Sub

Public Sub Initialize
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	presentador.Initialize
	Layouts.Inicializar
	indicator.Initialize(Root, 150dip, 150dip)
	ime.Initialize("ime")
	SetTopBarColorAndTitle(Colores.COLOR_PRIMARIO, xui.Color_White, "")
	InicializarPaginas
	Root.LoadLayout("PageLogin")
	CrearOpcionServidor
	CrearOpcionDesbloqueo
	UI.AplicarTema(Root)
End Sub

Private Sub B4XPage_Appear
	visible = True
	lblDesbloqueo.Visible = presentador.PuedeDesbloquear
	If lblDesbloqueo.Visible And ofrecido = False Then
		ofrecido = True
		Desbloquear
	End If
End Sub

Private Sub CrearOpcionDesbloqueo
	huella.Initialize
	lblDesbloqueo.Text = Mensajes.DESBLOQUEO_ENTRAR
End Sub

Private Sub lblDesbloqueo_Click
	Desbloquear
End Sub

Private Sub Desbloquear
	Wait For (huella.Pedir(Mensajes.DESBLOQUEO_TITULO, presentador.NombreGuardado)) Complete (Identificado As Boolean)
	If visible = False Or Identificado = False Then Return
	presentador.AbrirSinConexion
	B4XPages.ShowPageAndRemovePreviousPages(Layouts.PAGINA_INICIO)
End Sub

Private Sub B4XPage_Disappear
	visible = False
End Sub

Private Sub InicializarPaginas
	Phome.Initialize
	PCotizacion.Initialize
	PEspecificaciones.Initialize
	PCLientes.Initialize
	PClienteDetalle.Initialize
	B4XPages.AddPageAndCreate(Layouts.PAGINA_INICIO, Phome)
	B4XPages.AddPageAndCreate(Layouts.PAGINA_COTIZACION, PCotizacion)
	B4XPages.AddPageAndCreate(Layouts.PAGINA_ESPECIFICACIONES, PEspecificaciones)
	B4XPages.AddPageAndCreate(Layouts.PAGINA_CLIENTES, PCLientes)
	B4XPages.AddPageAndCreate(Layouts.PAGINA_CLIENTE_DETALLE, PClienteDetalle)
End Sub

Private Sub CrearOpcionServidor
	lblServidor.Text = presentador.TextoServidor
	dlgServidor.Initialize(Root)
	UI.EstilizarDialogo(dlgServidor)
	dlgServidor.Title = Mensajes.TITULO_SERVIDOR
	plantillaServidor.Initialize
	plantillaServidor.lblTitle.Text = Mensajes.TITULO_SERVIDOR
	UI.EstilizarPlantillaTexto(plantillaServidor)
End Sub

Private Sub lblServidor_Click
	PedirServidor
End Sub

Private Sub PedirServidor As ResumableSub
	plantillaServidor.Text = Api.UrlServidor
	Dim rs As Object = dlgServidor.ShowTemplate(plantillaServidor, Mensajes.GUARDAR, "", Mensajes.CANCELAR)
	UI.AjustarBarraTitulo(dlgServidor)
	UI.CentrarDialogo(dlgServidor)
	Wait For (rs) Complete (Respuesta As Int)
	If Respuesta <> xui.DialogResponse_Positive Then Return False
	Dim r As Resultado = presentador.GuardarServidor(plantillaServidor.Text)
	If r.Ok = False Then
		xui.MsgboxAsync(r.Mensaje, Mensajes.TITULO)
		Return False
	End If
	lblServidor.Text = presentador.TextoServidor
	Return True
End Sub

Private Sub btnIngresar_Click
	If presentador.PROBAR_SIN_SERVIDOR Then
		B4XPages.ShowPageAndRemovePreviousPages(Layouts.PAGINA_INICIO)
		Return
	End If
	If presentador.FaltaServidor Then
		Wait For (PedirServidor) Complete (Guardada As Boolean)
		If Guardada = False Then Return
	End If
	indicator.show
	Wait For (presentador.Ingresar(TextUsername.Text, Textpassword.Text)) Complete (r As Resultado)
	indicator.Hide
	If visible = False Then Return
	If r.Ok = False Then
		xui.MsgboxAsync(r.Mensaje, Mensajes.TITULO)
		Return
	End If
	Textpassword.Text = ""
	B4XPages.ShowPageAndRemovePreviousPages(Layouts.PAGINA_INICIO)
End Sub

Private Sub SetTopBarColorAndTitle (BackgroundColor As Int, TitleColor As String, Title As String)
	Dim top As B4XView = xui.CreatePanel("")
	top.Color = BackgroundColor
	Dim act As Activity = B4XPages.GetNativeParent(Me)
	Dim r As Rect = ime.GetContentRect
	act.AddView(top, 0, 0, act.Width, r.Top)
	Dim cs As CSBuilder
	cs.Initialize.Color(TitleColor).Append(Title).Pop
	B4XPages.SetTitle(Me, cs)
End Sub
