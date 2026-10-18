unit Anovo.Controllers.Reportes;

// Reportes del proceso de cotizaciones bajo /api/reportes (RF-008).

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.Controllers.Base,
  Anovo.DTOs.Reportes,
  Anovo.Services.Intf.Reportes,
  Anovo.Permisos;

type

  [MVCPath('/api/reportes')]
  TReportesController = class(TControllerBase)
  public
    [MVCPath('/cotizaciones')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_REPORTES_VER + SEPARADOR_PERMISOS +
      PERMISO_REPORTES_VER_PROPIOS)]
    [MVCSwagSummary('Reportes', 'Cotizaciones elaboradas en el periodo, con ' +
      'su estado actual: resumen, por estado, por asesor, por tipo de ' +
      'trabajo y por mes. Con reportes.ver_propios, solo las de sus ' +
      'solicitudes o las que elaboro', 'reporteCotizaciones')]
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

    [MVCPath('/cotizaciones/detalle')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_REPORTES_VER + SEPARADOR_PERMISOS +
      PERMISO_REPORTES_VER_PROPIOS)]
    [MVCSwagSummary('Reportes', 'Las cotizaciones detras de una fila del ' +
      'reporte: las que tuvieron un paso del cliente en el periodo (o el ' +
      'paso indicado, en la vista estado); en la vista cliente, las enviadas ' +
      'en el periodo. Hasta 500, la mas reciente primero',
      'detalleReporteCotizaciones')]
    [MVCSwagParam(plQuery, 'desde', 'Fecha inicial, aaaa-mm-dd', ptString,
      False)]
    [MVCSwagParam(plQuery, 'hasta', 'Fecha final incluida, aaaa-mm-dd',
      ptString, False)]
    [MVCSwagParam(plQuery, 'vista', 'estado, asesor, tipo, mes o cliente',
      ptString, True)]
    [MVCSwagParam(plQuery, 'clave', 'El estado, el id del asesor, del tipo ' +
      '(0 sin tipo) o del cliente, o el mes como aaaamm', ptString, True)]
    [MVCSwagResponses(200, 'Las cotizaciones de la fila')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(422, 'Vista o clave invalida, o rango al reves')]
    function Detalle([MVCInject] AServicio: IReporteService;
      const [MVCFromQueryString('desde', '')] ADesde: string;
      const [MVCFromQueryString('hasta', '')] AHasta: string;
      const [MVCFromQueryString('vista', '')] AVista: string;
      const [MVCFromQueryString('clave', '')] AClave: string): IMVCResponse;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils;

function TReportesController.Cotizaciones(AServicio: IReporteService;
  const ADesde, AHasta: string): IMVCResponse;
var
  lHasta: TDateTime;
begin
  lHasta := ComoFecha(AHasta, Date);
  Result := OKResponse(AServicio.Cotizaciones(ComoFecha(ADesde,
    StartOfTheMonth(lHasta)), lHasta, UsuarioId, Roles));
end;

function TReportesController.Detalle(AServicio: IReporteService;
  const ADesde, AHasta, AVista, AClave: string): IMVCResponse;
var
  lHasta: TDateTime;
begin
  lHasta := ComoFecha(AHasta, Date);
  Result := OKResponse(AServicio.Detalle(ComoFecha(ADesde,
    StartOfTheMonth(lHasta)), lHasta, AVista, AClave, UsuarioId, Roles));
end;

end.
