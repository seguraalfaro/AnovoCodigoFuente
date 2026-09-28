unit Anovo.Config;

// Configuracion local del escritorio: la URL del servidor y el intervalo
// de los avisos en el .ini junto al ejecutable, y la version del programa.

interface

type
  TConfig = class
  private
    class var FUrl: string;
    class function RutaIni: string;
  public
    class function UrlServidor: string;

    class function UrlGuardada: string;

    class procedure GuardarUrl(const AUrl: string);
    class function MinutosAvisos: Integer;
    class function VersionEscritorio: string;
  end;

implementation

uses
  System.SysUtils,
  System.IniFiles,
  System.Math,
  Anovo.Textos;

const
  URL_POR_DEFECTO = 'https://localhost:443';
  MINUTOS_AVISOS_POR_DEFECTO = 5;
  MINUTOS_AVISOS_MINIMO = 1;
  MINUTOS_AVISOS_MAXIMO = 60;

class function TConfig.RutaIni: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.ini');
end;

class function TConfig.UrlGuardada: string;
var
  lIni: TIniFile;
begin
  lIni := TIniFile.Create(RutaIni);
  try
    Result := lIni.ReadString('Servidor', 'Url', URL_POR_DEFECTO).Trim;
  finally
    lIni.Free;
  end;
end;

class function TConfig.UrlServidor: string;
begin
  if FUrl.IsEmpty then
  begin
    FUrl := UrlGuardada;

    if not FUrl.StartsWith('https://', True) then
      raise Exception.Create(SUrlSinHttps);
  end;
  Result := FUrl;
end;

class procedure TConfig.GuardarUrl(const AUrl: string);
var
  lIni: TIniFile;
begin
  if not AUrl.StartsWith('https://', True) then
    raise Exception.Create(SUrlSinHttps);
  lIni := TIniFile.Create(RutaIni);
  try
    lIni.WriteString('Servidor', 'Url', AUrl);
  finally
    lIni.Free;
  end;
  FUrl := AUrl;
end;

class function TConfig.MinutosAvisos: Integer;
var
  lIni: TIniFile;
begin
  lIni := TIniFile.Create(RutaIni);
  try
    Result := lIni.ReadInteger('Avisos', 'Minutos',
      MINUTOS_AVISOS_POR_DEFECTO);
  finally
    lIni.Free;
  end;
  Result := EnsureRange(Result, MINUTOS_AVISOS_MINIMO, MINUTOS_AVISOS_MAXIMO);
end;

class function TConfig.VersionEscritorio: string;
var
  lMayor, lMenor, lCompilacion: Cardinal;
begin
  if GetProductVersion(ParamStr(0), lMayor, lMenor, lCompilacion) then
    Result := Format('%d.%d.%d', [lMayor, lMenor, lCompilacion])
  else
    Result := SSinDato;
end;

end.
