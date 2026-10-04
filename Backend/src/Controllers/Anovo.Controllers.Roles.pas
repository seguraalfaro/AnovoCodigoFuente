unit Anovo.Controllers.Roles;

// Roles bajo /api/roles: la matriz de permisos por rol
// y sus cambios.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.DTOs.Roles,
  Anovo.Services.Intf.Roles;

const
  PERMISO_VER_PERMISOS = 'permisos.ver';
  PERMISO_EDITAR_PERMISOS = 'permisos.editar';

type

  [MVCPath('/api/roles')]
  [MVCRequiresPermiso(PERMISO_VER_PERMISOS)]
  TRolesController = class(TMVCController)
  public

    [MVCPath('')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Roles', 'Roles con sus usuarios activos, catalogo de ' +
      'permisos y matriz rol-permiso', 'obtenerMatriz')]
    [MVCSwagResponses(200, 'Roles, permisos y asignaciones',
      TMatrizPermisosDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function ObtenerMatriz([MVCInject] AServicio: IRolService): IMVCResponse;

    [MVCPath('/matriz')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_EDITAR_PERMISOS)]
    [MVCSwagSummary('Roles', 'Otorga o quita permisos a los roles. Rige en ' +
      'la siguiente peticion de cada usuario', 'cambiarMatriz')]
    [MVCSwagResponses(204, 'Cambios aplicados')]
    [MVCSwagResponses(403, 'Se intento cambiar el rol de quien hace el cambio')]
    [MVCSwagResponses(404, 'No existe el rol o el permiso')]
    [MVCSwagResponses(422, 'Falta el motivo o el permiso no es del ambito ' +
      'del rol')]
    function CambiarMatriz([MVCInject] AServicio: IRolService;
      const [MVCFromBody] ADto: TCambiosMatrizDTO): IMVCResponse;
  end;

implementation

function TRolesController.ObtenerMatriz(AServicio: IRolService): IMVCResponse;
begin
  Result := OKResponse(AServicio.Matriz);
end;

function TRolesController.CambiarMatriz(AServicio: IRolService;
  const ADto: TCambiosMatrizDTO): IMVCResponse;
begin
  AServicio.CambiarMatriz(ADto);
  Result := NoContentResponse;
end;

end.
