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

'Cedula fisica 9 digitos, juridica 10. Solo cuenta digitos, asi que
'acepta con o sin guiones, que es como la escribe la gente.
Public Sub Identificacion (Valor As String) As Boolean
	Dim n As Int = 0
	For i = 0 To Valor.Length - 1
		Dim c As String = Valor.CharAt(i)
		If c >= "0" And c <= "9" Then n = n + 1
	Next
	Return n = 9 Or n = 10
End Sub

'Solo comprueba que haya digitos suficientes. En campo aparecen
'extensiones y celulares escritos de cualquier forma, y rechazar un
'telefono valido molesta mas que aceptar uno mal escrito.
Public Sub Telefono (Valor As String) As Boolean
	If Valor.Trim = "" Then Return False
	Dim n As Int = 0
	For i = 0 To Valor.Length - 1
		Dim c As String = Valor.CharAt(i)
		If c >= "0" And c <= "9" Then n = n + 1
	Next
	Return n >= 8
End Sub