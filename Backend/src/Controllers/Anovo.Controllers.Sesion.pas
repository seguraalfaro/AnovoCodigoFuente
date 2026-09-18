unit Anovo.Controllers.Sesion;

// GET /api/sesion: los permisos del usuario del token.
//
// Pide token pero ningun permiso: tambien lo llama quien entro con clave
// provisional, y a ese le tiene que llegar la lista vacia, no un 403.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.DTOs.Sesion,
  Anovo.Services.Intf.Permisos;

type
  [MVCPath('/api/sesion')]
  TSesionController = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresAuthentication]
    [MVCSwagSummary('Sesion', 'Rol y permisos del usuario del token',
      'obtenerSesion')]
    [MVCSwagResponses(200, 'Rol y permisos', TSesionDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    function Obtener([MVCInject] APermisos: IPermisoService): IMVCResponse;
  end;

implementation

function TSesionController.Obtener(APermisos: IPermisoService): IMVCResponse;
var
  lSesion: TSesionDTO;
begin
  lSesion := TSesionDTO.Create;
  // Un solo rol por usuario; el claim es lista y aqui se toma el primero.
  if Context.LoggedUser.Roles.Count > 0 then
    lSesion.Rol := Context.LoggedUser.Roles[0];
  lSesion.Permisos := APermisos.PermisosDe(lSesion.Rol);
  Result := OKResponse(lSesion);
end;

end.
