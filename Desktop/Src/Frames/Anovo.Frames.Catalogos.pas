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
    pnbottom: TRelativePanel;
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
    procedure ArmarColumnas(const ACatalogo: TCatalogo);
    procedure AjustarColumnas;
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
  Anovo.Datos.Memoria;

type
  TAccionRejilla = record
    Clave: string;
    Rotulo: string;
  end;

const
  CAMPO_ACCIONES = 'ACCIONES';
  CAMPO_ESTADO = 'ESTADO';

  // Mismo orden que TAccionCatalogo. La clave es la que llega a Accion.
  ACCIONES: array [TAccionCatalogo] of TAccionRejilla =
    ((Clave: 'editar'; Rotulo: 'Editar'),
    (Clave: 'historial'; Rotulo: 'Historial'),
    (Clave: 'precio'; Rotulo: 'Precio'),
    (Clave: 'inactivar'; Rotulo: 'Inactivar'));

  // Lo que se lee arriba y en el boton, por pestana.
  TITULOS: array [TCatalogo] of string = ('Materiales', 'Mano de obra',
    'M' + #225 + 'quinas', 'Tipos de trabajo');
  ROTULO_NUEVO: array [TCatalogo] of string = ('+ Nuevo material',
    '+ Nueva mano de obra', '+ Nueva m' + #225 + 'quina',
    '+ Nuevo tipo de trabajo');
  PISTA_BUSQUEDA: array [TCatalogo] of string =
    ('C' + #243 + 'digo, nombre o descripci' + #243 + 'n',
    'C' + #243 + 'digo, nombre o descripci' + #243 + 'n',
    'C' + #243 + 'digo, nombre o descripci' + #243 + 'n', 'Nombre');

  // Lo que la pastilla muestra. En la tabla se guarda el booleano tal como
  // vino; esto es solo para el dibujo, que pinta texto y no un si o un no.
  ESTADO_ACTIVO = 'activo';
  ESTADO_INACTIVO = 'inactivo';

constructor TfraCatalogos.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grDatos);
  FPresentador := TPresentadorCatalogos.Create(Self, TApiCatalogos.Create);
  FPresentador.Iniciar;
end;

destructor TfraCatalogos.Destroy;
begin
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
begin
  // El DTO trae ACTIVO como booleano y la pastilla dibuja texto, asi que el
  // texto se deriva aqui, despues de copiar las filas.
  ATabla.DisableControls;
  try
    ATabla.First;
    while not ATabla.Eof do
    begin
      ATabla.Edit;
      if ATabla.FieldByName('ACTIVO').AsBoolean then
        ATabla.FieldByName(CAMPO_ESTADO).AsString := ESTADO_ACTIVO
      else
        ATabla.FieldByName(CAMPO_ESTADO).AsString := ESTADO_INACTIVO;
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
    if MessageDlg('Se va a inactivar el registro seleccionado. ' +
      'No se borra: las cotizaciones anteriores lo siguen nombrando.' +
      sLineBreak + sLineBreak + 'Continuar?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
      FPresentador.Inactivar(lId);
end;

// IVistaCatalogos

procedure TfraCatalogos.MostrarCatalogo(const ACatalogo: TCatalogo);
begin
  FCatalogo := ACatalogo;

  lblTitulo.Caption := TITULOS[ACatalogo];
  btnNuevo.Caption := ROTULO_NUEVO[ACatalogo];
  sbBuscar.TextHint := PISTA_BUSQUEDA[ACatalogo];

  // La categoria solo existe en mano de obra.
  cbCategoria.Visible := ACatalogo = ctManoObra;

  // Tipos de trabajo trae la lista entera: el buscador no tiene a quien
  // preguntarle.
  sbBuscar.Visible := ACatalogo <> ctTiposTrabajo;

  case ACatalogo of
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
  ArmarColumnas(ACatalogo);
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

procedure TfraCatalogos.ArmarColumnas(const ACatalogo: TCatalogo);

  procedure Columna(const ACampo: string; const AAncho: Integer);
  var
    lColumna: TColumn;
  begin
    lColumna := grDatos.Columns.Add;
    lColumna.FieldName := ACampo;
    lColumna.Width := AAncho;
  end;

begin
  // Por codigo y no en el .dfm como en clientes: una sola rejilla sirve a las
  // cuatro pestanas y cada una necesita sus columnas. Sin titulo, que lo pone
  // el DisplayLabel del campo en dmMemoria y asi no vive en dos sitios.
  grDatos.Columns.Clear;
  case ACatalogo of
    ctManoObra:
      begin
        Columna('CODIGO', 90);
        Columna('NOMBRE', 220);
        Columna('CATEGORIA_NOMBRE', 130);
        Columna('UNIDAD_MEDIDA', 80);
        Columna('COSTO_UNITARIO', 100);
        Columna('FECHA_VIGENCIA', 100);
      end;
    ctMaquinas:
      begin
        Columna('CODIGO', 90);
        Columna('NOMBRE', 220);
        Columna('DESCRIPCION', 200);
        Columna('COSTO_HORA', 110);
        Columna('FECHA_VIGENCIA', 100);
      end;
    ctTiposTrabajo:
      Columna('NOMBRE', 320);
  else
    begin
      Columna('CODIGO', 90);
      Columna('NOMBRE', 220);
      Columna('UNIDAD_MEDIDA', 80);
      Columna('COSTO_UNITARIO', 100);
      Columna('PRECIO_UNITARIO', 100);
      Columna('FECHA_VIGENCIA', 100);
    end;
  end;
  Columna(CAMPO_ESTADO, 90);
  // El ancho real lo calcula AjustarColumnas con los botones que haya.
  Columna(CAMPO_ACCIONES, 10);
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
end;

procedure TfraCatalogos.Resize;
begin
  inherited;
  OcultarScrollVertical(grDatos);
end;

procedure TfraCatalogos.MostrarCargando(const AActivo: Boolean);
begin
  if AActivo then
  begin
    lblPaginacion.Caption := 'Cargando ' + LowerCase(TITULOS[FCatalogo]) +
      '...';
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
    cbCategoria.Items.AddObject('Todas las categor' + #237 + 'as',
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
    lblPaginacion.Caption := 'No hay registros que coincidan'
  else if ATotalPaginas = 0 then
    lblPaginacion.Caption := Format('%d registros', [ATotal])
  else
    lblPaginacion.Caption := Format('%d registros '#183' p'#225'gina %d de %d',
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
