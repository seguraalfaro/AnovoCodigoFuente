B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Punto unico para pedir una sincronizacion desde las paginas: arranca el servicio solo
' con sesion iniciada, con algo por subir y si no esta corriendo ya.
Sub Process_Globals
	Public Const PERMISO_AVISOS As String = "android.permission.POST_NOTIFICATIONS"
End Sub

Public Sub Pedir
	If Sesion.Iniciada = False And LlaveDispositivo.HayLlave = False Then Return
	If ServicioSincronizacion.Corriendo Then Return
	If DbSync.Pendientes = 0 Then Return
	StartService(ServicioSincronizacion)
End Sub

Public Sub Forzar
	If Sesion.Iniciada = False And LlaveDispositivo.HayLlave = False Then Return
	DbSync.ReintentarTodo
	Pedir
End Sub

Public Sub getEnCurso As Boolean
	Return ServicioSincronizacion.Corriendo
End Sub
