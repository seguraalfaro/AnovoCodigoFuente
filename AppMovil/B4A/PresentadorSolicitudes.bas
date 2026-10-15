B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador de la pestana Solicitudes (HU-03): lista del asesor con el estado como lo ve el,
' filtro del mes y textos de cada fila. Todo sale de SQLite. No conoce vistas.

Sub Class_Globals
	Private Const SEPARADOR As String = " · "
	Private mFilas As List
	Private mSoloMes As Boolean = True
End Sub

Public Sub Initialize
	mFilas.Initialize
End Sub

#Region Estado
Public Sub Actualizar
	Dim desde As String = ""
	If mSoloMes Then
		Dim hoy As Long = DateTime.Now
		desde = Utils.Formatear(DateTime.Add(hoy, 0, 0, 1 - DateTime.GetDayOfMonth(hoy)), "yyyy-MM-dd")
	End If
	mFilas = DbSeguimiento.Lista(desde)
End Sub

Public Sub getSoloMes As Boolean
	Return mSoloMes
End Sub

Public Sub setSoloMes (Valor As Boolean)
	mSoloMes = Valor
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
	If mSoloMes Then Return Mensajes.SIN_SOLICITUDES_MES
	Return Mensajes.SIN_SOLICITUDES
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
