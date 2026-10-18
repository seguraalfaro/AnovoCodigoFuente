unit Anovo.Controllers.Dispositivos;

// Dispositivos bajo /api/auth: registro con el token del login, renovacion
// de la sesion con la llave y cierre. Renovar y cerrar no llevan token.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.Controllers.Base,
  Anovo.Permisos,
  Anovo.DTOs.Dispositivos,
  Anovo.Services.Intf.Dispositivos;

type
  [MVCPath('/api/auth')]
  TDispositivosController = class(TControllerBase)
  public
    [MVCPath('/dispositivos')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_ADJUNTOS_CREAR)]
    [MVCSwagSummary('Sesion', 'Registra el telefono y entrega su llave. La ' +
      'llave se muestra una sola vez', 'registrarDispositivo')]
    [MVCSwagParam(plBody, 'body', 'Uuid y nombre del telefono',
      TDispositivoNuevoDTO)]
    [MVCSwagResponses(201, 'Llave y fecha de vencimiento', TLlaveDispositivoDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'La cuenta no tiene acceso a la app movil: le ' +
      'falta adjuntos.crear')]
    [MVCSwagResponses(422, 'Falta el uuid del dispositivo')]
    function Registrar([MVCInject] AServicio: IDispositivoService;
      const [MVCFromBody] ADto: TDispositivoNuevoDTO): IMVCResponse;

    [MVCPath('/renovar')]
    [MVCHTTPMethods([httpPOST])]
    [MVCSwagSummary('Sesion', 'Entrega un token nuevo y rota la llave del ' +
      'dispositivo', 'renovarSesion')]
    [MVCSwagParam(plBody, 'body', 'Uuid del telefono y su llave',
      TRenovacionDTO)]
    [MVCSwagResponses(200, 'Token, llave nueva y vencimiento',
      TSesionRenovadaDTO)]
    [MVCSwagResponses(401, 'Llave invalida, vencida o dispositivo inactivo')]
    function Renovar([MVCInject] AServicio: IDispositivoService;
      const [MVCFromBody] ADto: TRenovacionDTO): IMVCResponse;

    [MVCPath('/cierre')]
    [MVCHTTPMethods([httpPOST])]
    [MVCSwagSummary('Sesion', 'Inactiva la llave del dispositivo al cerrar ' +
      'sesion', 'cerrarDispositivo')]
    [MVCSwagParam(plBody, 'body', 'Uuid del telefono y su llave',
      TRenovacionDTO)]
    [MVCSwagResponses(204, 'Cerrado, o llave que ya no valia')]
    function Cerrar([MVCInject] AServicio: IDispositivoService;
      const [MVCFromBody] ADto: TRenovacionDTO): IMVCResponse;
  end;

implementation

function TDispositivosController.Registrar(AServicio: IDispositivoService;
  const ADto: TDispositivoNuevoDTO): IMVCResponse;
begin
  Result := CreatedResponse('', AServicio.Registrar(UsuarioId, ADto));
end;

function TDispositivosController.Renovar(AServicio: IDispositivoService;
  const ADto: TRenovacionDTO): IMVCResponse;
begin
  Result := OKResponse(AServicio.Renovar(ADto));
end;

function TDispositivosController.Cerrar(AServicio: IDispositivoService;
  const ADto: TRenovacionDTO): IMVCResponse;
begin
  AServicio.Cerrar(ADto);
  Result := NoContentResponse;
end;

end.
