B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
'ASBuscador - buscador con filtrado sobre lista en memoria
'Sistema de cotizaciones de Anovo (TFG UNED IS-2026)
'
'PROCEDENCIA
'Basado en AutoCompleteEditText v1.01 (Erel) y en el antirrebote por
'contador de B4XSearchTemplate (Erel), ambos del foro B4X.
'
'MODIFICACIONES
'  -Se retira el ListView interno y el indice de prefijos y subcadenas:
'   el componente devuelve la lista filtrada y la pagina la pinta donde
'   quiera. El indice ademas es innecesario con catalogos de cientos de
'   elementos y obligaria a reconstruirlo cada vez que se registra un
'   cliente sin conexion.
'  -Se agregan boton de limpiar y lupa opcional.
'  -El antirrebote pasa a ser configurable desde el Designer.
'  -Los colores fijos pasan a propiedades del Designer.
'
'QUE HACE Y QUE NO
'Recibe una lista, filtra segun lo que el usuario escribe y emite el
'resultado. No sabe de donde vienen los datos ni como se dibujan.
'
'La coincidencia se busca en cualquier parte del texto, pero el
'resultado sale ordenado por relevancia: primero los que empiezan con el
'termino y despues los que lo contienen en medio. Escribir "zam" pone
'"Zamora S.A." antes que "Luis Zamora".
'
'ANTIRREBOTE
'El evento no se emite en cada tecla: se espera RetardoMs y solo se
'dispara si no llego otra pulsacion mientras tanto. Escribir "zamora"
'produce un filtrado, no seis. El contador descarta las invocaciones
'viejas cuando el Sleep de una anterior termina despues que el de otra
'mas reciente.
'
'Librerias necesarias: Core, XUI, JavaObject, IME

#DesignerProperty: Key: Hint, DisplayName: Hint, FieldType: String, DefaultValue: Buscar...
#DesignerProperty: Key: ConLupa, DisplayName: Mostrar lupa, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: ConLimpiar, DisplayName: Mostrar boton limpiar, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: RetardoMs, DisplayName: Retardo antirrebote (ms), FieldType: Int, DefaultValue: 150
#DesignerProperty: Key: MinCaracteres, DisplayName: Minimo de caracteres, FieldType: Int, DefaultValue: 1
#DesignerProperty: Key: IgnorarAcentos, DisplayName: Ignorar acentos, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: ColorFondo, DisplayName: Color de fondo, FieldType: Color, DefaultValue: 0xFFF2F4F7
#DesignerProperty: Key: ColorBorde, DisplayName: Color del borde, FieldType: Color, DefaultValue: 0xFFD6DAE0
#DesignerProperty: Key: ColorTexto, DisplayName: Color del texto, FieldType: Color, DefaultValue: 0xFF1C1C1E
#DesignerProperty: Key: ColorIcono, DisplayName: Color de los iconos, FieldType: Color, DefaultValue: 0xFF8FA4BC
#DesignerProperty: Key: Radio, DisplayName: Radio de esquina (dip), FieldType: Float, DefaultValue: 8
#DesignerProperty: Key: TamanoTexto, DisplayName: Tamano del texto, FieldType: Float, DefaultValue: 14

#Event: Filtrado (Resultado As List)
#Event: Limpiado
#Event: Buscar (Texto As String)

Sub Class_Globals
	Private xui As XUI
	Private mCallBack As Object
	Private mEventName As String

	Private mBase As B4XView
	Private txt As EditText
	Private lblLupa As Label
	Private btnX As Label
	Private ime As IME

	'--- fuente y comparacion ---
	Private fuente As List
	Private resultado As List
	Private moduloCmp As Object
	Private campoCmp As String = ""

	'Contador del antirrebote: cada pulsacion lo incrementa y las
	'invocaciones viejas se descartan al despertar.
	Private indiceCambio As Int = 0

	Private retardo, minChars As Int
	Private conLupa, conLimpiar, sinAcentos As Boolean
	Private cFondo, cBorde, cTexto, cIcono As Int
	Private radio As Float
	Private listo As Boolean = False

	Private ACENTOS As String = "áàäâéèëêíìïîóòöôúùüûñç"
	Private LLANAS  As String = "aaaaeeeeiiiioooouuuunc"
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mCallBack = Callback
	mEventName = EventName
End Sub

Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	LeerProps(Props)

	fuente.Initialize
	resultado.Initialize

	txt.Initialize("txt")
	txt.SingleLine = True
	txt.Hint = Props.Get("Hint")
	txt.TextSize = Props.Get("TamanoTexto")
	txt.TextColor = cTexto
	txt.HintColor = cIcono
	txt.Gravity = Bit.Or(Gravity.LEFT, Gravity.CENTER_VERTICAL)

	'De AutoCompleteEditText: sin la barra de sugerencias, que en un
	'campo de busqueda propone palabras que estorban.
	txt.InputType = Bit.Or(txt.INPUT_TYPE_TEXT, 0x00080000)

	'Sin editor a pantalla completa en horizontal, que taparia la lista.
	'IME_FLAG_NO_FULLSCREEN | IME_ACTION_SEARCH
	Try
		Dim jo As JavaObject = txt
		jo.RunMethod("setImeOptions", Array As Object(Bit.Or(33554432, 3)))
	Catch
		Log("ASBuscador: setImeOptions no disponible")
	End Try

	mBase.AddView(txt, 0, 0, mBase.Width, mBase.Height)

	lblLupa.Initialize("")
	lblLupa.Typeface = Typeface.FONTAWESOME
	lblLupa.Text = Chr(0xF002)
	lblLupa.TextColor = cIcono
	lblLupa.Gravity = Gravity.CENTER
	mBase.AddView(lblLupa, 0, 0, 20dip, mBase.Height)
	lblLupa.Visible = conLupa

	btnX.Initialize("btnX")
	btnX.Typeface = Typeface.FONTAWESOME
	btnX.Text = Chr(0xF00D)
	btnX.TextColor = cIcono
	btnX.Gravity = Gravity.CENTER
	mBase.AddView(btnX, 0, 0, 22dip, mBase.Height)
	btnX.Visible = False

	'Un Label no recibe toques hasta marcarlo como clickable.
	Try
		Dim jx As JavaObject = btnX
		jx.RunMethod("setClickable", Array As Object(True))
	Catch
		Log("ASBuscador: setClickable no disponible")
	End Try

	ime.Initialize("ime")
	listo = True
	Recolocar
End Sub

Private Sub LeerProps (Props As Map)
	conLupa    = Props.Get("ConLupa")
	conLimpiar = Props.Get("ConLimpiar")
	sinAcentos = Props.Get("IgnorarAcentos")
	retardo    = Props.Get("RetardoMs")
	minChars   = Props.Get("MinCaracteres")
	cFondo     = xui.PaintOrColorToColor(Props.Get("ColorFondo"))
	cBorde     = xui.PaintOrColorToColor(Props.Get("ColorBorde"))
	cTexto     = xui.PaintOrColorToColor(Props.Get("ColorTexto"))
	cIcono     = xui.PaintOrColorToColor(Props.Get("ColorIcono"))
	radio      = DipToCurrent(Props.Get("Radio"))
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
	If Not(listo) Then Return
	Recolocar
End Sub

'Unica funcion que dimensiona. El campo ocupa todo el ancho y los iconos
'se superponen sobre sus extremos; el padding evita que el texto quede
'debajo de ellos.
Private Sub Recolocar
	Dim w As Int = mBase.Width
	Dim h As Int = mBase.Height
	If w <= 0 Or h <= 0 Then Return

	Dim v As B4XView = txt
	v.SetLayoutAnimated(0, 0, 0, w, h)
	v.SetColorAndBorder(cFondo, 1dip, cBorde, radio)

	Dim izq As Int = 12dip
	If conLupa Then
		Dim vl As B4XView = lblLupa
		vl.SetLayoutAnimated(0, 10dip, 0, 20dip, h)
		izq = 36dip
	End If

	Dim der As Int = 12dip
	If conLimpiar Then
		Dim vx As B4XView = btnX
		vx.SetLayoutAnimated(0, w - 32dip, 0, 22dip, h)
		der = 38dip
	End If

	Try
		Dim jo As JavaObject = txt
		jo.RunMethod("setPadding", Array As Object(izq, 0, der, 0))
	Catch
		Log("ASBuscador: setPadding no disponible")
	End Try
End Sub

#Region Configuracion
'Indica que texto de cada objeto se compara. El Sub recibe el objeto y
'devuelve el String contra el que se busca. Concatenar varios campos
'permite buscar por cualquiera de ellos con el mismo cuadro.
'
'   Buscador.Comparar(Me, "TextoCliente")
'
'   Public Sub TextoCliente (o As Object) As String
'       Dim c As Cliente = o
'       Return c.Nombre & " " & c.Telefono
'   End Sub
'
'Si no se llama, la fuente se trata como lista de Strings.
Public Sub Comparar (Origen As Object, Campo As String)
	moduloCmp = Origen
	campoCmp = Campo
End Sub

'Fuente de datos. Puede venir de SQLite, de la API o de donde sea: el
'buscador no lo sabe ni le importa. Asignarla emite Filtrado.
Public Sub setFuente (Datos As List)
	If Datos.IsInitialized Then
		fuente = Datos
	Else
		fuente.Initialize
	End If
	Aplicar
End Sub

Public Sub getFuente As List
	Return fuente
End Sub

'Resultado actual del filtro, por si la pagina lo necesita fuera del
'evento -por ejemplo para resolver el indice de un ItemClick.
Public Sub getResultado As List
	Return resultado
End Sub

Public Sub getCantidad As Int
	If resultado.IsInitialized = False Then Return 0
	Return resultado.Size
End Sub

'Vuelve a filtrar con el termino actual. Se llama tras agregar, editar
'o borrar un registro de la fuente.
Public Sub Refrescar
	Aplicar
End Sub
#End Region

#Region Filtrado
'Filtra la fuente y emite el resultado.
Private Sub Aplicar
	If Not(listo) Then Return

	Dim t As String = Preparar(txt.Text)
	resultado.Initialize

	If t.Length < minChars Then
		For Each o As Object In fuente
			resultado.Add(o)
		Next
	Else
		Dim prefijo, subcadena As List
		prefijo.Initialize
		subcadena.Initialize

		For Each o As Object In fuente
			Dim n As String = Preparar(TextoDe(o))
			If n.StartsWith(t) Then
				prefijo.Add(o)
			Else If n.Contains(t) Then
				subcadena.Add(o)
			End If
		Next

		For Each o As Object In prefijo
			resultado.Add(o)
		Next
		For Each o As Object In subcadena
			resultado.Add(o)
		Next
	End If

	If xui.SubExists(mCallBack, mEventName & "_Filtrado", 1) Then
		CallSub2(mCallBack, mEventName & "_Filtrado", resultado)
	End If
End Sub

Private Sub TextoDe (o As Object) As String
	If campoCmp = "" Then Return "" & o
	Return CallSub2(moduloCmp, campoCmp, o)
End Sub

'Minusculas y, si la propiedad lo pide, sin acentos: buscar "metalurgica"
'encuentra "Metalúrgica". Conserva la longitud original para que las
'posiciones sigan siendo validas sobre el texto sin normalizar.
Private Sub Preparar (value As String) As String
	If value = "" Then Return ""
	Dim t As String = value.ToLowerCase.Trim
	If Not(sinAcentos) Then Return t

	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To t.Length - 1
		Dim c As String = t.CharAt(i)
		Dim p As Int = ACENTOS.IndexOf(c)
		If p >= 0 And p < LLANAS.Length Then
			sb.Append(LLANAS.CharAt(p))
		Else
			sb.Append(c)
		End If
	Next
	Return sb.ToString
End Sub
#End Region

#Region Eventos internos
'De B4XSearchTemplate: cada pulsacion incrementa el contador y al
'despertar del Sleep, si el contador cambio es que llego otra tecla y
'esta invocacion se descarta.
Private Sub txt_TextChanged (Old As String, New As String)
	If conLimpiar Then btnX.Visible = (New.Length > 0)

	indiceCambio = indiceCambio + 1
	Dim miIndice As Int = indiceCambio
	Sleep(retardo)
	If miIndice <> indiceCambio Then Return

	Aplicar
End Sub

Private Sub txt_EnterPressed
	ime.HideKeyboard
	If xui.SubExists(mCallBack, mEventName & "_Buscar", 1) Then
		CallSub2(mCallBack, mEventName & "_Buscar", txt.Text)
	End If
End Sub

Private Sub btnX_Click
	Limpiar
End Sub
#End Region

#Region API publica
'Vacia el campo y emite Filtrado con la lista completa, ademas de
'Limpiado por si la pagina quiere hacer algo mas, como volver la lista
'al principio.
Public Sub Limpiar
	If Not(listo) Then Return

	'Se incrementa el contador para descartar cualquier antirrebote en
	'vuelo: si el usuario borra mientras uno esperaba, no debe repintar
	'con un termino que ya no existe.
	indiceCambio = indiceCambio + 1
	txt.Text = ""
	btnX.Visible = False

	Aplicar

	If xui.SubExists(mCallBack, mEventName & "_Limpiado", 0) Then
		CallSub(mCallBack, mEventName & "_Limpiado")
	End If
End Sub

Public Sub getTexto As String
	If Not(listo) Then Return ""
	Return txt.Text
End Sub

'Asigna el texto y filtra, sin esperar el antirrebote.
Public Sub setTexto (t As String)
	If Not(listo) Then Return
	indiceCambio = indiceCambio + 1
	txt.Text = t
	btnX.Visible = (t.Length > 0 And conLimpiar)
	Aplicar
End Sub

Public Sub Enfocar
	If Not(listo) Then Return
	txt.RequestFocus
	ime.ShowKeyboard(txt)
End Sub

Public Sub OcultarTeclado
	ime.HideKeyboard
End Sub

Public Sub getBase As B4XView
	Return mBase
End Sub

Public Sub getCampo As EditText
	Return txt
End Sub

Public Sub setEnable (b As Boolean)
	If Not(listo) Then Return
	txt.Enabled = b
End Sub

Public Sub getEnable As Boolean
	If Not(listo) Then Return False
	Return txt.Enabled
End Sub
#End Region