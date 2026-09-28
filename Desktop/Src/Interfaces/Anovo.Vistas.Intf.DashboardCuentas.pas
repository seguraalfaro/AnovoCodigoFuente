unit Anovo.Vistas.Intf.DashboardCuentas;

// Contrato de la vista del dashboard del administrador.

interface

uses
  Anovo.DTOs.Dashboard;

type
  IVistaDashboardCuentas = interface
    ['{80456025-6157-4684-88FA-C1BD39F9EE45}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarDashboard(const ADatos: TDashboardCuentasDTO);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
