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
	Public Const COLOR_APROBADA            As Int = 0xFF22C55E   'cotizaciones aprobadas
	Public Const COLOR_BORRADOR_PENDIENTE  As Int = 0xFFF59E0B   'borradores y pendientes
	Public Const COLOR_RECHAZADA_ERROR     As Int = 0xFFEF4444   'rechazadas y errores de sincronización
	Public COLOR_ERROR As Int = 0xFFB3261E
	Public COLOR_ERROR_CLARO    As Int = 0xFFD14A42
	Public COLOR_ADVERTENCIA       As Int = 0xFFBA7517
	Public COLOR_ADVERTENCIA_TENUE As Int = 0xFFFAEEDA
	Public COLOR_ERROR_TENUE       As Int = 0xFFFCE8E6
	Public COLOR_EXITO             As Int = 0xFF1E7B3C
	Public COLOR_EXITO_TENUE       As Int = 0xFFE6F4EA
	'--- Estado "en revisión": NO está en el vocabulario acordado ---
	'(borrador · pendiente · aprobada · rechazada · enviada). Ver
	'componentes-b4x-anovo.md, pendiente #7. Mientras no se confirme con
	'Anovo, se pinta con el mismo ámbar pero marcado como provisional
	'(borde rojo) en la interfaz — no se inventa un color propio.
	Public Const COLOR_EN_REVISION_PROVISIONAL As Int = 0xFFF59E0B

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

'Etiqueta de estado -> color, para pintar chips en listas de cotizaciones.
'Uso: Colores.ColorDeEstado("aprobada")
Public Sub ColorDeEstado (Estado As String) As Int
	Select Estado
		Case "borrador", "pendiente", "devuelta"
			Return COLOR_BORRADOR_PENDIENTE
		Case "aprobada"
			Return COLOR_APROBADA
		Case "rechazada"
			Return COLOR_RECHAZADA_ERROR
		Case "enviada", "visto_bueno"
			Return COLOR_MEDIO
		Case "en_revision_provisional"
			Return COLOR_EN_REVISION_PROVISIONAL
		Case Else
			Log("Colores.ColorDeEstado: estado desconocido -> " & Estado)
			Return COLOR_TEXTO_SECUNDARIO
	End Select
End Sub

'Color de un valor numérico en resúmenes: apagado cuando es cero, para que se
'note qué falta antes de continuar.
Public Sub ColorDeConteo (Cantidad As Int) As Int
	If Cantidad = 0 Then Return COLOR_DESHABILITADO
	Return COLOR_TEXTO_PRIMARIO
End Sub