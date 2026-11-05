; Anovo: instalador del servidor (API, Firebird, base y túnel) y de la aplicación
; de escritorio. Instala la versión de 64 o de 32 bits según el Windows del equipo.
; Se compila con compilar.bat, que antes genera los ejecutables en compilado\.

#define Version "1.0.0"
#define Terceros AddBackslash(SourcePath) + "..\..\Instalador-terceros"
#define FbX64 "Firebird-4.0.6.3221-0-x64.exe"
#define FbX86 "Firebird-4.0.6.3221-0-Win32.exe"
#define FbZip Terceros + "\firebird\Firebird-4.0.6.3221-0-x64"
#define SslX64 Terceros + "\openssl\openssl-3.5.8-Windows-x64"
#define SslX86 Terceros + "\openssl\openssl-3.5.8-Windows-x86"
#if FileExists(Terceros + "\cloudflared\cloudflared-windows-amd64.exe") && FileExists(Terceros + "\cloudflared\cloudflared-windows-386.exe")
  #define HayCloudflared
#endif

[Setup]
AppId={{04420858-052C-4303-AE26-B4E7FE2F30AF}
AppName=Anovo
AppVersion={#Version}
AppVerName=Anovo {#Version}
AppPublisher=Anovo
DefaultDirName={sd}\Anovo
DefaultGroupName=Anovo
DisableProgramGroupPage=yes
UsePreviousAppDir=yes
PrivilegesRequired=admin
ArchitecturesAllowed=x86compatible x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
WizardStyle=modern
SetupIconFile=..\Backend\AnovoAPI_Icon1.ico
UninstallDisplayIcon={uninstallexe}
OutputDir=salida
OutputBaseFilename=Anovo-{#Version}-instalador
Compression=lzma2/max
SolidCompression=yes
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"

[Types]
Name: "completa"; Description: "Servidor y aplicación de escritorio"
Name: "servidor"; Description: "Solo el servidor"
Name: "escritorio"; Description: "Solo la aplicación de escritorio (equipos de la oficina)"
Name: "personalizada"; Description: "Personalizada"; Flags: iscustom

[Components]
Name: "servidor"; Description: "Servidor de Anovo: API, base de datos Firebird y túnel"; Types: completa servidor
Name: "escritorio"; Description: "Aplicación de escritorio"; Types: completa escritorio

[Tasks]
#ifdef HayCloudflared
Name: "tunel"; Description: "Configurar el túnel de Cloudflare para las tabletas"; Components: servidor
#endif
Name: "iconoescritorio"; Description: "Crear un acceso directo en el escritorio"; Components: escritorio

[Dirs]
Name: "{app}\Servidor\logs"; Components: servidor
Name: "{app}\Servidor\certificates"; Components: servidor
Name: "{app}\db"; Components: servidor; Flags: uninsneveruninstall
Name: "{app}\Escritorio"; Components: escritorio; Permissions: users-modify

[Files]
Source: "compilado\Win64\AnovoAPI.exe"; DestDir: "{app}\Servidor"; Components: servidor; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#SslX64}\libcrypto-3-x64.dll"; DestDir: "{app}\Servidor"; Components: servidor; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#SslX64}\libssl-3-x64.dll"; DestDir: "{app}\Servidor"; Components: servidor; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#FbZip}\fbclient.dll"; DestDir: "{app}\Servidor"; Components: servidor; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#FbZip}\msvcp140.dll"; DestDir: "{app}\Servidor"; Components: servidor; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#FbZip}\vcruntime140.dll"; DestDir: "{app}\Servidor"; Components: servidor; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#FbZip}\zlib1.dll"; DestDir: "{app}\Servidor"; Components: servidor; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "compilado\Win32\AnovoAPI.exe"; DestDir: "{app}\Servidor"; Components: servidor; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "{#SslX86}\libcrypto-3.dll"; DestDir: "{app}\Servidor"; Components: servidor; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "{#SslX86}\libssl-3.dll"; DestDir: "{app}\Servidor"; Components: servidor; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "{code:Certificado|0}"; DestDir: "{app}\Servidor\certificates"; DestName: "servidor.crt"; Components: servidor; Check: HayCertificado(0); Flags: external
Source: "{code:Certificado|1}"; DestDir: "{app}\Servidor\certificates"; DestName: "servidor.key"; Components: servidor; Check: HayCertificado(1); Flags: external
Source: "{code:Certificado|2}"; DestDir: "{app}\Servidor\certificates"; DestName: "rootCA.crt"; Components: servidor; Check: HayCertificado(2); Flags: external
#ifdef HayCloudflared
Source: "{#Terceros}\cloudflared\cloudflared-windows-amd64.exe"; DestDir: "{app}\Servidor\tunel"; DestName: "cloudflared.exe"; Tasks: tunel; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "{#Terceros}\cloudflared\cloudflared-windows-386.exe"; DestDir: "{app}\Servidor\tunel"; DestName: "cloudflared.exe"; Tasks: tunel; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "{code:ArchivoTunel}"; DestDir: "{app}\Servidor\tunel"; DestName: "credenciales.json"; Tasks: tunel; Flags: external
#endif
Source: "compilado\Win64\AnovoEscritorio.exe"; DestDir: "{app}\Escritorio"; Components: escritorio; Check: Is64BitInstallMode; Flags: ignoreversion
Source: "compilado\Win32\AnovoEscritorio.exe"; DestDir: "{app}\Escritorio"; Components: escritorio; Check: not Is64BitInstallMode; Flags: ignoreversion
Source: "..\Desktop\Src\Recursos\Marca\*"; DestDir: "{app}\Escritorio\Recursos\Marca"; Components: escritorio; Flags: ignoreversion
Source: "{code:Certificado|2}"; DestDir: "{app}\Escritorio\certificados"; DestName: "anovo-ca.crt"; Components: escritorio; Check: HayCertificado(2); Flags: external
Source: "plantillas\*"; Flags: dontcopy
Source: "base\anovo_produccion.fbk"; Flags: dontcopy
Source: "{#Terceros}\firebird\{#FbX64}"; Flags: dontcopy
Source: "{#Terceros}\firebird\{#FbX86}"; Flags: dontcopy

[Icons]
Name: "{commonstartup}\Servidor Anovo"; Filename: "{app}\Servidor\AnovoAPI.exe"; WorkingDir: "{app}\Servidor"; Components: servidor
Name: "{group}\Servidor Anovo"; Filename: "{app}\Servidor\AnovoAPI.exe"; WorkingDir: "{app}\Servidor"; Components: servidor
Name: "{group}\Anovo"; Filename: "{app}\Escritorio\AnovoEscritorio.exe"; WorkingDir: "{app}\Escritorio"; Components: escritorio
Name: "{autodesktop}\Anovo"; Filename: "{app}\Escritorio\AnovoEscritorio.exe"; WorkingDir: "{app}\Escritorio"; Tasks: iconoescritorio

[Run]
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Anovo API"""; Components: servidor; Flags: runhidden
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall add rule name=""Anovo API"" dir=in action=allow protocol=TCP localport={code:Puerto} profile=private,domain"; Components: servidor; StatusMsg: "Abriendo el puerto del servidor en el firewall..."; Flags: runhidden
Filename: "{sys}\certutil.exe"; Parameters: "-f -addstore Root ""{app}\Escritorio\certificados\anovo-ca.crt"""; Components: escritorio; Check: HayCaEscritorio; StatusMsg: "Instalando la CA de Anovo en Windows..."; Flags: runhidden
Filename: "{app}\Servidor\AnovoAPI.exe"; WorkingDir: "{app}\Servidor"; Description: "Abrir el servidor para registrar al administrador y los datos de la empresa"; Components: servidor; Flags: postinstall nowait skipifsilent
Filename: "{app}\Escritorio\AnovoEscritorio.exe"; WorkingDir: "{app}\Escritorio"; Description: "Abrir la aplicación de escritorio"; Components: escritorio and not servidor; Flags: postinstall nowait skipifsilent unchecked

[UninstallRun]
Filename: "{sys}\netsh.exe"; Parameters: "advfirewall firewall delete rule name=""Anovo API"""; Components: servidor; RunOnceId: "ReglaFirewall"; Flags: runhidden

[Code]
const
  CLAVE_FIREBIRD = 'SOFTWARE\Firebird Project\Firebird Server\Instances';
  SERVICIO_FIREBIRD = 'FirebirdServerDefaultInstance';

var
  PaginaRed: TInputQueryWizardPage;
  PaginaSysdba: TInputQueryWizardPage;
  PaginaCotizacion: TInputQueryWizardPage;
  PaginaCertificados: TInputFileWizardPage;
  PaginaTunel: TInputFileWizardPage;
  PaginaHost: TInputQueryWizardPage;
  FirebirdPrevio: string;

function SetEnvironmentVariable(lpName, lpValue: string): BOOL;
  external 'SetEnvironmentVariableW@kernel32.dll stdcall';

function TareaTunel: Boolean;
begin
#ifdef HayCloudflared
  Result := WizardIsTaskSelected('tunel');
#else
  Result := False;
#endif
end;

function BuscarFirebird: string;
begin
  Result := '';
  if IsWin64 and RegQueryStringValue(HKLM64, CLAVE_FIREBIRD, 'DefaultInstance', Result) and (Result <> '') then
    Exit;
  if RegQueryStringValue(HKLM32, CLAVE_FIREBIRD, 'DefaultInstance', Result) and (Result <> '') then
    Exit;
  Result := '';
end;

function RutaServidor: string;
begin
  Result := ExpandConstant('{app}\Servidor\');
end;

function RutaBase: string;
begin
  Result := ExpandConstant('{app}\db\ANOVO.FDB');
end;

function Dsn: string;
begin
  Result := '127.0.0.1:' + RutaBase;
end;

function Puerto(Param: string): string;
begin
  Result := Trim(PaginaRed.Values[1]);
end;

function NombreServidor: string;
begin
  Result := Trim(PaginaRed.Values[0]);
end;

function Certificado(Param: string): string;
begin
  Result := Trim(PaginaCertificados.Values[StrToInt(Param)]);
end;

function HayCertificado(Indice: Integer): Boolean;
begin
  Result := Trim(PaginaCertificados.Values[Indice]) <> '';
end;

function HayCaEscritorio: Boolean;
begin
  Result := FileExists(ExpandConstant('{app}\Escritorio\certificados\anovo-ca.crt'));
end;

function ArchivoTunel(Param: string): string;
begin
  Result := Trim(PaginaTunel.Values[0]);
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

  PaginaRed := CreateInputQueryPage(wpSelectTasks, 'Servidor de Anovo',
    'Nombre y puerto con que los equipos de la oficina llegan al servidor.',
    'El nombre tiene que figurar en el certificado del servidor. En el equipo del servidor se deja el nombre del propio equipo.');
  PaginaRed.Add('Nombre o dirección IP del servidor:', False);
  PaginaRed.Add('Puerto HTTPS:', False);
  PaginaRed.Values[0] := GetPreviousData('Servidor', Lowercase(GetComputerNameString));
  PaginaRed.Values[1] := GetPreviousData('Puerto', '443');

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

  PaginaCertificados := CreateInputFilePage(PaginaCotizacion.ID, 'Certificados',
    'Archivos del certificado HTTPS emitidos con la CA de Anovo.',
    'El certificado y la llave del servidor solo se piden al instalar el servidor. La llave de la CA nunca se copia a este equipo. Si el equipo ya tiene los archivos, puede dejar el campo vacío.');
  PaginaCertificados.Add('Certificado del servidor (.crt):', 'Certificados (*.crt;*.pem)|*.crt;*.pem|Todos los archivos|*.*', '.crt');
  PaginaCertificados.Add('Llave privada del servidor (.key):', 'Llaves (*.key;*.pem)|*.key;*.pem|Todos los archivos|*.*', '.key');
  PaginaCertificados.Add('Certificado de la CA de Anovo (rootCA.crt):', 'Certificados (*.crt;*.pem)|*.crt;*.pem|Todos los archivos|*.*', '.crt');

  PaginaTunel := CreateInputFilePage(PaginaCertificados.ID, 'Túnel de Cloudflare',
    'Credenciales del túnel por el que entran las tabletas.',
    'Es el archivo .json que crea «cloudflared tunnel create» para el túnel de Anovo.');
  PaginaTunel.Add('Credenciales del túnel (.json):', 'Credenciales (*.json)|*.json', '.json');

  PaginaHost := CreateInputQueryPage(PaginaTunel.ID, 'Túnel de Cloudflare',
    'Nombre público de la API.',
    'Es la dirección que usan las tabletas para llegar al servidor por el túnel.');
  PaginaHost.Add('Nombre público:', False);
  PaginaHost.Values[0] := GetPreviousData('Host', 'api.anovoms.com');
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  SetPreviousData(PreviousDataKey, 'Servidor', NombreServidor);
  SetPreviousData(PreviousDataKey, 'Puerto', Puerto(''));
  SetPreviousData(PreviousDataKey, 'Host', Trim(PaginaHost.Values[0]));
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := False;
  if PageID = PaginaSysdba.ID then
    Result := not WizardIsComponentSelected('servidor')
  else if PageID = PaginaCotizacion.ID then
    Result := (not WizardIsComponentSelected('servidor')) or FileExists(RutaBase)
  else if (PageID = PaginaTunel.ID) or (PageID = PaginaHost.ID) then
    Result := not TareaTunel;
end;

function Falta(const Mensaje: string): Boolean;
begin
  MsgBox(Mensaje, mbError, MB_OK);
  Result := False;
end;

function CertificadoListo(Indice: Integer; const Destino, Nombre: string): Boolean;
var
  Archivo: string;
begin
  Archivo := Trim(PaginaCertificados.Values[Indice]);
  if Archivo = '' then
    Result := FileExists(Destino) or Falta('Falta ' + Nombre + '.')
  else
    Result := FileExists(Archivo) or Falta('No se encontró el archivo ' + Archivo + '.');
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  Numero: Integer;
  Certificados: string;
begin
  Result := True;
  if CurPageID = PaginaRed.ID then
  begin
    Numero := StrToIntDef(Puerto(''), 0);
    if NombreServidor = '' then
      Result := Falta('Escriba el nombre o la dirección IP del servidor.')
    else if (Numero < 1) or (Numero > 65535) then
      Result := Falta('El puerto tiene que ser un número entre 1 y 65535.');
  end
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
  end
  else if CurPageID = PaginaCertificados.ID then
  begin
    Certificados := RutaServidor + 'certificates\';
    if WizardIsComponentSelected('servidor') then
      Result := CertificadoListo(0, Certificados + 'servidor.crt', 'el certificado del servidor') and
        CertificadoListo(1, Certificados + 'servidor.key', 'la llave privada del servidor') and
        CertificadoListo(2, Certificados + 'rootCA.crt', 'el certificado de la CA de Anovo');
    if Result and WizardIsComponentSelected('escritorio') then
      Result := CertificadoListo(2, ExpandConstant('{app}\Escritorio\certificados\anovo-ca.crt'),
        'el certificado de la CA de Anovo');
  end
  else if CurPageID = PaginaTunel.ID then
  begin
    if not FileExists(ArchivoTunel('')) then
      Result := Falta('Seleccione el archivo de credenciales del túnel.')
    else if LeerTunelId(ArchivoTunel('')) = '' then
      Result := Falta('El archivo no tiene el identificador del túnel (TunnelID).');
  end
  else if CurPageID = PaginaHost.ID then
  begin
    if Trim(PaginaHost.Values[0]) = '' then
      Result := Falta('Escriba el nombre público de la API.');
  end;
end;

procedure Avisar(const Mensaje: string);
begin
  SuppressibleMsgBox(Mensaje, mbError, MB_OK, IDOK);
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
  Codigo: Integer;
begin
  Archivo := ExpandConstant('{tmp}\aleatorio.txt');
  Exec(ExpandConstant('{sys}\WindowsPowerShell\v1.0\powershell.exe'),
    '-NoProfile -NonInteractive -Command "$b = New-Object byte[] ' + IntToStr(Bytes) +
    '; [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($b); ' +
    'Set-Content -Encoding Ascii -NoNewline -Path ''' + Archivo + ''' -Value (-join ($b | ForEach-Object { $_.ToString(''x2'') }))"',
    '', SW_HIDE, ewWaitUntilTerminated, Codigo);
  Result := '';
  if LoadStringFromFile(Archivo, Texto) then
    Result := Trim(String(Texto));
  DeleteFile(Archivo);
  if Length(Result) <> Bytes * 2 then
    RaiseException('No se pudo generar una clave aleatoria.');
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
  Reemplazar(Texto, 'HOST', Trim(PaginaHost.Values[0]));
  Reemplazar(Texto, 'PUERTO', Puerto(''));
  Reemplazar(Texto, 'SERVIDOR', NombreServidor);
  Reemplazar(Texto, 'CA', RutaServidor + 'certificates\rootCA.crt');
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
  if not Lista then
    Exit;

  if not FileExists(RutaServidor + '.env') then
    EscribirEnv;
  if TareaTunel then
    EscribirTunel;
end;

procedure PrepararEscritorio;
var
  Archivo, Texto: string;
begin
  Archivo := ExpandConstant('{app}\Escritorio\AnovoEscritorio.ini');
  if FileExists(Archivo) then
    Exit;
  Texto := LeerPlantilla('AnovoEscritorio.ini');
  Reemplazar(Texto, 'URL', 'https://' + NombreServidor + ':' + Puerto(''));
  SaveStringToFile(Archivo, Texto, False);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep <> ssPostInstall then
    Exit;
  if WizardIsComponentSelected('servidor') then
    PrepararServidor;
  if WizardIsComponentSelected('escritorio') then
    PrepararEscritorio;
end;
