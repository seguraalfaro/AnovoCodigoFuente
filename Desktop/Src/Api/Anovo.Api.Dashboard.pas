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
    function Asistente: TDashboardAsistenteDTO;
    function Supervisor: TDashboardSupervisorDTO;
    function Gerencia: TDashboardGerenciaDTO;
    function Cuentas: TDashboardCuentasDTO;
    function Avisos: TAvisosDTO;
  end;

implementation

uses
  MVCFramework.RESTClient.Intf;

const
  RUTA_DASHBOARD_ASESOR = '/api/dashboard/asesor';
  RUTA_DASHBOARD_ASISTENTE = '/api/dashboard/asistente';
  RUTA_DASHBOARD_SUPERVISOR = '/api/dashboard/supervisor';
  RUTA_DASHBOARD_GERENCIA = '/api/dashboard/gerencia';
  RUTA_DASHBOARD_CUENTAS = '/api/dashboard/cuentas';
  RUTA_DASHBOARD_AVISOS = '/api/dashboard/avisos';

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

function TApiDashboard.Asistente: TDashboardAsistenteDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_DASHBOARD_ASISTENTE);
    end);

  Result := TDashboardAsistenteDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiDashboard.Supervisor: TDashboardSupervisorDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_DASHBOARD_SUPERVISOR);
    end);

  Result := TDashboardSupervisorDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiDashboard.Gerencia: TDashboardGerenciaDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_DASHBOARD_GERENCIA);
    end);

  Result := TDashboardGerenciaDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiDashboard.Cuentas: TDashboardCuentasDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_DASHBOARD_CUENTAS);
    end);

  Result := TDashboardCuentasDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

function TApiDashboard.Avisos: TAvisosDTO;
var
  lRespuesta: IMVCRESTResponse;
begin
  lRespuesta := Ejecutar(
    function: IMVCRESTResponse
    begin
      Result := NuevoCliente.Get(RUTA_DASHBOARD_AVISOS);
    end);

  Result := TAvisosDTO.Create;
  try
    lRespuesta.BodyFor(Result, 'data');
  except
    Result.Free;
    raise;
  end;
end;

end.
