B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.

Sub Process_Globals
	Private kvsBorradores As KeyValueStore
	Public DbSQL As SQL
End Sub

#Region Apertura
'Llamado una vez desde Main.B4XPage_Created / arranque
Public Sub Inicializar
	kvsBorradores.Initialize(File.DirInternal, "borradores.dat")
	DbSQL = DbEsquema.Abrir
	DbPrueba.Cargar
End Sub
#End Region

#Region Borradores
'Tipo: "cliente" | "cotizacion" | "encargado" ...
Public Sub HayBorrador (Tipo As String) As Boolean
	Return kvsBorradores.ContainsKey(Tipo)
End Sub

Public Sub LeerBorrador (Tipo As String) As Map
	Return kvsBorradores.GetDefault(Tipo, CreateMap())
End Sub

Public Sub GuardarBorrador (Tipo As String, Datos As Map)
	Datos.Put("_guardado", DateTime.Now)
	kvsBorradores.Put(Tipo, Datos)
End Sub

Public Sub BorrarBorrador (Tipo As String)
	If kvsBorradores.ContainsKey(Tipo) Then kvsBorradores.Remove(Tipo)
End Sub
#End Region

#Region Cola de sincronización
'Marca una fila como pendiente de enviar al servidor.
'Entidad: cliente|contacto|firma|solicitud|adjunto|medida (CHECK de cola_sync).
Public Sub Encolar (Entidad As String, Uuid As String)
	Dim uno As List
	uno.Initialize
	uno.Add(Uuid)
	EncolarVarios(Entidad, uno)
End Sub

'Varias filas de la misma entidad en una sola pasada.
'Usa InsertMapsIn (sin transaccion propia) para poder ir dentro de la
'transaccion del alta y revertirse con ella si algo falla.
Public Sub EncolarVarios (Entidad As String, Uuids As List)
	If Uuids.IsInitialized = False Or Uuids.Size = 0 Then Return
	Dim ahora As String = Utils.AhoraBd
	Dim filas As List
	filas.Initialize
	For Each u As String In Uuids
		filas.Add(CreateMap("entidad": Entidad, "uuid_local": u, "fecha_encolado": ahora))
	Next
	extDBUtils.InsertMapsIn(DbSQL, "cola_sync", filas)
End Sub
#End Region

#Region Utilidades
'Identificador local de cada fila. El servidor asigna despues su id_servidor.
Public Sub NuevoUuid As String
	Dim ju As JavaObject
	ju.InitializeStatic("java.util.UUID")
	Return ju.RunMethod("randomUUID", Null)
End Sub

#End Region
