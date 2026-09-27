unit Anovo.Controllers.Version;

// GET /api/version, sin token: versiones del servidor, del
// movil y del aviso de privacidad.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.DTOs.Sesion,
  Anovo.Services.Intf.Sesion;

type
  [MVCPath('/api/version')]
  TVersionController = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Version', 'Versiones del servidor, del movil y del ' +
      'aviso de privacidad', 'obtenerVersion')]
    [MVCSwagResponses(200, 'Versiones', TVersionDTO)]
    function Obtener([MVCInject] AServicio: ISesionService): IMVCResponse;
  end;

implementation

function TVersionController.Obtener(AServicio: ISesionService): IMVCResponse;
begin
  Result := OKResponse(AServicio.Versiones);
end;

end.
