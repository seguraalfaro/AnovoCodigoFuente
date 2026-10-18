unit Anovo.Controllers.Sesion;

// Sesion bajo /api/sesion: rol y permisos, datos de la
// cuenta propia y cambio de clave.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Controllers.Base,
  Anovo.DTOs.Sesion,
  Anovo.Services.Intf.Sesion;

type
  [MVCPath('/api/sesion')]
  TSesionController = class(TControllerBase)
  public
    [MVCPath]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresAuthentication]
    [MVCSwagSummary('Sesion', 'Rol y permisos efectivos del usuario del token',
      'obtenerSesion')]
    [MVCSwagResponses(200, 'Rol y permisos', TSesionDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    function Obtener([MVCInject] AServicio: ISesionService): IMVCResponse;

    [MVCPath('/cuenta')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresAuthentication]
    [MVCSwagSummary('Sesion', 'Datos de la cuenta del usuario del token',
      'obtenerCuenta')]
    [MVCSwagResponses(200, 'Nombre, correo, rol y fecha del ultimo cambio de ' +
      'clave', TCuentaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    function ObtenerCuenta([MVCInject] AServicio: ISesionService): IMVCResponse;

    [MVCPath('/clave')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresAuthentication]
    [MVCSwagSummary('Sesion', 'Cambia la clave del usuario del token. Con ' +
      'clave provisional, hay que volver a entrar despues', 'cambiarClave')]
    [MVCSwagResponses(204, 'Clave cambiada')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(422, 'Clave actual incorrecta o clave nueva que no ' +
      'cumple la regla')]
    function CambiarClave([MVCInject] AServicio: ISesionService;
      const [MVCFromBody] ADto: TCambioClaveDTO): IMVCResponse;
  end;

implementation

uses
  System.SysUtils;

function TSesionController.Obtener(AServicio: ISesionService): IMVCResponse;
begin
  Result := OKResponse(AServicio.Sesion(UsuarioId, Rol));
end;

function TSesionController.ObtenerCuenta(AServicio: ISesionService)
  : IMVCResponse;
begin
  Result := OKResponse(AServicio.Cuenta(UsuarioId, Rol));
end;

function TSesionController.CambiarClave(AServicio: ISesionService;
  const ADto: TCambioClaveDTO): IMVCResponse;
begin
  AServicio.CambiarClave(UsuarioId, ADto);
  Result := NoContentResponse;
end;

end.
