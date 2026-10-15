B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Pantalla de sincronizacion: carga PageSincronizacion y arma la lista con la conexion, lo que
' falta subir, los errores, el boton y el historial. Se repinta al terminar cada sincronizacion.
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private presentador As PresentadorSincronizacion
	Private visible As Boolean
	Private ClvSync As CustomListView
	Private lblSyncConTitulo, lblSyncConEstado, lblSyncServidorRot, lblSyncServidor, lblSyncUltimaRot, lblSyncUltima As B4XView
	Private lblSyncPendTitulo, lblPend1Valor, lblPend2Valor, lblPend3Valor, lblPend1Titulo, lblPend2Titulo, lblPend3Titulo As B4XView
	Private pnPend1, pnPend2, pnPend3 As B4XView
	Private lblSyncErrorTitulo, lblSyncErrorMensaje, lblSyncReintentar As B4XView
	Private pnSyncAlDia, lblSyncAlDia, BtnSincronizarAhora As B4XView
	Private lblIntentoIcono, lblIntentoResultado, lblIntentoFecha, lblIntentoDetalle As B4XView
	Private lblSeccion As B4XView
	Private Const ALTO_CONEXION As Int = 108dip
	Private Const ALTO_PENDIENTES As Int = 116dip
	Private Const ALTO_ERROR As Int = 82dip
	Private Const ALTO_ACCION As Int = 108dip
	Private Const ALTO_ACCION_SOLA As Int = 56dip
	Private Const ALTO_INTENTO As Int = 70dip
	Private Const ALTO_SECCION As Int = 36dip
	Private Const RADIO_PASTILLA As Int = 10dip
	Private Const RADIO_ICONO As Int = 16dip
	Private Const ARRIBA_BOTON As Int = 6dip
End Sub

Public Sub Initialize As Object
	presentador.Initialize
	Return Me
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageSincronizacion")
	B4XPages.SetTitle(Me, Mensajes.SYNC_PANTALLA)
	UI.AplicarTema(Root)
End Sub

Private Sub B4XPage_Appear
	visible = True
	Pintar
	Wait For (presentador.Probar) Complete (EnLinea As Boolean)
	If visible Then PintarEstadoConexion
End Sub

Private Sub B4XPage_Disappear
	visible = False
End Sub

Public Sub SincronizacionTerminada (Resultado As ResumenSync)
	If Resultado.SesionVencida Then
		Api.VolverAlIngreso(Resultado.Mensaje)
		Return
	End If
	If visible Then Pintar
End Sub

Private Sub Pintar
	presentador.Actualizar
	ClvSync.Clear
	Dim ancho As Int = ClvSync.AsView.Width
	ClvSync.Add(CrearConexion(ancho), Null)
	ClvSync.Add(CrearPendientes(ancho), Null)
	If presentador.Errores.Size > 0 Then
		ClvSync.Add(CrearSeccion(ancho, Mensajes.SyncErrores(presentador.Errores.Size), Colores.COLOR_ERROR, True), Null)
		For Each e As ErrorSync In presentador.Errores
			ClvSync.Add(CrearError(ancho, e), e)
		Next
	End If
	ClvSync.Add(CrearAccion(ancho), Null)
	ClvSync.Add(CrearSeccion(ancho, Mensajes.SYNC_HISTORIAL, Colores.COLOR_PRIMARIO, True), Null)
	If presentador.Historial.Size = 0 Then ClvSync.Add(CrearSeccion(ancho, Mensajes.SYNC_SIN_HISTORIAL, Colores.COLOR_TEXTO_SECUNDARIO, False), Null)
	For Each i As IntentoSync In presentador.Historial
		ClvSync.Add(CrearIntento(ancho, i), Null)
	Next
End Sub

Private Sub Fila (Ancho As Int, Alto As Int) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, Ancho, Alto)
	Return p
End Sub

Private Sub CrearConexion (Ancho As Int) As B4XView
	Dim p As B4XView = Fila(Ancho, ALTO_CONEXION)
	p.LoadLayout("ItemSyncConexion")
	lblSyncConTitulo.Text = Mensajes.PERFIL_CONEXION
	lblSyncServidorRot.Text = Mensajes.ROTULO_SERVIDOR
	lblSyncServidor.Text = presentador.Servidor
	lblSyncUltimaRot.Text = Mensajes.SYNC_ULTIMA_EXITOSA
	lblSyncUltima.Text = presentador.UltimaExitosa
	PintarEstadoConexion
	Return p
End Sub

Private Sub PintarEstadoConexion
	Dim f As FranjaSync = presentador.EstadoConexion
	lblSyncConEstado.Text = f.Texto
	lblSyncConEstado.TextColor = f.Tinta
	lblSyncConEstado.SetColorAndBorder(f.Fondo, 0, f.Fondo, RADIO_PASTILLA)
End Sub

Private Sub CrearPendientes (Ancho As Int) As B4XView
	Dim p As B4XView = Fila(Ancho, ALTO_PENDIENTES)
	p.LoadLayout("ItemSyncPendientes")
	lblSyncPendTitulo.Text = Mensajes.SYNC_POR_SUBIR_TITULO
	lblPend1Titulo.Text = Mensajes.SYNC_CLIENTES
	lblPend2Titulo.Text = Mensajes.SYNC_SOLICITUDES
	lblPend3Titulo.Text = Mensajes.RESUMEN_FOTOS
	Dim valores() As Int = presentador.Pendientes
	Dim etiquetas() As B4XView = Array As B4XView(lblPend1Valor, lblPend2Valor, lblPend3Valor)
	Dim cajas() As B4XView = Array As B4XView(pnPend1, pnPend2, pnPend3)
	For k = 0 To 2
		etiquetas(k).Text = valores(k)
		If valores(k) > 0 Then
			etiquetas(k).TextColor = Colores.COLOR_ADVERTENCIA
			cajas(k).Color = Colores.COLOR_ADVERTENCIA_TENUE
		Else
			etiquetas(k).TextColor = Colores.COLOR_DESHABILITADO
		End If
	Next
	Return p
End Sub

Private Sub CrearError (Ancho As Int, e As ErrorSync) As B4XView
	Dim p As B4XView = Fila(Ancho, ALTO_ERROR)
	p.LoadLayout("ItemSyncError")
	lblSyncErrorTitulo.Text = presentador.TituloError(e)
	lblSyncErrorMensaje.Text = e.Mensaje
	lblSyncReintentar.Text = Mensajes.SYNC_REINTENTAR
	lblSyncReintentar.Tag = e
	Return p
End Sub

Private Sub CrearAccion (Ancho As Int) As B4XView
	Dim alDia As Boolean = presentador.AlDia
	Dim alto As Int = ALTO_ACCION_SOLA
	If alDia Then alto = ALTO_ACCION
	Dim p As B4XView = Fila(Ancho, alto)
	p.LoadLayout("ItemSyncAccion")
	pnSyncAlDia.Visible = alDia
	lblSyncAlDia.Text = Mensajes.SYNC_TODO_AL_DIA
	If alDia = False Then BtnSincronizarAhora.Top = ARRIBA_BOTON
	If presentador.EnCurso Then
		BtnSincronizarAhora.Text = Mensajes.SYNC_SINCRONIZANDO
		BtnSincronizarAhora.Enabled = False
	Else
		BtnSincronizarAhora.Text = Mensajes.SYNC_AHORA
	End If
	BtnSincronizarAhora.Tag = Utils.TAG_BTN
	If alDia Then BtnSincronizarAhora.Tag = Utils.TAG_SEC
	UI.AplicarVista(BtnSincronizarAhora)
	Return p
End Sub

Private Sub CrearIntento (Ancho As Int, i As IntentoSync) As B4XView
	Dim p As B4XView = Fila(Ancho, ALTO_INTENTO)
	p.LoadLayout("ItemSyncIntento")
	Dim f As FranjaSync = presentador.IconoDe(i)
	lblIntentoIcono.Text = f.Glifo
	lblIntentoIcono.TextColor = f.Tinta
	lblIntentoIcono.SetColorAndBorder(f.Fondo, 0, f.Fondo, RADIO_ICONO)
	lblIntentoResultado.Text = presentador.ResultadoDe(i)
	lblIntentoFecha.Text = presentador.FechaDe(i)
	lblIntentoDetalle.Text = presentador.DetalleDe(i)
	Return p
End Sub

Private Sub CrearSeccion (Ancho As Int, Texto As String, Tinta As Int, Negrita As Boolean) As B4XView
	Dim p As B4XView = Fila(Ancho, ALTO_SECCION)
	p.LoadLayout("ItemSeccion")
	lblSeccion.Text = Texto
	lblSeccion.TextColor = Tinta
	If Negrita = False Then lblSeccion.Font = xui.CreateDefaultFont(12)
	Return p
End Sub

Private Sub BtnSincronizarAhora_Click
	presentador.Sincronizar
	Pintar
End Sub

Private Sub lblSyncReintentar_Click
	Dim v As B4XView = Sender
	presentador.Reintentar(v.Tag)
	Pintar
End Sub
