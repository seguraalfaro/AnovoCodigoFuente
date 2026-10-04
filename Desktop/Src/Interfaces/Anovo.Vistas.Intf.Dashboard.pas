unit Anovo.Vistas.Intf.Dashboard;

// Contrato de las vistas de dashboard; T es el DTO del rol.

interface

type
  IVistaDashboard<T: class> = interface
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarDashboard(const ADatos: T);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
