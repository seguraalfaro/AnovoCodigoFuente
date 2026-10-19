B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Fachada de la API como TApiBase del escritorio: arma el RestCliente con la URL
' y el token, y traduce cada respuesta fallida a un mensaje para la persona.

Sub Process_Globals
	Private xui As XUI
	Private kvs As KeyValueStore
	Private Const ARCHIVO_CONFIGURACION As String = "configuracion.dat"
	Private Const LLAVE_URL As String = "url_servidor"
	Private Const PREFIJO_HTTPS As String = "https://"
	Private Const URL_POR_DEFECTO As String = "https://api.anovoms.com"
	Private Const TIEMPO_MS As Int = 30000
	Public Const HTTP_OK As Int = 200
	Public Const HTTP_CREADO As Int = 201
	Public Const HTTP_NO_AUTORIZADO As Int = 401
	Public Const HTTP_PROHIBIDO As Int = 403
	Public Const HTTP_DEMASIADAS As Int = 429
	Public Const HTTP_SERVIDOR As Int = 500
	Private Const HTTP_PASARELA_DESDE As Int = 502
	Private Const HTTP_PASARELA_HASTA As Int = 504
	Private Const HTTP_TUNEL_DESDE As Int = 520
	Private Const HTTP_TUNEL_HASTA As Int = 530
	Private Const PAGINA_INGRESO As String = "MainPage"
End Sub

#Region Servidor
Private Sub Configuracion As KeyValueStore
	If kvs.IsInitialized = False Then kvs.Initialize(File.DirInternal, ARCHIVO_CONFIGURACION)
	Return kvs
End Sub

Public Sub UrlServidor As String
	Return Configuracion.GetDefault(LLAVE_URL, URL_POR_DEFECTO)
End Sub

Public Sub ValidarUrl (Url As String) As String
	If Url.Trim = "" Then Return Mensajes.URL_VACIA
	If Url.Trim.ToLowerCase.StartsWith(PREFIJO_HTTPS) = False Then Return Mensajes.URL_SIN_HTTPS
	Return ""
End Sub

Public Sub GuardarUrl (Url As String)
	Configuracion.Put(LLAVE_URL, Url.Trim)
End Sub
#End Region

#Region Cliente REST
Public Sub NuevoCliente (ConToken As Boolean) As RestCliente
	Dim cliente As RestCliente
	cliente.Initialize
	cliente.BaseUrl(UrlServidor).ReadTimeout(TIEMPO_MS)
	If ConToken Then cliente.SetBearerAuthorization(Sesion.Token)
	Return cliente
End Sub
#End Region

#Region Errores y sesión
Public Sub SesionVencida (Respuesta As RestRespuesta) As Boolean
	Return Respuesta.StatusCode = HTTP_NO_AUTORIZADO
End Sub

Public Sub NoDisponible (Estado As Int) As Boolean
	Return (Estado >= HTTP_PASARELA_DESDE And Estado <= HTTP_PASARELA_HASTA) Or (Estado >= HTTP_TUNEL_DESDE And Estado <= HTTP_TUNEL_HASTA)
End Sub

Public Sub MensajeDe (Respuesta As RestRespuesta) As String
	If Respuesta.StatusCode = 0 Then
		Dim detalle As String = Respuesta.Content
		If detalle <> Null And (detalle.Contains("CertPath") Or detalle.Contains("SSLHandshake")) Then Return Mensajes.CERTIFICADO_INVALIDO
		Return Mensajes.SIN_CONEXION
	End If
	If Respuesta.StatusCode = HTTP_NO_AUTORIZADO Then Return Mensajes.SESION_VENCIDA
	If NoDisponible(Respuesta.StatusCode) Then Return Mensajes.SERVIDOR_NO_DISPONIBLE
	If Respuesta.Mensaje <> "" Then Return Mensajes.ConDetalles(Respuesta.Mensaje, Respuesta.Detalles)
	If Respuesta.StatusCode = HTTP_DEMASIADAS Then Return Mensajes.DEMASIADAS_PETICIONES
	Return Mensajes.ErrorServidor(Respuesta.StatusCode)
End Sub

Public Sub VolverAlIngreso (Mensaje As String)
	Sesion.Cerrar
	B4XPages.ShowPageAndRemovePreviousPages(PAGINA_INGRESO)
	If Mensaje <> "" Then xui.MsgboxAsync(Mensaje, Mensajes.TITULO)
End Sub
#End Region
