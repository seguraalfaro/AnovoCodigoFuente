B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Ventana generica para elegir un elemento de una lista con busqueda. Se arma por
' codigo con ASBuscador y una lista de dos lineas, se abre debajo del campo que la
' llama (o encima si no cabe, contando el teclado) y devuelve el Valor elegido.

Sub Class_Globals
	Private xui As XUI
	Private mPadre As B4XView
	Private mAncla As B4XView
	Private dlg As B4XDialog
	Private pnl As B4XView
	Private buscador As ASBuscador
	Private lista As ListView
	Private lblVacio As Label
	Private ime As IME
	Private elegido As Object
	Private abierta As Boolean
	Private Const ALTO_BUSCADOR As Int = 44
	Private Const ALTO_FILA As Int = 56
	Private Const ALTO_MAXIMO As Int = 600
	Private Const ALTO_MINIMO As Int = 160
	Private Const MARGEN As Int = 4
	Private Const ESPERA_TECLADO As Int = 350
	Private Const PROPORCION_ALTO As Float = 0.7
End Sub

Public Sub Initialize (Padre As B4XView)
	mPadre = Padre
End Sub

#Region Mostrar y elegir
Public Sub Elegir (Ancla As B4XView, Titulo As String, Ayuda As String, Opciones As List) As ResumableSub
	Preparar(Ancla.Width)
	mAncla = Ancla
	elegido = Null
	dlg.Title = Titulo
	buscador.Campo.Hint = Ayuda
	buscador.Limpiar
	buscador.setFuente(Opciones)

	Dimensionar(AltoContenido(dlg.TitleBarHeight + dlg.ButtonsHeight + 6dip, mPadre.Height))
	Dim rs As Object = dlg.ShowCustom(pnl, "", "", Mensajes.CANCELAR)
	abierta = True
	UI.AjustarBarraTitulo(dlg)
	Ubicar
	buscador.Enfocar
	UbicarLuego
	Wait For (rs) Complete (Respuesta As Int)
	abierta = False
	buscador.OcultarTeclado
	If Respuesta = xui.DialogResponse_Positive Then Return elegido
	Return Null
End Sub

Public Sub TextoOpcion (o As Object) As String
	Dim op As OpcionBusqueda = o
	Return op.Titulo & " " & op.Detalle
End Sub

Private Sub Preparar (Ancho As Int)
	If pnl.IsInitialized Then Return
	dlg.Initialize(mPadre)
	UI.EstilizarDialogo(dlg)
	ime.Initialize("ime")
	ime.AddHeightChangedEvent

	Dim altoBuscador As Int = DipToCurrent(ALTO_BUSCADOR)
	Dim alto As Int = DipToCurrent(ALTO_MAXIMO)
	pnl = xui.CreatePanel("")
	pnl.Tag = Utils.TAG_RAW
	pnl.Color = Colores.COLOR_SUPERFICIE
	pnl.SetLayoutAnimated(0, 0, 0, Ancho, alto)

	Dim base As B4XView = xui.CreatePanel("")
	base.SetLayoutAnimated(0, 0, 0, Ancho - 24dip, altoBuscador)
	pnl.AddView(base, 12dip, 8dip, Ancho - 24dip, altoBuscador)
	Dim lbl As Label
	lbl.Initialize("")
	buscador.Initialize(Me, "buscador")
	buscador.DesignerCreateView(base, lbl, PropiedadesBuscador)
	buscador.Comparar(Me, "TextoOpcion")

	lista.Initialize("lista")
	lista.Color = Colores.COLOR_SUPERFICIE
	lista.TwoLinesLayout.ItemHeight = DipToCurrent(ALTO_FILA)
	lista.TwoLinesLayout.Label.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	lista.TwoLinesLayout.Label.TextSize = 14
	lista.TwoLinesLayout.Label.Typeface = Typeface.DEFAULT_BOLD
	lista.TwoLinesLayout.SecondLabel.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
	lista.TwoLinesLayout.SecondLabel.TextSize = 12
	For Each l As Label In Array As Label(lista.TwoLinesLayout.Label, lista.TwoLinesLayout.SecondLabel)
		l.Left = 16dip
		l.Width = Ancho - 32dip
	Next
	Dim arriba As Int = altoBuscador + 16dip
	pnl.AddView(lista, 0, arriba, Ancho, alto - arriba)

	lblVacio.Initialize("")
	lblVacio.Text = Mensajes.SIN_RESULTADOS
	lblVacio.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
	lblVacio.TextSize = 13
	lblVacio.Gravity = Gravity.CENTER_HORIZONTAL
	pnl.AddView(lblVacio, 12dip, arriba + 16dip, Ancho - 24dip, 40dip)
End Sub

Private Sub PropiedadesBuscador As Map
	Return CreateMap("Hint": "", "ConLupa": True, "ConLimpiar": True, "RetardoMs": 150, _
		"MinCaracteres": 1, "IgnorarAcentos": True, "ColorFondo": Colores.COLOR_SUPERFICIE, _
		"ColorBorde": Colores.COLOR_BORDE, "ColorTexto": Colores.COLOR_TEXTO_PRIMARIO, _
		"ColorIcono": Colores.COLOR_TEXTO_SECUNDARIO, "Radio": 8, "TamanoTexto": 14)
End Sub
#End Region

#Region Posición y tamaño
Private Sub UbicarLuego
	Sleep(ESPERA_TECLADO)
	If abierta Then Ubicar
End Sub

Private Sub Ubicar
	Dim limite As Int = LimiteVisible
	Dim pos() As Int = Posicion(mAncla)
	Dim m As Int = DipToCurrent(MARGEN)
	Dim extra As Int = pnl.Top + dlg.ButtonsHeight + 4dip
	Dim abajo As Int = limite - pos(1) - mAncla.Height - 2 * m
	Dim arriba As Int = pos(1) - 2 * m
	Dim haciaAbajo As Boolean = abajo >= AltoContenido(extra, limite) + extra Or abajo >= arriba
	Dim espacio As Int = arriba
	If haciaAbajo Then espacio = abajo
	Dim contenido As Int = Max(DipToCurrent(ALTO_MINIMO), Min(AltoContenido(extra, limite), espacio - extra))
	Dimensionar(contenido)
	Dim altoVentana As Int = extra + contenido
	Dim arribaVentana As Int = pos(1) - m - altoVentana
	If haciaAbajo Then arribaVentana = pos(1) + mAncla.Height + m
	arribaVentana = Max(0, Min(arribaVentana, limite - altoVentana))
	Dim izquierda As Int = Max(0, Min(pos(0), mPadre.Width - dlg.Base.Width))
	dlg.Base.SetLayoutAnimated(0, izquierda, arribaVentana, dlg.Base.Width, altoVentana)
	Dim cancelar As B4XView = dlg.GetButton(xui.DialogResponse_Cancel)
	cancelar.Top = altoVentana - dlg.ButtonsHeight - 4dip
End Sub

Private Sub AltoContenido (Extra As Int, Limite As Int) As Int
	Return Min(Limite * PROPORCION_ALTO, DipToCurrent(ALTO_MAXIMO)) - Extra
End Sub

Private Sub LimiteVisible As Int
	Dim r As JavaObject
	r.InitializeNewInstance("android.graphics.Rect", Null)
	Dim jp As JavaObject = mPadre
	jp.RunMethod("getWindowVisibleDisplayFrame", Array As Object(r))
	Dim enPadre(2) As Int
	jp.RunMethod("getLocationOnScreen", Array As Object(enPadre))
	Dim fondo As Int = r.GetField("bottom")
	Return Min(mPadre.Height, fondo - enPadre(1))
End Sub

Private Sub Posicion (v As B4XView) As Int()
	Dim enVista(2), enPadre(2) As Int
	Dim jv As JavaObject = v
	jv.RunMethod("getLocationOnScreen", Array As Object(enVista))
	Dim jp As JavaObject = mPadre
	jp.RunMethod("getLocationOnScreen", Array As Object(enPadre))
	Return Array As Int(enVista(0) - enPadre(0), enVista(1) - enPadre(1))
End Sub

Private Sub Dimensionar (Alto As Int)
	Dim arriba As Int = DipToCurrent(ALTO_BUSCADOR) + 16dip
	Alto = Max(Alto, arriba + DipToCurrent(ALTO_FILA))
	pnl.Height = Alto
	Dim vl As B4XView = lista
	vl.SetLayoutAnimated(0, 0, arriba, pnl.Width, Alto - arriba)
End Sub
#End Region

#Region Eventos
Private Sub ime_HeightChanged (NewHeight As Int, OldHeight As Int)
	If abierta Then Ubicar
End Sub

Private Sub buscador_Filtrado (Resultado As List)
	lista.Clear
	For Each op As OpcionBusqueda In Resultado
		lista.AddTwoLines2(op.Titulo, op.Detalle, op.Valor)
	Next
	lblVacio.Visible = (Resultado.Size = 0)
End Sub

Private Sub lista_ItemClick (Position As Int, Value As Object)
	elegido = Value
	dlg.Close(xui.DialogResponse_Positive)
End Sub
#End Region
