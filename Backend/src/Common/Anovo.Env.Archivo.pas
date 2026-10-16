unit Anovo.Env.Archivo;

// Escribe claves en el .env junto al ejecutable sin tocar el resto de las
// lineas, y recarga dotEnv para que el servidor lea los valores nuevos.

interface

uses
  System.Generics.Collections;

type
  TValorEnv = TPair<string, string>;

  TArchivoEnv = class
  public
    class function Ruta: string; static;
    class procedure Guardar(const AValores: TArray<TValorEnv>); static;
  end;

function ValorEnv(const AClave, AValor: string): TValorEnv;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  MVCFramework.Commons;

const
  ARCHIVO_ENV = '.env';
  ENCABEZADO = '# Anovo: configuracion guardada desde la ventana del servidor';

function ValorEnv(const AClave, AValor: string): TValorEnv;
begin
  Result := TValorEnv.Create(AClave, AValor);
end;

class function TArchivoEnv.Ruta: string;
begin
  Result := TPath.Combine(AppPath, ARCHIVO_ENV);
end;

function ClaveDeLinea(const ALinea: string): string;
var
  lPos: Integer;
begin
  Result := '';
  if ALinea.Trim.StartsWith('#') then
    Exit;
  lPos := ALinea.IndexOf('=');
  if lPos > 0 then
    Result := ALinea.Substring(0, lPos).Trim;
end;

function LineaDe(const AValor: TValorEnv): string;
var
  lValor: string;
begin
  lValor := AValor.Value.Trim.Replace('"', '''', [rfReplaceAll]);
  if (lValor.IndexOfAny([' ', '#', '''', '$']) >= 0) then
    lValor := '"' + lValor + '"';
  Result := AValor.Key + '=' + lValor;
end;

class procedure TArchivoEnv.Guardar(const AValores: TArray<TValorEnv>);
var
  lLineas: TStringList;
  lValor: TValorEnv;
  lHecho: Boolean;
  lEncabezado: Boolean;
  I: Integer;
begin
  lLineas := TStringList.Create;
  try
    if FileExists(Ruta) then
      lLineas.LoadFromFile(Ruta, TEncoding.UTF8);
    lEncabezado := lLineas.IndexOf(ENCABEZADO) >= 0;
    for lValor in AValores do
    begin
      lHecho := False;
      for I := 0 to lLineas.Count - 1 do
        if SameText(ClaveDeLinea(lLineas[I]), lValor.Key) then
        begin
          lLineas[I] := LineaDe(lValor);
          lHecho := True;
          Break;
        end;
      if lHecho then
        Continue;
      if not lEncabezado then
      begin
        lLineas.Add('');
        lLineas.Add(ENCABEZADO);
        lEncabezado := True;
      end;
      lLineas.Add(LineaDe(lValor));
    end;
    lLineas.WriteBOM := True;
    lLineas.SaveToFile(Ruta, TEncoding.UTF8);
  finally
    lLineas.Free;
  end;
  dotEnv.Rebuild;
end;

end.
