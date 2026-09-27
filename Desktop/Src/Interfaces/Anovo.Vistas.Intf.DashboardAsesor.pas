unit Anovo.Vistas.Intf.DashboardAsesor;

// Contrato de la vista del dashboard del asesor.

interface

uses
  Anovo.DTOs.Dashboard;

type
  IVistaDashboardAsesor = interface
    ['{E42F967E-19BD-4027-A3A5-D8FA875592CE}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarDashboard(const ADatos: TDashboardAsesorDTO);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
