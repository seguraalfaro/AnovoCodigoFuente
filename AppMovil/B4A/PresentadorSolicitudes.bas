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
		If mEstado = "" Or Grupo(f) = mEstado Then mFilas.Add(f)
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
	Return Array As String(Mensajes.FILTRO_TODOS_ESTADOS, Mensajes.SEG_POR_SUBIR, Mensajes.SEG_ESPERANDO, _
		Mensajes.SEG_ELABORACION, Mensajes.SEG_ENVIADA, Mensajes.SEG_APROBADA, Mensajes.SEG_RECHAZADA, Mensajes.SEG_SIN_RESPUESTA)
End Sub

Public Sub setEstado (Texto As String)
	If Texto = Mensajes.FILTRO_TODOS_ESTADOS Then mEstado = "" Else mEstado = Texto
End Sub

Public Sub IndiceEstado As Int
	If mEstado = "" Then Return 0
	Return Max(0, getEstados.IndexOf(mEstado))
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
	If f.Estado = DbSeguimiento.ESTADO_APROBADA And f.Monto > 0 Then texto = texto & SEPARADOR & Mensajes.Colones(f.Monto)
	Return texto
End Sub

Public Sub EstadoDe (f As SeguimientoFila) As String
	If SinRespuesta(f) Then Return Mensajes.SEG_SIN_RESPUESTA
	Return Mensajes.TextoEstado(f.Estado)
End Sub

Public Sub TintaDe (f As SeguimientoFila) As Int
	Return Colores.TintaEstado(f.Estado)
End Sub

Public Sub FondoDe (f As SeguimientoFila) As Int
	Return Colores.FondoEstado(f.Estado)
End Sub
#End Region

#Region Ficha y resumen
Public Sub FilaDe (Uuid As String) As SeguimientoFila
	Return DbSeguimiento.Fila(Uuid)
End Sub

Public Sub FilasFicha (f As SeguimientoFila) As List
	Dim filas As List
	filas.Initialize
	filas.Add(Array As String(Mensajes.FICHA_ESTADO, EstadoDe(f)))
	If f.Cliente <> "" Then filas.Add(Array As String(Mensajes.FICHA_CLIENTE, f.Cliente))
	filas.Add(Array As String(Mensajes.FICHA_CAPTURADA, Utils.BdACorta(f.Fecha)))
	Dim cotizacion As String = Mensajes.FICHA_SIN_COTIZACION
	If f.ConCotizacion Then cotizacion = Mensajes.NumeroCotizacion(f.Cotizacion)
	filas.Add(Array As String(Mensajes.FICHA_COTIZACION, cotizacion))
	If f.Estado = DbSeguimiento.ESTADO_APROBADA And f.Monto > 0 And Sesion.Tiene(Sesion.PERMISO_VER_APROBADAS_PROPIAS) Then filas.Add(Array As String(Mensajes.FICHA_MONTO, Mensajes.Colones(f.Monto)))
	Dim servidor As String = Mensajes.FICHA_SUBIDA
	If f.Estado = DbSeguimiento.ESTADO_POR_SUBIR Then servidor = Mensajes.FICHA_POR_SUBIR
	filas.Add(Array As String(Mensajes.FICHA_SERVIDOR, servidor))
	Return filas
End Sub

Public Sub ResumenPorGrupo As List
	Dim cuentas As Map
	cuentas.Initialize
	For Each f As SeguimientoFila In DbSeguimiento.Lista("", HASTA_SIN_LIMITE)
		Dim g As String = Grupo(f)
		cuentas.Put(g, cuentas.GetDefault(g, 0) + 1)
	Next
	Dim res As List
	res.Initialize
	For Each g As String In getEstados
		If cuentas.ContainsKey(g) Then res.Add(Array As Object(g, cuentas.Get(g)))
	Next
	Return res
End Sub
#End Region

#Region Ayudantes
Private Sub SinRespuesta (f As SeguimientoFila) As Boolean
	Return f.Estado = DbSeguimiento.ESTADO_DESCARTADA And f.ConCotizacion
End Sub

Private Sub Grupo (f As SeguimientoFila) As String
	If SinRespuesta(f) Then Return Mensajes.SEG_SIN_RESPUESTA
	Select f.Estado
		Case DbSeguimiento.ESTADO_POR_SUBIR
			Return Mensajes.SEG_POR_SUBIR
		Case DbSeguimiento.ESTADO_BORRADOR, DbSeguimiento.ESTADO_PENDIENTE, DbSeguimiento.ESTADO_DEVUELTA, DbSeguimiento.ESTADO_VISTO_BUENO
			Return Mensajes.SEG_ELABORACION
		Case DbSeguimiento.ESTADO_ENVIADA
			Return Mensajes.SEG_ENVIADA
		Case DbSeguimiento.ESTADO_APROBADA
			Return Mensajes.SEG_APROBADA
		Case DbSeguimiento.ESTADO_RECHAZADA, DbSeguimiento.ESTADO_DESCARTADA
			Return Mensajes.SEG_RECHAZADA
	End Select
	Return Mensajes.SEG_ESPERANDO
End Sub
#End Region
