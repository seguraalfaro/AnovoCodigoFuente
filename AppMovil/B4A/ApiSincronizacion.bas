B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Rutas de sincronizacion: subida por unidad (cliente con contactos y firma, solicitud con sus
' piezas, cada foto) y la bajada. Devuelve el RestCliente armado; quien llama espera Enviar.
Sub Process_Globals
	Private Const RUTA_CLIENTE As String = "/api/clientes/registro-completo"
	Private Const RUTA_SOLICITUD As String = "/api/solicitudes/completa"
	Private Const RUTA_FOTO As String = "/api/solicitudes/($id)/adjuntos"
	Private Const RUTA_BAJADA As String = "/api/sincronizacion/bajada"
	Private Const RUTA_INDICADORES As String = "/api/dashboard/asesor"
	Private Const PARAM_DESDE As String = "desde"
	Private Const PARAM_ID As String = "id"
	Private Const ENCABEZADO_UBICACION As String = "Location"
End Sub

Public Sub SubirCliente (Paquete As Map) As RestCliente
	Return Api.NuevoCliente(True).AddBody(Paquete).PrepararPost(RUTA_CLIENTE)
End Sub

Public Sub SubirSolicitud (Paquete As Map) As RestCliente
	Return Api.NuevoCliente(True).AddBody(Paquete).PrepararPost(RUTA_SOLICITUD)
End Sub

Public Sub SubirFoto (SolicitudId As Int, Paquete As Map) As RestCliente
	Return Api.NuevoCliente(True).AddPathParam(PARAM_ID, SolicitudId).AddBody(Paquete).PrepararPost(RUTA_FOTO)
End Sub

Public Sub Bajar (Desde As String) As RestCliente
	Dim r As RestCliente = Api.NuevoCliente(True)
	If Desde <> "" Then r.AddQueryStringParam(PARAM_DESDE, Desde)
	Return r.PrepararGet(RUTA_BAJADA)
End Sub

Public Sub Indicadores As RestCliente
	Return Api.NuevoCliente(True).PrepararGet(RUTA_INDICADORES)
End Sub

Public Sub IdCreado (Respuesta As RestRespuesta) As Int
	Dim destino As String = Respuesta.HeaderValue(ENCABEZADO_UBICACION)
	Dim i As Int = destino.LastIndexOf("/")
	If i < 0 Then Return 0
	Dim id As String = destino.SubString(i + 1)
	If IsNumber(id) Then Return id
	Return 0
End Sub
