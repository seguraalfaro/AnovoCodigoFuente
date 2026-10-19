B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador de la ficha del cliente: datos, estado de subida, contactos y el
' ultimo permiso de datos. Solo consulta. No conoce vistas.

Sub Class_Globals
	Private Const SEPARADOR As String = " · "
	Private Const TIPO_JURIDICA As Int = 1
	Private Const SIN_DATO As String = "-"
	Private mCliente As Cliente
	Private mEstado As String
	Private mContactos As List
	Private mPermiso As PermisoCliente
	Private mConsentimiento As String
End Sub

Public Sub Initialize
	mCliente = Tipos.ClienteVacio
	mContactos.Initialize
End Sub

#Region Estado
Public Sub Cargar (c As Cliente)
	mCliente = c
	mEstado = DbClientes.EstadoDe(c.UuidLocal)
	mContactos = DbClientes.ContactosDe(c.UuidLocal)
	mPermiso = DbClientes.UltimoPermiso(c.UuidLocal)
	mConsentimiento = DbClientes.ConsentimientoDe(c.UuidLocal)
End Sub
#End Region

#Region Lo que pinta la página
Public Sub getClienteActual As Cliente
	Return mCliente
End Sub

Public Sub getNombre As String
	Return mCliente.Nombre
End Sub

Public Sub getIdentificacion As String
	Dim tipo As String = ""
	If mCliente.TipoIdentificacion >= 0 And mCliente.TipoIdentificacion < Utils.TiposIdent.Length Then tipo = Utils.TiposIdent(mCliente.TipoIdentificacion)
	Return Utils.Unir(SEPARADOR, Array As String(tipo, mCliente.Identificacion))
End Sub

Public Sub getTelefono As String
	Return ConGuion(mCliente.Telefono)
End Sub

Public Sub getDireccion As String
	Return ConGuion(mCliente.Direccion)
End Sub

Public Sub getCobro As String
	Return ConGuion(Utils.Unir(SEPARADOR, Array As String(mCliente.ContactoCobro, mCliente.CorreoCobro)))
End Sub

Public Sub getEsJuridica As Boolean
	Return mCliente.TipoIdentificacion = TIPO_JURIDICA
End Sub

Public Sub getEstadoPastilla As String
	Return Mensajes.PastillaCliente(mEstado)
End Sub

Public Sub getTintaEstado As Int
	Return Colores.TintaPastilla(mEstado)
End Sub

Public Sub getFondoEstado As Int
	Return Colores.FondoPastilla(mEstado)
End Sub

Public Sub getContactos As List
	Return mContactos
End Sub

Private Sub FaltaFirma As Boolean
	If mEstado <> "confirmado" Then Return False
	Return mConsentimiento = DbClientes.CONSENTIMIENTO_PENDIENTE Or mConsentimiento = DbClientes.CONSENTIMIENTO_REVOCADO
End Sub

Public Sub getPuedeFirmar As Boolean
	Return FaltaFirma And Sesion.Tiene(Sesion.PERMISO_CLIENTES_CONSENTIMIENTO)
End Sub

Public Sub getPuedeCrearSolicitud As Boolean
	Return Sesion.Tiene(Sesion.PERMISO_SOLICITUDES_CREAR)
End Sub

Public Sub getPermiso As String
	If FaltaFirma Then Return Mensajes.PermisoSegunEstado(mConsentimiento)
	Return Mensajes.TextoPermiso(mPermiso.Accion, mPermiso.Firmante)
End Sub

Public Sub getDetallePermiso As String
	If getPuedeFirmar Then Return Mensajes.TOCAR_PARA_FIRMAR
	If FaltaFirma Then Return Mensajes.SIN_PERMISO_FIRMAR
	If mPermiso.Accion = "" Then Return ""
	Return Mensajes.PermisoDetalle(Utils.BdADisplay(mPermiso.Fecha), mPermiso.Version)
End Sub
#End Region

#Region Textos de cada fila
Public Sub DetalleContacto (k As Contacto) As String
	Return Utils.Unir(SEPARADOR, Array As String(k.Puesto, k.Celular, k.Telefono, k.Correo))
End Sub
#End Region

#Region Ayudantes
Private Sub ConGuion (Texto As String) As String
	If Texto = Null Or Texto.Trim = "" Then Return SIN_DATO
	Return Texto
End Sub
#End Region
