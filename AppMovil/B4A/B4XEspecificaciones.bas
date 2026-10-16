B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Pagina de la pieza en tres partes (datos, croquis y fotos). Lee los campos y pinta;
' reglas, fotos y borrador son del presentador; croquis y camara, de sus clases de vista.

Sub Class_Globals
	Private Root As B4XView 'ignore
	Private xui As XUI 'ignore
	Private Const TIPO_IMAGEN As String = "image/*"
	Private Const SIN_PENDIENTE As Int = 0
	Private Const PENDIENTE_NUEVA As Int = 1
	Private Const PENDIENTE_EDITAR As Int = 2
	Private Const PENDIENTE_RETOMAR As Int = 3
	Private Const PageDetalles As Int = 0
	Private Const PageCROQUIS As Int = 1
	Private Const PageFOTOS As Int = 2

	Private presentador As PresentadorEspecificaciones
	Private croquis As EditorCroquis
	Private camara As CamaraPieza
	Private pendiente As Int
	Private piezaEditar As Pieza
	Private enCaptura As Boolean

	Private TextNombrePieza As B4XFloatTextField
	Private CampoTipoTrabajo, CampoMaterial, CampoAcabado As CampoBusqueda
	Private pagecont As AHPageContainer
	Private AHViewEspecificaciones As AHViewPager
	Private navegacion() As B4XView
	Private BtnCroquis As Button
	Private BtnDetalles As Button
	Private BtnCamera As Button
	Private CvMedidas As CustomListView
	Private lblMedidaLetra, lblMedidaNombre, lblMedidaDetalle, lblSeccion As B4XView
	Private ivFoto, lblQuitarFoto As B4XView
	Private Const ALTO_MEDIDA As Int = 64dip
	Private Const ALTO_AVISO As Int = 36dip

	Private ASDrawIso1 As ASDrawIso
	Private BtnLapiz As Button
	Private btnborrador As Button
	Private BtnDeshacer As Button
	Private BtnColor1 As Button
	Private BtnColor2 As Button
	Private BtnColor3 As Button
	Private btnOpciones As Button

	Private BtnDisparar As Button
	Private BtnFlash As Button
	Private BtnRotar As Button
	Private CvFoto As CustomListView
	Private pnPreview As Panel
	Private pnSinCamara As Panel
	Private lblSinCamIcono As Label
	Private lblSinCamTexto As Label
	Private lblSinCamTitulo As Label
	Private BtnPermitirCamara As Button
End Sub

Public Sub Initialize As Object
	Return Me
End Sub

#Region Ciclo y borrador
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageespecificacionesHome")
	B4XPages.SetTitle(Me, Mensajes.TITULO_PIEZA)
	presentador.Initialize
	pagecont.Initialize
	For i = 0 To 2
		pagecont.AddPage(CrearPagina(i), "page" & i)
	Next
	croquis.Initialize(Root, ASDrawIso1, BtnLapiz, btnborrador, BtnDeshacer, btnOpciones, _
		Array As B4XView(BtnColor1, BtnColor2, BtnColor3))
	camara.Initialize(Me, "Camara", pnPreview, pnSinCamara, lblSinCamIcono, lblSinCamTitulo, _
		lblSinCamTexto, BtnDisparar, BtnFlash, BtnRotar, BtnPermitirCamara)
	navegacion = Array As B4XView(BtnDetalles, BtnCamera, BtnCroquis)
	AHViewEspecificaciones.PageContainer = pagecont
	AHViewEspecificaciones.PagingEnabled = False
	AHViewEspecificaciones.CurrentPage = PageDetalles
	UI.MarcarGrupo(navegacion, PageDetalles)
	UI.AplicarTema(Root)
	PintarMedidas
End Sub

Private Sub CrearPagina (Indice As Int) As B4XView
	Dim page As B4XView = xui.CreatePanel("")
	page.SetLayoutAnimated(0, 0, 0, AHViewEspecificaciones.Width, AHViewEspecificaciones.Height)
	Select Indice
		Case 0
			page.LoadLayout("PageEspecificaciones")
		Case 1
			page.LoadLayout("PageEspecificacionesCroquis")
		Case 2
			page.LoadLayout("PageEspecificacionesfoto")
	End Select
	UI.AplicarTema(page)
	Return page
End Sub

Public Sub NuevaPieza
	pendiente = PENDIENTE_NUEVA
End Sub

Public Sub EditarPieza (p As Pieza)
	pendiente = PENDIENTE_EDITAR
	piezaEditar = p
End Sub

Public Sub RetomarPieza
	pendiente = PENDIENTE_RETOMAR
End Sub

Public Sub getHayPiezaSinTerminar As Boolean
	Return presentador.HayBorrador
End Sub

Public Sub getNombrePiezaSinTerminar As String
	Return presentador.NombreBorrador
End Sub

Private Sub B4XPage_Appear
	If pendiente = SIN_PENDIENTE Then Return
	Dim accion As Int = pendiente
	pendiente = SIN_PENDIENTE
	enCaptura = False
	If accion <> PENDIENTE_RETOMAR And presentador.HayBorrador Then
		Dim sf As Object = xui.Msgbox2Async(Mensajes.RetomarPieza(presentador.NombreBorrador), Mensajes.TITULO, Mensajes.SI, "", Mensajes.NO, Null)
		Wait For (sf) Msgbox_Result (Respuesta As Int)
		If Respuesta = xui.DialogResponse_Positive Then accion = PENDIENTE_RETOMAR Else presentador.DescartarBorrador
	End If
	Limpiar
	If accion = PENDIENTE_RETOMAR And presentador.Restaurar Then Pintar
	If accion = PENDIENTE_EDITAR Then
		presentador.EditarPieza(piezaEditar)
		Pintar
	End If
	If presentador.Editando Then B4XPages.SetTitle(Me, Mensajes.TITULO_EDITAR_PIEZA) Else B4XPages.SetTitle(Me, Mensajes.TITULO_PIEZA)
	enCaptura = True
End Sub

Private Sub B4XPage_Disappear
	camara.Cerrar
	Persistir
End Sub

Private Sub B4XPage_Background
	camara.Cerrar
	Persistir
End Sub

Private Sub B4XPage_Foreground
	If AHViewEspecificaciones.CurrentPage = PageFOTOS Then AbrirCamara
End Sub

Private Sub Persistir
	If enCaptura = False Then Return
	presentador.GuardarBorrador(TextNombrePieza.Text, croquis.Json, AHViewEspecificaciones.CurrentPage)
End Sub

Private Sub Limpiar
	presentador.Nuevo
	TextNombrePieza.Text = ""
	PintarCatalogos
	croquis.Limpiar
	CvFoto.Clear
	PintarMedidas
	AHViewEspecificaciones.GotoPage(PageDetalles, False)
End Sub

Private Sub Pintar
	TextNombrePieza.Text = presentador.Nombre
	PintarCatalogos
	croquis.Cargar(presentador.CroquisJson)
	For Each archivo As String In presentador.Fotos
		CvFoto.Add(CrearMiniatura(archivo), archivo)
	Next
	PintarMedidas
	AHViewEspecificaciones.GotoPage(presentador.Pagina, False)
End Sub
#End Region

#Region Datos de la pieza
Private Sub PintarCatalogos
	CampoTipoTrabajo.Texto = presentador.TextoTipoTrabajo
	CampoMaterial.Texto = presentador.TextoTipoMaterial
	CampoAcabado.Texto = presentador.TextoAcabado
End Sub

Private Sub CampoTipoTrabajo_Opciones As List
	Return presentador.OpcionesTiposTrabajo
End Sub

Private Sub CampoTipoTrabajo_Elegido (Valor As Object)
	presentador.ElegirTipoTrabajo(Valor)
	PintarCatalogos
End Sub

Private Sub CampoMaterial_Opciones As List
	Return presentador.OpcionesTiposMaterial
End Sub

Private Sub CampoMaterial_Elegido (Valor As Object)
	presentador.ElegirTipoMaterial(Valor)
	PintarCatalogos
End Sub

Private Sub CampoAcabado_Opciones As List
	Return presentador.OpcionesAcabados
End Sub

Private Sub CampoAcabado_Elegido (Valor As Object)
	presentador.ElegirAcabado(Valor)
	PintarCatalogos
End Sub

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
	Dim pregunta As String = Mensajes.DESCARTAR_PIEZA
	If presentador.Editando Then pregunta = Mensajes.DESCARTAR_CAMBIOS_PIEZA
	Dim sf As Object = xui.Msgbox2Async(pregunta, Mensajes.TITULO, Mensajes.SI, "", Mensajes.NO, Null)
	Wait For (sf) Msgbox_Result (Respuesta As Int)
	If Respuesta <> xui.DialogResponse_Positive Then Return
	presentador.DescartarFotos
	Limpiar
	B4XPages.ClosePage(Me)
End Sub

Private Sub BtnGuardar_Click
	Dim editando As Boolean = presentador.Editando
	Dim r As Resultado = presentador.ArmarPieza(TextNombrePieza.Text, croquis.Json, croquis.Medidas)
	If r.Ok = False Then
		AHViewEspecificaciones.GotoPage(PageDetalles, True)
		xui.MsgboxAsync(r.Mensaje, Mensajes.TITULO)
		Return
	End If
	Dim cotizacion As B4XCotizacion = B4XPages.GetPage(Layouts.PAGINA_COTIZACION)
	If editando Then cotizacion.ReemplazarPieza(r.Datos) Else cotizacion.AgregarPieza(r.Datos)
	Limpiar
	B4XPages.ClosePage(Me)
End Sub

Private Sub AHViewEspecificaciones_PageChanged (Position As Int)
	If Position = PageCROQUIS Then croquis.Preparar Else croquis.Salir
	If Position = PageFOTOS Then AbrirCamara Else camara.Cerrar
	If Position = PageDetalles Then PintarMedidas
	UI.MarcarGrupo(navegacion, Position)
End Sub
#End Region

#Region Medidas
Private Sub PintarMedidas
	CvMedidas.Clear
	Dim medidas As List = croquis.Medidas
	If medidas.Size = 0 Then
		CvMedidas.Add(CrearAvisoMedidas, Null)
		Return
	End If
	For Each m As Map In medidas
		CvMedidas.Add(CrearCardMedida(m), m.Get("id"))
	Next
End Sub

Private Sub CrearCardMedida (m As Map) As B4XView
	Dim item As B4XView = xui.CreatePanel("")
	item.SetLayoutAnimated(0, 0, 0, CvMedidas.AsView.Width, ALTO_MEDIDA)
	item.LoadLayout("ItemMedida")
	lblMedidaLetra.Text = m.Get("etiqueta")
	lblMedidaNombre.Text = m.Get("medida")
	Dim valor As Double = m.Get("valor")
	If valor > 0 Then
		lblMedidaDetalle.Text = Mensajes.DetalleMedida(valor, m.Get("unidad"), m.Get("cantidad"))
	Else
		lblMedidaDetalle.Text = Mensajes.MEDIDA_SIN_VALOR
		lblMedidaDetalle.TextColor = Colores.COLOR_ADVERTENCIA
	End If
	Return item
End Sub

Private Sub CrearAvisoMedidas As B4XView
	Dim item As B4XView = xui.CreatePanel("")
	item.SetLayoutAnimated(0, 0, 0, CvMedidas.AsView.Width, ALTO_AVISO)
	item.LoadLayout("ItemSeccion")
	lblSeccion.Text = Mensajes.SIN_MEDIDAS
	lblSeccion.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
	lblSeccion.Font = xui.CreateDefaultFont(14)
	Return item
End Sub

Private Sub CvMedidas_ItemClick (Index As Int, Value As Object)
	If Value = Null Then Return
	Wait For (croquis.PedirMedida(Value)) Complete (Hecho As Boolean)
	PintarMedidas
End Sub
#End Region

#Region Croquis
Private Sub BtnLapiz_Click
	croquis.UsarLapiz
End Sub

Private Sub btnborrador_Click
	croquis.UsarBorrador
End Sub

Private Sub BtnDeshacer_Click
	croquis.Deshacer
End Sub

Private Sub BtnColor1_Click
	croquis.ElegirColor(0)
End Sub

Private Sub BtnColor2_Click
	croquis.ElegirColor(1)
End Sub

Private Sub BtnColor3_Click
	croquis.ElegirColor(2)
End Sub

Private Sub btnOpciones_Click
	croquis.AbrirMenu
End Sub

Private Sub ASDrawIso1_Cambio
	croquis.Refrescar
End Sub

Private Sub ASDrawIso1_Medida (Id As Int)
	Wait For (croquis.PedirMedida(Id)) Complete (Hecho As Boolean)
	croquis.Refrescar
End Sub

Private Sub ASDrawIso1_Texto (Id As Int)
	Wait For (croquis.PedirTexto(Id)) Complete (Hecho As Boolean)
	croquis.Refrescar
End Sub
#End Region

#Region Fotos
Private Sub AbrirCamara
	If camara.Lista Then Return
	If camara.ComprobarEquipo = False Then Return
	Dim rp As RuntimePermissions
	If rp.Check(rp.PERMISSION_CAMERA) = False Then
		rp.CheckAndRequest(rp.PERMISSION_CAMERA)
		Wait For B4XPage_PermissionResult (Permission As String, Result As Boolean)
		If Permission <> rp.PERMISSION_CAMERA Then Return
		If Result = False Then
			camara.Denegada(Adjuntos.PermisoBloqueado(rp.PERMISSION_CAMERA))
			Return
		End If
	End If
	camara.Abrir
End Sub

Private Sub BtnRotar_Click
	camara.Rotar
End Sub

Private Sub BtnFlash_Click
	camara.CambiarFlash
End Sub

Private Sub BtnDisparar_Click
	camara.Disparar
End Sub

Private Sub BtnPermitirCamara_Click
	If camara.Bloqueada Then camara.AbrirAjustes Else AbrirCamara
End Sub

Sub Camara_Foto (Datos() As Byte)
	If presentador.PuedeAgregarFoto = False Then
		xui.MsgboxAsync(Mensajes.FOTOS_MAXIMO, Mensajes.TITULO)
		Return
	End If
	MostrarFoto(presentador.AgregarFoto(Datos), Mensajes.FOTO_NO_GUARDADA)
End Sub

Private Sub BtnGaleria_Click
	If presentador.PuedeAgregarFoto = False Then
		xui.MsgboxAsync(Mensajes.FOTOS_MAXIMO, Mensajes.TITULO)
		Return
	End If
	Dim selector As ContentChooser
	selector.Initialize("selector")
	selector.Show(TIPO_IMAGEN, Mensajes.ELEGIR_FOTO)
	Wait For selector_Result (Success As Boolean, Dir As String, FileName As String)
	If Success = False Then Return
	MostrarFoto(presentador.AgregarFotoDeGaleria(Dir, FileName), Mensajes.FOTO_NO_VALIDA)
End Sub

Private Sub MostrarFoto (Archivo As String, Falla As String)
	If Archivo = "" Then
		Dim texto As String = Falla
		If presentador.MotivoRechazo <> "" Then texto = presentador.MotivoRechazo
		xui.MsgboxAsync(texto, Mensajes.TITULO)
		Return
	End If
	CvFoto.Add(CrearMiniatura(Archivo), Archivo)
	CvFoto.JumpToItem(CvFoto.Size - 1)
	Persistir
End Sub

Private Sub CrearMiniatura (Archivo As String) As B4XView
	Dim lado As Int = CvFoto.AsView.Height
	Dim item As B4XView = xui.CreatePanel("")
	item.SetLayoutAnimated(0, 0, 0, lado, lado)
	item.LoadLayout("ItemFoto")
	ivFoto.SetBitmap(xui.LoadBitmapResize(presentador.CarpetaFotos, Archivo, lado, lado, True))
	lblQuitarFoto.Tag = Archivo
	Return item
End Sub

Private Sub QuitarFoto_Click
	Dim v As B4XView = Sender
	Dim i As Int = presentador.QuitarFoto(v.Tag)
	If i >= 0 Then CvFoto.RemoveAt(i)
	Persistir
End Sub
#End Region
