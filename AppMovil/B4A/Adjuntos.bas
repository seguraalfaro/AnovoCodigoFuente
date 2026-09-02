B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	Private xui As XUI 'ignore

	Public Const MAX_FOTOS  As Int = 20
	Public Const ANCHO_FOTO As Int = 1600
	Public Const ANCHO_MINI As Int = 128
	Public Const CALIDAD    As Int = 85

	Type Foto (Archivo As String, Miniatura As String, Sincronizada As Boolean)

	'--- deteccion de camaras ---
	Public Const ESTADO_OK           As String = "ok"
	Public Const ESTADO_SIN_HARDWARE As String = "sin_hardware"
	Public Const ESTADO_BLOQUEADO    As String = "bloqueado"
	Public Const ESTADO_DENEGADO     As String = "denegado"
	Public Const ESTADO_FALLO        As String = "fallo"

	Private hayTrasera, hayFrontal, detectadas As Boolean
End Sub

'El hardware no cambia mientras el proceso vive: se consulta una sola vez
'y el resultado queda cacheado. No requiere permiso de camara.
Private Sub DetectarCamaras
	If detectadas Then Return
	detectadas = True

	Try
		Dim cam As JavaObject
		cam.InitializeStatic("android.hardware.Camera")
		Dim infoClase As JavaObject
		infoClase.InitializeStatic("android.hardware.Camera$CameraInfo")
		Dim FACING_FRONT As Int = infoClase.GetField("CAMERA_FACING_FRONT")

		Dim n As Int = cam.RunMethod("getNumberOfCameras", Null)
		For i = 0 To n - 1
			Dim info As JavaObject
			info.InitializeNewInstance("android.hardware.Camera$CameraInfo", Null)
			cam.RunMethod("getCameraInfo", Array(i, info))
			Dim facing As Int = info.GetField("facing")
			If facing = FACING_FRONT Then
				hayFrontal = True
			Else
				hayTrasera = True
			End If
		Next
	Catch
		Log("DetectarCamaras: " & LastException.Message)
		DetectarPorFeatures
	End Try

	Log($"Camaras -> trasera: ${hayTrasera}, frontal: ${hayFrontal}"$)
End Sub

'Respaldo por si getNumberOfCameras falla. Las features son metadatos que
'declara el fabricante, menos fiables que consultar el HAL, pero sirven
'para no quedarse sin dato.
Private Sub DetectarPorFeatures
	Try
		Dim ctx As JavaObject
		ctx.InitializeContext
		Dim pm As JavaObject = ctx.RunMethod("getPackageManager", Null)
		hayTrasera = pm.RunMethod("hasSystemFeature", Array("android.hardware.camera"))
		hayFrontal = pm.RunMethod("hasSystemFeature", Array("android.hardware.camera.front"))

		'Equipos que solo declaran la generica: se asume trasera.
		If Not(hayTrasera) And Not(hayFrontal) Then
			hayTrasera = pm.RunMethod("hasSystemFeature", Array("android.hardware.camera.any"))
		End If
	Catch
		Log("DetectarPorFeatures: " & LastException.Message)
		hayTrasera = True     'ante la duda, que decida CamEx_Ready
	End Try
End Sub

Public Sub getTieneCamara As Boolean
	DetectarCamaras
	Return hayTrasera Or hayFrontal
End Sub

Public Sub getPuedeRotar As Boolean
	DetectarCamaras
	Return hayTrasera And hayFrontal
End Sub

Public Sub getHayTrasera As Boolean
	DetectarCamaras
	Return hayTrasera
End Sub

Public Sub getHayFrontal As Boolean
	DetectarCamaras
	Return hayFrontal
End Sub

'Distingue un permiso simplemente denegado de uno bloqueado de forma
'permanente ("no volver a preguntar").
'PRECONDICION: llamar solo DESPUES de una denegacion. Antes de la primera
'solicitud tambien devuelve True y daria un falso positivo.
Public Sub PermisoBloqueado (permiso As String) As Boolean
	Try
		Dim ctx As JavaObject
		ctx.InitializeContext
		Return Not(ctx.RunMethod("shouldShowRequestPermissionRationale", Array(permiso)))
	Catch
		Log("PermisoBloqueado: " & LastException.Message)
		Return False
	End Try
End Sub