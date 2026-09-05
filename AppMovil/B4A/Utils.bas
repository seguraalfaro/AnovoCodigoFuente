B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' ============================================================
'  Texto — cadenas y formato de fechas. Sin estado, sin UI, sin BD.
'  Toda funcion que toque DateTime.DateFormat lo deja como estaba:
'  ese formato es global al proceso.
' ============================================================
Sub Process_Globals
	Public Const FORMATO_BD      As String = "yyyy-MM-dd HH:mm:ss"   ' columnas TEXT de fecha en SQLite
	Public Const FORMATO_API     As String = "yyyy-MM-dd HH:mm:ss.SSS" ' ajustar al confirmar el del backend
	Public Const FORMATO_DISPLAY As String = "dd/MM/yyyy HH:mm"
	Public Const FORMATO_CORTA   As String = "dd/MM/yyyy"
	Public Const LARGO_IDENT_FISICA   As Int = 9
	Public Const LARGO_IDENT_JURIDICA As Int = 10
	Public Const LARGO_IDENT_DIMEX    As Int = 12
	Public Const LARGO_IDENT_DIMEX_MIN As Int = 11
	Public Const LARGO_TELEFONO       As Int = 8
	Public Const LARGO_TELEFONO_EXT   As Int = 14
	Public Const HINT_CORREO As String ="correo@Empresa.com"
	Public Const HINT_CEDULA As String ="104530756"
	Public Const HINT_CEDULA_DIMEX As String ="121800123456"
	Public Const  HINT_TELEFONO As String ="8888-8888"
	Public Const  HINT_TELEFONO_EXT As String ="8888-8888 EXT 423"
	Public Const  HINT_MONTO As String ="8888-8888 EXT 423"
	Public Const HINT_CEDULA_JURIDICA As String ="3101A00001"
	Public Const HINT_REQUERIDO As String = "Campo obligatorio"
	Public Const HINT_FORMATO   As String = "Formato incorrecto"
	Public Const HINT_ERROR As String ="Revise este campo"
	Public Const TiposIdent() As String= Array As String("Cédula física", "Cédula jurídica", "DIMEX")
End Sub

#Region Cadenas
Public Sub EstaVacio (Valor As Object) As Boolean
	If Valor = Null Then Return True
	Return Valor.As(String).Trim = ""
End Sub

Public Sub ValorPorDefecto (Valor As String, ValorDefecto As String) As String
	If EstaVacio(Valor) Then Return ValorDefecto
	Return Valor
End Sub

'Corta el texto y le pone puntos suspensivos si no cabe.Esto fue hecho
'primera vez aplicacion de mantenimiento recortar texto en las card
Public Sub Truncar (Valor As String, LongitudMaxima As Int) As String
	If EstaVacio(Valor) Then Return ""
	If Valor.Length <= LongitudMaxima Then Return Valor
	Return Valor.SubString2(0, LongitudMaxima - 3) & "..."
End Sub
'Une los trozos no vacios con el separador. Evita quedarse con " ·  · " sueltos.
Public Sub Unir (Separador As String, Partes() As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For Each p As String In Partes
		If EstaVacio(p) Then Continue
		If sb.Length > 0 Then sb.Append(Separador)
		sb.Append(p.Trim)
	Next
	Return sb.ToString
End Sub

#End Region

#Region Fechas

'Formatea la fecha (DateTime.Now o lo que devuelva Parsear). "" si falla.
Public Sub Formatear (Fecha As Long, FormatoDate As String) As String
	Dim previo As String = DateTime.DateFormat
	Dim r As String = ""
	Try
		DateTime.DateFormat = FormatoDate
		r = DateTime.Date(Fecha)
	Catch
		Log("Texto.Formatear: " & LastException)
	End Try
	DateTime.DateFormat = previo
	Return r
End Sub

'Interpreta una fecha con el formato indicado. Devuelve 0 si no se pudo.
Public Sub Parsear (Fecha As String, FormatoDate As String) As Long
	If EstaVacio(Fecha) Then Return 0
	Dim previo As String = DateTime.DateFormat
	Dim r As Long = 0
	Try
		DateTime.DateFormat = FormatoDate
		r = DateTime.DateParse(Fecha.Trim)
	Catch
		Log("Texto.Parsear: " & LastException)
	End Try
	DateTime.DateFormat = previo
	Return r
End Sub

'Fecha y hora actual tal como la guardan las columnas de fecha de SQLite.
Public Sub AhoraBd As String
	Return Formatear(DateTime.Now, FORMATO_BD)
End Sub

'Fecha guardada en la base -> texto para mostrar al usuario.
Public Sub BdADisplay (FechaBd As String) As String
	Dim f As Long = Parsear(FechaBd, FORMATO_BD)
	If f = 0 Then Return ""
	Return Formatear(f, FORMATO_DISPLAY)
End Sub

'Solo el dia, para listados.
Public Sub BdACorta (FechaBd As String) As String
	Dim f As Long = Parsear(FechaBd, FORMATO_BD)
	If f = 0 Then Return ""
	Return Formatear(f, FORMATO_CORTA)
End Sub

#End Region

#Region API

'ISO del servidor (2026-08-30T14:05:33.123Z) -> fecha. 0 si no se pudo.
'Tolera la T, la Z, los nanosegundos de mas y que venga sin milisegundos.
Public Sub ApiAFecha (FechaApi As String) As Long
	If EstaVacio(FechaApi) Then Return 0
	Dim s As String = FechaApi.Trim.Replace("T", " ").Replace("Z", "")
	If s.Length > 23 Then s = s.SubString2(0, 23)
	If s.Length = 19 Then s = s & ".000"
	Return Parsear(s, FORMATO_API)
End Sub

'Lo que llega del servidor -> texto para mostrar al usuario.
Public Sub ApiADisplay (FechaApi As String) As String
	Dim f As Long = ApiAFecha(FechaApi)
	If f = 0 Then Return ""
	Return Formatear(f, FORMATO_DISPLAY)
End Sub

'Lo que llega del servidor -> como se guarda en SQLite (al bajar datos).
Public Sub ApiABd (FechaApi As String) As String
	Dim f As Long = ApiAFecha(FechaApi)
	If f = 0 Then Return ""
	Return Formatear(f, FORMATO_BD)
End Sub

'Lo que hay en SQLite -> lo que se manda al servidor (al subir la cola).
'OJO: la Z asume UTC y DateTime formatea en la zona del dispositivo (UTC-6).
'Se ajusta cuando este el endpoint: o se quita la Z, o se pone el offset real.
Public Sub BdAApi (FechaBd As String) As String
	Dim f As Long = Parsear(FechaBd, FORMATO_BD)
	If f = 0 Then Return ""
	Return Formatear(f, FORMATO_API).Replace(" ", "T") & "Z"
End Sub




#End Region

#Region Texto
'Deja solo digitos. La usan las mascaras para reconstruir el texto desde
'cero en vez de insertar separadores sobre lo que hay.
Public Sub SoloDigitos (s As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To s.Length - 1
		Dim c As String = s.SubString2(i, i + 1)
		If "0123456789".IndexOf(c) > -1 Then sb.Append(c)
	Next
	Return sb.ToString
End Sub

'Digitos y letras, en mayuscula. La cedula juridica lleva letras en el
'consecutivo (3-101-A00001).
Public Sub SoloAlfanum (s As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To s.Length - 1
		Dim c As String = s.SubString2(i, i + 1).ToUpperCase
		If "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".IndexOf(c) > -1 Then sb.Append(c)
	Next
	Return sb.ToString
End Sub

'Lo que se guarda y se envia a la API. Si el movil manda con guiones y el
'escritorio sin ellos, el cotejo al sincronizar duplica clientes.
Public Sub Normalizar (Texto As String) As String
	Return SoloAlfanum(Texto)
End Sub
#End Region


#Region AsignarDatosCombox

Public Sub AsignarItemsCombo (cd As B4XComboBox, items() As String)
	cd.SetItems(items)
	cd.SelectedIndex = 0
End Sub

#End Region