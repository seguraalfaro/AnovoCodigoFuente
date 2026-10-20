unit Anovo.Repositories.Catalogos;

// Repositorios de catalogos y de la lista Todos.

interface

uses
  System.Generics.Collections,
  MVCFramework.ActiveRecord,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Catalogos,
  Anovo.Entities.Catalogos,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas;

type
  TMaterialRepository = class(TAnovoRepository<TMateriales>,
    IMaterialRepository)
  public
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;
    function BuscarConPrecio(const ATexto: string;
      const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False)
      : TObjectList<TMaterialesConPrecio>;
    function ObtenerPorCodigo(const ACodigo: string): TMateriales;
    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  TCatalogoTodosRepository = class(TAnovoRepository<TMateriales>,
    ICatalogoTodosRepository)
  public
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False)
      : TObjectList<TCatalogoTodos>;
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;
  end;

  TPrecioProgramadoRepository = class(TAnovoRepository<TPreciosProgramados>,
    IPrecioProgramadoRepository)
  public
    function PorAplicar: TObjectList<TPreciosProgramados>;
  end;

  TMaterialPrecioRepository = class(TAnovoRepository<TMaterialesPrecios>,
    IMaterialPrecioRepository)
  public
    function PrecioVigenteDe(const AMaterialId: Integer): TMaterialesPrecios;
    function HistorialDe(const AMaterialId: Integer)
      : TObjectList<TMaterialesPrecios>;
  end;

  TManoObraRepository = class(TAnovoRepository<TManoObra>, IManoObraRepository)
  public
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
  public
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;
    function BuscarConPrecio(const ATexto: string;
      const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False)
      : TObjectList<TMaquinasConPrecio>;
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
    function PorAbreviatura(const AAbreviatura: string): Integer;
  end;

  TTipoTrabajoRepository = class(TAnovoRepository<TTiposTrabajo>,
    ITipoTrabajoRepository)
  public
    function Todos(const AIncluirInactivos: Boolean = False;
      const ATexto: string = ''): TObjectList<TTiposTrabajo>;
    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  TCatalogoSimpleRepository<T: TMVCActiveRecord, constructor> = class
    (TAnovoRepository<T>)
  public
    function Todos(const AIncluirInactivos: Boolean = False;
      const ATexto: string = ''): TObjectList<T>;
    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  TTipoMaterialRepository = class(TCatalogoSimpleRepository<TTiposMaterial>,
    ITipoMaterialRepository)
  end;

  TAcabadoRepository = class(TCatalogoSimpleRepository<TAcabados>,
    IAcabadoRepository)
  end;

  TFormaPagoRepository = class(TCatalogoSimpleRepository<TFormasPago>,
    IFormaPagoRepository)
  public
    function Activa(const AId: Integer): TFormasPago;
  end;

implementation

uses
  System.SysUtils,
  System.Variants,
  Anovo.SQL.Catalogos;

function NombreBusqueda(const AIncluirInactivos: Boolean): string;
begin
  if AIncluirInactivos then
    Result := CONSULTA_BUSCAR
  else
    Result := CONSULTA_BUSCAR_ACTIVOS;
end;

function NombreBusquedaDeCategoria(const AIncluirInactivos: Boolean): string;
begin
  if AIncluirInactivos then
    Result := CONSULTA_BUSCAR_DE_CATEGORIA
  else
    Result := CONSULTA_BUSCAR_ACTIVOS_DE_CATEGORIA;
end;

function TMaterialRepository.ContarBusqueda(const ATexto: string;
  const AIncluirInactivos: Boolean): Int64;
var
  lTexto: string;
begin
  lTexto := TextoParaRQL(ATexto);
  Result := ContarConsulta<TMaterialesConPrecio>(NombreBusqueda(AIncluirInactivos),
    [lTexto, lTexto, lTexto, 0, 0]);
end;

function TMaterialRepository.BuscarConPrecio(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean)
  : TObjectList<TMaterialesConPrecio>;
var
  lTexto: string;
begin
  lTexto := TextoParaRQL(ATexto);
  Result := ListarConsulta<TMaterialesConPrecio>(NombreBusqueda(AIncluirInactivos),
    [lTexto, lTexto, lTexto, (APagina - 1) * APorPagina, APorPagina]);
end;

function TMaterialRepository.ObtenerPorCodigo(const ACodigo: string)
  : TMateriales;
begin
  Result := GetOneByWhere(MATERIALES_POR_CODIGO, [ACodigo], False);
end;

function TMaterialRepository.ExisteNombre(const ANombre: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := NombreDuplicado(ANombre, AExcluirId);
end;

function TCatalogoTodosRepository.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean)
  : TObjectList<TCatalogoTodos>;
var
  lTexto: string;
begin
  lTexto := TextoParaRQL(ATexto);
  Result := ListarConsulta<TCatalogoTodos>(NombreBusqueda(AIncluirInactivos),
    [lTexto, lTexto, lTexto, (APagina - 1) * APorPagina, APorPagina]);
end;

function TCatalogoTodosRepository.ContarBusqueda(const ATexto: string;
  const AIncluirInactivos: Boolean): Int64;
var
  lTexto: string;
begin
  lTexto := TextoParaRQL(ATexto);
  Result := ContarConsulta<TCatalogoTodos>(NombreBusqueda(AIncluirInactivos),
    [lTexto, lTexto, lTexto, 0, 0]);
end;

function TPrecioProgramadoRepository.PorAplicar
  : TObjectList<TPreciosProgramados>;
begin
  Result := GetWhere(PROGRAMADOS_POR_APLICAR, []);
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

function TManoObraRepository.ContarBusqueda(const ATexto: string;
  const AIncluirInactivos: Boolean; const ACategoriaId: Integer): Int64;
var
  lTexto: string;
begin
  lTexto := TextoParaRQL(ATexto);
  if ACategoriaId > 0 then
    Result := ContarConsulta<TManoObraConPrecio>
      (NombreBusquedaDeCategoria(AIncluirInactivos),
      [ACategoriaId, lTexto, lTexto, lTexto, 0, 0])
  else
    Result := ContarConsulta<TManoObraConPrecio>
      (NombreBusqueda(AIncluirInactivos), [lTexto, lTexto, lTexto, 0, 0]);
end;

function TManoObraRepository.BuscarConPrecio(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  const ACategoriaId: Integer): TObjectList<TManoObraConPrecio>;
var
  lTexto: string;
  lInicio: Integer;
begin
  lTexto := TextoParaRQL(ATexto);
  lInicio := (APagina - 1) * APorPagina;
  if ACategoriaId > 0 then
    Result := ListarConsulta<TManoObraConPrecio>
      (NombreBusquedaDeCategoria(AIncluirInactivos),
      [ACategoriaId, lTexto, lTexto, lTexto, lInicio, APorPagina])
  else
    Result := ListarConsulta<TManoObraConPrecio>
      (NombreBusqueda(AIncluirInactivos),
      [lTexto, lTexto, lTexto, lInicio, APorPagina]);
end;

function TManoObraRepository.ObtenerPorCodigo(const ACodigo: string): TManoObra;
begin
  Result := GetOneByWhere(MANO_OBRA_POR_CODIGO, [ACodigo], False);
end;

function TManoObraRepository.ExisteNombre(const ANombre: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := NombreDuplicado(ANombre, AExcluirId);
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

function TMaquinaRepository.ContarBusqueda(const ATexto: string;
  const AIncluirInactivos: Boolean): Int64;
var
  lTexto: string;
begin
  lTexto := TextoParaRQL(ATexto);
  Result := ContarConsulta<TMaquinasConPrecio>(NombreBusqueda(AIncluirInactivos),
    [lTexto, lTexto, lTexto, 0, 0]);
end;

function TMaquinaRepository.BuscarConPrecio(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean)
  : TObjectList<TMaquinasConPrecio>;
var
  lTexto: string;
begin
  lTexto := TextoParaRQL(ATexto);
  Result := ListarConsulta<TMaquinasConPrecio>(NombreBusqueda(AIncluirInactivos),
    [lTexto, lTexto, lTexto, (APagina - 1) * APorPagina, APorPagina]);
end;

function TMaquinaRepository.ObtenerPorCodigo(const ACodigo: string): TMaquinas;
begin
  Result := GetOneByWhere(MAQUINAS_POR_CODIGO, [ACodigo], False);
end;

function TMaquinaRepository.ExisteNombre(const ANombre: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := NombreDuplicado(ANombre, AExcluirId);
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
  Result := NombreDuplicado(ANombre, AExcluirId);
end;

function TCatalogoSimpleRepository<T>.Todos(const AIncluirInactivos: Boolean;
  const ATexto: string): TObjectList<T>;
begin
  if AIncluirInactivos then
    Result := GetWhere(CATALOGO_SIMPLE_TODOS, [ATexto])
  else
    Result := GetWhere(CATALOGO_SIMPLE_ACTIVOS, [ATexto]);
end;

function TCatalogoSimpleRepository<T>.ExisteNombre(const ANombre: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := NombreDuplicado(ANombre, AExcluirId);
end;

function TFormaPagoRepository.Activa(const AId: Integer): TFormasPago;
begin
  Result := GetByPK(AId, False);
  if (Result <> nil) and not Result.Activo.ValueOrDefault then
    FreeAndNil(Result);
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
  Result := NombreDuplicado(ANombre, AExcluirId);
end;

function TUnidadMedidaRepository.PorAbreviatura(const AAbreviatura
  : string): Integer;
var
  lId: Variant;
begin
  lId := TMVCActiveRecord.CurrentConnection.ExecSQLScalar
    (UNIDAD_POR_ABREVIATURA, [AAbreviatura]);
  if VarIsNull(lId) or VarIsEmpty(lId) then
    Result := 0
  else
    Result := lId;
end;

end.
