B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
B4A=True

'ASDrawSteps - Progress stepper cross-platform (B4A / B4i / B4J)
'Version 1.50
'Dibujado 100% nativo con B4XCanvas. Unica dependencia: XUI.
'
'ARQUITECTURA EN DOS CAPAS
'En B4A el B4XCanvas se instala como background drawable del panel sobre el que
'se inicializa. Eso tiene dos consecuencias que definen el diseño:
'   1. Asignar .Color a ese panel DESPUES de cvs.Initialize borra el dibujo.
'   2. RemoveAllViews sobre ese panel se lleva puesto todo.
'Por eso el canvas vive en pnlCanvas, las views en pnlOverlay, y mBase queda
'transparente e intocado. Refresh solo limpia el overlay.
'
'UNA SOLA FUENTE DE VERDAD PARA EL TAMANO
'Las capas SIEMPRE se dimensionan contra mBase, nunca contra los parametros que
'llegan por AddToParent o Base_Resize. Si el llamador pasa un alto distinto del
'que el contenedor termino teniendo, las capas quedaban de un tamano y el marco
'de otro: el contenido se centraba en la capa chica y los titulos se cortaban
'contra su borde. SincronizarCapas corrige eso y Refresh la invoca.
'
'MEDICION DEL TEXTO
'El alto de linea se MIDE con el canvas, no se estima. La formula anterior
'(Size * 1.35dip) mezclaba unidades de fuente con dip y en pantallas densas
'devolvia un alto menor que el del texto real. Ademas el alto del Label se
'reasigna DESPUES del AddView: B4A remide el TextView interno al agregarlo y
'puede dejarlo mas bajo que lo pedido, recortando el descendente.
'
'SIN TIPOS PROPIOS
'Los pasos van en dos listas paralelas de String. En B4X los Type son globales
'al proyecto aunque se declaren dentro de una clase, asi que un componente
'reutilizable que declara Type puede chocar con otro modulo.
'
'Changelog
'V1.50
'  -AltoLinea medido con MeasureText en vez de estimado
'  -El alto de cada etiqueta se reasigna tras AddView
'  -Padding vertical del Label en cero (B4A)
'  -Getters LabelAltoPedido / LabelAltoReal para diagnostico
'V1.40
'  -Capas sincronizadas siempre contra mBase
'V1.30
'  -Etiquetas simetricas y ajuste automatico de fuente / dos lineas
'V1.20
'  -SidePadding y centrado vertical del bloque
'V1.11
'  -Se elimina el Type propio
'V1.10
'  -Separacion canvas / overlay
'V1.00
'  -Version inicial

#Event: StepClick (Index As Int, Id As String)

#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0xFF1B2733, Description: Fondo del componente
#DesignerProperty: Key: ActiveColor, DisplayName: Active Color, FieldType: Color, DefaultValue: 0xFF2F80ED, Description: Color de los pasos completados y del paso actual
#DesignerProperty: Key: InactiveColor, DisplayName: Inactive Color, FieldType: Color, DefaultValue: 0xFF3E4C59, Description: Color de los pasos pendientes
#DesignerProperty: Key: LineColor, DisplayName: Line Color, FieldType: Color, DefaultValue: 0xFF3E4C59, Description: Color de la linea entre pasos no completados
#DesignerProperty: Key: CircleTextColor, DisplayName: Circle Text Color, FieldType: Color, DefaultValue: 0xFFFFFFFF, Description: Color del numero o del check dentro del circulo
#DesignerProperty: Key: PendingTextColor, DisplayName: Pending Text Color, FieldType: Color, DefaultValue: 0xFF93A5B6, Description: Color del numero en los pasos pendientes
#DesignerProperty: Key: LabelColor, DisplayName: Label Color, FieldType: Color, DefaultValue: 0xFF93A5B6, Description: Color del titulo
#DesignerProperty: Key: CircleRadius, DisplayName: Circle Radius (dip), FieldType: Int, DefaultValue: 16, MinRange: 6, MaxRange: 48, Description: Radio pedido. Se recorta si no entra en el contenedor.
#DesignerProperty: Key: SidePadding, DisplayName: Side Padding (dip), FieldType: Int, DefaultValue: 20, MinRange: 0, MaxRange: 80, Description: Margen del borde al centro del primer y ultimo circulo
#DesignerProperty: Key: TextSize, DisplayName: Text Size, FieldType: Float, DefaultValue: 14, MinRange: 8, MaxRange: 30, Description: Tamano del numero dentro del circulo
#DesignerProperty: Key: LabelTextSize, DisplayName: Label Text Size, FieldType: Float, DefaultValue: 12, MinRange: 7, MaxRange: 26, Description: Tamano pedido para los titulos. Se reduce solo si no entra.
#DesignerProperty: Key: MinLabelTextSize, DisplayName: Min Label Text Size, FieldType: Float, DefaultValue: 9, MinRange: 6, MaxRange: 20, Description: Piso de legibilidad. Por debajo se pasa a dos lineas.
#DesignerProperty: Key: MaxLabelLines, DisplayName: Max Label Lines, FieldType: Int, DefaultValue: 2, MinRange: 1, MaxRange: 2, Description: 1 fuerza una sola linea, 2 permite el salto
#DesignerProperty: Key: LineWidth, DisplayName: Line Width (dip), FieldType: Int, DefaultValue: 3, MinRange: 1, MaxRange: 12, Description: Grosor de la linea conectora
#DesignerProperty: Key: Orientation, DisplayName: Orientation, FieldType: String, DefaultValue: HORIZONTAL, List: HORIZONTAL|VERTICAL, Description: Direccion del stepper
#DesignerProperty: Key: Clickable, DisplayName: Clickable, FieldType: Boolean, DefaultValue: True, Description: Permite volver a un paso ya completado

Sub Class_Globals
	Private xui As XUI
	Private mCallBack As Object
	Private mEventName As String

	Private mBase As B4XView
	Private pnlCanvas As B4XView      'solo dibujo
	Private pnlOverlay As B4XView     'solo views
	Private cvs As B4XCanvas

	'Listas paralelas: mIds(i) y mTitles(i) describen el mismo paso.
	Private mIds As List
	Private mTitles As List
	Private mCurrentIndex As Int = 0

	Private mBackColor, mActiveColor, mInactiveColor, mLineColor As Int
	Private mCircleTextColor, mPendingTextColor, mLabelColor As Int
	Private mRadius, mTextSize, mLineWidth, mSidePad As Float
	Private mLabelSize, mMinLabelSize As Float
	Private mMaxLines As Int
	Private mVertical As Boolean
	Private mClickable As Boolean

	'Resultado del ultimo ajuste, para diagnostico.
	Private rEfectivo, sizeEfectivo As Float
	Private lineasEfectivas As Int = 1
	Private altoPedido, altoReal As Float

	Private SEP As Float              'separacion circulo <-> etiqueta
	Private vistaLista As Boolean = False
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
	mIds.Initialize
	mTitles.Initialize
	SEP = 5dip
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mIds.IsInitialized = False Then mIds.Initialize
	If mTitles.IsInitialized = False Then mTitles.Initialize
	If SEP = 0 Then SEP = 5dip
	LeerProps(Props)

	'mBase queda transparente y sin dibujo propio: es solo el contenedor.
	mBase.Color = xui.Color_Transparent

	'Capa de dibujo. El color va ANTES de cvs.Initialize; despues de eso el
	'fondo lo pinta DrawRect y nadie vuelve a tocar .Color de este panel.
	pnlCanvas = xui.CreatePanel("")
	pnlCanvas.Color = mBackColor
	mBase.AddView(pnlCanvas, 0, 0, mBase.Width, mBase.Height)
	cvs.Initialize(pnlCanvas)

	'Capa de views. Es la unica que se limpia en cada Refresh.
	pnlOverlay = xui.CreatePanel("")
	pnlOverlay.Color = xui.Color_Transparent
	mBase.AddView(pnlOverlay, 0, 0, mBase.Width, mBase.Height)

	vistaLista = True
	SincronizarCapas
End Sub

Private Sub LeerProps (Props As Map)
	mBackColor        = xui.PaintOrColorToColor(Props.Get("BackgroundColor"))
	mActiveColor      = xui.PaintOrColorToColor(Props.Get("ActiveColor"))
	mInactiveColor    = xui.PaintOrColorToColor(Props.Get("InactiveColor"))
	mLineColor        = xui.PaintOrColorToColor(Props.Get("LineColor"))
	mCircleTextColor  = xui.PaintOrColorToColor(Props.Get("CircleTextColor"))
	mPendingTextColor = xui.PaintOrColorToColor(Props.Get("PendingTextColor"))
	mLabelColor       = xui.PaintOrColorToColor(Props.Get("LabelColor"))
	mRadius       = Props.GetDefault("CircleRadius", 16) * 1dip
	mSidePad      = Props.GetDefault("SidePadding", 20) * 1dip
	mTextSize     = Props.GetDefault("TextSize", 14)
	mLabelSize    = Props.GetDefault("LabelTextSize", 12)
	mMinLabelSize = Props.GetDefault("MinLabelTextSize", 9)
	mMaxLines     = Props.GetDefault("MaxLabelLines", 2)
	mLineWidth    = Props.GetDefault("LineWidth", 3) * 1dip
	mVertical     = (Props.GetDefault("Orientation", "HORIZONTAL") = "VERTICAL")
	mClickable    = Props.GetDefault("Clickable", True)
End Sub

Public Sub PropsPorDefecto As Map
	Return CreateMap( _
		"BackgroundColor": 0xFF1B2733, _
		"ActiveColor": 0xFF2F80ED, _
		"InactiveColor": 0xFF3E4C59, _
		"LineColor": 0xFF3E4C59, _
		"CircleTextColor": 0xFFFFFFFF, _
		"PendingTextColor": 0xFF93A5B6, _
		"LabelColor": 0xFF93A5B6, _
		"CircleRadius": 16, _
		"SidePadding": 20, _
		"TextSize": 14, _
		"LabelTextSize": 12, _
		"MinLabelTextSize": 9, _
		"MaxLabelLines": 2, _
		"LineWidth": 3, _
		"Orientation": "HORIZONTAL", _
		"Clickable": True)
End Sub

'Agrega el view por codigo, sin usar el Designer.
Public Sub AddToParent (Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	Dim p As B4XView = xui.CreatePanel("")
	Parent.AddView(p, Left, Top, Width, Height)
	DesignerCreateView(p, Null, PropsPorDefecto)
End Sub

'Se conserva la firma porque el Designer la llama con parametros, pero los
'valores se ignoran a proposito: la medida buena es la de mBase.
Public Sub Base_Resize (Width As Double, Height As Double)
	If Not(vistaLista) Then Return
	SincronizarCapas
End Sub

'Iguala las dos capas y el canvas al tamano real de mBase. Es la unica funcion
'que dimensiona: cualquier otra ruta pasa por aca.
Private Sub SincronizarCapas
	If Not(vistaLista) Then Return
	Dim w As Float = mBase.Width
	Dim h As Float = mBase.Height
	If w <= 0 Or h <= 0 Then Return
	If pnlCanvas.Width <> w Or pnlCanvas.Height <> h Then
		pnlCanvas.SetLayoutAnimated(0, 0, 0, w, h)
		pnlOverlay.SetLayoutAnimated(0, 0, 0, w, h)
		cvs.Resize(w, h)
	End If
	Refresh
End Sub

#Region Pasos

Public Sub AddStep (Id As String, Title As String)
	mIds.Add(Id)
	mTitles.Add(Title)
	Refresh
End Sub

'Carga todos los pasos de una. Ids y Titles deben tener el mismo largo.
Public Sub SetSteps (Ids() As String, Titles() As String)
	mIds.Clear
	mTitles.Clear
	For i = 0 To Min(Ids.Length, Titles.Length) - 1
		mIds.Add(Ids(i))
		mTitles.Add(Titles(i))
	Next
	mCurrentIndex = Min(mCurrentIndex, Max(0, mIds.Size - 1))
	Refresh
End Sub

Public Sub ClearSteps
	mIds.Clear
	mTitles.Clear
	mCurrentIndex = 0
	Refresh
End Sub

Public Sub getStepCount As Int
	Return mIds.Size
End Sub

Public Sub GetStepId (Index As Int) As String
	If Index < 0 Or Index >= mIds.Size Then Return ""
	Return mIds.Get(Index)
End Sub

Public Sub GetStepTitle (Index As Int) As String
	If Index < 0 Or Index >= mTitles.Size Then Return ""
	Return mTitles.Get(Index)
End Sub

Public Sub setCurrentIndex (Index As Int)
	mCurrentIndex = Max(0, Min(Index, mIds.Size - 1))
	Refresh
End Sub

Public Sub getCurrentIndex As Int
	Return mCurrentIndex
End Sub

Public Sub getCurrentId As String
	Return GetStepId(mCurrentIndex)
End Sub

'Avanza un paso. Devuelve False si ya estaba en el ultimo.
Public Sub NextStep As Boolean
	If mCurrentIndex >= mIds.Size - 1 Then Return False
	setCurrentIndex(mCurrentIndex + 1)
	Return True
End Sub

'Retrocede un paso. Devuelve False si ya estaba en el primero.
Public Sub PreviousStep As Boolean
	If mCurrentIndex <= 0 Then Return False
	setCurrentIndex(mCurrentIndex - 1)
	Return True
End Sub

#End Region

#Region Apariencia

Public Sub setBackgroundColor (Color As Int)
	mBackColor = Color
	Refresh
End Sub
Public Sub getBackgroundColor As Int
	Return mBackColor
End Sub

Public Sub setActiveColor (Color As Int)
	mActiveColor = Color
	Refresh
End Sub
Public Sub getActiveColor As Int
	Return mActiveColor
End Sub

Public Sub setInactiveColor (Color As Int)
	mInactiveColor = Color
	Refresh
End Sub
Public Sub getInactiveColor As Int
	Return mInactiveColor
End Sub

Public Sub setLineColor (Color As Int)
	mLineColor = Color
	Refresh
End Sub
Public Sub getLineColor As Int
	Return mLineColor
End Sub

Public Sub setLabelColor (Color As Int)
	mLabelColor = Color
	Refresh
End Sub
Public Sub getLabelColor As Int
	Return mLabelColor
End Sub

Public Sub setCircleTextColor (Color As Int)
	mCircleTextColor = Color
	Refresh
End Sub
Public Sub getCircleTextColor As Int
	Return mCircleTextColor
End Sub

Public Sub setPendingTextColor (Color As Int)
	mPendingTextColor = Color
	Refresh
End Sub
Public Sub getPendingTextColor As Int
	Return mPendingTextColor
End Sub

'Radio PEDIDO en dip. El efectivo puede ser menor si no entra.
Public Sub setCircleRadius (Dips As Float)
	If Dips < 6 Then Return
	mRadius = Dips * 1dip
	Refresh
End Sub
Public Sub getCircleRadius As Float
	Return mRadius / 1dip
End Sub

Public Sub getCircleRadiusEfectivo As Float
	Return rEfectivo / 1dip
End Sub

Public Sub getLabelTextSizeEfectivo As Float
	Return sizeEfectivo
End Sub

Public Sub getLabelLinesEfectivo As Int
	Return lineasEfectivas
End Sub

'Alto que se le pidio a la etiqueta y alto que B4A le dio realmente. Si no
'coinciden, el texto se recorta y el problema es del Label, no del calculo.
Public Sub getLabelAltoPedido As Float
	Return altoPedido
End Sub

Public Sub getLabelAltoReal As Float
	Return altoReal
End Sub

'Tamano real de la capa de dibujo. Si no coincide con el de la base, hay
'desfase y el dibujo sale descolocado.
Public Sub getCanvasWidth As Float
	If Not(vistaLista) Then Return 0
	Return pnlCanvas.Width
End Sub

Public Sub getCanvasHeight As Float
	If Not(vistaLista) Then Return 0
	Return pnlCanvas.Height
End Sub

Public Sub setSidePadding (Dips As Float)
	If Dips < 0 Then Return
	mSidePad = Dips * 1dip
	Refresh
End Sub
Public Sub getSidePadding As Float
	Return mSidePad / 1dip
End Sub

'Tamano del numero dentro del circulo.
Public Sub setTextSize (Size As Float)
	If Size < 6 Then Return
	mTextSize = Size
	Refresh
End Sub
Public Sub getTextSize As Float
	Return mTextSize
End Sub

'Tamano pedido para los titulos.
Public Sub setLabelTextSize (Size As Float)
	If Size < 6 Then Return
	mLabelSize = Size
	Refresh
End Sub
Public Sub getLabelTextSize As Float
	Return mLabelSize
End Sub

Public Sub setMinLabelTextSize (Size As Float)
	If Size < 6 Then Return
	mMinLabelSize = Size
	Refresh
End Sub
Public Sub getMinLabelTextSize As Float
	Return mMinLabelSize
End Sub

'1 fuerza una sola linea, 2 permite el salto.
Public Sub setMaxLabelLines (Lines As Int)
	mMaxLines = Max(1, Min(2, Lines))
	Refresh
End Sub
Public Sub getMaxLabelLines As Int
	Return mMaxLines
End Sub

Public Sub setLineWidth (Dips As Float)
	If Dips < 1 Then Return
	mLineWidth = Dips * 1dip
	Refresh
End Sub
Public Sub getLineWidth As Float
	Return mLineWidth / 1dip
End Sub

Public Sub setVertical (b As Boolean)
	mVertical = b
	Refresh
End Sub
Public Sub getVertical As Boolean
	Return mVertical
End Sub

Public Sub setClickable (b As Boolean)
	mClickable = b
	Refresh
End Sub
Public Sub getClickable As Boolean
	Return mClickable
End Sub

Public Sub getBase As B4XView
	Return mBase
End Sub

'Alto ideal del contenedor: ni sobra ni falta.
Public Sub getAltoRecomendado As Float
	If mVertical Then Return Max(1, mIds.Size) * (2 * mRadius + 14dip)
	Return 2 * mRadius + SEP + AltoLinea(mLabelSize) * mMaxLines + 10dip
End Sub

#End Region

#Region Ajuste

'Alto real de una linea a ese tamano, MEDIDO con el canvas. "Ag" tiene
'ascendente y descendente, asi que devuelve la caja completa de la fuente y no
'la de un texto en particular. Estimarlo como Size * 1.35dip mezclaba unidades
'de fuente con dip y en pantallas densas quedaba corto.
Private Sub AltoLinea (Size As Float) As Float
	If Not(vistaLista) Then Return Size * 2dip
	Dim r As B4XRect = cvs.MeasureText("Ag", xui.CreateDefaultFont(Size))
	Return r.Height + 6dip
End Sub

Private Sub AnchoTexto (Texto As String, Size As Float) As Float
	Dim r As B4XRect = cvs.MeasureText(Texto, xui.CreateDefaultFont(Size))
	Return r.Width
End Sub

'Ancho disponible para la etiqueta, SIMETRICO respecto del circulo. La simetria
'es lo que mantiene el titulo centrado bajo su circulo: recortar solo el lado
'que se sale desplazaba visualmente el primero y el ultimo.
Private Sub AnchoEtiqueta (cx As Float, Paso As Float, Cuenta As Int) As Float
	Dim hastaBorde As Float = Min(cx - 2dip, pnlCanvas.Width - 2dip - cx)
	Dim ancho As Float = 2 * hastaBorde
	If Cuenta > 1 Then ancho = Min(ancho, Paso * 0.96)
	Return Max(12dip, ancho)
End Sub

'Titulo mas largo: manda para elegir fuente y numero de lineas, asi todos los
'pasos comparten tamano y el conjunto se ve parejo.
Private Sub AnchoTituloMayor (Size As Float) As Float
	Dim m As Float = 0
	For Each t As String In mTitles
		m = Max(m, AnchoTexto(t, Size))
	Next
	Return m
End Sub

'Primero achica la fuente hasta el piso; recien despues parte en dos lineas.
Private Sub AjustarEtiquetas (AnchoDisp As Float)
	Dim s As Float = mLabelSize
	Do While s > mMinLabelSize And AnchoTituloMayor(s) > AnchoDisp
		s = s - 0.5
	Loop
	If AnchoTituloMayor(s) <= AnchoDisp Or mMaxLines = 1 Then
		sizeEfectivo = s
		lineasEfectivas = 1
		Return
	End If
	'No entro ni al minimo: dos lineas, y se recupera tamano porque cada linea
	'carga con la mitad del texto.
	Dim s2 As Float = mLabelSize
	Do While s2 > mMinLabelSize And AnchoTituloMayor(s2) > AnchoDisp * 2
		s2 = s2 - 0.5
	Loop
	sizeEfectivo = s2
	lineasEfectivas = 2
End Sub

#End Region

#Region Dibujo

Public Sub Refresh
	If Not(vistaLista) Then Return

	'Si el contenedor cambio de tamano desde el ultimo dibujo, las capas se
	'ajustan primero. Asi Refresh es seguro en cualquier momento.
	If mBase.Width > 0 And mBase.Height > 0 Then
		If pnlCanvas.Width <> mBase.Width Or pnlCanvas.Height <> mBase.Height Then
			pnlCanvas.SetLayoutAnimated(0, 0, 0, mBase.Width, mBase.Height)
			pnlOverlay.SetLayoutAnimated(0, 0, 0, mBase.Width, mBase.Height)
			cvs.Resize(mBase.Width, mBase.Height)
		End If
	End If
	If pnlCanvas.Width <= 0 Or pnlCanvas.Height <= 0 Then Return

	'El fondo va como primer trazo. ClearRect deja transparente y el bitmap del
	'canvas sustituye al Color del panel.
	cvs.ClearRect(cvs.TargetRect)
	cvs.DrawRect(cvs.TargetRect, mBackColor, True, 0)

	'Solo se limpia el overlay. pnlCanvas nunca se toca.
	pnlOverlay.RemoveAllViews

	If mIds.Size > 0 Then
		If mVertical Then
			DibujarVertical
		Else
			DibujarHorizontal
		End If
	End If
	cvs.Invalidate
End Sub

Private Sub DibujarHorizontal
	Dim n As Int = mIds.Size
	Dim W As Float = pnlCanvas.Width
	Dim H As Float = pnlCanvas.Height

	'Pasada 1: radio provisional para saber donde caen los circulos.
	Dim r As Float = LimitarRadio(mRadius, n, 1)
	Dim izq As Float = mSidePad + r
	Dim paso As Float = 0
	If n > 1 Then paso = (W - 2 * izq) / (n - 1)

	'Ajuste de texto con ese ancho, y radio definitivo con las lineas reales.
	AjustarEtiquetas(AnchoEtiqueta(izq, paso, n))
	r = LimitarRadio(mRadius, n, lineasEfectivas)
	rEfectivo = r
	izq = mSidePad + r
	If n > 1 Then paso = (W - 2 * izq) / (n - 1) Else paso = 0

	Dim labelH As Float = AltoLinea(sizeEfectivo) * lineasEfectivas
	Dim bloque As Float = 2 * r + SEP + labelH
	Dim arriba As Float = Max(0, (H - bloque) / 2)
	Dim cy As Float = arriba + r

	'lineas primero, para que los circulos queden encima
	For i = 0 To n - 2
		Dim c As Int = mLineColor
		If i + 1 <= mCurrentIndex Then c = mActiveColor
		cvs.DrawLine(CentroH(i, izq, paso, n) + r, cy, _
			CentroH(i + 1, izq, paso, n) - r, cy, c, mLineWidth)
	Next

	For i = 0 To n - 1
		Dim cx As Float = CentroH(i, izq, paso, n)
		DibujarCirculo(i, cx, cy, r)

		'ancho simetrico: el centro del label coincide siempre con el circulo
		Dim lw As Float = AnchoEtiqueta(cx, paso, n)
		AgregarEtiqueta(mTitles.Get(i), "CENTER", cx - lw / 2, cy + r + SEP, lw, labelH)

		AgregarZonaToque(i, cx - r - 3dip, cy - r - 3dip, 2 * r + 6dip, 2 * r + 6dip)
	Next
End Sub

Private Sub DibujarVertical
	Dim n As Int = mIds.Size
	Dim W As Float = pnlCanvas.Width
	Dim H As Float = pnlCanvas.Height

	Dim r As Float = Min(mRadius, ((H - 2 * mSidePad) / Max(1, n) - 6dip) / 2)
	r = Max(4dip, r)
	rEfectivo = r

	Dim cx As Float = mSidePad + r
	Dim x As Float = cx + r + 10dip
	AjustarEtiquetas(Max(12dip, W - x - mSidePad))
	Dim labelH As Float = AltoLinea(sizeEfectivo) * lineasEfectivas

	Dim arriba As Float = mSidePad + r
	Dim paso As Float = 0
	If n > 1 Then paso = (H - 2 * arriba) / (n - 1)

	For i = 0 To n - 2
		Dim c As Int = mLineColor
		If i + 1 <= mCurrentIndex Then c = mActiveColor
		cvs.DrawLine(cx, CentroV(i, arriba, paso, n) + r, _
			cx, CentroV(i + 1, arriba, paso, n) - r, c, mLineWidth)
	Next

	For i = 0 To n - 1
		Dim cy As Float = CentroV(i, arriba, paso, n)
		DibujarCirculo(i, cx, cy, r)
		AgregarEtiqueta(mTitles.Get(i), "LEFT", x, cy - labelH / 2, _
			Max(12dip, W - x - mSidePad), labelH)
		AgregarZonaToque(i, cx - r - 3dip, cy - r - 3dip, 2 * r + 6dip, 2 * r + 6dip)
	Next
End Sub

'El radio nunca puede hacer que el contenido exceda la base: se limita por el
'alto que sobra tras reservar el texto, y por el ancho por paso para que dos
'circulos no se toquen.
Private Sub LimitarRadio (Pedido As Float, Cuenta As Int, Lineas As Int) As Float
	Dim tam As Float = sizeEfectivo
	If tam <= 0 Then tam = mLabelSize
	Dim reservaTexto As Float = SEP + AltoLinea(tam) * Lineas + 6dip
	Dim r As Float = Min(Pedido, (pnlCanvas.Height - reservaTexto) / 2)
	If Cuenta > 1 Then
		Dim porPaso As Float = (pnlCanvas.Width - 2 * mSidePad) / (Cuenta - 1)
		r = Min(r, porPaso / 2 - 2dip)
	End If
	Return Max(4dip, r)
End Sub

Private Sub CentroH (Index As Int, Izq As Float, Paso As Float, Cuenta As Int) As Float
	If Cuenta = 1 Then Return pnlCanvas.Width / 2
	Return Izq + Index * Paso
End Sub

Private Sub CentroV (Index As Int, Arriba As Float, Paso As Float, Cuenta As Int) As Float
	If Cuenta = 1 Then Return pnlCanvas.Height / 2
	Return Arriba + Index * Paso
End Sub

Private Sub DibujarCirculo (Index As Int, cx As Float, cy As Float, r As Float)
	If Index < mCurrentIndex Then
		cvs.DrawCircle(cx, cy, r, mActiveColor, True, 0)
		DibujarCheck(cx, cy, r, mCircleTextColor)
	Else if Index = mCurrentIndex Then
		cvs.DrawCircle(cx, cy, r, mActiveColor, True, 0)
		DibujarNumero(Index + 1, cx, cy, r, mCircleTextColor, True)
	Else
		cvs.DrawCircle(cx, cy, r, mInactiveColor, True, 0)
		DibujarNumero(Index + 1, cx, cy, r, mPendingTextColor, False)
	End If
End Sub

Private Sub DibujarCheck (cx As Float, cy As Float, r As Float, Color As Int)
	Dim p As B4XPath
	p.Initialize(cx - r * 0.40, cy + r * 0.02)
	p.LineTo(cx - r * 0.12, cy + r * 0.32)
	p.LineTo(cx + r * 0.42, cy - r * 0.30)
	cvs.DrawPath(p, Color, False, Max(2dip, r * 0.15))
End Sub

'El numero se achica junto con el circulo cuando el radio fue recortado, para
'que nunca sobresalga del borde.
Private Sub DibujarNumero (Numero As Int, cx As Float, cy As Float, r As Float, Color As Int, Negrita As Boolean)
	Dim tam As Float = Min(mTextSize, (r / 1dip) * 0.95)
	Dim fnt As B4XFont
	If Negrita Then
		fnt = xui.CreateDefaultBoldFont(tam)
	Else
		fnt = xui.CreateDefaultFont(tam)
	End If
	Dim txt As String = Numero
	Dim rct As B4XRect = cvs.MeasureText(txt, fnt)
	cvs.DrawText(txt, cx, cy - rct.Height / 2 - rct.Top, fnt, Color, "CENTER")
End Sub

'Crea la etiqueta, la agrega y REASIGNA su alto. B4A remide el TextView interno
'al agregarlo y puede dejarlo mas bajo que lo pedido, lo que recorta el
'descendente de las letras. El SetLayoutAnimated posterior fija el alto real.
Private Sub AgregarEtiqueta (Texto As String, Alineacion As String, x As Float, y As Float, w As Float, h As Float)
	Dim L As Label
	L.Initialize("")
	Dim lbl As B4XView = L
	lbl.Text = Texto
	lbl.TextColor = mLabelColor
	lbl.Font = xui.CreateDefaultFont(sizeEfectivo)
	lbl.SetTextAlignment("CENTER", Alineacion)
	#if B4A
	L.SingleLine = (lineasEfectivas = 1)
	'sin padding el descendente no se recorta contra el borde del label
	L.Padding = Array As Int (0, 0, 0, 0)
	#End If
	pnlOverlay.AddView(lbl, x, y, w, h)
	lbl.SetLayoutAnimated(0, x, y, w, h)

	altoPedido = h
	altoReal = lbl.Height
End Sub

Private Sub AgregarZonaToque (Index As Int, Izq As Float, Arriba As Float, Ancho As Float, Alto As Float)
	If mClickable = False Then Return
	Dim p As B4XView = xui.CreatePanel("zona")
	p.Color = xui.Color_Transparent
	p.Tag = Index
	pnlOverlay.AddView(p, Izq, Arriba, Ancho, Alto)
End Sub

Private Sub zona_Click
	Dim v As B4XView = Sender
	Dim idx As Int = v.Tag
	'solo se puede volver a un paso ya completado
	If idx > mCurrentIndex Then Return
	If xui.SubExists(mCallBack, mEventName & "_StepClick", 2) Then
		CallSub3(mCallBack, mEventName & "_StepClick", idx, mIds.Get(idx))
	End If
End Sub

#End Region