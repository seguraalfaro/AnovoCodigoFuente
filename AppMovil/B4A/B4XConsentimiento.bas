B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Firma del consentimiento de un cliente ya registrado, pendiente o revocado, en pantalla propia.
' Layout PageConsentimiento: el bloque del paso 3 del registro con Cancelar y Guardar firma abajo.

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private presentador As PresentadorConsentimiento
	Private scvtexto As ScrollView
	Private CkAcepto As CheckBox
	Private Cbfirmante As B4XComboBox
	Private TextCedulaConsentimiento As B4XFloatTextField
	Private SignPad As SignPad
	Private BtnCancelarFirma, BtnGuardarFirma As B4XView
	Private HayFirma As Boolean
	Private visible As Boolean
	Private Const MARGEN_TEXTO As Int = 8dip
End Sub

Public Sub Initialize As Object
	presentador.Initialize
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageConsentimiento")
	B4XPages.SetTitle(Me, Mensajes.TITULO_FIRMAR_CONSENTIMIENTO)
	BtnCancelarFirma.Text = Mensajes.CANCELAR
	BtnGuardarFirma.Text = Mensajes.GUARDAR_FIRMA
	UI.AplicarTema(Root)
End Sub

Public Sub Mostrar (c As Cliente)
	presentador.Cargar(c)
End Sub

Private Sub B4XPage_Appear
	visible = True
	CkAcepto.Checked = False
	TextCedulaConsentimiento.Text = ""
	SignPad.clear
	HayFirma = False
	UI.PintarTextoLargo(scvtexto, Mensajes.CuerpoPermiso(presentador.TextoPermiso), MARGEN_TEXTO)
	Cbfirmante.SetItems(presentador.Firmantes)
	Cbfirmante.SelectedIndex = 0
End Sub

Private Sub B4XPage_Disappear
	visible = False
End Sub

Private Sub BtnCancelarFirma_Click
	If HayFirma Or CkAcepto.Checked Or TextCedulaConsentimiento.Text.Trim <> "" Then
		Dim sf As Object = xui.Msgbox2Async(Mensajes.DESCARTAR_FIRMA, Mensajes.TITULO, Mensajes.SI, "", Mensajes.NO, Null)
		Wait For (sf) Msgbox_Result (Respuesta As Int)
		If visible = False Then Return
		If Respuesta <> xui.DialogResponse_Positive Then Return
	End If
	B4XPages.ClosePage(Me)
End Sub

Private Sub BtnGuardarFirma_Click
	Dim r As Resultado = presentador.Guardar(LeerPermiso)
	If r.Ok = False Then
		xui.MsgboxAsync(r.Mensaje, Mensajes.TITULO)
		Return
	End If
	Sincronizacion.Pedir
	xui.MsgboxAsync(Mensajes.CONSENTIMIENTO_GUARDADO, Mensajes.TITULO)
	Wait For Msgbox_Result (Boton As Int)
	If visible = False Then Return
	B4XPages.ClosePage(Me)
End Sub

Private Sub LeerPermiso As Consentimiento
	Dim p As Consentimiento = Tipos.ConsentimientoVacio
	p.Acepta = CkAcepto.Checked
	If Cbfirmante.Size > 0 Then p.Firmante = Cbfirmante.SelectedItem.Trim
	p.CedulaFirmante = TextCedulaConsentimiento.Text.Trim
	If HayFirma Then p.Firma = extDBUtils.Image2Blob(SignPad.TransparentSignatureBitmap, True)
	Return p
End Sub

Private Sub SignPad_onSigned (sign As Object)
	HayFirma = True
End Sub

Private Sub lblBorrar_Click
	SignPad.clear
	HayFirma = False
End Sub
