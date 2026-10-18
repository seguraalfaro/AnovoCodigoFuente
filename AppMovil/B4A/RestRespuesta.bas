B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Respuesta de RestCliente, al estilo de IMVCRESTResponse de DMVC: estado,
' contenido, encabezados, los datos del sobre "data" y el error de la API.
Sub Class_Globals
	Public Success As Boolean
	Public StatusCode As Int
	Public Content As String
	Public Codigo As String
	Public Mensaje As String
	Public Detalles As List
	Private mEncabezados As Map
	Private mJson As Map
End Sub

Public Sub Initialize (Job As HttpJob)
	Success = Job.Success
	mEncabezados.Initialize
	StatusCode = 0
	Try
		StatusCode = Job.Response.StatusCode
		mEncabezados = Job.Response.GetHeaders
	Catch
		StatusCode = 0
	End Try
	If Success Then
		Content = Job.GetString
	Else
		Content = Job.ErrorMessage
	End If
	mJson = LeerJson(Content)
	Codigo = ""
	Mensaje = ""
	Detalles.Initialize
	If Success = False Then LeerError
End Sub

Private Sub LeerJson (Texto As String) As Map
	Dim vacio As Map
	vacio.Initialize
	If Texto = Null Then Return vacio
	If Texto.Trim.StartsWith("{") = False Then Return vacio
	Try
		Dim parser As JSONParser
		parser.Initialize(Texto)
		Return parser.NextObject
	Catch
		Return vacio
	End Try
End Sub

Private Sub LeerError
	Codigo = "ERROR"
	Dim e As Object = mJson.Get("error")
	If e Is Map Then
		Dim m As Map = e
		Codigo = m.GetDefault("codigo", "ERROR")
		Mensaje = m.GetDefault("mensaje", "")
		Dim lista As Object = m.Get("detalles")
		If lista Is List Then
			For Each d As Object In lista.As(List)
				If d Is Map Then
					Dim texto As String = d.As(Map).GetDefault("mensaje", "")
					If texto.Trim <> "" Then Detalles.Add(texto.Trim)
				End If
			Next
		End If
	End If
End Sub

Public Sub Valor (Llave As String) As Object
	Return mJson.Get(Llave)
End Sub

Public Sub DatosMap As Map
	Dim d As Object = mJson.Get("data")
	If d Is Map Then Return d
	Dim vacio As Map
	vacio.Initialize
	Return vacio
End Sub

Public Sub HeaderValue (Nombre As String) As String
	For Each llave As String In mEncabezados.Keys
		If llave.EqualsIgnoreCase(Nombre) Then
			Dim valores As List = mEncabezados.Get(llave)
			If valores.Size > 0 Then Return valores.Get(0)
		End If
	Next
	Return ""
End Sub
