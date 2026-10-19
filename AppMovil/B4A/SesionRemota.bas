B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Sesion con el servidor usando la llave del telefono: registra el telefono al ingresar,
' consigue un token vigente renovando con la llave y trae los permisos. Es clase porque espera respuestas de red.
Sub Class_Globals
	Private Const CAMPO_LLAVE As String = "llave"
	Private Const CAMPO_TOKEN As String = "token"
	Private Const CAMPO_PERMISOS As String = "permisos"
	Private Const MARGEN_SEGUNDOS As Int = 120
End Sub

Public Sub Initialize
End Sub

Public Sub AsegurarSesion As ResumableSub
	If Sesion.VigentePor(MARGEN_SEGUNDOS) Then Return Api.HTTP_OK
	If LlaveDispositivo.HayLlave = False Then Return Api.HTTP_NO_AUTORIZADO
	Wait For (ApiAutenticacion.Renovar(LlaveDispositivo.Uuid, LlaveDispositivo.Leer).Enviar) Complete (Respuesta As RestRespuesta)
	If Respuesta.Success Then
		Dim datos As Map = Respuesta.DatosMap
		If Sesion.Abrir(datos.GetDefault(CAMPO_TOKEN, "")) = False Then Return Api.HTTP_NO_AUTORIZADO
		LlaveDispositivo.Guardar(datos.GetDefault(CAMPO_LLAVE, ""))
		LlaveDispositivo.MarcarContacto
		Return Api.HTTP_OK
	End If
	If Respuesta.StatusCode = Api.HTTP_NO_AUTORIZADO Then LlaveDispositivo.Borrar
	Return Respuesta.StatusCode
End Sub

Public Sub ActualizarPermisos As ResumableSub
	Wait For (ApiSesion.Permisos.Enviar) Complete (Respuesta As RestRespuesta)
	If Respuesta.Success Then
		Dim lista As Object = Respuesta.DatosMap.Get(CAMPO_PERMISOS)
		Dim permisos As List
		permisos.Initialize
		If lista Is List Then permisos.AddAll(lista)
		Sesion.AsignarPermisos(permisos)
	End If
	Return Respuesta
End Sub

Public Sub RegistrarTelefono As ResumableSub
	Wait For (ApiAutenticacion.RegistrarDispositivo(LlaveDispositivo.Uuid, LlaveDispositivo.NombreTelefono).Enviar) Complete (Respuesta As RestRespuesta)
	If Respuesta.Success = False Then
		Log("Registro del telefono: " & Respuesta.StatusCode)
		Return Respuesta.StatusCode
	End If
	Dim datos As Map = Respuesta.DatosMap
	If LlaveDispositivo.Guardar(datos.GetDefault(CAMPO_LLAVE, "")) = False Then Return 0
	Dim nuevo As String = datos.GetDefault(CAMPO_TOKEN, "")
	If nuevo <> "" Then Sesion.Abrir(nuevo)
	Return Api.HTTP_CREADO
End Sub
