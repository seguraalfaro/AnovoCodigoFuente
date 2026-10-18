B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.7
@EndOfDesignText@
' Presentador del Perfil, como TPresentadorConfiguracion del escritorio: la cuenta, la prueba
' de conexion, las versiones y el cambio de clave, que vuelve a entrar con la clave nueva.

Sub Class_Globals
	Private Const LARGO_MINIMO As Int = 10
	Private Const SIN_DATO As String = "-"
	Private Const CAMPO_SERVIDOR As String = "servidor"
	Private Const CAMPO_BASE As String = "base_datos"
	Private Const CAMPO_MOVIL As String = "movil"
	Private Const CAMPO_AVISO As String = "aviso_privacidad"
	Private Const CAMPO_ADICIONALES As String = "permisos_adicionales"
	Private Const CAMPO_QUITADOS As String = "permisos_quitados"
	Private Const CAMPO_CLAVE As String = "clave_cambiada"
	Private Const CAMPO_TOKEN As String = "token"
	Private mPermisos As String
	Private mClave As String
	Private mProbado As Boolean
	Private mConectado As Boolean
	Private mMilisegundos As Long
	Private mVersionServidor As String
	Private mVersionBase As String
	Private mVersionMovil As String
	Private mVersionAviso As String
	Private mCargando As Boolean
	Private remota As SesionRemota
	Private mSesionVencida As Boolean
End Sub

Public Sub Initialize
	remota.Initialize
	Limpiar
End Sub

#Region Estado
Private Sub Limpiar
	mPermisos = SIN_DATO
	mClave = SIN_DATO
	mVersionServidor = SIN_DATO
	mVersionBase = SIN_DATO
	mVersionMovil = SIN_DATO
	mVersionAviso = SIN_DATO
End Sub

Public Sub Cargar As ResumableSub
	mCargando = True
	Wait For (Probar) Complete (Hecho As Boolean)
	If mConectado Then
		Wait For (remota.AsegurarSesion) Complete (Estado As Int)
		If Estado = Api.HTTP_OK Then
			Wait For (ApiSesion.Cuenta.Enviar) Complete (Respuesta As RestRespuesta)
			If Respuesta.Success Then LeerCuenta(Respuesta.DatosMap)
		End If
	End If
	mCargando = False
	Return True
End Sub

Private Sub LeerCuenta (d As Map)
	mPermisos = Mensajes.PermisosPropios(d.GetDefault(CAMPO_ADICIONALES, 0), d.GetDefault(CAMPO_QUITADOS, 0))
	Dim fecha As String = Utils.ApiADisplay(d.GetDefault(CAMPO_CLAVE, ""))
	mClave = Texto(fecha)
End Sub
#End Region

#Region Lo que pinta la página
Public Sub getIniciales As String
	Return Utils.Iniciales(Sesion.Nombre)
End Sub

Public Sub getNombre As String
	Return Sesion.Nombre
End Sub

Public Sub getCorreo As String
	Return Sesion.Correo
End Sub

Public Sub getRol As String
	Return Mensajes.NombreDeRol(Sesion.Rol)
End Sub

Public Sub getPermisos As String
	Return mPermisos
End Sub

Public Sub getClaveCambiada As String
	Return mClave
End Sub

Public Sub getServidor As String
	If Api.UrlServidor = "" Then Return SIN_DATO
	Return Api.UrlServidor
End Sub

Public Sub getEstadoConexion As String
	If mCargando Then Return Mensajes.PROBANDO
	If mProbado = False Then Return SIN_DATO
	If mConectado Then Return Mensajes.CONECTADO
	Return Mensajes.SIN_RESPUESTA
End Sub

Public Sub getConectado As Boolean
	Return mProbado And mConectado
End Sub

Public Sub getRespuesta As String
	If getConectado = False Then Return SIN_DATO
	Return Mensajes.Milisegundos(mMilisegundos)
End Sub

Public Sub getVersionApp As String
	If Application.VersionName <> "" Then Return Application.VersionName
	Return Application.VersionCode
End Sub

Public Sub getVersionServidor As String
	Return mVersionServidor
End Sub

Public Sub getVersionBase As String
	Return mVersionBase
End Sub

Public Sub getVersionMovil As String
	Return mVersionMovil
End Sub

Public Sub getVersionAviso As String
	Return mVersionAviso
End Sub
#End Region

#Region Acciones
Public Sub Probar As ResumableSub
	mCargando = True
	Dim inicio As Long = DateTime.Now
	Wait For (ApiSesion.Version.Enviar) Complete (Respuesta As RestRespuesta)
	mProbado = True
	mConectado = Respuesta.Success
	mMilisegundos = DateTime.Now - inicio
	If mConectado Then
		Dim d As Map = Respuesta.DatosMap
		mVersionServidor = Texto(d.GetDefault(CAMPO_SERVIDOR, ""))
		mVersionBase = Texto(d.GetDefault(CAMPO_BASE, ""))
		mVersionMovil = Texto(d.GetDefault(CAMPO_MOVIL, ""))
		mVersionAviso = Texto(d.GetDefault(CAMPO_AVISO, ""))
	End If
	mCargando = False
	Return mConectado
End Sub

Public Sub CambiarClave (Actual As String, Nueva As String, Repetida As String) As ResumableSub
	mSesionVencida = False
	Dim error As String = ValidarClave(Actual, Nueva, Repetida)
	If error <> "" Then Return Tipos.Falla(error)
	Wait For (remota.AsegurarSesion) Complete (Estado As Int)
	If Estado = Api.HTTP_NO_AUTORIZADO Then Return Vencida
	If Estado <> Api.HTTP_OK Then Return Tipos.Falla(Mensajes.CLAVE_SIN_CONEXION)
	Wait For (ApiSesion.CambiarClave(Actual, Nueva).Enviar) Complete (Respuesta As RestRespuesta)
	If Respuesta.StatusCode = Api.HTTP_NO_AUTORIZADO Then Return Vencida
	If Respuesta.Success = False Then Return Tipos.Falla(Api.MensajeDe(Respuesta))
	Wait For (ApiAutenticacion.IniciarSesion(Sesion.Correo, Nueva).Enviar) Complete (Ingreso As RestRespuesta)
	If Ingreso.Success = False Or Sesion.Abrir(Ingreso.Valor(CAMPO_TOKEN)) = False Then Return Tipos.Falla(Mensajes.CLAVE_CAMBIADA_REINGRESO)
	LlaveDispositivo.GuardarPerfil(Sesion.UsuarioId, Sesion.Correo, Sesion.Nombre, Sesion.Rol)
	Wait For (remota.RegistrarTelefono) Complete (Registrado As Boolean)
	Wait For (Cargar) Complete (Hecho As Boolean)
	Dim texto As String = Mensajes.CLAVE_CAMBIADA
	If Registrado = False Then texto = texto & " " & Mensajes.TELEFONO_NO_REGISTRADO
	Return Tipos.Correcto(texto)
End Sub

Public Sub getSesionVencida As Boolean
	Return mSesionVencida
End Sub

Private Sub Vencida As Resultado
	mSesionVencida = True
	Return Tipos.Falla(Mensajes.SESION_VENCIDA)
End Sub

Private Sub ValidarClave (Actual As String, Nueva As String, Repetida As String) As String
	If Actual = "" Then Return Mensajes.FALTA_CLAVE_ACTUAL
	If Nueva.Length < LARGO_MINIMO Then Return Mensajes.ClaveCorta(LARGO_MINIMO)
	If Regex.IsMatch(".*[A-Za-zÁÉÍÓÚÑáéíóúñ].*", Nueva) = False Or Regex.IsMatch(".*[0-9].*", Nueva) = False Then Return Mensajes.CLAVE_SIN_LETRAS_NUMEROS
	If Nueva <> Repetida Then Return Mensajes.CLAVE_NO_COINCIDE
	If Nueva = Actual Then Return Mensajes.CLAVE_IGUAL
	Return ""
End Sub
#End Region

#Region Ayudantes
Private Sub Texto (Valor As Object) As String
	If Valor = Null Or Valor = "" Then Return SIN_DATO
	Return Valor
End Sub
#End Region
