unit Anovo.Controllers.Empresa;

// Datos de la empresa bajo /api/empresa: los ve y los cambia gerencia
// (empresa.editar) o TI (empresa.administrar).

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.Controllers.Base,
  Anovo.DTOs.Empresa,
  Anovo.Services.Intf.Empresa,
  Anovo.Permisos;

const
  PERMISO_EMPRESA = PERMISO_EMPRESA_EDITAR + SEPARADOR_PERMISOS +
    PERMISO_EMPRESA_ADMINISTRAR;

type

  [MVCPath('/api/empresa')]
  [MVCRequiresPermiso(PERMISO_EMPRESA)]
  TEmpresaController = class(TControllerBase)
  public
    [MVCPath]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Empresa', 'Datos de la empresa: encabezado de la ' +
      'cotizacion, IVA y plazo de cotizaciones sin respuesta',
      'obtenerEmpresa')]
    [MVCSwagResponses(200, 'Los datos de la empresa', TEmpresaDTO)]
    function Obtener([MVCInject] AServicio: IEmpresaService): IMVCResponse;

    [MVCPath]
    [MVCHTTPMethods([httpPUT])]
    [MVCSwagSummary('Empresa', 'Actualiza los datos de la empresa. El IVA ' +
      'nuevo rige para las cotizaciones que se elaboren despues',
      'actualizarEmpresa')]
    [MVCSwagResponses(204, 'Actualizados')]
    [MVCSwagResponses(422, 'Falta un dato obligatorio o un valor esta ' +
      'fuera de rango')]
    function Actualizar([MVCInject] AServicio: IEmpresaService;
      const [MVCFromBody] ADto: TEmpresaDTO): IMVCResponse;
  end;

implementation

function TEmpresaController.Obtener(AServicio: IEmpresaService): IMVCResponse;
begin
  Result := OKResponse(AServicio.Obtener);
end;

function TEmpresaController.Actualizar(AServicio: IEmpresaService;
  const ADto: TEmpresaDTO): IMVCResponse;
begin
  AServicio.Actualizar(ADto);
  Result := NoContentResponse;
end;

end.
