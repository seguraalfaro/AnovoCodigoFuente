B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Tipos que viajan entre capas y el resultado de un presentador.
' Los Type son globales al proyecto: se declaran solo aqui, nunca en Main.
Sub Process_Globals
	Type Resultado (Ok As Boolean, Mensaje As String, Datos As Object)
	Type Cliente (UuidLocal As String, Nombre As String, TipoIdentificacion As Int, Identificacion As String, _
		Telefono As String, Direccion As String, ContactoCobro As String, CorreoCobro As String)
	Type Contacto (UuidLocal As String, Nombre As String, Puesto As String, Telefono As String, _
		Celular As String, Correo As String, Principal As Boolean)
	Type Consentimiento (Acepta As Boolean, Firmante As String, CedulaFirmante As String, Firma() As Byte, Version As String)
	Type Pieza (UuidLocal As String, Nombre As String, TipoTrabajo As String, Material As String, _
		Acabado As String, Medidas As Int, Fotos As Int, Croquis As Boolean, _
		TipoTrabajoId As Int, TipoMaterialId As Int, AcabadoId As Int, CroquisJson As String, _
		ListaMedidas As List, ListaFotos As List)
	Type MedidaPieza (Etiqueta As String, TipoMedida As String, Valor As Double, Unidad As String, _
		Cantidad As Int, Orden As Int)
	Type OpcionBusqueda (Titulo As String, Detalle As String, Valor As Object)
	Type Solicitud (UuidLocal As String, ClienteUuid As String, ContactoUuid As String, _
		NombreProyecto As String, Descripcion As String, Observaciones As String)
	Type UnidadSync (Clase As String, Uuid As String, Paquete As Map, SolicitudId As Int, Ruta As String, ClienteId As Int)
	Type ResumenSync (Subidos As Int, Bajados As Int, ConError As Int, Pendientes As Int, SinConexion As Boolean, _
		SesionVencida As Boolean, ServidorOcupado As Boolean, FalloBajada As Boolean, Mensaje As String)
	Type FranjaSync (Texto As String, Accion As String, Glifo As String, Tinta As Int, Fondo As Int)
	Type SolicitudReciente (Proyecto As String, Cliente As String, Fecha As String, EstadoSync As String)
	Type SeguimientoFila (Uuid As String, Proyecto As String, Cliente As String, Fecha As String, Estado As String, Monto As Double)
	Type ClienteFila (Datos As Cliente, EstadoSync As String)
	Type PerfilLocal (UsuarioId As Int, Correo As String, Nombre As String, Rol As String)
	Type UbicacionGps (Ok As Boolean, Latitud As Double, Longitud As Double, Precision As Double)
	Type IntentoSync (Fecha As String, Resultado As String, Subidos As Int, Bajados As Int, ConError As Int, Pendientes As Int)
	Type ErrorSync (Entidad As String, Uuid As String, Titulo As String, Mensaje As String)
	Type PermisoCliente (Accion As String, Firmante As String, Fecha As String, Version As String)
	Type TextoPermiso (Version As String, Titulo As String, Contenido As String)
End Sub

Public Sub Correcto (Datos As Object) As Resultado
	Dim r As Resultado
	r.Initialize
	r.Ok = True
	r.Mensaje = ""
	r.Datos = Datos
	Return r
End Sub

Public Sub Falla (Mensaje As String) As Resultado
	Dim r As Resultado
	r.Initialize
	r.Ok = False
	r.Mensaje = Mensaje
	Return r
End Sub

Public Sub ClienteVacio As Cliente
	Dim c As Cliente
	c.Initialize
	c.UuidLocal = ""
	c.Nombre = ""
	c.Identificacion = ""
	c.Telefono = ""
	c.Direccion = ""
	c.ContactoCobro = ""
	c.CorreoCobro = ""
	Return c
End Sub

Public Sub ConsentimientoVacio As Consentimiento
	Dim c As Consentimiento
	c.Initialize
	c.Firmante = ""
	c.CedulaFirmante = ""
	c.Version = ""
	Dim sinFirma(0) As Byte
	c.Firma = sinFirma
	Return c
End Sub

Public Sub ContactoVacio As Contacto
	Dim k As Contacto
	k.Initialize
	k.UuidLocal = ""
	k.Nombre = ""
	k.Puesto = ""
	k.Telefono = ""
	k.Celular = ""
	k.Correo = ""
	Return k
End Sub

Public Sub UbicacionVacia As UbicacionGps
	Dim u As UbicacionGps
	u.Initialize
	u.Ok = False
	Return u
End Sub

Public Sub Opcion (Titulo As String, Detalle As String, Valor As Object) As OpcionBusqueda
	Dim o As OpcionBusqueda
	o.Initialize
	o.Titulo = Titulo
	o.Detalle = Detalle
	o.Valor = Valor
	Return o
End Sub

Public Sub PiezaVacia As Pieza
	Dim p As Pieza
	p.Initialize
	p.UuidLocal = ""
	p.Nombre = ""
	p.TipoTrabajo = ""
	p.Material = ""
	p.Acabado = ""
	p.CroquisJson = ""
	p.ListaMedidas.Initialize
	p.ListaFotos.Initialize
	Return p
End Sub
