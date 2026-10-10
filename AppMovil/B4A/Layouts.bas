B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'Alta de cliente
	Public ClienteLayouts() As String
	Public ClienteClaves()  As String
	Public ClienteTitulos() As String

	'Cotizacion
	Public CotizacionLayouts() As String
	Public CotizacionClaves()  As String
	Public CotizacionTitulos() As String
	Public Const ItemContacto As String = "ItemContacto"
	Public Const ItemFoto     As String = "ItemFoto"
	Public Const ItemVacio    As String = "ItemVacio"
	Public Const PAGINA_INICIO As String = "Phome"
	Public Const PAGINA_COTIZACION As String = "Pcotizacion"
	Public Const PAGINA_ESPECIFICACIONES As String = "PEspecificaciones"
	Public Const PAGINA_CLIENTES As String = "PCLientes"
End Sub

Public Sub Inicializar
	ClienteLayouts = Array As String("PageClienteDatos", "PageClienteContactos", "PageClienteConsentimiento")
	ClienteClaves  = Array As String("datos", "contactos", "consentimiento")
	ClienteTitulos = Array As String("Cliente", "Contactos", "Permiso")

	CotizacionLayouts = Array As String("PageCotizacion1", "PageCotizacion2", "PageCotizacion3")
	CotizacionClaves  = Array As String("general", "detalle", "revision")
	CotizacionTitulos = Array As String("General", "Detalle", "Revisión")
End Sub