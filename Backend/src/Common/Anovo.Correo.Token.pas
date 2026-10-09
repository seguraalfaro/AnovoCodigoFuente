unit Anovo.Correo.Token;

// Guarda el refresh token de OAuth2 cifrado con DPAPI de Windows: solo la
// misma cuenta de Windows, en la misma maquina, puede leerlo.

interface

type
  TTokenCorreo = class
  public
    class procedure Guardar(const ARuta, AToken: string); static;
    class function Leer(const ARuta: string): string; static;
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.IOUtils;

type
  TDataBlob = record
    cbData: DWORD;
    pbData: PByte;
  end;

  PDataBlob = ^TDataBlob;

const
  CRYPTPROTECT_UI_FORBIDDEN = $1;
  ENTROPIA = 'Anovo.Correo.OAuth2';

function CryptProtectData(pDataIn: PDataBlob; szDataDescr: PWideChar;
  pOptionalEntropy: PDataBlob; pvReserved: Pointer; pPromptStruct: Pointer;
  dwFlags: DWORD; pDataOut: PDataBlob): BOOL; stdcall;
  external 'crypt32.dll' name 'CryptProtectData';

function CryptUnprotectData(pDataIn: PDataBlob; ppszDataDescr: PPWideChar;
  pOptionalEntropy: PDataBlob; pvReserved: Pointer; pPromptStruct: Pointer;
  dwFlags: DWORD; pDataOut: PDataBlob): BOOL; stdcall;
  external 'crypt32.dll' name 'CryptUnprotectData';

function Blob(const ABytes: TBytes): TDataBlob;
begin
  Result.cbData := Length(ABytes);
  if Result.cbData = 0 then
    Result.pbData := nil
  else
    Result.pbData := @ABytes[0];
end;

class procedure TTokenCorreo.Guardar(const ARuta, AToken: string);
var
  lPlano, lEntropia, lCifrado: TBytes;
  lEntrada, lClave, lSalida: TDataBlob;
begin
  lPlano := TEncoding.UTF8.GetBytes(AToken);
  lEntropia := TEncoding.UTF8.GetBytes(ENTROPIA);
  lEntrada := Blob(lPlano);
  lClave := Blob(lEntropia);
  if not CryptProtectData(@lEntrada, nil, @lClave, nil, nil,
    CRYPTPROTECT_UI_FORBIDDEN, @lSalida) then
    RaiseLastOSError;
  try
    SetLength(lCifrado, lSalida.cbData);
    Move(lSalida.pbData^, lCifrado[0], lSalida.cbData);
  finally
    LocalFree(HLOCAL(lSalida.pbData));
  end;
  TFile.WriteAllBytes(ARuta, lCifrado);
end;

class function TTokenCorreo.Leer(const ARuta: string): string;
var
  lCifrado, lEntropia, lPlano: TBytes;
  lEntrada, lClave, lSalida: TDataBlob;
begin
  Result := '';
  if not FileExists(ARuta) then
    Exit;
  lCifrado := TFile.ReadAllBytes(ARuta);
  lEntropia := TEncoding.UTF8.GetBytes(ENTROPIA);
  lEntrada := Blob(lCifrado);
  lClave := Blob(lEntropia);
  if not CryptUnprotectData(@lEntrada, nil, @lClave, nil, nil,
    CRYPTPROTECT_UI_FORBIDDEN, @lSalida) then
    Exit;
  try
    SetLength(lPlano, lSalida.cbData);
    if lSalida.cbData > 0 then
      Move(lSalida.pbData^, lPlano[0], lSalida.cbData);
  finally
    LocalFree(HLOCAL(lSalida.pbData));
  end;
  Result := TEncoding.UTF8.GetString(lPlano);
end;

end.
