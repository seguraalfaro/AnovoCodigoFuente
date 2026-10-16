unit Anovo.UI.Rejilla;

// Aspecto de las rejillas de la ventana del servidor: colores de VclPlano,
// estado HTTP como pastilla y orden al pulsar el titulo de una columna.

interface

uses
  System.Types, System.Classes, Vcl.Graphics, Vcl.Grids, Vcl.DBGrids,
  rDBGrid;

type
  TRejillaServidor = class(TComponent)
  private
    FGrid: TrDBGrid;
    FCampoEstado: string;
    procedure DibujarCelda(Sender: TObject; const ARect: TRect;
      ADataCol: Integer; AColumn: TColumn; AState: TGridDrawState);
    procedure DibujarTitulo(Sender: TObject; ACol, ARow: Longint; Rect: TRect;
      State: TGridDrawState);
    procedure PulsarTitulo(AColumn: TColumn);
  public
    class procedure Aplicar(AGrid: TrDBGrid; const ACampoEstado: string);
  end;

implementation

uses
  System.SysUtils, System.UITypes, Vcl.Controls, Vcl.Forms, Data.DB,
  RosiCompGlobalCfg,
  FireDAC.Comp.Client, VclPlano.Paleta, VclPlano.Pastilla;

const
  ALTO_FILA = 30;
  ALTO_PASTILLA = 18;
  MARGEN_CELDA = 10;
  FUENTE = 'Segoe UI';
  FUENTE_SEMI = 'Segoe UI Semibold';
  DESCENDENTE = ':D';
  ESTADO_ERROR_CLIENTE = 400;
  ESTADO_ERROR_SERVIDOR = 500;

type
  TRejillaAbierta = class(TrDBGrid);

function EstadoHttp(const ACodigo: Integer): TPlanoEstado;
begin
  if ACodigo >= ESTADO_ERROR_SERVIDOR then
    Result := fsDanger
  else if ACodigo >= ESTADO_ERROR_CLIENTE then
    Result := fsPending
  else
    Result := fsSuccess;
end;

class procedure TRejillaServidor.Aplicar(AGrid: TrDBGrid;
  const ACampoEstado: string);
var
  lRejilla: TRejillaServidor;
begin
  lRejilla := TRejillaServidor.Create(AGrid);
  lRejilla.FGrid := AGrid;
  lRejilla.FCampoEstado := ACampoEstado;

  AGrid.DrawingStyle := gdsClassic;
  AGrid.GridLookStyle := grs_Default;
  AGrid.OptionsEx2.FixedCell.TitleExBtn := False;
  AGrid.OptionsEx2.FixedCell.TitleBtn := False;
  AGrid.OptionsEx2.FixedCell.FixedColBtn := False;
  AGrid.OptionsEx2.FixedCell.TitlePopup := False;
  AGrid.OptionsEx2.Appearance.TitleFontStyleColor := False;

  AGrid.Color := PaletaPlano.Surface;
  AGrid.FixedColor := PaletaPlano.Background;
  AGrid.Font.Name := FUENTE;
  AGrid.Font.Height := -12;
  AGrid.Font.Color := PaletaPlano.Text;
  AGrid.TitleFont.Name := FUENTE_SEMI;
  AGrid.TitleFont.Height := -12;
  AGrid.TitleFont.Color := PaletaPlano.TextMuted;
  AGrid.RowFixHeight := ALTO_FILA;
  AGrid.RowVerticalAlign := taVerticalCenter;

  AGrid.ColorOddRow := clNone;
  AGrid.ColorActiveRow := PaletaPlano.Kind[fkSecondary];
  AGrid.ColorHotTrackRow := PlanoMezcla(PaletaPlano.Kind[fkSecondary],
    PaletaPlano.Surface, 60);
  AGrid.OptionsEx2.Appearance.DataRowLineColor := PaletaPlano.Border;
  AGrid.OptionsEx2.Appearance.DataColLineColor := clNone;
  AGrid.OptionsEx2.Appearance.TitleRowLineColor := clNone;
  AGrid.OptionsEx2.Appearance.TitleColLineColor := clNone;
  AGrid.OptionsEx2.Appearance.SkipCellHighlight := True;
  AGrid.OptionsEx2.Appearance.DrawRowFocus := False;

  AGrid.Options := AGrid.Options - [dgColLines, dgIndicator, dgEditing] +
    [dgRowLines, dgTitles, dgRowSelect, dgAlwaysShowSelection];
  AGrid.ReadOnly := True;
  AGrid.BorderStyle := bsNone;
  AGrid.Ctl3D := False;
  AGrid.DoubleBuffered := True;

  AGrid.OnDrawColumnCellEnd := lRejilla.DibujarCelda;
  AGrid.OnDrawTitleCellEnd := lRejilla.DibujarTitulo;
  AGrid.OnTitleClick := lRejilla.PulsarTitulo;
  AGrid.ColumnWidth := cwAutoWidth;
end;

procedure TRejillaServidor.DibujarCelda(Sender: TObject; const ARect: TRect;
  ADataCol: Integer; AColumn: TColumn; AState: TGridDrawState);
var
  R: TRect;
  lTexto: string;
  lFila: Integer;
begin
  if (AColumn = nil) or (AColumn.Field = nil) or
    not SameText(AColumn.FieldName, FCampoEstado) or
    AColumn.Field.DataSet.IsEmpty then
    Exit;

  FGrid.Canvas.Brush.Style := bsSolid;
  lFila := FGrid.MouseCoord(ARect.Left + 1, ARect.Top + 1).Y;
  if lFila = TRejillaAbierta(FGrid).Row then
    FGrid.Canvas.Brush.Color := FGrid.ColorActiveRow
  else if lFila = TRejillaAbierta(FGrid).MouseOverRow then
    FGrid.Canvas.Brush.Color := FGrid.ColorHotTrackRow
  else
    FGrid.Canvas.Brush.Color := FGrid.Color;
  FGrid.Canvas.FillRect(ARect);

  lTexto := AColumn.Field.AsString;
  FGrid.Canvas.Font.Name := FUENTE_SEMI;
  FGrid.Canvas.Font.Height := -11;
  R.Left := ARect.Left + MARGEN_CELDA;
  R.Top := ARect.Top + (ARect.Height - ALTO_PASTILLA) div 2;
  R.Right := R.Left + TPlanoPastilla.AnchoPara(FGrid.Canvas, lTexto);
  R.Bottom := R.Top + ALTO_PASTILLA;
  TPlanoPastilla.DibujarEn(FGrid.Canvas, R, lTexto,
    EstadoHttp(AColumn.Field.AsInteger));
end;

procedure TRejillaServidor.DibujarTitulo(Sender: TObject; ACol, ARow: Longint;
  Rect: TRect; State: TGridDrawState);
var
  lIndice: Integer;
  lTexto: string;
  lDatos: TFDMemTable;
begin
  if ARow <> 0 then
    Exit;
  FGrid.Canvas.Brush.Style := bsSolid;
  FGrid.Canvas.Brush.Color := PaletaPlano.Background;
  FGrid.Canvas.FillRect(Rect);
  lIndice := ACol - TRejillaAbierta(FGrid).FixedCols;
  if (lIndice < 0) or (lIndice >= FGrid.Columns.Count) then
    Exit;

  lTexto := FGrid.Columns[lIndice].Title.Caption;
  if (FGrid.DataSource.DataSet is TFDMemTable) then
  begin
    lDatos := TFDMemTable(FGrid.DataSource.DataSet);
    if SameText(lDatos.IndexFieldNames, FGrid.Columns[lIndice].FieldName) then
      lTexto := lTexto + ' ' + #$25B2
    else if SameText(lDatos.IndexFieldNames, FGrid.Columns[lIndice].FieldName +
      DESCENDENTE) then
      lTexto := lTexto + ' ' + #$25BC;
  end;
  FGrid.Canvas.Font := FGrid.TitleFont;
  FGrid.Canvas.Brush.Style := bsClear;
  Rect.Left := Rect.Left + MARGEN_CELDA;
  FGrid.Canvas.TextRect(Rect, lTexto, [tfVerticalCenter, tfSingleLine,
    tfEndEllipsis]);
  FGrid.Canvas.Brush.Style := bsSolid;
end;

procedure TRejillaServidor.PulsarTitulo(AColumn: TColumn);
var
  lDatos: TFDMemTable;
begin
  if not(FGrid.DataSource.DataSet is TFDMemTable) then
    Exit;
  lDatos := TFDMemTable(FGrid.DataSource.DataSet);
  if SameText(lDatos.IndexFieldNames, AColumn.FieldName) then
    lDatos.IndexFieldNames := AColumn.FieldName + DESCENDENTE
  else if SameText(lDatos.IndexFieldNames, AColumn.FieldName + DESCENDENTE) then
    lDatos.IndexFieldNames := ''
  else
    lDatos.IndexFieldNames := AColumn.FieldName;
  FGrid.Invalidate;
end;

end.
