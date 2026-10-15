B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Cliente REST al estilo de TMVCRESTClient de DMVC: se configura encadenando llamadas y termina
' en un verbo resumible, o se arma con Preparar* en un modulo y quien llama espera Enviar.
Sub Class_Globals
	Private mBaseUrl As String
	Private mEncabezados As Map
	Private mRuta As Map
	Private mConsulta As List
	Private mCuerpo As String
	Private mTiempoMs As Int
	Private mMetodo As String
	Private mRecurso As String
	Private su As StringUtils
	Private Const CODIFICACION As String = "UTF8"
	Private Const TIPO_JSON As String = "application/json"
	Private Const TIEMPO_POR_DEFECTO_MS As Int = 30000
End Sub

Public Sub Initialize
	mEncabezados.Initialize
	mRuta.Initialize
	mConsulta.Initialize
	mCuerpo = ""
	mTiempoMs = TIEMPO_POR_DEFECTO_MS
End Sub

Public Sub BaseUrl (Url As String) As RestCliente
	mBaseUrl = Url.Trim
	Do While mBaseUrl.EndsWith("/")
		mBaseUrl = mBaseUrl.SubString2(0, mBaseUrl.Length - 1)
	Loop
	Return Me
End Sub

Public Sub ReadTimeout (Milisegundos As Int) As RestCliente
	mTiempoMs = Milisegundos
	Return Me
End Sub

Public Sub SetBearerAuthorization (Token As String) As RestCliente
	mEncabezados.Put("Authorization", "Bearer " & Token)
	Return Me
End Sub

Public Sub AddHeader (Nombre As String, Valor As String) As RestCliente
	mEncabezados.Put(Nombre, Valor)
	Return Me
End Sub

Public Sub AddPathParam (Nombre As String, Valor As String) As RestCliente
	mRuta.Put(Nombre, Valor)
	Return Me
End Sub

Public Sub AddBody (Cuerpo As Object) As RestCliente
	Dim generador As JSONGenerator
	If Cuerpo Is Map Then
		generador.Initialize(Cuerpo)
		mCuerpo = generador.ToString
	Else If Cuerpo Is List Then
		generador.Initialize2(Cuerpo)
		mCuerpo = generador.ToString
	Else
		mCuerpo = Cuerpo
	End If
	Return Me
End Sub

Public Sub PrepararGet (Recurso As String) As RestCliente
	Return Preparar("GET", Recurso)
End Sub

Public Sub PrepararPost (Recurso As String) As RestCliente
	Return Preparar("POST", Recurso)
End Sub

Public Sub PrepararPut (Recurso As String) As RestCliente
	Return Preparar("PUT", Recurso)
End Sub

Private Sub Preparar (Metodo As String, Recurso As String) As RestCliente
	mMetodo = Metodo
	mRecurso = Recurso
	Return Me
End Sub

Public Sub Enviar As ResumableSub
	Wait For (Ejecutar(mMetodo, mRecurso)) Complete (Respuesta As RestRespuesta)
	Return Respuesta
End Sub

Public Sub Get (Recurso As String) As ResumableSub
	Wait For (Ejecutar("GET", Recurso)) Complete (Respuesta As RestRespuesta)
	Return Respuesta
End Sub

Public Sub Post (Recurso As String) As ResumableSub
	Wait For (Ejecutar("POST", Recurso)) Complete (Respuesta As RestRespuesta)
	Return Respuesta
End Sub

Public Sub Put (Recurso As String) As ResumableSub
	Wait For (Ejecutar("PUT", Recurso)) Complete (Respuesta As RestRespuesta)
	Return Respuesta
End Sub

Public Sub Patch (Recurso As String) As ResumableSub
	Wait For (Ejecutar("PATCH", Recurso)) Complete (Respuesta As RestRespuesta)
	Return Respuesta
End Sub

Public Sub Delete (Recurso As String) As ResumableSub
	Wait For (Ejecutar("DELETE", Recurso)) Complete (Respuesta As RestRespuesta)
	Return Respuesta
End Sub

Private Sub ArmarUrl (Recurso As String) As String
	Dim ruta As String = Recurso
	For Each nombre As String In mRuta.Keys
		ruta = ruta.Replace("($" & nombre & ")", su.EncodeUrl(mRuta.Get(nombre), CODIFICACION))
	Next
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append(mBaseUrl).Append(ruta)
	For i = 0 To mConsulta.Size - 1
		Dim par() As String = mConsulta.Get(i)
		If i = 0 Then sb.Append("?") Else sb.Append("&")
		sb.Append(su.EncodeUrl(par(0), CODIFICACION)).Append("=").Append(su.EncodeUrl(par(1), CODIFICACION))
	Next
	Return sb.ToString
End Sub

Private Sub Ejecutar (Metodo As String, Recurso As String) As ResumableSub
	Dim j As HttpJob
	j.Initialize("", Me)
	Dim destino As String = ArmarUrl(Recurso)
	Select Metodo
		Case "POST"
			j.PostString(destino, mCuerpo)
		Case "PUT"
			j.PutString(destino, mCuerpo)
		Case "PATCH"
			j.PatchString(destino, mCuerpo)
		Case "DELETE"
			j.Delete(destino)
		Case Else
			j.Download(destino)
	End Select
	If Metodo = "POST" Or Metodo = "PUT" Or Metodo = "PATCH" Then j.GetRequest.SetContentType(TIPO_JSON)
	j.GetRequest.SetHeader("Accept", TIPO_JSON)
	For Each nombre As String In mEncabezados.Keys
		j.GetRequest.SetHeader(nombre, mEncabezados.Get(nombre))
	Next
	j.GetRequest.Timeout = mTiempoMs
	Wait For (j) JobDone (j As HttpJob)
	Dim respuesta As RestRespuesta
	respuesta.Initialize(j)
	j.Release
	Return respuesta
End Sub
