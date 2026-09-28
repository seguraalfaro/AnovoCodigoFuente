unit Anovo.Vistas.Intf.DashboardSupervisor;

// Contrato de la vista del dashboard del supervisor.

interface

uses
  Anovo.DTOs.Dashboard;

type
  IVistaDashboardSupervisor = interface
    ['{F668E7FD-FDC5-440D-9A16-2338DE13E314}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarDashboard(const ADatos: TDashboardSupervisorDTO);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
