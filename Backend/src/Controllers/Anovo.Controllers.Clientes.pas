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
// la forma unica del contrato. Atraparlas aqui solo serviria para escribir dos
// veces lo mismo, peor.
//
// PERMISOS. Cada accion declara su lista completa. DMVC no hereda de un rol a
// otro: la accion que se quede sin atributo queda abierta a cualquier token
// valido, y eso no da error ni aviso. Segun lo acordado el 15/09/2026 y
// pendiente de minuta (P18): el administrador queda fuera de clientes por ser
// rol de TI, e inactivar se reserva a supervisor y gerencia.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  MVCFramework.Swagger.Commons,
  MVCFramework.Middleware.Authentication.RoleBasedAuthHandler,
  Anovo.DTOs.Clientes,
  Anovo.Services.Intf.Clientes;

const
  // Quienes trabajan con clientes. El separador por defecto de
  // MVCRequiresRole es el punto y coma, y reOR significa "con uno basta".
  ROLES_CLIENTES = 'asesor;asistente;supervisor;gerencia';
  ROLES_INACTIVAR = 'supervisor;gerencia';

  POR_PAGINA_POR_DEFECTO = 50;
  POR_PAGINA_MAXIMO = 200;

type
  [MVCPath('/api/clientes')]
  TClientesController = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresRole(ROLES_CLIENTES, reOR)]
    [MVCSwagSummary('Clientes', 'Lista y busca clientes, paginado', 'listarClientes')]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en nombre, identificacion, telefono o correo', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1', ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200', ptInteger, False)]
    [MVCSwagParam(plQuery, 'incluir_inactivos', 'Incluir los clientes dados de baja', ptBoolean, False)]
    [MVCSwagResponses(200, 'Pagina de clientes', TClientesPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol del token no alcanza para esta operacion')]
    function Listar([MVCInject] AServicio: IClienteService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)]
        APorPagina: Integer;
      const [MVCFromQueryString('incluir_inactivos', False)]
        AIncluirInactivos: Boolean): IMVCResponse;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresRole(ROLES_CLIENTES, reOR)]
    [MVCSwagSummary('Clientes', 'Obtiene un cliente por su numero', 'obtenerCliente')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagResponses(200, 'El cliente', TClienteDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol del token no alcanza para esta operacion')]
    [MVCSwagResponses(404, 'No existe un cliente con ese numero')]
    function Obtener([MVCInject] AServicio: IClienteService;
      const AId: Integer): IMVCResponse;

    [MVCPath]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresRole(ROLES_CLIENTES, reOR)]
    [MVCSwagSummary('Clientes', 'Registra un cliente nuevo', 'crearCliente')]
    [MVCSwagParam(plBody, 'Cliente', 'Datos del cliente nuevo', TClienteNuevoDTO)]
    [MVCSwagResponses(201, 'Creado. La cabecera Location apunta al cliente')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol del token no alcanza para esta operacion')]
    [MVCSwagResponses(422, 'Algun campo no paso la validacion')]
    function Crear([MVCInject] AServicio: IClienteService;
      [MVCFromBody] const ADto: TClienteNuevoDTO): IMVCResponse;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresRole(ROLES_CLIENTES, reOR)]
    [MVCSwagSummary('Clientes', 'Modifica un cliente existente', 'actualizarCliente')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagParam(plBody, 'Cliente', 'Datos del cliente, con su objversion', TClienteEdicionDTO)]
    [MVCSwagResponses(204, 'Actualizado')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol del token no alcanza para esta operacion')]
    [MVCSwagResponses(404, 'No existe un cliente con ese numero')]
    [MVCSwagResponses(409, 'Otra persona lo modifico: objversion vencida')]
    [MVCSwagResponses(422, 'Algun campo no paso la validacion')]
    function Actualizar([MVCInject] AServicio: IClienteService;
      const AId: Integer;
      [MVCFromBody] const ADto: TClienteEdicionDTO): IMVCResponse;

    // Sub-recurso y POST, no DELETE: la baja es logica. Un cliente inactivo
    // sigue referenciado desde sus solicitudes y cotizaciones, asi que borrarlo
    // de verdad no es una opcion, y llamar DELETE a algo que no borra confunde
    // a quien lea el contrato.
    [MVCPath('/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCRequiresRole(ROLES_INACTIVAR, reOR)]
    [MVCSwagSummary('Clientes', 'Inactiva un cliente. Baja logica', 'inactivarCliente')]
    [MVCSwagParam(plPath, 'AId', 'Numero del cliente', ptInteger, True)]
    [MVCSwagResponses(204, 'Inactivado, o ya estaba inactivo')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol del token no alcanza para esta operacion')]
    [MVCSwagResponses(404, 'No existe un cliente con ese numero')]
    function Inactivar([MVCInject] AServicio: IClienteService;
      const AId: Integer): IMVCResponse;
  end;

implementation

uses
  System.Math,
  System.SysUtils,
  System.Generics.Collections;

function TClientesController.Listar(AServicio: IClienteService;
  const ABusqueda: string;
  const APagina, APorPagina: Integer;
  const AIncluirInactivos: Boolean): IMVCResponse;
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
    AIncluirInactivos, lTotal);

  // El sobre se queda con la lista y el framework libera el sobre.
  Result := OKResponse(TClientesPaginaDTO.Create(lDatos, lTotal, lPagina,
    lPorPagina));
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
  // 201 con Location. Si el alta ya habia subido con ese uuid_local, el
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

end.
