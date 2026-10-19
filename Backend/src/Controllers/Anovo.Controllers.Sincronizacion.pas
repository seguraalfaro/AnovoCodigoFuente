unit Anovo.Controllers.Sincronizacion;

// Sincronizacion bajo /api/sincronizacion: lo que baja al movil desde la
// ultima vez. Sin fecha baja todo lo activo.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.Controllers.Base,
  Anovo.DTOs.Sincronizacion,
  Anovo.Services.Intf.Sincronizacion,
  Anovo.Permisos;

type
  [MVCPath('/api/sincronizacion')]
  [MVCRequiresPermiso(PERMISO_ACCESO_MOVIL)]
  [MVCRequiresPermiso(PERMISO_CLIENTES_VER)]
  TSincronizacionController = class(TControllerBase)
  public
    [MVCPath('/bajada')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_SOLICITUDES_CREAR)]
    [MVCSwagSummary('Sincronizacion', 'Clientes, contactos y catalogos ' +
      'modificados desde una fecha, inactivos incluidos, y el seguimiento de ' +
      'las solicitudes del usuario del token', 'bajarAlMovil')]
    [MVCSwagParam(plQuery, 'desde', 'servidor_ahora de la bajada anterior, ' +
      'en ISO 8601. Sin valor baja todo lo activo', ptString, False)]
    [MVCSwagResponses(200, 'Lo modificado y la hora del servidor', TBajadaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(422, 'desde sin la forma ISO 8601')]
    function Bajar([MVCInject] AServicio: ISincronizacionService;
      const [MVCFromQueryString('desde', '')] ADesde: string): IMVCResponse;
  end;

implementation

function TSincronizacionController.Bajar(AServicio: ISincronizacionService;
  const ADesde: string): IMVCResponse;
begin
  Result := OKResponse(AServicio.Bajar(UsuarioId, ComoFechaHora(ADesde)));
end;

end.
