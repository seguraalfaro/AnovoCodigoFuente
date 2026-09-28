unit Anovo.Vistas.Intf.DashboardAsistente;

// Contrato de la vista del dashboard del asistente.

interface

uses
  Anovo.DTOs.Dashboard;

type
  IVistaDashboardAsistente = interface
    ['{FD28D3F3-16BC-4EA3-8EC5-7E7AADDBB28F}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarDashboard(const ADatos: TDashboardAsistenteDTO);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
