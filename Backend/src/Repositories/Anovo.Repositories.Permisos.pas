unit Anovo.Repositories.Permisos;

// Repositorio de permisos: la matriz rol-permiso.

interface

uses
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Permisos,
  Anovo.Entities.Permisos;

type
  TPermisoRepository = class(TAnovoRepository<TRolesPermisos>,
    IPermisoRepository)
  public
    function Matriz: TArray<TRolPermiso>;
  end;

implementation

uses
  System.Generics.Collections,
  Anovo.Entities.Vistas.Permisos,
  Anovo.SQL.Permisos;

function TPermisoRepository.Matriz: TArray<TRolPermiso>;
var
  lFilas: TObjectList<TRolPermisoVista>;
  I: Integer;
begin
  lFilas := SelectVista<TRolPermisoVista>(PERMISOS_MATRIZ, []);
  try
    SetLength(Result, lFilas.Count);
    for I := 0 to lFilas.Count - 1 do
    begin
      Result[I].Rol := lFilas[I].Rol;
      Result[I].Permiso := lFilas[I].Permiso;
    end;
  finally
    lFilas.Free;
  end;
end;

end.
