B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@

'Modulo de tematizacion automatica de vistas.
'Librerias necesarias: Core, XUI, JavaObject
'
'La identificacion es por el campo Tag del Designer, no por el nombre.
'Solo se marcan las vistas que se salen del comportamiento por defecto.
'
'Los literales de los tags viven en Utils (TAG_*), porque Mascara usa la
'misma lista. Las categorias (CAT_*) son internas de este modulo.
'
'Tags reconocidos:
'   Botones reales (Button):
'      (vacio)        primario
'      _sec           secundario
'      _peligro       peligro
'      _icon          icono circular, fondo tenue
'   Labels que hacen de boton:
'      _btn           primario
'      _btn_sec       secundario
'      _btn_peligro   peligro
'      _btn_icon      icono circular
'   Forma (combinable con lo anterior):
'      _redondo       radio = mitad del alto
'      _pill          radio = mitad del alto
'   Labels de texto:
'      (vacio)        texto primario
'      _tit           titulo en negrita
'      _sub           texto secundario
'      _error         rojo
'      _link          azul primario
'      _chip          insignia, fondo tenue y esquinas redondas
'      _chip_alerta   insignia ambar, para estados pendientes
'   Paneles:
'      (vacio)        no se toca
'      _fondo         fondo de pantalla
'      _card          superficie con borde y radio
'      _card_btn      card presionable
'      _barra         relleno primario
'      _sep           linea de separacion
'   EditText:
'      no necesita tag
'   B4XFloatTextField (el tag va en el custom view, en el Designer):
'      _ftf_email             teclado de correo
'      _ftf_telefono          teclado de telefono
'      _ftf_telefono_ext      teclado de telefono, con extension
'      _ftf_monto             teclado decimal
'      _ftf_cedula            cedula fisica, solo digitos
'      _ftf_cedula_juridica   alfanumerico en mayusculas
'      _ftf_cedula_dimex      solo digitos
'      _ftf_cedulajuridica_cedula   acepta los tres, decide el combo
'   Excluir cualquier vista:
'      _raw
'
'TAMANOS DE LETRA
'El modulo NO asigna TextSize: eso se define en el Designer, vista por
'vista, para que AutoScaleAll lo escale. Referencia del proyecto:
'   _tit    14      (vacio) 13      _sub 12      _chip 11
'Al subir un tamano hay que subir el alto de la vista en el script.
'
'B4XFLOATTEXTFIELD
'GetAllViewsRecursive no devuelve el custom view, devuelve su EditText
'interno. Por ahi se entra: al llegar a un EditText se mira el Tag del padre.
'
'El Tag del panel base no sirve, ahi la clase se guarda a si misma
'(mBase.Tag = Me). El tag del Designer queda en la propiedad Tag de la
'instancia. Ojo con reasignar mBase.Tag: se rompe el componente recuerda dia perdide
'por haber cambiado tag en los card que agregaste CustomListView.
'
'GRUPOS CON UN ELEMENTO ACTIVO
'MarcarGrupo recibe el array de botones y el indice del activo. La categoria
'destacada se deduce de la que le corresponde a cada boton por su Tag, y los
'inactivos vuelven sola a la suya. indice = -1 deja a todos inactivos.
'   UI.MarcarGrupo(navegacion, Position)

Sub Process_Globals
	Private Const TAG_OBLIGATORIO As String = "_oblig"
	Private xui As XUI
	Public RADIO_BOTON     As Int = 10dip
	Public RADIO_CAMPO     As Int = 8dip
	Public RADIO_TARJETA   As Int = 12dip
	Public BORDE_ANCHO     As Int = 1dip
	Public BORDE_ANCHO_SEC As Int = 2dip
	Private Const SMALL_SCREEN_CARD_HEIGHT As Int = 310dip
	Private Const SMALL_SCREEN_SIZE As Float = 4.5
	Private Const CARD_HEIGHT As Int = 220dip
	Public Const EVENTO_CAMPO As String = "EditText"
	Public DEPURAR As Boolean = False

	'Categorias: las devuelve un clasificador y las consume un Select.
	'Escritas a mano en los dos lados, un typo cae en el Case Else sin avisar.
	Private Const CAT_PRIMARIO     As String = "primario"
	Private Const CAT_SECUNDARIO   As String = "secundario"
	Private Const CAT_PELIGRO      As String = "peligro"
	Private Const CAT_ICONO        As String = "icono"
	Private Const CAT_ICONO_ACTIVO As String = "icono_activo"

	Private Const CAT_NORMAL      As String = "normal"
	Private Const CAT_TITULO      As String = "titulo"
	Private Const CAT_SUBTITULO   As String = "subtitulo"
	Private Const CAT_ERROR       As String = "error"
	Private Const CAT_LINK        As String = "link"
	Private Const CAT_CHIP        As String = "chip"
	Private Const CAT_CHIP_ALERTA As String = "chip_alerta"

	Private Const CAT_FONDO    As String = "fondo"
	Private Const CAT_CARD     As String = "card"
	Private Const CAT_CARD_BTN As String = "card_btn"
	Private Const CAT_BARRA    As String = "barra"
	Private Const CAT_SEP      As String = "sep"

	Private Const CAT_NOMBRE           As String = "nombre"
	Private Const CAT_EMAIL           As String = "email"
	Private Const CAT_TELEFONO        As String = "telefono"
	Private Const CAT_TELEFONO_EXT    As String = "telefono_ext"
	Private Const CAT_MONTO           As String = "monto"
	Private Const CAT_CEDULA          As String = "cedula"
	Private Const CAT_CEDULA_JURIDICA As String = "cedula_juridica"
	Private Const CAT_CEDULA_DIMEX    As String = "cedula_dimex"
	Private Const CAT_NINGUNA         As String = ""

	'Guarda el color de texto original de cada boton para restaurarlo
	'en Habilitar. La clave es la instancia de la vista.
	Private ColoresTexto As Map
End Sub

#Region Punto de entrada
'Aplica el tema a todas las vistas hijas del panel indicado.
'Llamar una vez despues de cada LoadLayout.
Public Sub AplicarTema (Padre As B4XView)
	If ColoresTexto.IsInitialized = False Then ColoresTexto.Initialize
	For Each v As B4XView In Padre.GetAllViewsRecursive
		AplicarVista(v)
	Next
End Sub

'Aplica el tema a una sola vista.
Public Sub AplicarVista (v As B4XView)
	If ColoresTexto.IsInitialized = False Then ColoresTexto.Initialize

	Dim t As String = ObtenerTag(v)
	If t.Contains(Utils.TAG_RAW) Then Return

	Dim o As Object = v
	Dim categoria As String = ""

	If o Is Button Then
		categoria = ClasificarBoton(t)
		EstilizarBoton(v, categoria, t)

	Else If o Is EditText Then
		'EditText suelto o interno de un B4XFloatTextField: lo dice el tag del padre.
		Dim tp As String = TagDelPadre(v)
		Dim ftf As B4XFloatTextField = IdentificarFloatText(v)
		categoria = ClasificarFloatTextField(tp)

		If ftf <> Null Then
			UnificarEvento(ftf)
			EstilizarCampoFlotante(ftf, v, categoria)
		Else
			'EditText suelto: se le pinta borde propio, el flotante ya trae el suyo
			EstilizarCampo(v)
		End If

	Else If o Is Label Then
		If t.Contains(Utils.TAG_BTN) Then
			categoria = ClasificarBoton(t)
			EstilizarBotonLabel(v, categoria, t)
		Else
			categoria = ClasificarEtiqueta(t)
			EstilizarEtiqueta(v, categoria)
		End If

	Else If o Is Panel Then
		categoria = ClasificarPanel(t)
		EstilizarPanel(v, categoria)
	End If

	If DEPURAR Then Log("UI: [" & t & "] " & GetType(o) & " -> " & categoria _
		& "  alto=" & v.Height)
End Sub

public Sub IdentificarFloatText(Remitente As Object) As B4XFloatTextField
	Try
		If Remitente Is B4XFloatTextField Then Return Remitente

		Dim v As B4XView = Remitente
		Dim p As B4XView = v.Parent
		If p.IsInitialized = False Then Return Null

		Dim o As Object = p.Tag
		If o Is B4XFloatTextField Then Return o
		Return Null
	Catch
		Return Null
	End Try

End Sub

Private Sub UnificarEvento (Campo As B4XFloatTextField)
	Dim r As Reflector
	r.Target = Campo
	r.SetField2("_meventname", EVENTO_CAMPO)
End Sub


#End Region

#Region Identificacion
'Un Tag que no sea texto (por ejemplo la instancia de un custom view) da "".
Private Sub TagDeObjeto (o As Object) As String
	Try
		If o = Null Then Return ""
		If (o Is String) = False Then Return ""
		Return o.As(String).Trim.ToLowerCase
	Catch
		Return ""
	End Try
End Sub

'Devuelve el Tag de la vista en minusculas.
'Si el Tag no es texto o esta vacio, devuelve cadena vacia.
Public Sub ObtenerTag (v As B4XView) As String
	Try
		Return TagDeObjeto(v.Tag)
	Catch
		Return ""
	End Try
End Sub

'Tag del contenedor inmediato. Vacio si no hay padre.
'Si el padre es el base de un B4XFloatTextField, el tag se lo pide a la clase.
Public Sub TagDelPadre (v As B4XView) As String
	Try
		Dim p As B4XView = v.Parent
		If p.IsInitialized = False Then Return ""

		Dim o As Object = p.Tag
		If o Is B4XFloatTextField Then
			Dim ftf As B4XFloatTextField = o
			Return TagDeObjeto(ftf.Tag)
		End If
		If o Is B4XComboBox Then
			Dim cbo As B4XComboBox = o
			Return TagDeObjeto(cbo.Tag)
		End If
		Return TagDeObjeto(o)
	Catch
		Return ""
	End Try
End Sub

'Diagnostico. Llamar una vez para ver que Tag tiene cada vista.
Public Sub ListarTags (Padre As B4XView)
	Log("--- UI.ListarTags ---")
	For Each v As B4XView In Padre.GetAllViewsRecursive
		Dim o As Object = v
		Log("[" & ObtenerTag(v) & "]  padre:[" & TagDelPadre(v) & "]  tipo: " & GetType(o) _
			& "  alto=" & v.Height & "  ancho=" & v.Width)
	Next
	Log("--- fin ---")
End Sub
#End Region

#Region Clasificadores
Private Sub ClasificarBoton (t As String) As String
	If t.Contains(Utils.TAG_ICON)    Then Return CAT_ICONO
	If t.Contains(Utils.TAG_SEC)     Then Return CAT_SECUNDARIO
	If t.Contains(Utils.TAG_PELIGRO) Then Return CAT_PELIGRO
	Return CAT_PRIMARIO
End Sub

'_chip_alerta va antes que _chip porque tambien lo contiene.
Private Sub ClasificarEtiqueta (t As String) As String
	If t.Contains(Utils.TAG_CHIP_ALERTA) Then Return CAT_CHIP_ALERTA
	If t.Contains(Utils.TAG_CHIP)        Then Return CAT_CHIP
	If t.Contains(Utils.TAG_TIT)         Then Return CAT_TITULO
	If t.Contains(Utils.TAG_SUB)         Then Return CAT_SUBTITULO
	If t.Contains(Utils.TAG_ERROR)       Then Return CAT_ERROR
	If t.Contains(Utils.TAG_LINK)        Then Return CAT_LINK
	Return CAT_NORMAL
End Sub

Private Sub ClasificarPanel (t As String) As String
	If t.Contains(Utils.TAG_CARD_BTN) Then Return CAT_CARD_BTN
	If t.Contains(Utils.TAG_FONDO)    Then Return CAT_FONDO
	If t.Contains(Utils.TAG_CARD)     Then Return CAT_CARD
	If t.Contains(Utils.TAG_BARRA)    Then Return CAT_BARRA
	If t.Contains(Utils.TAG_SEP)      Then Return CAT_SEP
	Return CAT_NINGUNA
End Sub

'Prefijo _ftf_ propio para que un panel tagueado _card_telefono
'no arrastre por error al EditText que tenga adentro.
'Los tags largos van primero: _ftf_cedula es prefijo de los otros tres.
Private Sub ClasificarFloatTextField (t As String) As String
	If t.Contains(Utils.TAG_FTF_EMAIL)           Then Return CAT_EMAIL
	If t.Contains(Utils.TAG_FTF_TELEFONO_EXT)    Then Return CAT_TELEFONO_EXT
	If t.Contains(Utils.TAG_FTF_TELEFONO)        Then Return CAT_TELEFONO
	If t.Contains(Utils.TAG_FTF_MONTO)           Then Return CAT_MONTO
	If t.Contains(Utils.TAG_FTF_CEDULA_JURIDICA) Then Return CAT_CEDULA_JURIDICA
	If t.Contains(Utils.TAG_FTF_CEDULA_DIMEX)    Then Return CAT_CEDULA_DIMEX
	If t.Contains(Utils.TAG_FTF_CEDULA)          Then Return CAT_CEDULA
	If t.Contains(Utils.TAG_FTF_NOMBRE)          Then Return CAT_NOMBRE
	Return CAT_NINGUNA
End Sub

'Version destacada de cada categoria, para el elemento activo de un grupo.
Private Sub CategoriaActiva (t As String) As String
	Select ClasificarBoton(t)
		Case CAT_ICONO
			Return CAT_ICONO_ACTIVO
		Case Else
			Return CAT_PRIMARIO
	End Select
End Sub

'Devuelve los cinco valores de una categoria de boton.
'Salida: Array(fondo, fondoPresionado, texto, borde, anchoBorde)
Private Sub PaletaBoton (categoria As String) As Int()
	Select categoria
		Case CAT_SECUNDARIO
			Return Array As Int( _
				Colores.COLOR_SUPERFICIE, _
				Colores.COLOR_FONDO_PANTALLA, _
				Colores.COLOR_PRIMARIO, _
				Colores.COLOR_PRIMARIO, _
				BORDE_ANCHO_SEC)
		Case CAT_PELIGRO
			Return Array As Int( _
				Colores.COLOR_ERROR, _
				Colores.COLOR_ERROR_CLARO, _
				Colores.COLOR_TEXTO_SOBRE_PRIMARIO, _
				Colores.COLOR_ERROR, _
				0)
		Case CAT_ICONO
			Return Array As Int( _
				Colores.COLOR_PRIMARIO_TENUE, _
				Colores.COLOR_PRIMARIO_SUAVE, _
				Colores.COLOR_PRIMARIO, _
				Colores.COLOR_PRIMARIO_TENUE, _
				0)
		Case CAT_ICONO_ACTIVO
			Return Array As Int( _
				Colores.COLOR_SUPERFICIE, _
				Colores.COLOR_PRIMARIO_TENUE, _
				Colores.COLOR_PRIMARIO, _
				Colores.COLOR_SUPERFICIE, _
				0)
		Case Else
			Return Array As Int( _
				Colores.COLOR_PRIMARIO, _
				Colores.COLOR_PRIMARIO_CLARO, _
				Colores.COLOR_TEXTO_SOBRE_PRIMARIO, _
				Colores.COLOR_PRIMARIO, _
				0)
	End Select
End Sub

'Devuelve el radio de esquina segun el tag.
'Los tags de forma circular usan la mitad del alto de la vista.
Private Sub RadioDe (v As B4XView, t As String) As Int
	If t.Contains(Utils.TAG_ICON)    Then Return v.Height / 2
	If t.Contains(Utils.TAG_REDONDO) Then Return v.Height / 2
	If t.Contains(Utils.TAG_PILL)    Then Return v.Height / 2
	Return RADIO_BOTON
End Sub
#End Region

#Region Botones reales
Private Sub EstilizarBoton (v As B4XView, categoria As String, t As String)
	Dim p() As Int = PaletaBoton(categoria)

	v.TextColor = p(2)

	Dim btn As Button = v
	btn.Background = CrearFondoBoton(p(0), p(1), p(3), p(4), RadioDe(v, t))

	ColoresTexto.Put(ClaveDe(v), p(2))
End Sub

'Construye el StateListDrawable que en el Designer se arma a mano.
Private Sub CrearFondoBoton (fondo As Int, fondoPress As Int, borde As Int, anchoBorde As Int, radio As Int) As StateListDrawable
	Dim normal As ColorDrawable
	normal.Initialize2(fondo, radio, anchoBorde, borde)

	Dim presionado As ColorDrawable
	presionado.Initialize2(fondoPress, radio, anchoBorde, borde)

	Dim deshabilitado As ColorDrawable
	deshabilitado.Initialize2(Colores.COLOR_DESHABILITADO, radio, 0, Colors.Transparent)

	Dim sld As StateListDrawable
	sld.Initialize
	'El orden importa: gana el primer estado que coincide
	sld.AddState(sld.State_Pressed, presionado)
	sld.AddState(sld.State_Disabled, deshabilitado)
	sld.AddCatchAllState(normal)
	Return sld
End Sub
#End Region

#Region Labels que hacen de boton
'Un Label admite StateListDrawable igual que un Button,
'pero hay que marcarlo como clickable para que Android
'le pase el estado presionado.
Private Sub EstilizarBotonLabel (v As B4XView, categoria As String, t As String)
	Dim p() As Int = PaletaBoton(categoria)

	v.TextColor = p(2)

	Dim lbl As Label = v
	lbl.Background = CrearFondoBoton(p(0), p(1), p(3), p(4), RadioDe(v, t))

	Dim jo As JavaObject = lbl
	jo.RunMethod("setClickable", Array As Object(True))

	ColoresTexto.Put(ClaveDe(v), p(2))
End Sub
#End Region

#Region Grupos con un elemento activo
'Repinta un boton con una categoria distinta a la de su Tag.
Public Sub Recategorizar (v As B4XView, categoria As String)
	Dim t As String = ObtenerTag(v)
	Dim o As Object = v
	If o Is Button Then
		EstilizarBoton(v, categoria, t)
	Else If o Is Label Then
		EstilizarBotonLabel(v, categoria, t)
	End If
End Sub

'Marca uno de un grupo como activo. Los demas vuelven a la categoria que
'les corresponde por su Tag. indice = -1 deja a todos inactivos, util
'cuando la seleccion se hizo desde un menu y ningun boton la representa.
Public Sub MarcarGrupo (botones() As B4XView, indice As Int)
	If ColoresTexto.IsInitialized = False Then ColoresTexto.Initialize

	For i = 0 To botones.Length - 1
		Dim t As String = ObtenerTag(botones(i))
		If i = indice Then
			Recategorizar(botones(i), CategoriaActiva(t))
		Else
			Recategorizar(botones(i), ClasificarBoton(t))
		End If
	Next
End Sub
#End Region

#Region Estado habilitado
'Habilita o deshabilita un boton ajustando tambien el color del texto.
'Usar esto en vez de asignar .Enabled directamente.
Public Sub Habilitar (v As B4XView, activo As Boolean)
	v.Enabled = activo

	If activo = False Then
		v.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
		Return
	End If

	Dim k As String = ClaveDe(v)
	If ColoresTexto.IsInitialized And ColoresTexto.ContainsKey(k) Then
		v.TextColor = ColoresTexto.Get(k)
	Else
		v.TextColor = Colores.COLOR_TEXTO_SOBRE_PRIMARIO
	End If
End Sub

'Clave unica por instancia de vista, independiente del Tag.
Private Sub ClaveDe (v As B4XView) As String
	Dim o As Object = v
	Return o
End Sub
#End Region

#Region Campos
'EditText suelto: borde, radio y color propios.
Private Sub EstilizarCampo (v As B4XView)
	v.SetColorAndBorder(Colores.COLOR_SUPERFICIE, BORDE_ANCHO, _
	                    Colores.COLOR_BORDE, RADIO_CAMPO)
	v.TextColor = Colores.COLOR_TEXTO_PRIMARIO

	Dim et As EditText = v
	et.HintColor = Colores.COLOR_DESHABILITADO

End Sub

'EditText interno de un B4XFloatTextField. El hint va en el componente
'(Campo.HintText), no en el EditText: si se ponen los dos se ven los dos,
'el flotante arriba y el nativo dentro de la caja.
'El InputType es ayuda visual para el usuario, no validacion: el teclado
'de telefono deja escribir + y #, y el de correo deja escribir cualquier
'cosa. La validacion la sigue haciendo el modulo Formato.
'En campos de contrasena no usar estos tags: el InputType pisa el PasswordMode.
'Marcarlos _raw o vacios.
Private Sub EstilizarCampoFlotante (Campo As B4XFloatTextField, v As B4XView, categoria As String)
	v.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	v.SetColorAndBorder(Colores.COLOR_SUPERFICIE, BORDE_ANCHO, _
	                    Colores.COLOR_BORDE, RADIO_CAMPO)

	Dim et As EditText = v
	et.HintColor = Colores.COLOR_DESHABILITADO

	Select categoria
		Case CAT_EMAIL
			' B4A no expone TYPE_TEXT_VARIATION_EMAIL_ADDRESS en EditText, por lo que
			' se combina INPUT_TYPE_TEXT (TYPE_CLASS_TEXT, 0x1) con el literal 0x20 de
			' android.text.InputType. Valor resultante: 33.
			' Fuente del valor: developer.android.com/reference/android/text/InputType
			' Uso confirmado en B4X Forum, "EditText input types" (hilo 40647).
			et.InputType = Utils.INPUT_CORREO
			PonerHint(Campo, Utils.HINT_CORREO)
		Case CAT_TELEFONO
			et.InputType = et.INPUT_TYPE_PHONE
			PonerHint(Campo, Utils.HINT_TELEFONO)
		Case CAT_TELEFONO_EXT
			et.InputType = et.INPUT_TYPE_PHONE
			PonerHint(Campo, Utils.HINT_TELEFONO_EXT)
		Case CAT_MONTO
			et.InputType = et.INPUT_TYPE_DECIMAL_NUMBERS
			PonerHint(Campo, Utils.HINT_MONTO)
		Case CAT_CEDULA
			et.InputType = et.INPUT_TYPE_NUMBERS
			PonerHint(Campo, Utils.HINT_CEDULA)
		Case CAT_CEDULA_JURIDICA
			'El consecutivo juridico pasa a alfanumerico (3-101-A00001),
			'asi que el teclado no puede ser numerico.
			et.InputType = Utils.INPUT_ALFANUMERICO_MAY
			PonerHint(Campo, Utils.HINT_CEDULA_JURIDICA)
		Case CAT_CEDULA_DIMEX
			et.InputType = et.INPUT_TYPE_NUMBERS
			PonerHint(Campo, Utils.HINT_CEDULA_DIMEX)
		Case CAT_NOMBRE
			et.InputType = Utils.INPUT_ALFANUMERICO_MAY
			PonerHint(Campo, Utils.HINT_NOMBRE)
	End Select
End Sub
'Se usa al limpiar un error: restaurar sin repintar el teclado.
Public Sub HintPorTag (Campo As B4XFloatTextField) As String
	Dim categoria As String = ClasificarFloatTextField(TagDelPadre(Campo.TextField))
	Select categoria
		Case CAT_EMAIL
			Return Utils.HINT_CORREO
		Case CAT_TELEFONO
			Return Utils.HINT_TELEFONO
		Case CAT_TELEFONO_EXT
			Return Utils.HINT_TELEFONO_EXT
		Case CAT_MONTO
			Return Utils.HINT_MONTO
		Case CAT_CEDULA
			Return Utils.HINT_CEDULA
		Case CAT_CEDULA_JURIDICA
			Return Utils.HINT_CEDULA_JURIDICA
		Case CAT_CEDULA_DIMEX
			Return Utils.HINT_CEDULA_DIMEX
		Case CAT_NOMBRE
			Return Utils.HINT_NOMBRE
	End Select
	Return ""
End Sub
'Reconfigura el campo generico de identificacion cuando cambia el combo.
'Recibe la constante de Mascara, no el indice del combo.
Public Sub ConfigurarIdentificacion (Campo As B4XFloatTextField, Tipo As Int)
	Dim et As EditText = Campo.TextField
	Select Tipo
		Case Formato.MASCARA_IDENT_JURIDICA
			et.InputType = Utils.INPUT_ALFANUMERICO_MAY
			PonerHint(Campo, Utils.HINT_CEDULA_JURIDICA)
		Case Formato.MASCARA_IDENT_FISICA
			et.InputType = Utils.INPUT_SOLO_DIGITOS
			PonerHint(Campo, Utils.HINT_CEDULA)
		Case Formato.MASCARA_IDENT_DIMEX
			et.InputType = Utils.INPUT_SOLO_DIGITOS
			PonerHint(Campo, Utils.HINT_CEDULA_DIMEX)
	
	End Select
End Sub

Public Sub RetornarTextField (Remitente As Object) As EditText
	If Remitente Is B4XFloatTextField Then
		Dim ftf As B4XFloatTextField = Remitente
		Return ftf.TextField
	End If
	If Remitente Is EditText Then Return Remitente
	Return Null
End Sub
'Sin Update el label flotante se queda con el texto anterior.
Private Sub PonerHint (Campo As B4XFloatTextField, hint As String)
	Campo.HintText = hint
	Campo.Update
End Sub

'Ya no hace falta llamarlo: AplicarTema alcanza los campos flotantes por
'el Tag del contenedor. Se conserva por compatibilidad con las paginas viejas.
Public Sub EstilizarCampos (Campos() As B4XFloatTextField)
	For Each c As B4XFloatTextField In Campos
		CampoNormal(c)
	Next
End Sub

'Estos dos si se siguen usando: se llaman durante la validacion, cuando
'ya se tiene el objeto B4XFloatTextField a mano.
Public Sub CampoError (Campo As B4XFloatTextField,hint As String=Null)
	Campo.TextField.As(B4XView).SetColorAndBorder(Colores.COLOR_SUPERFICIE, _
		BORDE_ANCHO_SEC, Colores.COLOR_ERROR, RADIO_CAMPO)
	If hint <> "" Then PonerHint(Campo, hint)
End Sub

Public Sub CampoNormal (Campo As B4XFloatTextField,hint As String=Null)
	Campo.TextField.As(B4XView).SetColorAndBorder(Colores.COLOR_SUPERFICIE, _
		BORDE_ANCHO, Colores.COLOR_BORDE, RADIO_CAMPO)
	If hint <> "" Then PonerHint(Campo, hint)
End Sub

Public Sub MarcarError (Remitente As Object, hint As String = "")
	Dim ftf As B4XFloatTextField = IdentificarFloatText(Remitente)
	If ftf <> Null Then
		If hint = "" Then hint = Utils.HINT_REQUERIDO
		CampoError(ftf, hint)
		Return
	End If

	Dim v As B4XView = Remitente
	v.SetColorAndBorder(Colores.COLOR_SUPERFICIE, BORDE_ANCHO_SEC, _
		Colores.COLOR_ERROR, RADIO_CAMPO)
	If hint <> "" Then
		Dim et As EditText = v
		et.Hint = hint
	End If
End Sub

Public Sub MarcarNormal (Remitente As Object, hint As String = "")
	Dim ftf As B4XFloatTextField = IdentificarFloatText(Remitente)
	If ftf <> Null Then
		'Sin hint explicito se restaura el que le toca por el tag.
		If hint = "" Then hint = HintPorTag(ftf)
		CampoNormal(ftf, hint)
		Return
	End If

	'EditText suelto: borde normal. Estaba copiado de MarcarError y dejaba el
	'campo en rojo justo cuando se acababa de validar bien.
	Dim v As B4XView = Remitente
	v.SetColorAndBorder(Colores.COLOR_SUPERFICIE, BORDE_ANCHO, _
		Colores.COLOR_BORDE, RADIO_CAMPO)
	If hint <> "" Then
		Dim et As EditText = v
		et.Hint = hint
	End If
End Sub

Public Sub ConfigurarMemo (Campo As EditText, Ayuda As String)
	Campo.As(B4XView).SetColorAndBorder(Colores.COLOR_SUPERFICIE, BORDE_ANCHO, _
		Colores.COLOR_BORDE, RADIO_CAMPO)
	Campo.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	Campo.Hint = Ayuda
	Campo.HintColor = Colores.COLOR_DESHABILITADO
	Campo.SingleLine = False
	Campo.Gravity = Bit.Or(Gravity.TOP, Gravity.LEFT)
	Campo.ForceDoneButton = False
	Campo.Padding = Array As Int(10dip, 8dip, 10dip, 8dip)
End Sub

Public Sub CampoDeBusqueda (Campo As B4XFloatTextField, Evento As String)
	Dim et As EditText = Campo.TextField
	et.InputType = et.INPUT_TYPE_NONE
	Dim jo As JavaObject = et
	jo.RunMethod("setFocusable", Array As Object(False))
	Dim p() As Int = et.Padding
	et.Padding = Array As Int(12dip, p(1), 40dip, p(3))
	Dim lupa As Label
	lupa.Initialize("")
	lupa.Tag = Utils.TAG_RAW
	lupa.Typeface = Typeface.FONTAWESOME
	lupa.Text = Chr(0xF002)
	lupa.TextSize = 14
	lupa.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
	lupa.Gravity = Gravity.CENTER
	Dim tf As B4XView = Campo.TextField
	Campo.mBase.AddView(lupa, tf.Left + tf.Width - 36dip, tf.Top, 28dip, tf.Height)
	Dim capa As B4XView = xui.CreatePanel(Evento)
	capa.Tag = Utils.TAG_RAW
	capa.Color = xui.Color_Transparent
	Campo.mBase.AddView(capa, 0, 0, Campo.mBase.Width, Campo.mBase.Height)
End Sub
#End Region

#Region Etiquetas
Private Sub EstilizarEtiqueta (v As B4XView, categoria As String)
	Select categoria
		Case CAT_TITULO
			v.TextColor = Colores.COLOR_TEXTO_PRIMARIO
			Dim lbl As Label = v
			lbl.Typeface = Typeface.DEFAULT_BOLD

		Case CAT_SUBTITULO
			v.TextColor = Colores.COLOR_TEXTO_SECUNDARIO

		Case CAT_ERROR
			v.TextColor = Colores.COLOR_ERROR

		Case CAT_LINK
			v.TextColor = Colores.COLOR_PRIMARIO

		Case CAT_CHIP
			EstilizarChip(v, Colores.COLOR_PRIMARIO_TENUE, Colores.COLOR_PRIMARIO)

		Case CAT_CHIP_ALERTA
			EstilizarChip(v, Colores.COLOR_ADVERTENCIA_TENUE, Colores.COLOR_ADVERTENCIA)

		Case Else
			v.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	End Select
End Sub

'Insignia de estado. No es pulsable: solo fondo, color de texto y radio.
'El radio sale del alto, asi que la vista ya debe tener su tamano final.
'Si el chip se crea por codigo, llamar AplicarVista despues de dimensionarlo.
Private Sub EstilizarChip (v As B4XView, fondo As Int, value As Int)
	v.SetColorAndBorder(fondo, 0, Colors.Transparent, v.Height / 2)
	v.TextColor = value
End Sub
#End Region

#Region Paneles
Private Sub EstilizarPanel (v As B4XView, categoria As String)
	Select categoria
		Case CAT_FONDO
			v.Color = Colores.COLOR_FONDO_PANTALLA

		Case CAT_CARD
			v.SetColorAndBorder(Colores.COLOR_SUPERFICIE, BORDE_ANCHO, _
			                    Colores.COLOR_BORDE, RADIO_TARJETA)

		Case CAT_CARD_BTN
			Dim normal As ColorDrawable
			normal.Initialize2(Colores.COLOR_SUPERFICIE, RADIO_TARJETA, _
			                   BORDE_ANCHO, Colores.COLOR_BORDE)

			Dim presionado As ColorDrawable
			presionado.Initialize2(Colores.COLOR_FONDO_PANTALLA, RADIO_TARJETA, _
			                       BORDE_ANCHO, Colores.COLOR_PRIMARIO)

			Dim sld As StateListDrawable
			sld.Initialize
			sld.AddState(sld.State_Pressed, presionado)
			sld.AddCatchAllState(normal)

			Dim pnl As Panel = v
			pnl.Background = sld

			Dim jo As JavaObject = pnl
			jo.RunMethod("setClickable", Array As Object(True))

		Case CAT_BARRA
			v.Color = Colores.COLOR_PRIMARIO

		Case CAT_SEP
			v.Color = Colores.COLOR_BORDE

		Case Else
			'Contenedor estructural: no se toca
	End Select
End Sub
#End Region

#Region Utilidades de pantalla
Public Sub GetCardHeight As Int
	If GetDeviceLayoutValues.ApproximateScreenSize < SMALL_SCREEN_SIZE Then
		Return SMALL_SCREEN_CARD_HEIGHT
	Else
		Return CARD_HEIGHT
	End If
End Sub
#End Region

#Region Cargar Paginas PageContainer

Public Sub PaginaVacia (AHView As AHViewPager) As B4XView
	Dim pagina As B4XView = xui.CreatePanel("")
	pagina.Height = AHView.Height
	pagina.Width = AHView.Width
	Return pagina
End Sub

Public Sub CargarContenedor (AHView As AHViewPager, Contenedor As AHPageContainer, Paginas() As B4XView)
	Contenedor.Initialize
	For i = 0 To Paginas.Length - 1
		AplicarTema(Paginas(i))
		Contenedor.AddPage(Paginas(i), "page" & i)
	Next
	AHView.PageContainer = Contenedor
	AHView.PagingEnabled = False
	AHView.CurrentPage = 0
End Sub


#End Region

#Region Indicador de pasos

Public Sub CargarIndicadorPasos(Indicador As ASDrawSteps, Claves() As String, Titulos() As String)
	AplicarTemaIndicador(Indicador)
	Indicador.SetSteps(Claves, Titulos)
	Indicador.CurrentIndex = 0
End Sub

Private Sub AplicarTemaIndicador(Indicador As ASDrawSteps)
	Indicador.BackgroundColor   = Colores.COLOR_FONDO_PANTALLA
	Indicador.ActiveColor       = Colores.COLOR_PRIMARIO
	Indicador.InactiveColor     = Colores.COLOR_DESHABILITADO
	Indicador.LineColor         = Colores.COLOR_BORDE
	Indicador.CircleTextColor   = Colores.COLOR_TEXTO_SOBRE_PRIMARIO
	Indicador.PendingTextColor  = Colores.COLOR_TEXTO_SECUNDARIO
	Indicador.LabelColor        = Colores.COLOR_TEXTO_SECUNDARIO
End Sub

#End Region


#Region Formularios
Public Sub LimpiarFormulario (Padre As B4XView)
	For Each v As B4XView In Padre.GetAllViewsRecursive
		Dim o As Object = v

		If o Is EditText Then
			If Not (Utils.EstaVacio( v.Text)) Then v.Text = ""
		Else If o Is CheckBox Then
			Dim cb As CheckBox = v
			cb.Checked = False

		Else If o Is RadioButton Then
			Dim rb As RadioButton = v
			rb.Checked = False

		Else If o Is Spinner Then
			Dim sp As Spinner = v
			If sp.Size > 0 Then sp.SelectedIndex = 0
		End If
	Next
End Sub

#End Region
#Region Formularios

Public Sub ValidarFormulario (Padre As B4XView) As Boolean
	Dim ok As Boolean = True
	For Each v As B4XView In Padre.GetAllViewsRecursive
		If Obligatorio(v) = False Then Continue
		Dim o As Object = v
		Dim vacio As Boolean
		If o Is EditText Then
			vacio = Utils.EstaVacio(v.Text)
		Else If o Is Spinner Then
			Dim sp As Spinner = v
			vacio = Utils.EstaVacio(sp.SelectedItem)
		Else If o Is CheckBox Then
			Dim cb As CheckBox = v
			vacio = (cb.Checked = False)
		Else
			Continue
		End If
		If vacio Then
			ok = False
			MarcarError(v)
		Else
			MarcarNormal(v)
		End If
	Next
	Return ok
End Sub

Private Sub Obligatorio (v As B4XView) As Boolean
	Dim t As String = TagDelPadre(v)
	If t = "" Then t = ObtenerTag(v)
	Return t.Contains(TAG_OBLIGATORIO)
End Sub

#End Region
#Region Dialogos

Public Sub CentrarDialogo (Dialogo As B4XDialog)
	Dim b As B4XView = Dialogo.Base
	Dim arriba As Int = Max(0, (Dialogo.mParent.Height - b.Height) / 2)
	b.SetLayoutAnimated(0, b.Left, arriba, b.Width, b.Height)
End Sub

Public Sub AjustarBarraTitulo (Dialogo As B4XDialog)
	If Dialogo.TitleBar.IsInitialized = False Then Return
	Dim altoVisible As Int = Dialogo.TitleBar.Top + Dialogo.TitleBar.Height
	Dim radio As Int = Dialogo.BorderCornersRadius
	Dialogo.TitleBar.SetLayoutAnimated(0, 0, 0, Dialogo.Base.Width, altoVisible + radio)
	Dialogo.TitleBar.SetColorAndBorder(Dialogo.TitleBarColor, 0, Dialogo.TitleBarColor, radio)
	If Dialogo.TitleBar.NumberOfViews > 0 Then
		Dialogo.TitleBar.GetView(0).SetLayoutAnimated(0, 0, 0, Dialogo.Base.Width, altoVisible)
	End If
End Sub

Public Sub EstilizarDialogo (Dialogo As B4XDialog)
	Dialogo.BackgroundColor = Colores.COLOR_SUPERFICIE
	Dialogo.BorderColor = Colores.COLOR_BORDE
	Dialogo.BorderWidth = 1dip
	Dialogo.BorderCornersRadius = 12dip
	Dialogo.TitleBarColor = Colores.COLOR_PRIMARIO
	Dialogo.TitleBarTextColor = Colores.COLOR_TEXTO_SOBRE_PRIMARIO
	Dialogo.TitleBarHeight = 44dip
	Dialogo.TitleBarFont = xui.CreateDefaultBoldFont(15)
	Dialogo.ButtonsColor = Colores.COLOR_SUPERFICIE
	Dialogo.ButtonsTextColor = Colores.COLOR_MEDIO
	Dialogo.ButtonsTextColorDisabled = Colores.COLOR_DESHABILITADO
	Dialogo.ButtonsFont = xui.CreateDefaultBoldFont(14)
	Dialogo.ButtonsHeight = 48dip
	Dialogo.BodyTextColor = Colores.COLOR_TEXTO_PRIMARIO
	Dialogo.OverlayColor = 0x80000000
	Dialogo.PutAtTop = True
End Sub

Public Sub EstilizarPlantillaTexto (Plantilla As B4XInputTemplate)
	Plantilla.mBase.Color = Colores.COLOR_SUPERFICIE
	Plantilla.lblTitle.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
	Plantilla.TextField1.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	Plantilla.SetBorderColor(Colores.COLOR_BORDE, Colores.COLOR_RECHAZADA_ERROR)
End Sub

#End Region
#Region Teclado

Public Sub SoltarFoco (Campo As B4XView)
	If Campo.IsInitialized = False Then Return

	Dim act As JavaObject
	act.InitializeContext
	Dim enfocada As Object = act.RunMethod("getCurrentFocus", Null)
	If enfocada = Null Then Return

	Dim jc As JavaObject = Campo
	Dim esElMismo As Boolean = jc.RunMethod("equals", Array As Object(enfocada))
	If esElMismo = False Then Return

	jc.RunMethod("clearFocus", Null)
End Sub

#End Region