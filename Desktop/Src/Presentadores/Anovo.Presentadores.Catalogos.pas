unit Anovo.Presentadores.Catalogos;

// Presentador de la seccion Catalogos.

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.Api.Intf.Catalogos,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Catalogos,
  Anovo.Permisos,
  Anovo.Textos;

type
  TPresentadorCatalogos = class(TPresentadorBase)
  private
    FVista: IVistaCatalogos;
    FApi: IApiCatalogos;
    FCatalogo: TCatalogo;
    FTexto: string;
    FCategoriaId: Integer;
    FPagina: Integer;
    FTotalPaginas: Integer;
    FCategoriasPedidas: Boolean;
    procedure Cargar;
    procedure CargarLista<T: class>(const ATrabajo: TFunc<TObjectList<T>>;
      const AListo: TProc<TObjectList<T>>);
    procedure MostrarPagina(const APagina: Integer; const ATotal: Int64);
    procedure CargarMateriales;
    procedure CargarManoObra;
    procedure CargarMaquinas;
    procedure CargarTodos;
    procedure CargarTiposTrabajo;
    procedure CargarSimples;
    procedure CargarUnidadesMedida;
    procedure CargarUnidadesActivas;
    procedure CargarCategorias;
    procedure PublicarAcciones;
    function CatalogoDeFila: TCatalogo;
  public
    constructor Create(const AVista: IVistaCatalogos;
      const AApi: IApiCatalogos);
    procedure Iniciar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure Filtrar(const ACatalogo: TCatalogo);
    procedure FiltrarCategoria(const ACategoriaId: Integer);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;

    procedure Nuevo;
    procedure Importar;
    procedure Editar(const AId: Integer);
    procedure CambiarPrecio(const AId: Integer);
    procedure VerHistorial(const AId: Integer);
    procedure Inactivar(const AId: Integer);
    procedure Recargar;

    class function AccionesPermitidas: TAccionesCatalogo;
    class function PuedeEditar: Boolean;
  end;

const
  CATALOGO_POR_PAGINA = 50;

implementation

uses
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Importacion,
  Anovo.Sesion;

const
  CATALOGOS_IMPORTABLES = [ctMateriales, ctManoObra, ctMaquinas];

function TodasLasCategorias: TCategoriaDTO;
begin
  Result := TCategoriaDTO.Create;
  Result.ID := 0;
  Result.Nombre := STodasLasCategorias;
end;

constructor TPresentadorCatalogos.Create(const AVista: IVistaCatalogos;
  const AApi: IApiCatalogos);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCatalogo := ctTodos;
  FPagina := 1;
end;

procedure TPresentadorCatalogos.Iniciar;
begin
  FVista.MostrarCatalogo(FCatalogo);
  PublicarAcciones;
  FVista.MostrarBusqueda('', False);
  CargarUnidadesActivas;
  Cargar;
end;

procedure TPresentadorCatalogos.PublicarAcciones;
var
  lAcciones: TAccionesCatalogo;
begin
  lAcciones := AccionesPermitidas;
  if FCatalogo in CATALOGOS_SIN_PRECIO then
    lAcciones := lAcciones - [acPrecio, acHistorial];
  FVista.MostrarAcciones(lAcciones, PuedeEditar and (FCatalogo <> ctTodos));
  FVista.MostrarImportar(PuedeEditar, PuedeEditar and
    (FCatalogo in CATALOGOS_IMPORTABLES));
end;

procedure TPresentadorCatalogos.Cargar;
begin
  case FCatalogo of
    ctTodos:
      CargarTodos;
    ctMateriales:
      CargarMateriales;
    ctManoObra:
      begin
        if not FCategoriasPedidas then
          CargarCategorias;
        CargarManoObra;
      end;
    ctMaquinas:
      CargarMaquinas;
    ctTiposTrabajo:
      CargarTiposTrabajo;
    ctUnidadesMedida:
      CargarUnidadesMedida;
    ctTiposMaterial, ctAcabados, ctFormasPago:
      CargarSimples;
  end;
end;

procedure TPresentadorCatalogos.CargarLista<T>(const ATrabajo
  : TFunc<TObjectList<T>>; const AListo: TProc<TObjectList<T>>);
begin
  EjecutarUltima<TObjectList<T>>(SAccionCargarCatalogo, ATrabajo, AListo,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end);
end;

procedure TPresentadorCatalogos.MostrarPagina(const APagina: Integer;
  const ATotal: Int64);
begin
  FTotalPaginas := (ATotal + CATALOGO_POR_PAGINA - 1) div CATALOGO_POR_PAGINA;
  FVista.MostrarPaginacion(APagina, FTotalPaginas, ATotal);
end;

procedure TPresentadorCatalogos.CargarMateriales;
var
  lApi: IApiCatalogos;
  lTexto: string;
  lPagina: Integer;
  lTotal: Int64;
begin
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;
  lTotal := 0;

  CargarLista<TMaterialDTO>(
    function: TObjectList<TMaterialDTO>
    begin
      Result := lApi.BuscarMateriales(lTexto, lPagina, CATALOGO_POR_PAGINA,
        False, lTotal);
    end,
    procedure(ALista: TObjectList<TMaterialDTO>)
    begin
      FVista.MostrarMateriales(ALista);
      MostrarPagina(lPagina, lTotal);
    end);
end;

procedure TPresentadorCatalogos.CargarManoObra;
var
  lApi: IApiCatalogos;
  lTexto: string;
  lPagina, lCategoria: Integer;
  lTotal: Int64;
begin
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;
  lCategoria := FCategoriaId;
  lTotal := 0;

  CargarLista<TManoObraDTO>(
    function: TObjectList<TManoObraDTO>
    begin
      Result := lApi.BuscarManoObra(lTexto, lPagina, CATALOGO_POR_PAGINA,
        False, lCategoria, lTotal);
    end,
    procedure(ALista: TObjectList<TManoObraDTO>)
    begin
      FVista.MostrarManoObra(ALista);
      MostrarPagina(lPagina, lTotal);
    end);
end;

procedure TPresentadorCatalogos.CargarMaquinas;
var
  lApi: IApiCatalogos;
  lTexto: string;
  lPagina: Integer;
  lTotal: Int64;
begin
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;
  lTotal := 0;

  CargarLista<TMaquinaDTO>(
    function: TObjectList<TMaquinaDTO>
    begin
      Result := lApi.BuscarMaquinas(lTexto, lPagina, CATALOGO_POR_PAGINA,
        False, lTotal);
    end,
    procedure(ALista: TObjectList<TMaquinaDTO>)
    begin
      FVista.MostrarMaquinas(ALista);
      MostrarPagina(lPagina, lTotal);
    end);
end;

procedure TPresentadorCatalogos.CargarTodos;
var
  lApi: IApiCatalogos;
  lTexto: string;
  lPagina: Integer;
  lTotal: Int64;
begin
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;
  lTotal := 0;

  CargarLista<TCatalogoItemDTO>(
    function: TObjectList<TCatalogoItemDTO>
    begin
      Result := lApi.BuscarTodos(lTexto, lPagina, CATALOGO_POR_PAGINA,
        False, lTotal);
    end,
    procedure(ALista: TObjectList<TCatalogoItemDTO>)
    begin
      FVista.MostrarTodos(ALista);
      MostrarPagina(lPagina, lTotal);
    end);
end;

procedure TPresentadorCatalogos.CargarTiposTrabajo;
var
  lApi: IApiCatalogos;
  lTexto: string;
begin
  lApi := FApi;
  lTexto := FTexto;

  CargarLista<TTipoTrabajoDTO>(
    function: TObjectList<TTipoTrabajoDTO>
    begin
      Result := lApi.TiposTrabajo(False, lTexto);
    end,
    procedure(ALista: TObjectList<TTipoTrabajoDTO>)
    begin
      FTotalPaginas := 0;
      FVista.MostrarTiposTrabajo(ALista);
      FVista.MostrarPaginacion(1, 0, ALista.Count);
    end);
end;

procedure TPresentadorCatalogos.CargarSimples;
var
  lApi: IApiCatalogos;
  lTexto: string;
  lCatalogo: TCatalogoSimple;
begin
  lApi := FApi;
  lTexto := FTexto;
  lCatalogo := CatalogoSimpleDe(FCatalogo);

  CargarLista<TCatalogoSimpleDTO>(
    function: TObjectList<TCatalogoSimpleDTO>
    begin
      Result := lApi.Simples(lCatalogo, False, lTexto);
    end,
    procedure(ALista: TObjectList<TCatalogoSimpleDTO>)
    begin
      FTotalPaginas := 0;
      FVista.MostrarSimples(ALista);
      FVista.MostrarPaginacion(1, 0, ALista.Count);
    end);
end;

procedure TPresentadorCatalogos.CargarCategorias;
var
  lApi: IApiCatalogos;
begin
  FCategoriasPedidas := True;
  lApi := FApi;

  Ejecutar<TObjectList<TCategoriaDTO>>(SAccionCargarCatalogo,
    function: TObjectList<TCategoriaDTO>
    begin
      Result := lApi.Categorias;
      Result.Insert(0, TodasLasCategorias);
    end,
    procedure(ALista: TObjectList<TCategoriaDTO>)
    begin
      FVista.MostrarCategorias(ALista);
    end, nil);
end;

procedure TPresentadorCatalogos.CargarUnidadesMedida;
var
  lApi: IApiCatalogos;
  lTexto: string;
begin
  lApi := FApi;
  lTexto := FTexto;

  CargarLista<TUnidadMedidaDTO>(
    function: TObjectList<TUnidadMedidaDTO>
    begin
      Result := lApi.UnidadesMedida(False, lTexto);
    end,
    procedure(ALista: TObjectList<TUnidadMedidaDTO>)
    begin
      FTotalPaginas := 0;
      if lTexto.IsEmpty then
        FVista.MostrarUnidadesActivas(ALista);
      FVista.MostrarUnidadesMedida(ALista);
      FVista.MostrarPaginacion(1, 0, ALista.Count);
    end);
end;

procedure TPresentadorCatalogos.CargarUnidadesActivas;
var
  lApi: IApiCatalogos;
begin
  lApi := FApi;

  Ejecutar<TObjectList<TUnidadMedidaDTO>>(SAccionCargarCatalogo,
    function: TObjectList<TUnidadMedidaDTO>
    begin
      Result := lApi.UnidadesMedida(False);
    end,
    procedure(ALista: TObjectList<TUnidadMedidaDTO>)
    begin
      FVista.MostrarUnidadesActivas(ALista);
    end, nil);
end;

procedure TPresentadorCatalogos.Buscar(const ATexto: string);
begin
  FTexto := ATexto.Trim;
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, not FTexto.IsEmpty);
  Cargar;
end;

procedure TPresentadorCatalogos.Limpiar;
begin
  Buscar('');
end;

procedure TPresentadorCatalogos.Filtrar(const ACatalogo: TCatalogo);
begin
  if ACatalogo = FCatalogo then
    Exit;

  FCatalogo := ACatalogo;
  FTexto := '';
  FCategoriaId := 0;
  FPagina := 1;

  FVista.MostrarCatalogo(FCatalogo);
  PublicarAcciones;
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorCatalogos.FiltrarCategoria(const ACategoriaId: Integer);
begin
  if (FCatalogo <> ctManoObra) or (ACategoriaId = FCategoriaId) then
    Exit;
  FCategoriaId := ACategoriaId;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorCatalogos.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorCatalogos.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorCatalogos.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
end;

procedure TPresentadorCatalogos.Recargar;
begin
  Cargar;
end;

function TPresentadorCatalogos.CatalogoDeFila: TCatalogo;
begin
  if FCatalogo = ctTodos then
    Result := FVista.CatalogoDeLaFila
  else
    Result := FCatalogo;
end;

procedure TPresentadorCatalogos.Importar;
begin
  if not PuedeEditar or not (FCatalogo in CATALOGOS_IMPORTABLES) then
    Exit;
  case FCatalogo of
    ctManoObra:
      FVista.MostrarFormularioImportacion(ciManoObra);
    ctMaquinas:
      FVista.MostrarFormularioImportacion(ciMaquinas);
  else
    FVista.MostrarFormularioImportacion(ciMateriales);
  end;
end;

procedure TPresentadorCatalogos.Nuevo;
begin
  if not PuedeEditar or (FCatalogo = ctTodos) then
    Exit;
  FVista.MostrarFormularioItem(FCatalogo, 0);
end;

procedure TPresentadorCatalogos.Editar(const AId: Integer);
begin
  if not PuedeEditar then
    Exit;
  FVista.MostrarFormularioItem(CatalogoDeFila, AId);
end;

procedure TPresentadorCatalogos.CambiarPrecio(const AId: Integer);
begin
  if not PuedeEditar then
    Exit;
  if CatalogoDeFila in CATALOGOS_SIN_PRECIO then
    Exit;
  FVista.MostrarFormularioPrecio(CatalogoDeFila, AId);
end;

procedure TPresentadorCatalogos.VerHistorial(const AId: Integer);
var
  lApi: IApiCatalogos;
  lCatalogo: TCatalogo;
  lLista: TObjectList<TPrecioDTO>;
begin
  lCatalogo := CatalogoDeFila;
  if lCatalogo in CATALOGOS_SIN_PRECIO then
    Exit;
  lApi := FApi;
  lLista := nil;

  Ejecutar(SAccionCargarCatalogo,
    procedure
    begin
      case lCatalogo of
        ctManoObra:
          lLista := lApi.HistorialPrecioManoObra(AId);
        ctMaquinas:
          lLista := lApi.HistorialCostoMaquina(AId);
      else
        lLista := lApi.HistorialPrecioMaterial(AId);
      end;
    end,
    procedure
    var
      lTomada: TObjectList<TPrecioDTO>;
    begin
      lTomada := lLista;
      lLista := nil;
      Diferir(
        procedure
        begin
          FVista.MostrarHistorial(lTomada);
        end,
        procedure
        begin
          lTomada.Free;
        end);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end,
    procedure
    begin
      lLista.Free;
    end);
end;

procedure TPresentadorCatalogos.Inactivar(const AId: Integer);
var
  lApi: IApiCatalogos;
  lCatalogo: TCatalogo;
begin
  if not PuedeEditar or not FVista.Confirmar(SConfirmarInactivar) then
    Exit;
  lApi := FApi;
  lCatalogo := CatalogoDeFila;

  Ejecutar(SAccionCargarCatalogo,
    procedure
    begin
      case lCatalogo of
        ctManoObra:
          lApi.InactivarManoObra(AId);
        ctMaquinas:
          lApi.InactivarMaquina(AId);
        ctTiposTrabajo:
          lApi.InactivarTipoTrabajo(AId);
        ctUnidadesMedida:
          lApi.InactivarUnidadMedida(AId);
        ctTiposMaterial, ctAcabados, ctFormasPago:
          lApi.InactivarSimple(CatalogoSimpleDe(lCatalogo), AId);
      else
        lApi.InactivarMaterial(AId);
      end;
    end,
    procedure
    begin
      Cargar;
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end);
end;

class function TPresentadorCatalogos.AccionesPermitidas: TAccionesCatalogo;
begin
  Result := [];
  if TSesion.Tiene(PERMISO_CATALOGOS_VER) then
    Include(Result, acHistorial);
  if TSesion.Tiene(PERMISO_CATALOGOS_EDITAR) then
    Result := Result + [acEditar, acPrecio, acInactivar];
end;

class function TPresentadorCatalogos.PuedeEditar: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_CATALOGOS_EDITAR);
end;

end.
