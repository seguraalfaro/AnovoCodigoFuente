unit Anovo.Repositories.Intf.Permisos;

// Contrato del repositorio de permisos.

interface

uses
  MVCFramework.Repository,
  Anovo.Entities.Permisos;

type
  TRolPermiso = record
    Rol: string;
    Permiso: string;
  end;

  IPermisoRepository = interface(IMVCRepository<TRolesPermisos>)
    ['{B7E3D2A1-5C4F-4E8B-9A16-3F0D7C29E851}']

    function Matriz: TArray<TRolPermiso>;
  end;

implementation

end.
