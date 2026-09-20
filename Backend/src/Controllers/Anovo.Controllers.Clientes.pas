                                                         unit Anovo.Controllers.Clientes;

// Clientes: la frontera HTTP.
//
// Aqui no hay negocio ni base de datos. Cada accion traduce lo que llega por
// HTTP a una llamada del servicio, y lo que el servicio devuelve a una
// respuesta. Si una accion crece mas de tres o cuatro lineas, es que se le
// esta metiendo algo que le toca al servicio.
//
// El servicio entra por parametro con [MVCInject], no por constructor. El
// framework lo resuelve por accion, no una vez por peticion, y deja la firma
// diciendo de que depende cada una.
//
// Las excepciones no se atrapan: el manejador de Anovo.Errors las convierte a
// la forma unica del contrato.
//
// Los contactos y el historial de consentimiento van como sub-recursos del
// cliente: no existen fuera de su cliente, y la ruta es la que dice de quien
// son.
//
// PERMISOS. Cada accion declara el suyo con [MVCRequiresPermiso]; quien lo
// tiene lo dice ROLES_PERMISOS, no este archivo. La clase exige ademas
// clientes.ver: una accion que se quede sin atributo no queda abierta, pero
// si abierta a todo el que vea clientes. La matriz inicial es la de la minuta
// 06/2026 (P18): el administrador queda fuera de clientes por ser rol de TI, e
// inactivar se reserva a supervisor y gerencia.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.DTOs.Clientes,
  Anovo.Services.Intf.Clientes;

const
  // Los codigos de PERMISOS. Un error de tipeo aqui no da error: deja a todos
  // con 403, que se nota en la primera prueba.
  PERMISO_VER = 'clientes.ver';
  PERMISO_CREAR = 'clientes.crear';
  PERMISO_EDITAR = 'clientes.editar';
  PERMISO_INACTIVAR = 'clientes.inactivar';
  PERMISO_CONSENTIMIENTO = 'clientes.consentimiento';

  POR_PAGINA_POR_DEFECTO = 50;
  POR_PAGINA_MAXIMO = 200;

type

  [MVCPath('/api/clientes')]
  [MVCRequiresPermiso(PERMISO_VER)]
  TClientesController = class(TMVCController)
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
    [MVCRequiresPermiso(PERMISO_CREAR)]
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
    [MVCRequiresPermiso(PERMISO_EDITAR)]
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

    // Sub-recurso y POST, no DELETE: la baja es logica. Un cliente inactivo
    // sigue referenciado desde sus solicitudes y cotizaciones, asi que borrarlo
    // de verdad no es una opcion, y llamar DELETE a algo que no borra confunde
    // a quien lea el contrato.
    [MVCPath('/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_INACTIVAR)]
    [MVCSwagSummary('Clientes', 'Inactiva un cliente. Baja logica',
      'inactivarCliente')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagResponses(204, 'Inactivado, o ya estaba inactivo')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(404, 'No existe un cliente con ese numero')]
    function Inactivar([MVCInject] AServicio: IClienteService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/registro-completo')]
    [MVCHTTPMethods([httpPOST])]
    // Los dos: crea al cliente y guarda su firma de consentimiento.
    [MVCRequiresPermiso(PERMISO_CREAR)]
    [MVCRequiresPermiso(PERMISO_CONSENTIMIENTO)]
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

    // CONTACTOS

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
    [MVCRequiresPermiso(PERMISO_EDITAR)]
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
    [MVCRequiresPermiso(PERMISO_EDITAR)]
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

    [MVCPath('/($AId)/contactos/($AContactoId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_EDITAR)]
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

    // CONSENTIMIENTO

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

    // Sub-recurso del historial: revocar no modifica ninguna fila, agrega
    // una. El estado del cliente cambia en la misma transaccion.
    [MVCPath('/($AId)/consentimientos/revocacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresPermiso(PERMISO_CONSENTIMIENTO)]
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
  System.Math,
  System.SysUtils,
  System.Generics.Collections;

// Clientes

function TClientesController.Listar(AServicio: IClienteService;
  const ABusqueda: string; const APagina, APorPagina: Integer;
  const AIncluirInactivos: Boolean; const AConsentimiento: string)
  : TClientesPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDatos: TObjectList<TClienteDTO>;
begin
  // Se acotan aqui y no en el servicio porque son un problema de la frontera:
  // pagina 0 o -3 producen un ROWS invalido, y un por_pagina de 100000 deja al
  // servidor armando cien mil objetos porque alguien escribio mal un numero.
  lPagina := Max(APagina, 1);
  lPorPagina := EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO);

  lDatos := AServicio.Buscar(ABusqueda, lPagina, lPorPagina,
    AIncluirInactivos, AConsentimiento, lTotal);

  // El sobre se devuelve tal cual y no dentro de OKResponse: OKResponse lo
  // envuelve en otro "data" y la lista quedaria en data.data. El sobre se queda
  // con la lista y el framework libera el sobre.
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
  // 201 con Location. Si el registro ya habia subido con ese uuid_local, el
  // servicio devuelve el id existente y el Location apunta al mismo sitio: el
  // telefono que reintenta no distingue si creo o reencontro, y no necesita
  // distinguirlo.
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

function TClientesController.RegistrarCompleto(AServicio: IClienteService;
  const ADto: TClienteRegistroCompletoDTO): IMVCResponse;
begin
  Result := CreatedResponse('/api/clientes/' + AServicio.RegistrarCompleto(ADto)
    .ToString);
end;

// Contactos

function TClientesController.Contactos(AServicio: IClienteService;
  const AId: Integer): IMVCResponse;
begin
  // La lista va dentro de "data", como el resto de las colecciones del
  // contrato. Sin paginar: un cliente tiene unos pocos contactos.
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

function TClientesController.InactivarContacto(AServicio: IClienteService;
  const AId, AContactoId: Integer): IMVCResponse;
begin
  AServicio.InactivarContacto(AId, AContactoId);
  Result := NoContentResponse;
end;

// Consentimiento

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
