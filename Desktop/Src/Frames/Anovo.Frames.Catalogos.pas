unit Anovo.Frames.Catalogos;

// Seccion Catalogos (HU-05): los listados y la lista Todos.

interface

uses
  Anovo.UI.CeldasRejilla,
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo, Vcl.WinXPanels,
  Data.DB, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, rDBGrid,
  rDBComponents,
  FlatVcl.BotonWin, VclPlano.BotonWin,
  Anovo.Frames.Listado,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Importacion,
  Anovo.Vistas.Intf.Catalogos,
  Anovo.Presentadores.Catalogos;

type
  TfraCatalogos = class(TfraListado, IVistaCatalogos)
    btnExportar: TPlanoBotonWin;
    btnImportar: TPlanoBotonWin;
    btnNuevo: TPlanoBotonWin;
    cbCategoria: TrDBLookupComboBox;
    cbCatalogo: TComboBox;
    cpCatalogo: TCardPanel;
    crdTodos: TCard;
    grTodos: TrDBGrid;
    crdMateriales: TCard;
    grMateriales: TrDBGrid;
    crdManoObra: TCard;
    grManoObra: TrDBGrid;
    crdMaquinas: TCard;
    grMaquinas: TrDBGrid;
    crdTiposTrabajo: TCard;
    grTiposTrabajo: TrDBGrid;
    crdUnidades: TCard;
    grUnidades: TrDBGrid;
    crdSimples: TCard;
    grSimples: TrDBGrid;
    procedure cbCatalogoChange(Sender: TObject);
    procedure cbCategoriaClick(Sender: TObject);
    procedure btnNuevoClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
  private
    FPresentador: TPresentadorCatalogos;
    FCatalogo: TCatalogo;
    function Rejillas: TArray<TrDBGrid>;
    function TarjetaDe(const ACatalogo: TCatalogo): TCard;
    procedure Accion(Sender: TObject; const AClave: string);
    function IdDeLaFila: Integer;
    function NombreDeLaFila: string;
    procedure Cargar<T: class>(const AFilas: TObjectList<T>;
      const ATabla: TFDMemTable);
    procedure MostrarCatalogo(const ACatalogo: TCatalogo);
    procedure MostrarImportar(const AVisible, AHabilitado: Boolean);
    procedure MostrarFormularioImportacion(
      const ACatalogo: TCatalogoImportacion);
    procedure MostrarAcciones(const AAcciones: TAccionesCatalogo;
      const APuedeCrear: Boolean);
    procedure MostrarMateriales(const AFilas: TObjectList<TMaterialDTO>);
    procedure MostrarManoObra(const AFilas: TObjectList<TManoObraDTO>);
    procedure MostrarMaquinas(const AFilas: TObjectList<TMaquinaDTO>);
    procedure MostrarTiposTrabajo(const AFilas: TObjectList<TTipoTrabajoDTO>);
    procedure MostrarSimples(const AFilas: TObjectList<TCatalogoSimpleDTO>);
    procedure MostrarUnidadesMedida(const AFilas: TObjectList<TUnidadMedidaDTO>);
    procedure MostrarUnidadesActivas(const AFilas: TObjectList<TUnidadMedidaDTO>);
    procedure MostrarTodos(const AFilas: TObjectList<TCatalogoItemDTO>);
    function CatalogoDeLaFila: TCatalogo;
    procedure MostrarCategorias(const ACategorias: TObjectList<TCategoriaDTO>);
    procedure MostrarFormularioItem(const ACatalogo: TCatalogo;
      const AId: Integer);
    procedure MostrarFormularioPrecio(const ACatalogo: TCatalogo;
      const AId: Integer);
    procedure MostrarHistorial(const ACatalogo: TCatalogo;
      const AFilas: TObjectList<TPrecioDTO>);
    function Confirmar(const AMensaje: string): Boolean;
  protected
    procedure Buscar(const ATexto: string); override;
    procedure Limpiar; override;
    procedure PaginaAnterior; override;
    procedure PaginaSiguiente; override;
    procedure MostrarCargando(const AActivo: Boolean); override;
    procedure Resize; override;
    function RejillaActiva: TrDBGrid; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.ColumnasRejilla,
  Anovo.Api.Catalogos,
  Anovo.Forms.ItemCatalogo,
  Anovo.Forms.PrecioCatalogo,
  Anovo.Forms.ImportacionCatalogo,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.UI.Vista,
  Anovo.Textos;

const
  CAMPO_ACCIONES = 'ACCIONES';
  CAMPO_ESTADO = 'ESTADO';

  ACCIONES: array [TAccionCatalogo] of TAccionRejilla = ((Clave: 'editar';
    Rotulo: SAccionEditar), (Clave: 'historial'; Rotulo: SAccionHistorial),
    (Clave: 'precio'; Rotulo: SAccionPrecio), (Clave: 'inactivar';
    Rotulo: SAccionInactivar));

function TituloDe(const ACatalogo: TCatalogo): string;
begin
  case ACatalogo of
    ctTodos:
      Result := SModuloCatalogos;
    ctManoObra:
      Result := SCatalogoManoObra;
    ctMaquinas:
      Result := SCatalogoMaquinas;
    ctTiposTrabajo:
      Result := SCatalogoTiposTrabajo;
    ctUnidadesMedida:
      Result := SCatalogoUnidadesMedida;
    ctTiposMaterial:
      Result := SCatalogoTiposMaterial;
    ctAcabados:
      Result := SCatalogoAcabados;
    ctFormasPago:
      Result := SCatalogoFormasPago;
  else
    Result := SCatalogoMateriales;
  end;
end;

function RotuloNuevoDe(const ACatalogo: TCatalogo): string;
begin
  case ACatalogo of
    ctManoObra:
      Result := SNuevaManoObra;
    ctMaquinas:
      Result := SNuevaMaquina;
    ctTiposTrabajo:
      Result := SNuevoTipoTrabajo;
    ctUnidadesMedida:
      Result := SNuevaUnidadMedida;
    ctTiposMaterial:
      Result := SNuevoTipoMaterial;
    ctAcabados:
      Result := SNuevoAcabado;
    ctFormasPago:
      Result := SNuevaFormaPago;
  else
    Result := SNuevoMaterial;
  end;
end;

function CatalogoDeTipo(const ATipo: string): TCatalogo;
begin
  if SameText(ATipo, TIPO_MANO_OBRA) then
    Result := ctManoObra
  else if SameText(ATipo, TIPO_MAQUINA) then
    Result := ctMaquinas
  else
    Result := ctMateriales;
end;

function PistaBusquedaDe(const ACatalogo: TCatalogo): string;
begin
  if ACatalogo in CATALOGOS_SIN_PRECIO then
    Result := SPistaBusquedaNombre
  else
    Result := SPistaBusquedaItem;
end;

constructor TfraCatalogos.Create(AOwner: TComponent);
var
  lGrid: TrDBGrid;
  lRejilla: TCeldasRejilla;
begin
  inherited Create(AOwner);
  FTextoSinRegistros := SSinRegistros;
  FTextoPaginacion := SPaginacionRegistros;
  FTextoSoloTotal := SRegistrosTotal;

  for lGrid in Rejillas do
  begin
    AplicarTemaGrid(lGrid);
    lRejilla := TCeldasRejilla.De(lGrid);
    lRejilla.ColumnaEstado(CAMPO_ESTADO);
    lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
    lRejilla.OnAccion := Accion;
  end;

  FPresentador := TPresentadorCatalogos.Create(Self, TApiCatalogos.Create);
  FPresentador.Iniciar;
end;

destructor TfraCatalogos.Destroy;
begin
  FreeAndNil(FPresentador);
  dmMemoria.mtCategorias.Close;
  dmMemoria.mtCatalogoSimple.Close;
  inherited;
end;

function TfraCatalogos.Rejillas: TArray<TrDBGrid>;
begin
  Result := [grTodos, grMateriales, grManoObra, grMaquinas, grTiposTrabajo,
    grUnidades, grSimples];
end;

function TfraCatalogos.TarjetaDe(const ACatalogo: TCatalogo): TCard;
begin
  case ACatalogo of
    ctTodos:
      Result := crdTodos;
    ctManoObra:
      Result := crdManoObra;
    ctMaquinas:
      Result := crdMaquinas;
    ctTiposTrabajo:
      Result := crdTiposTrabajo;
    ctUnidadesMedida:
      Result := crdUnidades;
    ctTiposMaterial, ctAcabados, ctFormasPago:
      Result := crdSimples;
  else
    Result := crdMateriales;
  end;
end;

function TfraCatalogos.RejillaActiva: TrDBGrid;
begin
  case FCatalogo of
    ctTodos:
      Result := grTodos;
    ctManoObra:
      Result := grManoObra;
    ctMaquinas:
      Result := grMaquinas;
    ctTiposTrabajo:
      Result := grTiposTrabajo;
    ctUnidadesMedida:
      Result := grUnidades;
    ctTiposMaterial, ctAcabados, ctFormasPago:
      Result := grSimples;
  else
    Result := grMateriales;
  end;
end;

function TfraCatalogos.IdDeLaFila: Integer;
begin
  Result := dmMemoria.IdFilaCatalogo;
end;

function TfraCatalogos.NombreDeLaFila: string;
begin
  Result := dmMemoria.NombreFilaCatalogo;
end;

procedure TfraCatalogos.Accion(Sender: TObject; const AClave: string);
var
  lId: Integer;
begin
  lId := IdDeLaFila;
  if lId = 0 then
    Exit;

  if SameText(AClave, ACCIONES[acEditar].Clave) then
    FPresentador.Editar(lId)
  else if SameText(AClave, ACCIONES[acHistorial].Clave) then
    FPresentador.VerHistorial(lId)
  else if SameText(AClave, ACCIONES[acPrecio].Clave) then
    FPresentador.CambiarPrecio(lId)
  else if SameText(AClave, ACCIONES[acInactivar].Clave) then
    FPresentador.Inactivar(lId);
end;

function TfraCatalogos.Confirmar(const AMensaje: string): Boolean;
begin
  Result := Anovo.UI.Vista.Confirmar(AMensaje);
end;

procedure TfraCatalogos.MostrarCatalogo(const ACatalogo: TCatalogo);
begin
  FCatalogo := ACatalogo;

  lblTitulo.Caption := TituloDe(ACatalogo);
  btnNuevo.Caption := RotuloNuevoDe(ACatalogo);
  sbBuscar.TextHint := PistaBusquedaDe(ACatalogo);

  cbCategoria.Visible := ACatalogo = ctManoObra;
  cbCategoria.KeyValue := 0;

  case ACatalogo of
    ctTodos:
      dmMemoria.dsCatalogo.DataSet := dmMemoria.mtTodos;
    ctManoObra:
      dmMemoria.dsCatalogo.DataSet := dmMemoria.mtManoObra;
    ctMaquinas:
      dmMemoria.dsCatalogo.DataSet := dmMemoria.mtMaquinas;
    ctTiposTrabajo:
      dmMemoria.dsCatalogo.DataSet := dmMemoria.mtTiposTrabajo;
    ctUnidadesMedida:
      dmMemoria.dsCatalogo.DataSet := dmMemoria.mtUnidadesLista;
    ctTiposMaterial, ctAcabados, ctFormasPago:
      dmMemoria.dsCatalogo.DataSet := dmMemoria.mtCatalogoSimple;
  else
    dmMemoria.dsCatalogo.DataSet := dmMemoria.mtMateriales;
  end;
  cpCatalogo.ActiveCard := TarjetaDe(ACatalogo);
end;

procedure TfraCatalogos.MostrarAcciones(const AAcciones: TAccionesCatalogo;
  const APuedeCrear: Boolean);
var
  lGrid: TrDBGrid;
begin
  btnNuevo.Visible := APuedeCrear;
  for lGrid in Rejillas do
    TCeldasRejilla.De(lGrid).PonerAcciones<TAccionesCatalogo>(ACCIONES,
      AAcciones);
end;

procedure TfraCatalogos.Cargar<T>(const AFilas: TObjectList<T>;
  const ATabla: TFDMemTable);
begin
  TMapeoDatos.AListaTabla<T>(AFilas, ATabla);
  TCeldasRejilla.De(RejillaActiva).AjustarColumnas;
end;

procedure TfraCatalogos.Resize;
begin
  inherited;
  Anovo.UI.CeldasRejilla.AjustarColumnas(RejillaActiva);
end;

procedure TfraCatalogos.Buscar(const ATexto: string);
begin
  FPresentador.Buscar(ATexto);
end;

procedure TfraCatalogos.Limpiar;
begin
  FPresentador.Limpiar;
end;

procedure TfraCatalogos.PaginaAnterior;
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraCatalogos.PaginaSiguiente;
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraCatalogos.MostrarCargando(const AActivo: Boolean);
begin
  FTextoCargando := Format(SCargandoCatalogo, [LowerCase(TituloDe(FCatalogo))]);
  inherited;
  cbCatalogo.Enabled := not AActivo;
  cbCategoria.Enabled := not AActivo;
end;

procedure TfraCatalogos.MostrarMateriales(const AFilas
  : TObjectList<TMaterialDTO>);
begin
  Cargar<TMaterialDTO>(AFilas, dmMemoria.mtMateriales);
end;

procedure TfraCatalogos.MostrarManoObra(const AFilas
  : TObjectList<TManoObraDTO>);
begin
  Cargar<TManoObraDTO>(AFilas, dmMemoria.mtManoObra);
end;

procedure TfraCatalogos.MostrarTodos(const AFilas
  : TObjectList<TCatalogoItemDTO>);
begin
  Cargar<TCatalogoItemDTO>(AFilas, dmMemoria.mtTodos);
end;

function TfraCatalogos.CatalogoDeLaFila: TCatalogo;
begin
  if dmMemoria.mtTodos.IsEmpty then
    Exit(ctMateriales);
  Result := CatalogoDeTipo(dmMemoria.mtTodosTIPO.AsString);
end;

procedure TfraCatalogos.MostrarMaquinas(const AFilas: TObjectList<TMaquinaDTO>);
begin
  Cargar<TMaquinaDTO>(AFilas, dmMemoria.mtMaquinas);
end;

procedure TfraCatalogos.MostrarTiposTrabajo(const AFilas
  : TObjectList<TTipoTrabajoDTO>);
begin
  Cargar<TTipoTrabajoDTO>(AFilas, dmMemoria.mtTiposTrabajo);
end;

procedure TfraCatalogos.MostrarSimples(const AFilas
  : TObjectList<TCatalogoSimpleDTO>);
begin
  Cargar<TCatalogoSimpleDTO>(AFilas, dmMemoria.mtCatalogoSimple);
end;

procedure TfraCatalogos.MostrarUnidadesMedida(const AFilas
  : TObjectList<TUnidadMedidaDTO>);
begin
  Cargar<TUnidadMedidaDTO>(AFilas, dmMemoria.mtUnidadesLista);
end;

procedure TfraCatalogos.MostrarUnidadesActivas(const AFilas
  : TObjectList<TUnidadMedidaDTO>);
begin
  TMapeoDatos.AListaTabla<TUnidadMedidaDTO>(AFilas, dmMemoria.mtUnidadesMedida);
end;

procedure TfraCatalogos.MostrarCategorias(const ACategorias
  : TObjectList<TCategoriaDTO>);
begin
  TMapeoDatos.AListaTabla<TCategoriaDTO>(ACategorias, dmMemoria.mtCategorias);
  cbCategoria.KeyValue := 0;
end;

procedure TfraCatalogos.MostrarFormularioItem(const ACatalogo: TCatalogo;
  const AId: Integer);
begin
  if TfrmItemCatalogo.Mostrar(Self, ACatalogo, AId) then
    FPresentador.Recargar;
end;

procedure TfraCatalogos.MostrarImportar(const AVisible, AHabilitado: Boolean);
begin
  btnImportar.Visible := AVisible;
  btnImportar.Enabled := AHabilitado;
end;

procedure TfraCatalogos.MostrarFormularioImportacion(
  const ACatalogo: TCatalogoImportacion);
begin
  if TfrmImportacionCatalogo.Mostrar(Self, ACatalogo) then
    FPresentador.Recargar;
end;

procedure TfraCatalogos.btnImportarClick(Sender: TObject);
begin
  FPresentador.Importar;
end;

procedure TfraCatalogos.MostrarFormularioPrecio(const ACatalogo: TCatalogo;
  const AId: Integer);
begin
  if TfrmPrecioCatalogo.Mostrar(Self, ACatalogo, AId, NombreDeLaFila, mpCambiar)
  then
    FPresentador.Recargar;
end;

procedure TfraCatalogos.MostrarHistorial(const ACatalogo: TCatalogo;
  const AFilas: TObjectList<TPrecioDTO>);
begin
  TMapeoDatos.AListaTabla<TPrecioDTO>(AFilas, dmMemoria.mtHistorialPrecio);
  TfrmPrecioCatalogo.Mostrar(Self, ACatalogo, 0, NombreDeLaFila, mpHistorial);
end;

procedure TfraCatalogos.cbCatalogoChange(Sender: TObject);
begin
  if not Assigned(FPresentador) then
    Exit;
  FPresentador.Filtrar(TCatalogo(cbCatalogo.ItemIndex));
end;

procedure TfraCatalogos.cbCategoriaClick(Sender: TObject);
begin
  if not Assigned(FPresentador) or VarIsNull(cbCategoria.KeyValue) then
    Exit;
  FPresentador.FiltrarCategoria(cbCategoria.KeyValue);
end;

procedure TfraCatalogos.btnNuevoClick(Sender: TObject);
begin
  FPresentador.Nuevo;
end;

procedure TfraCatalogos.btnExportarClick(Sender: TObject);
begin
  TColumnasRejilla.ExportarRejilla(RejillaActiva);
end;

end.
