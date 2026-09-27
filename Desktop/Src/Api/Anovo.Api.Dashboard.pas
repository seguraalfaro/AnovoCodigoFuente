unit Anovo.Api.Dashboard;

// Cliente de la API de dashboards.

interface

uses
  Anovo.Api.Base,
  Anovo.Api.Intf.Dashboard,
  Anovo.DTOs.Dashboard;

type
  TApiDashboard = class(TApiBase, IApiDashboard)
  public
    function Asesor: TDashboardAsesorDTO;
  end;

implementation

uses
  MVCFramework.RESTClient.Intf;

const
  RUTA_DASHBOARD_ASESOR = '/api/dashboard/asesor';

function TApiDashboard.Asesor: TDashboardAsesorDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_DASHBOARD_ASESOR);
    end);

  Result := TDashboardAsesorDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

end.
