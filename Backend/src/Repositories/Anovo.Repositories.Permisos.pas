unit Anovo.Repositories.Permisos;

// Repositorio de permisos: la matriz rol-permiso, de V_PERMISOS_ROLES.

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
  Anovo.Entities.Consultas;

function TPermisoRepository.Matriz: TArray<TRolPermiso>;
var
  lFilas: TObjectList<TPermisosDeRoles>;
  I: Integer;
begin
  lFilas := ListarConsulta<TPermisosDeRoles>(CONSULTA_ORDENADAS, [],
    SIN_LIMITE);
  try
    SetLength(Result, lFilas.Count);
    for I := 0 to lFilas.Count - 1 do
    begin
      Result[I].Rol := lFilas[I].Rol.ValueOrDefault;
      Result[I].Permiso := lFilas[I].Permiso.ValueOrDefault;
    end;
  finally
    lFilas.Free;
  end;
end;

end.
