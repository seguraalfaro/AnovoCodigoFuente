unit Anovo.Services.Intf.Permisos;

// Contratos de la cache y del servicio de permisos.

interface

uses
  Anovo.Repositories.Intf.Permisos;

type
  IPermisoCache = interface
    ['{5E2A9C47-1B8D-4F3A-A6E0-7D14B9C382F5}']
    function Cargada: Boolean;
    procedure Cargar(const AMatriz: TArray<TRolPermiso>);

    procedure Invalidar;

    function Tiene(const ARol, APermiso: string): Boolean;

    function PermisosDe(const ARol: string): TArray<string>;
  end;

  IPermisoService = interface
    ['{A93F1C58-6E27-4B0D-8D41-2C5E7B90F364}']
    function Tiene(const ARol, APermiso: string): Boolean;
    function PermisosDe(const ARol: string): TArray<string>;
  end;

implementation

end.
