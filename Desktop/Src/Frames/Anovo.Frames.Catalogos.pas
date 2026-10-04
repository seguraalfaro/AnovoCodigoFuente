unit Anovo.Frames.Catalogos;

// Seccion Catalogos (HU-05): los listados y la lista Todos.

interface

uses
  Anovo.UI.DBGridExtend,
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXCtrls, Vcl.WinXPanels,
  Data.DB, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, rDBGrid,
  rDBComponents,
  FlatVcl.BotonWin, VclPlano.Pestanas, VclPlano.BotonWin,
  Anovo.Frames.Listado,
  Anovo.DTOs.Catalogos,
  Anovo.Vistas.Intf.Catalogos,
  Anovo.Presentadores.Catalogos;

type
  TfraCatalogos = class(TfraListado, IVistaCatalogos)
    btnExportar: TPlanoBotonWin;
    btnNuevo: TPlanoBotonWin;
    cbCategoria: TrDBLookupComboBox;
    pstCatalogo: TPlanoPestanas;
    procedure pstCatalogoChange(Sender: TObject);
    procedure cbCategoriaClick(Sender: TObject);
    procedure btnNuevoClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
  private
    FPresentador: TPresentadorCatalogos;
    FCatalogo: TCatalogo;
    procedure Accion(Sender: TObject; const AClave: string);
    function TablaActual: TDataSet;
    function IdDeLaFila: Integer;
    function NombreDeLaFila: string;
    procedure Cargar<T: class>(const AFilas: TObjectList<T>;
      const ATabla: TFDMemTable);
    procedure MostrarCatalogo(const ACatalogo: TCatalogo);
    procedure MostrarAcciones(const AAcciones: TAccionesCatalogo;
      const APuedeCrear: Boolean);
    procedure MostrarMateriales(const AFilas: TObjectList<TMaterialDTO>);
    procedure MostrarManoObra(const AFilas: TObjectList<TManoObraDTO>);
    procedure MostrarMaquinas(const AFilas: TObjectList<TMaquinaDTO>);
    procedure MostrarTiposTrabajo(const AFilas: TObjectList<TTipoTrabajoDTO>);
    procedure MostrarUnidadesMedida(const AFilas: TObjectList<TUnidadMedidaDTO>);
    procedure MostrarUnidadesActivas(const AFilas: TObjectList<TUnidadMedidaDTO>);
    procedure MostrarTodos(const AFilas: TObjectList<TCatalogoItemDTO>);
    function CatalogoDeLaFila: TCatalogo;
    procedure MostrarCategorias(const ACategorias: TObjectList<TCategoriaDTO>);
    procedure MostrarFormularioItem(const ACatalogo: TCatalogo;
      const AId: Integer);
    procedure MostrarFormularioPrecio(const ACatalogo: TCatalogo;
      const AId: Integer);
    procedure MostrarHistorial(const AFilas: TObjectList<TPrecioDTO>);
  protected
    procedure Buscar(const ATexto: string); override;
    procedure Limpiar; override;
    procedure PaginaAnterior; override;
    procedure PaginaSiguiente; override;
    procedure MostrarCargando(const AActivo: Boolean); override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  rDBExport,
  Anovo.Api.Catalogos,
  Anovo.Forms.ItemCatalogo,
  Anovo.Forms.PrecioCatalogo,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
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
      Result := SCatalogoTodos;
    ctManoObra:
      Result := SCatalogoManoObra;
    ctMaquinas:
      Result := SCatalogoMaquinas;
    ctTiposTrabajo:
      Result := SCatalogoTiposTrabajo;
    ctUnidadesMedida:
      Result := SCatalogoUnidadesMedida;
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
  if ACatalogo in [ctTiposTrabajo, ctUnidadesMedida] then
    Result := SPistaBusquedaNombre
  else
    Result := SPistaBusquedaItem;
end;

constructor TfraCatalogos.Create(AOwner: TComponent);
var
  lRejilla: TDBGridExtend;
begin
  inherited Create(AOwner);
  FTextoSinRegistros := SSinRegistros;
  FTextoPaginacion := SPaginacionRegistros;
  FTextoSoloTotal := SRegistrosTotal;

  lRejilla := TDBGridExtend.De(grDatos);
  lRejilla.ColumnaEstado(CAMPO_ESTADO);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := Accion;

  FPresentador := TPresentadorCatalogos.Create(Self, TApiCatalogos.Create);
  FPresentador.Iniciar;
end;

destructor TfraCatalogos.Destroy;
begin
  FPresentador.Free;
  dmMemoria.mtCategorias.Close;
  inherited;
end;

function TfraCatalogos.TablaActual: TDataSet;
begin
  Result := dmMemoria.dsCatalogo.DataSet;
end;

function TfraCatalogos.IdDeLaFila: Integer;
var
  lTabla: TDataSet;
begin
  lTabla := TablaActual;
  if lTabla.IsEmpty then
    Exit(0);
  Result := lTabla.FieldByName('ID').AsInteger;
end;

function TfraCatalogos.NombreDeLaFila: string;
var
  lTabla: TDataSet;
begin
  lTabla := TablaActual;

  if lTabla.IsEmpty then
    Exit('');
  Result := lTabla.FieldByName('NOMBRE').AsString;
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
    if MessageDlg(SConfirmarInactivar, mtConfirmation, [mbYes, mbNo], 0) = mrYes
    then
      FPresentador.Inactivar(lId);
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
  else
    dmMemoria.dsCatalogo.DataSet := dmMemoria.mtMateriales;
  end;
  grDatos.DataSource := dmMemoria.dsCatalogo;
  grDatos.Columns.State := csDefault;
end;

procedure TfraCatalogos.MostrarAcciones(const AAcciones: TAccionesCatalogo;
  const APuedeCrear: Boolean);
begin
  btnNuevo.Visible := APuedeCrear;
  TDBGridExtend.De(grDatos).PonerAcciones<TAccionesCatalogo>(ACCIONES,
    AAcciones);
end;

procedure TfraCatalogos.Cargar<T>(const AFilas: TObjectList<T>;
  const ATabla: TFDMemTable);
begin
  TMapeoDatos.AListaTabla<T>(AFilas, ATabla);
  TDBGridExtend.De(grDatos).AjustarColumnas;
end;

procedure TfraCatalogos.Resize;
begin
  inherited;
  Anovo.UI.DBGridExtend.AjustarColumnas(grDatos);
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
  pstCatalogo.Enabled := not AActivo;
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

procedure TfraCatalogos.MostrarFormularioPrecio(const ACatalogo: TCatalogo;
  const AId: Integer);
begin
  if TfrmPrecioCatalogo.Mostrar(Self, ACatalogo, AId, NombreDeLaFila, mpCambiar)
  then
    FPresentador.Recargar;
end;

procedure TfraCatalogos.MostrarHistorial(const AFilas: TObjectList<TPrecioDTO>);
begin
  TMapeoDatos.AListaTabla<TPrecioDTO>(AFilas, dmMemoria.mtHistorialPrecio);
  if FCatalogo = ctTodos then
    TfrmPrecioCatalogo.Mostrar(Self, CatalogoDeLaFila, 0, NombreDeLaFila,
      mpHistorial)
  else
    TfrmPrecioCatalogo.Mostrar(Self, FCatalogo, 0, NombreDeLaFila, mpHistorial);
end;

procedure TfraCatalogos.pstCatalogoChange(Sender: TObject);
begin
  if not Assigned(FPresentador) then
    Exit;
  FPresentador.Filtrar(TCatalogo(pstCatalogo.ItemIndex));
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
  rDBExport.DBExport(grDatos, True, True);
end;

end.
