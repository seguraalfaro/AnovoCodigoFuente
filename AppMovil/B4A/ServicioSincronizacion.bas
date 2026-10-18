B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=13.7
@EndOfDesignText@
' Servicio en primer plano de tipo dataSync: aloja al Sincronizador para que la subida
' termine aunque el asesor salga de la app. Se arranca siempre con la app abierta.
#Region  Service Attributes
	#StartAtBoot: False
#End Region

Sub Process_Globals
	Private Const ID_AVISO As Int = 41
	Private Const ID_RESULTADO As Int = 42
	Private Const PAGINA_TERMINADA As String = "SincronizacionTerminada"
	Private motor As Sincronizador
	Public Corriendo As Boolean
	Public Ultimo As ResumenSync
End Sub

#Region Ciclo del servicio
Sub Service_Create
	motor.Initialize
End Sub

Sub Service_Start (StartingIntent As Intent)
	If Corriendo Then Return
	Corriendo = True
	Service.StartForeground(ID_AVISO, Aviso(Mensajes.SYNC_SUBIENDO, False))
	Correr
End Sub

Private Sub Correr
	Wait For (motor.Ejecutar) Complete (Resultado As ResumenSync)
	Ultimo = Resultado
	Corriendo = False
	Service.StopForeground(ID_AVISO)
	If Resultado.ConError > 0 Or Resultado.SesionVencida Then Aviso(Resultado.Mensaje, True).Notify(ID_RESULTADO)
	Avisar(Resultado)
	StopService(Me)
End Sub

Sub Service_Timeout (Params As Map)
	Corriendo = False
	Service.StopForeground(ID_AVISO)
	StopService(Me)
End Sub

Sub Service_Destroy
End Sub
#End Region

#Region Avisos
Private Sub Avisar (Resultado As ResumenSync)
	If Resultado.SesionVencida Then
		Api.VolverAlIngreso(Resultado.Mensaje)
		Return
	End If
	Try
		B4XPages.GetManager.RaiseEvent(B4XPages.GetManager.GetTopPage, PAGINA_TERMINADA, Array(Resultado))
	Catch
		Log("ServicioSincronizacion.Avisar: " & LastException.Message)
	End Try
End Sub

Private Sub Aviso (Texto As String, Importante As Boolean) As Notification
	Dim n As Notification
	If Importante Then n.Initialize2(n.IMPORTANCE_DEFAULT) Else n.Initialize2(n.IMPORTANCE_LOW)
	n.Icon = "icon"
	n.AutoCancel = True
	n.SetInfo(Mensajes.SYNC_TITULO, Texto, Main)
	Return n
End Sub
#End Region
