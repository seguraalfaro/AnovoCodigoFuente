B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Sesion con el servidor usando la llave del telefono: registra el telefono al ingresar y
' consigue un token vigente renovando con la llave. Es clase porque espera respuestas de red.
Sub Class_Globals
	Private Const CAMPO_LLAVE As String = "llave"
	Private Const CAMPO_TOKEN As String = "token"
	Private Const MARGEN_SEGUNDOS As Int = 120
	Public Const ESTADO_OK As Int = 200
	Public Const ESTADO_NO_AUTORIZADO As Int = 401
End Sub

Public Sub Initialize
End Sub

Public Sub AsegurarSesion As ResumableSub
	If Sesion.VigentePor(MARGEN_SEGUNDOS) Then Return ESTADO_OK
	If LlaveDispositivo.HayLlave = False Then Return ESTADO_NO_AUTORIZADO
	Wait For (ApiAutenticacion.Renovar(LlaveDispositivo.Uuid, LlaveDispositivo.Leer).Enviar) Complete (Respuesta As RestRespuesta)
	If Respuesta.Success Then
		Dim datos As Map = Respuesta.DatosMap
		If Sesion.Abrir(datos.GetDefault(CAMPO_TOKEN, "")) = False Then Return ESTADO_NO_AUTORIZADO
		LlaveDispositivo.Guardar(datos.GetDefault(CAMPO_LLAVE, ""))
		LlaveDispositivo.MarcarContacto
		Return ESTADO_OK
	End If
	If Respuesta.StatusCode = ESTADO_NO_AUTORIZADO Then LlaveDispositivo.Borrar
	Return Respuesta.StatusCode
End Sub

Public Sub RegistrarTelefono As ResumableSub
	Wait For (ApiAutenticacion.RegistrarDispositivo(LlaveDispositivo.Uuid, LlaveDispositivo.NombreTelefono).Enviar) Complete (Respuesta As RestRespuesta)
	If Respuesta.Success = False Then
		Log("Registro del telefono: " & Respuesta.StatusCode)
		Return False
	End If
	Return LlaveDispositivo.Guardar(Respuesta.DatosMap.GetDefault(CAMPO_LLAVE, ""))
End Sub
