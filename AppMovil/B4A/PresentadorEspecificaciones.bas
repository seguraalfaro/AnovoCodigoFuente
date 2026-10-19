B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador de la pieza en tres partes (datos, croquis y fotos): catalogos, fotos,
' borrador en KVS mientras se captura y armado de la Pieza que vuelve a la cotizacion.

Sub Class_Globals
	Private Const EXTENSION_FOTO As String = ".jpg"
	Private Const TIPO_BORRADOR As String = "pieza"
	Private Const CLAVE_UUID As String = "uuid"
	Private Const CLAVE_NOMBRE As String = "nombre"
	Private Const CLAVE_TRABAJO As String = "trabajo"
	Private Const CLAVE_MATERIAL As String = "material"
	Private Const CLAVE_ACABADO As String = "acabado"
	Private Const CLAVE_CROQUIS As String = "croquis"
	Private Const CLAVE_FOTOS As String = "fotos"
	Private Const CLAVE_ORIGINALES As String = "originales"
	Private Const CLAVE_QUITADAS As String = "quitadas"
	Private Const CLAVE_PAGINA As String = "pagina"

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
	Private mNombre As String
	Private mCroquisJson As String
	Private mPagina As Int
	Private mMotivoRechazo As String
End Sub

Public Sub Initialize
	mTiposTrabajo = DbCatalogos.TiposTrabajo
	mTiposMaterial = DbCatalogos.TiposMaterial
	mAcabados = DbCatalogos.Acabados
	Nuevo
End Sub

#Region Estado
Public Sub Nuevo
	mUuid = ""
	mTrabajoId = 0
	mMaterialId = 0
	mAcabadoId = 0
	mNombre = ""
	mCroquisJson = ""
	mPagina = 0
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
	mNombre = p.Nombre
	mCroquisJson = p.CroquisJson
	If p.ListaFotos.IsInitialized Then
		mFotos.AddAll(p.ListaFotos)
		mOriginales.AddAll(p.ListaFotos)
	End If
End Sub

Public Sub getEditando As Boolean
	Return mUuid <> ""
End Sub

Public Sub getHayBorrador As Boolean
	Return Db.HayBorrador(TIPO_BORRADOR)
End Sub

Public Sub getNombreBorrador As String
	Return Db.LeerBorrador(TIPO_BORRADOR).GetDefault(CLAVE_NOMBRE, "")
End Sub

Public Sub GuardarBorrador (NombrePieza As String, Croquis As String, Hoja As Int)
	mNombre = NombrePieza
	mCroquisJson = Croquis
	mPagina = Hoja
	If mUuid = "" And NombrePieza.Trim = "" And Croquis = "" And mFotos.Size = 0 And _
		mTrabajoId = 0 And mMaterialId = 0 And mAcabadoId = 0 Then
		Db.BorrarBorrador(TIPO_BORRADOR)
		Return
	End If
	Db.GuardarBorrador(TIPO_BORRADOR, CreateMap(CLAVE_UUID: mUuid, CLAVE_NOMBRE: mNombre, _
		CLAVE_TRABAJO: mTrabajoId, CLAVE_MATERIAL: mMaterialId, CLAVE_ACABADO: mAcabadoId, _
		CLAVE_CROQUIS: mCroquisJson, CLAVE_FOTOS: mFotos, CLAVE_ORIGINALES: mOriginales, _
		CLAVE_QUITADAS: mQuitadas, CLAVE_PAGINA: mPagina))
End Sub

Public Sub Restaurar As Boolean
	Dim b As Map = Db.LeerBorrador(TIPO_BORRADOR)
	If b.ContainsKey(CLAVE_FOTOS) = False Then
		Db.BorrarBorrador(TIPO_BORRADOR)
		Return False
	End If
	Nuevo
	mUuid = b.GetDefault(CLAVE_UUID, "")
	mNombre = b.GetDefault(CLAVE_NOMBRE, "")
	mTrabajoId = b.GetDefault(CLAVE_TRABAJO, 0)
	mMaterialId = b.GetDefault(CLAVE_MATERIAL, 0)
	mAcabadoId = b.GetDefault(CLAVE_ACABADO, 0)
	mCroquisJson = b.GetDefault(CLAVE_CROQUIS, "")
	mPagina = b.GetDefault(CLAVE_PAGINA, 0)
	mFotos.AddAll(b.Get(CLAVE_FOTOS))
	mOriginales.AddAll(b.GetDefault(CLAVE_ORIGINALES, mOriginales))
	mQuitadas.AddAll(b.GetDefault(CLAVE_QUITADAS, mQuitadas))
	Return True
End Sub

Public Sub DescartarBorrador
	If Restaurar Then DescartarFotos
	Db.BorrarBorrador(TIPO_BORRADOR)
End Sub
#End Region

#Region Lo que pinta la página
Public Sub getNombre As String
	Return mNombre
End Sub

Public Sub getCroquisJson As String
	Return mCroquisJson
End Sub

Public Sub getPagina As Int
	Return mPagina
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

Public Sub getAvisoAdjuntos As String
	If Sesion.Tiene(Sesion.PERMISO_ADJUNTOS_CREAR) Then Return ""
	Return Mensajes.SIN_PERMISO_ADJUNTOS
End Sub

Public Sub getPuedeAgregarFoto As Boolean
	Return mFotos.Size < Adjuntos.MAX_FOTOS
End Sub
#End Region

#Region Acciones
Public Sub ElegirTipoTrabajo (Id As Int)
	mTrabajoId = Id
End Sub

Public Sub ElegirTipoMaterial (Id As Int)
	mMaterialId = Id
End Sub

Public Sub ElegirAcabado (Id As Int)
	mAcabadoId = Id
End Sub

Public Sub getMotivoRechazo As String
	Return mMotivoRechazo
End Sub

Private Sub MedidasAceptadas (Medidas() As Int) As Boolean
	mMotivoRechazo = ""
	If Adjuntos.EsChica(Medidas) = False Then Return True
	mMotivoRechazo = Mensajes.FotoChica(Medidas(0), Medidas(1))
	Return False
End Sub

Public Sub AgregarFoto (Datos() As Byte) As String
	If getPuedeAgregarFoto = False Then Return ""
	If MedidasAceptadas(Adjuntos.MedidasDeBytes(Datos)) = False Then Return ""
	Dim archivo As String = Db.NuevoUuid & EXTENSION_FOTO
	If Adjuntos.GuardarFoto(Datos, archivo) = False Then Return ""
	mFotos.Add(archivo)
	Return archivo
End Sub

Public Sub AgregarFotoDeGaleria (Dir As String, Archivo As String) As String
	If getPuedeAgregarFoto = False Then Return ""
	If MedidasAceptadas(Adjuntos.MedidasDe(Dir, Archivo)) = False Then Return ""
	Dim destino As String = Db.NuevoUuid & EXTENSION_FOTO
	If Adjuntos.CopiarImagen(Dir, Archivo, destino) = False Then Return ""
	mFotos.Add(destino)
	Return destino
End Sub

Public Sub QuitarFoto (Archivo As String) As Int
	Dim i As Int = mFotos.IndexOf(Archivo)
	If i < 0 Then Return -1
	mFotos.RemoveAt(i)
	If mOriginales.IndexOf(Archivo) >= 0 Then
		mQuitadas.Add(Archivo)
	Else
		Adjuntos.BorrarFotos(Array As String(Archivo))
	End If
	Return i
End Sub

Public Sub DescartarFotos
	Dim nuevas As List
	nuevas.Initialize
	For Each archivo As String In mFotos
		If mOriginales.IndexOf(archivo) < 0 Then nuevas.Add(archivo)
	Next
	Adjuntos.BorrarFotos(nuevas)
	Db.BorrarBorrador(TIPO_BORRADOR)
	Nuevo
End Sub

Public Sub ArmarPieza (NombrePieza As String, Croquis As String, MedidasCroquis As List) As Resultado
	If NombrePieza.Trim = "" Then Return Tipos.Falla(Mensajes.FALTA_NOMBRE_PIEZA)
	If mTrabajoId <= 0 Then Return Tipos.Falla(Mensajes.FALTA_TIPO_TRABAJO)
	If mMaterialId <= 0 Then Return Tipos.Falla(Mensajes.FALTA_MATERIAL)
	If mAcabadoId <= 0 Then Return Tipos.Falla(Mensajes.FALTA_ACABADO)
	Dim p As Pieza = Tipos.PiezaVacia
	p.UuidLocal = mUuid
	p.Nombre = NombrePieza.Trim
	p.TipoTrabajoId = mTrabajoId
	p.TipoTrabajo = getTextoTipoTrabajo
	p.TipoMaterialId = mMaterialId
	p.Material = getTextoTipoMaterial
	p.AcabadoId = mAcabadoId
	p.Acabado = getTextoAcabado
	p.CroquisJson = Croquis
	p.Croquis = Croquis <> ""
	p.ListaMedidas.AddAll(MedidasCroquis)
	p.Medidas = p.ListaMedidas.Size
	p.ListaFotos.AddAll(mFotos)
	p.Fotos = mFotos.Size
	Adjuntos.BorrarFotos(mQuitadas)
	Db.BorrarBorrador(TIPO_BORRADOR)
	Nuevo
	Return Tipos.Correcto(p)
End Sub
#End Region

#Region Ayudantes
Private Sub NombreDe (Opciones As List, Id As Int) As String
	If Id <= 0 Then Return ""
	For Each o As OpcionBusqueda In Opciones
		If Id = o.Valor Then Return o.Titulo
	Next
	Return ""
End Sub
#End Region
