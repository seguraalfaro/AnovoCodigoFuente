unit Anovo.Tunel.Config;

// Configuracion del tunel de Cloudflare leida del .env: ejecutable de
// cloudflared, archivo de configuracion, nombre del tunel y arranque.

interface

type
  TConfigTunel = record
    Exe: string;
    ArchivoConfig: string;
    Nombre: string;
    Automatico: Boolean;
    function Configurado: Boolean;
    function Parametros: string;
    function Descripcion: string;
    class function Leer: TConfigTunel; static;
    class function ConfigPorDefecto: string; static;
  end;

const
  CLAVE_TUNEL_EXE = 'anovo.tunel.exe';
  CLAVE_TUNEL_CONFIG = 'anovo.tunel.config';
  CLAVE_TUNEL_NOMBRE = 'anovo.tunel.nombre';
  CLAVE_TUNEL_AUTOMATICO = 'anovo.tunel.automatico';

implementation

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  MVCFramework.Commons;

const
  EXE_POR_DEFECTO = 'C:\Program Files (x86)\cloudflared\cloudflared.exe';
  CARPETA_CLOUDFLARED = '.cloudflared';
  ARCHIVO_CONFIG = 'config.yml';
  CLAVE_YML_TUNEL = 'tunnel:';
  CLAVE_YML_HOST = 'hostname:';
  CLAVE_YML_SERVICIO = 'service:';

class function TConfigTunel.ConfigPorDefecto: string;
begin
  Result := TPath.Combine(TPath.Combine(GetEnvironmentVariable('USERPROFILE'),
    CARPETA_CLOUDFLARED), ARCHIVO_CONFIG);
end;

class function TConfigTunel.Leer: TConfigTunel;
begin
  Result := Default(TConfigTunel);
  Result.Exe := dotEnv.Env(CLAVE_TUNEL_EXE, EXE_POR_DEFECTO).Trim;
  Result.ArchivoConfig := dotEnv.Env(CLAVE_TUNEL_CONFIG, '').Trim;
  Result.Nombre := dotEnv.Env(CLAVE_TUNEL_NOMBRE, '').Trim;
  Result.Automatico := dotEnv.Env(CLAVE_TUNEL_AUTOMATICO, False);
end;

function TConfigTunel.Configurado: Boolean;
var
  lConfig: string;
begin
  lConfig := ArchivoConfig;
  if lConfig.IsEmpty then
    lConfig := ConfigPorDefecto;
  Result := FileExists(Exe) and FileExists(lConfig);
end;

function TConfigTunel.Parametros: string;
begin
  Result := 'tunnel --no-autoupdate';
  if not ArchivoConfig.IsEmpty then
    Result := Result + ' --config "' + ArchivoConfig + '"';
  Result := Result + ' run';
  if not Nombre.IsEmpty then
    Result := Result + ' ' + Nombre;
end;

function ValorYml(ALineas: TStrings; const AClave: string): string;
var
  lLinea: string;
begin
  for lLinea in ALineas do
    if lLinea.Trim.TrimLeft(['-', ' ']).StartsWith(AClave) then
      Exit(lLinea.Trim.TrimLeft(['-', ' ']).Substring(AClave.Length).Trim);
  Result := '';
end;

function TConfigTunel.Descripcion: string;
var
  lArchivo, lTunel, lHost, lServicio: string;
  lLineas: TStringList;
begin
  lArchivo := ArchivoConfig;
  if lArchivo.IsEmpty then
    lArchivo := ConfigPorDefecto;
  if not FileExists(lArchivo) then
    Exit('');
  lLineas := TStringList.Create;
  try
    lLineas.LoadFromFile(lArchivo);
    lTunel := ValorYml(lLineas, CLAVE_YML_TUNEL);
    lHost := ValorYml(lLineas, CLAVE_YML_HOST);
    lServicio := ValorYml(lLineas, CLAVE_YML_SERVICIO);
  finally
    lLineas.Free;
  end;
  if not Nombre.IsEmpty then
    lTunel := Nombre;
  Result := 'cloudflared   ' + #$00B7 + '   t' + #$00FA + 'nel ' + lTunel;
  if not lHost.IsEmpty then
    Result := Result + '   ' + #$00B7 + '   ' + lHost + ' ' + #$2192 + ' ' +
      lServicio;
end;

end.
