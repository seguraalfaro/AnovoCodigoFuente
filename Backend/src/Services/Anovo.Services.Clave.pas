unit Anovo.Services.Clave;

// HASH DE CONTRASENAS
//
// bcrypt sobre la libreria de F:\Componetes de terceros\bcrypt-master\src.
// 

interface

type
  // REGENERAR EL GUID
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
  // 12 tarda unos 250 ms por verificacion 
  COSTO_BCRYPT = 12;

implementation

uses
  System.SysUtils, BCrypt, BCrypt.Types;

function TClaveService.Hashear(const AClave: string): string;
begin
  if AClave.IsEmpty then
    raise Exception.Create('No se puede hashear una clave vacia');

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

//esto queda or si mas adelante se decide cambiar el costo actualizarlo.
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
