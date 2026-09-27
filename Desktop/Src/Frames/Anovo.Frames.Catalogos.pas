unit Anovo.Frames.Catalogos;

// Seccion Catalogos (HU-05): los listados y la lista Todos.

interface

uses
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXCtrls, Vcl.WinXPanels,
  Data.DB, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  FlatVcl.BotonWin, VclPlano.Pestanas, VclPlano.BotonWin,
  Anovo.DTOs.Catalogos,
  Anovo.Vistas.Intf.Catalogos,
  Anovo.Presentadores.Catalogos;

type
  TfraCatalogos = class(TFrame, IVistaCatalogos)
    pnlBarra: TPanel;
    sbBuscar: TSearchBox;
    btnExportar: TPlanoBotonWin;
    btnNuevo: TPlanoBotonWin;
    btnLimpiar: TPlanoBotonWin;
    cbCategoria: TComboBox;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pstCatalogo: TPlanoPestanas;
    pnclient: TRelativePanel;
    grDatos: TrDBGrid;
    pnlPie: TPanel;
    lblPaginacion: TLabel;
    btnAnterior: TPlanoBotonWin;
    btnSiguiente: TPlanoBotonWin;
    procedure sbBuscarInvokeSearch(Sender: TObject);
    procedure btnLimpiarClick(Sender: TObject);
    procedure pstCatalogoChange(Sender: TObject);
    procedure cbCategoriaChange(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnSiguienteClick(Sender: TObject);
    procedure btnNuevoClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);

  private
    FPresentador: TPresentadorCatalogos;
    FCatalogo: TCatalogo;
    procedure Accion(Sender: TObject; const AClave: string);
    function IdDeLaFila: Integer;
    function NombreDeLaFila: string;
    procedure Cargar<T: class>(const AFilas: TObjectList<T>;
      const ATabla: TFDMemTable);
    procedure TipoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure MostrarCatalogo(const ACatalogo: TCatalogo);
    procedure MostrarAcciones(const AAcciones: TAccionesCatalogo;
      const APuedeCrear: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarMateriales(const AFilas: TObjectList<TMaterialDTO>);
    procedure MostrarManoObra(const AFilas: TObjectList<TManoObraDTO>);
    procedure MostrarMaquinas(const AFilas: TObjectList<TMaquinaDTO>);
    procedure MostrarTiposTrabajo(const AFilas: TObjectList<TTipoTrabajoDTO>);
    procedure MostrarTodos(const AFilas: TObjectList<TCatalogoItemDTO>);
    function CatalogoDeLaFila: TCatalogo;
    procedure MostrarCategorias(const ACategorias: TObjectList<TCategoriaDTO>);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarFormularioItem(const ACatalogo: TCatalogo;
      const AId: Integer);
    procedure MostrarFormularioPrecio(const ACatalogo: TCatalogo;
      const AId: Integer);
    procedure MostrarHistorial(const AFilas: TObjectList<TPrecioDTO>);
  protected
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

type
  TAccionRejilla = record
    Clave: string;
    Rotulo: string;
  end;

const
  CAMPO_ACCIONES = 'ACCIONES';
  CAMPO_ESTADO = 'ESTADO';

  ACCIONES: array [TAccionCatalogo] of TAccionRejilla =
    ((Clave: 'editar'; Rotulo: 'Editar'),
    (Clave: 'historial'; Rotulo: 'Historial'),
    (Clave: 'precio'; Rotulo: 'Precio'),
    (Clave: 'inactivar'; Rotulo: 'Inactivar'));

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
  if ACatalogo = ctTiposTrabajo then
    Result := SPistaBusquedaNombre
  else
    Result := SPistaBusquedaItem;
end;

constructor TfraCatalogos.Create(AOwner: TComponent);
var
  lRejilla: TDBGridExtend;
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grDatos);
  dmMemoria.mtTodosTIPO.OnGetText := TipoGetText;

  lRejilla := TDBGridExtend.De(grDatos);
  lRejilla.ColumnaEstado(CAMPO_ESTADO);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := Accion;

  FPresentador := TPresentadorCatalogos.Create(Self, TApiCatalogos.Create);
  FPresentador.Iniciar;
end;

destructor TfraCatalogos.Destroy;
begin
  dmMemoria.mtTodosTIPO.OnGetText := nil;
  FPresentador.Free;
  inherited;
end;

function TfraCatalogos.IdDeLaFila: Integer;
begin
  Result := 0;
  if (dmMemoria.dsCatalogo.DataSet = nil) or
    dmMemoria.dsCatalogo.DataSet.IsEmpty then
    Exit;
  Result := dmMemoria.dsCatalogo.DataSet.FieldByName('ID').AsInteger;
end;

function TfraCatalogos.NombreDeLaFila: string;
var
  lTabla: TDataSet;
begin
  Result := '';
  lTabla := dmMemoria.dsCatalogo.DataSet;
  if (lTabla = nil) or lTabla.IsEmpty then
    Exit;
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
    if MessageDlg(SConfirmarInactivar, mtConfirmation, [mbYes, mbNo], 0)
      = mrYes then
      FPresentador.Inactivar(lId);
end;

procedure TfraCatalogos.MostrarCatalogo(const ACatalogo: TCatalogo);
begin
  FCatalogo := ACatalogo;

  lblTitulo.Caption := TituloDe(ACatalogo);
  btnNuevo.Caption := RotuloNuevoDe(ACatalogo);
  sbBuscar.TextHint := PistaBusquedaDe(ACatalogo);

  cbCategoria.Visible := ACatalogo = ctManoObra;

  sbBuscar.Visible := ACatalogo <> ctTiposTrabajo;

  case ACatalogo of
    ctTodos:
      dmMemoria.dsCatalogo.DataSet := dmMemoria.mtTodos;
    ctManoObra:
      dmMemoria.dsCatalogo.DataSet := dmMemoria.mtManoObra;
    ctMaquinas:
      dmMemoria.dsCatalogo.DataSet := dmMemoria.mtMaquinas;
    ctTiposTrabajo:
      dmMemoria.dsCatalogo.DataSet := dmMemoria.mtTiposTrabajo;
  else
    dmMemoria.dsCatalogo.DataSet := dmMemoria.mtMateriales;
  end;
  grDatos.DataSource := dmMemoria.dsCatalogo;
  grDatos.Columns.State := csDefault;
end;

procedure TfraCatalogos.MostrarAcciones(const AAcciones: TAccionesCatalogo;
  const APuedeCrear: Boolean);
var
  lAccion: TAccionCatalogo;
  lRejilla: TDBGridExtend;
begin
  btnNuevo.Visible := APuedeCrear;

  lRejilla := TDBGridExtend.De(grDatos);
  lRejilla.Limpiar;
  for lAccion in AAcciones do
    lRejilla.Agregar(ACCIONES[lAccion].Clave, ACCIONES[lAccion].Rotulo);
  lRejilla.AjustarColumnas;
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
  OcultarScrollVertical(grDatos);
  Anovo.UI.DBGridExtend.AjustarColumnas(grDatos);
end;

procedure TfraCatalogos.MostrarCargando(const AActivo: Boolean);
begin
  if AActivo then
  begin
    lblPaginacion.Caption := Format(SCargandoCatalogo,
      [LowerCase(TituloDe(FCatalogo))]);
    Screen.Cursor := crAppStart;
  end
  else
    Screen.Cursor := crDefault;
  sbBuscar.Enabled := not AActivo;
  pstCatalogo.Enabled := not AActivo;
end;

procedure TfraCatalogos.MostrarBusqueda(const ATexto: string;
  const APuedeLimpiar: Boolean);
begin
  if sbBuscar.Text <> ATexto then
    sbBuscar.Text := ATexto;
  btnLimpiar.Visible := APuedeLimpiar;
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

procedure TfraCatalogos.TipoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  case CatalogoDeTipo(Sender.AsString) of
    ctManoObra:
      Text := STipoManoObra;
    ctMaquinas:
      Text := STipoMaquina;
  else
    Text := STipoMaterial;
  end;
end;

procedure TfraCatalogos.MostrarMaquinas(const AFilas
  : TObjectList<TMaquinaDTO>);
begin
  Cargar<TMaquinaDTO>(AFilas, dmMemoria.mtMaquinas);
end;

procedure TfraCatalogos.MostrarTiposTrabajo(const AFilas
  : TObjectList<TTipoTrabajoDTO>);
begin
  Cargar<TTipoTrabajoDTO>(AFilas, dmMemoria.mtTiposTrabajo);
end;

procedure TfraCatalogos.MostrarCategorias(const ACategorias
  : TObjectList<TCategoriaDTO>);
var
  lCategoria: TCategoriaDTO;
begin
  cbCategoria.Items.BeginUpdate;
  try
    cbCategoria.Items.Clear;
    cbCategoria.Items.AddObject(STodasLasCategorias,
      TObject(0));
    for lCategoria in ACategorias do
      cbCategoria.Items.AddObject(lCategoria.Nombre,
        TObject(lCategoria.ID));
    cbCategoria.ItemIndex := 0;
  finally
    cbCategoria.Items.EndUpdate;
  end;
end;

procedure TfraCatalogos.MostrarPaginacion(const APagina,
  ATotalPaginas: Integer; const ATotal: Int64);
begin
  if ATotal = 0 then
    lblPaginacion.Caption := SSinRegistros
  else if ATotalPaginas = 0 then
    lblPaginacion.Caption := Format(SRegistrosTotal, [ATotal])
  else
    lblPaginacion.Caption := Format(SPaginacionRegistros,
      [ATotal, APagina, ATotalPaginas]);

  btnAnterior.Enabled := APagina > 1;
  btnSiguiente.Enabled := APagina < ATotalPaginas;
end;

procedure TfraCatalogos.MostrarError(const AMensaje: string);
begin
  MessageDlg(AMensaje, mtError, [mbOK], 0);
end;

procedure TfraCatalogos.MostrarFormularioItem(const ACatalogo: TCatalogo;
  const AId: Integer);
begin
  if TfrmItemCatalogo.Mostrar(Self, ACatalogo, AId, cbCategoria.Items) then
    FPresentador.Recargar;
end;

procedure TfraCatalogos.MostrarFormularioPrecio(const ACatalogo: TCatalogo;
  const AId: Integer);
begin
  if TfrmPrecioCatalogo.Mostrar(Self, ACatalogo, AId, NombreDeLaFila,
    mpCambiar) then
    FPresentador.Recargar;
end;

procedure TfraCatalogos.MostrarHistorial(const AFilas
  : TObjectList<TPrecioDTO>);
begin
  TMapeoDatos.AListaTabla<TPrecioDTO>(AFilas, dmMemoria.mtHistorialPrecio);
  if FCatalogo = ctTodos then
    TfrmPrecioCatalogo.Mostrar(Self, CatalogoDeLaFila, 0, NombreDeLaFila,
      mpHistorial)
  else
    TfrmPrecioCatalogo.Mostrar(Self, FCatalogo, 0, NombreDeLaFila,
      mpHistorial);
end;

procedure TfraCatalogos.sbBuscarInvokeSearch(Sender: TObject);
begin
  FPresentador.Buscar(sbBuscar.Text);
end;

procedure TfraCatalogos.btnLimpiarClick(Sender: TObject);
begin
  FPresentador.Limpiar;
end;

procedure TfraCatalogos.pstCatalogoChange(Sender: TObject);
begin
  if not Assigned(FPresentador) then
    Exit;
  FPresentador.Filtrar(TCatalogo(pstCatalogo.ItemIndex));
end;

procedure TfraCatalogos.cbCategoriaChange(Sender: TObject);
begin
  if not Assigned(FPresentador) then
    Exit;
  if cbCategoria.ItemIndex < 0 then
    Exit;
  FPresentador.FiltrarCategoria
    (Integer(cbCategoria.Items.Objects[cbCategoria.ItemIndex]));
end;

procedure TfraCatalogos.btnAnteriorClick(Sender: TObject);
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraCatalogos.btnSiguienteClick(Sender: TObject);
begin
  FPresentador.PaginaSiguiente;
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
