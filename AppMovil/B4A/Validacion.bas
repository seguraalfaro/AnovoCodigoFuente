B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
'Code module: Validar
'Validaciones reutilizables. Sin dependencias de UI ni de base de datos.
'Devuelven True cuando el valor es valido.
Sub Process_Globals
	
End Sub

Public Sub TextoMinimo (Valor As String, Minimo As Int) As Boolean
	Return Valor.Trim.Length >= Minimo
End Sub

Public Sub Vacio (Valor As String) As Boolean
	Return Valor.Trim.Length > 0
End Sub

'Al menos uno de los dos con contenido.
Public Sub AlgunoConValor (A As String, B As String) As Boolean
	Return A.Trim <> "" Or B.Trim <> ""
End Sub
'https://www.b4x.com/android/forum/threads/%E2%9C%85-validate-a-correctly-formatted-email-address.39803/
Public Sub Correo (EmailAddress As String) As Boolean
	Dim MatchEmail As Matcher = Regex.Matcher("^(?i)[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])$", EmailAddress)
  If MatchEmail.Find = True Then
		Return True
	Else
		Return False
	End If
End Sub

Public Sub RevisarTelefono(texto As String,Campo As B4XFloatTextField)As Boolean
	If texto.Length< Utils.LARGO_TELEFONO Then
		UI.CampoError(Campo,Utils.HINT_ERROR)
		Return False
	Else
		UI.CampoNormal(Campo,Utils.HINT_TELEFONO)
		Return True
	End If
	
End Sub
Public Sub RevisarTelefonoExt(texto As String, Campo As B4XFloatTextField)As Boolean
	If texto.Length< Utils.LARGO_TELEFONO Then
		UI.CampoError(Campo,Utils.HINT_ERROR)
		Return False
	Else
		UI.CampoNormal(Campo,Utils.HINT_TELEFONO_EXT)
		Return True
	End If
	'pendiente implementar para largo de extension
End Sub
Public Sub RevisarIdentificacion(Tipo As Int,texto As String, Campo As B4XFloatTextField)As Boolean
	Select Tipo
		Case 0
			If texto.Length< Utils.LARGO_IDENT_FISICA Then
				UI.CampoError(Campo,Utils.HINT_FORMATO)
				Return False
			Else
				UI.CampoNormal(Campo,Utils.HINT_CEDULA)
				Return True
			End If
		Case 1
			If texto.Length< Utils.LARGO_IDENT_JURIDICA Then
				UI.CampoError(Campo,Utils.HINT_FORMATO)
				Return False
			Else
				UI.CampoNormal(Campo,Utils.HINT_CEDULA_JURIDICA)
				Return True
			End If
			
		Case 2
			If texto.Length< Utils.LARGO_IDENT_DIMEX_MIN Then
				UI.CampoError(Campo,Utils.HINT_FORMATO)
				Return False
			Else
				UI.CampoNormal(Campo,Utils.HINT_CEDULA_DIMEX)
				Return True
			End If
		
		
	End Select
	Return False
End Sub