B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
B4A=True

'Name: ASDrawIso
'Version: 4.0
'Lienzo de croquis para el sistema de cotizaciones de Anovo (TFG UNED IS-2026).
'
'ARQUITECTURA
'El dibujo no se acumula en un bitmap sino que vive como lista de trazos
'vectoriales y se repinta completo. Eso habilita borrar un trazo suelto,
'rotular cotas y serializar el croquis.
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
'LAS COTAS NO SE CALCULAN
'La medida la escribe el asesor: el croquis de campo casi nunca esta a escala.
'Cada lado de una figura, cada circulo y cada arco quedan marcados con su letra
'(A, B, C...) sin pedir nada; al tocarla, la pagina pide su valor con el evento
'Medida. La letra liga la cota con su fila de la tabla de medidas.
'
'Changelog
'V4.0
'  -Cotas con letra, tipo, valor, unidad y cantidad escritos por el asesor
'  -Cota de diametro o radio sobre circulos y arcos, y cota de angulo
'  -Herramientas Circulo, Arco y Texto; marca de hueco en circulos y figuras cerradas
'  -Rejilla isometrica o cuadrada
'  -Herramienta Agujero: un toque deja el hueco en el plano de la cara y pide su diametro
'  -Con rejilla isometrica el circulo se dibuja como elipse en la cara donde cae
'  -Cada lado de una figura, cada circulo y cada arco salen con su letra pendiente
'  -La letra se toca con cualquier herramienta, salvo Borrar y Lapiz
'  -JSON version 3; los croquis de la version 2 se siguen leyendo
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
#DesignerProperty: Key: Modo, DisplayName: Modo, FieldType: String, DefaultValue: puntos, List: puntos|linea|libre|cota|angulo|circulo|agujero|arco|texto|hueco|borrar

#DesignerProperty: Key: StrokeWidth, DisplayName: Stroke Width, FieldType: Float, DefaultValue: 3
#DesignerProperty: Key: StrokeColor, DisplayName: Stroke Color, FieldType: Color, DefaultValue: 0xFF14181D
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0xFFFDFDFB

#DesignerProperty: Key: GridVisible, DisplayName: Grid Visible, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: GridType, DisplayName: Grid Type, FieldType: String, DefaultValue: iso, List: iso|cuadrada
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
#Event: Medida (Id As Int)
#Event: Texto (Id As Int)

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
	Type ASDTrazo (Id As Int, Tipo As String, Pts As List, Color As Int, Grosor As Float, _
		Hueco As Boolean, Texto As String, Forma As String, Etiqueta As String, _
		Medida As String, Valor As Double, Unidad As String, Cantidad As Int, Ref As Int, _
		Plano As String, Lado As Int)

	Private trazos As List
	Private hist As List
	Private hIdx As Int = 0
	Private siguienteId As Int = 1

	'--- estado de interaccion ---
	Private modo As String = "puntos"
	Private verRejilla As Boolean = True
	Private tipoRejilla As String = "iso"
	Private conIman As Boolean = True
	Private verRotulos As Boolean = True
	Private escalaM As Float = 0.5
	Private planoForzado As String = ""
	Private planoUltimo As String = "superior"

	Private cadena As ASDTrazo           'polilinea toque a toque en construccion
	Private ancla As ASDPunto            'ultimo vertice fijado de la cadena
	Private cursor As ASDPunto           'punto imantado bajo el dedo
	Private libre As ASDTrazo            'trazo a mano alzada en curso
	Private cotaTmp As ASDPunto          'primer punto de una cota
	Private arrastreIni As ASDPunto      'origen de la recta por arrastre
	Private centroTmp As ASDPunto
	Private arcoTmp As List
	Private anguloTmp As List
	Private textoTmp As ASDPunto

	Private bajadoX, bajadoY As Float
	Private sobreRotulo As Boolean
	Private movido As Boolean
	Private UMBRAL As Float
	Private TOQUE As Float
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
	Private fntTexto As B4XFont
	Private habilitado As Boolean = True

	Private vistaLista As Boolean = False
	Private enSincronia As Boolean = False   'evita recursion Pintar <-> Sincronizar
	Private C_PAPEL, C_REJILLA, C_GUIA, C_ACTIVO, C_COTA As Int

	'Motivo del ultimo fallo de ImportarJSON. Vacio si la ultima importacion
	'salio bien. Lo lee la pagina para avisar al usuario.
	Private ultimoError As String = ""

	Private Const VERSION_JSON As Int = 3
	Private Const PASOS_ARCO As Int = 32
	Private Const LETRAS As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	Private Const ALFA_HUECO As Int = 0x30000000
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
		arcoTmp.Initialize
		anguloTmp.Initialize
	End If
	UMBRAL = 6dip
	TOQUE = 16dip
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
	tipoRejilla = Props.GetDefault("GridType", "iso")
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
	fntTexto    = xui.CreateDefaultFont(Props.Get("LabelTextSize") + 2)
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
		"GridType": "iso", _
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
'factores distintos rompe los 60 grados.
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
	'que ya queda reescalado. Solo falta lo que esta en construccion. El ancla y
	'el cursor pueden ser el mismo objeto que un vertice de la cadena: se
	'reconstruyen en vez de escalarlos otra vez.
	If cadena.IsInitialized Then
		EscalarPuntos(cadena.Pts, f)
		If cadena.Pts.Size > 0 Then ancla = cadena.Pts.Get(cadena.Pts.Size - 1)
	End If
	If libre.IsInitialized Then EscalarPuntos(libre.Pts, f)
	EscalarPuntos(arcoTmp, f)
	EscalarPuntos(anguloTmp, f)
	cotaTmp = EscalarSuelto(cotaTmp, f)
	arrastreIni = EscalarSuelto(arrastreIni, f)
	centroTmp = EscalarSuelto(centroTmp, f)
	textoTmp = EscalarSuelto(textoTmp, f)
	Dim vp As ASDPunto : cursor = vp

	'La arista de la reticula acompana al dibujo: si no, los trazos dejarian de
	'caer sobre los nodos y el iman corregiria hacia puntos erroneos.
	LADO = LADO * f
	CalcularBase
End Sub

Private Sub EscalarSuelto (p As ASDPunto, f As Float) As ASDPunto
	If p.IsInitialized = False Then Return p
	Return Pt(p.X * f, p.Y * f)
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

'Nodo mas cercano. En la isometrica, por regla de Cramer sobre los dos
'vectores base; en la cuadrada, redondeo por eje.
Private Sub Imantar (p As ASDPunto) As ASDPunto
	If Not(conIman) Then Return p
	If tipoRejilla = "cuadrada" Then
		Return Pt(Round(p.X / LADO) * LADO, Round(p.Y / LADO) * LADO)
	End If
	Dim i As Int = Round(( p.X * VY - p.Y * VX) / DET)
	Dim j As Int = Round((-p.X * UY + p.Y * UX) / DET)
	Return Pt(i * UX + j * VX, i * UY + j * VY)
End Sub

Private Sub PintarRejilla
	If tipoRejilla = "cuadrada" Then
		PintarRejillaCuadrada
	Else
		PintarRejillaIso
	End If
End Sub

Private Sub PintarRejillaCuadrada
	If LADO < 1 Then Return
	Dim W As Float = pnl.Width
	Dim H As Float = pnl.Height
	For k = 0 To Ceil(W / LADO)
		cvs.DrawLine(k * LADO, 0, k * LADO, H, C_REJILLA, 1dip)
	Next
	For k = 0 To Ceil(H / LADO)
		cvs.DrawLine(0, k * LADO, W, k * LADO, C_REJILLA, 1dip)
	Next
End Sub

Private Sub PintarRejillaIso
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
		If t.Tipo <> "cota" Then PintarTrazo(t)
	Next
	For Each t As ASDTrazo In trazos
		If t.Tipo = "cota" Then PintarCota(t)
	Next

	If libre.IsInitialized Then Polilinea(libre.Pts, libre.Color, libre.Grosor)
	PintarPendientes

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

Private Sub PintarPendientes
	If arrastreIni.IsInitialized And cursor.IsInitialized Then
		LineaPunteada(arrastreIni, cursor, C_GUIA, 2dip)
	End If

	If cadena.IsInitialized Then
		Polilinea(cadena.Pts, cadena.Color, cadena.Grosor)
		If ancla.IsInitialized And cursor.IsInitialized Then
			LineaPunteada(ancla, cursor, C_GUIA, 2dip)
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
	End If

	If centroTmp.IsInitialized And cursor.IsInitialized Then
		Dim r0 As Float = Dist(centroTmp, cursor)
		If r0 > UMBRAL Then Polilinea(PuntosElipse(centroTmp, r0, PlanoEn(centroTmp)), C_GUIA, 1.6dip)
		cvs.DrawCircle(centroTmp.X, centroTmp.Y, 2.5dip, C_GUIA, True, 0)
	End If

	If arcoTmp.Size > 0 And cursor.IsInitialized Then
		If arcoTmp.Size = 1 Then
			LineaPunteada(arcoTmp.Get(0), cursor, C_GUIA, 1.6dip)
		Else
			Polilinea(PuntosArco(arcoTmp.Get(0), arcoTmp.Get(1), cursor), C_GUIA, 1.6dip)
		End If
	End If
	For Each v As ASDPunto In arcoTmp
		cvs.DrawCircle(v.X, v.Y, 3.5dip, C_GUIA, True, 0)
	Next

	If anguloTmp.Size > 0 And cursor.IsInitialized Then
		Dim vert As ASDPunto = anguloTmp.Get(0)
		If anguloTmp.Size = 1 Then
			LineaPunteada(vert, cursor, C_GUIA, 1.6dip)
		Else
			LineaPunteada(vert, anguloTmp.Get(1), C_GUIA, 1.6dip)
			LineaPunteada(vert, cursor, C_GUIA, 1.6dip)
			Polilinea(PuntosAngulo(vert, anguloTmp.Get(1), cursor), C_GUIA, 1.6dip)
		End If
	End If
	For Each v As ASDPunto In anguloTmp
		cvs.DrawCircle(v.X, v.Y, 3.5dip, C_GUIA, True, 0)
	Next
End Sub

Private Sub PintarTrazo (t As ASDTrazo)
	Select t.Tipo
		Case "circulo"
			Dim c As ASDPunto = t.Pts.Get(0)
			Dim r As Float = Dist(c, t.Pts.Get(1))
			Dim contorno As List = PuntosElipse(c, r, t.Plano)
			If t.Hueco Then
				Rayado(RutaPoligono(contorno), Limites(contorno), t.Color)
				CruzCentro(c, r, t.Plano, t.Color)
			End If
			Polilinea(contorno, t.Color, t.Grosor)
		Case "arco"
			Polilinea(PuntosArco(t.Pts.Get(0), t.Pts.Get(1), t.Pts.Get(2)), t.Color, t.Grosor)
		Case "texto"
			Dim p As ASDPunto = t.Pts.Get(0)
			Caja(t.Texto, fntTexto, p.X, p.Y, t.Color, 0, False)
		Case Else
			If t.Hueco And Cerrada(t) Then
				Dim ruta2 As B4XPath = RutaPoligono(t.Pts)
				Rayado(ruta2, Limites(t.Pts), t.Color)
			End If
			Polilinea(t.Pts, t.Color, t.Grosor)
	End Select
End Sub

Private Sub PintarCota (t As ASDTrazo)
	Dim color As Int = C_COTA
	If t.Valor <= 0 Then color = C_GUIA
	Select t.Forma
		Case "lado"
			Dim lp0 As ASDPunto = PosRotulo(t)
			If lp0.IsInitialized And verRotulos Then Caja(TextoCota(t), fntCota, lp0.X, lp0.Y, color, 0, True)
		Case "diametro", "radio"
			Dim borde As ASDPunto = t.Pts.Get(0)
			Dim pos As ASDPunto = t.Pts.Get(1)
			Dim fig As ASDTrazo = TrazoPorId(t.Ref)
			If fig.IsInitialized Then
				Dim c As ASDPunto = CentroDe(fig)
				If c.IsInitialized Then
					If t.Forma = "diametro" Then
						cvs.DrawLine(2 * c.X - borde.X, 2 * c.Y - borde.Y, borde.X, borde.Y, color, 1.4dip)
					Else
						cvs.DrawLine(c.X, c.Y, borde.X, borde.Y, color, 1.4dip)
					End If
				End If
			End If
			cvs.DrawLine(borde.X, borde.Y, pos.X, pos.Y, color, 1.4dip)
			cvs.DrawCircle(borde.X, borde.Y, 2.5dip, color, True, 0)
			Dim anclaje As Int = 1
			If pos.X >= borde.X Then anclaje = -1
			If verRotulos Then Caja(TextoCota(t), fntCota, pos.X, pos.Y, color, anclaje, True)
		Case "angulo"
			Dim v As ASDPunto = t.Pts.Get(0)
			cvs.DrawLine(v.X, v.Y, t.Pts.Get(1).As(ASDPunto).X, t.Pts.Get(1).As(ASDPunto).Y, color, 1.2dip)
			cvs.DrawLine(v.X, v.Y, t.Pts.Get(2).As(ASDPunto).X, t.Pts.Get(2).As(ASDPunto).Y, color, 1.2dip)
			Polilinea(PuntosAngulo(v, t.Pts.Get(1), t.Pts.Get(2)), color, 1.6dip)
			Dim lp As ASDPunto = PosRotulo(t)
			If verRotulos Then Caja(TextoCota(t), fntCota, lp.X, lp.Y, color, 0, True)
		Case Else
			Dim a As ASDPunto = t.Pts.Get(0)
			Dim b As ASDPunto = t.Pts.Get(1)
			LineaPunteada(a, b, color, 1.6dip)
			MarcasCota(a, b, color)
			Dim mp As ASDPunto = PosRotulo(t)
			If verRotulos Then Caja(TextoCota(t), fntCota, mp.X, mp.Y, color, 0, True)
	End Select
End Sub

Private Sub TextoCota (t As ASDTrazo) As String
	If t.Valor <= 0 Then Return t.Etiqueta & " ?"
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append(t.Etiqueta).Append(" = ")
	If t.Cantidad > 1 Then sb.Append(t.Cantidad).Append("× ")
	If t.Forma = "diametro" Then sb.Append("Ø ")
	If t.Forma = "radio" Then sb.Append("R ")
	sb.Append(NumberFormat2(t.Valor, 1, 2, 0, False))
	Select t.Unidad
		Case "grados"
			sb.Append("°")
		Case "pulg"
			sb.Append(QUOTE)
		Case Else
			sb.Append(" ").Append(t.Unidad)
	End Select
	Return sb.ToString
End Sub

Private Sub PosRotulo (t As ASDTrazo) As ASDPunto
	Select t.Forma
		Case "lado"
			Dim fig As ASDTrazo = TrazoPorId(t.Ref)
			Dim vacio As ASDPunto
			If fig.IsInitialized = False Then Return vacio
			If t.Lado < 0 Or t.Lado > fig.Pts.Size - 2 Then Return vacio
			Dim pa As ASDPunto = fig.Pts.Get(t.Lado)
			Dim pb As ASDPunto = fig.Pts.Get(t.Lado + 1)
			Dim normal As Float = Angulo(pa, pb) - cPI / 2
			Dim medio As ASDPunto = Pt((pa.X + pb.X) / 2, (pa.Y + pb.Y) / 2)
			Dim sentido As Float = 1
			If Cerrada(fig) And DentroDe(fig, Pt(medio.X + Cos(normal) * 13dip, medio.Y + Sin(normal) * 13dip)) Then sentido = -1
			Dim r As B4XRect = cvs.MeasureText(TextoCota(t), fntCota)
			Dim separacion As Float = 6dip + Abs(Cos(normal)) * (r.Width + 8dip) / 2 + Abs(Sin(normal)) * (r.Height + 6dip) / 2
			Return Pt(medio.X + sentido * Cos(normal) * separacion, medio.Y + sentido * Sin(normal) * separacion)
		Case "diametro", "radio"
			Return t.Pts.Get(1)
		Case "angulo"
			Dim v As ASDPunto = t.Pts.Get(0)
			Dim a1 As Float = Angulo(v, t.Pts.Get(1))
			Dim d As Float = Barrido(a1, Angulo(v, t.Pts.Get(2)))
			Return Pt(v.X + Cos(a1 + d / 2) * 44dip, v.Y + Sin(a1 + d / 2) * 44dip)
		Case Else
			Dim a As ASDPunto = t.Pts.Get(0)
			Dim b As ASDPunto = t.Pts.Get(1)
			Return Pt((a.X + b.X) / 2, (a.Y + b.Y) / 2 - 12dip)
	End Select
End Sub

'anclaje: -1 la caja empieza en x, 0 centrada en x, 1 termina en x.
Private Sub Caja (txt As String, fnt As B4XFont, x As Float, y As Float, color As Int, anclaje As Int, borde As Boolean)
	If txt = "" Then Return
	Dim r As B4XRect = cvs.MeasureText(txt, fnt)
	Dim ancho As Float = r.Width + 8dip
	Dim alto As Float = r.Height + 6dip
	Dim cx As Float = x
	If anclaje = -1 Then cx = x + ancho / 2
	If anclaje = 1 Then cx = x - ancho / 2
	cx = Max(ancho / 2, Min(pnl.Width - ancho / 2, cx))
	Dim cy As Float = Max(alto / 2, Min(pnl.Height - alto / 2, y))
	Dim fondo As B4XRect
	fondo.Initialize(cx - ancho / 2, cy - alto / 2, cx + ancho / 2, cy + alto / 2)
	cvs.DrawRect(fondo, C_PAPEL, True, 0)
	If borde Then cvs.DrawRect(fondo, color, False, 1dip)
	cvs.DrawText(txt, cx, cy - r.CenterY, fnt, color, "CENTER")
End Sub

Private Sub Rayado (ruta As B4XPath, marco As B4XRect, color As Int)
	Dim tenue As Int = Bit.Or(Bit.And(color, 0x00FFFFFF), ALFA_HUECO)
	cvs.DrawPath(ruta, tenue, True, 0)
	cvs.ClipPath(ruta)
	Dim paso As Float = 7dip
	Dim alto As Float = marco.Height
	Dim x As Float = marco.Left - alto
	Do While x < marco.Right
		cvs.DrawLine(x, marco.Bottom, x + alto, marco.Top, color, 1dip)
		x = x + paso
	Loop
	cvs.RemoveClip
End Sub

Private Sub CruzCentro (c As ASDPunto, r As Float, plano As String, color As Int)
	Dim e() As Float = EjesPlano(plano)
	Dim l As Float = r + 4dip
	cvs.DrawLine(c.X - l * e(0), c.Y - l * e(1), c.X + l * e(0), c.Y + l * e(1), color, 1dip)
	cvs.DrawLine(c.X - l * e(2), c.Y - l * e(3), c.X + l * e(2), c.Y + l * e(3), color, 1dip)
End Sub

Private Sub RutaPoligono (pts As List) As B4XPath
	Dim p0 As ASDPunto = pts.Get(0)
	Dim ruta As B4XPath
	ruta.Initialize(p0.X, p0.Y)
	For i = 1 To pts.Size - 1
		Dim p As ASDPunto = pts.Get(i)
		ruta.LineTo(p.X, p.Y)
	Next
	Return ruta
End Sub

Private Sub Limites (pts As List) As B4XRect
	Dim p0 As ASDPunto = pts.Get(0)
	Dim izq As Float = p0.X
	Dim arriba As Float = p0.Y
	Dim der As Float = p0.X
	Dim abajo As Float = p0.Y
	For Each p As ASDPunto In pts
		izq = Min(izq, p.X) : der = Max(der, p.X)
		arriba = Min(arriba, p.Y) : abajo = Max(abajo, p.Y)
	Next
	Dim marco As B4XRect
	marco.Initialize(izq, arriba, der, abajo)
	Return marco
End Sub

Private Sub Polilinea (pts As List, color As Int, gr As Float)
	If pts.Size = 0 Then Return
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

#End Region

#Region Geometria

'Circunferencia que pasa por inicio, fin y el punto de curva. Sin inicializar
'si los tres puntos estan alineados.
Private Sub CentroTresPuntos (a As ASDPunto, b As ASDPunto, m As ASDPunto) As ASDPunto
	Dim d As Double = 2 * (a.X * (b.Y - m.Y) + b.X * (m.Y - a.Y) + m.X * (a.Y - b.Y))
	Dim vacio As ASDPunto
	If Abs(d) < 1 Then Return vacio
	Dim a2 As Double = a.X * a.X + a.Y * a.Y
	Dim b2 As Double = b.X * b.X + b.Y * b.Y
	Dim m2 As Double = m.X * m.X + m.Y * m.Y
	Dim centroX As Double = (a2 * (b.Y - m.Y) + b2 * (m.Y - a.Y) + m2 * (a.Y - b.Y)) / d
	Dim centroY As Double = (a2 * (m.X - b.X) + b2 * (a.X - m.X) + m2 * (b.X - a.X)) / d
	Return Pt(centroX, centroY)
End Sub

Private Sub PuntosArco (a As ASDPunto, b As ASDPunto, m As ASDPunto) As List
	Dim salida As List
	salida.Initialize
	Dim c As ASDPunto = CentroTresPuntos(a, b, m)
	If c.IsInitialized = False Then
		salida.Add(a)
		salida.Add(b)
		Return salida
	End If
	Dim r As Float = Dist(c, a)
	Dim t0 As Float = Angulo(c, a)
	Dim total As Float = Positivo(Angulo(c, b) - t0)
	If Positivo(Angulo(c, m) - t0) > total Then total = total - 2 * cPI
	For k = 0 To PASOS_ARCO
		Dim t As Float = t0 + total * k / PASOS_ARCO
		salida.Add(Pt(c.X + r * Cos(t), c.Y + r * Sin(t)))
	Next
	Return salida
End Sub

Private Sub PuntosAngulo (v As ASDPunto, p1 As ASDPunto, p2 As ASDPunto) As List
	Dim salida As List
	salida.Initialize
	Dim a1 As Float = Angulo(v, p1)
	Dim d As Float = Barrido(a1, Angulo(v, p2))
	Dim r As Float = 24dip
	For k = 0 To 16
		Dim t As Float = a1 + d * k / 16
		salida.Add(Pt(v.X + r * Cos(t), v.Y + r * Sin(t)))
	Next
	Return salida
End Sub

Private Sub Angulo (desde As ASDPunto, hacia As ASDPunto) As Float
	Return ATan2(hacia.Y - desde.Y, hacia.X - desde.X)
End Sub

Private Sub Positivo (a As Float) As Float
	Do While a < 0
		a = a + 2 * cPI
	Loop
	Do While a >= 2 * cPI
		a = a - 2 * cPI
	Loop
	Return a
End Sub

'Barrido mas corto entre dos direcciones, con signo.
Private Sub Barrido (a1 As Float, a2 As Float) As Float
	Dim d As Float = Positivo(a2 - a1)
	If d > cPI Then d = d - 2 * cPI
	Return d
End Sub

Private Sub GradosEntre (v As ASDPunto, p1 As ASDPunto, p2 As ASDPunto) As Double
	Return Round2(Abs(Barrido(Angulo(v, p1), Angulo(v, p2))) * 180 / cPI, 0)
End Sub

'Ejes unitarios del plano en pantalla: el primero en (0, 1) y el segundo en
'(2, 3). La isometrica tiene tres: U a 30 grados hacia arriba, V a 30 hacia
'abajo y W vertical.
Private Sub EjesPlano (plano As String) As Float()
	Dim s3 As Float = Sqrt(3) / 2
	Select plano
		Case "superior"
			Return Array As Float(s3, -0.5, s3, 0.5)
		Case "izquierda"
			Return Array As Float(s3, 0.5, 0, 1)
		Case "derecha"
			Return Array As Float(s3, -0.5, 0, 1)
	End Select
	Return Array As Float(1, 0, 0, 1)
End Sub

Private Sub PuntoElipse (c As ASDPunto, r As Float, plano As String, ang As Float) As ASDPunto
	Dim e() As Float = EjesPlano(plano)
	Return Pt(c.X + r * (Cos(ang) * e(0) + Sin(ang) * e(2)), c.Y + r * (Cos(ang) * e(1) + Sin(ang) * e(3)))
End Sub

Private Sub PuntosElipse (c As ASDPunto, r As Float, plano As String) As List
	Dim salida As List
	salida.Initialize
	For k = 0 To 48
		salida.Add(PuntoElipse(c, r, plano, 2 * cPI * k / 48))
	Next
	Return salida
End Sub

'Plano para un circulo nuevo: el forzado desde el menu, o el de la cara cerrada
'mas chica que contiene el centro, segun la direccion de sus lados.
Private Sub PlanoEn (p As ASDPunto) As String
	If planoForzado <> "" Then Return planoForzado
	If tipoRejilla <> "iso" Then Return "frente"
	Dim menor As Float = -1
	Dim cara As ASDTrazo
	For Each t As ASDTrazo In trazos
		If Cerrada(t) And DentroDe(t, p) Then
			Dim a As Float = AreaDe(t)
			If menor < 0 Or a < menor Then
				menor = a
				cara = t
			End If
		End If
	Next
	If cara.IsInitialized = False Then Return planoUltimo
	Dim haciaArriba, haciaAbajo, vertical As Boolean
	For i = 0 To cara.Pts.Size - 2
		Dim a1 As ASDPunto = cara.Pts.Get(i)
		Dim b1 As ASDPunto = cara.Pts.Get(i + 1)
		If Dist(a1, b1) < UMBRAL Then Continue
		Dim g As Float = Positivo(Angulo(a1, b1))
		If g >= cPI Then g = g - cPI
		Dim grados As Float = g * 180 / cPI
		If Abs(grados - 90) < 15 Then vertical = True
		If Abs(grados - 30) < 15 Then haciaAbajo = True
		If Abs(grados - 150) < 15 Then haciaArriba = True
	Next
	Dim plano As String = planoUltimo
	If haciaArriba And haciaAbajo Then plano = "superior"
	If haciaAbajo And vertical And Not(haciaArriba) Then plano = "izquierda"
	If haciaArriba And vertical And Not(haciaAbajo) Then plano = "derecha"
	planoUltimo = plano
	Return plano
End Sub

'Distancia del punto al centro medida en los ejes del plano, en radios: 1 es
'el borde de la elipse.
Private Sub EnPlano (t As ASDTrazo, p As ASDPunto) As Float
	Dim c As ASDPunto = t.Pts.Get(0)
	Dim r As Float = Dist(c, t.Pts.Get(1))
	If r <= 0 Then Return 999
	Dim e() As Float = EjesPlano(t.Plano)
	Dim determinante As Float = e(0) * e(3) - e(1) * e(2)
	Dim dx As Float = p.X - c.X
	Dim dy As Float = p.Y - c.Y
	Dim a As Float = (dx * e(3) - dy * e(2)) / determinante / r
	Dim b As Float = (dy * e(0) - dx * e(1)) / determinante / r
	Return Sqrt(a * a + b * b)
End Sub

Private Sub CentroDe (t As ASDTrazo) As ASDPunto
	If t.Tipo = "circulo" Then Return t.Pts.Get(0)
	If t.Tipo = "arco" Then Return CentroTresPuntos(t.Pts.Get(0), t.Pts.Get(1), t.Pts.Get(2))
	Dim vacio As ASDPunto
	Return vacio
End Sub

Private Sub Cerrada (t As ASDTrazo) As Boolean
	If t.Tipo <> "poli" Or t.Pts.Size < 4 Then Return False
	Return Dist(t.Pts.Get(0), t.Pts.Get(t.Pts.Size - 1)) < 1
End Sub

Private Sub DentroDe (t As ASDTrazo, p As ASDPunto) As Boolean
	If t.Tipo = "circulo" Then Return EnPlano(t, p) <= 1
	If Cerrada(t) = False Then Return False
	Dim dentro As Boolean = False
	Dim j As Int = t.Pts.Size - 1
	For i = 0 To t.Pts.Size - 1
		Dim a As ASDPunto = t.Pts.Get(i)
		Dim b As ASDPunto = t.Pts.Get(j)
		If (a.Y > p.Y) <> (b.Y > p.Y) Then
			If p.X < (b.X - a.X) * (p.Y - a.Y) / (b.Y - a.Y) + a.X Then dentro = Not(dentro)
		End If
		j = i
	Next
	Return dentro
End Sub

Private Sub AreaDe (t As ASDTrazo) As Float
	If t.Tipo = "circulo" Then
		Dim e() As Float = EjesPlano(t.Plano)
		Return cPI * Power(Dist(t.Pts.Get(0), t.Pts.Get(1)), 2) * Abs(e(0) * e(3) - e(1) * e(2))
	End If
	Dim suma As Float = 0
	For i = 0 To t.Pts.Size - 2
		Dim a As ASDPunto = t.Pts.Get(i)
		Dim b As ASDPunto = t.Pts.Get(i+1)
		suma = suma + (a.X * b.Y - b.X * a.Y)
	Next
	Return Abs(suma) / 2
End Sub

#End Region

#Region Toque

Private Sub pnl_Touch (Action As Int, X As Float, Y As Float)
	If Not(habilitado) Then Return
	If xui.SubExists(mCallBack, mEventName & "_Touch", 2) Then
		CallSub3(mCallBack, mEventName & "_Touch", Action, CreateMap("X": X, "Y": Y))
	End If

	If Action = pnl.TOUCH_ACTION_DOWN Then
		sobreRotulo = False
		Dim tocada As Int = RotuloEn(Pt(X, Y))
		If tocada > 0 Then
			sobreRotulo = True
			PedirMedida(tocada)
			Return
		End If
	End If
	If sobreRotulo Then Return

	Select Action
		Case pnl.TOUCH_ACTION_DOWN
			bajadoX = X : bajadoY = Y
			movido = False
			Select modo
				Case "borrar"
					BorrarEn(Pt(X, Y))
				Case "hueco"
					AlternarHueco(Pt(X, Y))
				Case "libre"
					libre = NuevoTrazo("libre")
					libre.Pts.Add(Pt(X, Y))
					Pintar
				Case "linea"
					arrastreIni = Imantar(Pt(X, Y))
					cursor = arrastreIni
					Pintar
				Case "circulo"
					centroTmp = Imantar(Pt(X, Y))
					cursor = Pt(X, Y)
					Pintar
				Case "agujero"
					Dim cotaAgujero As Int = CotaDeAgujeroEn(Pt(X, Y))
					If cotaAgujero > 0 Then
						PedirMedida(cotaAgujero)
					Else
						centroTmp = Pt(X, Y)
						cursor = Pt(X, Y)
						Pintar
					End If
			End Select

		Case pnl.TOUCH_ACTION_MOVE
			If Sqrt(Power(X-bajadoX,2) + Power(Y-bajadoY,2)) > UMBRAL Then movido = True
			If libre.IsInitialized Then
				libre.Pts.Add(Pt(X, Y))
				Pintar
				Return
			End If
			If centroTmp.IsInitialized Then
				cursor = Pt(X, Y)
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
			Select modo
				Case "borrar", "hueco"
					Return
				Case "linea"
					CerrarArrastre(Imantar(Pt(X, Y)))
					Return
				Case "circulo"
					CerrarCirculo(Pt(X, Y))
					Return
				Case "agujero"
					CerrarAgujero(Pt(X, Y))
					Return
				Case "texto"
					If Not(movido) Then TocarTexto(Pt(X, Y))
					Return
			End Select
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
			Agregar(t)
		End If
	End If
	Dim vacio As ASDPunto
	arrastreIni = vacio
	Pintar
	Avisar
End Sub

Private Sub CerrarCirculo (borde As ASDPunto)
	If centroTmp.IsInitialized Then
		If Dist(centroTmp, borde) > UMBRAL Then
			Dim t As ASDTrazo = NuevoTrazo("circulo")
			t.Plano = PlanoEn(centroTmp)
			t.Pts.Add(centroTmp)
			t.Pts.Add(borde)
			Agregar(t)
		End If
	End If
	Dim vp As ASDPunto : centroTmp = vp : cursor = vp
	Pintar
	Avisar
End Sub

'Un toque deja un agujero de tamano fijo; arrastrar define el tamano. Sale ya
'marcado como hueco y con su cota de diametro, y la pagina pide el valor.
Private Sub CerrarAgujero (borde As ASDPunto)
	If centroTmp.IsInitialized = False Then Return
	Dim r As Float = Dist(centroTmp, borde)
	If Not(movido) Or r < UMBRAL Then r = Max(9dip, LADO * 0.3)
	Dim t As ASDTrazo = NuevoTrazo("circulo")
	t.Plano = PlanoEn(centroTmp)
	t.Hueco = True
	t.Grosor = Min(grosorLapiz, 3dip)
	t.Pts.Add(centroTmp)
	t.Pts.Add(Pt(centroTmp.X + r, centroTmp.Y))
	Agregar(t)
	Dim vp As ASDPunto : centroTmp = vp : cursor = vp
	Pintar
	Avisar
End Sub

Private Sub CotaDeAgujeroEn (p As ASDPunto) As Int
	For Each t As ASDTrazo In trazos
		If t.Tipo = "circulo" And t.Hueco And DentroDe(t, p) Then
			For Each c As ASDTrazo In trazos
				If c.Tipo = "cota" And c.Ref = t.Id Then Return c.Id
			Next
		End If
	Next
	Return 0
End Sub

Private Sub CotaDiametro (fig As ASDTrazo, unidad As String) As ASDTrazo
	Dim c As ASDPunto = fig.Pts.Get(0)
	Dim r As Float = Dist(c, fig.Pts.Get(1))
	Dim cota As ASDTrazo = NuevaCota("diametro", "Diámetro", unidad)
	Dim borde As ASDPunto = PuntoElipse(c, r, fig.Plano, -cPI / 4)
	Dim dir As Float = Angulo(c, borde)
	cota.Pts.Add(borde)
	cota.Pts.Add(Pt(borde.X + 22dip * Cos(dir), borde.Y + 22dip * Sin(dir)))
	cota.Ref = fig.Id
	Return cota
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

	Select modo
		Case "cota"
			TocarCota(n, Pt(crudoX, crudoY))
		Case "angulo"
			TocarAngulo(n)
		Case "arco"
			TocarArco(n)
		Case Else
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
	End Select
	cursor = n
	Pintar
	Avisar
End Sub

'Con la cota libre, tocar una cota existente pide su medida y tocar el borde de
'un circulo o un arco le pone su cota de diametro o radio.
Private Sub TocarCota (n As ASDPunto, crudo As ASDPunto)
	If cotaTmp.IsInitialized = False Then
		Dim existente As Int = CotaEn(crudo)
		If existente > 0 Then
			PedirMedida(existente)
			Return
		End If
		Dim fig As ASDTrazo = FiguraRedondaEn(crudo)
		If fig.IsInitialized Then
			CrearCotaRedonda(fig)
			Return
		End If
		cotaTmp = n
		Return
	End If

	If Dist(cotaTmp, n) > UMBRAL Then
		Dim c As ASDTrazo = NuevaCota("lineal", "Largo", "cm")
		c.Pts.Add(cotaTmp)
		c.Pts.Add(n)
		Agregar(c)
		Dim vacio As ASDPunto
		cotaTmp = vacio
		PedirMedida(c.Id)
		Return
	End If
	Dim vacio2 As ASDPunto
	cotaTmp = vacio2
End Sub

Private Sub CrearCotaRedonda (fig As ASDTrazo)
	For Each ya As ASDTrazo In trazos
		If ya.Tipo = "cota" And ya.Ref = fig.Id Then
			PedirMedida(ya.Id)
			Return
		End If
	Next
	Dim c As ASDPunto = CentroDe(fig)
	Dim cota As ASDTrazo
	If fig.Tipo = "circulo" Then
		cota = CotaDiametro(fig, "cm")
	Else
		cota = NuevaCota("radio", "Radio", "cm")
		Dim m As ASDPunto = fig.Pts.Get(2)
		Dim dir2 As Float = -cPI / 4
		If c.IsInitialized Then dir2 = Angulo(c, m)
		cota.Pts.Add(Pt(m.X, m.Y))
		cota.Pts.Add(Pt(m.X + 22dip * Cos(dir2), m.Y + 22dip * Sin(dir2)))
	End If
	cota.Ref = fig.Id
	trazos.Add(cota)
	Guardar
	Pintar
	Avisar
End Sub

Private Sub TocarAngulo (n As ASDPunto)
	anguloTmp.Add(n)
	If anguloTmp.Size < 3 Then Return
	Dim v As ASDPunto = anguloTmp.Get(0)
	If Dist(v, anguloTmp.Get(1)) > UMBRAL And Dist(v, anguloTmp.Get(2)) > UMBRAL Then
		Dim c As ASDTrazo = NuevaCota("angulo", "Ángulo", "grados")
		c.Pts.AddAll(anguloTmp)
		c.Valor = GradosEntre(v, anguloTmp.Get(1), anguloTmp.Get(2))
		Agregar(c)
		anguloTmp.Initialize
		Return
	End If
	anguloTmp.Initialize
End Sub

Private Sub TocarArco (n As ASDPunto)
	arcoTmp.Add(n)
	If arcoTmp.Size < 3 Then Return
	If Dist(arcoTmp.Get(0), arcoTmp.Get(1)) > UMBRAL Then
		Dim t As ASDTrazo = NuevoTrazo("arco")
		t.Pts.AddAll(arcoTmp)
		Agregar(t)
	End If
	arcoTmp.Initialize
End Sub

Private Sub TocarTexto (p As ASDPunto)
	Dim mejor As Float = 24dip
	Dim id As Int = 0
	For Each t As ASDTrazo In trazos
		If t.Tipo = "texto" Then
			Dim d As Float = Dist(t.Pts.Get(0), p)
			If d < mejor Then
				mejor = d
				id = t.Id
			End If
		End If
	Next
	textoTmp = p
	If xui.SubExists(mCallBack, mEventName & "_Texto", 1) Then
		CallSubDelayed2(mCallBack, mEventName & "_Texto", id)
	End If
End Sub

Private Sub PedirMedida (Id As Int)
	Pintar
	If xui.SubExists(mCallBack, mEventName & "_Medida", 1) Then
		CallSubDelayed2(mCallBack, mEventName & "_Medida", Id)
	End If
End Sub

Private Sub CerrarLibre
	If libre.IsInitialized Then
		If libre.Pts.Size > 2 Then Agregar(libre)
		Dim vacio As ASDTrazo
		libre = vacio
	End If
	Pintar
	Avisar
End Sub

Private Sub BorrarEn (p As ASDPunto)
	Dim idx As Int = -1
	Dim mejor As Float = TOQUE
	For i = 0 To trazos.Size - 1
		Dim t As ASDTrazo = trazos.Get(i)
		Dim d As Float = DistATrazo(t, p)
		If d < mejor Then
			mejor = d
			idx = i
		End If
	Next
	If idx >= 0 Then
		Dim t2 As ASDTrazo = trazos.Get(idx)
		QuitarConCotas(t2.Id)
		Guardar
		Pintar
		Avisar
	End If
End Sub

'Marca o desmarca como hueco la figura mas chica que contiene el toque: asi un
'agujero dentro de una placa se marca sin tocar la placa.
Private Sub AlternarHueco (p As ASDPunto)
	Dim idx As Int = -1
	Dim menor As Float = -1
	For i = 0 To trazos.Size - 1
		Dim t As ASDTrazo = trazos.Get(i)
		If (t.Tipo = "circulo" Or Cerrada(t)) And DentroDe(t, p) Then
			Dim a As Float = AreaDe(t)
			If menor < 0 Or a < menor Then
				menor = a
				idx = i
			End If
		End If
	Next
	If idx < 0 Then Return
	Dim nuevo As ASDTrazo = CopiaTrazo(trazos.Get(idx))
	nuevo.Hueco = Not(nuevo.Hueco)
	trazos.Set(idx, nuevo)
	Guardar
	Pintar
	Avisar
End Sub

Private Sub CotaEn (p As ASDPunto) As Int
	Dim mejor As Float = TOQUE
	Dim id As Int = 0
	For Each t As ASDTrazo In trazos
		If t.Tipo = "cota" Then
			Dim d As Float = DistATrazo(t, p)
			If d < mejor Then
				mejor = d
				id = t.Id
			End If
		End If
	Next
	Return id
End Sub

Private Sub FiguraRedondaEn (p As ASDPunto) As ASDTrazo
	Dim mejor As Float = TOQUE
	Dim elegida As ASDTrazo
	For Each t As ASDTrazo In trazos
		If t.Tipo = "circulo" Or t.Tipo = "arco" Then
			Dim d As Float = DistATrazo(t, p)
			If t.Tipo = "circulo" And (t.Hueco Or Dist(t.Pts.Get(0), t.Pts.Get(1)) < 24dip) And DentroDe(t, p) Then d = 0
			If d < mejor Then
				mejor = d
				elegida = t
			End If
		End If
	Next
	Return elegida
End Sub

#End Region

#Region Historial

'Instantaneas de la lista. Los trazos confirmados nunca se mutan: editar una
'medida o marcar un hueco reemplaza el trazo por una copia, asi la copia
'superficial alcanza. La excepcion deliberada es Reescalar, que si los muta:
'el historial debe quedar en la misma escala que el dibujo.
Private Sub Guardar
	Do While hist.Size > hIdx + 1
		hist.RemoveAt(hist.Size - 1)
	Loop
	hist.Add(CopiaLista(trazos))
	hIdx = hist.Size - 1
End Sub

Private Sub Agregar (t As ASDTrazo)
	trazos.Add(t)
	MarcarMedidas(t)
	Guardar
End Sub

'Cada cota se agrega antes de pedir la siguiente letra: si no, todas saldrian
'con la misma.
Private Sub MarcarMedidas (t As ASDTrazo)
	Select t.Tipo
		Case "poli"
			For i = 0 To t.Pts.Size - 2
				If Dist(t.Pts.Get(i), t.Pts.Get(i + 1)) <= UMBRAL Then Continue
				Dim c As ASDTrazo = NuevaCota("lado", "Largo", "cm")
				c.Ref = t.Id
				c.Lado = i
				trazos.Add(c)
			Next
		Case "circulo"
			Dim unidad As String = "cm"
			If t.Hueco Then unidad = "pulg"
			trazos.Add(CotaDiametro(t, unidad))
		Case "arco"
			Dim r As ASDTrazo = NuevaCota("radio", "Radio", "cm")
			Dim centro As ASDPunto = CentroDe(t)
			Dim m As ASDPunto = t.Pts.Get(2)
			Dim dir As Float = -cPI / 4
			If centro.IsInitialized Then dir = Angulo(centro, m)
			r.Pts.Add(Pt(m.X, m.Y))
			r.Pts.Add(Pt(m.X + 22dip * Cos(dir), m.Y + 22dip * Sin(dir)))
			r.Ref = t.Id
			trazos.Add(r)
	End Select
End Sub

'Letra bajo el dedo, en cualquier herramienta menos Borrar y Lapiz, y nunca a
'mitad de una figura: ahi el toque es un vertice.
Private Sub RotuloEn (p As ASDPunto) As Int
	If Not(verRotulos) Then Return 0
	If modo = "borrar" Or modo = "libre" Then Return 0
	If cadena.IsInitialized Or getTrazoPendiente Then Return 0
	Dim mejor As Float = TOQUE
	Dim id As Int = 0
	For Each t As ASDTrazo In trazos
		If t.Tipo = "cota" Then
			Dim lp As ASDPunto = PosRotulo(t)
			If lp.IsInitialized Then
				Dim d As Float = Dist(lp, p)
				If d < mejor Then
					mejor = d
					id = t.Id
				End If
			End If
		End If
	Next
	Return id
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
	If arcoTmp.Size > 0 Or anguloTmp.Size > 0 Or cotaTmp.IsInitialized Or centroTmp.IsInitialized Then
		If arcoTmp.Size > 0 Then arcoTmp.RemoveAt(arcoTmp.Size - 1)
		If anguloTmp.Size > 0 Then anguloTmp.RemoveAt(anguloTmp.Size - 1)
		Dim vp2 As ASDPunto : cotaTmp = vp2 : centroTmp = vp2
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
	Return hIdx > 0 Or cadena.IsInitialized Or getTrazoPendiente
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
	LimpiarPendientes
	movido = False
	Pintar
	Avisar
End Sub

Private Sub LimpiarPendientes
	Dim vp As ASDPunto
	ancla = vp : cotaTmp = vp : arrastreIni = vp : cursor = vp : centroTmp = vp
	arcoTmp.Initialize
	anguloTmp.Initialize
End Sub

#End Region

#Region API publica
'
'CONVENIO DE EVENTOS
'El evento Cambio se emite solo cuando el croquis cambia por accion del usuario
'sobre el lienzo. Los setters NO lo emiten, porque quien los llama ya sabe que
'cambio el estado y se refresca solo. Medida y Texto piden a la pagina que
'abra su ventana; la respuesta vuelve por FijarMedida y PonerTexto.

Public Sub TerminarCadena (cerrar As Boolean)
	If cadena.IsInitialized Then
		If cerrar And cadena.Pts.Size > 2 Then
			Dim p0 As ASDPunto = cadena.Pts.Get(0)
			cadena.Pts.Add(Pt(p0.X, p0.Y))
		End If
		If cadena.Pts.Size > 1 Then Agregar(cadena)
	End If
	Dim vt As ASDTrazo : cadena = vt
	LimpiarPendientes
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

Public Sub getTrazoPendiente As Boolean
	Return cotaTmp.IsInitialized Or centroTmp.IsInitialized Or arcoTmp.Size > 0 Or anguloTmp.Size > 0
End Sub

'modo: puntos | linea | libre | cota | angulo | circulo | agujero | arco | texto | hueco | borrar
Public Sub setModo (m As String)
	TerminarCadena(False)
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

'iso | cuadrada
Public Sub setTipoRejilla (t As String)
	If t <> "iso" And t <> "cuadrada" Then Return
	tipoRejilla = t
	Pintar
End Sub

Public Sub getTipoRejilla As String
	Return tipoRejilla
End Sub

'Plano de los circulos y agujeros nuevos: "" = segun la cara donde caen, o
'superior, izquierda, derecha, frente.
Public Sub setPlanoCirculo (p As String)
	planoForzado = p
End Sub

Public Sub getPlanoCirculo As String
	Return planoForzado
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

'Medidas del croquis ordenadas por letra. Cada una es un Map con id, etiqueta,
'forma, medida, valor, unidad y cantidad.
Public Sub getMedidas As List
	Dim cotas As List
	cotas.Initialize
	For Each t As ASDTrazo In trazos
		If t.Tipo = "cota" Then cotas.Add(t)
	Next
	cotas.SortType("Etiqueta", True)
	Dim salida As List
	salida.Initialize
	For Each t As ASDTrazo In cotas
		salida.Add(MapaMedida(t))
	Next
	Return salida
End Sub

Public Sub getMedida (Id As Int) As Map
	Dim t As ASDTrazo = TrazoPorId(Id)
	If t.IsInitialized = False Or t.Tipo <> "cota" Then
		Dim vacio As Map
		vacio.Initialize
		Return vacio
	End If
	Return MapaMedida(t)
End Sub

Public Sub getMedidasPendientes As Int
	Dim n As Int = 0
	For Each t As ASDTrazo In trazos
		If t.Tipo = "cota" And t.Valor <= 0 Then n = n + 1
	Next
	Return n
End Sub

Public Sub FijarMedida (Id As Int, Medida As String, Valor As Double, Unidad As String, Cantidad As Int)
	Dim idx As Int = IndicePorId(Id)
	If idx < 0 Then Return
	Dim t As ASDTrazo = CopiaTrazo(trazos.Get(idx))
	t.Medida = Medida
	t.Valor = Valor
	t.Unidad = Unidad
	t.Cantidad = Max(1, Cantidad)
	trazos.Set(idx, t)
	Guardar
	Pintar
	Avisar
End Sub

Public Sub QuitarTrazo (Id As Int)
	If IndicePorId(Id) < 0 Then Return
	QuitarConCotas(Id)
	Guardar
	Pintar
	Avisar
End Sub

Public Sub getTextoDe (Id As Int) As String
	Dim t As ASDTrazo = TrazoPorId(Id)
	If t.IsInitialized = False Then Return ""
	Return t.Texto
End Sub

'Id = 0 pone una nota nueva donde se toco; un texto vacio la borra.
Public Sub PonerTexto (Id As Int, Texto As String)
	Dim limpio As String = Texto.Trim
	If Id = 0 Then
		If limpio = "" Or textoTmp.IsInitialized = False Then Return
		Dim t As ASDTrazo = NuevoTrazo("texto")
		t.Pts.Add(textoTmp)
		t.Texto = limpio
		Agregar(t)
	Else
		Dim idx As Int = IndicePorId(Id)
		If idx < 0 Then Return
		If limpio = "" Then
			trazos.RemoveAt(idx)
		Else
			Dim nuevo As ASDTrazo = CopiaTrazo(trazos.Get(idx))
			nuevo.Texto = limpio
			trazos.Set(idx, nuevo)
		End If
		Guardar
	End If
	Dim vp As ASDPunto : textoTmp = vp
	Pintar
	Avisar
End Sub

'Imagen del croquis. conRejilla = False entrega papel limpio.
'No es el formato de trabajo: solo se invoca para el PDF de la cotizacion o
'para adjuntar la imagen. El formato persistente es el JSON.
Public Sub Exportar (conRejilla As Boolean) As B4XBitmap
	TerminarCadena(False)
	Dim previoR As Boolean = verRejilla
	verRejilla = conRejilla
	Pintar
	Dim bmp As B4XBitmap = cvs.CreateBitmap.Crop(0, 0, pnl.Width, pnl.Height)
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
	Dim lista As List
	lista.Initialize
	For Each t As ASDTrazo In trazos
		Dim m As Map = CreateMap("id": t.Id, "tipo": t.Tipo, "color": t.Color, _
			"grosor": Round2(t.Grosor, 1))
		If t.Hueco Then m.Put("hueco", True)
		If t.Tipo = "circulo" And t.Plano <> "frente" Then m.Put("plano", t.Plano)
		If t.Tipo = "texto" Then m.Put("texto", t.Texto)
		If t.Tipo = "cota" Then
			m.Put("forma", t.Forma)
			m.Put("etiqueta", t.Etiqueta)
			m.Put("medida", t.Medida)
			m.Put("valor", t.Valor)
			m.Put("unidad", t.Unidad)
			m.Put("cantidad", t.Cantidad)
			If t.Ref > 0 Then m.Put("ref", t.Ref)
			If t.Forma = "lado" Then m.Put("lado", t.Lado)
		End If
		Dim pts As List
		pts.Initialize
		For Each p As ASDPunto In t.Pts
			Dim par As List
			par.Initialize
			par.Add(Round(p.X))
			par.Add(Round(p.Y))
			pts.Add(par)
		Next
		m.Put("puntos", pts)
		lista.Add(m)
	Next
	Dim raiz As Map = CreateMap("version": VERSION_JSON, "rejilla": tipoRejilla, _
		"unidad_celda_m": escalaM, "arista_px": Round(LADO), "trazos": lista)
	Dim gen As JSONGenerator
	gen.Initialize(raiz)
	Return gen.ToString
End Sub

'Reconstruye el croquis desde su JSON. Los puntos se reescalan si la arista de
'celda cambio respecto de la que tenia el dispositivo que lo dibujo. Lee la
'version 2: sus cotas traian los metros calculados y pasan a valor en metros.
'Devuelve False tanto si no habia croquis (texto vacio) como si el JSON esta
'danado. UltimoError distingue los dos casos.
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
		tipoRejilla = raiz.GetDefault("rejilla", "iso")

		Dim nuevos As List
		nuevos.Initialize
		Dim mayor As Int = 0
		Dim lst As List = raiz.Get("trazos")
		For Each mt As Map In lst
			Dim t As ASDTrazo = NuevoTrazo(mt.Get("tipo"))
			t.Id = mt.GetDefault("id", 0)
			t.Color = mt.GetDefault("color", colorLapiz)
			t.Grosor = mt.GetDefault("grosor", grosorLapiz)
			t.Hueco = mt.GetDefault("hueco", False)
			t.Texto = mt.GetDefault("texto", "")
			t.Plano = mt.GetDefault("plano", "frente")
			If t.Tipo = "cota" Then
				t.Forma = mt.GetDefault("forma", "lineal")
				t.Etiqueta = mt.GetDefault("etiqueta", "")
				t.Medida = mt.GetDefault("medida", "Largo")
				t.Unidad = mt.GetDefault("unidad", "cm")
				t.Cantidad = mt.GetDefault("cantidad", 1)
				t.Ref = mt.GetDefault("ref", 0)
				t.Lado = mt.GetDefault("lado", 0)
				If mt.ContainsKey("valor") Then
					t.Valor = mt.Get("valor")
				Else If mt.ContainsKey("metros") Then
					t.Valor = mt.Get("metros")
					t.Unidad = "m"
				End If
			End If
			Dim pts As List = mt.Get("puntos")
			For Each par As List In pts
				t.Pts.Add(Pt(par.Get(0) * factor, par.Get(1) * factor))
			Next
			If t.Pts.Size > 0 Or t.Forma = "lado" Then
				nuevos.Add(t)
				mayor = Max(mayor, t.Id)
			End If
		Next

		Cancelar
		trazos = nuevos
		siguienteId = mayor + 1
		For Each t As ASDTrazo In trazos
			If t.Id <= 0 Then
				t.Id = siguienteId
				siguienteId = siguienteId + 1
			End If
			If t.Tipo = "cota" And t.Etiqueta = "" Then t.Etiqueta = SiguienteEtiqueta
		Next
		hist.Initialize
		hist.Add(CopiaLista(trazos))
		hIdx = 0
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

'Perimetro y area de lo dibujado a escala de rejilla. Solo cuenta lineas y
'trazos libres; las medidas reales son las de las cotas.
Public Sub getResumen As Map
	Dim aMetros As Float = escalaM / LADO
	Dim perim As Float = 0
	Dim area As Float = 0
	Dim segs As Int = 0
	Dim cerradas As Int = 0

	For Each t As ASDTrazo In trazos
		If t.Tipo <> "poli" And t.Tipo <> "libre" Then Continue
		For i = 0 To t.Pts.Size - 2
			perim = perim + Dist(t.Pts.Get(i), t.Pts.Get(i+1))
			segs = segs + 1
		Next
		If Cerrada(t) Then
			cerradas = cerradas + 1
			area = area + AreaDe(t)
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
	t.Id = siguienteId
	siguienteId = siguienteId + 1
	t.Tipo = tipo
	t.Pts.Initialize
	t.Color = colorLapiz
	t.Grosor = grosorLapiz
	t.Texto = ""
	t.Forma = ""
	t.Etiqueta = ""
	t.Medida = ""
	t.Unidad = ""
	t.Cantidad = 1
	t.Plano = "frente"
	Return t
End Sub

Private Sub NuevaCota (forma As String, medida As String, unidad As String) As ASDTrazo
	Dim c As ASDTrazo = NuevoTrazo("cota")
	c.Color = C_COTA
	c.Forma = forma
	c.Medida = medida
	c.Unidad = unidad
	c.Etiqueta = SiguienteEtiqueta
	Return c
End Sub

Private Sub CopiaTrazo (o As ASDTrazo) As ASDTrazo
	Dim t As ASDTrazo
	t.Initialize
	t.Id = o.Id
	t.Tipo = o.Tipo
	t.Pts.Initialize
	t.Pts.AddAll(o.Pts)
	t.Color = o.Color
	t.Grosor = o.Grosor
	t.Hueco = o.Hueco
	t.Texto = o.Texto
	t.Forma = o.Forma
	t.Etiqueta = o.Etiqueta
	t.Medida = o.Medida
	t.Valor = o.Valor
	t.Unidad = o.Unidad
	t.Cantidad = o.Cantidad
	t.Ref = o.Ref
	t.Plano = o.Plano
	t.Lado = o.Lado
	Return t
End Sub

Private Sub MapaMedida (t As ASDTrazo) As Map
	Return CreateMap("id": t.Id, "etiqueta": t.Etiqueta, "forma": t.Forma, _
		"medida": t.Medida, "valor": t.Valor, "unidad": t.Unidad, "cantidad": t.Cantidad)
End Sub

'Primera letra libre: al borrar la B, la cota siguiente vuelve a ser la B.
Private Sub SiguienteEtiqueta As String
	Dim usadas As Map
	usadas.Initialize
	For Each t As ASDTrazo In trazos
		If t.Tipo = "cota" Then usadas.Put(t.Etiqueta, True)
	Next
	Dim i As Int = 0
	Do While True
		Dim e As String
		If i < 26 Then
			e = LETRAS.CharAt(i)
		Else
			e = LETRAS.CharAt(Floor(i / 26) - 1) & LETRAS.CharAt(i Mod 26)
		End If
		If usadas.ContainsKey(e) = False Then Return e
		i = i + 1
	Loop
	Return ""
End Sub

Private Sub TrazoPorId (Id As Int) As ASDTrazo
	For Each t As ASDTrazo In trazos
		If t.Id = Id Then Return t
	Next
	Dim vacio As ASDTrazo
	Return vacio
End Sub

Private Sub IndicePorId (Id As Int) As Int
	For i = 0 To trazos.Size - 1
		Dim t As ASDTrazo = trazos.Get(i)
		If t.Id = Id Then Return i
	Next
	Return -1
End Sub

'Una cota de diametro o radio no tiene sentido sin su figura.
Private Sub QuitarConCotas (Id As Int)
	For i = trazos.Size - 1 To 0 Step -1
		Dim t As ASDTrazo = trazos.Get(i)
		If t.Id = Id Or (t.Tipo = "cota" And t.Ref = Id) Then trazos.RemoveAt(i)
	Next
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
	Select t.Tipo
		Case "circulo"
			Return DistAPolilinea(PuntosElipse(t.Pts.Get(0), Dist(t.Pts.Get(0), t.Pts.Get(1)), t.Plano), p)
		Case "arco"
			Return DistAPolilinea(PuntosArco(t.Pts.Get(0), t.Pts.Get(1), t.Pts.Get(2)), p)
		Case "texto"
			Return Dist(t.Pts.Get(0), p)
		Case "cota"
			Dim d As Float = Dist(PosRotulo(t), p)
			If t.Forma = "angulo" Then
				Dim lados As List
				lados.Initialize
				lados.AddAll(Array(t.Pts.Get(1), t.Pts.Get(0), t.Pts.Get(2)))
				Return Min(d, DistAPolilinea(lados, p))
			End If
			Return Min(d, DistAPolilinea(t.Pts, p))
	End Select
	Return DistAPolilinea(t.Pts, p)
End Sub

Private Sub DistAPolilinea (pts As List, p As ASDPunto) As Float
	If pts.Size = 1 Then Return Dist(pts.Get(0), p)
	Dim d As Float = 999999
	For i = 0 To pts.Size - 2
		Dim a As ASDPunto = pts.Get(i)
		Dim b As ASDPunto = pts.Get(i+1)
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
	Return modo = "puntos" Or modo = "cota" Or modo = "linea" Or modo = "arco" Or modo = "angulo"
End Sub

'El evento Cambio solo se emite cuando la vista ya esta construida.
Private Sub Avisar
	If Not(vistaLista) Then Return
	If xui.SubExists(mCallBack, mEventName & "_Cambio", 0) Then
		CallSub(mCallBack, mEventName & "_Cambio")
	End If
End Sub

#End Region
