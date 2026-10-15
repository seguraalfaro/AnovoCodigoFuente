B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador de la nueva cotizacion en tres pasos (cliente, detalles, revision):
' lleva el borrador, el cliente, el contacto y las piezas, y valida cada paso. No conoce vistas.

Sub Class_Globals
	Private Const TIPO_BORRADOR As String = "cotizacion"
	Private Const CLAVE_CLIENTE As String = "cliente"
	Private Const CLAVE_CONTACTO As String = "contacto"
	Private Const CLAVE_PROYECTO As String = "proyecto"
	Private Const CLAVE_PIEZAS As String = "piezas"
	Private Const CLAVE_OBSERVACIONES As String = "observaciones"
	Private Const CLAVE_PAGINA As String = "pagina"
	Private Const PASO_CLIENTE As Int = 0
	Private Const PASO_DETALLES As Int = 1
	Private Const MAX_OBSERVACIONES As Int = 500
	Private Const SEPARADOR As String = " · "

	Private mCliente As Cliente
	Private mContacto As Contacto
	Private mProyecto As String
	Private mPiezas As List
	Private mObservaciones As String
	Private mPagina As Int
End Sub

Public Sub Initialize
	Nuevo
End Sub

#Region Estado
Public Sub getHayBorrador As Boolean
	Return Db.HayBorrador(TIPO_BORRADOR)
End Sub

Public Sub Nuevo
	mCliente = Tipos.ClienteVacio
	mContacto = Tipos.ContactoVacio
	mProyecto = ""
	mPiezas.Initialize
	mObservaciones = ""
	mPagina = PASO_CLIENTE
End Sub

Public Sub DescartarBorrador
	For Each p As Pieza In mPiezas
		Adjuntos.BorrarFotos(p.ListaFotos)
	Next
	Db.BorrarBorrador(TIPO_BORRADOR)
	Dim piezaSinTerminar As PresentadorEspecificaciones
	piezaSinTerminar.Initialize
	piezaSinTerminar.DescartarBorrador
	Nuevo
End Sub

Public Sub Restaurar As Boolean
	Dim b As Map = Db.LeerBorrador(TIPO_BORRADOR)
	If b.ContainsKey(CLAVE_PIEZAS) = False Then
		DescartarBorrador
		Return False
	End If
	mCliente = b.GetDefault(CLAVE_CLIENTE, Tipos.ClienteVacio)
	mContacto = b.GetDefault(CLAVE_CONTACTO, Tipos.ContactoVacio)
	mProyecto = b.GetDefault(CLAVE_PROYECTO, "")
	mPiezas = b.Get(CLAVE_PIEZAS)
	mObservaciones = b.GetDefault(CLAVE_OBSERVACIONES, "")
	mPagina = b.GetDefault(CLAVE_PAGINA, PASO_CLIENTE)
	Return True
End Sub

Public Sub GuardarBorrador (NombreProyecto As String, TextoObservaciones As String, Hoja As Int)
	mProyecto = NombreProyecto
	mObservaciones = TextoObservaciones
	mPagina = Hoja
	If getHayCliente = False And NombreProyecto = "" And TextoObservaciones = "" And mPiezas.Size = 0 Then
		Db.BorrarBorrador(TIPO_BORRADOR)
		Return
	End If
	Db.GuardarBorrador(TIPO_BORRADOR, CreateMap(CLAVE_CLIENTE: mCliente, CLAVE_CONTACTO: mContacto, _
		CLAVE_PROYECTO: mProyecto, CLAVE_PIEZAS: mPiezas, CLAVE_OBSERVACIONES: mObservaciones, _
		CLAVE_PAGINA: mPagina))
End Sub
#End Region

#Region Lo que pinta la página
Public Sub getHayCliente As Boolean
	Return mCliente.UuidLocal <> ""
End Sub

Public Sub getTextoCliente As String
	Return mCliente.Nombre
End Sub

Public Sub getTextoContacto As String
	Return mContacto.Nombre
End Sub

Public Sub getProyecto As String
	Return mProyecto
End Sub

Public Sub getPiezas As List
	Return mPiezas
End Sub

Public Sub getObservaciones As String
	Return mObservaciones
End Sub

Public Sub getPagina As Int
	Return mPagina
End Sub

Public Sub getTotalMedidas As Int
	Dim total As Int
	For Each p As Pieza In mPiezas
		total = total + p.Medidas
	Next
	Return total
End Sub

Public Sub getTotalCroquis As Int
	Dim total As Int
	For Each p As Pieza In mPiezas
		If p.Croquis Then total = total + 1
	Next
	Return total
End Sub

Public Sub getMaxObservaciones As Int
	Return MAX_OBSERVACIONES
End Sub

Public Sub getTextoUbicacion As String
	If getHayCliente = False Then Return Mensajes.UBICACION_SIN
	Return Mensajes.Coordenadas(DbClientes.UbicacionDe(mCliente.UuidLocal))
End Sub

Public Sub getTotalFotos As Int
	Dim total As Int
	For Each p As Pieza In mPiezas
		total = total + p.Fotos
	Next
	Return total
End Sub

Public Sub OpcionesClientes As List
	Dim res As List
	res.Initialize
	For Each c As Cliente In DbClientes.Lista
		res.Add(Tipos.Opcion(c.Nombre, Unir(Array As String(c.Identificacion, c.Telefono)), c))
	Next
	Return res
End Sub

Public Sub OpcionesContactos As List
	Dim res As List
	res.Initialize
	If getHayCliente = False Then Return res
	For Each k As Contacto In DbClientes.ContactosDe(mCliente.UuidLocal)
		res.Add(Tipos.Opcion(k.Nombre, Unir(Array As String(k.Puesto, k.Celular, k.Telefono)), k))
	Next
	Return res
End Sub
#End Region

#Region Acciones
Public Sub ElegirCliente (c As Cliente)
	If c.UuidLocal = mCliente.UuidLocal Then Return
	mCliente = c
	mContacto = Tipos.ContactoVacio
End Sub

Public Sub ElegirContacto (k As Contacto)
	mContacto = k
End Sub

Public Sub Guardar (NombreProyecto As String, TextoObservaciones As String) As Resultado
	For Each paso As Int In Array As Int(PASO_CLIENTE, PASO_DETALLES)
		Dim r As Resultado = ValidarPaso(paso)
		If r.Ok = False Then Return r
	Next
	Dim s As Solicitud
	s.Initialize
	s.UuidLocal = Db.NuevoUuid
	s.ClienteUuid = mCliente.UuidLocal
	s.ContactoUuid = mContacto.UuidLocal
	s.NombreProyecto = NombreProyecto.Trim
	s.Observaciones = TextoObservaciones.Trim
	s.Descripcion = DescripcionDe(s.NombreProyecto)
	Dim uuid As String = DbSolicitudes.Guardar(s, mPiezas)
	If uuid = "" Then Return Tipos.Falla(Mensajes.SOLICITUD_NO_GUARDADA)
	Db.BorrarBorrador(TIPO_BORRADOR)
	Nuevo
	Return Tipos.Correcto(uuid)
End Sub

Public Sub ValidarPaso (Paso As Int) As Resultado
	If Paso = PASO_CLIENTE And getHayCliente = False Then Return Tipos.Falla(Mensajes.FALTA_CLIENTE)
	If Paso = PASO_CLIENTE And mContacto.UuidLocal = "" Then Return Tipos.Falla(Mensajes.FALTA_CONTACTO)
	If Paso = PASO_DETALLES And mPiezas.Size = 0 Then Return Tipos.Falla(Mensajes.SIN_PIEZAS)
	Return Tipos.Correcto(Null)
End Sub

Public Sub ObservacionesExcedidas (Texto As String) As Boolean
	Return Texto.Length > MAX_OBSERVACIONES
End Sub

Public Sub AgregarPieza (p As Pieza) As Pieza
	p.UuidLocal = Db.NuevoUuid
	mPiezas.Add(p)
	Return p
End Sub

Public Sub ReemplazarPieza (p As Pieza) As Int
	Dim i As Int = IndicePieza(p.UuidLocal)
	If i >= 0 Then mPiezas.Set(i, p)
	Return i
End Sub

Public Sub QuitarPieza (Uuid As String) As Int
	For i = 0 To mPiezas.Size - 1
		Dim p As Pieza = mPiezas.Get(i)
		If p.UuidLocal = Uuid Then
			Adjuntos.BorrarFotos(p.ListaFotos)
			mPiezas.RemoveAt(i)
			Return i
		End If
	Next
	Return -1
End Sub
#End Region

#Region Textos de cada fila
Public Sub DetallePieza (p As Pieza) As String
	Dim partes As List
	partes.Initialize
	partes.AddAll(Array As String(p.TipoTrabajo, p.Material, p.Acabado))
	If p.Medidas > 0 Then partes.Add(Mensajes.PiezaMedidas(p.Medidas))
	Dim valores(partes.Size) As String
	For i = 0 To partes.Size - 1
		valores(i) = partes.Get(i)
	Next
	Return Unir(valores)
End Sub

Public Sub PiezaIncompleta (p As Pieza) As Boolean
	Return p.Croquis = False Or p.Fotos = 0
End Sub

Public Sub EstadoPieza (p As Pieza) As String
	If p.Croquis = False And p.Fotos = 0 Then Return Mensajes.PIEZA_SIN_ADJUNTOS
	If p.Croquis = False Then Return Mensajes.PIEZA_SIN_CROQUIS
	If p.Fotos = 0 Then Return Mensajes.PIEZA_SIN_FOTOS
	Return Mensajes.PiezaAdjuntos(p.Fotos)
End Sub
#End Region

#Region Ayudantes
Private Sub DescripcionDe (NombreProyecto As String) As String
	If NombreProyecto <> "" Then Return NombreProyecto
	Dim nombres(mPiezas.Size) As String
	For i = 0 To mPiezas.Size - 1
		Dim p As Pieza = mPiezas.Get(i)
		nombres(i) = p.Nombre
	Next
	Return Unir(nombres)
End Sub

Public Sub PiezaPorUuid (Uuid As String) As Pieza
	Dim i As Int = IndicePieza(Uuid)
	If i < 0 Then Return Tipos.PiezaVacia
	Return mPiezas.Get(i)
End Sub

Private Sub IndicePieza (Uuid As String) As Int
	If Uuid = "" Then Return -1
	For i = 0 To mPiezas.Size - 1
		Dim p As Pieza = mPiezas.Get(i)
		If p.UuidLocal = Uuid Then Return i
	Next
	Return -1
End Sub

Private Sub Unir (Valores() As String) As String
	Dim sb As StringBuilder
	sb.Initialize
	For Each v As String In Valores
		If v.Trim = "" Then Continue
		If sb.Length > 0 Then sb.Append(SEPARADOR)
		sb.Append(v.Trim)
	Next
	Return sb.ToString
End Sub
#End Region
