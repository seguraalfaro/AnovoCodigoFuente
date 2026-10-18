unit Anovo.Controllers.Consentimiento;

// Textos del consentimiento bajo /api/consentimiento: el vigente y cualquier
// version los lee quien tenga sesion; publicar es de gerencia o TI.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.Controllers.Base,
  Anovo.DTOs.Clientes,
  Anovo.Services.Intf.Consentimiento,
  Anovo.Permisos;

const
  PERMISO_PUBLICAR = PERMISO_EMPRESA_EDITAR + SEPARADOR_PERMISOS +
    PERMISO_EMPRESA_ADMINISTRAR;

type

  [MVCPath('/api/consentimiento')]
  TConsentimientoController = class(TControllerBase)
  public
    [MVCPath('/vigente')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresAuthentication]
    [MVCSwagSummary('Consentimiento', 'Texto del consentimiento que se firma ' +
      'hoy', 'consentimientoVigente')]
    [MVCSwagResponses(200, 'El texto vigente', TConsentimientoTextoDTO)]
    [MVCSwagResponses(404, 'Todavia no se publico ninguno')]
    function Vigente([MVCInject] AServicio: IConsentimientoTextoService)
      : IMVCResponse;

    [MVCPath('/versiones/($AVersion)')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresAuthentication]
    [MVCSwagSummary('Consentimiento', 'Texto de una version, tal como se ' +
      'firmo', 'consentimientoVersion')]
    [MVCSwagParam(plPath, 'AVersion', 'Version del texto', ptString, True)]
    [MVCSwagResponses(200, 'El texto de esa version', TConsentimientoTextoDTO)]
    [MVCSwagResponses(404, 'No existe esa version')]
    function Version([MVCInject] AServicio: IConsentimientoTextoService;
      const AVersion: string): IMVCResponse;

    [MVCPath('/versiones')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_PUBLICAR)]
    [MVCSwagSummary('Consentimiento', 'Todas las versiones, la mas reciente ' +
      'primero', 'listarConsentimientos')]
    [MVCSwagResponses(200, 'Las versiones')]
    function Versiones([MVCInject] AServicio: IConsentimientoTextoService)
      : IMVCResponse;

    [MVCPath('/versiones')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_PUBLICAR)]
    [MVCSwagSummary('Consentimiento', 'Publica una version nueva: queda ' +
      'vigente y la anterior deja de regir. Una version no se edita',
      'publicarConsentimiento')]
    [MVCSwagParam(plBody, 'Texto', 'Version, titulo y contenido',
      TConsentimientoTextoNuevoDTO)]
    [MVCSwagResponses(201, 'Publicada')]
    [MVCSwagResponses(422, 'Falta un dato, es muy largo o la version ya existe')]
    function Publicar([MVCInject] AServicio: IConsentimientoTextoService;
      const [MVCFromBody] ADto: TConsentimientoTextoNuevoDTO): IMVCResponse;
  end;

implementation

uses
  System.SysUtils,
  System.NetEncoding;

function TConsentimientoController.Vigente(AServicio
  : IConsentimientoTextoService): IMVCResponse;
begin
  Result := OKResponse(AServicio.Vigente);
end;

function TConsentimientoController.Version(AServicio
  : IConsentimientoTextoService; const AVersion: string): IMVCResponse;
begin
  Result := OKResponse(AServicio.Version(AVersion));
end;

function TConsentimientoController.Versiones(AServicio
  : IConsentimientoTextoService): IMVCResponse;
begin
  Result := OKResponse(AServicio.Versiones);
end;

function TConsentimientoController.Publicar(AServicio
  : IConsentimientoTextoService;
  const ADto: TConsentimientoTextoNuevoDTO): IMVCResponse;
begin
  AServicio.Publicar(ADto, UsuarioId);
  Result := CreatedResponse('/api/consentimiento/versiones/' +
    TNetEncoding.URL.Encode(ADto.Version.Trim));
end;

end.
