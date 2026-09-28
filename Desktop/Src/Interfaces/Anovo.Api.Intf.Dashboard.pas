unit Anovo.Api.Intf.Dashboard;

// Contrato de la API de dashboards.

interface

uses
  Anovo.DTOs.Dashboard;

type
  IApiDashboard = interface
    ['{EC9C986F-FB64-4831-A4ED-B429F8A6661F}']
    function Asesor: TDashboardAsesorDTO;
    function Asistente: TDashboardAsistenteDTO;
    function Supervisor: TDashboardSupervisorDTO;
    function Gerencia: TDashboardGerenciaDTO;
    function Cuentas: TDashboardCuentasDTO;
    function Avisos: TAvisosDTO;
  end;

implementation

end.
