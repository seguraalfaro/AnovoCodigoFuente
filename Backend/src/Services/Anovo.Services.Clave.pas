unit Anovo.Services.Clave;

// Hash y verificacion de claves con bcrypt.

interface

type
  IClaveService = interface
    ['{6C08D012-896A-45F8-8E7A-1B90C26DC065}']

    function Hashear(const AClave: string): string;
    function Verificar(const AClave, AHash: string): Boolean;
    function RequiereRehash(const AHash: string): Boolean;
  end;

  TClaveService = class(TInterfacedObject, IClaveService)
  public
    function Hashear(const AClave: string): string;
    function Verificar(const AClave, AHash: string): Boolean;
    function RequiereRehash(const AHash: string): Boolean;
  end;

const
  COSTO_BCRYPT = 12;

implementation

uses
  System.SysUtils, BCrypt, BCrypt.Types,
  Anovo.Textos;

function TClaveService.Hashear(const AClave: string): string;
begin
  if AClave.IsEmpty then
    raise Exception.Create(SClaveVaciaHash);

  Result := TBCrypt.GenerateHash(AClave, COSTO_BCRYPT, THashType.Default);
end;

function TClaveService.Verificar(const AClave, AHash: string): Boolean;
begin

  if AClave.IsEmpty or AHash.IsEmpty then
    Exit(False);

  try
    Result := TBCrypt.CompareHash(AClave, AHash);
  except
    Result := False;
  end;
end;

function TClaveService.RequiereRehash(const AHash: string): Boolean;
begin
  if AHash.IsEmpty then
    Exit(True);

  try
    Result := TBCrypt.NeedsRehash(AHash, COSTO_BCRYPT);
  except
    Result := True;
  end;
end;

end.
