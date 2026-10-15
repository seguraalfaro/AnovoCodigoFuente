B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador del registro de cliente en tres pasos (datos, contactos, permiso):
' lleva el borrador, valida cada paso y guarda. No conoce vistas.

Sub Class_Globals
	Private Const TIPO_BORRADOR As String = "cliente"
	Private Const CLAVE_CLIENTE As String = "cliente"
	Private Const CLAVE_CONTACTOS As String = "contactos"
	Private Const CLAVE_CONSENTIMIENTO As String = "consentimiento"
	Private Const CLAVE_PAGINA As String = "pagina"
	Private Const CLAVE_UBICACION As String = "ubicacion"
	Private Const GLIFO_UBICACION As Int = 0xF041
	Private Const PASO_DATOS As Int = 0
	Private Const PASO_CONTACTOS As Int = 1
	Private Const SEPARADOR As String = "  ·  "

	Private mCliente As Cliente
	Private mContactos As List
	Private mConsentimiento As Consentimiento
	Private mPagina As Int
	Private mUbicacion As UbicacionGps
	Private mBuscando As Boolean
End Sub

Public Sub Initialize
	mContactos.Initialize
	Nuevo
End Sub

#Region Estado
Public Sub getHayBorrador As Boolean
	Return Db.HayBorrador(TIPO_BORRADOR)
End Sub

Public Sub Nuevo
	mCliente = Tipos.ClienteVacio
	mCliente.UuidLocal = Db.NuevoUuid
	mContactos.Initialize
	mConsentimiento = Tipos.ConsentimientoVacio
	mPagina = PASO_DATOS
	mUbicacion = Tipos.UbicacionVacia
	mBuscando = False
End Sub

Public Sub DescartarBorrador
	Db.BorrarBorrador(TIPO_BORRADOR)
	Nuevo
End Sub

Public Sub Restaurar As Boolean
	Dim b As Map = Db.LeerBorrador(TIPO_BORRADOR)
	If b.ContainsKey(CLAVE_CLIENTE) = False Then
		DescartarBorrador
		Return False
	End If
	mCliente = b.Get(CLAVE_CLIENTE)
	mContactos = b.Get(CLAVE_CONTACTOS)
	mConsentimiento = b.Get(CLAVE_CONSENTIMIENTO)
	mPagina = b.GetDefault(CLAVE_PAGINA, PASO_DATOS)
	mUbicacion = b.GetDefault(CLAVE_UBICACION, Tipos.UbicacionVacia)
	mBuscando = False
	Return True
End Sub

Public Sub GuardarBorrador (DatosCliente As Cliente, PermisoActual As Consentimiento, Hoja As Int)
	DatosCliente.UuidLocal = mCliente.UuidLocal
	mCliente = DatosCliente
	mConsentimiento = PermisoActual
	mPagina = Hoja
	If DatosCliente.Nombre = "" And mContactos.Size = 0 Then
		Db.BorrarBorrador(TIPO_BORRADOR)
		Return
	End If
	Dim sinFirma As Consentimiento = Tipos.ConsentimientoVacio
	sinFirma.Acepta = PermisoActual.Acepta
	sinFirma.Firmante = PermisoActual.Firmante
	sinFirma.CedulaFirmante = PermisoActual.CedulaFirmante
	Db.GuardarBorrador(TIPO_BORRADOR, CreateMap(CLAVE_CLIENTE: mCliente, CLAVE_CONTACTOS: mContactos, _
		CLAVE_CONSENTIMIENTO: sinFirma, CLAVE_PAGINA: mPagina, CLAVE_UBICACION: mUbicacion))
End Sub
#End Region

#Region Lo que pinta la página
Public Sub getPuedeReintentarUbicacion As Boolean
	Return mBuscando = False And mUbicacion.Ok = False
End Sub

Public Sub getFranjaUbicacion As FranjaSync
	Dim f As FranjaSync
	f.Initialize
	f.Glifo = Chr(GLIFO_UBICACION)
	f.Accion = ""
	If mBuscando Then
		f.Texto = Mensajes.UBICACION_BUSCANDO
		f.Tinta = Colores.COLOR_MEDIO
		f.Fondo = Colores.COLOR_PRIMARIO_TENUE
	Else If mUbicacion.Ok Then
		f.Texto = Mensajes.UbicacionCapturada(Round(mUbicacion.Precision))
		f.Tinta = Colores.COLOR_EXITO
		f.Fondo = Colores.COLOR_EXITO_TENUE
	Else
		f.Texto = Mensajes.UBICACION_SIN
		f.Accion = Mensajes.SYNC_REINTENTAR
		f.Tinta = Colores.COLOR_ADVERTENCIA
		f.Fondo = Colores.COLOR_ADVERTENCIA_TENUE
	End If
	Return f
End Sub

Public Sub getDatos As Cliente
	Return mCliente
End Sub

Public Sub getContactos As List
	Return mContactos
End Sub

Public Sub getPermiso As Consentimiento
	Return mConsentimiento
End Sub

Public Sub getPagina As Int
	Return mPagina
End Sub

Public Sub getFirmantes As List
	Dim nombres As List
	nombres.Initialize
	nombres.Add("")
	For Each c As Contacto In mContactos
		Dim n As String = c.Nombre.Trim
		If n <> "" And nombres.IndexOf(n) < 0 Then nombres.Add(n)
	Next
	Return nombres
End Sub
#End Region

#Region Acciones
Public Sub BuscandoUbicacion
	mBuscando = True
End Sub

Public Sub FijarUbicacion (u As UbicacionGps)
	mUbicacion = u
	mBuscando = False
End Sub

Public Sub ValidarPaso (Paso As Int, CamposCompletos As Boolean) As Resultado
	If Paso = PASO_DATOS And CamposCompletos = False Then Return Tipos.Falla(Mensajes.CAMPOS_INCOMPLETOS)
	If Paso = PASO_CONTACTOS And mContactos.Size = 0 Then Return Tipos.Falla(Mensajes.SIN_CONTACTOS)
	Return Tipos.Correcto(Null)
End Sub

Public Sub AgregarContacto (c As Contacto) As Contacto
	c.UuidLocal = Db.NuevoUuid
	mContactos.Add(c)
	Return c
End Sub

Public Sub QuitarContacto (Uuid As String) As Int
	For i = 0 To mContactos.Size - 1
		Dim c As Contacto = mContactos.Get(i)
		If c.UuidLocal = Uuid Then
			mContactos.RemoveAt(i)
			Return i
		End If
	Next
	Return -1
End Sub

Public Sub Guardar (PermisoActual As Consentimiento) As Resultado
	If PermisoActual.Acepta = False Then Return Tipos.Falla(Mensajes.FALTA_ACEPTAR)
	If PermisoActual.Firma.Length = 0 Then Return Tipos.Falla(Mensajes.FALTA_FIRMA)
	Dim uuid As String = DbClientes.Guardar(mCliente, mContactos, PermisoActual, mUbicacion)
	If uuid = "" Then Return Tipos.Falla(Mensajes.CLIENTE_NO_GUARDADO)
	Db.BorrarBorrador(TIPO_BORRADOR)
	Nuevo
	Return Tipos.Correcto(uuid)
End Sub
#End Region

#Region Textos de cada fila
Public Sub DetalleContacto (c As Contacto) As String
	Dim partes As List
	partes.Initialize
	For Each valor As String In Array As String(c.Telefono, c.Celular, c.Correo)
		If valor.Trim <> "" Then partes.Add(valor.Trim)
	Next
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To partes.Size - 1
		If i > 0 Then sb.Append(SEPARADOR)
		sb.Append(partes.Get(i))
	Next
	Return sb.ToString
End Sub
#End Region
