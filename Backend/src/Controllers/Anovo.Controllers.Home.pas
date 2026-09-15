// ***************************************************************************
//
// Delphi MVC Framework
//
// Copyright (c) 2010-2026 Daniele Teti and the DMVCFramework Team
//
// https://github.com/danieleteti/delphimvcframework
//
// ***************************************************************************

unit Anovo.Controllers.Home;

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  //tambien omiti la unidad roles por eso no se me llamaba correctamente
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
