B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Mascaras de texto mientras se escribe y validacion al perder el foco, segun el Tag del campo.
Sub Process_Globals
	Private MascaraEnCurso As Boolean

	Public Const MASCARA_NOMBRE       As Int = 0
	Public Const MASCARA_TELEFONO       As Int = 1
	Public Const MASCARA_TELEFONO_EXT   As Int = 2
	Public Const MASCARA_EMAIL          As Int = 4
	Public Const MASCARA_MONTO          As Int = 5
	Public Const MASCARA_IDENT_JURIDICA As Int = 6
	Public Const MASCARA_IDENT_FISICA   As Int = 7
	Public Const MASCARA_IDENT_DIMEX    As Int = 8
	
End Sub

#Region Evento de entrada
Public Sub SetTipoIdentificacion (indice As Int, Campo As B4XFloatTextField)
	Dim actual As String = UI.TagDelPadre(Campo.TextField)
	Dim viejo  As String = TagIdentActual(actual)
	Dim nuevo  As String = TagIdentPorIndice(indice)
	Dim tag    As String
	
	tag = actual.Replace(viejo, nuevo)

	Campo.Tag = tag

	MascaraEnCurso = True
	Campo.Text = ""
	MascaraEnCurso = False
	UI.ConfigurarIdentificacion(Campo, Enmascarar(tag))

End Sub

Private Sub TagIdentPorIndice (indice As Int) As String
	Select indice
		Case 0
			Return Utils.TAG_FTF_CEDULA
		Case 1
			Return Utils.TAG_FTF_CEDULA_JURIDICA
		Case 2
			Return Utils.TAG_FTF_CEDULA_DIMEX
		Case Else
			Return Utils.TAG_FTF_NOMBRE
	End Select
End Sub

Private Sub TagIdentActual (t As String) As String

	If t.Contains(Utils.TAG_FTF_CEDULA_JURIDICA) Then Return Utils.TAG_FTF_CEDULA_JURIDICA
	If t.Contains(Utils.TAG_FTF_CEDULA_DIMEX)    Then Return Utils.TAG_FTF_CEDULA_DIMEX
	If t.Contains(Utils.TAG_FTF_CEDULA)          Then Return Utils.TAG_FTF_CEDULA
	Return ""
End Sub

public Sub EventoCambioText(Remitente As Object ,Old As String, New As String)
	If MascaraEnCurso Then Return

	Dim et As EditText = UI.RetornarTextField(Remitente)
	If et = Null Then Return
	Dim t As String=obtenerTag(et)
	If t = "" Then Return

	Dim mascara As Int = Enmascarar(t)
	Dim nuevo As String = RevisarMarcara(mascara,New)
	If New  <> nuevo Then
		MascaraEnCurso = True
		et.Text = nuevo
		et.SelectionStart = nuevo.Length
		MascaraEnCurso = False
	End If
End Sub

Private Sub obtenerTag(et As EditText)As String
	Dim tag As String = UI.ObtenerTag(et)        
	If tag = "" Then tag = UI.TagDelPadre(et)    
	Return tag
End Sub

Private Sub RevisarMarcara(Tipo As Int, New As String)As String
	Select Tipo
		Case MASCARA_TELEFONO
			Return MascaraTelefono(New)
		Case MASCARA_TELEFONO_EXT
			Return MascaraTelefonoExt(New)
		Case MASCARA_IDENT_JURIDICA, MASCARA_IDENT_FISICA, MASCARA_IDENT_DIMEX
			Return MascaraIdentificacion(New, Tipo)
		End Select
	Return New
End Sub

Private Sub Enmascarar (t As String) As Int
	If t.Contains(Utils.TAG_FTF_TELEFONO_EXT)    Then Return MASCARA_TELEFONO_EXT
	If t.Contains(Utils.TAG_FTF_TELEFONO)        Then Return MASCARA_TELEFONO
	If t.Contains(Utils.TAG_FTF_MONTO)           Then Return MASCARA_MONTO
	If t.Contains(Utils.TAG_FTF_CEDULA_JURIDICA) Then Return MASCARA_IDENT_JURIDICA
	If t.Contains(Utils.TAG_FTF_CEDULA_DIMEX)    Then Return MASCARA_IDENT_DIMEX
	If t.Contains(Utils.TAG_FTF_CEDULA)          Then Return MASCARA_IDENT_FISICA
	If t.Contains(Utils.TAG_FTF_EMAIL)           Then Return MASCARA_EMAIL
	If t.Contains(Utils.TAG_FTF_NOMBRE)           Then Return MASCARA_NOMBRE
	Return MASCARA_NOMBRE
End Sub
#End Region

#Region Máscaras
Public Sub MascaraIdentificacion (Texto As String, Tipo As Int) As String
	Select Tipo
		Case MASCARA_IDENT_JURIDICA
			Dim s As String = Utils.SoloAlfanum(Texto)
			If s.Length > Utils.LARGO_IDENT_JURIDICA Then s = s.SubString2(0, Utils.LARGO_IDENT_JURIDICA)
			Dim res As String = s
			If s.Length > 1 Then res = s.SubString2(0, 1) & "-" & s.SubString2(1, Min(4, s.Length))
			If s.Length > 4 Then res = res & "-" & s.SubString(4)
			Return res

		Case MASCARA_IDENT_FISICA
			Dim d As String = Utils.SoloDigitos(Texto)
			If d.Length > Utils.LARGO_IDENT_FISICA Then d = d.SubString2(0, Utils.LARGO_IDENT_FISICA)
			Return d

		Case MASCARA_IDENT_DIMEX
			Dim dx As String = Utils.SoloDigitos(Texto)
			If dx.Length > Utils.LARGO_IDENT_DIMEX Then dx = dx.SubString2(0, Utils.LARGO_IDENT_DIMEX)
			Dim resx As String = dx
			If dx.Length > 1 Then resx = dx.SubString2(0, 1) & "-" & dx.SubString2(1, Min(5, dx.Length))
			If dx.Length > 5 Then resx = resx & "-" & dx.SubString(5)
			Return resx
	End Select
	Return Texto
End Sub

Public Sub MascaraTelefono (new As String) As String
	Dim d As String = Utils.SoloDigitos(new)
	If d.Length > Utils.LARGO_TELEFONO Then d = d.SubString2(0, Utils.LARGO_TELEFONO)
	If d.Length > 4 Then Return d.SubString2(0, 4) & "-" & d.SubString(4)
	Return d
End Sub

Public Sub MascaraTelefonoExt (Texto As String) As String
	Dim d As String = Utils.SoloDigitos(Texto)
	If d.Length > Utils.LARGO_TELEFONO_EXT Then d = d.SubString2(0, Utils.LARGO_TELEFONO_EXT)
	Dim res As String = d
	If d.Length > 4 Then res = d.SubString2(0, 4) & "-" & d.SubString2(4, Min(8, d.Length))
	If d.Length > 8 Then res = res & " ext " & d.SubString(8)
	Return res
End Sub
#End Region

#Region Validación al salir del campo
Public Sub EventoCambioFocusText(Remitente As Object)As Boolean
	Dim et As EditText = UI.RetornarTextField(Remitente)
	If et = Null Then Return True
	If Utils.EstaVacio(et.text) Then Return False

	Dim t As String=obtenerTag(et)
	Dim mascara As Int = Enmascarar(t)
	Dim texto As String = et.text

	Select mascara
		Case MASCARA_TELEFONO
			Return Marcar(Remitente, Validacion.EsTelefono(Utils.Normalizar(texto)), Utils.HINT_TELEFONO, Utils.HINT_ERROR)
		Case MASCARA_TELEFONO_EXT
			Return Marcar(Remitente, Validacion.EsTelefonoExt(Utils.Normalizar(texto)), Utils.HINT_TELEFONO_EXT, Utils.HINT_ERROR)
		Case MASCARA_IDENT_FISICA
			Return Marcar(Remitente, Validacion.EsIdentificacion(mascara, Utils.Normalizar(texto)), Utils.HINT_CEDULA, Utils.HINT_FORMATO)
		Case MASCARA_IDENT_JURIDICA
			Return Marcar(Remitente, Validacion.EsIdentificacion(mascara, Utils.Normalizar(texto)), Utils.HINT_CEDULA_JURIDICA, Utils.HINT_FORMATO)
		Case MASCARA_IDENT_DIMEX
			Return Marcar(Remitente, Validacion.EsIdentificacion(mascara, Utils.Normalizar(texto)), Utils.HINT_CEDULA_DIMEX, Utils.HINT_FORMATO)
		Case MASCARA_EMAIL
			Return Marcar(Remitente, Validacion.EsCorreo(Utils.NormalizarCorreo(texto)), Utils.HINT_CORREO, Utils.HINT_ERROR)
		Case MASCARA_NOMBRE
			Return Marcar(Remitente, Validacion.EsTexto(texto), "", Utils.HINT_TEXTO_INVALIDO)
	End Select

	Return False
End Sub

Private Sub Marcar (Remitente As Object, Valido As Boolean, AyudaNormal As String, AyudaError As String) As Boolean
	If Valido Then
		UI.MarcarNormal(Remitente, AyudaNormal)
	Else
		UI.MarcarError(Remitente, AyudaError)
	End If
	Return Valido
End Sub
#End Region
