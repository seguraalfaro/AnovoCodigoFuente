unit Anovo.Repositories.Permisos;

// Repositorio de permisos.
//
// El SQL esta en Anovo.SQL.Permisos.

interface

uses
  MVCFramework.Repository,
  Anovo.Repositories.Intf.Permisos,
  Anovo.Entities.Permisos;

type
  TPermisoRepository = class(TMVCRepository<TRolesPermisos>, IPermisoRepository)
  public
    function Matriz: TArray<TRolPermiso>;
  end;

implementation

uses
  System.Generics.Collections,
  Data.DB,
  MVCFramework.ActiveRecord,
  Anovo.SQL.Permisos;

function TPermisoRepository.Matriz: TArray<TRolPermiso>;
var
  lDatos: TDataSet;
  lLista: TList<TRolPermiso>;
  lPar: TRolPermiso;
begin
  // El dataset es nuestro: SelectDataSet no lo libera.
  lDatos := TMVCActiveRecord.SelectDataSet(PERMISOS_MATRIZ, []);
  try
    lLista := TList<TRolPermiso>.Create;
    try
      while not lDatos.Eof do
      begin
        lPar.Rol := lDatos.FieldByName('ROL').AsString;
        lPar.Permiso := lDatos.FieldByName('PERMISO').AsString;
        lLista.Add(lPar);
        lDatos.Next;
      end;
      Result := lLista.ToArray;
    finally
      lLista.Free;
    end;
  finally
    lDatos.Free;
  end;
end;

end.
