B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Manejo de vista del croquis de la pieza: herramientas, colores, menu de opciones y
' dialogos de medida y nota sobre ASDrawIso. La pagina solo le pasa sus eventos.

Sub Class_Globals
	Private xui As XUI
	Private Const MODO_LINEA As String = "linea"
	Private Const MODO_BORRAR As String = "borrar"
	Private Const REJILLA_ISO As String = "iso"
	Private Const REJILLA_CUADRADA As String = "cuadrada"
	Private Const ANCHO_MENU As Int = 210dip
	Private Const ALTO_MENU As Int = 430dip
	Private Const ALTO_TITULO As Int = 26dip
	Private Const CLAVE_ID As String = "id"
	Private Const CLAVE_ETIQUETA As String = "etiqueta"
	Private Const CLAVE_MEDIDA As String = "medida"
	Private Const CLAVE_VALOR As String = "valor"
	Private Const CLAVE_UNIDAD As String = "unidad"
	Private Const CLAVE_CANTIDAD As String = "cantidad"

	Private mRaiz As B4XView
	Private mDibujo As ASDrawIso
	Private mDeshacer As B4XView
	Private mOpciones As B4XView
	Private mColores() As B4XView
	Private mHerramientas() As B4XView
	Private menu As ASPopupMenuAdvanced
	Private dialogo As B4XDialog
	Private plantillaTexto As B4XInputTemplate
	Private pnlMedida As B4XView
	Private spnMedida As Spinner
	Private spnUnidad As Spinner
	Private txtValor As EditText
	Private txtCantidad As EditText

	Private PLANOS() As String = Array As String("", "superior", "izquierda", "derecha", "frente")
	Private COLORES_LAPIZ() As Int
	Private GROSORES() As Float
	Private idxPlano As Int
	Private idxGrosor As Int = 1
	Private mPreparado As Boolean
End Sub

Public Sub Initialize (Raiz As B4XView, Dibujo As ASDrawIso, BotonLapiz As B4XView, BotonBorrador As B4XView, _
		BotonDeshacer As B4XView, BotonOpciones As B4XView, Paleta() As B4XView)
	mRaiz = Raiz
	mDibujo = Dibujo
	mDeshacer = BotonDeshacer
	mOpciones = BotonOpciones
	mColores = Paleta
	mHerramientas = Array As B4XView(BotonLapiz, BotonBorrador)
End Sub

#Region Herramientas
Public Sub Preparar
	If mPreparado Then
		Refrescar
		Return
	End If
	mPreparado = True
	COLORES_LAPIZ = Array As Int(Colores.COLOR_TEXTO_PRIMARIO, Colores.COLOR_PRIMARIO, Colores.COLOR_ERROR)
	GROSORES = Array As Float(2dip, 4dip, 7dip)
	mDibujo.setModo(MODO_LINEA)
	mDibujo.Rejilla = True
	mDibujo.Iman = True
	mDibujo.setGrosorLapiz(GROSORES(idxGrosor))
	ElegirColor(0)
	PrepararMenu
	Refrescar
End Sub

Public Sub Salir
	mDibujo.TerminarCadena(False)
	If menu.IsInitialized Then menu.CloseMenu
End Sub

Public Sub UsarLapiz
	mDibujo.setModo(MODO_LINEA)
	Refrescar
End Sub

Public Sub UsarBorrador
	mDibujo.setModo(MODO_BORRAR)
	Refrescar
End Sub

Public Sub Deshacer
	mDibujo.Undo
	Refrescar
End Sub

Public Sub ElegirColor (Indice As Int)
	If COLORES_LAPIZ.Length = 0 Then Return
	For i = 0 To mColores.Length - 1
		Dim borde As Int = 0
		If i = Indice Then borde = 3dip
		mColores(i).SetColorAndBorder(COLORES_LAPIZ(i), borde, Colores.COLOR_TEXTO_PRIMARIO, mColores(i).Height / 2)
	Next
	mDibujo.setColorLapiz(COLORES_LAPIZ(Indice))
End Sub

Public Sub Refrescar
	Dim indice As Int = -1
	If mDibujo.getModo = MODO_LINEA Then indice = 0
	If mDibujo.getModo = MODO_BORRAR Then indice = 1
	UI.MarcarGrupo(mHerramientas, indice)
	UI.Habilitar(mDeshacer, mDibujo.PuedeUndo)
End Sub

Public Sub Limpiar
	mDibujo.Limpiar
	Refrescar
End Sub
#End Region

#Region Carga y guardado
Public Sub getJson As String
	mDibujo.TerminarCadena(False)
	If mDibujo.Vacio Then Return ""
	Return mDibujo.ExportarJSON
End Sub

Public Sub Cargar (Contenido As String) As Boolean
	If Contenido = "" Then Return False
	If mDibujo.ImportarJSON(Contenido) = False Then Return False
	Refrescar
	Return True
End Sub

Public Sub getMedidas As List
	Dim res As List
	res.Initialize
	For Each m As Map In mDibujo.Medidas
		res.Add(MedidaDe(m, res.Size))
	Next
	Return res
End Sub

Private Sub MedidaDe (m As Map, Orden As Int) As MedidaPieza
	Dim r As MedidaPieza
	r.Initialize
	r.Id = m.GetDefault(CLAVE_ID, 0)
	r.Etiqueta = m.GetDefault(CLAVE_ETIQUETA, "")
	r.TipoMedida = m.GetDefault(CLAVE_MEDIDA, "")
	r.Valor = m.GetDefault(CLAVE_VALOR, 0)
	r.Unidad = m.GetDefault(CLAVE_UNIDAD, "")
	r.Cantidad = m.GetDefault(CLAVE_CANTIDAD, 1)
	r.Orden = Orden
	Return r
End Sub
#End Region

#Region Medidas y rótulos
Private Sub AgregarRotulo (Texto As String, Arriba As Int)
	Dim l As Label
	l.Initialize("")
	l.Tag = Utils.TAG_SUB
	l.Text = Texto
	l.TextSize = 12
	pnlMedida.AddView(l, 16dip, Arriba, 268dip, 20dip)
End Sub

Public Sub PedirMedida (Id As Int) As ResumableSub
	Dim m As Map = mDibujo.getMedida(Id)
	If m.Size = 0 Then Return False
	PrepararDialogos
	Dim medida As MedidaPieza = MedidaDe(m, 0)
	spnMedida.SelectedIndex = Max(0, spnMedida.IndexOf(medida.TipoMedida))
	spnUnidad.SelectedIndex = Max(0, spnUnidad.IndexOf(medida.Unidad))
	If medida.Valor > 0 Then txtValor.Text = NumberFormat2(medida.Valor, 1, 2, 0, False) Else txtValor.Text = ""
	txtCantidad.Text = medida.Cantidad
	dialogo.Title = Mensajes.TituloMedida(medida.Etiqueta)
	Dim rs As Object = dialogo.ShowCustom(pnlMedida, Mensajes.GUARDAR, Mensajes.QUITAR, Mensajes.CANCELAR)
	UI.AjustarBarraTitulo(dialogo)
	UI.CentrarDialogo(dialogo)
	Wait For (rs) Complete (Resultado As Int)
	If Resultado = xui.DialogResponse_Negative Then
		mDibujo.QuitarTrazo(Id)
		Return True
	End If
	If Resultado <> xui.DialogResponse_Positive Then Return False
	Dim texto As String = txtValor.Text.Trim.Replace(",", ".")
	If texto = "" Or IsNumber(texto) = False Then
		xui.MsgboxAsync(Mensajes.FALTA_VALOR_MEDIDA, Mensajes.TituloMedida(medida.Etiqueta))
		Return False
	End If
	Dim cantidad As Int = 1
	If IsNumber(txtCantidad.Text.Trim) Then cantidad = Max(1, txtCantidad.Text.Trim)
	mDibujo.FijarMedida(Id, spnMedida.SelectedItem, texto, spnUnidad.SelectedItem, cantidad)
	Return True
End Sub

Public Sub PedirTexto (Id As Int) As ResumableSub
	PrepararDialogos
	plantillaTexto.Text = mDibujo.getTextoDe(Id)
	Dim borrar As String = ""
	If Id > 0 Then borrar = Mensajes.BORRAR
	dialogo.Title = Mensajes.NOTA_CROQUIS
	Dim rs As Object = dialogo.ShowTemplate(plantillaTexto, Mensajes.GUARDAR, borrar, Mensajes.CANCELAR)
	UI.AjustarBarraTitulo(dialogo)
	UI.CentrarDialogo(dialogo)
	Wait For (rs) Complete (Resultado As Int)
	If Resultado = xui.DialogResponse_Positive Then mDibujo.PonerTexto(Id, plantillaTexto.Text)
	If Resultado = xui.DialogResponse_Negative Then mDibujo.PonerTexto(Id, "")
	Return True
End Sub

Private Sub LlenarPendientes
	For Each m As MedidaPieza In getMedidas
		If m.Valor > 0 Then Continue
		Wait For (PedirMedida(m.Id)) Complete (Listo As Boolean)
		If Listo = False Then Exit
	Next
	Refrescar
End Sub
#End Region

#Region Menú
Public Sub AbrirMenu
	ConstruirMenu
	menu.OpenMenuOnView(mOpciones, ANCHO_MENU, ALTO_MENU)
End Sub

Private Sub menu_ItemClick (Index As Int, Tag As Object)
	menu.CloseMenu
	Select Tag
		Case "puntos", "linea", "circulo", "agujero", "arco", "texto", "hueco", "cota", "angulo"
			mDibujo.setModo(Tag)
		Case "llenar"
			LlenarPendientes
			Return
		Case "plano"
			idxPlano = (idxPlano + 1) Mod PLANOS.Length
			mDibujo.setPlanoCirculo(PLANOS(idxPlano))
		Case "tipo_rejilla"
			If mDibujo.getTipoRejilla = REJILLA_ISO Then mDibujo.setTipoRejilla(REJILLA_CUADRADA) Else mDibujo.setTipoRejilla(REJILLA_ISO)
			mDibujo.Rejilla = True
		Case "terminar"
			If mDibujo.EnCadena Then mDibujo.TerminarCadena(False)
		Case "cerrar"
			If mDibujo.PuedeCerrar Then mDibujo.TerminarCadena(True)
		Case "descartar"
			If mDibujo.EnCadena Or mDibujo.TrazoPendiente Then mDibujo.Cancelar
		Case "rejilla"
			mDibujo.Rejilla = Not(mDibujo.Rejilla)
		Case "iman"
			mDibujo.Iman = Not(mDibujo.Iman)
		Case "rotulos"
			mDibujo.Rotulos = Not(mDibujo.Rotulos)
		Case "grosor"
			idxGrosor = (idxGrosor + 1) Mod GROSORES.Length
			mDibujo.setGrosorLapiz(GROSORES(idxGrosor))
		Case "limpiar"
			If mDibujo.Vacio = False Then
				ConfirmarLimpiar
				Return
			End If
	End Select
	Refrescar
End Sub

Private Sub PrepararMenu
	menu.Initialize(mRaiz, Me, "menu")
	menu.ActivityHasActionBar = True
	menu.OrientationVertical = menu.OrientationVertical_TOP
	menu.CornerRadius = 10dip
	menu.MenuViewGap = 6dip
	menu.BackgroundPanel.Color = 0x52000000
	menu.TitleLabelProperties.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
	menu.TitleLabelProperties.xFont = xui.CreateDefaultFont(11)
	menu.TitleLabelProperties.BackgroundColor = Colores.COLOR_SUPERFICIE
	menu.TitleLabelProperties.LeftRightPadding = 12dip
	menu.SeparatorProperties.BackgroundColor = Colores.COLOR_BORDE
	menu.SeparatorProperties.Height = 1dip
End Sub

Private Sub ConstruirMenu
	menu.Clear
	Dim m As String = mDibujo.getModo
	menu.AddTitle(Mensajes.CROQUIS_HERRAMIENTAS, ALTO_TITULO)
	menu.AddItem(Fila(Chr(0xF192), Mensajes.CROQUIS_PUNTOS, m = "puntos", False), "puntos")
	menu.AddItem(Fila(Chr(0xF068), Mensajes.CROQUIS_LINEA, m = "linea", False), "linea")
	menu.AddItem(Fila(Chr(0xF192), Mensajes.CROQUIS_AGUJERO, m = "agujero", False), "agujero")
	menu.AddItem(Fila(Chr(0xF10C), Mensajes.CROQUIS_CIRCULO, m = "circulo", False), "circulo")
	menu.AddItem(Fila(Chr(0xF1CE), Mensajes.CROQUIS_ARCO, m = "arco", False), "arco")
	menu.AddItem(Fila(Chr(0xF031), Mensajes.CROQUIS_TEXTO, m = "texto", False), "texto")
	menu.AddItem(Fila(Chr(0xF1DB), Mensajes.CROQUIS_ABERTURA, m = "hueco", False), "hueco")
	menu.AddSeparator
	menu.AddTitle(Mensajes.CROQUIS_MEDIDAS, ALTO_TITULO)
	menu.AddItem(Fila(Chr(0xF07E), Mensajes.CROQUIS_COTA, m = "cota", False), "cota")
	menu.AddItem(Fila(Chr(0xF1FE), Mensajes.CROQUIS_ANGULO, m = "angulo", False), "angulo")
	Dim faltan As Int = mDibujo.getMedidasPendientes
	menu.AddItem(Fila(Chr(0xF044), Mensajes.CroquisLlenar(faltan), False, faltan = 0), "llenar")
	menu.AddSeparator
	menu.AddTitle(Mensajes.CROQUIS_FIGURA, ALTO_TITULO)
	menu.AddItem(Fila(Chr(0xF00C), Mensajes.CROQUIS_TERMINAR, False, Not(mDibujo.EnCadena)), "terminar")
	menu.AddItem(Fila(Chr(0xF096), Mensajes.CROQUIS_CERRAR, False, Not(mDibujo.PuedeCerrar)), "cerrar")
	menu.AddItem(Fila(Chr(0xF00D), Mensajes.CROQUIS_DESCARTAR, False, Not(mDibujo.EnCadena Or mDibujo.TrazoPendiente)), "descartar")
	menu.AddSeparator
	menu.AddTitle(Mensajes.CROQUIS_VISTA, ALTO_TITULO)
	menu.AddItem(Fila(Chr(0xF00A), Mensajes.CROQUIS_REJILLA, mDibujo.Rejilla, False), "rejilla")
	menu.AddItem(Fila(Chr(0xF0CE), Mensajes.CROQUIS_REJILLA_CUADRADA, mDibujo.getTipoRejilla = REJILLA_CUADRADA, False), "tipo_rejilla")
	menu.AddItem(Fila(Chr(0xF1B2), Mensajes.CroquisCara(idxPlano), False, False), "plano")
	menu.AddItem(Fila(Chr(0xF076), Mensajes.CROQUIS_IMAN, mDibujo.Iman, False), "iman")
	menu.AddItem(Fila(Chr(0xF02B), Mensajes.CROQUIS_ROTULOS, mDibujo.Rotulos, False), "rotulos")
	menu.AddSeparator
	menu.AddItem(Fila(Chr(0xF111), Mensajes.CroquisTrazo(idxGrosor), False, False), "grosor")
	menu.AddItem(Fila(Chr(0xF1F8), Mensajes.CROQUIS_LIMPIAR, False, mDibujo.Vacio), "limpiar")
End Sub

Private Sub Fila (Glifo As String, Texto As String, Marcada As Boolean, Atenuada As Boolean) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, ANCHO_MENU, 38dip)
	p.Color = Colores.COLOR_SUPERFICIE
	Dim colorTexto As Int = Colores.COLOR_TEXTO_PRIMARIO
	Dim colorIcono As Int = Colores.COLOR_PRIMARIO
	If Atenuada Then
		colorTexto = Colores.COLOR_DESHABILITADO
		colorIcono = Colores.COLOR_DESHABILITADO
	End If
	p.AddView(Etiqueta(Glifo, True, 14, colorIcono, Gravity.CENTER), 10dip, 0, 24dip, 38dip)
	p.AddView(Etiqueta(Texto, False, 14, colorTexto, Bit.Or(Gravity.LEFT, Gravity.CENTER_VERTICAL)), 40dip, 0, 140dip, 38dip)
	If Marcada Then p.AddView(Etiqueta(Chr(0xF00C), True, 12, Colores.COLOR_PRIMARIO, Gravity.CENTER), 182dip, 0, 20dip, 38dip)
	Return p
End Sub

Private Sub Etiqueta (Texto As String, Icono As Boolean, Tamano As Float, Color As Int, Gravedad As Int) As Label
	Dim l As Label
	l.Initialize("")
	If Icono Then l.Typeface = Typeface.FONTAWESOME
	l.Text = Texto
	l.TextSize = Tamano
	l.TextColor = Color
	l.Gravity = Gravedad
	Return l
End Sub

Private Sub ConfirmarLimpiar
	Wait For (xui.Msgbox2Async(Mensajes.BORRAR_CROQUIS, Mensajes.CONFIRMAR, Mensajes.BORRAR, "", Mensajes.CANCELAR, Null)) Msgbox_Result (Resultado As Int)
	If Resultado = xui.DialogResponse_Positive Then mDibujo.Limpiar
	Refrescar
End Sub
#End Region

#Region Diálogos
Private Sub PrepararDialogos
	If dialogo.IsInitialized Then Return
	dialogo.Initialize(mRaiz)
	UI.EstilizarDialogo(dialogo)
	plantillaTexto.Initialize
	plantillaTexto.lblTitle.Text = Mensajes.NOTA
	UI.EstilizarPlantillaTexto(plantillaTexto)

	pnlMedida = xui.CreatePanel("")
	pnlMedida.Tag = Utils.TAG_RAW
	pnlMedida.Color = Colores.COLOR_SUPERFICIE
	pnlMedida.SetLayoutAnimated(0, 0, 0, 300dip, 236dip)
	spnMedida = NuevoCombo(Mensajes.TiposMedida)
	spnUnidad = NuevoCombo(DbSolicitudes.UNIDADES_MEDIDA)
	txtValor.Initialize("")
	txtValor.InputType = txtValor.INPUT_TYPE_DECIMAL_NUMBERS
	txtValor.SingleLine = True
	txtCantidad.Initialize("")
	txtCantidad.InputType = txtCantidad.INPUT_TYPE_NUMBERS
	txtCantidad.SingleLine = True

	AgregarRotulo(Mensajes.ROTULO_TIPO_MEDIDA, 12dip)
	pnlMedida.AddView(spnMedida, 16dip, 32dip, 268dip, 44dip)
	AgregarRotulo(Mensajes.ROTULO_VALOR, 84dip)
	pnlMedida.AddView(txtValor, 16dip, 104dip, 156dip, 44dip)
	pnlMedida.AddView(spnUnidad, 184dip, 104dip, 100dip, 44dip)
	AgregarRotulo(Mensajes.ROTULO_CANTIDAD_IGUALES, 156dip)
	pnlMedida.AddView(txtCantidad, 16dip, 176dip, 100dip, 44dip)
	UI.AplicarTema(pnlMedida)
End Sub

Private Sub NuevoCombo (Valores As List) As Spinner
	Dim s As Spinner
	s.Initialize("")
	s.Tag = Utils.TAG_RAW
	s.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	s.DropdownBackgroundColor = Colores.COLOR_SUPERFICIE
	s.AddAll(Valores)
	Return s
End Sub
#End Region
