unit Anovo.Repositories.Usuarios;

// Repositorios de usuarios y de sus claves.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Entities.Usuarios;

type
  TUsuarioRepository = class(TAnovoRepository<TUsuarios>, IUsuarioRepository)
  public
    function NombresDe(const AIds: TArray<Integer>)
      : TDictionary<Integer, string>;
  end;

  TUsuarioClaveRepository = class(TAnovoRepository<TUsuariosClaves>,
    IUsuarioClaveRepository)
  public
    function ClaveActivaDe(const AUsuarioId: Integer): TUsuariosClaves;
  end;

implementation

uses
  System.SysUtils,
  Anovo.SQL.Usuarios;

function TUsuarioRepository.NombresDe(const AIds: TArray<Integer>)
  : TDictionary<Integer, string>;
var
  lEntidades: TObjectList<TUsuarios>;
  lUsuario: TUsuarios;
  lLista: string;
  lId: Integer;
begin
  Result := TDictionary<Integer, string>.Create;
  if Length(AIds) = 0 then
    Exit;

  lLista := '';
  for lId in AIds do
  begin
    if lLista <> '' then
      lLista := lLista + ',';
    lLista := lLista + IntToStr(lId);
  end;

  try
    lEntidades := GetWhere(Format(USUARIOS_POR_IDS, [lLista]), []);
    try
      for lUsuario in lEntidades do
        Result.AddOrSetValue(lUsuario.ID, lUsuario.Nombre);
    finally
      lEntidades.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TUsuarioClaveRepository.ClaveActivaDe(const AUsuarioId: Integer)
  : TUsuariosClaves;
begin
  Result := GetOneByWhere(USUARIO_CLAVE_ACTIVA, [AUsuarioId], False);
end;

end.
