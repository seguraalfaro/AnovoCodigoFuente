B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador de la hoja Clientes: la lista del telefono con su estado de subida
' y las opciones para la ventana de busqueda. No conoce vistas.
Sub Class_Globals
	Private Const SEPARADOR As String = " · "
	Private Const TIPO_JURIDICA As Int = 1
	Private mFilas As List
End Sub

Public Sub Initialize
	mFilas.Initialize
End Sub

Public Sub Actualizar
	mFilas = DbClientes.ListaConEstado
End Sub

Public Sub getFilas As List
	Return mFilas
End Sub

Public Sub getTotal As Int
	Return mFilas.Size
End Sub

Public Sub getTotalTexto As String
	Return Mensajes.CuentaClientes(mFilas.Size)
End Sub

Public Sub Iniciales (f As ClienteFila) As String
	Return Utils.Iniciales(f.Datos.Nombre)
End Sub

Public Sub EsJuridica (f As ClienteFila) As Boolean
	Return f.Datos.TipoIdentificacion = TIPO_JURIDICA
End Sub

Public Sub TextoBusqueda (f As ClienteFila) As String
	Return f.Datos.Nombre & " " & f.Datos.Identificacion & " " & f.Datos.Telefono
End Sub

Public Sub TituloDe (f As ClienteFila) As String
	Return f.Datos.Nombre
End Sub

Public Sub DetalleDe (f As ClienteFila) As String
	Return Utils.Unir(SEPARADOR, Array As String(Mensajes.TipoCorto(f.Datos.TipoIdentificacion), f.Datos.Identificacion, f.Datos.Telefono))
End Sub

Public Sub EstadoDe (f As ClienteFila) As String
	Return Mensajes.PastillaCliente(f.EstadoSync)
End Sub

Public Sub TintaDe (f As ClienteFila) As Int
	Return Colores.TintaPastilla(f.EstadoSync)
End Sub

Public Sub FondoDe (f As ClienteFila) As Int
	Return Colores.FondoPastilla(f.EstadoSync)
End Sub
