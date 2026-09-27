unit Anovo.Repositories.Catalogos;

// Repositorios de catalogos y de la lista Todos.

interface

uses
  System.Generics.Collections,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Catalogos,
  Anovo.Entities.Catalogos,
  Anovo.Entities.Vistas.Catalogos;

type
  TMaterialRepository = class(TAnovoRepository<TMateriales>,
    IMaterialRepository)
  private
    function Filtro(const AIncluirInactivos: Boolean): string;
    function Parametros(const ATexto: string): TArray<Variant>;
  public
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False): TObjectList<TMateriales>;
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;
    function BuscarConPrecio(const ATexto: string;
      const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False)
      : TObjectList<TMaterialConPrecio>;
    function ObtenerPorCodigo(const ACodigo: string): TMateriales;
    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  TCatalogoTodosRepository = class(TAnovoRepository<TMateriales>,
    ICatalogoTodosRepository)
  private
    function Filtro(const AIncluirInactivos: Boolean): string;
  public
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False)
      : TObjectList<TCatalogoItemConPrecio>;
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;
  end;

  TPrecioProgramadoRepository = class(TAnovoRepository<TPreciosProgramados>,
    IPrecioProgramadoRepository)
  public
    function PendientesDeMaterial(const AMaterialId: Integer)
      : TObjectList<TPreciosProgramados>;
    function PendientesDeManoObra(const AManoObraId: Integer)
      : TObjectList<TPreciosProgramados>;
    function PendientesDeMaquina(const AMaquinaId: Integer)
      : TObjectList<TPreciosProgramados>;
  end;

  TMaterialPrecioRepository = class(TAnovoRepository<TMaterialesPrecios>,
    IMaterialPrecioRepository)
  public
    function PrecioVigenteDe(const AMaterialId: Integer): TMaterialesPrecios;
    function HistorialDe(const AMaterialId: Integer)
      : TObjectList<TMaterialesPrecios>;
  end;

  TManoObraRepository = class(TAnovoRepository<TManoObra>, IManoObraRepository)
  private
    function Filtro(const AIncluirInactivos: Boolean;
      const ACategoriaId: Integer): string;
    function Parametros(const ATexto: string;
      const ACategoriaId: Integer): TArray<Variant>;
  public
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False;
      const ACategoriaId: Integer = 0): TObjectList<TManoObra>;
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False;
      const ACategoriaId: Integer = 0): Int64;
    function BuscarConPrecio(const ATexto: string;
      const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False;
      const ACategoriaId: Integer = 0): TObjectList<TManoObraConPrecio>;
    function ObtenerPorCodigo(const ACodigo: string): TManoObra;
    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  TManoObraPrecioRepository = class(TAnovoRepository<TManoObraPrecios>,
    IManoObraPrecioRepository)
  public
    function PrecioVigenteDe(const AManoObraId: Integer): TManoObraPrecios;
    function HistorialDe(const AManoObraId: Integer)
      : TObjectList<TManoObraPrecios>;
  end;

  TManoObraCategoriaRepository = class(TAnovoRepository<TManoObraCategoria>,
    IManoObraCategoriaRepository)
  public
    function Todas: TObjectList<TManoObraCategoria>;
  end;

  TMaquinaRepository = class(TAnovoRepository<TMaquinas>, IMaquinaRepository)
  private
    function Filtro(const AIncluirInactivos: Boolean): string;
    function Parametros(const ATexto: string): TArray<Variant>;
  public
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False): TObjectList<TMaquinas>;
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;
    function BuscarConPrecio(const ATexto: string;
      const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False)
      : TObjectList<TMaquinaConPrecio>;
    function ObtenerPorCodigo(const ACodigo: string): TMaquinas;
    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  TMaquinaPrecioRepository = class(TAnovoRepository<TMaquinasPrecios>,
    IMaquinaPrecioRepository)
  public
    function PrecioVigenteDe(const AMaquinaId: Integer): TMaquinasPrecios;
    function HistorialDe(const AMaquinaId: Integer)
      : TObjectList<TMaquinasPrecios>;
  end;

  TUnidadMedidaRepository = class(TAnovoRepository<TUnidadesMedida>,
    IUnidadMedidaRepository)
  public
    function Todas(const AIncluirInactivas: Boolean = False;
      const ATexto: string = ''): TObjectList<TUnidadesMedida>;
    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  TTipoTrabajoRepository = class(TAnovoRepository<TTiposTrabajo>,
    ITipoTrabajoRepository)
  public
    function Todos(const AIncluirInactivos: Boolean = False;
      const ATexto: string = ''): TObjectList<TTiposTrabajo>;
    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

implementation

uses
  System.SysUtils,
  System.Variants,
  MVCFramework.ActiveRecord,
  Anovo.SQL.Catalogos;

procedure Extremos(const APagina, APorPagina: Integer;
  out ADesde, AHasta: Integer);
begin
  ADesde := ((APagina - 1) * APorPagina) + 1;
  AHasta := APagina * APorPagina;
end;

function HayOtroCon(const ASQL, AValor: string;
  const AExcluirId: Integer): Boolean;
var
  lId: Variant;
begin
  lId := TMVCActiveRecord.CurrentConnection.ExecSQLScalar(ASQL,
    [AValor, AExcluirId]);
  Result := not VarIsNull(lId);
end;

function TMaterialRepository.Filtro(const AIncluirInactivos: Boolean): string;
begin
  Result := MATERIALES_FILTRO_BUSQUEDA;
  if not AIncluirInactivos then
    Result := Result + MATERIALES_SOLO_ACTIVOS;
end;

function TMaterialRepository.Parametros(const ATexto: string): TArray<Variant>;
begin
  Result := [ATexto, ATexto, ATexto];
end;

function TMaterialRepository.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean)
  : TObjectList<TMateriales>;
var
  lDesde, lHasta: Integer;
begin
  Extremos(APagina, APorPagina, lDesde, lHasta);
  Result := GetWhere(Filtro(AIncluirInactivos) + MATERIALES_ORDEN_Y_PAGINA,
    Parametros(ATexto) + [Variant(lDesde), Variant(lHasta)]);
end;

function TMaterialRepository.ContarBusqueda(const ATexto: string;
  const AIncluirInactivos: Boolean): Int64;
begin
  Result := GetConnection.ExecSQLScalar(MATERIALES_CONTAR +
    Filtro(AIncluirInactivos), Parametros(ATexto));
end;

function TMaterialRepository.BuscarConPrecio(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean)
  : TObjectList<TMaterialConPrecio>;
var
  lDesde, lHasta: Integer;
begin
  Extremos(APagina, APorPagina, lDesde, lHasta);
  Result := TMVCActiveRecord.Select<TMaterialConPrecio>
    (MATERIALES_CON_PRECIO + Filtro(AIncluirInactivos) +
    MATERIALES_ORDEN_Y_PAGINA,
    Parametros(ATexto) + [Variant(lDesde), Variant(lHasta)]);
end;

function TMaterialRepository.ObtenerPorCodigo(const ACodigo: string)
  : TMateriales;
begin
  Result := GetOneByWhere(MATERIALES_POR_CODIGO, [ACodigo], False);
end;

function TMaterialRepository.ExisteNombre(const ANombre: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := HayOtroCon(MATERIALES_NOMBRE_DUPLICADO, ANombre, AExcluirId);
end;

function TCatalogoTodosRepository.Filtro(const AIncluirInactivos
  : Boolean): string;
begin
  Result := CATALOGOS_TODOS_FILTRO;
  if not AIncluirInactivos then
    Result := Result + CATALOGOS_TODOS_SOLO_ACTIVOS;
end;

function TCatalogoTodosRepository.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean)
  : TObjectList<TCatalogoItemConPrecio>;
var
  lDesde, lHasta: Integer;
begin
  Extremos(APagina, APorPagina, lDesde, lHasta);
  Result := TMVCActiveRecord.Select<TCatalogoItemConPrecio>
    (CATALOGOS_TODOS + Filtro(AIncluirInactivos) +
    CATALOGOS_TODOS_ORDEN_Y_PAGINA,
    [ATexto, ATexto, ATexto, lDesde, lHasta]);
end;

function TCatalogoTodosRepository.ContarBusqueda(const ATexto: string;
  const AIncluirInactivos: Boolean): Int64;
begin
  Result := GetConnection.ExecSQLScalar(CATALOGOS_TODOS_CONTAR +
    Filtro(AIncluirInactivos), [ATexto, ATexto, ATexto]);
end;

function TPrecioProgramadoRepository.PendientesDeMaterial
  (const AMaterialId: Integer): TObjectList<TPreciosProgramados>;
begin
  Result := GetWhere(PROGRAMADOS_DE_MATERIAL, [AMaterialId]);
end;

function TPrecioProgramadoRepository.PendientesDeManoObra
  (const AManoObraId: Integer): TObjectList<TPreciosProgramados>;
begin
  Result := GetWhere(PROGRAMADOS_DE_MANO_OBRA, [AManoObraId]);
end;

function TPrecioProgramadoRepository.PendientesDeMaquina
  (const AMaquinaId: Integer): TObjectList<TPreciosProgramados>;
begin
  Result := GetWhere(PROGRAMADOS_DE_MAQUINA, [AMaquinaId]);
end;

function TMaterialPrecioRepository.PrecioVigenteDe(const AMaterialId: Integer)
  : TMaterialesPrecios;
begin
  Result := GetOneByWhere(MATERIAL_PRECIO_VIGENTE, [AMaterialId], False);
end;

function TMaterialPrecioRepository.HistorialDe(const AMaterialId: Integer)
  : TObjectList<TMaterialesPrecios>;
begin
  Result := GetWhere(MATERIAL_PRECIOS_HISTORIAL, [AMaterialId]);
end;

function TManoObraRepository.Filtro(const AIncluirInactivos: Boolean;
  const ACategoriaId: Integer): string;
begin
  Result := MANO_OBRA_FILTRO_BUSQUEDA;
  if not AIncluirInactivos then
    Result := Result + MANO_OBRA_SOLO_ACTIVOS;
  if ACategoriaId > 0 then
    Result := Result + MANO_OBRA_POR_CATEGORIA;
end;

function TManoObraRepository.Parametros(const ATexto: string;
  const ACategoriaId: Integer): TArray<Variant>;
begin
  Result := [ATexto, ATexto, ATexto];
  if ACategoriaId > 0 then
    Result := Result + [Variant(ACategoriaId)];
end;

function TManoObraRepository.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  const ACategoriaId: Integer): TObjectList<TManoObra>;
var
  lDesde, lHasta: Integer;
begin
  Extremos(APagina, APorPagina, lDesde, lHasta);
  Result := GetWhere(Filtro(AIncluirInactivos, ACategoriaId) +
    MANO_OBRA_ORDEN_Y_PAGINA, Parametros(ATexto, ACategoriaId) +
    [Variant(lDesde), Variant(lHasta)]);
end;

function TManoObraRepository.ContarBusqueda(const ATexto: string;
  const AIncluirInactivos: Boolean; const ACategoriaId: Integer): Int64;
begin
  Result := GetConnection.ExecSQLScalar(MANO_OBRA_CONTAR +
    Filtro(AIncluirInactivos, ACategoriaId),
    Parametros(ATexto, ACategoriaId));
end;

function TManoObraRepository.BuscarConPrecio(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  const ACategoriaId: Integer): TObjectList<TManoObraConPrecio>;
var
  lDesde, lHasta: Integer;
begin
  Extremos(APagina, APorPagina, lDesde, lHasta);
  Result := TMVCActiveRecord.Select<TManoObraConPrecio>
    (MANO_OBRA_CON_PRECIO + Filtro(AIncluirInactivos, ACategoriaId) +
    MANO_OBRA_ORDEN_Y_PAGINA, Parametros(ATexto, ACategoriaId) +
    [Variant(lDesde), Variant(lHasta)]);
end;

function TManoObraRepository.ObtenerPorCodigo(const ACodigo: string): TManoObra;
begin
  Result := GetOneByWhere(MANO_OBRA_POR_CODIGO, [ACodigo], False);
end;

function TManoObraRepository.ExisteNombre(const ANombre: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := HayOtroCon(MANO_OBRA_NOMBRE_DUPLICADO, ANombre, AExcluirId);
end;

function TManoObraPrecioRepository.PrecioVigenteDe(const AManoObraId: Integer)
  : TManoObraPrecios;
begin
  Result := GetOneByWhere(MANO_OBRA_PRECIO_VIGENTE, [AManoObraId], False);
end;

function TManoObraPrecioRepository.HistorialDe(const AManoObraId: Integer)
  : TObjectList<TManoObraPrecios>;
begin
  Result := GetWhere(MANO_OBRA_PRECIOS_HISTORIAL, [AManoObraId]);
end;

function TManoObraCategoriaRepository.Todas: TObjectList<TManoObraCategoria>;
begin
  Result := GetWhere(MANO_OBRA_CATEGORIAS, []);
end;

function TMaquinaRepository.Filtro(const AIncluirInactivos: Boolean): string;
begin
  Result := MAQUINAS_FILTRO_BUSQUEDA;
  if not AIncluirInactivos then
    Result := Result + MAQUINAS_SOLO_ACTIVAS;
end;

function TMaquinaRepository.Parametros(const ATexto: string): TArray<Variant>;
begin
  Result := [ATexto, ATexto, ATexto];
end;

function TMaquinaRepository.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean)
  : TObjectList<TMaquinas>;
var
  lDesde, lHasta: Integer;
begin
  Extremos(APagina, APorPagina, lDesde, lHasta);
  Result := GetWhere(Filtro(AIncluirInactivos) + MAQUINAS_ORDEN_Y_PAGINA,
    Parametros(ATexto) + [Variant(lDesde), Variant(lHasta)]);
end;

function TMaquinaRepository.ContarBusqueda(const ATexto: string;
  const AIncluirInactivos: Boolean): Int64;
begin
  Result := GetConnection.ExecSQLScalar(MAQUINAS_CONTAR +
    Filtro(AIncluirInactivos), Parametros(ATexto));
end;

function TMaquinaRepository.BuscarConPrecio(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean)
  : TObjectList<TMaquinaConPrecio>;
var
  lDesde, lHasta: Integer;
begin
  Extremos(APagina, APorPagina, lDesde, lHasta);
  Result := TMVCActiveRecord.Select<TMaquinaConPrecio>
    (MAQUINAS_CON_PRECIO + Filtro(AIncluirInactivos) +
    MAQUINAS_ORDEN_Y_PAGINA,
    Parametros(ATexto) + [Variant(lDesde), Variant(lHasta)]);
end;

function TMaquinaRepository.ObtenerPorCodigo(const ACodigo: string): TMaquinas;
begin
  Result := GetOneByWhere(MAQUINAS_POR_CODIGO, [ACodigo], False);
end;

function TMaquinaRepository.ExisteNombre(const ANombre: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := HayOtroCon(MAQUINAS_NOMBRE_DUPLICADO, ANombre, AExcluirId);
end;

function TMaquinaPrecioRepository.PrecioVigenteDe(const AMaquinaId: Integer)
  : TMaquinasPrecios;
begin
  Result := GetOneByWhere(MAQUINA_PRECIO_VIGENTE, [AMaquinaId], False);
end;

function TMaquinaPrecioRepository.HistorialDe(const AMaquinaId: Integer)
  : TObjectList<TMaquinasPrecios>;
begin
  Result := GetWhere(MAQUINA_PRECIOS_HISTORIAL, [AMaquinaId]);
end;

function TTipoTrabajoRepository.Todos(const AIncluirInactivos: Boolean;
  const ATexto: string): TObjectList<TTiposTrabajo>;
begin
  if AIncluirInactivos then
    Result := GetWhere(TIPOS_TRABAJO_TODOS, [ATexto])
  else
    Result := GetWhere(TIPOS_TRABAJO_ACTIVOS, [ATexto]);
end;

function TTipoTrabajoRepository.ExisteNombre(const ANombre: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := HayOtroCon(TIPOS_TRABAJO_NOMBRE_DUPLICADO, ANombre, AExcluirId);
end;

function TUnidadMedidaRepository.Todas(const AIncluirInactivas: Boolean;
  const ATexto: string): TObjectList<TUnidadesMedida>;
begin
  if AIncluirInactivas then
    Result := GetWhere(UNIDADES_MEDIDA_TODAS, [ATexto, ATexto])
  else
    Result := GetWhere(UNIDADES_MEDIDA_ACTIVAS, [ATexto, ATexto]);
end;

function TUnidadMedidaRepository.ExisteNombre(const ANombre: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := HayOtroCon(UNIDADES_MEDIDA_NOMBRE_DUPLICADO, ANombre, AExcluirId);
end;

end.
