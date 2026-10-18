B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
'Colores — app móvil Anovo Cotizaciones (TFG UNED IS-2026)
'
'Fuente: anteproyecto aprobado, apartado "Estilo Visual > Paleta de colores",
'Figura 25 (Entregables/figuras/image31.png, ver MAPA.md fila 30). Valores
'hex obtenidos por muestreo de píxel directo sobre esa imagen.
'
'Roles funcionales, tal como los asigna el texto del anteproyecto:
'  "El azul primario se utilizará en barras de navegación, encabezados de
'   tabla y botones de acción principal. El azul medio se reserva para
'   íconos en estado activo, bordes de campo con foco y enlaces. Como
'   colores de apoyo para estados del proceso, se define el verde para
'   cotizaciones aprobadas, el ámbar para borradores y recordatorios
'   pendientes, y el rojo para cotizaciones rechazadas y errores de
'   sincronización."
'
'Formato B4A: Int ARGB (0xAARRGGBB).
'
'Las constantes van como Const: el compilador impide reasignarlas, así que
'un color de la paleta no puede cambiarse por accidente en tiempo de ejecución.

Sub Process_Globals
	'--- Roles funcionales — usar estos en el código, no los de arriba ---
	Public Const COLOR_PRIMARIO            As Int = 0xFF1A3A5C   'barras, encabezados, botón de acción principal
	Public COLOR_PRIMARIO_CLARO  As Int = 0xFF2E5C8A   'presionado de botones sólidos
	Public COLOR_PRIMARIO_TENUE  As Int = 0xFFD6E4F5   'fondo de iconos
	Public COLOR_PRIMARIO_SUAVE  As Int = 0xFFB8D0EC   'presionado de iconos
	Public Const COLOR_MEDIO               As Int = 0xFF2960A0   'iconos activos, borde de campo con foco, enlaces
	Public Const COLOR_RECHAZADA_ERROR     As Int = 0xFFEF4444   'rechazadas y errores de sincronización
	Public COLOR_ERROR As Int = 0xFFB3261E
	Public COLOR_ERROR_CLARO    As Int = 0xFFD14A42
	Public COLOR_ADVERTENCIA       As Int = 0xFFBA7517
	Public COLOR_ADVERTENCIA_TENUE As Int = 0xFFFAEEDA
	Public COLOR_ERROR_TENUE       As Int = 0xFFFCE8E6
	Public COLOR_EXITO             As Int = 0xFF1E7B3C
	Public COLOR_EXITO_TENUE       As Int = 0xFFE6F4EA
	Private Const FAMILIA_NEUTRA As Int = 0
	Private Const FAMILIA_PENDIENTE As Int = 1
	Private Const FAMILIA_EXITO As Int = 2
	Private Const FAMILIA_PELIGRO As Int = 3
	Private Const FAMILIA_INFO As Int = 4

	'--- Neutros de soporte (no vienen de la Figura 25; uso interno de UI) ---
	Public Const COLOR_FONDO_PANTALLA       As Int = 0xFFF5F7FA
	Public Const COLOR_SUPERFICIE           As Int = 0xFFFFFFFF
	Public Const COLOR_TEXTO_PRIMARIO       As Int = 0xFF1C1C1E
	Public Const COLOR_TEXTO_SECUNDARIO     As Int = 0xFF6B7280
	Public Const COLOR_TEXTO_SOBRE_PRIMARIO As Int = 0xFFFFFFFF
	Public Const COLOR_BORDE                As Int = 0xFFD9DEE4
	Public Const COLOR_DESHABILITADO        As Int = 0xFFB0B8C1
End Sub

Public Sub TintaPastilla (Estado As String) As Int
	Select Estado
		Case DbSync.ESTADO_ERROR
			Return COLOR_ERROR
		Case DbSync.ESTADO_PENDIENTE
			Return COLOR_ADVERTENCIA
		Case Else
			Return COLOR_EXITO
	End Select
End Sub

Public Sub FondoPastilla (Estado As String) As Int
	Select Estado
		Case DbSync.ESTADO_ERROR
			Return COLOR_ERROR_TENUE
		Case DbSync.ESTADO_PENDIENTE
			Return COLOR_ADVERTENCIA_TENUE
		Case Else
			Return COLOR_EXITO_TENUE
	End Select
End Sub

Public Sub TintaEstado (Estado As String) As Int
	Select Familia(Estado)
		Case FAMILIA_PENDIENTE: Return COLOR_ADVERTENCIA
		Case FAMILIA_EXITO: Return COLOR_EXITO
		Case FAMILIA_PELIGRO: Return COLOR_ERROR
		Case FAMILIA_INFO: Return COLOR_MEDIO
	End Select
	Return COLOR_TEXTO_SECUNDARIO
End Sub

Public Sub FondoEstado (Estado As String) As Int
	Select Familia(Estado)
		Case FAMILIA_PENDIENTE: Return COLOR_ADVERTENCIA_TENUE
		Case FAMILIA_EXITO: Return COLOR_EXITO_TENUE
		Case FAMILIA_PELIGRO: Return COLOR_ERROR_TENUE
		Case FAMILIA_INFO: Return COLOR_PRIMARIO_TENUE
	End Select
	Return COLOR_FONDO_PANTALLA
End Sub

Private Sub Familia (Estado As String) As Int
	Select Estado
		Case DbSeguimiento.ESTADO_BORRADOR, DbSeguimiento.ESTADO_PENDIENTE, DbSeguimiento.ESTADO_DEVUELTA, DbSeguimiento.ESTADO_RECIBIDA
			Return FAMILIA_PENDIENTE
		Case DbSeguimiento.ESTADO_APROBADA
			Return FAMILIA_EXITO
		Case DbSeguimiento.ESTADO_RECHAZADA, DbSeguimiento.ESTADO_DESCARTADA
			Return FAMILIA_PELIGRO
		Case DbSeguimiento.ESTADO_ENVIADA, DbSeguimiento.ESTADO_VISTO_BUENO, DbSeguimiento.ESTADO_EN_COTIZACION
			Return FAMILIA_INFO
	End Select
	Return FAMILIA_NEUTRA
End Sub

'Color de un valor numérico en resúmenes: apagado cuando es cero, para que se
'note qué falta antes de continuar.
Public Sub ColorDeConteo (Cantidad As Int) As Int
	If Cantidad = 0 Then Return COLOR_DESHABILITADO
	Return COLOR_TEXTO_PRIMARIO
End Sub