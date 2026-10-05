unit Anovo.Forms.ImportacionCatalogo;

// Carga masiva de items nuevos a un catalogo: archivo, correspondencia de
// columnas (etiqueta y combo por campo, como el asistente de RosiComp),
// revision en la rejilla y aprobacion.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.UITypes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.BotonWin,
  Anovo.DTOs.Importacion,
  Anovo.Vistas.Intf.Importacion,
  Anovo.Presentadores.Importacion;

const
  WM_FILA_EDITADA = WM_USER + 1;

type
  TfrmImportacionCatalogo = class(TForm, IVistaImportacion)
    TitleBarPanel1: TTitleBarPanel;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlArchivo: TPanel;
    lblArchivo: TLabel;
    edArchivo: TEdit;
    btnAbrir: TPlanoBotonWin;
    lblHoja: TLabel;
    cbHoja: TComboBox;
    pnlCampos: TPanel;
    lblCampos: TLabel;
    sbCampos: TScrollBox;
    lblAyudaCampos: TLabel;
    pnlCentro: TPanel;
    pnlResumen: TPanel;
    lblResumen: TLabel;
    chkSoloErrores: TCheckBox;
    grFilas: TrDBGrid;
    pnlAccionesFila: TPanel;
    btnQuitar: TPlanoBotonWin;
    btnExportar: TPlanoBotonWin;
    pnlPie: TPanel;
    lblNota: TLabel;
    btnCancelar: TPlanoBotonWin;
    btnAprobar: TPlanoBotonWin;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAbrirClick(Sender: TObject);
    procedure cbHojaChange(Sender: TObject);
    procedure chkSoloErroresClick(Sender: TObject);
    procedure btnQuitarClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure btnAprobarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure grFilasCanEdit(Sender: TObject; Field: TField; Column: TColumn;
      var CanEdit: Boolean);
  private
    FPresentador: TPresentadorImportacion;
    FCatalogo: TCatalogoImportacion;
    FCombos: TArray<TComboBox>;
    FMostrando: Boolean;
    FPendiente: TFilaCarga;
    procedure ComboCampoChange(Sender: TObject);
    procedure TablaAfterPost(DataSet: TDataSet);
    procedure WMFilaEditada(var AMensaje: TMessage); message WM_FILA_EDITADA;
    procedure MarcarErrores;
    procedure PrepararCatalogo(const ATitulo: string;
      const ARotulos: TArray<string>; const AObligatorios: TArray<Boolean>;
      const AConUnidad, AConCategoria, AConPrecio: Boolean;
      const ARotuloCosto: string);
    procedure MostrarArchivo(const ARuta: string);
    procedure MostrarHojas(const AHojas: TArray<string>;
      const AIndice: Integer);
    procedure MostrarColumnas(const AColumnas: TArray<string>;
      const ASeleccion: TArray<Integer>);
    procedure MostrarFilas(const AFilas: TObjectList<TFilaCarga>);
    procedure MostrarResumen(const ALeidas, AListas, AConError: Integer;
      const ARevisando: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    function Confirmar(const AMensaje: string): Boolean;
    procedure Terminar(const AMensaje: string);
  public
    constructor Crear(AOwner: TComponent;
      const ACatalogo: TCatalogoImportacion);
    class function Mostrar(AOwner: TComponent;
      const ACatalogo: TCatalogoImportacion): Boolean;
  end;

implementation

{$R *.dfm}

uses
  rDBExport,
  Anovo.UI.Tema,
  Anovo.UI.Vista,
  Anovo.UI.DBGridExtend,
  Anovo.Api.Catalogos,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

const
  ALTO_ROTULO = 18;
  ALTO_CAMPO = 52;
  MARGEN_CAMPOS = 8;
  VALOR_CON_ERROR = '1';

class function TfrmImportacionCatalogo.Mostrar(AOwner: TComponent;
  const ACatalogo: TCatalogoImportacion): Boolean;
var
  lVentana: TfrmImportacionCatalogo;
begin
  lVentana := TfrmImportacionCatalogo.Crear(AOwner, ACatalogo);
  try
    Result := lVentana.ShowModal = mrOk;
  finally
    lVentana.Free;
  end;
end;

constructor TfrmImportacionCatalogo.Crear(AOwner: TComponent;
  const ACatalogo: TCatalogoImportacion);
begin
  FCatalogo := ACatalogo;
  inherited Create(AOwner);
end;

procedure TfrmImportacionCatalogo.FormCreate(Sender: TObject);
begin
  AplicarTema(Self);
  AplicarTemaBarraTitulo(Self, TitleBarPanel1);
  AplicarTemaGrid(grFilas);
  MarcarErrores;
  dmMemoria.mtImportacion.AfterPost := TablaAfterPost;
  FPresentador := TPresentadorImportacion.Create(Self, TApiCatalogos.Create,
    FCatalogo);
  FPresentador.Iniciar;
end;

procedure TfrmImportacionCatalogo.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPresentador);
  FreeAndNil(FPendiente);
  dmMemoria.mtImportacion.AfterPost := nil;
  dmMemoria.SoloErroresImportacion(False);
  dmMemoria.mtImportacion.Close;
end;

procedure TfrmImportacionCatalogo.MarcarErrores;
var
  lCondicion: TCellParamsCond;
begin
  lCondicion := TCellParamsCond.Create;
  lCondicion.FieldName := dmMemoria.mtImportacionCON_ERROR.FieldName;
  lCondicion.CondOperator := cpoEqual;
  lCondicion.Value := VALOR_CON_ERROR;
  lCondicion.Action := cpaSet;
  lCondicion.FontColor := clEstRechazadaBarra;
  lCondicion.BkColor := clAnovoErrorSuave;
  lCondicion.WholeRow := True;
  grFilas.CellParamsCondList.Add(lCondicion);
  grFilas.OptionsEx2.CellCondition.Active := True;
end;

procedure TfrmImportacionCatalogo.PrepararCatalogo(const ATitulo: string;
  const ARotulos: TArray<string>; const AObligatorios: TArray<Boolean>;
  const AConUnidad, AConCategoria, AConPrecio: Boolean;
  const ARotuloCosto: string);
var
  I, lTop: Integer;
  lRotulo: TLabel;
  lCombo: TComboBox;
begin
  Caption := ATitulo;
  lblTitulo.Caption := ATitulo;
  dmMemoria.PrepararImportacion(AConUnidad, AConCategoria, AConPrecio,
    ARotuloCosto);

  FCombos := [];
  lTop := MARGEN_CAMPOS;
  for I := 0 to High(ARotulos) do
  begin
    lRotulo := TLabel.Create(Self);
    lRotulo.Parent := sbCampos;
    if AObligatorios[I] then
      lRotulo.Tag := TAG_SECCION
    else
      lRotulo.Tag := TAG_APOYO;
    lRotulo.Caption := ARotulos[I];
    lRotulo.SetBounds(MARGEN_CAMPOS, lTop, sbCampos.ClientWidth -
      2 * MARGEN_CAMPOS, ALTO_ROTULO);

    lCombo := TComboBox.Create(Self);
    lCombo.Parent := sbCampos;
    lCombo.Style := csDropDownList;
    lCombo.Tag := I;
    lCombo.SetBounds(MARGEN_CAMPOS, lTop + ALTO_ROTULO + 2,
      sbCampos.ClientWidth - 2 * MARGEN_CAMPOS, lCombo.Height);
    lCombo.Anchors := [akLeft, akTop, akRight];
    lCombo.Items.Add(SSinColumna);
    lCombo.ItemIndex := 0;
    lCombo.Enabled := False;
    lCombo.OnChange := ComboCampoChange;
    FCombos := FCombos + [lCombo];

    Inc(lTop, ALTO_CAMPO);
  end;
  AplicarTemaEnCascada(sbCampos);
end;

procedure TfrmImportacionCatalogo.MostrarArchivo(const ARuta: string);
begin
  edArchivo.Text := ARuta;
end;

procedure TfrmImportacionCatalogo.MostrarHojas(const AHojas: TArray<string>;
  const AIndice: Integer);
var
  lHoja: string;
begin
  FMostrando := True;
  try
    cbHoja.Items.Clear;
    for lHoja in AHojas do
      cbHoja.Items.Add(lHoja);
    cbHoja.ItemIndex := AIndice;
    cbHoja.Enabled := Length(AHojas) > 1;
  finally
    FMostrando := False;
  end;
end;

procedure TfrmImportacionCatalogo.MostrarColumnas(const AColumnas
  : TArray<string>; const ASeleccion: TArray<Integer>);
var
  I: Integer;
  lColumna: string;
begin
  FMostrando := True;
  try
    for I := 0 to High(FCombos) do
    begin
      FCombos[I].Items.BeginUpdate;
      try
        FCombos[I].Items.Clear;
        FCombos[I].Items.Add(SSinColumna);
        for lColumna in AColumnas do
          FCombos[I].Items.Add(lColumna);
      finally
        FCombos[I].Items.EndUpdate;
      end;
      FCombos[I].ItemIndex := ASeleccion[I] + 1;
      FCombos[I].Enabled := True;
    end;
  finally
    FMostrando := False;
  end;
end;

procedure TfrmImportacionCatalogo.MostrarFilas(const AFilas
  : TObjectList<TFilaCarga>);
var
  lFila: Integer;
begin
  FMostrando := True;
  try
    lFila := 0;
    if dmMemoria.mtImportacion.Active and
      not dmMemoria.mtImportacion.IsEmpty then
      lFila := dmMemoria.mtImportacionFILA.AsInteger;
    TMapeoDatos.AListaTabla<TFilaCarga>(AFilas, dmMemoria.mtImportacion);
    if lFila > 0 then
      dmMemoria.mtImportacion.Locate(dmMemoria.mtImportacionFILA.FieldName,
        lFila, []);
    Anovo.UI.DBGridExtend.AjustarColumnas(grFilas);
  finally
    FMostrando := False;
  end;
end;

procedure TfrmImportacionCatalogo.MostrarResumen(const ALeidas, AListas,
  AConError: Integer; const ARevisando: Boolean);
begin
  if ARevisando then
    lblResumen.Caption := Format(SResumenRevisando, [ALeidas])
  else
    lblResumen.Caption := Format(SResumenCarga, [ALeidas, AListas,
      AConError]);
  btnAprobar.Caption := Format(SAprobarCarga, [AListas]);
  btnAprobar.Enabled := (AListas > 0) and not ARevisando;
  btnQuitar.Enabled := ALeidas > 0;
  btnExportar.Enabled := ALeidas > 0;
  chkSoloErrores.Enabled := ALeidas > 0;
end;

procedure TfrmImportacionCatalogo.MostrarCargando(const AActivo: Boolean);
begin
  CursorOcupado(AActivo);
  BloquearEdicion([pnlArchivo, pnlCampos, grFilas, pnlAccionesFila,
    btnAprobar], AActivo);
end;

procedure TfrmImportacionCatalogo.MostrarError(const AMensaje: string);
begin
  AvisarError(AMensaje);
end;

function TfrmImportacionCatalogo.Confirmar(const AMensaje: string): Boolean;
begin
  Result := Anovo.UI.Vista.Confirmar(AMensaje);
end;

procedure TfrmImportacionCatalogo.Terminar(const AMensaje: string);
begin
  Informar(AMensaje);
  ModalResult := mrOk;
end;

procedure TfrmImportacionCatalogo.ComboCampoChange(Sender: TObject);
var
  lCombo: TComboBox;
begin
  if FMostrando or (FPresentador = nil) then
    Exit;
  lCombo := Sender as TComboBox;
  FPresentador.Emparejar(lCombo.Tag, lCombo.ItemIndex - 1);
end;

procedure TfrmImportacionCatalogo.TablaAfterPost(DataSet: TDataSet);
begin
  if FMostrando then
    Exit;
  FreeAndNil(FPendiente);
  FPendiente := TMapeoDatos.ADto<TFilaCarga>(DataSet);
  PostMessage(Handle, WM_FILA_EDITADA, 0, 0);
end;

procedure TfrmImportacionCatalogo.WMFilaEditada(var AMensaje: TMessage);
begin
  if (FPendiente = nil) or (FPresentador = nil) then
    Exit;
  try
    FPresentador.CambiarFila(FPendiente);
  finally
    FreeAndNil(FPendiente);
  end;
end;

procedure TfrmImportacionCatalogo.btnAbrirClick(Sender: TObject);
var
  lDialogo: TOpenDialog;
begin
  lDialogo := TOpenDialog.Create(Self);
  try
    lDialogo.Filter := SFiltroArchivosCarga;
    lDialogo.Options := lDialogo.Options + [ofFileMustExist];
    if lDialogo.Execute then
      FPresentador.AbrirArchivo(lDialogo.FileName);
  finally
    lDialogo.Free;
  end;
end;

procedure TfrmImportacionCatalogo.cbHojaChange(Sender: TObject);
begin
  if FMostrando or (FPresentador = nil) then
    Exit;
  FPresentador.ElegirHoja(cbHoja.ItemIndex);
end;

procedure TfrmImportacionCatalogo.chkSoloErroresClick(Sender: TObject);
begin
  dmMemoria.SoloErroresImportacion(chkSoloErrores.Checked);
end;

procedure TfrmImportacionCatalogo.btnQuitarClick(Sender: TObject);
begin
  if not dmMemoria.mtImportacion.Active or dmMemoria.mtImportacion.IsEmpty
  then
    Exit;
  dmMemoria.mtImportacion.Cancel;
  FPresentador.QuitarFila(dmMemoria.mtImportacionFILA.AsInteger);
end;

procedure TfrmImportacionCatalogo.btnExportarClick(Sender: TObject);
begin
  rDBExport.DBExport(grFilas, True, True);
end;

procedure TfrmImportacionCatalogo.btnAprobarClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtImportacion);
  FPresentador.Aprobar;
end;

procedure TfrmImportacionCatalogo.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmImportacionCatalogo.grFilasCanEdit(Sender: TObject;
  Field: TField; Column: TColumn; var CanEdit: Boolean);
begin
  CanEdit := (Field <> nil) and not dmMemoria.mtImportacion.IsEmpty and
    (Field <> dmMemoria.mtImportacionFILA) and
    (Field <> dmMemoria.mtImportacionREVISION);
end;

end.
