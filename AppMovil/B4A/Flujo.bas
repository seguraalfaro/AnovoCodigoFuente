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
End Sub

Public Sub Inicializar
	ClienteLayouts = Array As String("PageClienteDatos", "PageClienteContactos", "PageClienteConsentimiento")
	ClienteClaves  = Array As String("datos", "contactos", "consentimiento")
	ClienteTitulos = Array As String("Cliente", "Contactos", "Permiso")

	CotizacionLayouts = Array As String("PageCotizacion1", "PageCotizacion2", "PageCotizacion3")
	CotizacionClaves  = Array As String("general", "detalle", "revision")
	CotizacionTitulos = Array As String("General", "Detalle", "Revisión")
End Sub