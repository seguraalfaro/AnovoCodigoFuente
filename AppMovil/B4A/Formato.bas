B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Private MascaraEnCurso As Boolean
	'0 fisica, 1 juridica, 2 dimex. Lo escribe el combo de la pagina por su propieda itemindex.
	Public MascaraTipoIdent As Int = 0
	

End Sub

#Region Evento de Entrada

public Sub EventoCambioText(Remitente As Object ,Old As String, New As String)
	If MascaraEnCurso Then Return
	
	Dim et As EditText = Remitente
	Dim t As String=obtenerTag(et)
	If t = "" Then Return
	
	Dim mascara As Int = Enmascarar(t)
	Dim nuevo As String = RevisarMarcara(mascara,New)
	If Old  <> nuevo Then
		'Asignar .Text vuelve a disparar el evento: de ahi la bandera.
		MascaraEnCurso = True
		et.Text = New
		et.SelectionStart = New.Length
		MascaraEnCurso = False
	End If
End Sub
Private Sub obtenerTag(et As EditText)As String
	Dim tag As String = UI.TagDelPadre(et)
	If tag = "" Then tag = UI.ObtenerTag(et)     'EditText suelto, sin custom view
	Return tag
End Sub
Private Sub RevisarMarcara(Tipo As Int, New As String)As String
	Select Tipo
		Case 1
			Return	MascaraTelefono(New)
		Case 2
			Return  MascaraTelefonoExt(New)
		Case 3
			Return  MascaraIdentificacion(New,MascaraTipoIdent)		
	End Select
	Return ""
End Sub



'_ftf_telefono_ext va antes que _ftf_telefono porque tambien lo contiene.
Private Sub Enmascarar (t As String) As Int
	If t.Contains("_ftf_telefono_ext") Then Return 1
	If t.Contains("_ftf_telefono")     Then Return 2
	If t.Contains("_ftf_cedulajuridica")       Then Return 3
	If t.Contains("_ftf_cedulajuridica_cedula")       Then Return 3
	If t.Contains("_ftf_cedula")       Then Return 3
	Return 0
End Sub


#End Region Mascaras

'Publicas y puras: se prueban sin interfaz y las reusa Validacion.
Public Sub MascaraIdentificacion (Texto As String, Tipo As Int) As String
	Select Tipo
		Case 0
			'El consecutivo juridico pasa a alfanumerico (3-101-A00001) a finales 2026
			'por eso aqui no se filtran solo digitos.
			Dim s As String = Utils.SoloAlfanum(Texto)
			If s.Length > Utils.LARGO_IDENT_JURIDICA Then s = s.SubString2(0, Utils.LARGO_IDENT_JURIDICA)
			Dim res As String = s
			If s.Length > 1 Then res = s.SubString2(0, 1) & "-" & s.SubString2(1, Min(4, s.Length))
			If s.Length > 4 Then res = res & "-" & s.SubString(4)
			Return res
 
		Case 1
			Dim d As String = Utils.SoloDigitos(Texto)
			If d.Length > Utils.LARGO_IDENT_FISICA Then d = d.SubString2(0, Utils.LARGO_IDENT_FISICA)
			Return d
 
		Case 2
			Dim d As String = Utils.SoloDigitos(Texto)
			If d.Length > Utils.LARGO_IDENT_DIMEX Then d = d.SubString2(0, Utils.LARGO_IDENT_DIMEX)
			Dim res As String = d
			If d.Length > 1 Then res = d.SubString2(0, 1) & "-" & d.SubString2(1, Min(5, d.Length))
			If d.Length > 5 Then res = res & "-" & d.SubString(5)
			Return res
	End Select
	Return ""
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


#Region ValidacioLinea

Public Sub EventoCambioFocusText(Remitente As Object)
	Dim et As EditText = Remitente
	Dim t As String=obtenerTag(et)
	Dim mascara As Int = Enmascarar(t)
	Dim texto As String = Utils.Normalizar(et.text)
	Select mascara
		Case 1
			RevisarTelefono(texto,Remitente)
		Case 2
			RevisarTelefonoExt(texto,Remitente)
		Case 3
			RevisarIdentificacion(texto,Remitente)
	End Select
End Sub

private Sub RevisarTelefono(texto As String,Campo As B4XFloatTextField)
	If texto.Length< Utils.LARGO_TELEFONO Then
		UI.CampoError(Campo,Utils.HINT_ERROR)
	Else	
		UI.CampoNormal(Campo,Utils.HINT_TELEFONO)
	End If
	
End Sub
private Sub RevisarTelefonoExt(texto As String, Campo As B4XFloatTextField)
	If texto.Length< Utils.LARGO_TELEFONO Then
		UI.CampoError(Campo,Utils.HINT_ERROR)
	Else
		UI.CampoNormal(Campo,Utils.HINT_TELEFONO_EXT)
	End If
	'pendiente implementar para largo de extension 
End Sub
Private Sub RevisarIdentificacion(texto As String, Campo As B4XFloatTextField)
	Select MascaraTipoIdent
		Case 0
			If texto.Length< Utils.LARGO_IDENT_FISICA Then
				UI.CampoError(Campo,Utils.HINT_ERROR)
			Else
				UI.CampoNormal(Campo,Utils.HINT_CEDULA)
			End If
		Case 1
			If texto.Length< Utils.LARGO_IDENT_JURIDICA Then
				UI.CampoError(Campo,Utils.HINT_ERROR)
			Else
				UI.CampoNormal(Campo,Utils.HINT_CEDULA_JURIDICA)
			End If
			
		Case 2
			If texto.Length< Utils.LARGO_IDENT_DIMEX_MIN Then
				UI.CampoError(Campo,Utils.HINT_ERROR)
			Else
				UI.CampoNormal(Campo,Utils.HINT_CEDULA_DIMEX)
			End If	
		
		
	End Select
End Sub

#End Region


