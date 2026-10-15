B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador de la pantalla de sincronizacion (P10): conexion, pendientes por tipo, registros
' con error e historial de intentos (RNF-012). No conoce vistas.
Sub Class_Globals
	Private Const LIMITE_HISTORIAL As Int = 20
	Private Const SIN_DATO As String = "-"
	Private Const FORMATO_INTENTO As String = "dd/MM HH:mm"
	Private Const GLIFO_EXITOSA As Int = 0xF058
	Private Const GLIFO_PARCIAL As Int = 0xF042
	Private Const GLIFO_SIN_CONEXION As Int = 0xF1EB
	Private Const GLIFO_SESION As Int = 0xF023
	Private mPendientes() As Int
	Private mErrores As List
	Private mHistorial As List
	Private mUltima As String
	Private mProbando As Boolean
	Private mProbado As Boolean
	Private mEnLinea As Boolean
End Sub

Public Sub Initialize
	mErrores.Initialize
	mHistorial.Initialize
	mPendientes = Array As Int(0, 0, 0)
End Sub

Public Sub Actualizar
	mPendientes = Array As Int(DbSync.PendientesDe(DbSync.CLASE_CLIENTE), DbSync.PendientesDe(DbSync.CLASE_SOLICITUD), DbSync.PendientesDe(DbSync.CLASE_FOTO))
	mErrores = DbSync.Errores
	mHistorial = DbSync.Historial(LIMITE_HISTORIAL)
	mUltima = DbSync.UltimaExitosa
End Sub

Public Sub Probar As ResumableSub
	mProbando = True
	Wait For (ApiSesion.Version.Enviar) Complete (Respuesta As RestRespuesta)
	mProbando = False
	mProbado = True
	mEnLinea = Respuesta.Success
	Return mEnLinea
End Sub

Public Sub getServidor As String
	If Api.UrlServidor = "" Then Return SIN_DATO
	Return Api.UrlServidor
End Sub

Public Sub getEstadoConexion As FranjaSync
	Dim f As FranjaSync
	f.Initialize
	If mProbando Or mProbado = False Then
		f.Texto = Mensajes.PROBANDO
		f.Tinta = Colores.COLOR_MEDIO
		f.Fondo = Colores.COLOR_PRIMARIO_TENUE
	Else If mEnLinea Then
		f.Texto = Mensajes.SYNC_EN_LINEA
		f.Tinta = Colores.COLOR_EXITO
		f.Fondo = Colores.COLOR_EXITO_TENUE
	Else
		f.Texto = Mensajes.SYNC_FUERA_DE_LINEA
		f.Tinta = Colores.COLOR_TEXTO_SECUNDARIO
		f.Fondo = Colores.COLOR_FONDO_PANTALLA
	End If
	Return f
End Sub

Public Sub getUltimaExitosa As String
	If mUltima = "" Then Return Mensajes.SYNC_NUNCA
	Return Utils.BdADisplay(mUltima)
End Sub

Public Sub getPendientes As Int()
	Return mPendientes
End Sub

Public Sub getTotalPendientes As Int
	Return mPendientes(0) + mPendientes(1) + mPendientes(2)
End Sub

Public Sub getAlDia As Boolean
	Return getTotalPendientes = 0 And mErrores.Size = 0
End Sub

Public Sub getEnCurso As Boolean
	Return Sincronizacion.getEnCurso
End Sub

Public Sub getErrores As List
	Return mErrores
End Sub

Public Sub TituloError (e As ErrorSync) As String
	Return Mensajes.TituloErrorSync(e.Entidad, e.Titulo)
End Sub

Public Sub getHistorial As List
	Return mHistorial
End Sub

Public Sub ResultadoDe (i As IntentoSync) As String
	Return Mensajes.ResultadoSync(i.Resultado)
End Sub

Public Sub FechaDe (i As IntentoSync) As String
	Return Utils.Formatear(Utils.Parsear(i.Fecha, Utils.FORMATO_BD), FORMATO_INTENTO)
End Sub

Public Sub DetalleDe (i As IntentoSync) As String
	Return Mensajes.DetalleIntento(i.Subidos, i.ConError, i.Pendientes)
End Sub

Public Sub IconoDe (i As IntentoSync) As FranjaSync
	Dim f As FranjaSync
	f.Initialize
	Select i.Resultado
		Case DbSync.RESULTADO_EXITOSA
			f.Glifo = Chr(GLIFO_EXITOSA)
			f.Tinta = Colores.COLOR_EXITO
			f.Fondo = Colores.COLOR_EXITO_TENUE
		Case DbSync.RESULTADO_PARCIAL
			f.Glifo = Chr(GLIFO_PARCIAL)
			f.Tinta = Colores.COLOR_ADVERTENCIA
			f.Fondo = Colores.COLOR_ADVERTENCIA_TENUE
		Case DbSync.RESULTADO_SESION
			f.Glifo = Chr(GLIFO_SESION)
			f.Tinta = Colores.COLOR_ERROR
			f.Fondo = Colores.COLOR_ERROR_TENUE
		Case Else
			f.Glifo = Chr(GLIFO_SIN_CONEXION)
			f.Tinta = Colores.COLOR_TEXTO_SECUNDARIO
			f.Fondo = Colores.COLOR_FONDO_PANTALLA
	End Select
	Return f
End Sub

Public Sub Sincronizar
	Sincronizacion.Forzar
End Sub

Public Sub Reintentar (e As ErrorSync)
	DbSync.ReintentarUno(e.Entidad, e.Uuid)
	Sincronizacion.Pedir
End Sub
