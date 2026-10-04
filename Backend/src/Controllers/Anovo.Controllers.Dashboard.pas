unit Anovo.Controllers.Dashboard;

// Dashboards por rol bajo /api/dashboard.
// El usuario sale del token, nunca de la URL.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.Controllers.Base,
  Anovo.DTOs.Dashboard,
  Anovo.Services.Intf.Dashboard,
  Anovo.Services.Intf.Permisos,
  Anovo.Permisos;

type

  [MVCPath('/api/dashboard')]
  TDashboardController = class(TControllerBase)
  private
    function Tiene(const APermisos: IPermisoService;
      const APermiso: string): Boolean;
  public
    [MVCPath('/asesor')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_VER_APROBADAS_PROPIAS)]
    [MVCSwagSummary('Dashboard', 'Cifras del mes y ultimas solicitudes del ' +
      'asesor que consulta', 'dashboardAsesor')]
    [MVCSwagResponses(200, 'Dashboard del asesor', TDashboardAsesorDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Asesor([MVCInject] AServicio: IDashboardService): IMVCResponse;

    [MVCPath('/asistente')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_ELABORAR)]
    [MVCSwagSummary('Dashboard', 'Trabajo pendiente del asistente que ' +
      'consulta y cola de solicitudes por cotizar', 'dashboardAsistente')]
    [MVCSwagResponses(200, 'Dashboard del asistente', TDashboardAsistenteDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Asistente([MVCInject] AServicio: IDashboardService)
      : IMVCResponse;

    [MVCPath('/supervisor')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_COTIZACIONES_APROBAR)]
    [MVCSwagSummary('Dashboard', 'Cifras del mes y cola de cotizaciones ' +
      'que el supervisor que consulta puede aprobar', 'dashboardSupervisor')]
    [MVCSwagResponses(200, 'Dashboard del supervisor', TDashboardSupervisorDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Supervisor([MVCInject] AServicio: IDashboardService)
      : IMVCResponse;

    [MVCPath('/gerencia')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_REPORTES_VER)]
    [MVCSwagSummary('Dashboard', 'Cifras del mes, productividad por asesor ' +
      'y cotizaciones por estado', 'dashboardGerencia')]
    [MVCSwagResponses(200, 'Dashboard de gerencia', TDashboardGerenciaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Gerencia([MVCInject] AServicio: IDashboardService): IMVCResponse;

    [MVCPath('/cuentas')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_USUARIOS_ADMINISTRAR)]
    [MVCSwagSummary('Dashboard', 'Cifras de las cuentas de usuario y ' +
      'cambios recientes', 'dashboardCuentas')]
    [MVCSwagResponses(200, 'Dashboard del administrador', TDashboardCuentasDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Cuentas([MVCInject] AServicio: IDashboardService): IMVCResponse;

    [MVCPath('/avisos')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresAuthentication]
    [MVCSwagSummary('Dashboard', 'Contadores del menu segun los permisos ' +
      'del usuario del token', 'dashboardAvisos')]
    [MVCSwagResponses(200, 'Contadores', TAvisosDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    function Avisos([MVCInject] AServicio: IDashboardService;
      [MVCInject] APermisos: IPermisoService): IMVCResponse;
  end;

implementation

uses
  System.SysUtils;

function TDashboardController.Tiene(const APermisos: IPermisoService;
  const APermiso: string): Boolean;
begin
  Result := APermisos.TieneAlguno(UsuarioId, Roles, [APermiso]);
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

function TDashboardController.Gerencia(AServicio: IDashboardService)
  : IMVCResponse;
begin
  Result := OKResponse(AServicio.DelGerencia);
end;

function TDashboardController.Cuentas(AServicio: IDashboardService)
  : IMVCResponse;
begin
  Result := OKResponse(AServicio.DelCuentas);
end;

function TDashboardController.Avisos(AServicio: IDashboardService;
  APermisos: IPermisoService): IMVCResponse;
begin
  Result := OKResponse(AServicio.DelAvisos(UsuarioId,
    Tiene(APermisos, PERMISO_COTIZACIONES_APROBAR),
    Tiene(APermisos, PERMISO_COTIZACIONES_ELABORAR)));
end;

end.
