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

Public Sub RevisarCorreo (texto As String, Campo As B4XFloatTextField) As Boolean
	Dim m As Matcher = Regex.Matcher(PATRON_CORREO, texto)
	If m.Find Then
		UI.CampoNormal(Campo, Utils.HINT_CORREO)
		Return True		
	Else
		UI.CampoError(Campo, Utils.HINT_ERROR)
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

Public Sub RevisarTexto (Texto As String, Campo As B4XFloatTextField) As Boolean
	Dim s As String = Texto.Trim
	Dim ok As Boolean = (s.Length >= Utils.LARGO_MINIMO_TEXTO) And _
		(Utils.ProporcionVocales(s) >= Utils.VOCALES_MINIMO)

	If ok Then
		UI.CampoNormal(Campo, UI.HintPorTag(Campo))
	Else
		UI.CampoError(Campo, Utils.HINT_TEXTO_INVALIDO)
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
			vacio = (sp.SelectedIndex <= 0)
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