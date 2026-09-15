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
  MVCFramework, MVCFramework.Commons;

type
  [MVCPath('/api')]
  TAnovoController = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    [MVCProduces(TMVCMediaType.TEXT_HTML)]
    function Index: String;
  end;

implementation

function TAnovoController.Index: String;
begin
  Result := '<p>Hello <strong>DelphiMVCFramework</strong> World</p>' +
            '<p><small>dmvcframework-' + DMVCFRAMEWORK_VERSION + '</small></p>';
end;

end.
