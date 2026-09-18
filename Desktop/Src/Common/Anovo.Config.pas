unit Anovo.Config;

{ Datos de conexion, leidos de un .ini junto al ejecutable. Nada cableado: la
  URL de desarrollo no es la del servidor de Anovo.

  El archivo se llama igual que el ejecutable:

    [Servidor]
    Url=https://localhost:443 }

interface

type
  TConfig = class
  private
    class var FUrl: string;
  public
    class function UrlServidor: string;
  end;

implementation

uses
  System.SysUtils,
  System.IniFiles;

const
  URL_POR_DEFECTO = 'https://localhost:443';

class function TConfig.UrlServidor: string;
var
  lIni: TIniFile;
begin
  if FUrl.IsEmpty then
  begin
    lIni := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
    try
      FUrl := lIni.ReadString('Servidor', 'Url', URL_POR_DEFECTO).Trim;
    finally
      lIni.Free;
    end;
    { Por http:// el token y la clave viajarian en claro. }
    if not FUrl.StartsWith('https://', True) then
      raise Exception.Create('La URL del servidor debe empezar por https://');
  end;
  Result := FUrl;
end;

end.
