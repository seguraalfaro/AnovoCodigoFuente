B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Nombres de las paginas B4XPages y claves y titulos del indicador de pasos de
' los registros de cliente y de cotizacion.
Sub Process_Globals
	Public ClienteClaves()  As String
	Public ClienteTitulos() As String

	Public CotizacionClaves()  As String
	Public CotizacionTitulos() As String
	Public Const PAGINA_INICIO As String = "Phome"
	Public Const PAGINA_COTIZACION As String = "Pcotizacion"
	Public Const PAGINA_ESPECIFICACIONES As String = "PEspecificaciones"
	Public Const PAGINA_CLIENTES As String = "PCLientes"
	Public Const PAGINA_CLIENTE_DETALLE As String = "PClienteDetalle"
	Public Const PAGINA_SINCRONIZACION As String = "PSincronizacion"
End Sub

Public Sub Inicializar
	ClienteClaves  = Array As String("datos", "contactos", "consentimiento")
	ClienteTitulos = Array As String("Cliente", "Contactos", "Permiso")

	CotizacionClaves  = Array As String("general", "detalle", "revision")
	CotizacionTitulos = Array As String("Cliente", "Detalles", "Revisión")
End Sub