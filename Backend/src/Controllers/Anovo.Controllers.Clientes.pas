unit Anovo.Controllers.Clientes;

// Clientes bajo /api/clientes: registro, contactos y
// consentimiento.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.Controllers.Base,
  Anovo.DTOs.Clientes,
  Anovo.DTOs.Cotizaciones,
  Anovo.Services.Intf.Clientes,
  Anovo.Permisos;

type

  [MVCPath('/api/clientes')]
  [MVCRequiresPermiso(PERMISO_CLIENTES_VER)]
  TClientesController = class(TControllerBase)
  public
    [MVCPath]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Clientes', 'Lista y busca clientes, paginado',
      'listarClientes')]
    [MVCSwagParam(plQuery, 'q',
      'Texto a buscar en nombre, identificacion, telefono o correo',
      ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'incluir_inactivos',
      'Incluir los clientes dados de baja', ptBoolean, False)]
    [MVCSwagParam(plQuery, 'consentimiento',
      'Filtra por estado de consentimiento: pendiente, firmado o revocado',
      ptString, False)]
    [MVCSwagResponses(200, 'Pagina de clientes', TClientesPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(422, 'consentimiento con un valor que no existe')]
    function Listar([MVCInject] AServicio: IClienteService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer;
      const [MVCFromQueryString('incluir_inactivos', False)] AIncluirInactivos
      : Boolean;
      const [MVCFromQueryString('consentimiento', '')] AConsentimiento: string)
      : TClientesPaginaDTO;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Clientes', 'Obtiene un cliente por su numero',
      'obtenerCliente')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagResponses(200, 'El cliente', TClienteDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(404, 'No existe un cliente con ese numero')]
    function Obtener([MVCInject] AServicio: IClienteService; const AId: Integer)
      : IMVCResponse;

    [MVCPath]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CLIENTES_CREAR)]
    [MVCSwagSummary('Clientes', 'Registra un cliente nuevo', 'crearCliente')]
    [MVCSwagParam(plBody, 'Cliente', 'Datos del cliente nuevo',
      TClienteNuevoDTO)]
    [MVCSwagResponses(201, 'Creado. La cabecera Location apunta al cliente')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(422, 'Algun campo no paso la validacion')]
    function Crear([MVCInject] AServicio: IClienteService;
      [MVCFromBody] const ADto: TClienteNuevoDTO): IMVCResponse;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_CLIENTES_EDITAR)]
    [MVCSwagSummary('Clientes', 'Modifica un cliente existente',
      'actualizarCliente')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagParam(plBody, 'Cliente', 'Datos del cliente, con su objversion',
      TClienteEdicionDTO)]
    [MVCSwagResponses(204, 'Actualizado')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(404, 'No existe un cliente con ese numero')]
    [MVCSwagResponses(409, 'Otra persona lo modifico: objversion vencida')]
    [MVCSwagResponses(422, 'Algun campo no paso la validacion')]
    function Actualizar([MVCInject] AServicio: IClienteService;
      const AId: Integer; [MVCFromBody] const ADto: TClienteEdicionDTO)
      : IMVCResponse;

    [MVCPath('/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CLIENTES_INACTIVAR)]
    [MVCSwagSummary('Clientes', 'Inactiva un cliente. Baja logica',
      'inactivarCliente')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagResponses(204, 'Inactivado, o ya estaba inactivo')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(404, 'No existe un cliente con ese numero')]
    function Inactivar([MVCInject] AServicio: IClienteService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/anonimizacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CLIENTES_INACTIVAR)]
    [MVCSwagSummary('Clientes',
      'Anonimiza a un cliente persona fisica (derecho de supresion, Ley 8968)',
      'anonimizarCliente')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagParam(plBody, 'Motivo', 'Motivo de la supresion', TMotivoDTO)]
    [MVCSwagResponses(204, 'Anonimizado: datos personales, contactos, croquis y fotos')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(404, 'No existe un cliente con ese numero')]
    [MVCSwagResponses(409, 'El cliente ya estaba anonimizado')]
    [MVCSwagResponses(422, 'Sin motivo, cedula juridica o sin tipo de identificacion')]
    function Anonimizar([MVCInject] AServicio: IClienteService;
      const AId: Integer; [MVCFromBody] const ADto: TMotivoDTO): IMVCResponse;

    [MVCPath('/registro-completo')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CLIENTES_CREAR)]
    [MVCRequiresPermiso(PERMISO_CLIENTES_CONSENTIMIENTO)]
    [MVCSwagSummary('Clientes',
      'Registra un cliente con sus contactos y la firma, todo o nada',
      'registrarClienteCompleto')]
    [MVCSwagParam(plBody, 'Registro',
      'Cliente, contactos y firma de consentimiento',
      TClienteRegistroCompletoDTO)]
    [MVCSwagResponses(201, 'Creado. La cabecera Location apunta al cliente')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(422, 'Faltan datos o no son coherentes entre si')]
    function RegistrarCompleto([MVCInject] AServicio: IClienteService;
      [MVCFromBody] const ADto: TClienteRegistroCompletoDTO): IMVCResponse;

    [MVCPath('/($AId)/contactos')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Clientes', 'Contactos activos de un cliente',
      'listarContactos')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagResponses(200, 'Los contactos, el principal primero', TContactoDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Contactos([MVCInject] AServicio: IClienteService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/contactos')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CLIENTES_EDITAR)]
    [MVCSwagSummary('Clientes', 'Agrega un contacto al cliente',
      'crearContacto')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagParam(plBody, 'Contacto', 'Datos del contacto', TContactoNuevoDTO)]
    [MVCSwagResponses(201, 'Creado. La cabecera Location apunta al contacto')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(422, 'Algun campo no paso la validacion')]
    function CrearContacto([MVCInject] AServicio: IClienteService;
      const AId: Integer; [MVCFromBody] const ADto: TContactoNuevoDTO)
      : IMVCResponse;

    [MVCPath('/($AId)/contactos/($AContactoId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_CLIENTES_EDITAR)]
    [MVCSwagSummary('Clientes', 'Modifica un contacto del cliente',
      'actualizarContacto')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagParam(plPath, 'AContactoId', 'Numero del contacto',
      ptInteger, True)]
    [MVCSwagParam(plBody, 'Contacto', 'Datos del contacto, con su objversion',
      TContactoEdicionDTO)]
    [MVCSwagResponses(204, 'Actualizado')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(404, 'Ese cliente no tiene un contacto con ese numero')]
    [MVCSwagResponses(409, 'Otra persona lo modifico: objversion vencida')]
    [MVCSwagResponses(422, 'Algun campo no paso la validacion')]
    function ActualizarContacto([MVCInject] AServicio: IClienteService;
      const AId, AContactoId: Integer;
      [MVCFromBody] const ADto: TContactoEdicionDTO): IMVCResponse;

    [MVCPath('/($AId)/contactos/($AContactoId)/anonimizacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CLIENTES_INACTIVAR)]
    [MVCSwagSummary('Clientes',
      'Anonimiza un contacto (derecho de supresion, Ley 8968) sin tocar al ' +
      'cliente', 'anonimizarContacto')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagParam(plPath, 'AContactoId', 'Numero del contacto',
      ptInteger, True)]
    [MVCSwagParam(plBody, 'Motivo', 'Motivo de la supresion', TMotivoDTO)]
    [MVCSwagResponses(204, 'Anonimizado: nombre, area, telefonos y correo')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(404, 'Ese cliente no tiene un contacto activo con ese ' +
      'numero (tambien si ya se anonimizo)')]
    [MVCSwagResponses(422, 'Sin motivo')]
    function AnonimizarContacto([MVCInject] AServicio: IClienteService;
      const AId, AContactoId: Integer;
      const [MVCFromBody] ADto: TMotivoDTO): IMVCResponse;

    [MVCPath('/($AId)/contactos/($AContactoId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CLIENTES_EDITAR)]
    [MVCSwagSummary('Clientes', 'Inactiva un contacto. Baja logica',
      'inactivarContacto')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagParam(plPath, 'AContactoId', 'Numero del contacto',
      ptInteger, True)]
    [MVCSwagResponses(204, 'Inactivado, o ya estaba inactivo')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(404, 'Ese cliente no tiene un contacto con ese numero')]
    function InactivarContacto([MVCInject] AServicio: IClienteService;
      const AId, AContactoId: Integer): IMVCResponse;

    [MVCPath('/($AId)/consentimientos')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Clientes',
      'Historial de consentimiento del cliente, el mas reciente primero',
      'listarConsentimientos')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagResponses(200, 'El historial, sin la imagen de la firma',
      TConsentimientoDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function Consentimientos([MVCInject] AServicio: IClienteService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/consentimientos/revocacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CLIENTES_CONSENTIMIENTO)]
    [MVCSwagSummary('Clientes', 'Registra la revocacion del consentimiento',
      'revocarConsentimiento')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagParam(plBody, 'Revocacion',
      'Quien la pide, y la objversion del cliente', TRevocacionDTO)]
    [MVCSwagResponses(204, 'Revocado')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(404, 'No existe un cliente con ese numero')]
    [MVCSwagResponses(409, 'Ya estaba revocado, u objversion vencida')]
    [MVCSwagResponses(422, 'Algun campo no paso la validacion')]
    function Revocar([MVCInject] AServicio: IClienteService;
      const AId: Integer; [MVCFromBody] const ADto: TRevocacionDTO)
      : IMVCResponse;
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections;

function TClientesController.Listar(AServicio: IClienteService;
  const ABusqueda: string; const APagina, APorPagina: Integer;
  const AIncluirInactivos: Boolean; const AConsentimiento: string)
  : TClientesPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDatos: TObjectList<TClienteDTO>;
begin
  lPagina := PaginaValida(APagina);
  lPorPagina := PorPaginaValida(APorPagina);

  lDatos := AServicio.Buscar(ABusqueda, lPagina, lPorPagina,
    AIncluirInactivos, AConsentimiento, lTotal);

  Result := TClientesPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
end;

function TClientesController.Obtener(AServicio: IClienteService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Obtener(AId));
end;

function TClientesController.Crear(AServicio: IClienteService;
  const ADto: TClienteNuevoDTO): IMVCResponse;
var
  lId: Integer;
begin
  lId := AServicio.Crear(ADto);
  Result := CreatedResponse('/api/clientes/' + lId.ToString);
end;

function TClientesController.Actualizar(AServicio: IClienteService;
  const AId: Integer; const ADto: TClienteEdicionDTO): IMVCResponse;
begin
  AServicio.Actualizar(AId, ADto);
  Result := NoContentResponse;
end;

function TClientesController.Inactivar(AServicio: IClienteService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.Inactivar(AId);
  Result := NoContentResponse;
end;

function TClientesController.Anonimizar(AServicio: IClienteService;
  const AId: Integer; const ADto: TMotivoDTO): IMVCResponse;
begin
  AServicio.Anonimizar(AId, ADto.Motivo);
  Result := NoContentResponse;
end;

function TClientesController.RegistrarCompleto(AServicio: IClienteService;
  const ADto: TClienteRegistroCompletoDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/clientes/' + AServicio.RegistrarCompleto(ADto)
    .ToString);
end;

function TClientesController.Contactos(AServicio: IClienteService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Contactos(AId));
end;

function TClientesController.CrearContacto(AServicio: IClienteService;
  const AId: Integer; const ADto: TContactoNuevoDTO): IMVCResponse;
begin
  Result := CreatedResponse(Format('/api/clientes/%d/contactos/%d',
    [AId, AServicio.CrearContacto(AId, ADto)]));
end;

function TClientesController.ActualizarContacto(AServicio: IClienteService;
  const AId, AContactoId: Integer; const ADto: TContactoEdicionDTO)
  : IMVCResponse;
begin
  AServicio.ActualizarContacto(AId, AContactoId, ADto);
  Result := NoContentResponse;
end;

function TClientesController.AnonimizarContacto(AServicio: IClienteService;
  const AId, AContactoId: Integer; const ADto: TMotivoDTO): IMVCResponse;
begin
  AServicio.AnonimizarContacto(AId, AContactoId, ADto.Motivo);
  Result := NoContentResponse;
end;

function TClientesController.InactivarContacto(AServicio: IClienteService;
  const AId, AContactoId: Integer): IMVCResponse;
begin
  AServicio.InactivarContacto(AId, AContactoId);
  Result := NoContentResponse;
end;

function TClientesController.Consentimientos(AServicio: IClienteService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Consentimientos(AId));
end;

function TClientesController.Revocar(AServicio: IClienteService;
  const AId: Integer; const ADto: TRevocacionDTO): IMVCResponse;
begin
  AServicio.Revocar(AId, ADto);
  Result := NoContentResponse;
end;

end.
