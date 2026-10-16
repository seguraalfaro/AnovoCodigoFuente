B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Sube la cola por unidades y en orden (clientes, solicitudes, fotos) y despues baja lo que cambio
' en el servidor. Solo confirma lo que el servidor acepto, unidad por unidad.

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

#Region Subida
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
	If r.SesionVencida = False And r.SinConexion = False Then
		Wait For (Bajar(r)) Complete (Bajado As Boolean)
	End If
	r.Pendientes = DbSync.Pendientes
	r.ConError = DbSync.ConError
	r.Mensaje = Resumen(r)
	DbSync.RegistrarIntento(r)
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
	Dim datos() As Byte = Adjuntos.LeerBytes(u.Ruta)
	Dim codificador As StringUtils
	u.Paquete.Put("contenido", codificador.EncodeBase64(datos))
	If datos.Length > 0 Then u.Paquete.Put("hash_sha256", Adjuntos.HuellaSha256(datos))
	Wait For (ApiSincronizacion.SubirFoto(u.SolicitudId, u.Paquete).Enviar) Complete (Respuesta As RestRespuesta)
	Return Respuesta
End Sub

Private Sub Reintentable (Estado As Int) As Boolean
	Return Estado = 0 Or Estado = ESTADO_DEMASIADAS Or Estado >= ESTADO_SERVIDOR
End Sub
#End Region

#Region Bajada
Private Sub Bajar (r As ResumenSync) As ResumableSub
	Wait For (remota.AsegurarSesion) Complete (Estado As Int)
	If Estado <> ESTADO_OK Then
		r.SesionVencida = (Estado = ESTADO_NO_AUTORIZADO)
		r.SinConexion = Not(r.SesionVencida)
		Return False
	End If
	Wait For (ApiSincronizacion.Bajar(DbBajada.Desde).Enviar) Complete (Respuesta As RestRespuesta)
	If Respuesta.StatusCode <> ESTADO_OK Then
		r.SesionVencida = (Respuesta.StatusCode = ESTADO_NO_AUTORIZADO)
		r.SinConexion = (Respuesta.StatusCode = 0)
		Return False
	End If
	Dim datos As Map = Respuesta.DatosMap
	Dim lote As Object = DbBajada.Aplicar(datos)
	Wait For (lote) Lote_NonQueryComplete (Exito As Boolean)
	If Exito Then r.Bajados = DbBajada.Contar(datos) Else Log("Sincronizador.Bajar: " & LastException.Message)
	Wait For (ApiSincronizacion.Indicadores.Enviar) Complete (Tablero As RestRespuesta)
	If Tablero.StatusCode = ESTADO_OK Then DbInicio.GuardarIndicadores(Tablero.DatosMap)
	Return Exito
End Sub
#End Region

#Region Ayudantes
Private Sub Resumen (r As ResumenSync) As String
	If r.SesionVencida Then Return Mensajes.SYNC_SESION
	If r.SinConexion Then Return Mensajes.SYNC_SIN_CONEXION
	If r.ConError > 0 Then Return Mensajes.SYNC_CON_ERRORES
	Return Mensajes.SYNC_LISTO
End Sub
#End Region
