B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Cadenas, fechas y vocabulario compartido: tags del Designer, InputType y hints. Sin UI ni base.
' Toda funcion que cambie DateTime.DateFormat lo deja como estaba: es global al proceso.
Sub Process_Globals
	Public Const FORMATO_BD      As String = "yyyy-MM-dd HH:mm:ss"
	Public Const FORMATO_API     As String = "yyyy-MM-dd HH:mm:ss.SSS"
	Public Const FORMATO_ENVIO   As String = "yyyy-MM-dd'T'HH:mm:ss"
	Public Const FORMATO_DISPLAY As String = "dd/MM/yyyy HH:mm"
	Public Const FORMATO_CORTA   As String = "dd/MM/yyyy"
	Public Const FORMATO_LARGA   As String = "EEEE d 'de' MMMM"

	Public Const LARGO_IDENT_FISICA   As Int = 9
	Public Const LARGO_IDENT_JURIDICA As Int = 10
	Public Const LARGO_IDENT_DIMEX    As Int = 12
	Public Const LARGO_IDENT_DIMEX_MIN As Int = 11
	Public Const LARGO_TELEFONO       As Int = 8
	Public Const LARGO_TELEFONO_EXT   As Int = 14
	Public Const LARGO_MINIMO_TEXTO As Int = 3
	Public Const VOCALES_MINIMO As Float = 0.2
	
	Public Const TiposIdent() As String= Array As String("Cédula física", "Cédula jurídica", "DIMEX")

	#Region Hints
	Public Const HINT_NOMBRE         As String ="Juan Perez / Anovo MS S.A."
	Public Const HINT_CEDULA          As String = "Cedula: 104530756"
	Public Const HINT_CEDULA_JURIDICA As String = "cedula juridica: 3-101-A00001"
	Public Const HINT_CEDULA_DIMEX    As String = "Cedula dimex: 1-2345-6789012"
	Public Const HINT_TELEFONO        As String = "Tel: 8888-8888"
	Public Const HINT_TELEFONO_EXT    As String = "Tel: 8888-8888 ext 423"
	Public Const HINT_CORREO          As String = "nombre@dominio.cr"
	Public Const HINT_MONTO           As String = "125000,00"
	Public Const HINT_ERROR           As String = "Formato invalido"
	Public Const HINT_REQUERIDO       As String = "Campo obligatorio"
	Public Const HINT_FORMATO         As String = "Formato incorrecto"
	Public Const HINT_TEXTO_INVALIDO As String = "Escriba un texto valido"

	#End Region

	#Region InputType
	Public Const INPUT_CORREO As Int = 33
	Public Const INPUT_ALFANUMERICO_MAY As Int = 4241
	Public Const INPUT_SOLO_DIGITOS As Int = 3
	#End Region

	#Region Tags del Designer
	Public Const TAG_RAW As String = "_raw"

	Public Const TAG_BTN     As String = "_btn"
	Public Const TAG_SEC     As String = "_sec"
	Public Const TAG_PELIGRO As String = "_peligro"
	Public Const TAG_ICON    As String = "_icon"
	Public Const TAG_REDONDO As String = "_redondo"
	Public Const TAG_PILL    As String = "_pill"

	Public Const TAG_TIT         As String = "_tit"
	Public Const TAG_SUB         As String = "_sub"
	Public Const TAG_ERROR       As String = "_error"
	Public Const TAG_LINK        As String = "_link"
	Public Const TAG_CHIP        As String = "_chip"
	Public Const TAG_CHIP_ALERTA As String = "_chip_alerta"

	Public Const TAG_FONDO    As String = "_fondo"
	Public Const TAG_CARD     As String = "_card"
	Public Const TAG_CARD_BTN As String = "_card_btn"
	Public Const TAG_BARRA    As String = "_barra"
	Public Const TAG_SEP      As String = "_sep"

	Public Const TAG_FTF_EMAIL           As String = "_ftf_email"
	Public Const TAG_FTF_TELEFONO        As String = "_ftf_telefono"
	Public Const TAG_FTF_TELEFONO_EXT    As String = "_ftf_telefono_ext"
	Public Const TAG_FTF_MONTO           As String = "_ftf_monto"
	Public Const TAG_FTF_CEDULA          As String = "_ftf_cedula"
	Public Const TAG_FTF_CEDULA_JURIDICA As String = "_ftf_cedula_juridica"
	Public Const TAG_FTF_CEDULA_DIMEX    As String = "_ftf_cedula_dimex"
	Public Const TAG_FTF_NOMBRE     As String = "_ftf_nombre"
	#End Region
End Sub

#Region Fechas
Public Sub Formatear (Fecha As Long, FormatoDate As String) As String
	Dim previo As String = DateTime.DateFormat
	Dim r As String = ""
	Try
		DateTime.DateFormat = FormatoDate
		r = DateTime.Date(Fecha)
	Catch
		Log("Texto.Formatear: " & LastException)
	End Try
	DateTime.DateFormat = previo
	Return r
End Sub

Public Sub Parsear (Fecha As String, FormatoDate As String) As Long
	If EstaVacio(Fecha) Then Return 0
	Dim previo As String = DateTime.DateFormat
	Dim r As Long = 0
	Try
		DateTime.DateFormat = FormatoDate
		r = DateTime.DateParse(Fecha.Trim)
	Catch
		Log("Texto.Parsear: " & LastException)
	End Try
	DateTime.DateFormat = previo
	Return r
End Sub

Public Sub AhoraBd As String
	Return Formatear(DateTime.Now, FORMATO_BD)
End Sub

Public Sub BdADisplay (FechaBd As String) As String
	Dim f As Long = Parsear(FechaBd, FORMATO_BD)
	If f = 0 Then Return ""
	Return Formatear(f, FORMATO_DISPLAY)
End Sub

Public Sub BdACorta (FechaBd As String) As String
	Dim f As Long = Parsear(FechaBd, FORMATO_BD)
	If f = 0 Then Return ""
	Return Formatear(f, FORMATO_CORTA)
End Sub

Public Sub ApiAFecha (FechaApi As String) As Long
	If EstaVacio(FechaApi) Then Return 0
	Dim s As String = FechaApi.Trim.Replace("T", " ").Replace("Z", "")
	If s.Length > 23 Then s = s.SubString2(0, 23)
	If s.Length = 19 Then s = s & ".000"
	Return Parsear(s, FORMATO_API)
End Sub

Public Sub ApiADisplay (FechaApi As String) As String
	Dim f As Long = ApiAFecha(FechaApi)
	If f = 0 Then Return ""
	Return Formatear(f, FORMATO_DISPLAY)
End Sub

Public Sub BdAApi (FechaBd As String) As String
	Dim f As Long = Parsear(FechaBd, FORMATO_BD)
	If f = 0 Then Return ""
	Return Formatear(f, FORMATO_ENVIO)
End Sub
#End Region

#Region Texto
Public Sub EstaVacio (Valor As Object) As Boolean
	If Valor = Null Then Return True
	Return Valor.As(String).Trim = ""
End Sub

Public Sub Unir (Separador As String, Partes() As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For Each p As String In Partes
		If EstaVacio(p) Then Continue
		If sb.Length > 0 Then sb.Append(Separador)
		sb.Append(p.Trim)
	Next
	Return sb.ToString
End Sub

Public Sub TextoONada (Valor As Object) As String
	If Valor = Null Then Return ""
	Return Valor
End Sub

Public Sub Iniciales (Nombre As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For Each palabra As String In Regex.Split("\s+", Nombre.Trim)
		If Regex.IsMatch("[A-Za-zÁÉÍÓÚÑáéíóúñ].*", palabra) = False Then Continue
		sb.Append(palabra.CharAt(0))
		If sb.Length = 2 Then Exit
	Next
	Return sb.ToString.ToUpperCase
End Sub

Public Sub SoloDigitos (s As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To s.Length - 1
		Dim c As String = s.SubString2(i, i + 1)
		If "0123456789".IndexOf(c) > -1 Then sb.Append(c)
	Next
	Return sb.ToString
End Sub

Public Sub SoloAlfanum (s As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To s.Length - 1
		Dim c As String = s.SubString2(i, i + 1).ToUpperCase
		If "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".IndexOf(c) > -1 Then sb.Append(c)
	Next
	Return sb.ToString
End Sub

Public Sub ProporcionVocales (s As String) As Float
	Dim letras As Int = 0
	Dim vocales As Int = 0
	For i = 0 To s.Length - 1
		Dim c As String = s.SubString2(i, i + 1).ToUpperCase
		If "ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÓÚÜÑ".IndexOf(c) > -1 Then
			letras = letras + 1
			If "AEIOUÁÉÍÓÚÜ".IndexOf(c) > -1 Then vocales = vocales + 1
		End If
	Next
	If letras = 0 Then Return 0
	Return vocales / letras
End Sub

Public Sub Normalizar (Texto As String) As String
	Return SoloAlfanum(Texto)
End Sub

Public Sub NormalizarCorreo (Texto As String) As String
	If EstaVacio(Texto) Then Return ""
	Return Texto.Trim.ToLowerCase
End Sub
#End Region

#Region Combos
Public Sub AsignarItemsCombo (cd As B4XComboBox, items() As String)
	cd.SetItems(items)
	cd.SelectedIndex = 0
End Sub
#End Region
