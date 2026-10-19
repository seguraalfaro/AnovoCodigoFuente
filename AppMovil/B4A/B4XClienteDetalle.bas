B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Ficha del cliente, solo consulta: carga PageClienteDetalle y arma la lista con los layouts
' ItemClienteDatos, ItemSeccion, ItemContactoFicha e ItemPermiso. El boton empieza una solicitud.

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private presentador As PresentadorClienteDetalle
	Private ClvFicha As CustomListView
	Private BtnNuevaSolicitud As B4XView
	Private lblDatosIniciales, lblDatosNombre, lblDatosIdentificacion, lblDatosEstado As B4XView
	Private lblTelefonoRot, lblTelefono, lblDireccionRot, lblDireccion, lblCobroRot, lblCobro As B4XView
	Private lblSeccion As B4XView
	Private lblContactoIniciales, lblContactoNombre, lblContactoPrincipal, lblContactoDetalle As B4XView
	Private lblPermisoTexto, lblPermisoDetalle As B4XView
	Private Const ALTO_DATOS As Int = 208dip
	Private Const ALTO_SECCION As Int = 36dip
	Private Const ALTO_CONTACTO As Int = 70dip
	Private Const ALTO_PERMISO As Int = 82dip
	Private Const RADIO_AVATAR As Int = 24dip
	Private Const RADIO_PASTILLA As Int = 10dip
	Private Const VALOR_PERMISO As String = "permiso"
End Sub

Public Sub Initialize As Object
	presentador.Initialize
	Return Me
End Sub

#Region Ciclo de la página
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("PageClienteDetalle")
	B4XPages.SetTitle(Me, Mensajes.TITULO_CLIENTE)
	BtnNuevaSolicitud.Text = Mensajes.NUEVA_SOLICITUD
	UI.AplicarTema(Root)
End Sub

Public Sub Mostrar (c As Cliente)
	presentador.Cargar(c)
End Sub

Private Sub B4XPage_Appear
	BtnNuevaSolicitud.Visible = presentador.PuedeCrearSolicitud
	Pintar
End Sub

Private Sub B4XPage_Resize (Width As Int, Height As Int)
	Pintar
End Sub
#End Region

#Region Pintar
Private Sub Pintar
	ClvFicha.Clear
	Dim ancho As Int = ClvFicha.AsView.Width
	ClvFicha.Add(CrearDatos(ancho), Null)
	ClvFicha.Add(CrearSeccion(ancho, Mensajes.FichaContactos(presentador.Contactos.Size), Colores.COLOR_PRIMARIO), Null)
	If presentador.Contactos.Size = 0 Then ClvFicha.Add(CrearSeccion(ancho, Mensajes.FICHA_SIN_CONTACTOS, Colores.COLOR_TEXTO_SECUNDARIO), Null)
	For Each k As Contacto In presentador.Contactos
		ClvFicha.Add(CrearContacto(ancho, k), k)
	Next
	ClvFicha.Add(CrearSeccion(ancho, Mensajes.FICHA_PERMISO, Colores.COLOR_PRIMARIO), Null)
	ClvFicha.Add(CrearPermiso(ancho), VALOR_PERMISO)
End Sub

Private Sub Fila (Ancho As Int, Alto As Int) As B4XView
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, Ancho, Alto)
	Return p
End Sub

Private Sub CrearDatos (Ancho As Int) As B4XView
	Dim p As B4XView = Fila(Ancho, ALTO_DATOS)
	p.LoadLayout("ItemClienteDatos")
	Dim fondo As Int = Colores.COLOR_EXITO_TENUE
	Dim tinta As Int = Colores.COLOR_EXITO
	If presentador.EsJuridica Then
		fondo = Colores.COLOR_PRIMARIO_TENUE
		tinta = Colores.COLOR_PRIMARIO
	End If
	lblDatosIniciales.Text = Utils.Iniciales(presentador.Nombre)
	lblDatosIniciales.TextColor = tinta
	lblDatosIniciales.SetColorAndBorder(fondo, 0, fondo, RADIO_AVATAR)
	lblDatosNombre.Text = presentador.Nombre
	lblDatosIdentificacion.Text = presentador.Identificacion
	lblDatosEstado.Text = presentador.EstadoPastilla
	lblDatosEstado.TextColor = presentador.TintaEstado
	lblDatosEstado.SetColorAndBorder(presentador.FondoEstado, 0, presentador.FondoEstado, RADIO_PASTILLA)
	lblTelefonoRot.Text = Mensajes.ROTULO_TELEFONO
	lblTelefono.Text = presentador.Telefono
	lblDireccionRot.Text = Mensajes.ROTULO_DIRECCION
	lblDireccion.Text = presentador.Direccion
	lblCobroRot.Text = Mensajes.ROTULO_COBROS
	lblCobro.Text = presentador.Cobro
	Return p
End Sub

Private Sub CrearSeccion (Ancho As Int, Texto As String, Tinta As Int) As B4XView
	Dim p As B4XView = Fila(Ancho, ALTO_SECCION)
	p.LoadLayout("ItemSeccion")
	lblSeccion.Text = Texto
	lblSeccion.TextColor = Tinta
	Return p
End Sub

Private Sub CrearContacto (Ancho As Int, k As Contacto) As B4XView
	Dim p As B4XView = Fila(Ancho, ALTO_CONTACTO)
	p.LoadLayout("ItemContactoFicha")
	lblContactoIniciales.Text = Utils.Iniciales(k.Nombre)
	lblContactoNombre.Text = k.Nombre
	lblContactoDetalle.Text = presentador.DetalleContacto(k)
	lblContactoPrincipal.Text = Mensajes.FICHA_PRINCIPAL
	lblContactoPrincipal.Visible = k.Principal
	Return p
End Sub

Private Sub CrearPermiso (Ancho As Int) As B4XView
	Dim p As B4XView = Fila(Ancho, ALTO_PERMISO)
	p.LoadLayout("ItemPermiso")
	lblPermisoTexto.Text = presentador.Permiso
	lblPermisoDetalle.Text = presentador.DetallePermiso
	Return p
End Sub
#End Region

#Region Eventos
Private Sub ClvFicha_ItemClick (Index As Int, Value As Object)
	If (Value Is String) = False Then Return
	If Value <> VALOR_PERMISO Or presentador.PuedeFirmar = False Then Return
	Dim pagina As B4XConsentimiento = B4XPages.GetPage(Layouts.PAGINA_CONSENTIMIENTO)
	pagina.Mostrar(presentador.ClienteActual)
	B4XPages.ShowPage(Layouts.PAGINA_CONSENTIMIENTO)
End Sub

Private Sub BtnNuevaSolicitud_Click
	Dim cotizacion As B4XCotizacion = B4XPages.GetPage(Layouts.PAGINA_COTIZACION)
	cotizacion.NuevaConCliente(presentador.ClienteActual)
	B4XPages.ShowPage(Layouts.PAGINA_COTIZACION)
End Sub
#End Region
