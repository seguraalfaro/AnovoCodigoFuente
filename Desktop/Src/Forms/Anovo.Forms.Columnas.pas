unit Anovo.Forms.Columnas;

// Dialogo para elegir que columnas ver en una rejilla, en que orden
// y con que alineacion; Restablecer vuelve a las de fabrica.

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.CheckLst, Vcl.TitleBarCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo,
  VclPlano.BotonWin,
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
    procedure clbColumnasClick(Sender: TObject);
    procedure clbColumnasClickCheck(Sender: TObject);
    procedure btnSubirClick(Sender: TObject);
    procedure btnBajarClick(Sender: TObject);
    procedure rbAlineacionClick(Sender: TObject);
    procedure btnRestablecerClick(Sender: TObject);
    procedure btnAplicarTodasClick(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
  private
    FColumnas: TColumnasElegidas;
    FPintando: Boolean;
    procedure Pintar(const AIndice: Integer);
    procedure MostrarAlineacion;
    function AlineacionElegida: TAlignment;
    procedure Mover(const ADesplazamiento: Integer);
  public
    class function Elegir(AOwner: TComponent;
      var AColumnas: TColumnasElegidas): TModalResult;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Textos;

class function TfrmColumnas.Elegir(AOwner: TComponent;
  var AColumnas: TColumnasElegidas): TModalResult;
var
  lForma: TfrmColumnas;
begin
  lForma := TfrmColumnas.Create(AOwner);
  try
    lForma.lblTitulo.Caption := STituloColumnas;
    lForma.lblSubtitulo.Caption := SAyudaColumnas;
    lForma.FColumnas := Copy(AColumnas);
    lForma.Pintar(0);
    Result := lForma.ShowModal;
    if Result = mrOk then
      AColumnas := lForma.FColumnas;
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

procedure TfrmColumnas.btnGuardarClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to High(FColumnas) do
    if FColumnas[I].Visible then
    begin
      ModalResult := mrOk;
      Exit;
    end;
  MostrarError(SColumnasFalta);
end;

end.
