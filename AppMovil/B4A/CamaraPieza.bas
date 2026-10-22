B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Manejo de vista de la camara de la pieza: vista previa, flash, rotar, disparo y aviso
' cuando no hay camara. El permiso lo pide la pagina; la foto le llega como evento _Foto.

Sub Class_Globals
	Private xui As XUI
	Private Const FLASH_SI As String = "on"
	Private Const FLASH_NO As String = "off"
	Private Const AJUSTES_APP As String = "android.settings.APPLICATION_DETAILS_SETTINGS"
	Private Const NUEVA_TAREA As Int = 0x10000000
	Private Const DURACION_DESTELLO As Int = 250
	Private Const ARCHIVO_OBTURADOR As String = "obturador.wav"
	Private Const FLUJO_SISTEMA As Int = 1
	Private Const VOLUMEN_OBTURADOR As Float = 1
	Private mSonidos As JavaObject
	Private mIdObturador As Int

	Private mCallback As Object
	Private mEvento As String
	Private camEx As CameraExClass
	Private mPreview As Panel
	Private mSinCamara As B4XView
	Private mIcono As B4XView
	Private mTitulo As B4XView
	Private mTexto As B4XView
	Private mDisparar As B4XView
	Private mFlash As B4XView
	Private mRotar As B4XView
	Private mPermitir As B4XView
	Private mLista, mDisparando, mConFlash, mFrontal, mBloqueado, mTieneFlash As Boolean
End Sub

Public Sub Initialize (Callback As Object, Evento As String, Preview As Panel, SinCamara1 As B4XView, _
		Icono As B4XView, Titulo As B4XView, Texto As B4XView, BotonDisparar As B4XView, BotonFlash As B4XView, _
		BotonRotar As B4XView, BotonPermitir As B4XView)
	mCallback = Callback
	mEvento = Evento
	mPreview = Preview
	mSinCamara = SinCamara1
	mIcono = Icono
	mTitulo = Titulo
	mTexto = Texto
	mDisparar = BotonDisparar
	mFlash = BotonFlash
	mRotar = BotonRotar
	mPermitir = BotonPermitir
	CargarObturador
	Esperando
End Sub

#Region Apertura y cierre
Public Sub getLista As Boolean
	Return mLista
End Sub

Public Sub getBloqueada As Boolean
	Return mBloqueado
End Sub

Public Sub ComprobarEquipo As Boolean
	If Adjuntos.getTieneCamara Then Return True
	Avisar(Adjuntos.ESTADO_SIN_HARDWARE)
	Return False
End Sub

Public Sub Abrir
	If mLista Then Return
	mBloqueado = False
	mSinCamara.Visible = False
	mPreview.Visible = True
	UI.Habilitar(mFlash, False)
	UI.Habilitar(mRotar, Adjuntos.getPuedeRotar)
	If Adjuntos.getHayTrasera = False Then mFrontal = True
	If Adjuntos.getHayFrontal = False Then mFrontal = False
	camEx.Initialize(mPreview, mFrontal, Me, "CamEx")
	mFrontal = camEx.Front
End Sub

Public Sub Esperando
	mPreview.Visible = False
	mSinCamara.Visible = True
	mPermitir.Visible = False
	UI.Habilitar(mDisparar, False)
	UI.Habilitar(mFlash, False)
	PintarAviso(Chr(0xF030), Colores.COLOR_TEXTO_SECUNDARIO, Mensajes.CAMARA_ESPERANDO, Mensajes.CAMARA_ESPERANDO_TEXTO, "")
End Sub

Public Sub Denegada (EstaBloqueada As Boolean)
	If EstaBloqueada Then Avisar(Adjuntos.ESTADO_BLOQUEADO) Else Avisar(Adjuntos.ESTADO_DENEGADO)
End Sub

Public Sub Cerrar
	If mLista = False Then Return
	camEx.StopPreview
	camEx.Release
	mLista = False
End Sub

Public Sub AbrirAjustes
	Dim i As Intent
	i.Initialize(AJUSTES_APP, "package:" & Application.PackageName)
	i.Flags = NUEVA_TAREA
	Try
		StartActivity(i)
	Catch
		Log("CamaraPieza.AbrirAjustes: " & LastException.Message)
		xui.MsgboxAsync(Mensajes.SIN_AJUSTES, Mensajes.TITULO)
	End Try
End Sub
#End Region

#Region Controles
Public Sub Rotar
	If mLista = False Or Adjuntos.getPuedeRotar = False Then Return
	Cerrar
	mFrontal = Not(mFrontal)
	Abrir
End Sub

Public Sub CambiarFlash
	If mLista = False Or mTieneFlash = False Then Return
	mConFlash = Not(mConFlash)
	camEx.SetFlashMode(IIf(mConFlash, FLASH_SI, FLASH_NO))
	If camEx.CommitParameters = False Then
		mConFlash = False
		mTieneFlash = False
		camEx.SetFlashMode(FLASH_NO)
		camEx.CommitParameters
		UI.Habilitar(mFlash, False)
	End If
	UI.MarcarGrupo(Array As B4XView(mFlash), IIf(mConFlash, 0, -1))
End Sub

Public Sub Disparar
	If mLista = False Or mDisparando Then Return
	mDisparando = True
	UI.Habilitar(mDisparar, False)
	Destello
	SonarObturador
	camEx.TakePicture
End Sub

Private Sub CargarObturador
	Try
		If File.Exists(File.DirInternal, ARCHIVO_OBTURADOR) = False Then File.Copy(File.DirAssets, ARCHIVO_OBTURADOR, File.DirInternal, ARCHIVO_OBTURADOR)
		mSonidos.InitializeNewInstance("android.media.SoundPool", Array(1, FLUJO_SISTEMA, 0))
		mIdObturador = mSonidos.RunMethod("load", Array(File.Combine(File.DirInternal, ARCHIVO_OBTURADOR), 1))
	Catch
		Log("CamaraPieza.CargarObturador: " & LastException.Message)
	End Try
End Sub

Private Sub SonarObturador
	If mSonidos.IsInitialized = False Or mIdObturador = 0 Then Return
	Dim volumen As Float = VOLUMEN_OBTURADOR
	Dim velocidad As Float = 1
	mSonidos.RunMethod("play", Array(mIdObturador, volumen, volumen, 1, 0, velocidad))
End Sub

Private Sub Destello
	Dim capa As B4XView = xui.CreatePanel("")
	capa.Color = xui.Color_White
	Dim vista As B4XView = mPreview
	vista.AddView(capa, 0, 0, vista.Width, vista.Height)
	capa.SetVisibleAnimated(DURACION_DESTELLO, False)
	Sleep(DURACION_DESTELLO)
	capa.RemoveViewFromParent
End Sub

Private Sub Avisar (Motivo As String)
	mLista = False
	mTieneFlash = False
	mConFlash = False
	mBloqueado = (Motivo = Adjuntos.ESTADO_BLOQUEADO)
	mPreview.Visible = False
	mSinCamara.Visible = True
	UI.Habilitar(mDisparar, False)
	UI.Habilitar(mFlash, False)
	UI.Habilitar(mRotar, False)
	UI.MarcarGrupo(Array As B4XView(mFlash), -1)
	mPermitir.Visible = True
	Select Motivo
		Case Adjuntos.ESTADO_SIN_HARDWARE
			PintarAviso(Chr(0xF030), Colores.COLOR_TEXTO_SECUNDARIO, Mensajes.CAMARA_SIN_EQUIPO, Mensajes.CAMARA_SEGUIR, "")
			mPermitir.Visible = False
		Case Adjuntos.ESTADO_BLOQUEADO
			PintarAviso(Chr(0xF023), Colores.COLOR_ERROR, Mensajes.CAMARA_BLOQUEADA, Mensajes.CAMARA_BLOQUEADA_TEXTO, Mensajes.ABRIR_AJUSTES)
		Case Adjuntos.ESTADO_FALLO
			PintarAviso(Chr(0xF071), Colores.COLOR_ERROR, Mensajes.CAMARA_FALLO, Mensajes.CAMARA_FALLO_TEXTO, Mensajes.REINTENTAR)
		Case Else
			PintarAviso(Chr(0xF030), Colores.COLOR_TEXTO_SECUNDARIO, Mensajes.CAMARA_NO_DISPONIBLE, Mensajes.CAMARA_SEGUIR, Mensajes.PERMITIR_CAMARA)
	End Select
End Sub

Private Sub PintarAviso (Glifo As String, Color As Int, Titulo As String, Texto As String, Boton As String)
	mIcono.Text = Glifo
	mIcono.TextColor = Color
	mTitulo.Text = Titulo
	mTexto.Text = Texto
	If Boton <> "" Then mPermitir.Text = Boton
End Sub
#End Region

#Region Eventos de la cámara
Sub CamEx_Ready (Success As Boolean)
	If Success = False Then
		Avisar(Adjuntos.ESTADO_FALLO)
		Return
	End If
	mLista = True
	camEx.SetJpegQuality(Adjuntos.CALIDAD)
	camEx.SetContinuousAutoFocus
	camEx.CommitParameters
	camEx.StartPreview
	mConFlash = False
	Dim modos As List = camEx.GetSupportedFlashModes
	mTieneFlash = modos.IsInitialized And modos.IndexOf(FLASH_SI) > -1
	UI.Habilitar(mFlash, mTieneFlash)
	UI.MarcarGrupo(Array As B4XView(mFlash), -1)
	UI.Habilitar(mDisparar, True)
	UI.Habilitar(mRotar, Adjuntos.getPuedeRotar)
End Sub

Sub CamEx_PictureTaken (Data() As Byte)
	mDisparando = False
	UI.Habilitar(mDisparar, True)
	If mLista Then camEx.StartPreview
	CallSub2(mCallback, mEvento & "_Foto", Data)
End Sub
#End Region
