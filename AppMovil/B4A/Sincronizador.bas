B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Sube la cola por unidades y en orden (clientes, solicitudes, fotos) y despues baja lo que cambio
' en el servidor. Solo confirma lo que el servidor acepto, unidad por unidad.

Sub Class_Globals
	Private Const CODIGO_CAMBIO_CLAVE As String = "CAMBIO_CLAVE_PENDIENTE"
	Private Const CODIGO_VERSION_VENCIDA As String = "VERSION_VENCIDA"
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
	For Each clase As String In Array As String(DbSync.CLASE_CLIENTE, DbSync.CLASE_FIRMA, DbSync.CLASE_SOLICITUD, DbSync.CLASE_FOTO)
		For Each u As UnidadSync In DbSync.Listas(clase)
			Wait For (remota.AsegurarSesion) Complete (Estado As Int)
			If Estado <> Api.HTTP_OK Then
				MarcarCaida(r, Estado)
				Exit
			End If
			Wait For (Enviar(u)) Complete (Respuesta As RestRespuesta)
			If Respuesta.StatusCode = Api.HTTP_CREADO Or Respuesta.StatusCode = Api.HTTP_OK Then
				Dim id As Int = ApiSincronizacion.IdCreado(Respuesta)
				If id > 0 Then
					DbSync.Confirmar(u, id)
					r.Subidos = r.Subidos + 1
				Else
					Log("Sincronizador: respuesta sin id para " & u.Uuid)
					DbSync.Reprogramar(u)
				End If
			Else If Respuesta.StatusCode = Api.HTTP_NO_AUTORIZADO Or Respuesta.Codigo = CODIGO_CAMBIO_CLAVE Then
				r.SesionVencida = True
				Exit
			Else If Reintentable(Respuesta.StatusCode) Then
				DbSync.Reprogramar(u)
				If Respuesta.StatusCode = 0 Or Respuesta.StatusCode = Api.HTTP_DEMASIADAS Then
					MarcarCaida(r, Respuesta.StatusCode)
					Exit
				End If
			Else If Respuesta.Codigo = CODIGO_VERSION_VENCIDA Then
				DbSync.MarcarError(u, Mensajes.SYNC_CONFLICTO)
				r.ConError = r.ConError + 1
			Else
				DbSync.MarcarError(u, Api.MensajeDe(Respuesta))
				r.ConError = r.ConError + 1
			End If
		Next
		If Detenido(r) Then Exit
	Next
	If Detenido(r) = False Then
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
		Case DbSync.CLASE_FIRMA
			Wait For (ApiSincronizacion.SubirFirma(u.ClienteId, u.Paquete).Enviar) Complete (Respuesta As RestRespuesta)
			Return Respuesta
	End Select
	Dim datos() As Byte = Adjuntos.LeerBytes(u.Ruta)
	Dim codificador As StringUtils
	u.Paquete.Put("contenido", codificador.EncodeBase64(datos))
	If datos.Length > 0 Then u.Paquete.Put("hash_sha256", Adjuntos.HuellaSha256(datos))
	Wait For (ApiSincronizacion.SubirFoto(u.SolicitudId, u.Paquete).Enviar) Complete (Respuesta As RestRespuesta)
	Return Respuesta
End Sub

Private Sub MarcarCaida (r As ResumenSync, Estado As Int)
	If Estado = 0 Then
		r.SinConexion = True
	Else If Estado = Api.HTTP_DEMASIADAS Or Estado >= Api.HTTP_SERVIDOR Then
		r.ServidorOcupado = True
	Else
		r.SesionVencida = True
	End If
End Sub

Private Sub Detenido (r As ResumenSync) As Boolean
	Return r.SesionVencida Or r.SinConexion Or r.ServidorOcupado
End Sub

Private Sub Reintentable (Estado As Int) As Boolean
	Return Estado = 0 Or Estado = Api.HTTP_DEMASIADAS Or Estado >= Api.HTTP_SERVIDOR
End Sub
#End Region

#Region Bajada
Private Sub Bajar (r As ResumenSync) As ResumableSub
	Wait For (remota.AsegurarSesion) Complete (Estado As Int)
	If Estado <> Api.HTTP_OK Then
		MarcarCaida(r, Estado)
		Return False
	End If
	Wait For (remota.ActualizarPermisos) Complete (Permisos As RestRespuesta)
	If Permisos.Success Then
		If Sesion.Tiene(Sesion.PERMISO_ACCESO_MOVIL) = False Then
			r.SesionVencida = True
			Return False
		End If
		LlaveDispositivo.GuardarPermisos(Sesion.Permisos)
	End If
	Wait For (ApiSincronizacion.Bajar(DbBajada.Desde).Enviar) Complete (Respuesta As RestRespuesta)
	If Respuesta.StatusCode <> Api.HTTP_OK Then
		If Respuesta.StatusCode = Api.HTTP_NO_AUTORIZADO Then
			r.SesionVencida = True
		Else If Respuesta.StatusCode = 0 Then
			r.SinConexion = True
		Else If Api.NoDisponible(Respuesta.StatusCode) Then
			r.ServidorOcupado = True
		Else
			r.FalloBajada = True
		End If
		Return False
	End If
	Dim datos As Map = Respuesta.DatosMap
	Dim lote As Object = DbBajada.Aplicar(datos)
	Wait For (lote) Lote_NonQueryComplete (Exito As Boolean)
	If Exito Then
		r.Bajados = DbBajada.Contar(datos)
	Else
		Log("Sincronizador.Bajar: " & LastException.Message)
		r.FalloBajada = True
	End If
	Wait For (ApiSincronizacion.Indicadores.Enviar) Complete (Tablero As RestRespuesta)
	If Tablero.StatusCode = Api.HTTP_OK Then DbInicio.GuardarIndicadores(Tablero.DatosMap)
	Return Exito
End Sub
#End Region

#Region Ayudantes
Private Sub Resumen (r As ResumenSync) As String
	If r.SesionVencida Then Return Mensajes.SYNC_SESION
	If r.SinConexion Then Return Mensajes.SYNC_SIN_CONEXION
	If r.ServidorOcupado Then Return Mensajes.SYNC_OCUPADO
	If r.ConError > 0 Then Return Mensajes.SYNC_CON_ERRORES
	If r.FalloBajada Then Return Mensajes.SYNC_BAJADA_FALLO
	Return Mensajes.SYNC_LISTO
End Sub
#End Region
