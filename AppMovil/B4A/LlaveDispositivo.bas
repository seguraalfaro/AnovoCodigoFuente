B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.7
@EndOfDesignText@
' Identidad del telefono y su llave para renovar la sesion. La llave se guarda cifrada
' con una clave AES del Keystore de Android, que no sale del telefono; nunca en claro.

Sub Process_Globals
	Private kvs As KeyValueStore
	Private Const ARCHIVO As String = "dispositivo.dat"
	Private Const CLAVE_UUID As String = "uuid"
	Private Const CLAVE_LLAVE As String = "llave"
	Private Const CLASE_JAVA As String = ".llavedispositivo"
	Private Const CLAVE_USUARIO As String = "usuario_id"
	Private Const CLAVE_CORREO As String = "correo"
	Private Const CLAVE_NOMBRE As String = "nombre"
	Private Const CLAVE_ROL As String = "rol"
	Private Const CLAVE_ACTIVO As String = "desbloqueo"
	Private Const CLAVE_CONTACTO As String = "ultimo_contacto"
	Private Const DIAS_SIN_CONEXION As Int = 30
End Sub

#Region Identidad del teléfono
Private Sub Almacen As KeyValueStore
	If kvs.IsInitialized = False Then kvs.Initialize(File.DirInternal, ARCHIVO)
	Return kvs
End Sub

Public Sub Uuid As String
	Dim u As String = Almacen.GetDefault(CLAVE_UUID, "")
	If u = "" Then
		u = Db.NuevoUuid
		Almacen.Put(CLAVE_UUID, u)
	End If
	Return u
End Sub

Public Sub NombreTelefono As String
	Dim p As Phone
	Return (p.Manufacturer & " " & p.Model).Trim
End Sub
#End Region

#Region Llave cifrada
Public Sub HayLlave As Boolean
	Return Almacen.ContainsKey(CLAVE_LLAVE)
End Sub

Public Sub Guardar (Llave As String) As Boolean
	Try
		Almacen.Put(CLAVE_LLAVE, Nativo.RunMethod("cifrar", Array(Llave)))
		Return True
	Catch
		Log("LlaveDispositivo.Guardar: " & LastException.Message)
		Borrar
		Return False
	End Try
End Sub

Public Sub Leer As String
	If HayLlave = False Then Return ""
	Try
		Return Nativo.RunMethod("descifrar", Array(Almacen.Get(CLAVE_LLAVE)))
	Catch
		Log("LlaveDispositivo.Leer: " & LastException.Message)
		Borrar
		Return ""
	End Try
End Sub

Public Sub Borrar
	Almacen.Remove(CLAVE_LLAVE)
End Sub

Public Sub BorrarTodo
	For Each c As String In Array As String(CLAVE_LLAVE, CLAVE_USUARIO, CLAVE_CORREO, CLAVE_NOMBRE, CLAVE_ROL, CLAVE_ACTIVO, CLAVE_CONTACTO)
		Almacen.Remove(c)
	Next
End Sub
#End Region

#Region Perfil guardado
Public Sub GuardarPerfil (Id As Int, CorreoUsuario As String, NombreUsuario As String, RolUsuario As String)
	If Id <> Almacen.GetDefault(CLAVE_USUARIO, 0) Then Almacen.Remove(CLAVE_ACTIVO)
	Almacen.Put(CLAVE_USUARIO, Id)
	Almacen.Put(CLAVE_CORREO, CorreoUsuario)
	Almacen.Put(CLAVE_NOMBRE, NombreUsuario)
	Almacen.Put(CLAVE_ROL, RolUsuario)
	MarcarContacto
End Sub

Public Sub Perfil As PerfilLocal
	Dim p As PerfilLocal
	p.Initialize
	p.UsuarioId = Almacen.GetDefault(CLAVE_USUARIO, 0)
	p.Correo = Almacen.GetDefault(CLAVE_CORREO, "")
	p.Nombre = Almacen.GetDefault(CLAVE_NOMBRE, "")
	p.Rol = Almacen.GetDefault(CLAVE_ROL, "")
	Return p
End Sub

Public Sub MarcarContacto
	Almacen.Put(CLAVE_CONTACTO, DateTime.Now)
End Sub
#End Region

#Region Desbloqueo
Public Sub DesbloqueoActivo As Boolean
	Return Almacen.GetDefault(CLAVE_ACTIVO, False)
End Sub

Public Sub ActivarDesbloqueo (Activo As Boolean)
	Almacen.Put(CLAVE_ACTIVO, Activo)
End Sub

Public Sub PuedeDesbloquear As Boolean
	If HayLlave = False Or DesbloqueoActivo = False Then Return False
	If Almacen.ContainsKey(CLAVE_USUARIO) = False Then Return False
	Dim ultimo As Long = Almacen.GetDefault(CLAVE_CONTACTO, 0)
	Return DateTime.Now - ultimo < DIAS_SIN_CONEXION * DateTime.TicksPerDay
End Sub
#End Region

#Region Java nativo
Private Sub Nativo As JavaObject
	Dim jo As JavaObject
	jo.InitializeStatic(Application.PackageName & CLASE_JAVA)
	Return jo
End Sub
#End Region

#If JAVA
import java.security.KeyStore;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;
import android.util.Base64;

private static final String ALIAS = "anovo_llave_dispositivo";
private static final int LARGO_IV = 12;
private static final int BITS_ETIQUETA = 128;

private static SecretKey claveAes() throws Exception {
	KeyStore ks = KeyStore.getInstance("AndroidKeyStore");
	ks.load(null);
	if (ks.containsAlias(ALIAS))
		return ((KeyStore.SecretKeyEntry) ks.getEntry(ALIAS, null)).getSecretKey();
	KeyGenerator kg = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore");
	kg.init(new KeyGenParameterSpec.Builder(ALIAS,
		KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
		.setBlockModes(KeyProperties.BLOCK_MODE_GCM)
		.setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
		.build());
	return kg.generateKey();
}

public static String cifrar(String texto) throws Exception {
	Cipher c = Cipher.getInstance("AES/GCM/NoPadding");
	c.init(Cipher.ENCRYPT_MODE, claveAes());
	byte[] iv = c.getIV();
	byte[] datos = c.doFinal(texto.getBytes("UTF-8"));
	byte[] todo = new byte[iv.length + datos.length];
	System.arraycopy(iv, 0, todo, 0, iv.length);
	System.arraycopy(datos, 0, todo, iv.length, datos.length);
	return Base64.encodeToString(todo, Base64.NO_WRAP);
}

public static String descifrar(String guardado) throws Exception {
	byte[] todo = Base64.decode(guardado, Base64.NO_WRAP);
	Cipher c = Cipher.getInstance("AES/GCM/NoPadding");
	c.init(Cipher.DECRYPT_MODE, claveAes(), new GCMParameterSpec(BITS_ETIQUETA, todo, 0, LARGO_IV));
	return new String(c.doFinal(todo, LARGO_IV, todo.length - LARGO_IV), "UTF-8");
}
#End If
