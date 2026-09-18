unit Anovo.Services.Intf.Permisos;

// Contrato de la cache de permisos.
//
// No lee la base por su cuenta: quien la consulta y la ve vacia le pasa la
// matriz. Asi la cache no depende de ninguna conexion y puede vivir todo lo
// que vive el servidor.

interface

uses
  Anovo.Repositories.Intf.Permisos;

type
  IPermisoCache = interface
    ['{5E2A9C47-1B8D-4F3A-A6E0-7D14B9C382F5}']
    function Cargada: Boolean;
    procedure Cargar(const AMatriz: TArray<TRolPermiso>);

    // Tras otorgar o quitar un permiso. La siguiente peticion la recarga, y
    // el cambio vale de inmediato sin esperar a que venzan los tokens.
    procedure Invalidar;

    function Tiene(const ARol, APermiso: string): Boolean;

    // Para GET /api/sesion: lo que el cliente usa para armar el menu.
    function PermisosDe(const ARol: string): TArray<string>;
  end;

  // Lo que usan el handler y los controllers.
  IPermisoService = interface
    ['{A93F1C58-6E27-4B0D-8D41-2C5E7B90F364}']
    function Tiene(const ARol, APermiso: string): Boolean;
    function PermisosDe(const ARol: string): TArray<string>;
  end;

implementation

end.
