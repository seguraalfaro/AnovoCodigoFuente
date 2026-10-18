unit Anovo.Controllers.Usuarios;

// Usuarios bajo /api/usuarios: cuentas, clave temporal y excepciones de
// permisos por persona. Solo para el perfil de TI.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.Controllers.Base,
  Anovo.DTOs.Usuarios,
  Anovo.Services.Intf.Dispositivos,
  Anovo.Services.Intf.Usuarios,
  Anovo.Permisos;

type

  [MVCPath('/api/usuarios')]
  [MVCRequiresPermiso(PERMISO_USUARIOS_ADMINISTRAR)]
  TUsuariosController = class(TControllerBase)
  public

    [MVCPath('')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Usuarios', 'Lista paginada de cuentas, sin el usuario ' +
      'Sistema', 'listarUsuarios')]
    [MVCSwagParam(plQuery, 'q', 'Busca en nombre o correo', ptString, False)]
    [MVCSwagParam(plQuery, 'estado', 'activos, inactivos, clave_pendiente o ' + 'con_adicionales; ' +
      'vacio trae todas', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagResponses(200, 'Pagina de usuarios', TUsuariosPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(422, 'estado con un valor que no existe')]
    function Listar([MVCInject] AServicio: IUsuarioService;
      const [MVCFromQueryString('q', '')] ABusqueda: string;
      const [MVCFromQueryString('estado', '')] AEstado: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer): TUsuariosPaginaDTO;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Usuarios', 'Obtiene una cuenta por su numero',
      'obtenerUsuario')]
    [MVCSwagParam(plPath, 'AId', 'Numero del usuario', ptInteger, True)]
    [MVCSwagResponses(200, 'La cuenta', TUsuarioDTO)]
    [MVCSwagResponses(404, 'No existe un usuario con ese numero')]
    function Obtener([MVCInject] AServicio: IUsuarioService;
      const AId: Integer): IMVCResponse;

    [MVCPath('')]
    [MVCHTTPMethods([httpPOST])]
    [MVCSwagSummary('Usuarios', 'Registra una cuenta con la clave temporal ' +
      'que genero el escritorio; la persona la cambia en su primer ingreso',
      'crearUsuario')]
    [MVCSwagParam(plBody, 'body', 'Correo, nombre, rol y clave temporal',
      TUsuarioEdicionDTO)]
    [MVCSwagResponses(201, 'Creado', TUsuarioDTO)]
    [MVCSwagResponses(404, 'No existe el rol')]
    [MVCSwagResponses(422, 'Falta el nombre, correo invalido o repetido, o ' +
      'clave temporal corta o con espacios')]
    function Crear([MVCInject] AServicio: IUsuarioService;
      const [MVCFromBody] ADto: TUsuarioEdicionDTO): IMVCResponse;

    [MVCPath('/($AId)')]
    [MVCHTTPMethods([httpPUT])]
    [MVCSwagSummary('Usuarios', 'Actualiza correo, nombre y rol. Al cambiar ' +
      'de rol se borran las excepciones de la persona', 'editarUsuario')]
    [MVCSwagParam(plPath, 'AId', 'Numero del usuario', ptInteger, True)]
    [MVCSwagParam(plBody, 'body', 'Correo, nombre y rol', TUsuarioEdicionDTO)]
    [MVCSwagResponses(204, 'Actualizado')]
    [MVCSwagResponses(403, 'Se intento cambiar el rol propio')]
    [MVCSwagResponses(404, 'No existe el usuario o el rol')]
    [MVCSwagResponses(422, 'Falta el nombre, correo invalido o repetido')]
    function Editar([MVCInject] AServicio: IUsuarioService; const AId: Integer;
      const [MVCFromBody] ADto: TUsuarioEdicionDTO): IMVCResponse;

    [MVCPath('/($AId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCSwagSummary('Usuarios', 'Inactiva la cuenta: ya no puede ingresar',
      'inactivarUsuario')]
    [MVCSwagParam(plPath, 'AId', 'Numero del usuario', ptInteger, True)]
    [MVCSwagResponses(204, 'Inactivada')]
    [MVCSwagResponses(403, 'Se intento inactivar la cuenta propia')]
    [MVCSwagResponses(404, 'No existe un usuario con ese numero')]
    function Inactivar([MVCInject] AServicio: IUsuarioService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/dispositivos')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Usuarios', 'Telefonos registrados por la cuenta, los ' +
      'activos primero', 'listarDispositivos')]
    [MVCSwagParam(plPath, 'AId', 'Numero del usuario', ptInteger, True)]
    [MVCSwagResponses(200, 'Los telefonos, sin la llave')]
    function Dispositivos([MVCInject] AServicio: IDispositivoService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/dispositivos/($ADispositivoId)/inactivacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCSwagSummary('Usuarios', 'Inactiva un telefono: su llave deja de ' +
      'servir y su sesion se corta en la siguiente peticion',
      'inactivarDispositivo')]
    [MVCSwagParam(plPath, 'AId', 'Numero del usuario', ptInteger, True)]
    [MVCSwagParam(plPath, 'ADispositivoId', 'Numero del telefono', ptInteger,
      True)]
    [MVCSwagResponses(204, 'Inactivado, o ya lo estaba')]
    [MVCSwagResponses(404, 'No existe ese telefono en esa cuenta')]
    function InactivarDispositivo([MVCInject] AServicio: IDispositivoService;
      const AId, ADispositivoId: Integer): IMVCResponse;

    [MVCPath('/($AId)/activacion')]
    [MVCHTTPMethods([httpPOST])]
    [MVCSwagSummary('Usuarios', 'Vuelve a activar la cuenta', 'activarUsuario')]
    [MVCSwagParam(plPath, 'AId', 'Numero del usuario', ptInteger, True)]
    [MVCSwagResponses(204, 'Activada')]
    [MVCSwagResponses(404, 'No existe un usuario con ese numero')]
    function Activar([MVCInject] AServicio: IUsuarioService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/clave')]
    [MVCHTTPMethods([httpPUT])]
    [MVCSwagSummary('Usuarios', 'Pone la clave temporal que genero el ' +
      'escritorio y obliga a cambiarla en el siguiente ingreso',
      'restablecerClave')]
    [MVCSwagParam(plPath, 'AId', 'Numero del usuario', ptInteger, True)]
    [MVCSwagParam(plBody, 'body', 'La clave temporal', TClaveTemporalDTO)]
    [MVCSwagResponses(204, 'Clave puesta')]
    [MVCSwagResponses(403, 'Se intento restablecer la clave propia')]
    [MVCSwagResponses(404, 'No existe un usuario con ese numero')]
    [MVCSwagResponses(422, 'Clave temporal corta o con espacios')]
    function RestablecerClave([MVCInject] AServicio: IUsuarioService;
      const AId: Integer; const [MVCFromBody] ADto: TClaveTemporalDTO)
      : IMVCResponse;

    [MVCPath('/($AId)/cambio-clave')]
    [MVCHTTPMethods([httpPOST])]
    [MVCSwagSummary('Usuarios', 'Obliga a cambiar la clave en el siguiente ' +
      'ingreso, sin cambiarla ahora', 'pedirCambioClave')]
    [MVCSwagParam(plPath, 'AId', 'Numero del usuario', ptInteger, True)]
    [MVCSwagResponses(204, 'Pedido')]
    [MVCSwagResponses(403, 'Se intento con la cuenta propia')]
    [MVCSwagResponses(404, 'No existe un usuario con ese numero')]
    function PedirCambioClave([MVCInject] AServicio: IUsuarioService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/permisos')]
    [MVCHTTPMethods([httpGET])]
    [MVCSwagSummary('Usuarios', 'Excepciones de la persona sobre los permisos ' +
      'de su rol', 'excepcionesUsuario')]
    [MVCSwagParam(plPath, 'AId', 'Numero del usuario', ptInteger, True)]
    [MVCSwagResponses(200, 'Permisos otorgados y quitados', TExcepcionDTO, True)]
    [MVCSwagResponses(404, 'No existe un usuario con ese numero')]
    function Excepciones([MVCInject] AServicio: IUsuarioService;
      const AId: Integer): IMVCResponse;

    [MVCPath('/($AId)/permisos')]
    [MVCHTTPMethods([httpPUT])]
    [MVCRequiresPermiso(PERMISO_PERMISOS_EDITAR)]
    [MVCSwagSummary('Usuarios', 'Otorga o quita permisos a la persona sobre ' +
      'los de su rol; tipo vacio borra la excepcion. Rige en la siguiente ' +
      'peticion', 'cambiarExcepciones')]
    [MVCSwagParam(plPath, 'AId', 'Numero del usuario', ptInteger, True)]
    [MVCSwagParam(plBody, 'body', 'Motivo y cambios', TCambiosExcepcionesDTO)]
    [MVCSwagResponses(204, 'Cambios aplicados')]
    [MVCSwagResponses(403, 'Se intento cambiar los permisos propios')]
    [MVCSwagResponses(404, 'No existe el usuario o el permiso')]
    [MVCSwagResponses(422, 'Falta el motivo, el permiso es de otro ambito o ' +
      'la excepcion no cambiaria nada')]
    function CambiarExcepciones([MVCInject] AServicio: IUsuarioService;
      const AId: Integer; const [MVCFromBody] ADto: TCambiosExcepcionesDTO)
      : IMVCResponse;
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections;

function TUsuariosController.Listar(AServicio: IUsuarioService;
  const ABusqueda, AEstado: string; const APagina, APorPagina: Integer)
  : TUsuariosPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDatos: TObjectList<TUsuarioDTO>;
begin
  lPagina := PaginaValida(APagina);
  lPorPagina := PorPaginaValida(APorPagina);
  lDatos := AServicio.Buscar(ABusqueda, AEstado, lPagina, lPorPagina, lTotal);
  Result := TUsuariosPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
end;

function TUsuariosController.Obtener(AServicio: IUsuarioService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Obtener(AId));
end;

function TUsuariosController.Crear(AServicio: IUsuarioService;
  const ADto: TUsuarioEdicionDTO): IMVCResponse;
var
  lUsuario: TUsuarioDTO;
begin
  lUsuario := AServicio.Crear(ADto);
  Result := CreatedResponse('/api/usuarios/' + lUsuario.ID.ToString, lUsuario);
end;

function TUsuariosController.Editar(AServicio: IUsuarioService;
  const AId: Integer; const ADto: TUsuarioEdicionDTO): IMVCResponse;
begin
  AServicio.Editar(AId, ADto);
  Result := NoContentResponse;
end;

function TUsuariosController.Dispositivos(AServicio: IDispositivoService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.DeUsuario(AId));
end;

function TUsuariosController.InactivarDispositivo(AServicio
  : IDispositivoService; const AId, ADispositivoId: Integer): IMVCResponse;
begin
  AServicio.InactivarPorAdmin(AId, ADispositivoId);
  Result := NoContentResponse;
end;

function TUsuariosController.Inactivar(AServicio: IUsuarioService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.Inactivar(AId);
  Result := NoContentResponse;
end;

function TUsuariosController.Activar(AServicio: IUsuarioService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.Activar(AId);
  Result := NoContentResponse;
end;

function TUsuariosController.RestablecerClave(AServicio: IUsuarioService;
  const AId: Integer; const ADto: TClaveTemporalDTO): IMVCResponse;
begin
  AServicio.RestablecerClave(AId, ADto.ClaveTemporal);
  Result := NoContentResponse;
end;

function TUsuariosController.PedirCambioClave(AServicio: IUsuarioService;
  const AId: Integer): IMVCResponse;
begin
  AServicio.PedirCambioClave(AId);
  Result := NoContentResponse;
end;

function TUsuariosController.Excepciones(AServicio: IUsuarioService;
  const AId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.Excepciones(AId));
end;

function TUsuariosController.CambiarExcepciones(AServicio: IUsuarioService;
  const AId: Integer; const ADto: TCambiosExcepcionesDTO): IMVCResponse;
begin
  AServicio.CambiarExcepciones(AId, ADto);
  Result := NoContentResponse;
end;

end.
