B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' ============================================================
'  Formato — da formato al texto mientras se escribe, y rutea la
'  validacion al perder el foco. Sin UI propia: solo toca el EditText
'  del B4XFloatTextField que dispara el evento.
'
'  El campo se reconoce por el Tag del Designer (Utils.TAG_*), no por
'  el nombre. Las funciones de mascara son puras: se prueban sin
'  interfaz y las reusa Validacion.
' ============================================================
Sub Process_Globals
	Private MascaraEnCurso As Boolean

	'Tipo de identificacion activo cuando el campo es generico (un solo
	'campo con el combo al lado). Lo escribe SetTipoIdentificacion.
	

	Public Const MASCARA_NINGUNA        As Int = 0
	Public Const MASCARA_TELEFONO       As Int = 1
	Public Const MASCARA_TELEFONO_EXT   As Int = 2
	Public Const MASCARA_IDENT          As Int = 3   'para implementar
	Public Const MASCARA_EMAIL          As Int = 4
	Public Const MASCARA_MONTO          As Int = 5
	Public Const MASCARA_IDENT_JURIDICA As Int = 6
	Public Const MASCARA_IDENT_FISICA   As Int = 7
	Public Const MASCARA_IDENT_DIMEX    As Int = 8
	Public MascaraTipoIdent As Int = MASCARA_IDENT_FISICA
End Sub

#Region Evento de Entrada
'Traduce el ItemIndex de Utils.TiposIdent al vocabulario de mascaras.
'El orden del combo es cosa de la pantalla y no debe ser el contrato.
Public Sub SetTipoIdentificacion (indice As Int, Campo As B4XFloatTextField)
	Select indice
		Case 1
			MascaraTipoIdent = MASCARA_IDENT_FISICA
		Case 2
			MascaraTipoIdent = MASCARA_IDENT_JURIDICA
		Case 3
			MascaraTipoIdent = MASCARA_IDENT_DIMEX
		Case Else
			MascaraTipoIdent = MASCARA_NINGUNA
	End Select

	If Campo.IsInitialized = False Then Return
	MascaraEnCurso = True
	Campo.Text = ""
	MascaraEnCurso = False
	UI.ConfigurarIdentificacion(Campo, MascaraTipoIdent)

End Sub

public Sub EventoCambioText(Remitente As Object ,Old As String, New As String)
	If MascaraEnCurso Then Return

	Dim campo As B4XFloatTextField = Remitente
	Dim et As EditText = campo.TextField

	Dim t As String=obtenerTag(et)
	If t = "" Then Return

	Dim mascara As Int = Enmascarar(t)
	Dim nuevo As String = RevisarMarcara(mascara,New)
	If New  <> nuevo Then
		'Asignar .Text vuelve a disparar el evento: de ahi la bandera.
		MascaraEnCurso = True
		et.Text = nuevo
		et.SelectionStart = nuevo.Length
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
		Case MASCARA_TELEFONO
			Return MascaraTelefono(New)
		Case MASCARA_TELEFONO_EXT
			Return MascaraTelefonoExt(New)
		Case MASCARA_IDENT_JURIDICA, MASCARA_IDENT_FISICA, MASCARA_IDENT_DIMEX
			Return MascaraIdentificacion(New, Tipo)
		Case MASCARA_IDENT
			Return MascaraIdentificacion(New, MascaraTipoIdent)
	End Select
	'Email y sin mascara no transforman: devolver New o el campo se vacia al escribir.
	Return New
End Sub

'El orden importa: los tags mas largos van primero porque los cortos los contienen.
Private Sub Enmascarar (t As String) As Int
	If t.Contains(Utils.TAG_FTF_TELEFONO_EXT)    Then Return MASCARA_TELEFONO_EXT
	If t.Contains(Utils.TAG_FTF_TELEFONO)        Then Return MASCARA_TELEFONO
	If t.Contains(Utils.TAG_FTF_MONTO)           Then Return MASCARA_MONTO
	If t.Contains(Utils.TAG_FTF_IDENT_TODAS)     Then Return MASCARA_IDENT
	If t.Contains(Utils.TAG_FTF_CEDULA_JURIDICA) Then Return MASCARA_IDENT_JURIDICA
	If t.Contains(Utils.TAG_FTF_CEDULA_DIMEX)    Then Return MASCARA_IDENT_DIMEX
	If t.Contains(Utils.TAG_FTF_CEDULA)   Then Return MASCARA_IDENT_FISICA
	If t.Contains(Utils.TAG_FTF_EMAIL)           Then Return MASCARA_EMAIL
	Return MASCARA_NINGUNA
End Sub
#End Region

#Region Mascaras
'Publicas y puras: se prueban sin interfaz y las reusa Validacion.
Public Sub MascaraIdentificacion (Texto As String, Tipo As Int) As String
	Select Tipo
		Case MASCARA_IDENT_JURIDICA
			'El consecutivo juridico pasa a alfanumerico (3-101-A00001) a finales 2026
			'por eso aqui no se filtran solo digitos.
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

#Region ValidacioLinea
'Normaliza segun el campo: SoloAlfanum se come la arroba y el punto,
'asi que el correo va por NormalizarCorreo o ninguna validacion pasa.
Public Sub EventoCambioFocusText(Remitente As Object)As Boolean
	Dim campo As B4XFloatTextField = Remitente
	Dim et As EditText = campo.TextField
	If Utils.EstaVacio(et.text) Then Return False

	Dim t As String=obtenerTag(et)
	Dim mascara As Int = Enmascarar(t)
	Dim texto As String = et.text

	Select mascara
		Case MASCARA_TELEFONO
			Return Validacion.RevisarTelefono(Utils.Normalizar(texto), Remitente)
		Case MASCARA_TELEFONO_EXT
			Return Validacion.RevisarTelefonoExt(Utils.Normalizar(texto), Remitente)
		Case MASCARA_IDENT_JURIDICA, MASCARA_IDENT_FISICA, MASCARA_IDENT_DIMEX
			Return Validacion.RevisarIdentificacion(mascara, Utils.Normalizar(texto), Remitente)
		Case MASCARA_IDENT
			Return Validacion.RevisarIdentificacion(MascaraTipoIdent, Utils.Normalizar(texto), Remitente)
		Case MASCARA_EMAIL
			Return Validacion.RevisarCorreo(Utils.NormalizarCorreo(texto), Remitente)
	End Select

	Return False
End Sub
#End Region
