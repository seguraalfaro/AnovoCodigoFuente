unit Anovo.Controllers.Home;

// Ruta de prueba del control de acceso por rol.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Middleware.Authentication.RoleBasedAuthHandler;

type

  [MVCPath('/api')]
  TAnovoController = class(TMVCController)
  public

    [MVCPath('/privado')]
    [MVCHTTPMethod([httpGET])]
    [MVCRequiresRole('supervisor')]
    function SoloSupervisor: String;
  end;

implementation

function TAnovoController.SoloSupervisor: String;
begin
  Result := 'Si ves esto, el rol supervisor esta activo';
end;

end.
