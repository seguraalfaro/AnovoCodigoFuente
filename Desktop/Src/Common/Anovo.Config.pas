unit Anovo.Config;

// Configuracion local del escritorio: la URL del servidor en el .ini
// junto al ejecutable y la version del programa.

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
    class function VersionEscritorio: string;
  end;

implementation

uses
  System.SysUtils,
  System.IniFiles,
  Anovo.Textos;

const
  URL_POR_DEFECTO = 'https://localhost:443';

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
