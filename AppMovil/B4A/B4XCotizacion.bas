B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Nueva cotizacion en tres pasos: cliente, detalles y revision. La pagina lee
' los campos y pinta; el borrador, las piezas y las reglas son del presentador.
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private presentador As PresentadorCotizacion
	Private visible As Boolean
	Private restaurando As Boolean
	Private enPieza As Boolean
	Private directo As Boolean
	Private clientePedido As Cliente
	Private hayPedido As Boolean
	Private Const ULTIMO As Int = 2
	Private Const PASO_CLIENTE As Int = 0
	Private Const PASO_DETALLES As Int = 1

	Private Pasos As ASDrawSteps
	Private AHView As AHViewPager
	Private pagecont As AHPageContainer
	Private BtnSiguiente As Button
	Private BtnAtras_sec As Button
	Private ventana As VentanaBuscar

	Private TextClient As B4XFloatTextField
	Private TextContacto As B4XFloatTextField
	Private TextNombreProyecto As B4XFloatTextField

	Private CvPiezas As CustomListView
	Private lblContador_chip As Label
	Private pnVacio As B4XView
	Private lblVacioIcono As Label
	Private lblVacioTitulo As Label
	Private lblVacioTexto As Label
	Private LblNumero As Label
	Private LblNombre As Label
	Private LblDatos As Label
	Private LblEstado As Label
	Private LblEditar As Label
	Private LblEliminar As Label

	Private txtObservaciones As EditText
	Private lblRevisionTitulo, lblRevisionSubtitulo, lblRevClienteTitulo, lblCambiar As B4XView
	Private lblRevClienteRot, lblRevCliente, lblRevContactoRot, lblRevContacto As B4XView
	Private lblRevProyectoRot, lblRevProyecto, lblRevUbicacionRot, lblRevUbicacion As B4XView
	Private lblResumenTitulo, lblRes1Valor, lblRes2Valor, lblRes3Valor, lblRes4Valor As B4XView
	Private lblRes1Titulo, lblRes2Titulo, lblRes3Titulo, lblRes4Titulo As B4XView
	Private lblObservacionesRot, lblContadorObs As B4XView
	Private ime As IME
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageIngresoDatos")
	B4XPages.SetTitle(Me, Mensajes.TITULO_COTIZACION)
	presentador.Initialize
	UI.CargarIndicadorPasos(Pasos, Layouts.CotizacionClaves, Layouts.CotizacionTitulos)
	Dim general As B4XView = UI.PaginaVacia(AHView)
	general.LoadLayout("PageCotizacion1")
	Dim detalle As B4XView = UI.PaginaVacia(AHView)
	detalle.LoadLayout("PageCotizacion2")
	Dim revision As B4XView = UI.PaginaVacia(AHView)
	revision.LoadLayout("PageCotizacion3")
	UI.CargarContenedor(AHView, pagecont, Array As B4XView(general, detalle, revision))
	UI.ConfigurarMemo(txtObservaciones, Mensajes.AYUDA_OBSERVACIONES)
	PrepararRevision
	ime.Initialize("IME")
	ime.AddHandleActionEvent(txtObservaciones)
	UI.AplicarTema(Root)
	UI.CampoDeBusqueda(TextClient, "BuscarCliente")
	UI.CampoDeBusqueda(TextContacto, "BuscarContacto")
	ventana.Initialize(Root)
End Sub

Private Sub PrepararVacio
	If pnVacio.NumberOfViews > 0 Then Return
	pnVacio.LoadLayout("ItemVacio")
	UI.AplicarTema(pnVacio)
	lblVacioIcono.Text = Chr(0xF0AD)
	lblVacioTitulo.Text = Mensajes.SIN_PIEZAS_TITULO
	lblVacioTexto.Text = Mensajes.SIN_PIEZAS_TEXTO
End Sub

Private Sub B4XPage_Appear
	visible = True
	If enPieza Then
		enPieza = False
		Return
	End If
	Dim aceptar As Boolean = directo
	directo = False
	If presentador.HayBorrador Then
		If aceptar = False Then
			Dim sf As Object = xui.Msgbox2Async(Mensajes.RETOMAR_COTIZACION, Mensajes.TITULO, Mensajes.SI, "", Mensajes.NO, Null)
			Wait For (sf) Msgbox_Result (Respuesta As Int)
			If visible = False Then Return
			aceptar = (Respuesta = xui.DialogResponse_Positive)
		End If
		If aceptar And presentador.Restaurar Then
			hayPedido = False
			Pintar
			OfrecerPieza
			Return
		End If
		presentador.DescartarBorrador
	Else
		presentador.Nuevo
	End If
	Limpiar
	If hayPedido Then
		hayPedido = False
		presentador.ElegirCliente(clientePedido)
		PintarCliente
		Persistir
	End If
End Sub

Public Sub RetomarBorrador
	directo = True
End Sub

Public Sub NuevaConCliente (c As Cliente)
	clientePedido = c
	hayPedido = True
End Sub

Private Sub B4XPage_Disappear
	visible = False
	Persistir
End Sub

Private Sub B4XPage_Background
	Persistir
End Sub

Private Sub Persistir
	If restaurando Then Return
	presentador.GuardarBorrador(TextNombreProyecto.Text.Trim, txtObservaciones.Text.Trim, AHView.CurrentPage)
End Sub

Private Sub OfrecerPieza
	Dim especificaciones As B4XEspecificaciones = B4XPages.GetPage(Layouts.PAGINA_ESPECIFICACIONES)
	If especificaciones.HayPiezaSinTerminar = False Then Return
	Dim sf As Object = xui.Msgbox2Async(Mensajes.RetomarPieza(especificaciones.NombrePiezaSinTerminar), Mensajes.TITULO, Mensajes.SI, "", Mensajes.NO, Null)
	Wait For (sf) Msgbox_Result (Respuesta As Int)
	If visible = False Or Respuesta <> xui.DialogResponse_Positive Then Return
	Persistir
	enPieza = True
	especificaciones.RetomarPieza
	B4XPages.ShowPage(Layouts.PAGINA_ESPECIFICACIONES)
End Sub

Private Sub Pintar
	restaurando = True
	PintarCliente
	TextNombreProyecto.Text = presentador.Proyecto
	txtObservaciones.Text = presentador.Observaciones
	PintarPiezas
	restaurando = False
	AHView.GotoPage(presentador.Pagina, True)
End Sub

Private Sub Limpiar
	restaurando = True
	PintarCliente
	TextNombreProyecto.Text = ""
	txtObservaciones.Text = ""
	PintarPiezas
	restaurando = False
	AHView.GotoPage(PASO_CLIENTE, True)
End Sub

Private Sub PintarCliente
	TextClient.Text = presentador.TextoCliente
	TextContacto.Text = presentador.TextoContacto
	TextContacto.TextField.Enabled = presentador.HayCliente
End Sub

Private Sub BuscarCliente_Click
	Wait For (ventana.Elegir(TextClient.mBase, Mensajes.ELEGIR_CLIENTE, Mensajes.AYUDA_BUSCAR_CLIENTE, presentador.OpcionesClientes)) Complete (Valor As Object)
	If visible = False Or Valor = Null Then Return
	presentador.ElegirCliente(Valor)
	PintarCliente
	Persistir
End Sub

Private Sub TextNombreProyecto_FocusChanged (HasFocus As Boolean)
	If HasFocus = False Then Persistir
End Sub

Private Sub BuscarContacto_Click
	If presentador.HayCliente = False Then
		xui.MsgboxAsync(Mensajes.FALTA_CLIENTE, Mensajes.TITULO)
		Return
	End If
	Wait For (ventana.Elegir(TextContacto.mBase, Mensajes.ELEGIR_CONTACTO, Mensajes.AYUDA_BUSCAR_CONTACTO, presentador.OpcionesContactos)) Complete (Valor As Object)
	If visible = False Or Valor = Null Then Return
	presentador.ElegirContacto(Valor)
	PintarCliente
	Persistir
End Sub

Private Sub PintarPiezas
	CvPiezas.Clear
	Dim piezas As List = presentador.Piezas
	For i = 0 To piezas.Size - 1
		Dim p As Pieza = piezas.Get(i)
		CvPiezas.Add(CrearItem(p, i + 1), p.UuidLocal)
	Next
	ActualizarPiezas
End Sub

Private Sub ActualizarPiezas
	Dim hay As Boolean = CvPiezas.Size > 0
	lblContador_chip.Text = CvPiezas.Size
	pnVacio.Visible = Not(hay)
	CvPiezas.AsView.Visible = hay
End Sub

Private Sub CrearItem (p As Pieza, Numero As Int) As B4XView
	Dim item As B4XView = xui.CreatePanel("")
	item.SetLayoutAnimated(0, 0, 0, CvPiezas.AsView.Width, 84dip)
	item.LoadLayout("ItemPieza")
	UI.AplicarTema(item)
	LblNumero.Text = Numero
	LblNombre.Text = p.Nombre
	LblDatos.Text = presentador.DetallePieza(p)
	PintarEstado(p)
	PonerIcono(LblEditar, Chr(0xF040))
	PonerIcono(LblEliminar, Chr(0xF1F8))
	LblEditar.Tag = p.UuidLocal
	LblEliminar.Tag = p.UuidLocal
	Return item
End Sub

Private Sub PintarEstado (p As Pieza)
	Dim cs As CSBuilder
	If presentador.PiezaIncompleta(p) Then
		cs.Initialize.Typeface(Typeface.FONTAWESOME).Append(Chr(0xF071)).Pop.Append("  " & presentador.EstadoPieza(p)).PopAll
		LblEstado.TextColor = Colores.COLOR_ADVERTENCIA
	Else
		cs.Initialize.Append(presentador.EstadoPieza(p)).PopAll
		LblEstado.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
	End If
	LblEstado.Text = cs
End Sub

Private Sub PonerIcono (Etiqueta As Label, Glifo As String)
	Etiqueta.Typeface = Typeface.FONTAWESOME
	Etiqueta.Text = Glifo
End Sub

Public Sub AgregarPieza (p As Pieza)
	Dim nueva As Pieza = presentador.AgregarPieza(p)
	CvPiezas.Add(CrearItem(nueva, CvPiezas.Size + 1), nueva.UuidLocal)
	ActualizarPiezas
	Persistir
End Sub

Public Sub ReemplazarPieza (p As Pieza)
	If presentador.ReemplazarPieza(p) < 0 Then Return
	PintarPiezas
	Persistir
End Sub

Private Sub LblEliminar_Click
	Dim v As B4XView = Sender
	If presentador.QuitarPieza(v.Tag) < 0 Then Return
	PintarPiezas
	Persistir
End Sub

Private Sub LblEditar_Click
	Dim v As B4XView = Sender
	Dim p As Pieza = presentador.PiezaPorUuid(v.Tag)
	If p.UuidLocal = "" Then Return
	Persistir
	enPieza = True
	Dim especificaciones As B4XEspecificaciones = B4XPages.GetPage(Layouts.PAGINA_ESPECIFICACIONES)
	especificaciones.EditarPieza(p)
	B4XPages.ShowPage(Layouts.PAGINA_ESPECIFICACIONES)
End Sub

Private Sub BtnAgregarPieza_Click
	Persistir
	enPieza = True
	Dim especificaciones As B4XEspecificaciones = B4XPages.GetPage(Layouts.PAGINA_ESPECIFICACIONES)
	especificaciones.NuevaPieza
	B4XPages.ShowPage(Layouts.PAGINA_ESPECIFICACIONES)
End Sub

Private Sub BtnSiguiente_Click
	Dim actual As Int = AHView.CurrentPage
	Dim r As Resultado = presentador.ValidarPaso(actual)
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

Private Sub Confirmar
	Dim r As Resultado = presentador.Guardar(TextNombreProyecto.Text, txtObservaciones.Text)
	If r.Ok = False Then
		xui.MsgboxAsync(r.Mensaje, Mensajes.TITULO)
		Return
	End If
	Limpiar
	Sincronizacion.Pedir
	Wait For (xui.MsgboxAsync(Mensajes.SOLICITUD_GUARDADA, Mensajes.TITULO)) Msgbox_Result (Respuesta As Int)
	B4XPages.ClosePage(Me)
End Sub

Private Sub BtnAtras_sec_Click
	If AHView.CurrentPage > 0 Then AHView.GotoPage(AHView.CurrentPage - 1, True)
End Sub

Private Sub Pasos_StepClick (Index As Int, Id As String)
	If Index < AHView.CurrentPage Then AHView.GotoPage(Index, True)
End Sub

Private Sub AHView_PageChanged (Position As Int)
	Pasos.CurrentIndex = Position
	If Position = PASO_DETALLES Then PrepararVacio
	If Position = ULTIMO Then
		PintarRevision
		BtnSiguiente.Text = Mensajes.GUARDAR_COTIZACION
	Else
		BtnSiguiente.Text = Mensajes.SIGUIENTE
	End If
End Sub

Private Sub txtObservaciones_TextChanged (Old As String, New As String)
	If restaurando = False And presentador.ObservacionesExcedidas(New) Then txtObservaciones.Text = Old
	lblContadorObs.Text = Mensajes.Contador(txtObservaciones.Text.Length, presentador.MaxObservaciones)
End Sub

Private Sub PrepararRevision
	lblRevisionTitulo.Text = Mensajes.REVISION_TITULO
	lblRevisionSubtitulo.Text = Mensajes.REVISION_SUBTITULO
	lblRevClienteTitulo.Text = Mensajes.REVISION_CLIENTE
	lblCambiar.Text = Mensajes.REVISION_CAMBIAR
	lblRevClienteRot.Text = Mensajes.ROTULO_CLIENTE
	lblRevContactoRot.Text = Mensajes.ROTULO_CONTACTO
	lblRevProyectoRot.Text = Mensajes.ROTULO_PROYECTO
	lblRevUbicacionRot.Text = Mensajes.ROTULO_UBICACION
	lblResumenTitulo.Text = Mensajes.REVISION_RESUMEN
	lblRes1Titulo.Text = Mensajes.RESUMEN_PIEZAS
	lblRes2Titulo.Text = Mensajes.RESUMEN_MEDIDAS
	lblRes3Titulo.Text = Mensajes.RESUMEN_FOTOS
	lblRes4Titulo.Text = Mensajes.RESUMEN_CROQUIS
	lblObservacionesRot.Text = Mensajes.OBSERVACIONES_OPCIONAL
End Sub

Private Sub PintarRevision
	lblRevCliente.Text = presentador.TextoCliente
	lblRevContacto.Text = presentador.TextoContacto
	lblRevProyecto.Text = presentador.Proyecto
	lblRevUbicacion.Text = presentador.TextoUbicacion
	Dim valores() As Int = Array As Int(presentador.Piezas.Size, presentador.TotalMedidas, presentador.TotalFotos, presentador.TotalCroquis)
	Dim etiquetas() As B4XView = Array As B4XView(lblRes1Valor, lblRes2Valor, lblRes3Valor, lblRes4Valor)
	For i = 0 To etiquetas.Length - 1
		etiquetas(i).Text = valores(i)
		etiquetas(i).TextColor = Colores.ColorDeConteo(valores(i))
	Next
	lblContadorObs.Text = Mensajes.Contador(txtObservaciones.Text.Length, presentador.MaxObservaciones)
End Sub

Private Sub lblCambiar_Click
	AHView.GotoPage(PASO_CLIENTE, True)
End Sub

Private Sub txtObservaciones_FocusChanged (HasFocus As Boolean)
	If HasFocus Then Return
	ime.HideKeyboard
	Persistir
End Sub
