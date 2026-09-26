unit Anovo.Frames.Catalogos;

// Catalogos (HU-05, lado escritorio): la vista de los cuatro listados.
//
// No decide nada. Pasa al presentador la pestana, el texto, la categoria y la
// pagina, y muestra lo que el presentador le manda. Que acciones y botones se
// ven tambien lo decide el presentador, con los permisos.
//
// Una sola rejilla para los cuatro catalogos: dsCatalogo apunta a la tabla de
// la pestana activa. Cuatro rejillas superpuestas serian cuatro juegos de
// columnas que mantener.
//
// Las listas de DTO que llegan del presentador se copian a dmMemoria y se
// liberan alla: la vista no guarda objetos que no son suyos.

interface

uses
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXCtrls, Vcl.WinXPanels,
  Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
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
    procedure MarcarEstados(const ATabla: TDataSet);
    procedure AjustarColumnas;
    procedure TipoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    // IVistaCatalogos
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
  // Tipos de trabajo no lleva precio, asi que tampoco esta columna: por eso
  // se busca con FindField y no con FieldByName.
  CAMPO_PROGRAMADO = 'PROGRAMADO_FECHA';

  // Mismo orden que TAccionCatalogo. La clave es la que llega a Accion.
  ACCIONES: array [TAccionCatalogo] of TAccionRejilla =
    ((Clave: 'editar'; Rotulo: 'Editar'),
    (Clave: 'historial'; Rotulo: 'Historial'),
    (Clave: 'precio'; Rotulo: 'Precio'),
    (Clave: 'inactivar'; Rotulo: 'Inactivar'));

  // Lo que la pastilla muestra. En la tabla se guarda el booleano tal como
  // vino; esto es solo para el dibujo, que pinta texto y no un si o un no.
  ESTADO_ACTIVO = 'activo';
  ESTADO_INACTIVO = 'inactivo';
  // Activo, pero con un cambio de precio esperando fecha. Gana sobre 'activo'
  // porque es lo que hay que saber ahora: el precio que se ve va a cambiar.
  ESTADO_PROGRAMADO = 'programado';

// Lo que se lee arriba, en el boton y en la caja de busqueda, por pestana.
// Funciones y no arreglos const: el texto vive en Anovo.Textos como
// resourcestring, y un resourcestring no sirve en una expresion constante.

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

// El codigo que manda el backend en la columna TIPO, pasado al catalogo del
// escritorio. Un codigo que no se conoce cae en materiales: si el backend
// agregara un tipo nuevo sin que el escritorio se entere, mejor abrir una
// ventana equivocada que reventar; y los tres codigos salen de la misma unidad
// de DTO que compilan los dos, asi que no deberian desalinearse.
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
  // Tipos de trabajo solo tiene nombre: no hay codigo ni descripcion donde
  // buscar.
  if ACatalogo = ctTiposTrabajo then
    Result := SPistaBusquedaNombre
  else
    Result := SPistaBusquedaItem;
end;

constructor TfraCatalogos.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grDatos);
  dmMemoria.mtTodosTIPO.OnGetText := TipoGetText;
  FPresentador := TPresentadorCatalogos.Create(Self, TApiCatalogos.Create);
  FPresentador.Iniciar;
end;

destructor TfraCatalogos.Destroy;
begin
  // dmMemoria vive mas que el frame: si el campo se quedara con el evento, la
  // proxima vez que alguien lo dibujara llamaria a un objeto ya liberado.
  dmMemoria.mtTodosTIPO.OnGetText := nil;
  FPresentador.Free;
  inherited;
end;

// Apoyo

function TfraCatalogos.IdDeLaFila: Integer;
begin
  // La rejilla ya movio el cursor a la fila pulsada: el ID es el de esa fila.
  Result := 0;
  if (dmMemoria.dsCatalogo.DataSet = nil) or
    dmMemoria.dsCatalogo.DataSet.IsEmpty then
    Exit;
  Result := dmMemoria.dsCatalogo.DataSet.FieldByName('ID').AsInteger;
end;

procedure TfraCatalogos.MarcarEstados(const ATabla: TDataSet);
var
  lProgramado: TField;
begin
  // El DTO trae ACTIVO como booleano y la pastilla dibuja texto, asi que el
  // texto se deriva aqui, despues de copiar las filas.
  lProgramado := ATabla.FindField(CAMPO_PROGRAMADO);

  ATabla.DisableControls;
  try
    ATabla.First;
    while not ATabla.Eof do
    begin
      ATabla.Edit;
      if not ATabla.FieldByName('ACTIVO').AsBoolean then
        ATabla.FieldByName(CAMPO_ESTADO).AsString := ESTADO_INACTIVO
      else if (lProgramado <> nil) and not lProgramado.IsNull then
        ATabla.FieldByName(CAMPO_ESTADO).AsString := ESTADO_PROGRAMADO
      else
        ATabla.FieldByName(CAMPO_ESTADO).AsString := ESTADO_ACTIVO;
      ATabla.Post;
      ATabla.Next;
    end;
    ATabla.First;
  finally
    ATabla.EnableControls;
  end;
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
    // Se confirma aqui y no en el presentador: preguntar es cosa de la
    // pantalla, y el presentador no sabe de ventanas.
    if MessageDlg(SConfirmarInactivar, mtConfirmation, [mbYes, mbNo], 0)
      = mrYes then
      FPresentador.Inactivar(lId);
end;

// IVistaCatalogos

procedure TfraCatalogos.MostrarCatalogo(const ACatalogo: TCatalogo);
begin
  FCatalogo := ACatalogo;

  lblTitulo.Caption := TituloDe(ACatalogo);
  btnNuevo.Caption := RotuloNuevoDe(ACatalogo);
  sbBuscar.TextHint := PistaBusquedaDe(ACatalogo);

  // La categoria solo existe en mano de obra.
  cbCategoria.Visible := ACatalogo = ctManoObra;

  // Tipos de trabajo trae la lista entera: el buscador no tiene a quien
  // preguntarle.
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
  // Las columnas no se declaran aqui: salen de los campos visibles del dataset,
  // en el orden en que estan en dmMemoria, con su DisplayLabel de titulo. Cada
  // mtXxx dice que se ve y que no; el ancho lo pone AjustarColumnas midiendo lo
  // que llego. Con csDefault la rejilla las vuelve a armar al cambiar de tabla.
  grDatos.Columns.State := csDefault;
end;

procedure TfraCatalogos.MostrarAcciones(const AAcciones: TAccionesCatalogo;
  const APuedeCrear: Boolean);
var
  lAccion: TAccionCatalogo;
  lRejilla: TDBGridExtend;
begin
  btnNuevo.Visible := APuedeCrear;

  // El dibujo es del TDBGridExtend que AplicarTemaGrid le dejo a la rejilla:
  // aqui solo se le dice que columnas son suyas.
  lRejilla := TDBGridExtend.De(grDatos);
  // Limpiar primero: esto se llama en cada cambio de pestana y si no, los
  // botones se van sumando.
  lRejilla.Limpiar;
  lRejilla.ColumnaEstado(CAMPO_ESTADO);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  for lAccion in AAcciones do
    lRejilla.Agregar(ACCIONES[lAccion].Clave, ACCIONES[lAccion].Rotulo);
  lRejilla.OnAccion := Accion;

  AjustarColumnas;
end;

procedure TfraCatalogos.AjustarColumnas;
var
  lRejilla: TDBGridExtend;
  I: Integer;
begin
  // La rejilla arma sus columnas sola a partir del dataset, y lo rehace cada
  // vez que llegan filas nuevas. Por eso esto corre despues de cargar y no
  // solo al declarar las acciones: al declararlas la tabla todavia esta
  // vacia y no hay columnas que ajustar.
  lRejilla := TDBGridExtend.De(grDatos);
  for I := 0 to grDatos.Columns.Count - 1 do
    if SameText(grDatos.Columns[I].FieldName, CAMPO_ACCIONES) then
    begin
      grDatos.Columns[I].Visible := lRejilla.AnchoAcciones > 0;
      grDatos.Columns[I].Width := lRejilla.AnchoAcciones;
    end;

  // Las columnas se miden contra lo que trajo la pagina y se reparten el ancho
  // de la rejilla. Con la unidad delante porque este metodo se llama igual.
  Anovo.UI.DBGridExtend.AjustarColumnas(grDatos);
end;

procedure TfraCatalogos.Resize;
begin
  inherited;
  OcultarScrollVertical(grDatos);
  // Al agrandar o achicar la ventana, las columnas se vuelven a repartir el
  // ancho. Sin datos cargados no hace nada: la rutina lo revisa.
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
  TMapeoDatos.AListaTabla<TMaterialDTO>(AFilas, dmMemoria.mtMateriales);
  MarcarEstados(dmMemoria.mtMateriales);
  AjustarColumnas;
end;

procedure TfraCatalogos.MostrarManoObra(const AFilas
  : TObjectList<TManoObraDTO>);
begin
  TMapeoDatos.AListaTabla<TManoObraDTO>(AFilas, dmMemoria.mtManoObra);
  MarcarEstados(dmMemoria.mtManoObra);
  AjustarColumnas;
end;

procedure TfraCatalogos.MostrarTodos(const AFilas
  : TObjectList<TCatalogoItemDTO>);
begin
  TMapeoDatos.AListaTabla<TCatalogoItemDTO>(AFilas, dmMemoria.mtTodos);
  MarcarEstados(dmMemoria.mtTodos);
  AjustarColumnas;
end;

function TfraCatalogos.CatalogoDeLaFila: TCatalogo;
begin
  if dmMemoria.mtTodos.IsEmpty then
    Exit(ctMateriales);
  // AsString y no Text: Text pasa por TipoGetText y trae el rotulo, no el
  // codigo.
  Result := CatalogoDeTipo(dmMemoria.mtTodosTIPO.AsString);
end;

procedure TfraCatalogos.TipoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  // La columna guarda el codigo que viaja en el JSON; en pantalla se lee el
  // nombre del catalogo.
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
  TMapeoDatos.AListaTabla<TMaquinaDTO>(AFilas, dmMemoria.mtMaquinas);
  MarcarEstados(dmMemoria.mtMaquinas);
  AjustarColumnas;
end;

procedure TfraCatalogos.MostrarTiposTrabajo(const AFilas
  : TObjectList<TTipoTrabajoDTO>);
begin
  TMapeoDatos.AListaTabla<TTipoTrabajoDTO>(AFilas, dmMemoria.mtTiposTrabajo);
  MarcarEstados(dmMemoria.mtTiposTrabajo);
  AjustarColumnas;
end;

procedure TfraCatalogos.MostrarCategorias(const ACategorias
  : TObjectList<TCategoriaDTO>);
var
  lCategoria: TCategoriaDTO;
begin
  cbCategoria.Items.BeginUpdate;
  try
    cbCategoria.Items.Clear;
    // El objeto queda guardado en el item: al filtrar hace falta el id, no el
    // texto.
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
  // Las categorias ya estan en el desplegable de la barra: se le prestan a la
  // ventana en vez de volver a pedirlas.
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
  // La lista es del presentador y se libera al volver: se copia a la tabla
  // antes de abrir la ventana.
  TMapeoDatos.AListaTabla<TPrecioDTO>(AFilas, dmMemoria.mtHistorialPrecio);
  MarcarEstados(dmMemoria.mtHistorialPrecio);
  // En Todos, FCatalogo no dice de que es la fila; la ventana lo necesita
  // para saber que columnas de precio mostrar.
  if FCatalogo = ctTodos then
    TfrmPrecioCatalogo.Mostrar(Self, CatalogoDeLaFila, 0, NombreDeLaFila,
      mpHistorial)
  else
    TfrmPrecioCatalogo.Mostrar(Self, FCatalogo, 0, NombreDeLaFila,
      mpHistorial);
end;

// Eventos


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
  // Llega antes de que el presentador exista, mientras se carga el .dfm.
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
  // Exporta lo que la rejilla tiene cargado, que es la pagina actual. Traer
  // el catalogo entero antes de exportar esta pendiente.
  rDBExport.DBExport(grDatos, True, True);
end;

end.
