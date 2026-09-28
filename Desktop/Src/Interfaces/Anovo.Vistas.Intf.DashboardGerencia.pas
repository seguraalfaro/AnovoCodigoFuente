unit Anovo.Vistas.Intf.DashboardGerencia;

// Contrato de la vista del dashboard de gerencia.

interface

uses
  Anovo.DTOs.Dashboard;

type
  IVistaDashboardGerencia = interface
    ['{3E0CEB37-B030-46F2-B400-AEAD0450CA7E}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarDashboard(const ADatos: TDashboardGerenciaDTO);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
