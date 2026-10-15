B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Hoja de Perfil: carga PagePerfil y, dentro del ScrollView, PerfilContenido, con las tarjetas
' de Configuracion del escritorio. La pagina le pasa su raiz y recibe CerrarSesion.

Sub Class_Globals
	Private xui As XUI
	Private mRaiz As B4XView
	Private mPagina As Object
	Private mRaizPagina As B4XView
	Private presentador As PresentadorPerfil
	Private huella As Desbloqueo
	Private dialogo As B4XDialog
	Private txtClaveActual, txtClaveNueva, txtClaveRepetir As B4XFloatTextField
	Private lblClaveNota As B4XView
	Private Const ALTO_DIALOGO As Int = 216dip
	Private Const ANCHO_DIALOGO As Int = 320dip
	Private Const LARGO_CLAVE As Int = 10
	Private Const EVENTO_CERRAR As String = "CerrarSesion"

	Private svPerfil As ScrollView
	Private pnContenido As B4XView
	Private lblIniciales, lblNombre, lblCorreo, lblRol As B4XView
	Private lblCuentaTitulo, lblPermisosRot, lblPermisos, lblClaveRot, lblClave As B4XView
	Private lblConexionTitulo, lblServidorRot, lblServidor, lblEstadoRot, lblEstado, lblRespuestaRot, lblRespuesta As B4XView
	Private lblSinConexionTitulo, lblSinConexionTexto, lblDesbloqueoRot, lblDesbloqueo As B4XView
	Private lblAcercaDeTitulo, lblAppRot, lblApp, lblMovilRot, lblMovil, lblVerServidorRot, lblVerServidor As B4XView
	Private lblBaseRot, lblBase, lblAvisoRot, lblAviso As B4XView
	Private BtnCambiarClave, BtnProbar, BtnDesbloqueo, BtnCerrarSesion As B4XView
End Sub

Public Sub Initialize (Raiz As B4XView, Pagina As Object, RaizPagina As B4XView)
	mRaiz = Raiz
	mPagina = Pagina
	mRaizPagina = RaizPagina
	presentador.Initialize
	huella.Initialize
	mRaiz.LoadLayout("PagePerfil")
	svPerfil.Panel.LoadLayout("PerfilContenido")
	svPerfil.Panel.Height = pnContenido.Height
	UI.AplicarTema(mRaiz)
	PonerTextos
End Sub

#Region Pintar
Private Sub PonerTextos
	lblCuentaTitulo.Text = Mensajes.PERFIL_MI_CUENTA
	lblPermisosRot.Text = Mensajes.ROTULO_PERMISOS
	lblClaveRot.Text = Mensajes.ROTULO_CLAVE
	BtnCambiarClave.Text = Mensajes.CAMBIAR_MI_CLAVE
	lblConexionTitulo.Text = Mensajes.PERFIL_CONEXION
	lblServidorRot.Text = Mensajes.ROTULO_SERVIDOR
	lblEstadoRot.Text = Mensajes.ROTULO_ESTADO
	lblRespuestaRot.Text = Mensajes.ROTULO_RESPUESTA
	BtnProbar.Text = Mensajes.PROBAR_CONEXION
	lblSinConexionTitulo.Text = Mensajes.PERFIL_SIN_CONEXION_TITULO
	lblSinConexionTexto.Text = Mensajes.PERFIL_SIN_CONEXION_TEXTO
	lblDesbloqueoRot.Text = Mensajes.ROTULO_ESTADO
	lblAcercaDeTitulo.Text = Mensajes.PERFIL_ACERCA_DE
	lblAppRot.Text = Mensajes.ROTULO_APP
	lblMovilRot.Text = Mensajes.ROTULO_MOVIL_DISPONIBLE
	lblVerServidorRot.Text = Mensajes.ROTULO_SERVIDOR
	lblBaseRot.Text = Mensajes.ROTULO_BASE
	lblAvisoRot.Text = Mensajes.ROTULO_AVISO
	BtnCerrarSesion.Text = Mensajes.MENU_CERRAR_SESION
End Sub

Public Sub Mostrar
	Pintar
	Wait For (presentador.Cargar) Complete (Hecho As Boolean)
	Pintar
End Sub

Private Sub Pintar
	lblIniciales.Text = presentador.Iniciales
	lblIniciales.SetColorAndBorder(Colores.COLOR_PRIMARIO_TENUE, 0, Colores.COLOR_PRIMARIO_TENUE, lblIniciales.Height / 2)
	lblRol.SetColorAndBorder(Colores.COLOR_PRIMARIO_TENUE, 0, Colores.COLOR_PRIMARIO_TENUE, lblRol.Height / 2)
	lblNombre.Text = presentador.Nombre
	lblCorreo.Text = presentador.Correo
	lblRol.Text = presentador.Rol
	lblPermisos.Text = presentador.Permisos
	lblClave.Text = presentador.ClaveCambiada

	lblServidor.Text = presentador.Servidor
	lblEstado.Text = presentador.EstadoConexion
	lblEstado.TextColor = Colores.COLOR_TEXTO_PRIMARIO
	If presentador.Conectado Then lblEstado.TextColor = Colores.COLOR_EXITO
	lblRespuesta.Text = presentador.Respuesta

	Dim activo As Boolean = LlaveDispositivo.DesbloqueoActivo
	lblDesbloqueo.Text = Mensajes.EstadoDesbloqueo(activo)
	lblDesbloqueo.TextColor = Colores.COLOR_TEXTO_SECUNDARIO
	If activo Then lblDesbloqueo.TextColor = Colores.COLOR_EXITO
	BtnDesbloqueo.Text = Mensajes.AccionDesbloqueo(activo)
	BtnDesbloqueo.Tag = Utils.TAG_BTN
	If activo Then BtnDesbloqueo.Tag = Utils.TAG_SEC
	UI.AplicarVista(BtnDesbloqueo)

	lblApp.Text = presentador.VersionApp
	lblMovil.Text = presentador.VersionMovil
	lblVerServidor.Text = presentador.VersionServidor
	lblBase.Text = presentador.VersionBase
	lblAviso.Text = presentador.VersionAviso
End Sub
#End Region

#Region Eventos
Private Sub BtnProbar_Click
	Wait For (presentador.Probar) Complete (Hecho As Boolean)
	Pintar
End Sub

Private Sub BtnCerrarSesion_Click
	CallSub(mPagina, EVENTO_CERRAR)
End Sub

Private Sub BtnDesbloqueo_Click
	If LlaveDispositivo.DesbloqueoActivo Then
		LlaveDispositivo.ActivarDesbloqueo(False)
		Pintar
		Return
	End If
	Dim aviso As String = PorQueNo
	If aviso <> "" Then
		xui.MsgboxAsync(aviso, Mensajes.TITULO)
		Return
	End If
	Wait For (huella.Pedir(Mensajes.DESBLOQUEO_TITULO, Mensajes.DESBLOQUEO_ACTIVAR)) Complete (Identificado As Boolean)
	If Identificado = False Then
		If huella.UltimoMensaje <> "" Then xui.MsgboxAsync(huella.UltimoMensaje, Mensajes.TITULO)
		Return
	End If
	LlaveDispositivo.ActivarDesbloqueo(True)
	Pintar
End Sub

Private Sub BtnCambiarClave_Click
	Dim pnl As B4XView = xui.CreatePanel("")
	pnl.SetLayoutAnimated(0, 0, 0, Min(mRaizPagina.Width - 48dip, ANCHO_DIALOGO), ALTO_DIALOGO)
	pnl.LoadLayout("DialogoClave")
	UI.AplicarTema(pnl)
	txtClaveActual.HintText = Mensajes.CLAVE_ACTUAL
	txtClaveNueva.HintText = Mensajes.CLAVE_NUEVA
	txtClaveRepetir.HintText = Mensajes.CLAVE_REPETIR
	For Each campo As B4XFloatTextField In Array As B4XFloatTextField(txtClaveActual, txtClaveNueva, txtClaveRepetir)
		campo.Update
	Next
	lblClaveNota.Text = Mensajes.ClaveCorta(LARGO_CLAVE)

	dialogo.Initialize(mRaizPagina)
	UI.EstilizarDialogo(dialogo)
	dialogo.Title = Mensajes.CAMBIAR_MI_CLAVE
	Dim rs As Object = dialogo.ShowCustom(pnl, Mensajes.GUARDAR, "", Mensajes.CANCELAR)
	UI.AjustarBarraTitulo(dialogo)
	UI.CentrarDialogo(dialogo)
	Wait For (rs) Complete (Respuesta As Int)
	If Respuesta <> xui.DialogResponse_Positive Then Return
	Wait For (presentador.CambiarClave(txtClaveActual.Text, txtClaveNueva.Text, txtClaveRepetir.Text)) Complete (r As Resultado)
	If r.Ok Then
		xui.MsgboxAsync(r.Datos, Mensajes.TITULO)
	Else
		xui.MsgboxAsync(r.Mensaje, Mensajes.TITULO)
	End If
	Pintar
End Sub
#End Region

#Region Acciones
Private Sub PorQueNo As String
	If LlaveDispositivo.HayLlave = False Then Return Mensajes.PERFIL_SIN_REGISTRO
	If huella.Estado = huella.SIN_BLOQUEO Then Return Mensajes.PERFIL_SIN_BLOQUEO
	If huella.Estado <> huella.DISPONIBLE Then Return Mensajes.PERFIL_NO_SOPORTADO
	Return ""
End Sub
#End Region
