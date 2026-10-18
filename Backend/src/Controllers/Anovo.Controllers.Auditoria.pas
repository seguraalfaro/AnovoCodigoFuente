unit Anovo.Controllers.Auditoria;

// Bitacora de auditoria bajo /api/auditoria. Solo lectura.

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  MVCFramework.Swagger.Commons,
  Anovo.Auth.Permisos,
  Anovo.Controllers.Base,
  Anovo.DTOs.Auditoria,
  Anovo.Services.Intf.Auditoria,
  Anovo.Permisos;

const


  DIAS_POR_DEFECTO = 30;

type

  [MVCPath('/api/auditoria')]
  [MVCRequiresPermiso(PERMISO_AUDITORIA_VER_TODA + SEPARADOR_PERMISOS +
    PERMISO_AUDITORIA_VER_CUENTAS)]
  TAuditoriaController = class(TControllerBase)
  private
    function Consultar(const AServicio: IAuditoriaService;
      const AAlcance: TAlcanceAuditoria; const ADesde, AHasta: string;
      const APagina, APorPagina: Integer; const AUsuarioId: Integer;
      const AEntidad, AAccion, ATexto: string): TAuditoriaPaginaDTO;
  public
    [MVCPath]
    [MVCHTTPMethods([httpGET])]
    [MVCRequiresPermiso(PERMISO_AUDITORIA_VER_TODA)]
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
    [MVCSwagParam(plQuery, 'entidad', 'Filtra por tabla, por ejemplo ' +
      'CLIENTES; CUENTAS trae las cuatro tablas de cuentas', ptString, False)]
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
    [MVCRequiresPermiso(PERMISO_AUDITORIA_VER_CUENTAS)]
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
      'CUENTAS (las cuatro), USUARIOS, USUARIOS_CLAVES, ROLES_PERMISOS o ' +
      'USUARIOS_PERMISOS. Por defecto CUENTAS', ptString, False)]
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
    [MVCRequiresPermiso(PERMISO_AUDITORIA_VER_TODA)]
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
  System.DateUtils,
  System.Generics.Collections,
  Anovo.Errors,
  Anovo.Textos;

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
  lPagina := PaginaValida(APagina);
  lPorPagina := PorPaginaValida(APorPagina);

  lHasta := ComoFecha(AHasta, Date);
  lDesde := ComoFecha(ADesde, IncDay(lHasta, -DIAS_POR_DEFECTO));

  lDatos := AServicio.Buscar(AAlcance, lDesde, lHasta, lPagina, lPorPagina,
    AUsuarioId, AEntidad, AAccion, ATexto, lTotal);

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
