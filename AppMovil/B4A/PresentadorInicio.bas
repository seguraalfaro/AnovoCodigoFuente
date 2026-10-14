B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador de la hoja de Inicio: saludo, franja de sincronizacion, cotizacion sin
' terminar, indicadores y ultimas solicitudes. Todo sale de SQLite y del KVS. No conoce vistas.
Sub Class_Globals
	Private Const DIAS_RECIENTES As Int = 7
	Private Const GLIFO_SUBIENDO As Int = 0xF021
	Private Const GLIFO_ERROR As Int = 0xF071
	Private Const GLIFO_PENDIENTE As Int = 0xF0EE
	Private Const GLIFO_AL_DIA As Int = 0xF00C
	Private Const SEPARADOR As String = " · "

	Private cotizacion As PresentadorCotizacion
	Private mFranja As FranjaSync
	Private mRecientes As List
	Private mHayBorrador As Boolean
	Private mDetalleBorrador As String
End Sub

Public Sub Initialize
	cotizacion.Initialize
	mRecientes.Initialize
End Sub

Public Sub Actualizar
	mFranja = ArmarFranja(DbSync.Pendientes, DbSync.ConError, Sincronizacion.getEnCurso)
	Dim desde As Long = DateTime.Add(DateTime.Now, 0, 0, -DIAS_RECIENTES)
	mRecientes = DbInicio.Recientes(Utils.Formatear(desde, Utils.FORMATO_BD))
	mHayBorrador = cotizacion.HayBorrador And cotizacion.Restaurar
	mDetalleBorrador = ""
	If mHayBorrador Then mDetalleBorrador = ArmarDetalleBorrador
End Sub

Public Sub getSaludo As String
	Dim nombre As String = Sesion.Nombre.Trim
	If nombre.Contains(" ") Then nombre = nombre.SubString2(0, nombre.IndexOf(" "))
	Return Mensajes.Saludo(nombre)
End Sub

Public Sub getFecha As String
	Dim texto As String = Utils.Formatear(DateTime.Now, Utils.FORMATO_LARGA)
	If texto = "" Then Return ""
	Return texto.SubString2(0, 1).ToUpperCase & texto.SubString(1)
End Sub

Public Sub getFranja As FranjaSync
	Return mFranja
End Sub

Public Sub getHayBorrador As Boolean
	Return mHayBorrador
End Sub

Public Sub getDetalleBorrador As String
	Return mDetalleBorrador
End Sub

Public Sub DescartarBorrador
	cotizacion.DescartarBorrador
	mHayBorrador = False
	mDetalleBorrador = ""
End Sub

Public Sub getKpiTitulos As List
	Return Mensajes.KpisAsesor
End Sub

Public Sub getKpiValores As List
	Return Array(Mensajes.KPI_SIN_DATO, Mensajes.KPI_SIN_DATO, Mensajes.KPI_SIN_DATO, Mensajes.KPI_SIN_DATO)
End Sub

Public Sub getRecientes As List
	Return mRecientes
End Sub

Public Sub TituloDe (r As SolicitudReciente) As String
	Return r.Proyecto
End Sub

Public Sub DetalleDe (r As SolicitudReciente) As String
	Return Unir(Array As String(r.Cliente, Utils.BdACorta(r.Fecha)))
End Sub

Public Sub EstadoDe (r As SolicitudReciente) As String
	Return Mensajes.EstadoSolicitud(r.EstadoSync)
End Sub

Public Sub ColorDe (r As SolicitudReciente) As Int
	Return Colores.TintaPastilla(r.EstadoSync)
End Sub

Public Sub FondoDe (r As SolicitudReciente) As Int
	Return Colores.FondoPastilla(r.EstadoSync)
End Sub

Private Sub ArmarFranja (Pendientes As Int, Errores As Int, EnCurso As Boolean) As FranjaSync
	Dim f As FranjaSync
	f.Initialize
	If EnCurso Then
		f.Texto = Mensajes.SYNC_SUBIENDO
		f.Glifo = Chr(GLIFO_SUBIENDO)
		f.Tinta = Colores.COLOR_MEDIO
		f.Fondo = Colores.COLOR_PRIMARIO_TENUE
	Else If Errores > 0 Then
		f.Texto = Mensajes.SyncConError(Errores)
		f.Accion = Mensajes.SYNC_REINTENTAR
		f.Glifo = Chr(GLIFO_ERROR)
		f.Tinta = Colores.COLOR_ERROR
		f.Fondo = Colores.COLOR_ERROR_TENUE
	Else If Pendientes > 0 Then
		f.Texto = Mensajes.SyncPorSubir(Pendientes)
		f.Accion = Mensajes.MENU_SINCRONIZAR
		f.Glifo = Chr(GLIFO_PENDIENTE)
		f.Tinta = Colores.COLOR_ADVERTENCIA
		f.Fondo = Colores.COLOR_ADVERTENCIA_TENUE
	Else
		f.Texto = Mensajes.SYNC_AL_DIA
		f.Glifo = Chr(GLIFO_AL_DIA)
		f.Tinta = Colores.COLOR_EXITO
		f.Fondo = Colores.COLOR_EXITO_TENUE
	End If
	Return f
End Sub

Private Sub ArmarDetalleBorrador As String
	Dim piezas As Int = cotizacion.Piezas.Size
	Dim cuenta As String = ""
	If piezas > 0 Then cuenta = Mensajes.CuentaPiezas(piezas)
	Dim texto As String = Unir(Array As String(cotizacion.TextoCliente, cotizacion.Proyecto, cuenta))
	If texto = "" Then Return Mensajes.INICIO_RETOMAR_VACIA
	Return texto
End Sub

Private Sub Unir (Partes() As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For Each p As String In Partes
		If p = Null Or p.Trim = "" Then Continue
		If sb.Length > 0 Then sb.Append(SEPARADOR)
		sb.Append(p.Trim)
	Next
	Return sb.ToString
End Sub
