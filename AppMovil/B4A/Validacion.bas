B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Reglas de validacion puras: reciben texto y devuelven True si es valido.
' Pintar el campo en rojo o normal es de UI y de Formato, no de aqui.
Sub Process_Globals
	Public Const PATRON_CORREO As String = "(?i)[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])"
End Sub

Public Sub EsCorreo (Texto As String) As Boolean
	Return Regex.Matcher(PATRON_CORREO, Texto).Find
End Sub

Public Sub EsTelefono (Texto As String) As Boolean
	Return Texto.Length >= Utils.LARGO_TELEFONO
End Sub

Public Sub EsTelefonoExt (Texto As String) As Boolean
	Return Texto.Length >= Utils.LARGO_TELEFONO
End Sub

Public Sub EsIdentificacion (Mascara As Int, Texto As String) As Boolean
	Select Mascara
		Case Formato.MASCARA_IDENT_FISICA
			Return Texto.Length >= Utils.LARGO_IDENT_FISICA
		Case Formato.MASCARA_IDENT_JURIDICA
			Return Texto.Length >= Utils.LARGO_IDENT_JURIDICA
		Case Formato.MASCARA_IDENT_DIMEX
			Return Texto.Length >= Utils.LARGO_IDENT_DIMEX_MIN
	End Select
	Return False
End Sub

Public Sub Consentimiento (p As Consentimiento) As String
	If p.Version = "" Then Return Mensajes.SIN_TEXTO_PERMISO
	If p.Acepta = False Then Return Mensajes.FALTA_ACEPTAR
	If p.Firma.Length = 0 Then Return Mensajes.FALTA_FIRMA
	If p.Firmante = "" Then Return Mensajes.FALTA_FIRMANTE
	If EsIdentificacion(Formato.MASCARA_IDENT_FISICA, p.CedulaFirmante) = False And _
		EsIdentificacion(Formato.MASCARA_IDENT_DIMEX, p.CedulaFirmante) = False Then Return Mensajes.FALTA_CEDULA_FIRMANTE
	Return ""
End Sub

Public Sub EsTexto (Texto As String) As Boolean
	Dim s As String = Texto.Trim
	Return s.Length >= Utils.LARGO_MINIMO_TEXTO And Utils.ProporcionVocales(s) >= Utils.VOCALES_MINIMO
End Sub
