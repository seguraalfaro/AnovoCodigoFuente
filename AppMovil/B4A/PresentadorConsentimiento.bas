B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador de la firma del consentimiento de un cliente ya registrado: valida como el registro
' y deja la firma en SQLite para que la suba el Sincronizador. No conoce vistas.

Sub Class_Globals
	Private mCliente As Cliente
	Private mContactos As List
End Sub

Public Sub Initialize
	mCliente = Tipos.ClienteVacio
	mContactos.Initialize
End Sub

Public Sub Cargar (c As Cliente)
	mCliente = c
	mContactos = DbClientes.ContactosDe(c.UuidLocal)
End Sub

Public Sub getTextoPermiso As TextoPermiso
	Return DbClientes.TextoVigente
End Sub

Public Sub getFirmantes As List
	Dim nombres As List
	nombres.Initialize
	nombres.Add("")
	For Each k As Contacto In mContactos
		Dim n As String = k.Nombre.Trim
		If n <> "" And nombres.IndexOf(n) < 0 Then nombres.Add(n)
	Next
	Return nombres
End Sub

Public Sub Guardar (Permiso As Consentimiento) As Resultado
	Permiso.Version = DbClientes.TextoVigente.Version
	Dim falla As String = Validacion.Consentimiento(Permiso)
	If falla <> "" Then Return Tipos.Falla(falla)
	If DbClientes.GuardarFirma(mCliente.UuidLocal, mContactos, Permiso) = False Then Return Tipos.Falla(Mensajes.CONSENTIMIENTO_NO_GUARDADO)
	Return Tipos.Correcto(mCliente.UuidLocal)
End Sub
