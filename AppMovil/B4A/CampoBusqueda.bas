B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Campo para elegir de una lista larga, para el Designer: muestra el valor elegido con una lupa y al
' tocarlo abre VentanaBuscar. Pide las opciones con <evento>_Opciones y avisa con <evento>_Elegido.
#DesignerProperty: Key: Hint, DisplayName: Hint, FieldType: String, DefaultValue: , Description: Texto del campo
#DesignerProperty: Key: Titulo, DisplayName: Titulo de la ventana, FieldType: String, DefaultValue: , Description: Titulo de la ventana de busqueda
#DesignerProperty: Key: Ayuda, DisplayName: Ayuda del buscador, FieldType: String, DefaultValue: , Description: Texto de ayuda dentro del buscador
#Event: Elegido (Valor As Object)
#Event: Opciones As List

Sub Class_Globals
	Private mEventName As String
	Private mCallBack As Object
	Public mBase As B4XView
	Private xui As XUI
	Public Tag As Object
	Private txt As EditText
	Private lupa As Label
	Private capa As B4XView
	Private ventana As VentanaBuscar
	Private mTitulo As String
	Private mAyuda As String
	Private mHabilitado As Boolean = True
	Private Const SUFIJO_OPCIONES As String = "_Opciones"
	Private Const SUFIJO_ELEGIDO As String = "_Elegido"
	Private Const ANCHO_LUPA As Int = 28dip
	Private Const MARGEN_LUPA As Int = 36dip
	Private Const ESPACIO_TEXTO As Int = 40dip
	Private Const MARGEN_TEXTO As Int = 12dip
	Private Const RADIO As Int = 8dip
	Private Const GLIFO_LUPA As Int = 0xF002
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

#Region Designer
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	Tag = mBase.Tag
	mBase.Tag = Me
	mTitulo = Props.GetDefault("Titulo", "")
	mAyuda = Props.GetDefault("Ayuda", "")
	txt.Initialize("")
	txt.SingleLine = True
	txt.Hint = Props.GetDefault("Hint", "")
	txt.TextSize = Lbl.TextSize
	txt.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	txt.HintColor = Colores.COLOR_TEXTO_SECUNDARIO
	txt.Gravity = Bit.Or(Gravity.LEFT, Gravity.CENTER_VERTICAL)
	txt.InputType = txt.INPUT_TYPE_NONE
	Dim jo As JavaObject = txt
	jo.RunMethod("setFocusable", Array As Object(False))
	txt.Background = Null
	txt.Padding = Array As Int(MARGEN_TEXTO, 0, ESPACIO_TEXTO, 0)
	txt.Tag = Utils.TAG_RAW
	mBase.AddView(txt, 0, 0, mBase.Width, mBase.Height)
	lupa.Initialize("")
	lupa.Typeface = Typeface.FONTAWESOME
	lupa.Text = Chr(GLIFO_LUPA)
	lupa.TextSize = 14
	lupa.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
	lupa.Gravity = Gravity.CENTER
	lupa.Tag = Utils.TAG_RAW
	mBase.AddView(lupa, 0, 0, ANCHO_LUPA, mBase.Height)
	capa = xui.CreatePanel("capa")
	capa.Tag = Utils.TAG_RAW
	capa.Color = xui.Color_Transparent
	mBase.AddView(capa, 0, 0, mBase.Width, mBase.Height)
	Pintar
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
	txt.SetLayout(0, 0, Width, Height)
	lupa.SetLayout(Width - MARGEN_LUPA, 0, ANCHO_LUPA, Height)
	capa.SetLayoutAnimated(0, 0, 0, Width, Height)
End Sub

Private Sub Pintar
	Dim fondo As Int = Colores.COLOR_SUPERFICIE
	If mHabilitado = False Then fondo = Colores.COLOR_FONDO_PANTALLA
	mBase.SetColorAndBorder(fondo, 1dip, Colores.COLOR_BORDE, RADIO)
	txt.Enabled = mHabilitado
End Sub
#End Region

#Region Propiedades
Public Sub getTexto As String
	Return txt.Text
End Sub

Public Sub setTexto (Valor As String)
	txt.Text = Valor
End Sub

Public Sub getHabilitado As Boolean
	Return mHabilitado
End Sub

Public Sub setHabilitado (Valor As Boolean)
	mHabilitado = Valor
	Pintar
End Sub
#End Region

#Region Eventos
Private Sub capa_Click
	If xui.SubExists(mCallBack, mEventName & SUFIJO_OPCIONES, 0) = False Then Return
	Dim opciones As Object = CallSub(mCallBack, mEventName & SUFIJO_OPCIONES)
	If opciones = Null Then Return
	If ventana.IsInitialized = False Then ventana.Initialize(B4XPages.GetNativeParent(mCallBack))
	Wait For (ventana.Elegir(mBase, mTitulo, mAyuda, opciones)) Complete (Valor As Object)
	If Valor = Null Then Return
	CallSub2(mCallBack, mEventName & SUFIJO_ELEGIDO, Valor)
End Sub
#End Region
