B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@

'Code module: Validar
'Validaciones reutilizables. Sin dependencias de UI ni de base de datos.
'Devuelven True cuando el valor es valido.
'
'El campo llega como Object y no como B4XFloatTextField: desde que los EditText
'sueltos del Designer comparten el evento unificado, el remitente puede ser el
'custom view o el EditText pelado. Por eso se pinta con UI.MarcarError y
'UI.MarcarNormal, que resuelven el tipo solos, y no con CampoError/CampoNormal,
'que dan por hecho el flotante y revientan con el suelto.
Sub Process_Globals
	'RFC 5322 simplificada. No valida que el dominio exista, solo la forma.
	Public Const PATRON_CORREO As String = "(?i)[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])"
	Public Const TAG_OBLIGATORIO As String = "_oblig"

End Sub

Public Sub TextoMinimo (Valor As String, Minimo As Int) As Boolean
	Return Valor.Trim.Length >= Minimo
End Sub


'Al menos uno de los dos con contenido.
Public Sub AlgunoConValor (A As String, B As String) As Boolean
	Return A.Trim <> "" Or B.Trim <> ""
End Sub

Public Sub RevisarCorreo (texto As String, Campo As Object) As Boolean
	Dim m As Matcher = Regex.Matcher(PATRON_CORREO, texto)
	If m.Find Then
		UI.MarcarNormal(Campo, Utils.HINT_CORREO)
		Return True
	Else
		UI.MarcarError(Campo, Utils.HINT_ERROR)
		Return False
	End If
End Sub

Public Sub RevisarTelefono(texto As String,Campo As Object)As Boolean
	If texto.Length< Utils.LARGO_TELEFONO Then
		UI.MarcarError(Campo,Utils.HINT_ERROR)
		Return False
	Else
		UI.MarcarNormal(Campo,Utils.HINT_TELEFONO)
		Return True
	End If
	
End Sub
Public Sub RevisarTelefonoExt(texto As String, Campo As Object)As Boolean
	If texto.Length< Utils.LARGO_TELEFONO Then
		UI.MarcarError(Campo,Utils.HINT_ERROR)
		Return False
	Else
		UI.MarcarNormal(Campo,Utils.HINT_TELEFONO_EXT)
		Return True
	End If
	'pendiente implementar para largo de extension
End Sub
Public Sub RevisarIdentificacion(Tipo As Int,texto As String, Campo As Object)As Boolean
	Select Tipo
		Case Formato.MASCARA_IDENT_FISICA
			If texto.Length< Utils.LARGO_IDENT_FISICA Then
				UI.MarcarError(Campo,Utils.HINT_FORMATO)
				Return False
			Else
				UI.MarcarNormal(Campo,Utils.HINT_CEDULA)
				Return True
			End If
		Case Formato.MASCARA_IDENT_JURIDICA
			If texto.Length< Utils.LARGO_IDENT_JURIDICA Then
				UI.MarcarError(Campo,Utils.HINT_FORMATO)
				Return False
			Else
				UI.MarcarNormal(Campo,Utils.HINT_CEDULA_JURIDICA)
				Return True
			End If
			
		Case Formato.MASCARA_IDENT_DIMEX
			If texto.Length< Utils.LARGO_IDENT_DIMEX_MIN Then
				UI.MarcarError(Campo,Utils.HINT_FORMATO)
				Return False
			Else
				UI.MarcarNormal(Campo,Utils.HINT_CEDULA_DIMEX)
				Return True
			End If
		
		
	End Select
	Return False
End Sub

'Sin hint explicito: al flotante se le repone el que le toca por el tag y al
'EditText suelto se le respeta el que trae del Designer o de ConfigurarMemo.
Public Sub RevisarTexto (Texto As String, Campo As Object) As Boolean
	Dim s As String = Texto.Trim
	Dim ok As Boolean = (s.Length >= Utils.LARGO_MINIMO_TEXTO) And _
		(Utils.ProporcionVocales(s) >= Utils.VOCALES_MINIMO)

	If ok Then
		UI.MarcarNormal(Campo)
	Else
		UI.MarcarError(Campo, Utils.HINT_TEXTO_INVALIDO)
	End If
	Return ok
End Sub

Public Sub ValidarFormulario (Padre As B4XView) As Boolean
	Dim ok As Boolean = True
	For Each v As B4XView In Padre.GetAllViewsRecursive
		If Obligatorio(v) = False Then Continue
		
		Dim o As Object = v
		Dim vacio As Boolean

		If o Is EditText Then
			vacio  = Utils.EstaVacio(v.Text)
		Else If o Is Spinner Then
			'El item guia ocupa la posicion 0: ahi el combo cuenta como vacio
			Dim sp As Spinner = v
			vacio =Utils.EstaVacio (sp.SelectedItem)
		Else If o Is CheckBox Then
			Dim cb As CheckBox = v
			vacio = (cb.Checked = False)
		Else
			Continue
		End If
		If vacio Then
			ok = False
			UI.MarcarError(v)
		Else
			UI.MarcarNormal(v)
		End If
	Next
	Return ok
End Sub

Private Sub Obligatorio (v As B4XView) As Boolean
	Dim t As String = UI.TagDelPadre(v)
	If t = "" Then t = UI.ObtenerTag(v)
	Return t.Contains(TAG_OBLIGATORIO)
End Sub
