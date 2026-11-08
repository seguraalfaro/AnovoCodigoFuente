; Anovo: un solo script para dos instaladores, elegido con /DProducto=servidor|escritorio.
; Instala la versión de 64 o de 32 bits según el Windows del equipo.
; Toma los ejecutables de las carpetas de salida de Delphi: compilar antes en Release.

#ifndef Producto
  #define Producto "servidor"
#endif
#define Version "1.0.0"
#define Terceros AddBackslash(SourcePath) + "..\..\Instalador-terceros"
#define FbX64 "Firebird-4.0.6.3221-0-x64.exe"
#define FbX86 "Firebird-4.0.6.3221-0-Win32.exe"
#define FbZip Terceros + "\firebird\Firebird-4.0.6.3221-0-x64"
#define SslX64 Terceros + "\openssl\openssl-3.5.8-Windows-x64"
#define SslX86 Terceros + "\openssl\openssl-3.5.8-Windows-x86"
#define TunelHost "api.anovoms.com"
#if FileExists(Terceros + "\cloudflared\cloudflared-windows-amd64.exe") && FileExists(Terceros + "\cloudflared\cloudflared-windows-386.exe") && FileExists(Terceros + "\tunel\credenciales.json")
  #define HayTunel
#endif

[Setup]
#if Producto == "servidor"
AppId={{04420858-052C-4303-AE26-B4E7FE2F30AF}
AppName=Anovo Servidor
AppVerName=Anovo Servidor {#Version}
SetupIconFile=..\Backend\AnovoAPI_Icon1.ico
OutputBaseFilename=Anovo-Servidor-{#Version}
#else
AppId={{38AC0F0D-500D-4E82-9C48-71E4FA90BBA2}
AppName=Anovo Escritorio
AppVerName=Anovo Escritorio {#Version}
SetupIconFile=..\Desktop\AnovoEscritorio_Icon1.ico
OutputBaseFilename=Anovo-Escritorio-{#Version}
#endif
AppVersion={#Version}
AppPublisher=Anovo
DefaultDirName={sd}\Anovo
DefaultGroupName=Anovo
DisableProgramGroupPage=yes
UsePreviousAppDir=yes
PrivilegesRequired=admin
ArchitecturesAllowed=x86compatible x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
WizardStyle=modern
UninstallDisplayIcon={uninstallexe}
OutputDir=salida
Compression=lzma2/max
SolidCompression=yes
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"

#if Producto == "escritorio"
[Tasks]
Name: "iconoescritorio"; Description: "Crear un acceso directo en el escritorio"
#endif

[Dirs]
#if Producto == "servidor"
Name: "{app}\Servidor\logs"
Name: "{app}\Servidor\certificates"
Name: "{app}\db"; Flags: uninsneveruninstall
#else
Name: "{app}\Escritorio"; Permissions: users-modify
#endif

[Files]
#if Producto == "servidor"
Source: "..\Backend\bin64\AnovoAPI.exe"; DestDir: "{app}\Servidor"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#SslX64}\libcrypto-3-x64.dll"; DestDir: "{app}\Servidor"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#SslX64}\libssl-3-x64.dll"; DestDir: "{app}\Servidor"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#FbZip}\fbclient.dll"; DestDir: "{app}\Servidor"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#FbZip}\msvcp140.dll"; DestDir: "{app}\Servidor"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#FbZip}\vcruntime140.dll"; DestDir: "{app}\Servidor"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#FbZip}\zlib1.dll"; DestDir: "{app}\Servidor"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "..\Backend\bin\AnovoAPI.exe"; DestDir: "{app}\Servidor"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "{#SslX86}\libcrypto-3.dll"; DestDir: "{app}\Servidor"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "{#SslX86}\libssl-3.dll"; DestDir: "{app}\Servidor"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "..\Backend\bin\swaggerui\*"; DestDir: "{app}\Servidor\swaggerui"; Flags: ignoreversion recursesubdirs createallsubdirs
#ifdef HayTunel
Source: "{#Terceros}\cloudflared\cloudflared-windows-amd64.exe"; DestDir: "{app}\Servidor\tunel"; DestName: "cloudflared.exe"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#Terceros}\cloudflared\cloudflared-windows-386.exe"; DestDir: "{app}\Servidor\tunel"; DestName: "cloudflared.exe"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "{#Terceros}\tunel\credenciales.json"; DestDir: "{app}\Servidor\tunel"; Flags: ignoreversion
#endif
Source: "plantillas\servidor.env"; Flags: dontcopy
Source: "plantillas\FDConnectionDefs.ini"; Flags: dontcopy
Source: "plantillas\config.yml"; Flags: dontcopy
Source: "scripts\aleatorio.ps1"; Flags: dontcopy
Source: "scripts\ips.ps1"; Flags: dontcopy
Source: "scripts\tarea-servidor.ps1"; Flags: dontcopy
Source: "{#SslX86}\openssl.exe"; Flags: dontcopy
Source: "{#SslX86}\libcrypto-3.dll"; Flags: dontcopy
Source: "{#SslX86}\libssl-3.dll"; Flags: dontcopy
Source: "base\anovo_produccion.fbk"; Flags: dontcopy
Source: "{#Terceros}\firebird\{#FbX64}"; Flags: dontcopy
Source: "{#Terceros}\firebird\{#FbX86}"; Flags: dontcopy
#else
Source: "..\Desktop\Win64\Release\AnovoEscritorio.exe"; DestDir: "{app}\Escritorio"; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "..\Desktop\Win32\Release\AnovoEscritorio.exe"; DestDir: "{app}\Escritorio"; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "..\Desktop\Src\Recursos\Marca\*"; DestDir: "{app}\Escritorio\Recursos\Marca"; Flags: ignoreversion
Source: "..\Desktop\Src\Recursos\Iconos\*"; DestDir: "{app}\Escritorio\Recursos\Iconos"; Excludes: "*.py,*.md,*.txt"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "plantillas\AnovoEscritorio.ini"; Flags: dontcopy
Source: "scripts\traer-certificado.ps1"; Flags: dontcopy
#endif

[Icons]
#if Producto == "servidor"
Name: "{group}\Servidor Anovo"; Filename: "{app}\Servidor\AnovoAPI.exe"; WorkingDir: "{app}\Servidor"
#else
Name: "{group}\Anovo"; Filename: "{app}\Escritorio\AnovoEscritorio.exe"; WorkingDir: "{app}\Escritorio"
Name: "{autodesktop}\Anovo"; Filename: "{app}\Escritorio\AnovoEscritorio.exe"; WorkingDir: "{app}\Escritorio"; Tasks: iconoescritorio
#endif

[Run]
#if Producto == "servidor"
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Anovo API"""; Flags: runhidden
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Anovo API"" dir=in action=allow program=""{app}\Servidor\AnovoAPI.exe"" protocol=TCP localport={code:Puerto} profile=any remoteip=localsubnet"; StatusMsg: "Abriendo el puerto del servidor en el firewall..."; Flags: runhidden
Filename: "{app}\Servidor\AnovoAPI.exe"; WorkingDir: "{app}\Servidor"; Description: "Abrir el servidor para registrar al administrador y los datos de la empresa"; Flags: postinstall nowait skipifsilent
#else
Filename: "{app}\Escritorio\AnovoEscritorio.exe"; WorkingDir: "{app}\Escritorio"; Description: "Abrir la aplicación de escritorio"; Flags: postinstall nowait skipifsilent
#endif

#if Producto == "servidor"
[UninstallRun]
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Anovo API"""; RunOnceId: "ReglaFirewall"; Flags: runhidden
Filename: "{sys}\schtasks.exe"; Parameters: "/Delete /TN ""Servidor Anovo"" /F"; RunOnceId: "TareaServidor"; Flags: runhidden

[InstallDelete]
Type: files; Name: "{commonstartup}\Servidor Anovo.lnk"
#endif

[Code]
const
  CLAVE_FIREBIRD = 'SOFTWARE\Firebird Project\Firebird Server\Instances';
  SERVICIO_FIREBIRD = 'FirebirdServerDefaultInstance';

var
  PaginaRed: TInputQueryWizardPage;
#if Producto == "servidor"
  PaginaSysdba: TInputQueryWizardPage;
  PaginaCotizacion: TInputQueryWizardPage;
  FirebirdPrevio: string;
#endif

function SetEnvironmentVariable(lpName, lpValue: string): BOOL;
  external 'SetEnvironmentVariableW@kernel32.dll stdcall';

function RutaServidor: string;
begin
  Result := ExpandConstant('{app}\Servidor\');
end;

function Puerto(Param: string): string;
begin
  Result := Trim(PaginaRed.Values[1]);
end;

function NombreServidor: string;
begin
  Result := Trim(PaginaRed.Values[0]);
end;

function Falta(const Mensaje: string): Boolean;
begin
  MsgBox(Mensaje, mbError, MB_OK);
  Result := False;
end;

procedure Avisar(const Mensaje: string);
begin
  SuppressibleMsgBox(Mensaje, mbError, MB_OK, IDOK);
end;

function Auxiliar(const Nombre, Parametros: string): Boolean;
var
  Codigo: Integer;
begin
  ExtractTemporaryFile(Nombre);
  Result := Exec(ExpandConstant('{sys}\WindowsPowerShell\v1.0\powershell.exe'),
    '-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "' + ExpandConstant('{tmp}\') + Nombre + '" ' + Parametros,
    '', SW_HIDE, ewWaitUntilTerminated, Codigo) and (Codigo = 0);
end;

function LeerPlantilla(const Nombre: string): string;
var
  Texto: AnsiString;
begin
  ExtractTemporaryFile(Nombre);
  if not LoadStringFromFile(ExpandConstant('{tmp}\') + Nombre, Texto) then
    RaiseException('No se pudo leer la plantilla ' + Nombre + '.');
  Result := String(Texto);
end;

procedure Reemplazar(var Texto: string; const Marca, Valor: string);
begin
  StringChangeEx(Texto, '{{' + Marca + '}}', Valor, True);
end;

procedure CrearPaginaRed(const Ayuda: string);
begin
  PaginaRed := CreateInputQueryPage(wpSelectDir, 'Servidor de Anovo',
    'Nombre y puerto con que los equipos de la oficina llegan al servidor.', Ayuda);
  PaginaRed.Add('Nombre o dirección IP del servidor:', False);
  PaginaRed.Add('Puerto HTTPS:', False);
  PaginaRed.Values[0] := GetPreviousData('Servidor', Lowercase(GetComputerNameString));
  PaginaRed.Values[1] := GetPreviousData('Puerto', '443');
end;

function RedValida: Boolean;
var
  Numero: Integer;
begin
  Result := True;
  Numero := StrToIntDef(Puerto(''), 0);
  if NombreServidor = '' then
    Result := Falta('Escriba el nombre o la dirección IP del servidor.')
  else if (Numero < 1) or (Numero > 65535) then
    Result := Falta('El puerto tiene que ser un número entre 1 y 65535.');
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  SetPreviousData(PreviousDataKey, 'Servidor', NombreServidor);
  SetPreviousData(PreviousDataKey, 'Puerto', Puerto(''));
end;

#if Producto == "servidor"
function BuscarFirebird: string;
begin
  Result := '';
  if IsWin64 and RegQueryStringValue(HKLM64, CLAVE_FIREBIRD, 'DefaultInstance', Result) and (Result <> '') then
    Exit;
  if RegQueryStringValue(HKLM32, CLAVE_FIREBIRD, 'DefaultInstance', Result) and (Result <> '') then
    Exit;
  Result := '';
end;

function RutaBase: string;
begin
  Result := ExpandConstant('{app}\db\ANOVO.FDB');
end;

function Dsn: string;
begin
  Result := '127.0.0.1:' + RutaBase;
end;

function LeerTunelId(const Archivo: string): string;
var
  Texto: AnsiString;
  S: string;
  P: Integer;
begin
  Result := '';
  if not LoadStringFromFile(Archivo, Texto) then
    Exit;
  S := String(Texto);
  P := Pos('"TunnelID"', S);
  if P = 0 then
    Exit;
  Delete(S, 1, P + 9);
  P := Pos('"', S);
  if P = 0 then
    Exit;
  Delete(S, 1, P);
  P := Pos('"', S);
  if P = 0 then
    Exit;
  Result := Copy(S, 1, P - 1);
end;

procedure InitializeWizard;
var
  Ayuda: string;
begin
  FirebirdPrevio := BuscarFirebird;
  CrearPaginaRed('Se deja el nombre de este equipo: con él y sus direcciones IP se genera el certificado HTTPS. Los equipos de la oficina usan este mismo nombre y puerto al instalar la aplicación de escritorio.');

  if FirebirdPrevio = '' then
    Ayuda := 'Firebird 4.0.6 se instala con esta clave. Guárdela en un lugar seguro: hace falta para respaldar y restaurar la base.'
  else
    Ayuda := 'Firebird ya está instalado en ' + FirebirdPrevio + '. Escriba la clave de SYSDBA que tiene hoy.';
  PaginaSysdba := CreateInputQueryPage(PaginaRed.ID, 'Base de datos',
    'Clave del administrador de Firebird (SYSDBA).', Ayuda);
  PaginaSysdba.Add('Clave de SYSDBA:', True);
  PaginaSysdba.Add('Confirmar la clave:', True);

  PaginaCotizacion := CreateInputQueryPage(PaginaSysdba.ID, 'Cotizaciones',
    'Número con que empieza la numeración de las cotizaciones.',
    'Si Anovo viene numerando cotizaciones a mano, escriba el número que sigue. Si empieza de cero, deje 1.');
  PaginaCotizacion.Add('Primer número de cotización:', False);
  PaginaCotizacion.Values[0] := '1';
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := (PageID = PaginaCotizacion.ID) and FileExists(RutaBase);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID = PaginaRed.ID then
    Result := RedValida
  else if CurPageID = PaginaSysdba.ID then
  begin
    if PaginaSysdba.Values[0] = '' then
      Result := Falta('Escriba la clave de SYSDBA.')
    else if PaginaSysdba.Values[0] <> PaginaSysdba.Values[1] then
      Result := Falta('Las dos claves no coinciden.')
    else if Pos('"', PaginaSysdba.Values[0]) > 0 then
      Result := Falta('La clave no puede llevar comillas dobles.');
  end
  else if CurPageID = PaginaCotizacion.ID then
  begin
    if StrToIntDef(Trim(PaginaCotizacion.Values[0]), 0) < 1 then
      Result := Falta('El primer número de cotización tiene que ser 1 o mayor.');
  end;
end;

function Ejecutar(const Exe, Parametros, Paso: string): Boolean;
var
  Codigo, I: Integer;
  Salida: TExecOutput;
  Detalle: string;
begin
  WizardForm.StatusLabel.Caption := Paso + '...';
  Result := ExecAndCaptureOutput(Exe, Parametros, '', SW_HIDE, ewWaitUntilTerminated, Codigo, Salida) and (Codigo = 0);
  if not Result then
  begin
    Detalle := '';
    for I := 0 to GetArrayLength(Salida.StdErr) - 1 do
      Detalle := Detalle + #13#10 + Salida.StdErr[I];
    for I := 0 to GetArrayLength(Salida.StdOut) - 1 do
      Detalle := Detalle + #13#10 + Salida.StdOut[I];
    Avisar(Paso + ': no se pudo completar.' + #13#10 + Detalle);
  end;
end;

function Aleatorio(Bytes: Integer): string;
var
  Archivo: string;
  Texto: AnsiString;
begin
  Archivo := ExpandConstant('{tmp}\aleatorio.txt');
  Result := '';
  if Auxiliar('aleatorio.ps1', '-Bytes ' + IntToStr(Bytes) + ' -Salida "' + Archivo + '"') and
    LoadStringFromFile(Archivo, Texto) then
    Result := Trim(String(Texto));
  DeleteFile(Archivo);
  if Length(Result) <> Bytes * 2 then
    RaiseException('No se pudo generar una clave aleatoria.');
end;

function GenerarCertificado: Boolean;
var
  Carpeta, Cnf, Ips: string;
  Lineas: TArrayOfString;
  I, N: Integer;
begin
  Carpeta := RutaServidor + 'certificates\';
  Result := FileExists(Carpeta + 'servidor.crt') and FileExists(Carpeta + 'servidor.key');
  if Result then
    Exit;
  WizardForm.StatusLabel.Caption := 'Generando el certificado HTTPS del servidor...';
  Ips := ExpandConstant('{tmp}\ips.txt');
  if not Auxiliar('ips.ps1', '-Salida "' + Ips + '"') or not LoadStringsFromFile(Ips, Lineas) then
    SetArrayLength(Lineas, 0);
  Cnf := '[req]' + #13#10 + 'prompt = no' + #13#10 + 'distinguished_name = dn' + #13#10 +
    'x509_extensions = v3' + #13#10#13#10 +
    '[dn]' + #13#10 + 'C = CR' + #13#10 + 'O = Anovo' + #13#10 + 'CN = ' + NombreServidor + #13#10#13#10 +
    '[v3]' + #13#10 + 'keyUsage = critical, digitalSignature, keyEncipherment' + #13#10 +
    'extendedKeyUsage = serverAuth' + #13#10 + 'subjectKeyIdentifier = hash' + #13#10 +
    'subjectAltName = @nombres' + #13#10#13#10 +
    '[nombres]' + #13#10 + 'DNS.1 = ' + NombreServidor + #13#10 + 'DNS.2 = localhost' + #13#10 +
    'IP.1 = 127.0.0.1' + #13#10;
  N := 1;
  for I := 0 to GetArrayLength(Lineas) - 1 do
    if Trim(Lineas[I]) <> '' then
    begin
      N := N + 1;
      Cnf := Cnf + 'IP.' + IntToStr(N) + ' = ' + Trim(Lineas[I]) + #13#10;
    end;
  SaveStringToFile(ExpandConstant('{tmp}\servidor.cnf'), Cnf, False);
  ExtractTemporaryFile('openssl.exe');
  ExtractTemporaryFile('libcrypto-3.dll');
  ExtractTemporaryFile('libssl-3.dll');
  SetEnvironmentVariable('OPENSSL_CONF', ExpandConstant('{tmp}\servidor.cnf'));
  Result := Ejecutar(ExpandConstant('{tmp}\openssl.exe'),
    'req -x509 -newkey rsa:2048 -noenc -sha256 -days 3650 -config "' + ExpandConstant('{tmp}\servidor.cnf') +
    '" -keyout "' + Carpeta + 'servidor.key" -out "' + Carpeta + 'servidor.crt"',
    'Generando el certificado HTTPS del servidor');
  SetEnvironmentVariable('OPENSSL_CONF', '');
end;

procedure FijarClave(const Archivo, Clave, Valor: string);
var
  Lineas: TArrayOfString;
  I, N: Integer;
begin
  if not LoadStringsFromFile(Archivo, Lineas) then
    SetArrayLength(Lineas, 0);
  N := GetArrayLength(Lineas);
  for I := 0 to N - 1 do
    if Pos(Clave + '=', Trim(Lineas[I])) = 1 then
    begin
      Lineas[I] := Clave + '=' + Valor;
      SaveStringsToUTF8File(Archivo, Lineas, False);
      Exit;
    end;
  SetArrayLength(Lineas, N + 1);
  Lineas[N] := Clave + '=' + Valor;
  SaveStringsToUTF8File(Archivo, Lineas, False);
end;

function InstalarFirebird: Boolean;
var
  Archivo: string;
  Codigo: Integer;
begin
  if Is64BitInstallMode then
    Archivo := '{#FbX64}'
  else
    Archivo := '{#FbX86}';
  WizardForm.StatusLabel.Caption := 'Instalando Firebird 4.0.6...';
  ExtractTemporaryFile(Archivo);
  Result := Exec(ExpandConstant('{tmp}\') + Archivo,
    '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /NOICONS' +
    ' /COMPONENTS="ServerComponent,DevAdminComponent,ClientComponent"' +
    ' /TASKS="UseSuperServerTask,UseServiceTask,AutoStartTask,CopyFbClientToSysTask"' +
    ' /SYSDBAPASSWORD="' + PaginaSysdba.Values[0] + '"',
    '', SW_HIDE, ewWaitUntilTerminated, Codigo) and (Codigo = 0);
  DeleteFile(ExpandConstant('{tmp}\') + Archivo);
end;

procedure SoloConexionLocal(const Carpeta: string);
var
  Archivo, Linea: string;
  Lineas: TArrayOfString;
  I, N, Codigo: Integer;
  Hecho: Boolean;
begin
  Archivo := Carpeta + 'firebird.conf';
  if not LoadStringsFromFile(Archivo, Lineas) then
    Exit;
  Hecho := False;
  N := GetArrayLength(Lineas);
  for I := 0 to N - 1 do
  begin
    Linea := Trim(Lineas[I]);
    if (not Hecho) and ((Pos('RemoteBindAddress', Linea) = 1) or (Pos('#RemoteBindAddress', Linea) = 1)) then
    begin
      Lineas[I] := 'RemoteBindAddress = 127.0.0.1';
      Hecho := True;
    end;
  end;
  if not Hecho then
  begin
    SetArrayLength(Lineas, N + 1);
    Lineas[N] := 'RemoteBindAddress = 127.0.0.1';
  end;
  SaveStringsToFile(Archivo, Lineas, False);
  WizardForm.StatusLabel.Caption := 'Reiniciando Firebird...';
  Exec(ExpandConstant('{sys}\net.exe'), 'stop ' + SERVICIO_FIREBIRD, '', SW_HIDE, ewWaitUntilTerminated, Codigo);
  Exec(ExpandConstant('{sys}\net.exe'), 'start ' + SERVICIO_FIREBIRD, '', SW_HIDE, ewWaitUntilTerminated, Codigo);
end;

procedure Restringir(const Carpeta: string; ConUsuario: Boolean);
var
  Permisos: string;
  Codigo: Integer;
begin
  Permisos := '"' + RemoveBackslash(Carpeta) + '" /inheritance:r /grant:r *S-1-5-18:(OI)(CI)F *S-1-5-32-544:(OI)(CI)F';
  if ConUsuario then
    Permisos := Permisos + ' "' + GetUserNameString + '":(OI)(CI)M';
  Exec(ExpandConstant('{sys}\icacls.exe'), Permisos, '', SW_HIDE, ewWaitUntilTerminated, Codigo);
end;

procedure EscribirConexion(const Clave, Firebird: string);
var
  Texto: string;
begin
  Texto := LeerPlantilla('FDConnectionDefs.ini');
  Reemplazar(Texto, 'BASE', RutaBase);
  Reemplazar(Texto, 'CLAVE', Clave);
  if Is64BitInstallMode then
    Reemplazar(Texto, 'VENDORLIB', RutaServidor + 'fbclient.dll')
  else
    Reemplazar(Texto, 'VENDORLIB', Firebird + 'fbclient.dll');
  SaveStringToFile(RutaServidor + 'FDConnectionDefs.ini', Texto, False);
end;

procedure EscribirEnv;
var
  Texto: string;
begin
  Texto := LeerPlantilla('servidor.env');
  Reemplazar(Texto, 'PUERTO', Puerto(''));
  Reemplazar(Texto, 'JWT_SECRET', Aleatorio(48));
  Reemplazar(Texto, 'CERT', RutaServidor + 'certificates\servidor.crt');
  Reemplazar(Texto, 'LLAVE', RutaServidor + 'certificates\servidor.key');
  Reemplazar(Texto, 'LOGS', RutaServidor + 'logs');
  SaveStringToFile(RutaServidor + '.env', Texto, False);
end;

procedure EscribirTunel;
var
  Texto, Carpeta: string;
begin
  Carpeta := RutaServidor + 'tunel\';
  Texto := LeerPlantilla('config.yml');
  Reemplazar(Texto, 'TUNEL_ID', LeerTunelId(Carpeta + 'credenciales.json'));
  Reemplazar(Texto, 'CREDENCIALES', Carpeta + 'credenciales.json');
  Reemplazar(Texto, 'LOG', RutaServidor + 'logs\cloudflared.log');
  Reemplazar(Texto, 'HOST', '{#TunelHost}');
  Reemplazar(Texto, 'PUERTO', Puerto(''));
  Reemplazar(Texto, 'SERVIDOR', NombreServidor);
  Reemplazar(Texto, 'CA', RutaServidor + 'certificates\servidor.crt');
  SaveStringToFile(Carpeta + 'config.yml', Texto, False);
  FijarClave(RutaServidor + '.env', 'anovo.tunel.exe', Carpeta + 'cloudflared.exe');
  FijarClave(RutaServidor + '.env', 'anovo.tunel.config', Carpeta + 'config.yml');
  FijarClave(RutaServidor + '.env', 'anovo.tunel.automatico', 'true');
end;

function PrepararBase(const Firebird: string): Boolean;
var
  Script, Clave: string;
  BaseNueva: Boolean;
  Primero: Integer;
begin
  Result := False;
  BaseNueva := not FileExists(RutaBase);
  if BaseNueva then
  begin
    Restringir(ExpandConstant('{app}\db'), False);
    ExtractTemporaryFile('anovo_produccion.fbk');
    if not Ejecutar(Firebird + 'gbak.exe', '-c "' + ExpandConstant('{tmp}\anovo_produccion.fbk') + '" "' + Dsn + '"',
      'Creando la base de datos') then
      Exit;
  end;
  if BaseNueva or not FileExists(RutaServidor + 'FDConnectionDefs.ini') then
  begin
    Clave := Aleatorio(24);
    Script := 'CREATE OR ALTER USER ANOVO_BACKEND PASSWORD ''' + Clave + ''' USING PLUGIN Srp;' + #13#10;
    Primero := StrToIntDef(Trim(PaginaCotizacion.Values[0]), 1);
    if BaseNueva and (Primero > 1) then
      Script := Script + 'ALTER SEQUENCE GEN_COTIZACION_NUMERO RESTART WITH ' + IntToStr(Primero) + ';' + #13#10;
    Script := Script + 'COMMIT;' + #13#10;
    SaveStringToFile(ExpandConstant('{tmp}\usuario.sql'), Script, False);
    try
      if not Ejecutar(Firebird + 'isql.exe', '-q -bail -i "' + ExpandConstant('{tmp}\usuario.sql') + '" "' + Dsn + '"',
        'Creando el usuario de la base') then
        Exit;
    finally
      DeleteFile(ExpandConstant('{tmp}\usuario.sql'));
    end;
    EscribirConexion(Clave, Firebird);
  end;
  Result := True;
end;

procedure PrepararServidor;
var
  Firebird: string;
  Lista: Boolean;
begin
  Restringir(RutaServidor, True);
  Firebird := BuscarFirebird;
  if Firebird = '' then
  begin
    if not InstalarFirebird then
    begin
      Avisar('Firebird no se pudo instalar. Instálelo aparte y vuelva a correr este instalador.');
      Exit;
    end;
    Firebird := BuscarFirebird;
    if Firebird = '' then
    begin
      Avisar('Firebird quedó instalado, pero no se encontró su carpeta en el registro de Windows.');
      Exit;
    end;
    SoloConexionLocal(AddBackslash(Firebird));
  end;
  Firebird := AddBackslash(Firebird);

  SetEnvironmentVariable('ISC_USER', 'SYSDBA');
  SetEnvironmentVariable('ISC_PASSWORD', PaginaSysdba.Values[0]);
  try
    Lista := PrepararBase(Firebird);
  finally
    SetEnvironmentVariable('ISC_PASSWORD', '');
    SetEnvironmentVariable('ISC_USER', '');
  end;
  if not Lista or not GenerarCertificado then
    Exit;

  if not FileExists(RutaServidor + '.env') then
    EscribirEnv;
#ifdef HayTunel
  EscribirTunel;
#endif
  if not Auxiliar('tarea-servidor.ps1', '-Carpeta "' + RemoveBackslash(RutaServidor) + '"') then
    Avisar('No se pudo programar el arranque del servidor al encender el equipo. Ábralo desde el menú Inicio, en Servidor Anovo.');
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    PrepararServidor;
end;
#else
procedure InitializeWizard;
begin
  CrearPaginaRed('Escriba el mismo nombre y puerto que se usaron al instalar el servidor de Anovo. El servidor tiene que estar encendido: de él se trae el certificado HTTPS.');
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID = PaginaRed.ID then
    Result := RedValida;
end;

function CertificadoEscritorio: Boolean;
var
  Archivo, Local: string;
  Codigo: Integer;
begin
  Archivo := ExpandConstant('{app}\Escritorio\certificados\servidor.crt');
  ForceDirectories(ExtractFileDir(Archivo));
  Local := RutaServidor + 'certificates\servidor.crt';
  if FileExists(Local) then
    Result := CopyFile(Local, Archivo, False)
  else
  begin
    WizardForm.StatusLabel.Caption := 'Trayendo el certificado del servidor ' + NombreServidor + '...';
    DeleteFile(Archivo);
    Result := Auxiliar('traer-certificado.ps1', '-Servidor "' + NombreServidor + '" -Puerto ' + Puerto('') +
      ' -Salida "' + Archivo + '"') and FileExists(Archivo);
  end;
  if not Result then
  begin
    Avisar('No se pudo obtener el certificado del servidor ' + NombreServidor + ':' + Puerto('') + '. ' +
      'Revise que el servidor de Anovo esté abierto y que el nombre y el puerto sean los mismos que se usaron al instalarlo; luego vuelva a correr este instalador.');
    Exit;
  end;
  WizardForm.StatusLabel.Caption := 'Instalando el certificado del servidor en Windows...';
  Result := Exec(ExpandConstant('{sys}\certutil.exe'), '-f -addstore Root "' + Archivo + '"', '', SW_HIDE,
    ewWaitUntilTerminated, Codigo) and (Codigo = 0);
  if not Result then
    Avisar('No se pudo instalar el certificado del servidor en Windows (certutil).');
end;

procedure PrepararEscritorio;
var
  Archivo, Texto: string;
begin
  Archivo := ExpandConstant('{app}\Escritorio\AnovoEscritorio.ini');
  if not FileExists(Archivo) then
  begin
    Texto := LeerPlantilla('AnovoEscritorio.ini');
    Reemplazar(Texto, 'URL', 'https://' + NombreServidor + ':' + Puerto(''));
    SaveStringToFile(Archivo, Texto, False);
  end;
  CertificadoEscritorio;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
    PrepararEscritorio;
end;
#endif
