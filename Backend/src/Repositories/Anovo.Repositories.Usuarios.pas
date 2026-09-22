unit Anovo.Repositories.Usuarios;

// Repositorio de usuarios.
//
// Por ahora solo resuelve nombres para la bitacora. El CRUD lo hereda de
// TMVCRepository<TUsuarios> y no hay nada escrito a mano.

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

implementation

uses
  System.SysUtils,
  Anovo.SQL.Usuarios;

{ TUsuarioRepository }

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

  // La lista va armada y no por parametros: son numeros que salieron de la
  // propia base, no texto de nadie, y un IN con parametros obliga a armar
  // tantos ? como ids traiga la pagina.
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

end.
