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
	Type Consentimiento (Acepta As Boolean, Firmante As String, CedulaFirmante As String, Firma() As Byte)
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
	Dim sinFirma(0) As Byte
	c.Firma = sinFirma
	Return c
End Sub
