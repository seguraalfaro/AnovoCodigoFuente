unit Anovo.Repositories.Intf.Permisos;

// Contrato del repositorio de permisos.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Permisos,
  Anovo.Entities.Consultas;

const
  TIPO_OTORGADO = 'otorgado';
  TIPO_QUITADO = 'quitado';

type
  TRolPermiso = record
    Rol: string;
    Permiso: string;
  end;

  TExcepcionPermiso = record
    UsuarioId: Integer;
    Permiso: string;
    Otorgado: Boolean;
  end;

  IPermisoRepository = interface(IMVCRepository<TRolesPermisos>)
    ['{B7E3D2A1-5C4F-4E8B-9A16-3F0D7C29E851}']

    function Matriz: TArray<TRolPermiso>;
    function Excepciones: TArray<TExcepcionPermiso>;
    function Asignacion(const ARolId, APermisoId: Integer): TRolesPermisos;
    function Asignado(const ARolId, APermisoId: Integer): Boolean;
  end;

  IPermisoCatalogoRepository = interface(IMVCRepository<TPermisos>)
    ['{544E293B-EA1E-433E-8403-EFE332186997}']
    function Catalogo: TObjectList<TCatalogoPermisos>;
  end;

implementation

end.
