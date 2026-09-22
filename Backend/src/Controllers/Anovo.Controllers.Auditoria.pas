unit Anovo.Controllers.Auditoria;

// Auditoria: la frontera HTTP.
//
// Aqui no hay negocio ni base de datos. Cada accion traduce lo que llega por
// HTTP a una llamada del servicio y lo que devuelve a una respuesta.
//
// Solo lectura: la bitacora la escriben los disparadores, asi que no hay POST,
// PUT ni DELETE. Que no exista la ruta es parte de la garantia.
//
// PERMISOS. Son dos y no se solapan:
//
//   auditoria.ver_toda     gerencia. La bitacora entera.
//   auditoria.ver_cuentas  administrador. Solo USUARIOS y USUARIOS_CLAVES,
//                          que es rol de TI y no tiene por que ver los datos
//                          de negocio.
//
// Por eso son dos rutas y no una con un filtro: la ruta dice que se esta
// consultando y el permiso va pegado a ella. La clase exige cualquiera de los
// dos -el ; vale como "alguno"- y cada accion exige el suyo; los dos se piden
// a la vez.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.DTOs.Auditoria,
  Anovo.Services.Intf.Auditoria;

const
  PERMISO_VER_TODA = 'auditoria.ver_toda';
  PERMISO_VER_CUENTAS = 'auditoria.ver_cuentas';

  POR_PAGINA_POR_DEFECTO = 50;
  POR_PAGINA_MAXIMO = 200;

  // Cuando no se pide ventana de tiempo. La bitacora es la tabla que mas
  // crece: sin ventana, la primera consulta del dia la barre entera.
  DIAS_POR_DEFECTO = 30;

type

  [MVCPath('/api/auditoria')]
  [MVCRequiresPermiso(PERMISO_VER_TODA + ';' + PERMISO_VER_CUENTAS)]
  TAuditoriaController = class(TMVCController)
  private
    function Consultar(const AServicio: IAuditoriaService;
      const AAlcance: TAlcanceAuditoria; const ADesde, AHasta: string;
      const APagina, APorPagina: Integer; const AUsuarioId: Integer;
      const AEntidad, AAccion, ATexto: string): TAuditoriaPaginaDTO;
  public
    [MVCPath]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_VER_TODA)]
    [MVCSwagSummary('Auditoria', 'Consulta la bitacora, paginada',
      'listarAuditoria')]
    [MVCSwagParam(plQuery, 'desde',
      'Fecha inicial, aaaa-mm-dd. Por defecto los ultimos 30 dias',
      ptString, False)]
    [MVCSwagParam(plQuery, 'hasta',
      'Fecha final, aaaa-mm-dd. Incluye el dia entero', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'usuario_id', 'Filtra por quien hizo el cambio',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'entidad', 'Filtra por tabla, por ejemplo CLIENTES',
      ptString, False)]
    [MVCSwagParam(plQuery, 'accion',
      'Filtra por accion: creacion, modificacion o eliminacion',
      ptString, False)]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en el detalle',
      ptString, False)]
    [MVCSwagResponses(200, 'Pagina de la bitacora', TAuditoriaPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    [MVCSwagResponses(422, 'Una fecha mal escrita o un rango al reves')]
    function Listar([MVCInject] AServicio: IAuditoriaService;
      const [MVCFromQueryString('desde', '')] ADesde: string;
      const [MVCFromQueryString('hasta', '')] AHasta: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer;
      const [MVCFromQueryString('usuario_id', 0)] AUsuarioId: Integer;
      const [MVCFromQueryString('entidad', '')] AEntidad: string;
      const [MVCFromQueryString('accion', '')] AAccion: string;
      const [MVCFromQueryString('q', '')] ABusqueda: string)
      : TAuditoriaPaginaDTO;

    [MVCPath('/cuentas')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_VER_CUENTAS)]
    [MVCSwagSummary('Auditoria',
      'Consulta la bitacora de cuentas de usuario, paginada',
      'listarAuditoriaCuentas')]
    [MVCSwagParam(plQuery, 'desde',
      'Fecha inicial, aaaa-mm-dd. Por defecto los ultimos 30 dias',
      ptString, False)]
    [MVCSwagParam(plQuery, 'hasta',
      'Fecha final, aaaa-mm-dd. Incluye el dia entero', ptString, False)]
    [MVCSwagParam(plQuery, 'pagina', 'Numero de pagina, desde 1',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'por_pagina', 'Cuantos por pagina. Maximo 200',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'usuario_id', 'Filtra por quien hizo el cambio',
      ptInteger, False)]
    [MVCSwagParam(plQuery, 'entidad',
      'USUARIOS o USUARIOS_CLAVES. Por defecto USUARIOS', ptString, False)]
    [MVCSwagParam(plQuery, 'accion',
      'Filtra por accion: creacion, modificacion o eliminacion',
      ptString, False)]
    [MVCSwagParam(plQuery, 'q', 'Texto a buscar en el detalle',
      ptString, False)]
    [MVCSwagResponses(200, 'Pagina de la bitacora de cuentas',
      TAuditoriaPaginaDTO)]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'Se pidio una entidad que no es de cuentas')]
    [MVCSwagResponses(422, 'Una fecha mal escrita o un rango al reves')]
    function ListarCuentas([MVCInject] AServicio: IAuditoriaService;
      const [MVCFromQueryString('desde', '')] ADesde: string;
      const [MVCFromQueryString('hasta', '')] AHasta: string;
      const [MVCFromQueryString('pagina', 1)] APagina: Integer;
      const [MVCFromQueryString('por_pagina', POR_PAGINA_POR_DEFECTO)
      ] APorPagina: Integer;
      const [MVCFromQueryString('usuario_id', 0)] AUsuarioId: Integer;
      const [MVCFromQueryString('entidad', '')] AEntidad: string;
      const [MVCFromQueryString('accion', '')] AAccion: string;
      const [MVCFromQueryString('q', '')] ABusqueda: string)
      : TAuditoriaPaginaDTO;

    [MVCPath('/($AEntidad)/($AEntidadId)')]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_VER_TODA)]
    [MVCSwagSummary('Auditoria', 'La bitacora de una fila',
      'auditoriaDeEntidad')]
    [MVCSwagParam(plPath, 'AEntidad', 'Tabla, por ejemplo CLIENTES',
      ptString, True)]
    [MVCSwagParam(plPath, 'AEntidadId', 'Numero de la fila', ptInteger, True)]
    [MVCSwagResponses(200,
      'Los movimientos de esa fila, el mas reciente primero')]
    [MVCSwagResponses(401, 'Sin token o token vencido')]
    [MVCSwagResponses(403, 'El rol no tiene el permiso para esta operacion')]
    function DeLaEntidad([MVCInject] AServicio: IAuditoriaService;
      const AEntidad: string; const AEntidadId: Integer): IMVCResponse;
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  System.DateUtils,
  System.Generics.Collections,
  Anovo.Errors;

{ TAuditoriaController }

// aaaa-mm-dd. Vacio devuelve el valor de reserva que decide cada accion.
function ComoFecha(const ATexto: string; const APorDefecto: TDateTime)
  : TDateTime;
var
  lFormato: TFormatSettings;
begin
  if Trim(ATexto) = '' then
    Exit(APorDefecto);

  // Formato fijo y no el del servidor: la fecha viaja en la URL y no debe
  // depender de la configuracion regional de la maquina donde corre la API.
  lFormato := TFormatSettings.Create;
  lFormato.DateSeparator := '-';
  lFormato.ShortDateFormat := 'yyyy-mm-dd';
  if not TryStrToDate(Trim(ATexto), Result, lFormato) then
    raise EDatoInvalido.Create('La fecha ' + ATexto +
      ' no tiene la forma aaaa-mm-dd.');
end;

function TAuditoriaController.Consultar(const AServicio: IAuditoriaService;
  const AAlcance: TAlcanceAuditoria; const ADesde, AHasta: string;
  const APagina, APorPagina: Integer; const AUsuarioId: Integer;
  const AEntidad, AAccion, ATexto: string): TAuditoriaPaginaDTO;
var
  lTotal: Int64;
  lPagina, lPorPagina: Integer;
  lDesde, lHasta: TDateTime;
  lDatos: TObjectList<TAuditoriaDTO>;
begin
  // Se acotan aqui y no en el servicio porque son un problema de la frontera:
  // pagina 0 produce un ROWS invalido y un por_pagina de 100000 deja al
  // servidor armando cien mil objetos porque alguien escribio mal un numero.
  lPagina := Max(APagina, 1);
  lPorPagina := EnsureRange(APorPagina, 1, POR_PAGINA_MAXIMO);

  lHasta := ComoFecha(AHasta, Date);
  lDesde := ComoFecha(ADesde, IncDay(lHasta, -DIAS_POR_DEFECTO));

  lDatos := AServicio.Buscar(AAlcance, lDesde, lHasta, lPagina, lPorPagina,
    AUsuarioId, AEntidad, AAccion, ATexto, lTotal);

  // El sobre se devuelve tal cual y no dentro de OKResponse: OKResponse lo
  // envuelve en otro "data" y la lista quedaria en data.data.
  Result := TAuditoriaPaginaDTO.Create(lDatos, lTotal, lPagina, lPorPagina);
end;

function TAuditoriaController.Listar(AServicio: IAuditoriaService;
  const ADesde, AHasta: string; const APagina, APorPagina: Integer;
  const AUsuarioId: Integer; const AEntidad, AAccion, ABusqueda: string)
  : TAuditoriaPaginaDTO;
begin
  Result := Consultar(AServicio, aaTodo, ADesde, AHasta, APagina, APorPagina,
    AUsuarioId, AEntidad, AAccion, ABusqueda);
end;

function TAuditoriaController.ListarCuentas(AServicio: IAuditoriaService;
  const ADesde, AHasta: string; const APagina, APorPagina: Integer;
  const AUsuarioId: Integer; const AEntidad, AAccion, ABusqueda: string)
  : TAuditoriaPaginaDTO;
begin
  Result := Consultar(AServicio, aaSoloCuentas, ADesde, AHasta, APagina,
    APorPagina, AUsuarioId, AEntidad, AAccion, ABusqueda);
end;

function TAuditoriaController.DeLaEntidad(AServicio: IAuditoriaService;
  const AEntidad: string; const AEntidadId: Integer): IMVCResponse;
begin
  Result := OKResponse(AServicio.DeLaEntidad(AEntidad, AEntidadId));
end;

end.
