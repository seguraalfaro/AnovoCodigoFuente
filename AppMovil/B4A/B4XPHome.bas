B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Pagina principal con el menu de cinco pestanas: Inicio, Clientes y Solicitudes pintan lo que
' les dan sus presentadores; Nueva abre la captura y Perfil va en su propia hoja.

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
	Private lblTotal As B4XView
	Private Label1 As B4XView
	Private BuscadorClientes As ASBuscador
	Private clientes As PresentadorClientes
	Private solicitudes As PresentadorSolicitudes
	Private ClvSolicitudes As CustomListView
	Private BuscadorSolicitudes As ASBuscador
	Private lblSolTitulo, lblSolTotal, lblFiltroMes, lblFiltroTodas, lblFiltroRango As B4XView
	Private pnEstados As B4XView
	Private chipsEstado As List
	Private dialogoFecha As B4XDialog
	Private plantillaFecha As B4XDateTemplate
	Private Const ALTO_CHIP As Int = 28dip
	Private Const SEPARACION_CHIP As Int = 6dip
	Private Const RELLENO_CHIP As Int = 24dip
	Private Const RADIO_FILTRO As Int = 8dip
	Private perfil As HojaPerfil
	Private panelPerfil As B4XView

	Private inicio As PresentadorInicio
	Private visible As Boolean
	Private lblSaludo As B4XView
	Private lblFecha As B4XView
	Private pnSync As B4XView
	Private lblSyncIcono As B4XView
	Private lblSync As B4XView
	Private lblSincronizar As B4XView
	Private pnRetomar As B4XView
	Private lblRetomarTitulo As B4XView
	Private lblRetomarDetalle As B4XView
	Private BtnRetomar As B4XView
	Private BtnDescartar As B4XView
	Private lblKpi1Titulo, lblKpi2Titulo, lblKpi3Titulo, lblKpi4Titulo As B4XView
	Private lblKpi1Valor, lblKpi2Valor, lblKpi3Valor, lblKpi4Valor As B4XView
	Private lblUltimas As B4XView
	Private ClvUltimas As CustomListView
	Private pnKpi1, pnKpi2, pnKpi3, pnKpi4 As B4XView
	Private topKpis As Int
	Private bajoRetomar As List
	Private Const ALTO_SOLICITUD As Int = 70dip
	Private Const ALTO_SECCION As Int = 36dip
	Private lblSolicitudTitulo, lblSolicitudDetalle, lblSolicitudEstado, lblSeccion As B4XView
	Private Const RADIO_FRANJA As Int = 8dip
	Private Const ALTO_TARJETA As Int = 62dip
	Private Const SEPARACION As Int = 8dip
	Private Const RADIO_AVATAR As Int = 16dip
	Private Const RADIO_PASTILLA As Int = 9dip
	Private lblClienteIniciales, lblClienteNombre, lblClienteDetalle, lblClienteEstado As B4XView

	Private Const PESTANAS As Int = 5
	Private Const HOJA_INICIO As Int = 0
	Private Const HOJA_CLIENTES As Int = 1
	Private Const HOJA_SOLICITUDES As Int = 3
	Private Const HOJA_PERFIL As Int = 4
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

#Region Ciclo de la página
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageHome")
	B4XPages.SetTitle(Me, Mensajes.TITULO)
	B4XPages.AddMenuItem(Me, Mensajes.MENU_SINCRONIZAR)
	B4XPages.AddMenuItem(Me, Mensajes.MENU_CERRAR_SESION)
	inicio.Initialize
	clientes.Initialize
	solicitudes.Initialize
	InicializarHojas
	perfil.Initialize(panelPerfil, Me, Root)
	InicializarMenu
	PrepararInicio
	PrepararClientes
	PrepararSolicitudes
	PedirPermisoAvisos
End Sub

Private Sub PedirPermisoAvisos
	Dim rp As RuntimePermissions
	If rp.Check(Sincronizacion.PERMISO_AVISOS) Then Return
	rp.CheckAndRequest(Sincronizacion.PERMISO_AVISOS)
	Wait For B4XPage_PermissionResult (Permission As String, Result As Boolean)
End Sub

Private Sub B4XPage_Appear
	visible = True
	Sincronizacion.Pedir
	Refrescar
End Sub

Private Sub Refrescar
	PintarInicio
	PintarClientes
	PintarSolicitudes
End Sub

Private Sub B4XPage_Disappear
	visible = False
End Sub

Private Sub B4XPage_Foreground
	Sincronizacion.Pedir
	Refrescar
End Sub
#End Region

#Region Menú y navegación
Private Sub B4XPage_MenuClick (Tag As String)
	If Tag = Mensajes.MENU_SINCRONIZAR Then AbrirSincronizacion
	If Tag = Mensajes.MENU_CERRAR_SESION Then CerrarSesion
End Sub

Private Sub InicializarMenu
	Menu.SetTabTextIcon(1, Mensajes.TAB_INICIO, Chr(0xF015), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(2, Mensajes.TAB_CLIENTES, Chr(0xF0C0), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(3, Mensajes.TAB_NUEVA, Chr(0xF067), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(4, Mensajes.TAB_SOLICITUDES, Chr(0xF15C), Typeface.FONTAWESOME)
	Menu.SetTabTextIcon(5, Mensajes.TAB_PERFIL, Chr(0xF007), Typeface.FONTAWESOME)
	Menu.SetCurrentTab2(1, False)
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
		Case 0: hoja.LoadLayout("PageInicio")
		Case 1: hoja.LoadLayout("Pageclientes")
		Case 3: hoja.LoadLayout("PageSolicitudes")
		Case 4: panelPerfil = hoja
	End Select
	UI.AplicarTema(hoja)
	Return hoja
End Sub

Private Sub Menu_Tab1Click
	AHViewHOme.GotoPage(HOJA_INICIO, True)
	PintarInicio
End Sub

Private Sub Menu_Tab2Click
	AHViewHOme.GotoPage(HOJA_CLIENTES, True)
	PintarClientes
End Sub

Private Sub Menu_Tab3Click
	B4XPages.ShowPage(Layouts.PAGINA_COTIZACION)
End Sub

Private Sub Menu_Tab4Click
	AHViewHOme.GotoPage(HOJA_SOLICITUDES, True)
	PintarSolicitudes
End Sub

Private Sub Menu_Tab5Click
	AHViewHOme.GotoPage(HOJA_PERFIL, True)
	perfil.Mostrar
End Sub
#End Region

#Region Inicio
Private Sub PrepararInicio
	lblRetomarTitulo.Text = Mensajes.INICIO_RETOMAR_TITULO
	BtnRetomar.Text = Mensajes.INICIO_RETOMAR
	BtnDescartar.Text = Mensajes.INICIO_DESCARTAR
	lblUltimas.Text = Mensajes.INICIO_ULTIMAS
	Dim titulos As List = inicio.KpiTitulos
	Dim etiquetas() As B4XView = Array As B4XView(lblKpi1Titulo, lblKpi2Titulo, lblKpi3Titulo, lblKpi4Titulo)
	For i = 0 To etiquetas.Length - 1
		etiquetas(i).Text = titulos.Get(i)
	Next
	topKpis = pnKpi1.Top
	bajoRetomar.Initialize
	For Each v As B4XView In Array As B4XView(pnKpi1, pnKpi2, pnKpi3, pnKpi4, lblUltimas, ClvUltimas.AsView)
		bajoRetomar.Add(Array As Object(v, v.Top - topKpis))
	Next
End Sub

Private Sub AcomodarRetomar (Mostrar As Boolean)
	pnRetomar.Visible = Mostrar
	Dim arriba As Int = topKpis
	If Mostrar = False Then arriba = pnRetomar.Top
	Dim lista As B4XView = ClvUltimas.AsView
	Dim fondo As Int = lista.Top + lista.Height
	For Each par As Object In bajoRetomar
		Dim datos() As Object = par
		Dim v As B4XView = datos(0)
		v.Top = arriba + datos(1)
	Next
	lista.Height = fondo - lista.Top
	ClvUltimas.Base_Resize(lista.Width, lista.Height)
End Sub

Private Sub PintarInicio
	inicio.Actualizar
	lblSaludo.Text = inicio.Saludo
	lblFecha.Text = inicio.Fecha
	PintarFranja(inicio.Franja)
	AcomodarRetomar(inicio.HayBorrador)
	lblRetomarDetalle.Text = inicio.DetalleBorrador
	Dim valores As List = inicio.KpiValores
	Dim etiquetas() As B4XView = Array As B4XView(lblKpi1Valor, lblKpi2Valor, lblKpi3Valor, lblKpi4Valor)
	For i = 0 To etiquetas.Length - 1
		etiquetas(i).Text = valores.Get(i)
	Next
	PintarRecientes
End Sub

Private Sub PintarFranja (f As FranjaSync)
	pnSync.SetColorAndBorder(f.Fondo, 0, f.Fondo, RADIO_FRANJA)
	lblSyncIcono.Text = f.Glifo
	lblSyncIcono.TextColor = f.Tinta
	lblSync.Text = f.Texto
	lblSync.TextColor = f.Tinta
	lblSincronizar.Text = f.Accion
	lblSincronizar.TextColor = f.Tinta
	lblSincronizar.Visible = f.Accion <> ""
End Sub

Private Sub PintarRecientes
	ClvUltimas.Clear
	Dim ancho As Int = ClvUltimas.AsView.Width
	If inicio.Recientes.Size = 0 Then
		ClvUltimas.Add(CrearAviso(ancho, Mensajes.INICIO_SIN_RECIENTES), Null)
		Return
	End If
	For Each r As SolicitudReciente In inicio.Recientes
		ClvUltimas.Add(CrearTarjetaSolicitud(ancho, r), r)
	Next
End Sub

Private Sub CrearTarjetaSolicitud (Ancho As Int, r As SolicitudReciente) As B4XView
	Dim item As B4XView = xui.CreatePanel("")
	item.SetLayoutAnimated(0, 0, 0, Ancho, ALTO_SOLICITUD)
	item.LoadLayout("ItemSolicitud")
	lblSolicitudTitulo.Text = inicio.TituloDe(r)
	lblSolicitudDetalle.Text = inicio.DetalleDe(r)
	lblSolicitudEstado.Text = inicio.EstadoDe(r)
	lblSolicitudEstado.TextColor = inicio.ColorDe(r)
	lblSolicitudEstado.SetColorAndBorder(inicio.FondoDe(r), 0, inicio.FondoDe(r), RADIO_PASTILLA)
	Return item
End Sub

Private Sub CrearAviso (Ancho As Int, Texto As String) As B4XView
	Dim item As B4XView = xui.CreatePanel("")
	item.SetLayoutAnimated(0, 0, 0, Ancho, ALTO_SECCION)
	item.LoadLayout("ItemSeccion")
	lblSeccion.Text = Texto
	lblSeccion.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
	lblSeccion.Font = xui.CreateDefaultFont(14)
	Return item
End Sub

Private Sub BtnRetomar_Click
	Dim cotizacion As B4XCotizacion = B4XPages.GetPage(Layouts.PAGINA_COTIZACION)
	cotizacion.RetomarBorrador
	B4XPages.ShowPage(Layouts.PAGINA_COTIZACION)
End Sub

Private Sub BtnDescartar_Click
	Dim sf As Object = xui.Msgbox2Async(Mensajes.INICIO_CONFIRMAR_DESCARTE, Mensajes.TITULO, Mensajes.SI, "", Mensajes.NO, Null)
	Wait For (sf) Msgbox_Result (Respuesta As Int)
	If visible = False Or Respuesta <> xui.DialogResponse_Positive Then Return
	inicio.DescartarBorrador
	PintarInicio
End Sub
#End Region

#Region Clientes
Private Sub PrepararClientes
	BuscadorClientes.Comparar(Me, "TextoFilaCliente")
	Label1.Text = Mensajes.MIS_CLIENTES
	Label1.Font = xui.CreateDefaultBoldFont(16)
	Label1.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	lblTotal.SetTextAlignment("CENTER", "CENTER")
	lblTotal.Font = xui.CreateDefaultBoldFont(12)
	lblTotal.TextColor = Colores.COLOR_PRIMARIO
End Sub

Private Sub PintarClientes
	clientes.Actualizar
	lblTotal.Text = clientes.TotalTexto
	lblTotal.SetColorAndBorder(Colores.COLOR_PRIMARIO_TENUE, 0, Colores.COLOR_PRIMARIO_TENUE, lblTotal.Height / 2)
	MostrarVacio(clientes.Total = 0, Chr(0xF0C0), Mensajes.SIN_CLIENTES_TITULO, Mensajes.SIN_CLIENTES_TEXTO)
	BuscadorClientes.setFuente(clientes.Filas)
End Sub

Private Sub BuscadorClientes_Filtrado (Resultado As List)
	ClvClientes.Clear
	Dim ancho As Int = ClvClientes.AsView.Width
	For Each f As ClienteFila In Resultado
		ClvClientes.Add(CrearTarjetaCliente(ancho, f), f)
	Next
End Sub

Private Sub TextoFilaCliente (o As Object) As String 'ignore
	Return clientes.TextoBusqueda(o)
End Sub

Private Sub CrearTarjetaCliente (Ancho As Int, f As ClienteFila) As B4XView
	Dim item As B4XView = xui.CreatePanel("")
	item.SetLayoutAnimated(0, 0, 0, Ancho, ALTO_TARJETA + SEPARACION)
	item.LoadLayout("ItemCliente")
	Dim fondo As Int = Colores.COLOR_EXITO_TENUE
	Dim tinta As Int = Colores.COLOR_EXITO
	If clientes.EsJuridica(f) Then
		fondo = Colores.COLOR_PRIMARIO_TENUE
		tinta = Colores.COLOR_PRIMARIO
	End If
	lblClienteIniciales.Text = clientes.Iniciales(f)
	lblClienteIniciales.TextColor = tinta
	lblClienteIniciales.SetColorAndBorder(fondo, 0, fondo, RADIO_AVATAR)
	lblClienteNombre.Text = clientes.TituloDe(f)
	lblClienteDetalle.Text = clientes.DetalleDe(f)
	lblClienteEstado.Text = clientes.EstadoDe(f)
	lblClienteEstado.TextColor = clientes.TintaDe(f)
	lblClienteEstado.SetColorAndBorder(clientes.FondoDe(f), 0, clientes.FondoDe(f), RADIO_PASTILLA)
	Return item
End Sub

Private Sub ClvClientes_ItemClick (Index As Int, Value As Object)
	Dim f As ClienteFila = Value
	AbrirCliente(f.Datos)
End Sub

Private Sub AbrirCliente (c As Cliente)
	Dim ficha As B4XClienteDetalle = B4XPages.GetPage(Layouts.PAGINA_CLIENTE_DETALLE)
	ficha.Mostrar(c)
	B4XPages.ShowPage(Layouts.PAGINA_CLIENTE_DETALLE)
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
#End Region

#Region Solicitudes
Private Sub PrepararSolicitudes
	BuscadorSolicitudes.Comparar(Me, "TextoFilaSolicitud")
	lblSolTitulo.Text = Mensajes.MIS_SOLICITUDES
	lblSolTitulo.Font = xui.CreateDefaultBoldFont(16)
	lblSolTitulo.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	lblSolTotal.SetTextAlignment("CENTER", "CENTER")
	lblSolTotal.Font = xui.CreateDefaultBoldFont(12)
	lblSolTotal.TextColor = Colores.COLOR_PRIMARIO
	lblFiltroMes.Text = Mensajes.FILTRO_MES
	lblFiltroTodas.Text = Mensajes.FILTRO_TODAS
	CrearChipsEstado
End Sub

Private Sub CrearChipsEstado
	chipsEstado.Initialize
	Dim hsv As HorizontalScrollView
	hsv.Initialize(0, "")
	pnEstados.AddView(hsv, 0, 0, pnEstados.Width, pnEstados.Height)
	Dim x As Int = 0
	Dim lienzo As B4XView = xui.CreatePanel("")
	lienzo.SetLayoutAnimated(0, 0, 0, 1dip, 1dip)
	Dim medida As B4XCanvas
	medida.Initialize(lienzo)
	For Each texto As String In solicitudes.Estados
		Dim l As Label
		l.Initialize("ChipEstado")
		l.Tag = Utils.TAG_RAW
		l.SingleLine = True
		Dim chip As B4XView = l
		chip.Text = texto
		chip.Font = xui.CreateDefaultBoldFont(12)
		chip.SetTextAlignment("CENTER", "CENTER")
		Dim ancho As Int = medida.MeasureText(texto, chip.Font).Width + RELLENO_CHIP
		hsv.Panel.AddView(chip, x, (pnEstados.Height - ALTO_CHIP) / 2, ancho, ALTO_CHIP)
		chipsEstado.Add(chip)
		x = x + ancho + SEPARACION_CHIP
	Next
	medida.Release
	hsv.Panel.Width = x
End Sub

Private Sub PintarSolicitudes
	solicitudes.Actualizar
	lblSolTotal.Text = solicitudes.TotalTexto
	lblSolTotal.SetColorAndBorder(Colores.COLOR_PRIMARIO_TENUE, 0, Colores.COLOR_PRIMARIO_TENUE, lblSolTotal.Height / 2)
	PintarFiltro(lblFiltroMes, solicitudes.Periodo = solicitudes.PERIODO_MES)
	PintarFiltro(lblFiltroTodas, solicitudes.Periodo = solicitudes.PERIODO_TODAS)
	PintarFiltro(lblFiltroRango, solicitudes.Periodo = solicitudes.PERIODO_RANGO)
	lblFiltroRango.Text = solicitudes.TextoRango
	For Each chip As B4XView In chipsEstado
		PintarFiltro(chip, solicitudes.EstadoActivo(chip.Text))
	Next
	BuscadorSolicitudes.setFuente(solicitudes.Filas)
End Sub

Private Sub PintarFiltro (Etiqueta As B4XView, Activo As Boolean)
	If Activo Then
		Etiqueta.SetColorAndBorder(Colores.COLOR_PRIMARIO, 0, Colores.COLOR_PRIMARIO, RADIO_FILTRO)
		Etiqueta.TextColor = Colores.COLOR_TEXTO_SOBRE_PRIMARIO
	Else
		Etiqueta.SetColorAndBorder(Colores.COLOR_SUPERFICIE, 1dip, Colores.COLOR_BORDE, RADIO_FILTRO)
		Etiqueta.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	End If
End Sub

Private Sub lblFiltroMes_Click
	solicitudes.Periodo = solicitudes.PERIODO_MES
	PintarSolicitudes
End Sub

Private Sub lblFiltroTodas_Click
	solicitudes.Periodo = solicitudes.PERIODO_TODAS
	PintarSolicitudes
End Sub

Private Sub ChipEstado_Click
	Dim chip As B4XView = Sender
	solicitudes.Estado = chip.Text
	PintarSolicitudes
End Sub

Private Sub lblFiltroRango_Click
	Wait For (PedirFecha(Mensajes.FECHA_DESDE, solicitudes.RangoDesde)) Complete (Desde As Long)
	If Desde = 0 Then Return
	Wait For (PedirFecha(Mensajes.FECHA_HASTA, solicitudes.RangoHasta)) Complete (Hasta As Long)
	If Hasta = 0 Then Return
	Dim r As Resultado = solicitudes.FijarRango(Desde, Hasta)
	If r.Ok = False Then
		xui.MsgboxAsync(r.Mensaje, Mensajes.TITULO)
		Return
	End If
	PintarSolicitudes
End Sub

Private Sub PedirFecha (Titulo As String, Inicial As Long) As ResumableSub
	If dialogoFecha.IsInitialized = False Then
		dialogoFecha.Initialize(Root)
		UI.EstilizarDialogo(dialogoFecha)
		plantillaFecha.Initialize
	End If
	plantillaFecha.Date = Inicial
	dialogoFecha.Title = Titulo
	Dim rs As Object = dialogoFecha.ShowTemplate(plantillaFecha, Mensajes.ELEGIR, "", Mensajes.CANCELAR)
	UI.AjustarBarraTitulo(dialogoFecha)
	UI.CentrarDialogo(dialogoFecha)
	Wait For (rs) Complete (Resultado As Int)
	If Resultado <> xui.DialogResponse_Positive Then Return 0
	Return plantillaFecha.Date
End Sub

Private Sub BuscadorSolicitudes_Filtrado (Resultado As List)
	ClvSolicitudes.Clear
	Dim ancho As Int = ClvSolicitudes.AsView.Width
	If Resultado.Size = 0 Then
		ClvSolicitudes.Add(CrearAviso(ancho, solicitudes.TextoVacio), Null)
		Return
	End If
	For Each f As SeguimientoFila In Resultado
		ClvSolicitudes.Add(CrearTarjetaSeguimiento(ancho, f), f)
	Next
End Sub

Private Sub TextoFilaSolicitud (o As Object) As String 'ignore
	Return solicitudes.TextoBusqueda(o)
End Sub

Private Sub CrearTarjetaSeguimiento (Ancho As Int, f As SeguimientoFila) As B4XView
	Dim item As B4XView = xui.CreatePanel("")
	item.SetLayoutAnimated(0, 0, 0, Ancho, ALTO_SOLICITUD)
	item.LoadLayout("ItemSolicitud")
	lblSolicitudTitulo.Text = solicitudes.TituloDe(f)
	lblSolicitudDetalle.Text = solicitudes.DetalleDe(f)
	lblSolicitudEstado.Text = solicitudes.EstadoDe(f)
	lblSolicitudEstado.TextColor = solicitudes.TintaDe(f)
	lblSolicitudEstado.SetColorAndBorder(solicitudes.FondoDe(f), 0, solicitudes.FondoDe(f), RADIO_PASTILLA)
	Return item
End Sub
#End Region

#Region Sincronización y sesión
Public Sub CerrarSesion
	Dim sf As Object = xui.Msgbox2Async(Mensajes.CONFIRMAR_CIERRE, Mensajes.TITULO, Mensajes.SI, "", Mensajes.NO, Null)
	Wait For (sf) Msgbox_Result (Respuesta As Int)
	If Respuesta <> xui.DialogResponse_Positive Then Return
	If LlaveDispositivo.HayLlave Then
		Wait For (ApiAutenticacion.CerrarDispositivo(LlaveDispositivo.Uuid, LlaveDispositivo.Leer).Enviar) Complete (Cierre As RestRespuesta)
	End If
	LlaveDispositivo.BorrarTodo
	Api.VolverAlIngreso("")
End Sub

Public Sub SincronizacionTerminada (Resultado As ResumenSync)
	If Resultado.SesionVencida Then
		Api.VolverAlIngreso(Resultado.Mensaje)
		Return
	End If
	Refrescar
End Sub

Private Sub Sincronizar
	Sincronizacion.Forzar
	PintarInicio
End Sub

Private Sub AbrirSincronizacion
	B4XPages.ShowPage(Layouts.PAGINA_SINCRONIZACION)
End Sub

Private Sub pnSync_Click
	AbrirSincronizacion
End Sub

Private Sub lblSync_Click
	AbrirSincronizacion
End Sub

Private Sub lblSincronizar_Click
	Sincronizar
End Sub
#End Region
