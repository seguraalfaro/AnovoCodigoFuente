B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Lectura de los catalogos que baja el Sincronizador: tipos de trabajo, tipos de
' material y acabados. Cada fila vuelve como OpcionBusqueda con el id_servidor en Valor.
Sub Process_Globals
	Private Const SQL_TIPOS_TRABAJO As String = "SELECT id_servidor, nombre FROM tipos_trabajo WHERE activo = 1 ORDER BY nombre COLLATE NOCASE"
	Private Const SQL_TIPOS_MATERIAL As String = "SELECT id_servidor, nombre FROM tipos_material WHERE activo = 1 ORDER BY nombre COLLATE NOCASE"
	Private Const SQL_ACABADOS As String = "SELECT id_servidor, nombre FROM acabados WHERE activo = 1 ORDER BY nombre COLLATE NOCASE"
End Sub

Public Sub TiposTrabajo As List
	Return Leer(SQL_TIPOS_TRABAJO)
End Sub

Public Sub TiposMaterial As List
	Return Leer(SQL_TIPOS_MATERIAL)
End Sub

Public Sub Acabados As List
	Return Leer(SQL_ACABADOS)
End Sub

Private Sub Leer (Consulta As String) As List
	Dim res As List
	res.Initialize
	Dim rs As ResultSet = Db.DbSQL.ExecQuery(Consulta)
	Do While rs.NextRow
		res.Add(Tipos.Opcion(rs.GetString("nombre"), "", rs.GetInt("id_servidor")))
	Loop
	rs.Close
	Return res
End Sub
