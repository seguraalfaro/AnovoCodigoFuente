unit Anovo.Repositories.Intf.Permisos;

// Contrato del repositorio de permisos.
//
// El CRUD de ROLES_PERMISOS (otorgar es insertar, quitar es borrar) ya lo da
// IMVCRepository<TRolesPermisos>. Lo que la pantalla de Roles y permisos
// necesite de mas se agrega cuando se construya HU-09.

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

    // Todos los pares rol-permiso por codigo.
    function Matriz: TArray<TRolPermiso>;
  end;

implementation

end.
