unit Anovo.Repositories.Permisos;

// Repositorios de permisos: la matriz rol-permiso, de V_PERMISOS_ROLES,
// y el catalogo de PERMISOS.

interface

uses
  System.Generics.Collections,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Permisos,
  Anovo.Entities.Permisos,
  Anovo.Entities.Consultas;

type
  TPermisoRepository = class(TAnovoRepository<TRolesPermisos>,
    IPermisoRepository)
  public
    function Matriz: TArray<TRolPermiso>;
    function Excepciones: TArray<TExcepcionPermiso>;
  end;

  TPermisoCatalogoRepository = class(TAnovoRepository<TPermisos>,
    IPermisoCatalogoRepository)
  public
    function Catalogo: TObjectList<TCatalogoPermisos>;
  end;

implementation

function TPermisoCatalogoRepository.Catalogo: TObjectList<TCatalogoPermisos>;
begin
  Result := ListarConsulta<TCatalogoPermisos>(CONSULTA_ORDENADAS, [],
    SIN_LIMITE);
end;

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

function TPermisoRepository.Excepciones: TArray<TExcepcionPermiso>;
var
  lFilas: TObjectList<TExcepcionesDePermisos>;
  I: Integer;
begin
  lFilas := ListarConsulta<TExcepcionesDePermisos>(CONSULTA_ORDENADAS, [],
    SIN_LIMITE);
  try
    SetLength(Result, lFilas.Count);
    for I := 0 to lFilas.Count - 1 do
    begin
      Result[I].UsuarioId := lFilas[I].UsuarioId.ValueOrDefault;
      Result[I].Permiso := lFilas[I].Permiso.ValueOrDefault;
      Result[I].Otorgado := lFilas[I].Tipo.ValueOrDefault = TIPO_OTORGADO;
    end;
  finally
    lFilas.Free;
  end;
end;

end.
