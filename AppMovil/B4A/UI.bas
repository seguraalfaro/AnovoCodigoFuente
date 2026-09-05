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
'      _ftf_email     teclado de correo
'      _ftf_telefono  teclado de telefono
'      _ftf_monto     teclado decimal
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
	If t.Contains("_raw") Then Return

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
		If t.Contains("_btn") Then
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
public Sub IdentificarFloatText(v As B4XView) As B4XFloatTextField
	Try
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
	If t.Contains("_icon")    Then Return "icono"
	If t.Contains("_sec")     Then Return "secundario"
	If t.Contains("_peligro") Then Return "peligro"
	Return "primario"
End Sub

'_chip_alerta va antes que _chip porque tambien lo contiene.
Private Sub ClasificarEtiqueta (t As String) As String
	If t.Contains("_chip_alerta") Then Return "chip_alerta"
	If t.Contains("_chip")        Then Return "chip"
	If t.Contains("_tit")         Then Return "titulo"
	If t.Contains("_sub")         Then Return "subtitulo"
	If t.Contains("_error")       Then Return "error"
	If t.Contains("_link")        Then Return "link"
	Return "normal"
End Sub

Private Sub ClasificarPanel (t As String) As String
	If t.Contains("_card_btn") Then Return "card_btn"
	If t.Contains("_fondo")    Then Return "fondo"
	If t.Contains("_card")     Then Return "card"
	If t.Contains("_barra")    Then Return "barra"
	If t.Contains("_sep")      Then Return "sep"
	Return ""
End Sub

'Prefijo _ftf_ propio para que un panel tagueado _card_telefono
'no arrastre por error al EditText que tenga adentro.
Private Sub ClasificarFloatTextField (t As String) As String
	If t.Contains("_ftf_email")            Then Return "email"
	If t.Contains("_ftf_telefono_ext")     Then Return "telefonoExt"
	If t.Contains("_ftf_telefono")         Then Return "telefono"
	If t.Contains("_ftf_monto")            Then Return "monto"
	If t.Contains("_ftf_cedula_juridica")  Then Return "cedulajuridica"
	If t.Contains("_ftf_cedula")           Then Return "cedula"
	Return ""
End Sub

'Version destacada de cada categoria, para el elemento activo de un grupo.
Private Sub CategoriaActiva (t As String) As String
	Select ClasificarBoton(t)
		Case "icono"
			Return "icono_activo"
		Case Else
			Return "primario"
	End Select
End Sub

'Devuelve los cinco valores de una categoria de boton.
'Salida: Array(fondo, fondoPresionado, texto, borde, anchoBorde)
Private Sub PaletaBoton (categoria As String) As Int()
	Select categoria
		Case "secundario"
			Return Array As Int( _
				Colores.COLOR_SUPERFICIE, _
				Colores.COLOR_FONDO_PANTALLA, _
				Colores.COLOR_PRIMARIO, _
				Colores.COLOR_PRIMARIO, _
				BORDE_ANCHO_SEC)
		Case "peligro"
			Return Array As Int( _
				Colores.COLOR_ERROR, _
				Colores.COLOR_ERROR_CLARO, _
				Colores.COLOR_TEXTO_SOBRE_PRIMARIO, _
				Colores.COLOR_ERROR, _
				0)
		Case "icono"
			Return Array As Int( _
				Colores.COLOR_PRIMARIO_TENUE, _
				Colores.COLOR_PRIMARIO_SUAVE, _
				Colores.COLOR_PRIMARIO, _
				Colores.COLOR_PRIMARIO_TENUE, _
				0)
		Case "icono_activo"
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
	If t.Contains("_icon")    Then Return v.Height / 2
	If t.Contains("_redondo") Then Return v.Height / 2
	If t.Contains("_pill")    Then Return v.Height / 2
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
		Case "email"
			' B4A no expone TYPE_TEXT_VARIATION_EMAIL_ADDRESS en EditText, por lo que
			' se combina INPUT_TYPE_TEXT (TYPE_CLASS_TEXT, 0x1) con el literal 0x20 de
			' android.text.InputType. Valor resultante: 33.
			' Fuente del valor: developer.android.com/reference/android/text/InputType
			' Uso confirmado en B4X Forum, "EditText input types" (hilo 40647).
			et.InputType = Bit.Or(et.INPUT_TYPE_TEXT, 32)
			PonerHint(Campo, Utils.HINT_CORREO)
		Case "telefono"
			et.InputType = et.INPUT_TYPE_PHONE
			PonerHint(Campo, Utils.HINT_TELEFONO)
		Case "telefonoExt"
			et.InputType = et.INPUT_TYPE_PHONE
			PonerHint(Campo, Utils.HINT_TELEFONO_EXT)
		Case "monto"
			et.InputType = et.INPUT_TYPE_DECIMAL_NUMBERS
			PonerHint(Campo, Utils.HINT_MONTO)
		Case "cedula"
			et.InputType = et.INPUT_TYPE_NUMBERS
			PonerHint(Campo, Utils.HINT_CEDULA)
		Case "cedulajuridica"
			'El consecutivo juridico pasa a alfanumerico (3-101-A00001),
			'asi que el teclado no puede ser numerico.
			et.InputType = et.INPUT_TYPE_TEXT
			PonerHint(Campo, Utils.HINT_CEDULA_JURIDICA)
	End Select
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
Public Sub MarcarError (v As B4XView)
	Dim ftf As B4XFloatTextField = IdentificarFloatText(v)
	If ftf <> Null Then
		CampoError(ftf, Utils.HINT_REQUERIDO)
		Return
	End If
	v.SetColorAndBorder(Colores.COLOR_SUPERFICIE, BORDE_ANCHO_SEC, _
		Colores.COLOR_ERROR, RADIO_CAMPO)
End Sub

Public Sub MarcarNormal (v As B4XView)
	Dim ftf As B4XFloatTextField = IdentificarFloatText(v)
	If ftf <> Null Then
		CampoNormal(ftf, "")
		Return
	End If
	v.SetColorAndBorder(Colores.COLOR_SUPERFICIE, BORDE_ANCHO, _
		Colores.COLOR_BORDE, RADIO_CAMPO)
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
#End Region

#Region Etiquetas
Private Sub EstilizarEtiqueta (v As B4XView, categoria As String)
	Select categoria
		Case "titulo"
			v.TextColor = Colores.COLOR_TEXTO_PRIMARIO
			Dim lbl As Label = v
			lbl.Typeface = Typeface.DEFAULT_BOLD

		Case "subtitulo"
			v.TextColor = Colores.COLOR_TEXTO_SECUNDARIO

		Case "error"
			v.TextColor = Colores.COLOR_ERROR

		Case "link"
			v.TextColor = Colores.COLOR_PRIMARIO

		Case "chip"
			EstilizarChip(v, Colores.COLOR_PRIMARIO_TENUE, Colores.COLOR_PRIMARIO)

		Case "chip_alerta"
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
		Case "fondo"
			v.Color = Colores.COLOR_FONDO_PANTALLA

		Case "card"
			v.SetColorAndBorder(Colores.COLOR_SUPERFICIE, BORDE_ANCHO, _
			                    Colores.COLOR_BORDE, RADIO_TARJETA)

		Case "card_btn"
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

		Case "barra"
			v.Color = Colores.COLOR_PRIMARIO

		Case "sep"
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

Public Sub  CargarPaginasContainer(Layout() As String, AHView As AHViewPager, pagecont As AHPageContainer)
	pagecont.Initialize

	For i = 0 To Layout.Length - 1
		pagecont.AddPage(CrearPagina(Layout(i), AHView), "page" & i)
	Next

	AHView.PageContainer = pagecont
	AHView.PagingEnabled = False
	AHView.CurrentPage = 0
End Sub

Private Sub CrearPagina(NombreLayout As String, AHView As AHViewPager) As B4XView
	Dim page As B4XView = xui.CreatePanel("")
	page.Height = AHView.Height
	page.Width = AHView.Width
	page.LoadLayout(NombreLayout)
	AplicarTema(page)
	Return page
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
