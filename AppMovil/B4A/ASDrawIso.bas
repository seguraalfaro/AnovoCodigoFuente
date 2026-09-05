B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
B4A=True

'Name: ASDrawIso
'Version: 3.1
'Lienzo de croquis para el sistema de cotizaciones de Anovo (TFG UNED IS-2026).
'
'ARQUITECTURA
'El dibujo no se acumula en un bitmap sino que vive como lista de trazos
'vectoriales y se repinta completo. Eso habilita borrar un trazo suelto,
'rotular cotas en metros y serializar el croquis.
'
'FORMATO DE TRABAJO: JSON
'El croquis se persiste y se sincroniza como JSON vectorial (kilobytes en vez
'de cientos, y reeditable). ExportarPNGBytes se conserva pero solo se invoca
'cuando se necesita la imagen: generar el PDF de la cotizacion o adjuntarla.
'La imagen se genera en el dispositivo que dibujo, garantizando que lo que ve
'el cliente sea identico a lo que se dibujo en sitio.
'
'UNA SOLA FUENTE DE VERDAD PARA EL TAMANO
'El panel de dibujo se dimensiona SIEMPRE contra mBase, nunca contra los
'parametros que llegan por Base_Resize. Los tamanos se comparan con tolerancia:
'son Float y B4A puede devolver valores que difieren en decimales entre un
'panel y su contenedor. Comparar con "=" provocaba una resincronizacion en
'cada repintado y con ella un reescalado que encogia los trazos.
'
'EL COLOR DEL PANEL NO SE TOCA DESPUES DE cvs.Initialize
'En B4A el B4XCanvas se instala como background drawable del panel. Asignar
'.Color despues borra el dibujo. El papel se pinta como primer trazo.
'
'TIPOS GLOBALES
'ASDPunto y ASDTrazo son Type y en B4X los Type son globales al proyecto aunque
'se declaren dentro de una clase. Si convive con otro modulo que declare tipos
'con el mismo nombre, el compilador falla con "An item with the same key has
'already been added".
'
'Changelog
'V3.1
'  -ImportarJSON registra el motivo del fallo en UltimoError y lo escribe al Log
'  -Se distingue "sin croquis" (texto vacio) de "croquis corrupto"
'V3.0
'  -Se retira la instrumentacion de diagnostico (LogD, DIAG, nInstancia)
'V2.2
'  -DesignerCreateView ya no reinicializa el croquis si ya existia: al rotar,
'   B4A puede volver a llamarlo sobre la misma instancia y borraba todo
'  -Comparacion de tamanos con tolerancia
'  -Reescalar ignora factores practicamente unitarios
'V2.1
'  -Reescalado de trazos al cambiar el tamano del lienzo
'  -SincronizarLienzo como unica funcion que dimensiona
'V2.0
'  -Modo Linea, color y grosor por trazo, doble toque, ExportarPNGBytes
'V1.0
'  -Reescritura sobre B4XCanvas con modelo vectorial

#DesignerProperty: Key: Enable, DisplayName: Enable, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: Modo, DisplayName: Modo, FieldType: String, DefaultValue: puntos, List: puntos|linea|libre|cota|borrar

#DesignerProperty: Key: StrokeWidth, DisplayName: Stroke Width, FieldType: Float, DefaultValue: 3
#DesignerProperty: Key: StrokeColor, DisplayName: Stroke Color, FieldType: Color, DefaultValue: 0xFF14181D
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0xFFFDFDFB

#DesignerProperty: Key: GridVisible, DisplayName: Grid Visible, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: GridSnap, DisplayName: Grid Snap, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: GridSize, DisplayName: Grid Size (dip), FieldType: Float, DefaultValue: 34
#DesignerProperty: Key: GridColor, DisplayName: Grid Color, FieldType: Color, DefaultValue: 0xFFBAC8D6

#DesignerProperty: Key: MetersPerCell, DisplayName: Meters Per Cell, FieldType: Float, DefaultValue: 0.5
#DesignerProperty: Key: ShowLabels, DisplayName: Show Measure Labels, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: GuideColor, DisplayName: Guide Color, FieldType: Color, DefaultValue: 0xFFD97706
#DesignerProperty: Key: DimensionColor, DisplayName: Dimension Color, FieldType: Color, DefaultValue: 0xFF0F766E
#DesignerProperty: Key: CrosshairColor, DisplayName: Crosshair Color, FieldType: Color, DefaultValue: 0xFF2F80ED
#DesignerProperty: Key: LabelTextSize, DisplayName: Label Text Size, FieldType: Float, DefaultValue: 11

#Event: Cambio
#Event: Touch (Action As Int, XY As Map)

Sub Class_Globals
	Private xui As XUI
	Private mCallBack As Object
	Private mEventName As String

	Private mBase As B4XView
	Private pnl As B4XView
	Private cvs As B4XCanvas

	'Color y Grosor viajan DENTRO del trazo: cambiar el lapiz no debe alterar
	'lo ya dibujado.
	Type ASDPunto (X As Float, Y As Float)
	Type ASDTrazo (Tipo As String, Pts As List, Color As Int, Grosor As Float)

	Private trazos As List
	Private hist As List
	Private hIdx As Int = 0

	'--- estado de interaccion ---
	Private modo As String = "puntos"    'puntos | linea | libre | cota | borrar
	Private verRejilla As Boolean = True
	Private conIman As Boolean = True
	Private verRotulos As Boolean = True
	Private escalaM As Float = 0.5

	Private cadena As ASDTrazo           'polilinea toque a toque en construccion
	Private ancla As ASDPunto            'ultimo vertice fijado de la cadena
	Private cursor As ASDPunto           'punto imantado bajo el dedo
	Private libre As ASDTrazo            'trazo a mano alzada en curso
	Private cotaTmp As ASDPunto          'primer punto de una cota
	Private arrastreIni As ASDPunto      'origen de la recta por arrastre

	Private bajadoX, bajadoY As Float
	Private movido As Boolean
	Private UMBRAL As Float
	Private ultimoToqueMs As Long        'para detectar doble toque
	Private ultimoToqueX, ultimoToqueY As Float
	Private VENTANA_DOBLE As Int = 400   'ms

	'--- geometria de la reticula triangular ---
	Private LADO As Float
	Private UX, UY, VX, VY, DET As Float

	'--- lapiz activo ---
	Private colorLapiz As Int
	Private grosorLapiz As Float

	'--- apariencia ---
	Private fntCota As B4XFont
	Private habilitado As Boolean = True

	Private vistaLista As Boolean = False
	Private enSincronia As Boolean = False   'evita recursion Pintar <-> Sincronizar
	Private C_PAPEL, C_REJILLA, C_GUIA, C_ACTIVO, C_COTA, C_ROTULO As Int

	'Motivo del ultimo fallo de ImportarJSON. Vacio si la ultima importacion
	'salio bien. Lo lee la pagina para avisar al usuario.
	Private ultimoError As String = ""
End Sub

'El Designer llama Initialize con dos parametros y luego DesignerCreateView.
'El panel no se crea aqui: en este punto la vista base todavia no existe.
Public Sub Initialize (Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	LeerProps(Props)

	'Al rotar, B4A recrea la Activity y el hospedador puede volver a llamar a
	'DesignerCreateView sobre la MISMA instancia. Reinicializar las listas aqui
	'borraba el croquis: solo se crean si aun no existen.
	If trazos.IsInitialized = False Then
		trazos.Initialize
		hist.Initialize
		hist.Add(CopiaLista(trazos))
		hIdx = 0
	End If
	UMBRAL = 6dip
	CalcularBase

	'mBase queda transparente: el papel lo pinta el canvas, no el contenedor.
	mBase.Color = xui.Color_Transparent

	'El color va ANTES de cvs.Initialize. Despues de esa llamada, asignar
	'pnl.Color reemplazaria el bitmap del canvas y borraria el dibujo.
	pnl = xui.CreatePanel("pnl")
	pnl.Color = C_PAPEL
	mBase.AddView(pnl, 0, 0, mBase.Width, mBase.Height)
	cvs.Initialize(pnl)

	vistaLista = True
	SincronizarLienzo
End Sub

Private Sub LeerProps (Props As Map)
	habilitado  = Props.Get("Enable")
	modo        = Props.Get("Modo")

	grosorLapiz = DipToCurrent(Props.Get("StrokeWidth"))
	colorLapiz  = xui.PaintOrColorToColor(Props.Get("StrokeColor"))
	C_PAPEL     = xui.PaintOrColorToColor(Props.Get("BackgroundColor"))

	verRejilla  = Props.Get("GridVisible")
	conIman     = Props.Get("GridSnap")
	'LADO solo se toma de las props en la primera construccion: si el lienzo ya
	'fue reescalado, volver al valor del Designer descolocaria los trazos
	'respecto de la reticula.
	If LADO <= 0 Then LADO = DipToCurrent(Props.Get("GridSize"))
	C_REJILLA   = xui.PaintOrColorToColor(Props.Get("GridColor"))

	escalaM     = Props.Get("MetersPerCell")
	verRotulos  = Props.Get("ShowLabels")
	C_GUIA      = xui.PaintOrColorToColor(Props.Get("GuideColor"))
	C_COTA      = xui.PaintOrColorToColor(Props.Get("DimensionColor"))
	C_ACTIVO    = xui.PaintOrColorToColor(Props.Get("CrosshairColor"))

	fntCota     = xui.CreateDefaultFont(Props.Get("LabelTextSize"))
	C_ROTULO    = xui.Color_ARGB(255, 90, 102, 115)
End Sub

'Valores por defecto para instanciar por codigo cuando no hay layout.
Public Sub PropsPorDefecto As Map
	Return CreateMap( _
		"Enable": True, _
		"Modo": "puntos", _
		"StrokeWidth": 3, _
		"StrokeColor": 0xFF14181D, _
		"BackgroundColor": 0xFFFDFDFB, _
		"GridVisible": True, _
		"GridSnap": True, _
		"GridSize": 34, _
		"GridColor": 0xFFBAC8D6, _
		"MetersPerCell": 0.5, _
		"ShowLabels": True, _
		"GuideColor": 0xFFD97706, _
		"DimensionColor": 0xFF0F766E, _
		"CrosshairColor": 0xFF2F80ED, _
		"LabelTextSize": 11)
End Sub

#Region Dimensionado

'Los tamanos son Float y B4A puede devolver valores que difieren en decimales
'entre un panel y su contenedor. Comparar con "=" provocaba resincronizacion
'en cada repintado, y con ella un reescalado que encogia los trazos.
Private Sub MismoTamano (a As Float, b As Float) As Boolean
	Return Abs(a - b) < 1
End Sub

'Se conserva la firma porque el Designer la llama con parametros, pero los
'valores se ignoran a proposito: la medida buena es la de mBase.
Public Sub Base_Resize (Width As Double, Height As Double)
	If Not(vistaLista) Then Return
	SincronizarLienzo
End Sub

'Unica funcion que dimensiona. Cualquier otra ruta pasa por aqui.
Private Sub SincronizarLienzo
	If Not(vistaLista) Then Return
	Dim W As Float = mBase.Width
	Dim H As Float = mBase.Height
	If W <= 0 Or H <= 0 Then Return

	If MismoTamano(pnl.Width, W) And MismoTamano(pnl.Height, H) Then
		enSincronia = True
		Pintar
		enSincronia = False
		Return
	End If

	'Los trazos viven en pixeles absolutos. Sin reescalar, al rotar el
	'dispositivo el croquis se corre y se recorta.
	If pnl.Width > 0 And pnl.Height > 0 Then
		Reescalar(W / pnl.Width, H / pnl.Height)
	End If

	pnl.SetLayoutAnimated(0, 0, 0, W, H)
	cvs.Resize(W, H)

	enSincronia = True
	Pintar
	enSincronia = False
End Sub

'Escala uniforme, no por eje. La reticula es isometrica: estirar X e Y con
'factores distintos rompe los 60 grados y las cotas pasarian a mentir.
Private Sub Reescalar (fx As Float, fy As Float)
	Dim f As Float = Min(fx, fy)
	If f <= 0 Then Return
	'Un factor practicamente unitario no debe tocar nada: aplicarlo muchas
	'veces acumula error de redondeo y desplaza el dibujo.
	If Abs(f - 1) < 0.01 Then Return

	For Each t As ASDTrazo In trazos
		EscalarPuntos(t.Pts, f)
	Next

	'El historial comparte los mismos objetos ASDTrazo que la lista activa, asi
	'que ya queda reescalado. Solo falta lo que esta en construccion.
	If cadena.IsInitialized Then EscalarPuntos(cadena.Pts, f)
	If libre.IsInitialized Then EscalarPuntos(libre.Pts, f)
	If ancla.IsInitialized Then
		ancla.X = ancla.X * f
		ancla.Y = ancla.Y * f
	End If
	If cotaTmp.IsInitialized Then
		cotaTmp.X = cotaTmp.X * f
		cotaTmp.Y = cotaTmp.Y * f
	End If
	If arrastreIni.IsInitialized Then
		arrastreIni.X = arrastreIni.X * f
		arrastreIni.Y = arrastreIni.Y * f
	End If
	If cursor.IsInitialized Then
		cursor.X = cursor.X * f
		cursor.Y = cursor.Y * f
	End If

	'La arista de la reticula acompana al dibujo: si no, los trazos dejarian de
	'caer sobre los nodos y el iman corregiria hacia puntos erroneos. Ademas
	'mantiene la razon escalaM/LADO, asi que las medidas no cambian al rotar.
	LADO = LADO * f
	CalcularBase
End Sub

Private Sub EscalarPuntos (pts As List, f As Float)
	If pts.IsInitialized = False Then Return
	For Each p As ASDPunto In pts
		p.X = p.X * f
		p.Y = p.Y * f
	Next
End Sub

#End Region

#Region Reticula

Private Sub CalcularBase
	Dim S3 As Float = Sqrt(3) / 2
	UX = S3 * LADO : UY = -LADO / 2
	VX = S3 * LADO : VY =  LADO / 2
	DET = UX * VY - UY * VX
End Sub

'Nodo mas cercano, por regla de Cramer sobre los dos vectores base.
Private Sub Imantar (p As ASDPunto) As ASDPunto
	If Not(conIman) Then Return p
	Dim i As Int = Round(( p.X * VY - p.Y * VX) / DET)
	Dim j As Int = Round((-p.X * UY + p.Y * UX) / DET)
	Return Pt(i * UX + j * VX, i * UY + j * VY)
End Sub

Private Sub PintarRejilla
	Dim S3 As Float = Sqrt(3) / 2
	Dim pasoX As Float = S3 * LADO
	Dim W As Float = pnl.Width
	Dim H As Float = pnl.Height
	If pasoX < 1 Or LADO < 1 Then Return

	'Verticales: columnas de nodos, separadas (raiz3/2)*LADO
	Dim nX As Int = Ceil(W / pasoX)
	For k = 0 To nX
		Dim x As Float = k * pasoX
		cvs.DrawLine(x, 0, x, H, C_REJILLA, 1dip)
	Next

	'Diagonales: siguiendo una hacia atras hasta x=0 desde cualquier nodo el
	'corte cae en multiplo entero de LADO, por eso la separacion es LADO.
	Dim pend As Float = 1 / Sqrt(3)
	Dim desvio As Float = W * pend
	Dim kMin As Int = Floor((-desvio - LADO) / LADO)
	Dim kMax As Int = Ceil((H + desvio + LADO) / LADO)

	For d = 0 To 1
		Dim mm As Float = pend
		If d = 0 Then mm = -pend
		For k = kMin To kMax
			Dim y0 As Float = k * LADO
			cvs.DrawLine(0, y0, W, y0 + mm * W, C_REJILLA, 1dip)
		Next
	Next
End Sub

#End Region

#Region Pintura

Private Sub Pintar
	If Not(vistaLista) Then Return

	'Si el contenedor cambio de tamano desde el ultimo repintado, primero se
	'sincroniza. enSincronia corta la recursion: SincronizarLienzo llama a
	'Pintar y sin la bandera se llamarian mutuamente sin fin.
	If Not(enSincronia) Then
		If Not(MismoTamano(pnl.Width, mBase.Width)) Or _
		   Not(MismoTamano(pnl.Height, mBase.Height)) Then
			SincronizarLienzo
			Return
		End If
	End If
	If pnl.Width <= 0 Or pnl.Height <= 0 Then Return

	'ClearRect deja el lienzo transparente y el bitmap del canvas sustituye al
	'Color del panel, asi que el papel va como primer trazo.
	cvs.ClearRect(cvs.TargetRect)
	cvs.DrawRect(cvs.TargetRect, C_PAPEL, True, 0)
	If verRejilla Then PintarRejilla

	For Each t As ASDTrazo In trazos
		PintarTrazo(t)
	Next

	If libre.IsInitialized Then Polilinea(libre.Pts, libre.Color, libre.Grosor)

	'Recta por arrastre en curso
	If arrastreIni.IsInitialized And cursor.IsInitialized Then
		LineaPunteada(arrastreIni, cursor, C_GUIA, 2dip)
		Rotulo(arrastreIni, cursor, C_GUIA)
	End If

	'Cadena toque a toque
	If cadena.IsInitialized Then
		Polilinea(cadena.Pts, cadena.Color, cadena.Grosor)
		If ancla.IsInitialized And cursor.IsInitialized Then
			LineaPunteada(ancla, cursor, C_GUIA, 2dip)
			Rotulo(ancla, cursor, C_GUIA)
		End If
		For Each v As ASDPunto In cadena.Pts
			cvs.DrawCircle(v.X, v.Y, 3.5dip, cadena.Color, True, 0)
		Next
		If ancla.IsInitialized Then
			cvs.DrawCircle(ancla.X, ancla.Y, 6dip, C_GUIA, False, 2dip)
		End If
	End If

	If cotaTmp.IsInitialized And cursor.IsInitialized Then
		LineaPunteada(cotaTmp, cursor, C_GUIA, 1.6dip)
		MarcasCota(cotaTmp, cursor, C_GUIA)
		Rotulo(cotaTmp, cursor, C_GUIA)
	End If

	'Mira sobre el nodo: sin ella el dedo tapa el punto y no se sabe donde caera
	If cursor.IsInitialized And UsaNodos And Not(libre.IsInitialized) Then
		cvs.DrawCircle(cursor.X, cursor.Y, 7dip, C_ACTIVO, False, 1.5dip)
		cvs.DrawLine(cursor.X - 11dip, cursor.Y, cursor.X - 3dip, cursor.Y, C_ACTIVO, 1.5dip)
		cvs.DrawLine(cursor.X + 3dip,  cursor.Y, cursor.X + 11dip, cursor.Y, C_ACTIVO, 1.5dip)
		cvs.DrawLine(cursor.X, cursor.Y - 11dip, cursor.X, cursor.Y - 3dip, C_ACTIVO, 1.5dip)
		cvs.DrawLine(cursor.X, cursor.Y + 3dip,  cursor.X, cursor.Y + 11dip, C_ACTIVO, 1.5dip)
	End If

	cvs.Invalidate
End Sub

Private Sub PintarTrazo (t As ASDTrazo)
	If t.Tipo = "cota" Then
		Dim a As ASDPunto = t.Pts.Get(0)
		Dim b As ASDPunto = t.Pts.Get(1)
		LineaPunteada(a, b, t.Color, 1.6dip)
		MarcasCota(a, b, t.Color)
		Rotulo(a, b, t.Color)
	Else
		Polilinea(t.Pts, t.Color, t.Grosor)
		If t.Tipo = "poli" Then
			For i = 0 To t.Pts.Size - 2
				Rotulo(t.Pts.Get(i), t.Pts.Get(i+1), C_ROTULO)
			Next
		End If
	End If
End Sub

Private Sub Polilinea (pts As List, color As Int, gr As Float)
	If pts.Size = 1 Then
		Dim p As ASDPunto = pts.Get(0)
		cvs.DrawCircle(p.X, p.Y, gr/2, color, True, 0)
		Return
	End If
	For i = 0 To pts.Size - 2
		Dim a As ASDPunto = pts.Get(i)
		Dim b As ASDPunto = pts.Get(i+1)
		cvs.DrawLine(a.X, a.Y, b.X, b.Y, color, gr)
		cvs.DrawCircle(b.X, b.Y, gr/2, color, True, 0)   'junta redondeada
	Next
End Sub

'B4XCanvas no tiene patron de guiones: el punteado se compone por tramos.
Private Sub LineaPunteada (a As ASDPunto, b As ASDPunto, color As Int, gr As Float)
	Dim dx As Float = b.X - a.X
	Dim dy As Float = b.Y - a.Y
	Dim largo As Float = Sqrt(dx*dx + dy*dy)
	If largo < 1 Then Return
	Dim ex As Float = dx / largo
	Dim ey As Float = dy / largo
	Dim tramo As Float = 7dip
	Dim hueco As Float = 5dip
	Dim t As Float = 0
	Do While t < largo
		Dim t2 As Float = Min(t + tramo, largo)
		cvs.DrawLine(a.X + ex*t, a.Y + ey*t, a.X + ex*t2, a.Y + ey*t2, color, gr)
		t = t2 + hueco
	Loop
End Sub

Private Sub MarcasCota (a As ASDPunto, b As ASDPunto, color As Int)
	Dim ang As Float = ATan2(b.Y - a.Y, b.X - a.X) + cPI / 2
	Dim cx As Float = Cos(ang) * 6dip
	Dim cy As Float = Sin(ang) * 6dip
	cvs.DrawLine(a.X + cx, a.Y + cy, a.X - cx, a.Y - cy, color, 1.6dip)
	cvs.DrawLine(b.X + cx, b.Y + cy, b.X - cx, b.Y - cy, color, 1.6dip)
End Sub

Private Sub Rotulo (a As ASDPunto, b As ASDPunto, color As Int)
	If Not(verRotulos) Then Return
	Dim largoPx As Float = Sqrt(Power(b.X-a.X,2) + Power(b.Y-a.Y,2))
	If largoPx < 8dip Then Return

	Dim mts As Float
	If conIman Then
		mts = Round(largoPx / LADO) * escalaM
	Else
		mts = largoPx / LADO * escalaM
	End If
	Dim txt As String = NumberFormat2(mts, 1, 2, 0, False) & " m"

	Dim mx As Float = (a.X + b.X) / 2
	Dim my As Float = (a.Y + b.Y) / 2
	Dim r As B4XRect = cvs.MeasureText(txt, fntCota)
	Dim fondo As B4XRect
	fondo.Initialize(mx - r.Width/2 - 4dip, my - 20dip, mx + r.Width/2 + 4dip, my - 4dip)
	cvs.DrawRect(fondo, C_PAPEL, True, 0)
	cvs.DrawText(txt, mx, my - 7dip, fntCota, color, "CENTER")
End Sub

#End Region

#Region Toque

Private Sub pnl_Touch (Action As Int, X As Float, Y As Float)
	If Not(habilitado) Then Return
	If xui.SubExists(mCallBack, mEventName & "_Touch", 2) Then
		CallSub3(mCallBack, mEventName & "_Touch", Action, CreateMap("X": X, "Y": Y))
	End If

	Select Action
		Case pnl.TOUCH_ACTION_DOWN
			bajadoX = X : bajadoY = Y
			movido = False
			Select modo
				Case "borrar"
					BorrarEn(Pt(X, Y))
				Case "libre"
					libre = NuevoTrazo("libre")
					libre.Pts.Add(Pt(X, Y))
					Pintar
				Case "linea"
					arrastreIni = Imantar(Pt(X, Y))
					cursor = arrastreIni
					Pintar
			End Select
			
		Case pnl.TOUCH_ACTION_MOVE
			If Sqrt(Power(X-bajadoX,2) + Power(Y-bajadoY,2)) > UMBRAL Then movido = True
			If libre.IsInitialized Then
				libre.Pts.Add(Pt(X, Y))
				Pintar
				Return
			End If
			If UsaNodos Then
				cursor = Imantar(Pt(X, Y))
				Pintar
			End If

		Case pnl.TOUCH_ACTION_UP
			If libre.IsInitialized Then
				CerrarLibre
				Return
			End If
			If modo = "borrar" Then Return
			If modo = "linea" Then
				CerrarArrastre(Imantar(Pt(X, Y)))
				Return
			End If
			If Not(movido) Then ToqueLimpio(Imantar(Pt(X, Y)), X, Y)
	End Select
End Sub

'Recta de un solo segmento: se dibuja arrastrando, como el lapiz, pero sale
'recta y pegada a la reticula.
Private Sub CerrarArrastre (fin As ASDPunto)
	If arrastreIni.IsInitialized Then
		If Dist(arrastreIni, fin) > UMBRAL Then
			Dim t As ASDTrazo = NuevoTrazo("poli")
			t.Pts.Add(arrastreIni)
			t.Pts.Add(fin)
			trazos.Add(t)
			Guardar
		End If
	End If
	Dim vacio As ASDPunto
	arrastreIni = vacio
	Pintar
	Avisar
End Sub

'Un toque sin arrastre fija un vertice. El umbral existe porque en pantalla
'tactil el dedo siempre derrapa unos pixeles.
Private Sub ToqueLimpio (n As ASDPunto, crudoX As Float, crudoY As Float)
	Dim ahora As Long = DateTime.Now
	Dim esDoble As Boolean = (ahora - ultimoToqueMs) < VENTANA_DOBLE _
		And Abs(crudoX - ultimoToqueX) < 24dip And Abs(crudoY - ultimoToqueY) < 24dip
	ultimoToqueMs = ahora
	ultimoToqueX = crudoX : ultimoToqueY = crudoY
	
	If esDoble And cadena.IsInitialized Then
		TerminarCadena(False)
		Return
	End If

	If modo = "cota" Then
		If Not(cotaTmp.IsInitialized) Then
			cotaTmp = n
		Else
			If Dist(cotaTmp, n) > UMBRAL Then
				Dim c As ASDTrazo = NuevoTrazo("cota")
				c.Color = C_COTA
				c.Pts.Add(cotaTmp)
				c.Pts.Add(n)
				trazos.Add(c)
				Guardar
			End If
			Dim vacio As ASDPunto
			cotaTmp = vacio
		End If
	Else
		If Not(cadena.IsInitialized) Then
			cadena = NuevoTrazo("poli")
			cadena.Pts.Add(n)
		Else
			Dim u As ASDPunto = cadena.Pts.Get(cadena.Pts.Size - 1)
			If Dist(u, n) < UMBRAL Then
				TerminarCadena(False)
				Return
			End If
			cadena.Pts.Add(n)
		End If
		ancla = cadena.Pts.Get(cadena.Pts.Size - 1)
	End If
	cursor = n
	Pintar
	Avisar
End Sub

Private Sub CerrarLibre
	If libre.IsInitialized Then
		If libre.Pts.Size > 2 Then
			trazos.Add(libre)
			Guardar
		End If
		Dim vacio As ASDTrazo
		libre = vacio
	End If
	Pintar
	Avisar
End Sub

Private Sub BorrarEn (p As ASDPunto)
	Dim idx As Int = -1
	Dim mejor As Float = 16dip
	For i = 0 To trazos.Size - 1
		Dim t As ASDTrazo = trazos.Get(i)
		Dim d As Float = DistATrazo(t, p)
		If d < mejor Then
			mejor = d
			idx = i
		End If
	Next
	If idx >= 0 Then
		trazos.RemoveAt(idx)
		Guardar
		Pintar
		Avisar
	End If
End Sub

#End Region

#Region Historial

'Instantaneas de la lista. Los trazos confirmados nunca se mutan, asi que la
'copia superficial alcanza. La excepcion deliberada es Reescalar, que si los
'muta: eso es correcto porque el historial debe quedar en la misma escala que
'el dibujo, o deshacer devolveria el croquis al tamano anterior.
Private Sub Guardar
	Do While hist.Size > hIdx + 1
		hist.RemoveAt(hist.Size - 1)
	Loop
	hist.Add(CopiaLista(trazos))
	hIdx = hist.Size - 1
End Sub

Private Sub CopiaLista (origen As List) As List
	Dim c As List
	c.Initialize
	For Each o As Object In origen
		c.Add(o)
	Next
	Return c
End Sub

'Deshacer a mitad de una figura quita el ultimo vertice, no confirma la figura.
Public Sub Undo
	If cadena.IsInitialized Then
		cadena.Pts.RemoveAt(cadena.Pts.Size - 1)
		If cadena.Pts.Size = 0 Then
			Dim vt As ASDTrazo : cadena = vt
			Dim vp As ASDPunto : ancla = vp
		Else
			ancla = cadena.Pts.Get(cadena.Pts.Size - 1)
		End If
		Pintar
		Avisar
		Return
	End If
	If cotaTmp.IsInitialized Then
		Dim vp2 As ASDPunto : cotaTmp = vp2
		Pintar
		Avisar
		Return
	End If
	If hIdx > 0 Then
		hIdx = hIdx - 1
		trazos = CopiaLista(hist.Get(hIdx))
		Pintar
		Avisar
	End If
End Sub

Public Sub Redo
	If hIdx < hist.Size - 1 Then
		hIdx = hIdx + 1
		trazos = CopiaLista(hist.Get(hIdx))
		Pintar
		Avisar
	End If
End Sub

Public Sub getPuedeUndo As Boolean
	Return hIdx > 0 Or cadena.IsInitialized Or cotaTmp.IsInitialized
End Sub

Public Sub getPuedeRedo As Boolean
	Return hIdx < hist.Size - 1
End Sub

Public Sub Limpiar
	Cancelar
	If trazos.Size = 0 Then
		Pintar
		Return
	End If
	trazos.Initialize
	Guardar
	Pintar
	Avisar
End Sub

'Descarta lo que este a medio dibujar sin confirmarlo.
Public Sub Cancelar
	Dim vt As ASDTrazo : cadena = vt : libre = vt
	Dim vp As ASDPunto : ancla = vp : cotaTmp = vp : arrastreIni = vp : cursor = vp
	movido = False
	Pintar
	Avisar
End Sub

#End Region

#Region API publica
'
'CONVENIO DE EVENTOS
'El evento Cambio se emite solo cuando el croquis cambia por accion del usuario
'sobre el lienzo. Los setters NO lo emiten, porque quien los llama ya sabe que
'cambio el estado y se refresca solo.

Public Sub TerminarCadena (cerrar As Boolean)
	If cadena.IsInitialized Then
		If cerrar And cadena.Pts.Size > 2 Then
			Dim p0 As ASDPunto = cadena.Pts.Get(0)
			cadena.Pts.Add(Pt(p0.X, p0.Y))
		End If
		If cadena.Pts.Size > 1 Then
			trazos.Add(cadena)
			Guardar
		End If
	End If
	Dim vt As ASDTrazo : cadena = vt
	Dim vp As ASDPunto : ancla = vp : cotaTmp = vp : cursor = vp
	Pintar
	Avisar
End Sub

Public Sub getEnCadena As Boolean
	Return cadena.IsInitialized And cadena.Pts.Size > 1
End Sub

Public Sub getPuedeCerrar As Boolean
	Return cadena.IsInitialized And cadena.Pts.Size > 2
End Sub

Public Sub getCotaPendiente As Boolean
	Return cotaTmp.IsInitialized
End Sub

'modo: puntos | linea | libre | cota | borrar
Public Sub setModo (m As String)
	TerminarCadena(False)
	Dim vp As ASDPunto : cursor = vp : arrastreIni = vp
	movido = False
	modo = m
	Pintar
End Sub

Public Sub getModo As String
	Return modo
End Sub

Public Sub setEnable (b As Boolean)
	habilitado = b
End Sub

Public Sub getEnable As Boolean
	Return habilitado
End Sub

Public Sub getBase As B4XView
	Return mBase
End Sub

'Tamano real del lienzo. Si no coincide con el de la base hay desfase.
Public Sub getLienzoWidth As Float
	If Not(vistaLista) Then Return 0
	Return pnl.Width
End Sub

Public Sub getLienzoHeight As Float
	If Not(vistaLista) Then Return 0
	Return pnl.Height
End Sub

'Motivo del ultimo fallo de ImportarJSON. Vacio si no hubo error o si la
'ultima importacion fue correcta. La pagina lo usa para avisar al usuario.
Public Sub getUltimoError As String
	Return ultimoError
End Sub

'Visibilidad de la reticula. Independiente del iman.
Public Sub setRejilla (b As Boolean)
	verRejilla = b
	Pintar
End Sub

Public Sub getRejilla As Boolean
	Return verRejilla
End Sub

Public Sub setIman (b As Boolean)
	conIman = b
End Sub

Public Sub getIman As Boolean
	Return conIman
End Sub

'Rotulos de medida. Se apagan para entregar un croquis limpio al cliente.
Public Sub setRotulos (b As Boolean)
	verRotulos = b
	Pintar
End Sub

Public Sub getRotulos As Boolean
	Return verRotulos
End Sub

Public Sub setEscala (m As Float)
	If m > 0 Then escalaM = m
	Pintar
End Sub

Public Sub getEscala As Float
	Return escalaM
End Sub

'Lapiz activo. Solo afecta a los trazos nuevos.
Public Sub setColorLapiz (c As Int)
	colorLapiz = c
End Sub

Public Sub getColorLapiz As Int
	Return colorLapiz
End Sub

Public Sub setGrosorLapiz (g As Float)
	If g > 0 Then grosorLapiz = g
End Sub

Public Sub getGrosorLapiz As Float
	Return grosorLapiz
End Sub

Public Sub setTamCelda (px As Float)
	If px < 8dip Then Return
	LADO = px
	CalcularBase
	Pintar
End Sub

Public Sub getTamCelda As Float
	Return LADO
End Sub

Public Sub getCantidadTrazos As Int
	If trazos.IsInitialized = False Then Return 0
	Return trazos.Size
End Sub

Public Sub getVacio As Boolean
	Return getCantidadTrazos = 0
End Sub

'Imagen del croquis. conRejilla = False entrega papel limpio.
'No es el formato de trabajo: solo se invoca para el PDF de la cotizacion o
'para adjuntar la imagen. El formato persistente es el JSON.
Public Sub Exportar (conRejilla As Boolean) As B4XBitmap
	TerminarCadena(False)
	Dim previoR As Boolean = verRejilla
	verRejilla = conRejilla
	Pintar
	Dim bmp As B4XBitmap = cvs.CreateBitmap
	If previoR <> conRejilla Then
		verRejilla = previoR
		Pintar
	End If
	Return bmp
End Sub

'PNG o JPEG comprimido (RF-004 / RNF-010). Se genera en el dispositivo que
'dibujo, garantizando que la imagen sea identica al croquis original.
Public Sub ExportarBytes (formatoImagen As String, conRejilla As Boolean, calidad As Int) As Byte()
	Dim bmp As B4XBitmap = Exportar(conRejilla)
	Dim out As OutputStream
	out.InitializeToBytesArray(0)
	bmp.WriteToStream(out, calidad, formatoImagen.ToUpperCase)
	out.Close
	Return out.ToBytesArray
End Sub

Public Sub ExportarPNGBytes (conRejilla As Boolean, calidad As Int) As Byte()
	Return ExportarBytes("PNG", conRejilla, calidad)
End Sub

'FORMATO DE TRABAJO. Serializacion vectorial: pesa kilobytes en vez de cientos
'y permite reeditar. Es lo que se guarda en SQLite y lo que se sincroniza.
Public Sub ExportarJSON As String
	TerminarCadena(False)
	Dim q As String = Chr(34)
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append("{").Append(q).Append("version").Append(q).Append(":2,")
	sb.Append(q).Append("unidad_celda_m").Append(q).Append(":").Append(escalaM).Append(",")
	sb.Append(q).Append("arista_px").Append(q).Append(":").Append(Round(LADO)).Append(",")
	sb.Append(q).Append("trazos").Append(q).Append(":[")
	For i = 0 To trazos.Size - 1
		Dim t As ASDTrazo = trazos.Get(i)
		If i > 0 Then sb.Append(",")
		sb.Append("{").Append(q).Append("tipo").Append(q).Append(":").Append(q).Append(t.Tipo).Append(q)
		sb.Append(",").Append(q).Append("color").Append(q).Append(":").Append(t.Color)
		sb.Append(",").Append(q).Append("grosor").Append(q).Append(":").Append(NumberFormat2(t.Grosor, 1, 1, 0, False))
		If t.Tipo = "cota" Then
			Dim celdas As Int = Round(Dist(t.Pts.Get(0), t.Pts.Get(1)) / LADO)
			sb.Append(",").Append(q).Append("metros").Append(q).Append(":")
			sb.Append(NumberFormat2(celdas * escalaM, 1, 2, 0, False))
		End If
		sb.Append(",").Append(q).Append("puntos").Append(q).Append(":[")
		For k = 0 To t.Pts.Size - 1
			Dim p As ASDPunto = t.Pts.Get(k)
			If k > 0 Then sb.Append(",")
			sb.Append("[").Append(Round(p.X)).Append(",").Append(Round(p.Y)).Append("]")
		Next
		sb.Append("]}")
	Next
	sb.Append("]}")
	Return sb.ToString
End Sub

'Reconstruye el croquis desde su JSON. Los puntos se reescalan si la arista de
'celda cambio respecto de la que tenia el dispositivo que lo dibujo.
'Devuelve False tanto si no habia croquis (texto vacio) como si el JSON esta
'danado. UltimoError distingue los dos casos: vacio en el primero, con el
'motivo en el segundo.
Public Sub ImportarJSON (value As String) As Boolean
	ultimoError = ""
	If value = "" Then Return False
	Try
		Dim jp As JSONParser
		jp.Initialize(value)
		Dim raiz As Map = jp.NextObject

		Dim aristaOrigen As Float = LADO
		If raiz.ContainsKey("arista_px") Then aristaOrigen = raiz.Get("arista_px")
		If aristaOrigen <= 0 Then aristaOrigen = LADO
		Dim factor As Float = LADO / aristaOrigen

		If raiz.ContainsKey("unidad_celda_m") Then escalaM = raiz.Get("unidad_celda_m")

		Dim nuevos As List
		nuevos.Initialize
		Dim lst As List = raiz.Get("trazos")
		For Each mt As Map In lst
			Dim t As ASDTrazo
			t.Initialize
			t.Tipo = mt.Get("tipo")
			t.Pts.Initialize
			If mt.ContainsKey("color") Then
				t.Color = mt.Get("color")
			Else
				t.Color = colorLapiz
			End If
			If mt.ContainsKey("grosor") Then
				t.Grosor = mt.Get("grosor")
			Else
				t.Grosor = grosorLapiz
			End If
			Dim pts As List = mt.Get("puntos")
			For Each par As List In pts
				t.Pts.Add(Pt(par.Get(0) * factor, par.Get(1) * factor))
			Next
			If t.Pts.Size > 0 Then nuevos.Add(t)
		Next

		Cancelar
		trazos = nuevos
		Guardar
		Pintar
		Avisar
		Return True
	Catch
		'Unico punto donde el diagnostico hace falta: un croquis que no carga
		'no deja rastro de por que. El texto queda en UltimoError para que la
		'pagina decida como avisar al usuario.
		ultimoError = LastException.Message
		Log("ASDrawIso.ImportarJSON: " & ultimoError)
		Return False
	End Try
End Sub

'Perimetro y area de lo dibujado, en unidades reales. El resultado no cambia al
'redimensionar: los pixeles se reescalan pero LADO acompana, asi que la razon
'escalaM/LADO se mantiene.
Public Sub getResumen As Map
	Dim aMetros As Float = escalaM / LADO
	Dim perim As Float = 0
	Dim area As Float = 0
	Dim segs As Int = 0
	Dim cerradas As Int = 0

	For Each t As ASDTrazo In trazos
		If t.Tipo = "cota" Then Continue
		For i = 0 To t.Pts.Size - 2
			perim = perim + Dist(t.Pts.Get(i), t.Pts.Get(i+1))
			segs = segs + 1
		Next
		If t.Tipo = "poli" And t.Pts.Size > 3 Then
			Dim p0 As ASDPunto = t.Pts.Get(0)
			Dim pn As ASDPunto = t.Pts.Get(t.Pts.Size - 1)
			If Dist(p0, pn) < 1 Then
				cerradas = cerradas + 1
				Dim suma As Float = 0
				For i = 0 To t.Pts.Size - 2
					Dim a As ASDPunto = t.Pts.Get(i)
					Dim b As ASDPunto = t.Pts.Get(i+1)
					suma = suma + (a.X * b.Y - b.X * a.Y)
				Next
				area = area + Abs(suma) / 2
			End If
		End If
	Next

	Return CreateMap( _
		"perimetro_m": Round2(perim * aMetros, 2), _
		"area_m2": Round2(area * aMetros * aMetros, 2), _
		"segmentos": segs, _
		"figuras_cerradas": cerradas)
End Sub

#End Region

#Region Utilidades

Private Sub NuevoTrazo (tipo As String) As ASDTrazo
	Dim t As ASDTrazo
	t.Initialize
	t.Tipo = tipo
	t.Pts.Initialize
	t.Color = colorLapiz
	t.Grosor = grosorLapiz
	Return t
End Sub

Private Sub Pt (x As Float, y As Float) As ASDPunto
	Dim p As ASDPunto
	p.Initialize
	p.X = x
	p.Y = y
	Return p
End Sub

Private Sub Dist (a As ASDPunto, b As ASDPunto) As Float
	Return Sqrt(Power(b.X-a.X, 2) + Power(b.Y-a.Y, 2))
End Sub

Private Sub DistATrazo (t As ASDTrazo, p As ASDPunto) As Float
	If t.Pts.Size = 1 Then Return Dist(t.Pts.Get(0), p)
	Dim d As Float = 999999
	For i = 0 To t.Pts.Size - 2
		Dim a As ASDPunto = t.Pts.Get(i)
		Dim b As ASDPunto = t.Pts.Get(i+1)
		Dim sx As Float = b.X - a.X
		Dim sy As Float = b.Y - a.Y
		Dim l2 As Float = sx*sx + sy*sy
		If l2 = 0 Then l2 = 1
		Dim u As Float = ((p.X-a.X)*sx + (p.Y-a.Y)*sy) / l2
		u = Max(0, Min(1, u))
		Dim dd As Float = Sqrt(Power(p.X-(a.X+sx*u),2) + Power(p.Y-(a.Y+sy*u),2))
		If dd < d Then d = dd
	Next
	Return d
End Sub

'Modos que trabajan sobre nodos de la reticula y muestran la mira.
Private Sub UsaNodos As Boolean
	Return modo = "puntos" Or modo = "cota" Or modo = "linea"
End Sub

'El evento Cambio solo se emite cuando la vista ya esta construida.
Private Sub Avisar
	If Not(vistaLista) Then Return
	If xui.SubExists(mCallBack, mEventName & "_Cambio", 0) Then
		CallSub(mCallBack, mEventName & "_Cambio")
	End If
End Sub

#End Region