unit Anovo.Forms.Columnas;

// Dialogo para elegir que columnas ver en una rejilla, en que orden
// y con que alineacion; Restablecer vuelve a las de fabrica.

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.CheckLst, Vcl.TitleBarCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo,
  Vcl.Samples.Spin, VclPlano.BotonWin, VclPlano.Pestanas,
  Anovo.Forms.Edicion,
  Anovo.UI.ColumnasRejilla;

type
  TfrmColumnas = class(TfrmEdicion)
    pnlCampos: TPanel;
    lblColumnas: TLabel;
    clbColumnas: TCheckListBox;
    btnSubir: TPlanoBotonWin;
    btnBajar: TPlanoBotonWin;
    lblAlineacion: TLabel;
    rbIzquierda: TRadioButton;
    rbCentro: TRadioButton;
    rbDerecha: TRadioButton;
    btnRestablecer: TPlanoBotonWin;
    btnAplicarTodas: TPlanoBotonWin;
    pstConfig: TPlanoPestanas;
    pnlVista: TPanel;
    chkFilasAlternas: TCheckBox;
    chkDegradado: TCheckBox;
    chkOrdenarTitulo: TCheckBox;
    chkEmbudo: TCheckBox;
    chkTotales: TCheckBox;
    lblAltoFila: TLabel;
    speAltoFila: TSpinEdit;
    procedure clbColumnasClick(Sender: TObject);
    procedure clbColumnasClickCheck(Sender: TObject);
    procedure btnSubirClick(Sender: TObject);
    procedure btnBajarClick(Sender: TObject);
    procedure rbAlineacionClick(Sender: TObject);
    procedure btnRestablecerClick(Sender: TObject);
    procedure btnAplicarTodasClick(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure pstConfigChange(Sender: TObject);
  private
    FColumnas: TColumnasElegidas;
    FVista: TVistaRejilla;
    FPintando: Boolean;
    procedure Pintar(const AIndice: Integer);
    procedure MostrarAlineacion;
    function AlineacionElegida: TAlignment;
    procedure Mover(const ADesplazamiento: Integer);
    procedure PintarVista;
    procedure LeerVista;
  public
    class function Elegir(AOwner: TComponent;
      var AColumnas: TColumnasElegidas; var AVista: TVistaRejilla;
      const APestana: Integer = 0): TModalResult;
  end;

const
  PESTANA_COLUMNAS = 0;
  PESTANA_VISTA = 1;

implementation

{$R *.dfm}

uses
  Anovo.Textos;

class function TfrmColumnas.Elegir(AOwner: TComponent;
  var AColumnas: TColumnasElegidas; var AVista: TVistaRejilla;
  const APestana: Integer): TModalResult;
var
  lForma: TfrmColumnas;
begin
  lForma := TfrmColumnas.Create(AOwner);
  try
    lForma.lblTitulo.Caption := STituloVistaRejilla;
    lForma.lblSubtitulo.Caption := SAyudaVistaRejilla;
    lForma.pstConfig.Items.Text := SPestanaColumnas + sLineBreak + SPestanaVista;
    lForma.FColumnas := Copy(AColumnas);
    lForma.FVista := AVista;
    lForma.Pintar(0);
    lForma.PintarVista;
    lForma.pstConfig.ItemIndex := APestana;
    lForma.pstConfigChange(nil);
    Result := lForma.ShowModal;
    if Result = mrOk then
    begin
      AColumnas := lForma.FColumnas;
      AVista := lForma.FVista;
    end;
  finally
    lForma.Free;
  end;
end;

procedure TfrmColumnas.Pintar(const AIndice: Integer);
var
  I: Integer;
begin
  clbColumnas.Items.BeginUpdate;
  try
    clbColumnas.Items.Clear;
    for I := 0 to High(FColumnas) do
    begin
      clbColumnas.Items.Add(FColumnas[I].Titulo);
      clbColumnas.Checked[I] := FColumnas[I].Visible;
    end;
  finally
    clbColumnas.Items.EndUpdate;
  end;
  if clbColumnas.Items.Count > 0 then
    clbColumnas.ItemIndex := AIndice;
  MostrarAlineacion;
end;

procedure TfrmColumnas.MostrarAlineacion;
var
  lIndice: Integer;
begin
  lIndice := clbColumnas.ItemIndex;
  if lIndice < 0 then
    Exit;
  FPintando := True;
  try
    rbIzquierda.Checked := FColumnas[lIndice].Alineacion = taLeftJustify;
    rbCentro.Checked := FColumnas[lIndice].Alineacion = taCenter;
    rbDerecha.Checked := FColumnas[lIndice].Alineacion = taRightJustify;
  finally
    FPintando := False;
  end;
end;

procedure TfrmColumnas.Mover(const ADesplazamiento: Integer);
var
  lDesde, lHasta: Integer;
  lAuxiliar: TColumnaElegida;
begin
  lDesde := clbColumnas.ItemIndex;
  lHasta := lDesde + ADesplazamiento;
  if (lDesde < 0) or (lHasta < 0) or (lHasta > High(FColumnas)) then
    Exit;
  lAuxiliar := FColumnas[lDesde];
  FColumnas[lDesde] := FColumnas[lHasta];
  FColumnas[lHasta] := lAuxiliar;
  Pintar(lHasta);
end;

procedure TfrmColumnas.clbColumnasClick(Sender: TObject);
begin
  MostrarAlineacion;
end;

procedure TfrmColumnas.clbColumnasClickCheck(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to High(FColumnas) do
    FColumnas[I].Visible := clbColumnas.Checked[I];
end;

procedure TfrmColumnas.btnSubirClick(Sender: TObject);
begin
  Mover(-1);
end;

procedure TfrmColumnas.btnBajarClick(Sender: TObject);
begin
  Mover(1);
end;

procedure TfrmColumnas.rbAlineacionClick(Sender: TObject);
var
  lIndice: Integer;
begin
  lIndice := clbColumnas.ItemIndex;
  if FPintando or (lIndice < 0) then
    Exit;
  FColumnas[lIndice].Alineacion := AlineacionElegida;
end;

function TfrmColumnas.AlineacionElegida: TAlignment;
begin
  if rbCentro.Checked then
    Result := taCenter
  else if rbDerecha.Checked then
    Result := taRightJustify
  else
    Result := taLeftJustify;
end;

procedure TfrmColumnas.btnAplicarTodasClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to High(FColumnas) do
    FColumnas[I].Alineacion := AlineacionElegida;
end;

procedure TfrmColumnas.btnRestablecerClick(Sender: TObject);
begin
  ModalResult := mrRetry;
end;

procedure TfrmColumnas.PintarVista;
begin
  chkFilasAlternas.Checked := FVista.FilasAlternas;
  chkDegradado.Checked := FVista.DegradadoFila;
  chkOrdenarTitulo.Checked := FVista.OrdenarTitulo;
  chkEmbudo.Checked := FVista.EmbudoFiltro;
  chkTotales.Checked := FVista.FilaTotales;
  speAltoFila.Value := FVista.AltoFila;
end;

procedure TfrmColumnas.LeerVista;
begin
  FVista.FilasAlternas := chkFilasAlternas.Checked;
  FVista.DegradadoFila := chkDegradado.Checked;
  FVista.OrdenarTitulo := chkOrdenarTitulo.Checked;
  FVista.EmbudoFiltro := chkEmbudo.Checked;
  FVista.FilaTotales := chkTotales.Checked;
  FVista.AltoFila := speAltoFila.Value;
end;

procedure TfrmColumnas.pstConfigChange(Sender: TObject);
begin
  pnlCampos.Visible := pstConfig.ItemIndex <> PESTANA_VISTA;
  pnlVista.Visible := pstConfig.ItemIndex = PESTANA_VISTA;
end;

procedure TfrmColumnas.btnGuardarClick(Sender: TObject);
var
  I: Integer;
begin
  LeerVista;
  for I := 0 to High(FColumnas) do
    if FColumnas[I].Visible then
    begin
      ModalResult := mrOk;
      Exit;
    end;
  MostrarError(SColumnasFalta);
end;

end.
