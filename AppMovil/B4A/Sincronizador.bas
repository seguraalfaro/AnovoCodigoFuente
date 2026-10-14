B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Sube la cola por unidades y en orden (clientes, solicitudes, fotos). Solo confirma lo que
' el servidor acepto, unidad por unidad; un dato rechazado queda en error y no se reintenta.
Sub Class_Globals
	Private Const ESTADO_CREADO As Int = 201
	Private Const ESTADO_OK As Int = 200
	Private Const ESTADO_NO_AUTORIZADO As Int = 401
	Private Const ESTADO_DEMASIADAS As Int = 429
	Private Const ESTADO_SERVIDOR As Int = 500
	Private mCorriendo As Boolean
	Private remota As SesionRemota
End Sub

Public Sub Initialize
	remota.Initialize
End Sub

Public Sub getCorriendo As Boolean
	Return mCorriendo
End Sub

Public Sub Ejecutar As ResumableSub
	Dim r As ResumenSync
	r.Initialize
	If mCorriendo Then Return r
	mCorriendo = True
	For Each clase As String In Array As String(DbSync.CLASE_CLIENTE, DbSync.CLASE_SOLICITUD, DbSync.CLASE_FOTO)
		For Each u As UnidadSync In DbSync.Listas(clase)
			Wait For (remota.AsegurarSesion) Complete (Estado As Int)
			If Estado = ESTADO_NO_AUTORIZADO Then
				r.SesionVencida = True
				Exit
			End If
			If Estado <> ESTADO_OK Then
				r.SinConexion = True
				Exit
			End If
			Wait For (Enviar(u)) Complete (Respuesta As RestRespuesta)
			If Respuesta.StatusCode = ESTADO_CREADO Or Respuesta.StatusCode = ESTADO_OK Then
				DbSync.Confirmar(u, ApiSincronizacion.IdCreado(Respuesta))
				r.Subidos = r.Subidos + 1
			Else If Respuesta.StatusCode = ESTADO_NO_AUTORIZADO Then
				r.SesionVencida = True
				Exit
			Else If Reintentable(Respuesta.StatusCode) Then
				DbSync.Reprogramar(u)
				r.SinConexion = (Respuesta.StatusCode = 0)
				If r.SinConexion Then Exit
			Else
				DbSync.MarcarError(u, Api.MensajeDe(Respuesta))
				r.ConError = r.ConError + 1
			End If
		Next
		If r.SesionVencida Or r.SinConexion Then Exit
	Next
	r.Pendientes = DbSync.Pendientes
	r.ConError = DbSync.ConError
	r.Mensaje = Resumen(r)
	mCorriendo = False
	Return r
End Sub

Private Sub Enviar (u As UnidadSync) As ResumableSub
	Select u.Clase
		Case DbSync.CLASE_CLIENTE
			Wait For (ApiSincronizacion.SubirCliente(u.Paquete).Enviar) Complete (Respuesta As RestRespuesta)
			Return Respuesta
		Case DbSync.CLASE_SOLICITUD
			Wait For (ApiSincronizacion.SubirSolicitud(u.Paquete).Enviar) Complete (Respuesta As RestRespuesta)
			Return Respuesta
	End Select
	u.Paquete.Put("contenido", Adjuntos.LeerBase64(u.Ruta))
	Wait For (ApiSincronizacion.SubirFoto(u.SolicitudId, u.Paquete).Enviar) Complete (Respuesta As RestRespuesta)
	Return Respuesta
End Sub

Private Sub Reintentable (Estado As Int) As Boolean
	Return Estado = 0 Or Estado = ESTADO_DEMASIADAS Or Estado >= ESTADO_SERVIDOR
End Sub

Private Sub Resumen (r As ResumenSync) As String
	If r.SesionVencida Then Return Mensajes.SYNC_SESION
	If r.SinConexion Then Return Mensajes.SYNC_SIN_CONEXION
	If r.ConError > 0 Then Return Mensajes.SYNC_CON_ERRORES
	Return Mensajes.SYNC_LISTO
End Sub
