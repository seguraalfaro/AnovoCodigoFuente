B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Punto unico para pedir una sincronizacion desde las paginas. Forzar (el boton) siempre sube y
' baja; Pedir (al abrir o guardar) arranca si hay algo por subir o si paso un rato desde la ultima.
Sub Process_Globals
	Public Const PERMISO_AVISOS As String = "android.permission.POST_NOTIFICATIONS"
	Private Const MINUTOS_ENTRE_BAJADAS As Int = 10
	Private ultimoArranque As Long
End Sub

Public Sub Pedir
	If PuedeArrancar = False Then Return
	If DbSync.Pendientes = 0 And DateTime.Now - ultimoArranque < MINUTOS_ENTRE_BAJADAS * DateTime.TicksPerMinute Then Return
	Arrancar
End Sub

Public Sub Forzar
	If PuedeArrancar = False Then Return
	DbSync.ReintentarTodo
	Arrancar
End Sub

Public Sub getEnCurso As Boolean
	Return ServicioSincronizacion.Corriendo
End Sub

Private Sub PuedeArrancar As Boolean
	If Sesion.Iniciada = False And LlaveDispositivo.HayLlave = False Then Return False
	Return ServicioSincronizacion.Corriendo = False
End Sub

Private Sub Arrancar
	ultimoArranque = DateTime.Now
	StartService(ServicioSincronizacion)
End Sub
