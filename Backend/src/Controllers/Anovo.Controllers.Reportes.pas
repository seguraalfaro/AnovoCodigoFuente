unit Anovo.Controllers.Reportes;

// Reportes del proceso de cotizaciones bajo /api/reportes (RF-008).

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.DTOs.Reportes,
  Anovo.Services.Intf.Reportes,
  Anovo.Permisos;

type

  [MVCPath('/api/reportes')]
  TReportesController = class(TMVCController)
  public
    [MVCPath('/cotizaciones')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_REPORTES_VER)]
    [MVCSwagSummary('Reportes', 'Cotizaciones elaboradas en el periodo, con ' +
      'su estado actual: resumen, por estado, por asesor, por tipo de ' +
      'trabajo y por mes', 'reporteCotizaciones')]
    [MVCSwagParam(plQuery, 'desde', 'Fecha inicial, aaaa-mm-dd. Por omision, ' +
      'el primer dia del mes de hasta', ptString, False)]
    [MVCSwagParam(plQuery, 'hasta', 'Fecha final incluida, aaaa-mm-dd. Por ' +
      'omision, hoy', ptString, False)]
    [MVCSwagResponses(200, 'Reporte del periodo', TReporteCotizacionesDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(422, 'Fecha con otra forma o rango al reves')]
    function Cotizaciones([MVCInject] AServicio: IReporteService;
      const [MVCFromQueryString('desde', '')] ADesde: string;
      const [MVCFromQueryString('hasta', '')] AHasta: string): IMVCResponse;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Anovo.Errors,
  Anovo.Textos;

function ComoFecha(const ATexto: string; const APorDefecto: TDateTime)
  : TDateTime;
var
  lFormato: TFormatSettings;
begin
  if Trim(ATexto) = '' then
    Exit(APorDefecto);

  lFormato := TFormatSettings.Create;
  lFormato.DateSeparator := '-';
  lFormato.ShortDateFormat := 'yyyy-mm-dd';
  if not TryStrToDate(Trim(ATexto), Result, lFormato) then
    raise EDatoInvalido.Create(Format(SFechaInvalida, [ATexto]));
end;

function TReportesController.Cotizaciones(AServicio: IReporteService;
  const ADesde, AHasta: string): IMVCResponse;
var
  lHasta: TDateTime;
begin
  lHasta := ComoFecha(AHasta, Date);
  Result := OKResponse(AServicio.Cotizaciones(ComoFecha(ADesde,
    StartOfTheMonth(lHasta)), lHasta));
end;

end.
