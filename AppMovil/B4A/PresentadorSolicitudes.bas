B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador de la pestana Solicitudes (HU-03): lista del asesor con el estado como lo ve el,
' filtros por estado y por periodo (mes, todas o rango) y textos de cada fila. Todo sale de SQLite.

Sub Class_Globals
	Private Const SEPARADOR As String = " · "
	Private mFilas As List
	Private Const HASTA_SIN_LIMITE As String = "9999-12-31"
	Private Const FORMATO_SQL As String = "yyyy-MM-dd"
	Private Const FORMATO_CHIP As String = "dd/MM"
	Public Const PERIODO_MES As Int = 0
	Public Const PERIODO_TODAS As Int = 1
	Public Const PERIODO_RANGO As Int = 2
	Private mPeriodo As Int = PERIODO_MES
	Private mDesde As Long
	Private mHasta As Long
	Private mEstado As String = ""
End Sub

Public Sub Initialize
	mFilas.Initialize
End Sub

#Region Estado
Public Sub Actualizar
	Dim desde As String = ""
	Dim hasta As String = HASTA_SIN_LIMITE
	Select mPeriodo
		Case PERIODO_MES
			Dim hoy As Long = DateTime.Now
			desde = Utils.Formatear(DateTime.Add(hoy, 0, 0, 1 - DateTime.GetDayOfMonth(hoy)), FORMATO_SQL)
		Case PERIODO_RANGO
			desde = Utils.Formatear(mDesde, FORMATO_SQL)
			hasta = Utils.Formatear(DateTime.Add(mHasta, 0, 0, 1), FORMATO_SQL)
	End Select
	Dim todas As List = DbSeguimiento.Lista(desde, hasta)
	mFilas.Initialize
	For Each f As SeguimientoFila In todas
		If mEstado = "" Or Grupo(f.Estado) = mEstado Then mFilas.Add(f)
	Next
End Sub

Public Sub getPeriodo As Int
	Return mPeriodo
End Sub

Public Sub setPeriodo (Valor As Int)
	mPeriodo = Valor
End Sub

Public Sub FijarRango (Desde As Long, Hasta As Long) As Resultado
	If Utils.Formatear(Desde, FORMATO_SQL).CompareTo(Utils.Formatear(Hasta, FORMATO_SQL)) > 0 Then Return Tipos.Falla(Mensajes.PERIODO_INVERTIDO)
	mDesde = Desde
	mHasta = Hasta
	mPeriodo = PERIODO_RANGO
	Return Tipos.Correcto(Null)
End Sub

Public Sub getRangoDesde As Long
	If mDesde = 0 Then Return DateTime.Now
	Return mDesde
End Sub

Public Sub getRangoHasta As Long
	If mHasta = 0 Then Return DateTime.Now
	Return mHasta
End Sub

Public Sub getEstados As List
	Return Array As String(Mensajes.FILTRO_TODAS, Mensajes.SEG_POR_SUBIR, Mensajes.SEG_ESPERANDO, _
		Mensajes.SEG_ELABORACION, Mensajes.SEG_ENVIADA, Mensajes.SEG_APROBADA, Mensajes.SEG_RECHAZADA)
End Sub

Public Sub setEstado (Texto As String)
	If Texto = Mensajes.FILTRO_TODAS Then mEstado = "" Else mEstado = Texto
End Sub

Public Sub EstadoActivo (Texto As String) As Boolean
	If Texto = Mensajes.FILTRO_TODAS Then Return mEstado = ""
	Return mEstado = Texto
End Sub
#End Region

#Region Lo que pinta la página
Public Sub getFilas As List
	Return mFilas
End Sub

Public Sub getTotalTexto As String
	Return mFilas.Size
End Sub

Public Sub getTextoVacio As String
	If mEstado <> "" Or mPeriodo = PERIODO_RANGO Then Return Mensajes.SIN_SOLICITUDES_FILTRO
	If mPeriodo = PERIODO_MES Then Return Mensajes.SIN_SOLICITUDES_MES
	Return Mensajes.SIN_SOLICITUDES
End Sub

Public Sub getTextoRango As String
	If mPeriodo <> PERIODO_RANGO Then Return Mensajes.FILTRO_FECHAS
	Return Mensajes.TextoRango(Utils.Formatear(mDesde, FORMATO_CHIP), Utils.Formatear(mHasta, FORMATO_CHIP))
End Sub
#End Region

#Region Textos de cada fila
Public Sub TextoBusqueda (f As SeguimientoFila) As String
	Return f.Proyecto & " " & f.Cliente
End Sub

Public Sub TituloDe (f As SeguimientoFila) As String
	Return f.Proyecto
End Sub

Public Sub DetalleDe (f As SeguimientoFila) As String
	Dim texto As String = f.Cliente
	Dim fecha As String = Utils.BdACorta(f.Fecha)
	If fecha <> "" Then
		If texto <> "" Then texto = texto & SEPARADOR
		texto = texto & fecha
	End If
	If Grupo(f.Estado) = Mensajes.SEG_APROBADA And f.Monto > 0 Then texto = texto & SEPARADOR & Mensajes.Colones(f.Monto)
	Return texto
End Sub

Public Sub EstadoDe (f As SeguimientoFila) As String
	Return Grupo(f.Estado)
End Sub

Public Sub TintaDe (f As SeguimientoFila) As Int
	Select Grupo(f.Estado)
		Case Mensajes.SEG_POR_SUBIR: Return Colores.COLOR_TEXTO_SECUNDARIO
		Case Mensajes.SEG_ESPERANDO: Return Colores.COLOR_ADVERTENCIA
		Case Mensajes.SEG_ELABORACION: Return Colores.COLOR_PROCESO
		Case Mensajes.SEG_ENVIADA: Return Colores.COLOR_MEDIO
		Case Mensajes.SEG_APROBADA: Return Colores.COLOR_EXITO
	End Select
	Return Colores.COLOR_ERROR
End Sub

Public Sub FondoDe (f As SeguimientoFila) As Int
	Select Grupo(f.Estado)
		Case Mensajes.SEG_POR_SUBIR: Return Colores.COLOR_FONDO_PANTALLA
		Case Mensajes.SEG_ESPERANDO: Return Colores.COLOR_ADVERTENCIA_TENUE
		Case Mensajes.SEG_ELABORACION: Return Colores.COLOR_PROCESO_TENUE
		Case Mensajes.SEG_ENVIADA: Return Colores.COLOR_PRIMARIO_TENUE
		Case Mensajes.SEG_APROBADA: Return Colores.COLOR_EXITO_TENUE
	End Select
	Return Colores.COLOR_ERROR_TENUE
End Sub
#End Region

#Region Ayudantes
Private Sub Grupo (Estado As String) As String
	Select Estado
		Case DbSeguimiento.ESTADO_POR_SUBIR: Return Mensajes.SEG_POR_SUBIR
		Case "borrador", "pendiente", "devuelta", "visto_bueno": Return Mensajes.SEG_ELABORACION
		Case "enviada": Return Mensajes.SEG_ENVIADA
		Case "aprobada": Return Mensajes.SEG_APROBADA
		Case "rechazada": Return Mensajes.SEG_RECHAZADA
	End Select
	Return Mensajes.SEG_ESPERANDO
End Sub
#End Region
