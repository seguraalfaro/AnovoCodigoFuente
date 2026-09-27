unit Anovo.Controllers.Dashboard;

// Dashboards por rol bajo /api/dashboard.
// El usuario sale del token, nunca de la URL.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.DTOs.Dashboard,
  Anovo.Services.Intf.Dashboard;

const
  PERMISO_DASHBOARD_ASESOR = 'cotizaciones.ver_aprobadas_propias';
  PERMISO_DASHBOARD_ASISTENTE = 'cotizaciones.elaborar';
  PERMISO_DASHBOARD_SUPERVISOR = 'cotizaciones.aprobar';

type

  [MVCPath('/api/dashboard')]
  TDashboardController = class(TMVCController)
  private
    function UsuarioId: Integer;
  public
    [MVCPath('/asesor')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_DASHBOARD_ASESOR)]
    [MVCSwagSummary('Dashboard', 'Cifras del mes y ultimas solicitudes del ' +
      'asesor que consulta', 'dashboardAsesor')]
    [MVCSwagResponses(200, 'Dashboard del asesor', TDashboardAsesorDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Asesor([MVCInject] AServicio: IDashboardService): IMVCResponse;

    [MVCPath('/asistente')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_DASHBOARD_ASISTENTE)]
    [MVCSwagSummary('Dashboard', 'Trabajo pendiente del asistente que ' +
      'consulta y cola de solicitudes por cotizar', 'dashboardAsistente')]
    [MVCSwagResponses(200, 'Dashboard del asistente', TDashboardAsistenteDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Asistente([MVCInject] AServicio: IDashboardService)
      : IMVCResponse;

    [MVCPath('/supervisor')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_DASHBOARD_SUPERVISOR)]
    [MVCSwagSummary('Dashboard', 'Cifras del mes y cola de cotizaciones ' +
      'que el supervisor que consulta puede aprobar', 'dashboardSupervisor')]
    [MVCSwagResponses(200, 'Dashboard del supervisor', TDashboardSupervisorDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Supervisor([MVCInject] AServicio: IDashboardService)
      : IMVCResponse;
  end;

implementation

uses
  System.SysUtils;

function TDashboardController.UsuarioId: Integer;
var
  lTexto: string;
begin
  lTexto := '';
  if Assigned(Context.LoggedUser.CustomData) then
    Context.LoggedUser.CustomData.TryGetValue('USUARIO_ID', lTexto);
  if not TryStrToInt(lTexto, Result) then
    Result := 0;
end;

function TDashboardController.Asesor(AServicio: IDashboardService)
  : IMVCResponse;
begin
  Result := OKResponse(AServicio.DelAsesor(UsuarioId));
end;

function TDashboardController.Asistente(AServicio: IDashboardService)
  : IMVCResponse;
begin
  Result := OKResponse(AServicio.DelAsistente(UsuarioId));
end;

function TDashboardController.Supervisor(AServicio: IDashboardService)
  : IMVCResponse;
begin
  Result := OKResponse(AServicio.DelSupervisor(UsuarioId));
end;

end.
