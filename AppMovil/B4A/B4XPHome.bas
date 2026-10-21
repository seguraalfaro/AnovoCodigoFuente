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
	Private CbEstado As B4XComboBox
	Private dialogoFecha As B4XDialog
	Private dialogoFicha As B4XDialog
	Private plantillaFecha As B4XDateTemplate
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
	Private lblKpi1Icono, lblKpi2Icono, lblKpi3Icono, lblKpi4Icono As B4XView
	Private lblUltimas, lblVerTodas As B4XView
	Private pnUltimas As B4XView
	Private Const MARGEN_LISTA As Int = 4dip
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
	Private Const RADIO_ICONO As Int = 10dip
	Private Const RELLENO_RESUMEN As Int = 12dip
	Private Const ALTO_FILA_RESUMEN As Int = 28dip
	Private Const ALTO_BARRA As Int = 6dip
	Private Const ANCHO_TEXTO_RESUMEN As Int = 140dip
	Private Const ANCHO_CUENTA As Int = 28dip
	Private Const ALTO_FILA_FICHA As Int = 34dip
	Private Const ANCHO_FICHA As Int = 340dip
	Private Const RELLENO_FICHA As Int = 16dip
	Private Const ARRIBA_FICHA As Int = 20dip
	Private Const ABAJO_FICHA As Int = 4dip
	Private Const FILTRO_TAMANO As Int = 13
	Private Const PESTANA_SOLICITUDES As Int = 4
	Private lblClienteIniciales, lblClienteNombre, lblClienteDetalle, lblClienteEstado As B4XView
	Private BtnNuevo As B4XView

	Private Const PESTANAS As Int = 5
	Private Const PESTANA_INICIO As Int = 1
	Private Const PESTANA_CLIENTES As Int = 2
	Private Const PESTANA_PERFIL As Int = 5
	Private pestanaActual As Int
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
	AplicarPermisos
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
	Menu.SetCurrentTab2(PESTANA_INICIO, False)
	pestanaActual = PESTANA_INICIO
End Sub

Private Sub AplicarPermisos
	BtnNuevo.Visible = inicio.CreaClientes
	lblVerTodas.Visible = inicio.VeSolicitudes
	Dim aviso As String
	If pestanaActual = PESTANA_CLIENTES Then aviso = inicio.AvisoClientes
	If pestanaActual = PESTANA_SOLICITUDES Then aviso = inicio.AvisoSolicitudes
	If aviso = "" Then Return
	pestanaActual = PESTANA_INICIO
	Menu.SetCurrentTab2(PESTANA_INICIO, False)
	AHViewHOme.GotoPage(HOJA_INICIO, False)
End Sub

Private Sub Bloqueada (Aviso As String) As Boolean
	If Aviso = "" Then Return False
	Menu.SetCurrentTab2(pestanaActual, False)
	xui.MsgboxAsync(Aviso, Mensajes.TITULO)
	Return True
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
	pestanaActual = PESTANA_INICIO
	AHViewHOme.GotoPage(HOJA_INICIO, True)
	PintarInicio
End Sub

Private Sub Menu_Tab2Click
	If Bloqueada(inicio.AvisoClientes) Then Return
	pestanaActual = PESTANA_CLIENTES
	AHViewHOme.GotoPage(HOJA_CLIENTES, True)
	PintarClientes
End Sub

Private Sub Menu_Tab3Click
	If Bloqueada(inicio.AvisoNueva) Then Return
	B4XPages.ShowPage(Layouts.PAGINA_COTIZACION)
End Sub

Private Sub Menu_Tab4Click
	If Bloqueada(inicio.AvisoSolicitudes) Then Return
	pestanaActual = PESTANA_SOLICITUDES
	AHViewHOme.GotoPage(HOJA_SOLICITUDES, True)
	PintarSolicitudes
End Sub

Private Sub Menu_Tab5Click
	pestanaActual = PESTANA_PERFIL
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
	lblVerTodas.Text = Mensajes.VER_TODAS
	PintarFondoLista(ClvUltimas)
	PintarIconosKpi
	Dim titulos As List = inicio.KpiTitulos
	Dim etiquetas() As B4XView = Array As B4XView(lblKpi1Titulo, lblKpi2Titulo, lblKpi3Titulo, lblKpi4Titulo)
	For i = 0 To etiquetas.Length - 1
		etiquetas(i).Text = titulos.Get(i)
	Next
	topKpis = pnKpi1.Top
	bajoRetomar.Initialize
	For Each v As B4XView In Array As B4XView(pnKpi1, pnKpi2, pnKpi3, pnKpi4, pnUltimas)
		bajoRetomar.Add(Array As Object(v, v.Top - topKpis))
	Next
End Sub

Private Sub PintarFondoLista (Lista As CustomListView)
	Lista.AsView.Color = Colores.COLOR_SUPERFICIE
	Lista.sv.Color = Colores.COLOR_SUPERFICIE
End Sub

Private Sub PintarIconosKpi
	Dim iconos() As B4XView = Array As B4XView(lblKpi1Icono, lblKpi2Icono, lblKpi3Icono, lblKpi4Icono)
	Dim glifos() As Int = Array As Int(0xF0F6, 0xF252, 0xF058, 0xF0D6)
	Dim tintas() As Int = Array As Int(Colores.COLOR_PRIMARIO, Colores.COLOR_ADVERTENCIA, Colores.COLOR_EXITO, Colores.COLOR_EXITO)
	Dim fondos() As Int = Array As Int(Colores.COLOR_PRIMARIO_TENUE, Colores.COLOR_ADVERTENCIA_TENUE, Colores.COLOR_EXITO_TENUE, Colores.COLOR_EXITO_TENUE)
	For i = 0 To iconos.Length - 1
		iconos(i).Text = Chr(glifos(i))
		iconos(i).TextColor = tintas(i)
		iconos(i).SetTextAlignment("CENTER", "CENTER")
		iconos(i).SetColorAndBorder(fondos(i), 0, fondos(i), RADIO_ICONO)
	Next
End Sub

Private Sub AcomodarRetomar (Mostrar As Boolean)
	pnRetomar.Visible = Mostrar
	Dim arriba As Int = topKpis
	If Mostrar = False Then arriba = pnRetomar.Top
	Dim fondo As Int = pnUltimas.Top + pnUltimas.Height
	For Each par As Object In bajoRetomar
		Dim datos() As Object = par
		Dim v As B4XView = datos(0)
		v.Top = arriba + datos(1)
	Next
	pnUltimas.Height = fondo - pnUltimas.Top
	Dim lista As B4XView = ClvUltimas.AsView
	lista.Height = pnUltimas.Height - lista.Top - MARGEN_LISTA
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
	lblSyncIcono.Color = xui.Color_Transparent
	lblSync.Color = xui.Color_Transparent
	lblSincronizar.Color = xui.Color_Transparent
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
	Else
		For Each r As SolicitudReciente In inicio.Recientes
			ClvUltimas.Add(CrearTarjetaSolicitud(ancho, r), r)
		Next
	End If
	Dim resumen As List = solicitudes.ResumenPorGrupo
	If resumen.Size = 0 Then Return
	ClvUltimas.Add(CrearSeccion(ancho, Mensajes.INICIO_RESUMEN), Null)
	ClvUltimas.Add(CrearResumen(ancho, resumen), Null)
End Sub

Private Sub CrearSeccion (Ancho As Int, Texto As String) As B4XView
	Dim item As B4XView = CrearAviso(Ancho, Texto)
	lblSeccion.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	lblSeccion.Font = xui.CreateDefaultBoldFont(16)
	Return item
End Sub

Private Sub CrearResumen (Ancho As Int, Filas As List) As B4XView
	Dim maximo As Int = 1
	For Each o As Object In Filas
		Dim fila() As Object = o
		maximo = Max(maximo, fila(1))
	Next
	Dim alto As Int = Filas.Size * ALTO_FILA_RESUMEN + RELLENO_RESUMEN
	Dim tarjeta As B4XView = xui.CreatePanel("")
	tarjeta.SetLayoutAnimated(0, 0, 0, Ancho, alto)
	Dim item As B4XView = tarjeta
	Dim anchoBarra As Int = tarjeta.Width - ANCHO_TEXTO_RESUMEN - ANCHO_CUENTA - 4 * RELLENO_RESUMEN
	Dim y As Int = 0
	For Each o As Object In Filas
		Dim fila() As Object = o
		Dim cantidad As Int = fila(1)
		Dim texto As B4XView = UI.Etiqueta(fila(0), 13, Colores.COLOR_TEXTO_PRIMARIO, False)
		texto.SetTextAlignment("CENTER", "LEFT")
		tarjeta.AddView(texto, RELLENO_RESUMEN, y, ANCHO_TEXTO_RESUMEN, ALTO_FILA_RESUMEN)
		Dim pista As B4XView = xui.CreatePanel("")
		tarjeta.AddView(pista, 2 * RELLENO_RESUMEN + ANCHO_TEXTO_RESUMEN, y + (ALTO_FILA_RESUMEN - ALTO_BARRA) / 2, anchoBarra, ALTO_BARRA)
		pista.SetColorAndBorder(Colores.COLOR_FONDO_PANTALLA, 0, Colores.COLOR_FONDO_PANTALLA, ALTO_BARRA / 2)
		Dim barra As B4XView = xui.CreatePanel("")
		pista.AddView(barra, 0, 0, Max(ALTO_BARRA, anchoBarra * cantidad / maximo), ALTO_BARRA)
		barra.SetColorAndBorder(Colores.COLOR_PRIMARIO_CLARO, 0, Colores.COLOR_PRIMARIO_CLARO, ALTO_BARRA / 2)
		Dim cuenta As B4XView = UI.Etiqueta(cantidad, 13, Colores.COLOR_TEXTO_PRIMARIO, True)
		cuenta.SetTextAlignment("CENTER", "RIGHT")
		tarjeta.AddView(cuenta, tarjeta.Width - RELLENO_RESUMEN - ANCHO_CUENTA, y, ANCHO_CUENTA, ALTO_FILA_RESUMEN)
		y = y + ALTO_FILA_RESUMEN
	Next
	Return item
End Sub

Private Sub ClvUltimas_ItemClick (Index As Int, Value As Object)
	If Value Is SolicitudReciente Then
		Dim r As SolicitudReciente = Value
		MostrarFicha(solicitudes.FilaDe(r.Uuid))
	End If
End Sub

Private Sub lblVerTodas_Click
	Menu.SetCurrentTab2(PESTANA_SOLICITUDES, False)
	Menu_Tab4Click
End Sub

Private Sub MostrarFicha (f As SeguimientoFila)
	If f.IsInitialized = False Then Return
	If dialogoFicha.IsInitialized = False Then
		dialogoFicha.Initialize(Root)
		UI.EstilizarDialogo(dialogoFicha)
	End If
	Dim filas As List = solicitudes.FilasFicha(f)
	Dim ancho As Int = Min(Root.Width - 48dip, ANCHO_FICHA)
	Dim util As Int = ancho - 2 * RELLENO_FICHA
	Dim contenido As B4XView = xui.CreatePanel("")
	contenido.SetLayoutAnimated(0, 0, 0, ancho, ARRIBA_FICHA + filas.Size * ALTO_FILA_FICHA + ABAJO_FICHA)
	Dim y As Int = ARRIBA_FICHA
	For Each o As Object In filas
		Dim par() As String = o
		Dim rotulo As B4XView = UI.Etiqueta(par(0), 13, Colores.COLOR_TEXTO_SECUNDARIO, False)
		rotulo.SetTextAlignment("CENTER", "LEFT")
		contenido.AddView(rotulo, RELLENO_FICHA, y, util * 0.4, ALTO_FILA_FICHA)
		Dim valor As B4XView = UI.Etiqueta(par(1), 14, Colores.COLOR_TEXTO_PRIMARIO, True)
		valor.SetTextAlignment("CENTER", "RIGHT")
		contenido.AddView(valor, RELLENO_FICHA + util * 0.4, y, util * 0.6, ALTO_FILA_FICHA)
		y = y + ALTO_FILA_FICHA
	Next
	dialogoFicha.Title = f.Proyecto
	Dim rs As Object = dialogoFicha.ShowCustom(contenido, Mensajes.FICHA_CERRAR, "", "")
	UI.AjustarBarraTitulo(dialogoFicha)
	UI.CentrarDialogo(dialogoFicha)
	Wait For (rs) Complete (Resultado As Int)
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
	For Each filtro As B4XView In Array As B4XView(lblFiltroMes, lblFiltroTodas, lblFiltroRango)
		filtro.Font = xui.CreateDefaultFont(FILTRO_TAMANO)
		filtro.SetTextAlignment("CENTER", "CENTER")
	Next
	CbEstado.SetItems(solicitudes.Estados)
	PintarFondoLista(ClvSolicitudes)
	CbEstado.cmbBox.TextSize = FILTRO_TAMANO + 1
	CbEstado.cmbBox.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	CbEstado.mBase.SetColorAndBorder(Colores.COLOR_SUPERFICIE, 1dip, Colores.COLOR_BORDE, RADIO_FILTRO)
End Sub

Private Sub PintarSolicitudes
	solicitudes.Actualizar
	lblSolTotal.Text = solicitudes.TotalTexto
	lblSolTotal.SetColorAndBorder(Colores.COLOR_PRIMARIO_TENUE, 0, Colores.COLOR_PRIMARIO_TENUE, lblSolTotal.Height / 2)
	PintarFiltro(lblFiltroMes, solicitudes.Periodo = solicitudes.PERIODO_MES)
	PintarFiltro(lblFiltroTodas, solicitudes.Periodo = solicitudes.PERIODO_TODAS)
	PintarFiltro(lblFiltroRango, solicitudes.Periodo = solicitudes.PERIODO_RANGO)
	lblFiltroRango.Text = solicitudes.TextoRango
	CbEstado.SelectedIndex = solicitudes.IndiceEstado
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

Private Sub CbEstado_SelectedIndexChanged (Index As Int)
	solicitudes.Estado = CbEstado.GetItem(Index)
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
		UI.EstilizarFecha(plantillaFecha)
	End If
	plantillaFecha.Date = Inicial
	dialogoFecha.Title = Titulo
	Dim rs As Object = dialogoFecha.ShowTemplate(plantillaFecha, Mensajes.ELEGIR, "", Mensajes.CANCELAR)
	UI.AjustarBarraTitulo(dialogoFecha)
	UI.CentrarDialogo(dialogoFecha)
	Wait For (rs) Complete (Resultado As Int)
	Dim elegida As Long = 0
	If Resultado = xui.DialogResponse_Positive Then elegida = plantillaFecha.Date
	Return elegida
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

Private Sub ClvSolicitudes_ItemClick (Index As Int, Value As Object)
	If Value Is SeguimientoFila Then MostrarFicha(Value)
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
	Wait For (inicio.CerrarSesion) Complete (Hecho As Boolean)
	Api.VolverAlIngreso("")
End Sub

Public Sub SincronizacionTerminada (Resultado As ResumenSync)
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
