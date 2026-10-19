unit Anovo.Controllers.Correo;

// Estado del correo saliente bajo /api/correo: el escritorio lo consulta para
// saber si ofrece el envio por correo.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.Controllers.Base,
  Anovo.DTOs.Correo,
  Anovo.Services.Intf.Correo,
  Anovo.Permisos;

type

  [MVCPath('/api/correo')]
  [MVCRequiresPermiso(PERMISO_COTIZACIONES_RESPONDER)]
  TCorreoController = class(TControllerBase)
  public
    [MVCPath('/estado')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Correo', 'Si el servidor puede enviar correo, con que ' +
      'modo y desde que cuenta', 'estadoCorreo')]
    [MVCSwagResponses(200, 'Estado del correo', TEstadoCorreoDTO)]
    function Estado([MVCInject] AServicio: ICorreoService): IMVCResponse;
  end;

implementation

function TCorreoController.Estado(AServicio: ICorreoService): IMVCResponse;
begin
  Result := OKResponse(AServicio.Estado);
end;

end.
