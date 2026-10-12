B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador de la pieza en tres partes (datos, croquis y fotos): opciones de los
' catalogos, fotos y armado de la Pieza, nueva o en edicion, que vuelve a la cotizacion.
Sub Class_Globals
	Private Const EXTENSION_FOTO As String = ".jpg"
	Private Const CLAVE_ETIQUETA As String = "etiqueta"
	Private Const CLAVE_MEDIDA As String = "medida"
	Private Const CLAVE_VALOR As String = "valor"
	Private Const CLAVE_UNIDAD As String = "unidad"
	Private Const CLAVE_CANTIDAD As String = "cantidad"

	Private mTiposTrabajo As List
	Private mTiposMaterial As List
	Private mAcabados As List
	Private mFotos As List
	Private mOriginales As List
	Private mQuitadas As List
	Private mUuid As String
	Private mTrabajoId As Int
	Private mMaterialId As Int
	Private mAcabadoId As Int
End Sub

Public Sub Initialize
	mTiposTrabajo = DbCatalogos.TiposTrabajo
	mTiposMaterial = DbCatalogos.TiposMaterial
	mAcabados = DbCatalogos.Acabados
	Nuevo
End Sub

Public Sub Nuevo
	mUuid = ""
	mTrabajoId = 0
	mMaterialId = 0
	mAcabadoId = 0
	mFotos.Initialize
	mOriginales.Initialize
	mQuitadas.Initialize
End Sub

Public Sub EditarPieza (p As Pieza)
	Nuevo
	mUuid = p.UuidLocal
	mTrabajoId = p.TipoTrabajoId
	mMaterialId = p.TipoMaterialId
	mAcabadoId = p.AcabadoId
	If p.ListaFotos.IsInitialized Then
		mFotos.AddAll(p.ListaFotos)
		mOriginales.AddAll(p.ListaFotos)
	End If
End Sub

Public Sub getEditando As Boolean
	Return mUuid <> ""
End Sub

Public Sub getOpcionesTiposTrabajo As List
	Return mTiposTrabajo
End Sub

Public Sub getOpcionesTiposMaterial As List
	Return mTiposMaterial
End Sub

Public Sub getOpcionesAcabados As List
	Return mAcabados
End Sub

Public Sub ElegirTipoTrabajo (Id As Int)
	mTrabajoId = Id
End Sub

Public Sub ElegirTipoMaterial (Id As Int)
	mMaterialId = Id
End Sub

Public Sub ElegirAcabado (Id As Int)
	mAcabadoId = Id
End Sub

Public Sub getTextoTipoTrabajo As String
	Return NombreDe(mTiposTrabajo, mTrabajoId)
End Sub

Public Sub getTextoTipoMaterial As String
	Return NombreDe(mTiposMaterial, mMaterialId)
End Sub

Public Sub getTextoAcabado As String
	Return NombreDe(mAcabados, mAcabadoId)
End Sub

Public Sub getFotos As List
	Return mFotos
End Sub

Public Sub getCarpetaFotos As String
	Return Adjuntos.CarpetaFotos
End Sub

Public Sub getPuedeAgregarFoto As Boolean
	Return mFotos.Size < Adjuntos.MAX_FOTOS
End Sub

Public Sub AgregarFoto (Datos() As Byte) As String
	If getPuedeAgregarFoto = False Then Return ""
	Dim carpeta As String = Adjuntos.CarpetaFotos
	Dim nombre As String = Db.NuevoUuid & EXTENSION_FOTO
	Try
		Dim salida As OutputStream = File.OpenOutput(carpeta, nombre, False)
		salida.WriteBytes(Datos, 0, Datos.Length)
		salida.Close
	Catch
		Log("PresentadorEspecificaciones.AgregarFoto: " & LastException.Message)
		Return ""
	End Try
	mFotos.Add(nombre)
	Return nombre
End Sub

Public Sub AgregarFotoDeGaleria (Dir As String, Archivo As String) As String
	If getPuedeAgregarFoto = False Then Return ""
	Dim nombre As String = Db.NuevoUuid & EXTENSION_FOTO
	If Adjuntos.CopiarImagen(Dir, Archivo, nombre) = False Then Return ""
	mFotos.Add(nombre)
	Return nombre
End Sub

Public Sub QuitarFoto (Nombre As String) As Int
	Dim i As Int = mFotos.IndexOf(Nombre)
	If i < 0 Then Return -1
	mFotos.RemoveAt(i)
	If mOriginales.IndexOf(Nombre) >= 0 Then
		mQuitadas.Add(Nombre)
	Else
		Adjuntos.BorrarFotos(Array As String(Nombre))
	End If
	Return i
End Sub

Public Sub DescartarFotos
	Dim nuevas As List
	nuevas.Initialize
	For Each nombre As String In mFotos
		If mOriginales.IndexOf(nombre) < 0 Then nuevas.Add(nombre)
	Next
	Adjuntos.BorrarFotos(nuevas)
	Nuevo
End Sub

Public Sub ArmarPieza (Nombre As String, CroquisJson As String, MedidasCroquis As List) As Resultado
	If Nombre.Trim = "" Then Return Tipos.Falla(Mensajes.FALTA_NOMBRE_PIEZA)
	Dim p As Pieza = Tipos.PiezaVacia
	p.UuidLocal = mUuid
	p.Nombre = Nombre.Trim
	p.TipoTrabajoId = mTrabajoId
	p.TipoTrabajo = getTextoTipoTrabajo
	p.TipoMaterialId = mMaterialId
	p.Material = getTextoTipoMaterial
	p.AcabadoId = mAcabadoId
	p.Acabado = getTextoAcabado
	p.CroquisJson = CroquisJson
	p.Croquis = CroquisJson <> ""
	For i = 0 To MedidasCroquis.Size - 1
		p.ListaMedidas.Add(MedidaDe(MedidasCroquis.Get(i), i))
	Next
	p.Medidas = p.ListaMedidas.Size
	p.ListaFotos.AddAll(mFotos)
	p.Fotos = mFotos.Size
	Adjuntos.BorrarFotos(mQuitadas)
	Nuevo
	Return Tipos.Correcto(p)
End Sub

Private Sub MedidaDe (m As Map, Orden As Int) As MedidaPieza
	Dim r As MedidaPieza
	r.Initialize
	r.Etiqueta = m.GetDefault(CLAVE_ETIQUETA, "")
	r.TipoMedida = m.GetDefault(CLAVE_MEDIDA, "")
	r.Valor = m.GetDefault(CLAVE_VALOR, 0)
	r.Unidad = m.GetDefault(CLAVE_UNIDAD, "")
	r.Cantidad = m.GetDefault(CLAVE_CANTIDAD, 1)
	r.Orden = Orden
	Return r
End Sub

Private Sub NombreDe (Opciones As List, Id As Int) As String
	If Id <= 0 Then Return ""
	For Each o As OpcionBusqueda In Opciones
		If Id = o.Valor Then Return o.Titulo
	Next
	Return ""
End Sub
