B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Mascaras de texto, puras: reciben texto o Tag y devuelven texto, mascara, validez o ayuda.
' El manejo del EditText (escribir, marcar en rojo) esta en UI.
Sub Process_Globals
	Public Const MASCARA_NOMBRE As Int = 0
	Public Const MASCARA_TELEFONO As Int = 1
	Public Const MASCARA_TELEFONO_EXT As Int = 2
	Public Const MASCARA_EMAIL As Int = 4
	Public Const MASCARA_MONTO As Int = 5
	Public Const MASCARA_IDENT_JURIDICA As Int = 6
	Public Const MASCARA_IDENT_FISICA As Int = 7
	Public Const MASCARA_IDENT_DIMEX As Int = 8
End Sub

#Region Mascara segun el Tag
Public Sub MascaraDeTag (t As String) As Int
	If t.Contains(Utils.TAG_FTF_TELEFONO_EXT) Then Return MASCARA_TELEFONO_EXT
	If t.Contains(Utils.TAG_FTF_TELEFONO) Then Return MASCARA_TELEFONO
	If t.Contains(Utils.TAG_FTF_MONTO) Then Return MASCARA_MONTO
	If t.Contains(Utils.TAG_FTF_CEDULA_JURIDICA) Then Return MASCARA_IDENT_JURIDICA
	If t.Contains(Utils.TAG_FTF_CEDULA_DIMEX) Then Return MASCARA_IDENT_DIMEX
	If t.Contains(Utils.TAG_FTF_CEDULA) Then Return MASCARA_IDENT_FISICA
	If t.Contains(Utils.TAG_FTF_EMAIL) Then Return MASCARA_EMAIL
	Return MASCARA_NOMBRE
End Sub

Public Sub TagIdentificacion (Indice As Int) As String
	Select Indice
		Case 0
			Return Utils.TAG_FTF_CEDULA
		Case 1
			Return Utils.TAG_FTF_CEDULA_JURIDICA
		Case 2
			Return Utils.TAG_FTF_CEDULA_DIMEX
	End Select
	Return Utils.TAG_FTF_NOMBRE
End Sub

Public Sub TagIdentificacionEn (t As String) As String
	If t.Contains(Utils.TAG_FTF_CEDULA_JURIDICA) Then Return Utils.TAG_FTF_CEDULA_JURIDICA
	If t.Contains(Utils.TAG_FTF_CEDULA_DIMEX) Then Return Utils.TAG_FTF_CEDULA_DIMEX
	If t.Contains(Utils.TAG_FTF_CEDULA) Then Return Utils.TAG_FTF_CEDULA
	Return ""
End Sub
#End Region

#Region Mascaras
Public Sub Aplicar (Mascara As Int, Texto As String) As String
	Select Mascara
		Case MASCARA_TELEFONO
			Return MascaraTelefono(Texto)
		Case MASCARA_TELEFONO_EXT
			Return MascaraTelefonoExt(Texto)
		Case MASCARA_IDENT_JURIDICA, MASCARA_IDENT_FISICA, MASCARA_IDENT_DIMEX
			Return MascaraIdentificacion(Texto, Mascara)
	End Select
	Return Texto
End Sub

Public Sub MascaraIdentificacion (Texto As String, Tipo As Int) As String
	Select Tipo
		Case MASCARA_IDENT_JURIDICA
			Dim s As String = Utils.SoloJuridica(Texto)
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

Public Sub MascaraTelefono (Texto As String) As String
	Dim d As String = Utils.SoloDigitos(Texto)
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

#Region Validez y ayudas
Public Sub EsValido (Mascara As Int, Texto As String) As Boolean
	Select Mascara
		Case MASCARA_TELEFONO
			Return Validacion.EsTelefono(Utils.Normalizar(Texto))
		Case MASCARA_TELEFONO_EXT
			Return Validacion.EsTelefonoExt(Utils.Normalizar(Texto))
		Case MASCARA_IDENT_FISICA, MASCARA_IDENT_JURIDICA, MASCARA_IDENT_DIMEX
			Return Validacion.EsIdentificacion(Mascara, Utils.Normalizar(Texto))
		Case MASCARA_EMAIL
			Return Validacion.EsCorreo(Utils.NormalizarCorreo(Texto))
		Case MASCARA_NOMBRE
			Return Validacion.EsTexto(Texto)
	End Select
	Return False
End Sub

Public Sub AyudaNormal (Mascara As Int) As String
	Select Mascara
		Case MASCARA_TELEFONO
			Return Utils.HINT_TELEFONO
		Case MASCARA_TELEFONO_EXT
			Return Utils.HINT_TELEFONO_EXT
		Case MASCARA_IDENT_FISICA
			Return Utils.HINT_CEDULA
		Case MASCARA_IDENT_JURIDICA
			Return Utils.HINT_CEDULA_JURIDICA
		Case MASCARA_IDENT_DIMEX
			Return Utils.HINT_CEDULA_DIMEX
		Case MASCARA_EMAIL
			Return Utils.HINT_CORREO
	End Select
	Return ""
End Sub

Public Sub AyudaError (Mascara As Int) As String
	Select Mascara
		Case MASCARA_IDENT_FISICA, MASCARA_IDENT_JURIDICA, MASCARA_IDENT_DIMEX
			Return Utils.HINT_FORMATO
		Case MASCARA_NOMBRE
			Return Utils.HINT_TEXTO_INVALIDO
	End Select
	Return Utils.HINT_ERROR
End Sub
#End Region
