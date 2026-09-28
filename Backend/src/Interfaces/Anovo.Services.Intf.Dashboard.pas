unit Anovo.Services.Intf.Dashboard;

// Contrato del servicio de dashboards.

interface

uses
  Anovo.DTOs.Dashboard;

type
  IDashboardService = interface
    ['{6F430C69-6CB2-491D-9DAC-F3238AEFCF16}']
    function DelAsesor(const AAsesorId: Integer): TDashboardAsesorDTO;
    function DelAsistente(const AUsuarioId: Integer): TDashboardAsistenteDTO;
    function DelSupervisor(const AUsuarioId: Integer)
      : TDashboardSupervisorDTO;
    function DelGerencia: TDashboardGerenciaDTO;
    function DelCuentas: TDashboardCuentasDTO;
    function DelAvisos(const AUsuarioId: Integer;
      const APuedeAprobar, APuedeElaborar: Boolean): TAvisosDTO;
  end;

implementation

end.
