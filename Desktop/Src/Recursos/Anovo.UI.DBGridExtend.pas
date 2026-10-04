unit Anovo.UI.DBGridExtend;

// Aspecto de las rejillas y lo que se dibuja sobre ellas:
// pastillas de estado, acciones y ajuste de columnas.

interface

uses
  System.Types, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.Graphics,
  Vcl.Grids, Vcl.DBGrids, rDBGrid;

const
  ALTO_FILA_LISTADO = 34;

procedure AplicarTemaGrid(AGrid: TrDBGrid; ASoloLectura: Boolean = True;
  AAltoFila: Integer = ALTO_FILA_LISTADO);

procedure TemarTitulos(AGrid: TrDBGrid);

procedure EditarCasillas(AGrid: TrDBGrid);

procedure AjustarColumnas(AGrid: TrDBGrid);

procedure AlinearDerecha(AGrid: TrDBGrid; const ACampos: array of string);

procedure OcultarScrollVertical(AGrid: TrDBGrid);

type
  TAccionRejilla = record
    Clave: string;
    Rotulo: string;
    Alterno: string;
    Campo: string;
  end;

  TEventoAccion = procedure(Sender: TObject; const AClave: string) of object;

  TDBGridExtend = class(TComponent)
  private
    FGrid: TrDBGrid;
    FColumnasEstado: TArray<string>;
    FCampoAcciones: string;
    FAcciones: TArray<TAccionRejilla>;
    FOnAccion: TEventoAccion;
    FTituloAnterior: TDrawCellEvent;
    FCeldaAnterior: TDrawColumnCellEvent;
    FUpAnterior: TMouseEvent;
    FMoveAnterior: TMouseMoveEvent;
    FTopHover: Integer;
    FCoordHover: TGridCoord;
    FBotonHover: Integer;
    function EsColumnaEstado(const ACampo: string): Boolean;
    function SinFilas: Boolean;
    function FondoDeCelda(const ARect: TRect; AColumn: TColumn): TColor;
    procedure RellenarFondo(const ARect: TRect; AColumn: TColumn);
    procedure DibujarEstado(const ARect: TRect; AColumn: TColumn);
    procedure DibujarAcciones(const ARect: TRect; AColumn: TColumn);
    function AnchoRotulo(ACanvas: TCanvas; AIndice: Integer): Integer;
    function RotuloDe(AIndice: Integer): string;
    function RectDeBoton(const ACelda: TRect; AIndice: Integer): TRect;
    function BotonEnPunto(AX, AY: Integer; out ATop: Integer;
      out ACoord: TGridCoord): Integer;
    procedure RepintarCelda(const ACoord: TGridCoord);
    procedure DibujarTitulo(Sender: TObject; ACol, ARow: Longint; Rect: TRect;
      State: TGridDrawState);
    procedure DibujarCelda(Sender: TObject; const ARect: TRect;
      ADataCol: Integer; AColumn: TColumn; AState: TGridDrawState);
    procedure Pulsar(Sender: TObject; AButton: TMouseButton;
      AShift: TShiftState; AX, AY: Integer);
    procedure Mover(Sender: TObject; AShift: TShiftState; AX, AY: Integer);
  public
    constructor Crear(AGrid: TrDBGrid);

    class function De(AGrid: TrDBGrid): TDBGridExtend;

    procedure ColumnaEstado(const ACampo: string);
    procedure ColumnaAcciones(const ACampo: string);
    procedure Agregar(const AClave, ARotulo: string);
    procedure AgregarAlterna(const AClave, ARotulo, AAlterno, ACampo: string);
    procedure Limpiar;
    procedure PonerLista(const AAcciones: array of TAccionRejilla);
    procedure PonerAcciones<T>(const ATodas: array of TAccionRejilla;
      const APermitidas: T);
    function AnchoAcciones: Integer;
    procedure AjustarAcciones;
    procedure AjustarColumnas;

    property OnAccion: TEventoAccion read FOnAccion write FOnAccion;
  end;

implementation

uses
  Winapi.Windows, System.SysUtils, System.Math, System.UITypes, Data.DB, RosiCompGlobalCfg,
  VclPlano.Paleta, VclPlano.Dibujo, VclPlano.Pastilla, Anovo.UI.Tema;

const
  MARGEN_CELDA = 10;
  ALTO_PASTILLA = 18;
  ALTO_BOTON = 22;
  RADIO_BOTON = 4;
  RELLENO_BOTON = 10;
  SEPARACION_BOTONES = 6;
  RESPIRO_TITULO = 4;
  DESBORDE_TITULO = 3;

type
  TRejillaAbierta = class(TrDBGrid);

procedure FuenteDeCelda(ACanvas: TCanvas; ABase: TFont);
begin
  ACanvas.Font := ABase;
  ACanvas.Font.Name := FUENTE_SEMI;
  ACanvas.Font.Height := -11;
end;

function EstadoPlano(const lEstado: string): TPlanoEstado;
var
  e: string;
begin
  e := LowerCase(Trim(lEstado));
  if (e = 'borrador') or (e = 'pendiente') or (e = 'recibida') or
    (e = 'programado') or (e = 'sin_guardar') then
    Result := fsPending
  else if (e = 'aprobada') or (e = 'activo') or (e = 'firmado') or
    (e = 'adicional') then
    Result := fsSuccess
  else if (e = 'rechazada') or (e = 'descartada') or (e = 'inactivo') or
    (e = 'revocado') or (e = 'quitado') then
    Result := fsDanger
  else if (e = 'enviada') or (e = 'en_cotizacion') or (e = 'en cotizacion') then
    Result := fsInfo
  else
    Result := fsNeutral;
end;

constructor TDBGridExtend.Crear(AGrid: TrDBGrid);
begin
  inherited Create(AGrid);
  FGrid := AGrid;
  FTopHover := -1;
  FCoordHover.X := -1;
  FCoordHover.Y := -1;
  FBotonHover := -1;

  FTituloAnterior := FGrid.OnDrawTitleCellEnd;
  FCeldaAnterior := FGrid.OnDrawColumnCellEnd;
  FUpAnterior := FGrid.OnMouseUp;
  FMoveAnterior := FGrid.OnMouseMove;

  FGrid.OnDrawTitleCellEnd := DibujarTitulo;
  FGrid.OnDrawColumnCellEnd := DibujarCelda;
  FGrid.OnMouseUp := Pulsar;
  FGrid.OnMouseMove := Mover;
end;

class function TDBGridExtend.De(AGrid: TrDBGrid): TDBGridExtend;
var
  I: Integer;
begin
  for I := 0 to AGrid.ComponentCount - 1 do
    if AGrid.Components[I] is TDBGridExtend then
      Exit(TDBGridExtend(AGrid.Components[I]));
  Result := TDBGridExtend.Crear(AGrid);
end;

procedure TDBGridExtend.ColumnaEstado(const ACampo: string);
begin
  if not EsColumnaEstado(ACampo) then
    FColumnasEstado := FColumnasEstado + [ACampo];
end;

procedure TDBGridExtend.ColumnaAcciones(const ACampo: string);
begin
  FCampoAcciones := ACampo;
end;

procedure TDBGridExtend.Agregar(const AClave, ARotulo: string);
var
  lNueva: TAccionRejilla;
begin
  lNueva.Clave := AClave;
  lNueva.Rotulo := ARotulo;
  FAcciones := FAcciones + [lNueva];
end;

procedure TDBGridExtend.AgregarAlterna(const AClave, ARotulo, AAlterno,
  ACampo: string);
var
  lNueva: TAccionRejilla;
begin
  lNueva.Clave := AClave;
  lNueva.Rotulo := ARotulo;
  lNueva.Alterno := AAlterno;
  lNueva.Campo := ACampo;
  FAcciones := FAcciones + [lNueva];
end;

function TDBGridExtend.AnchoRotulo(ACanvas: TCanvas; AIndice: Integer): Integer;
begin
  Result := ACanvas.TextWidth(FAcciones[AIndice].Rotulo);
  if FAcciones[AIndice].Alterno <> '' then
    Result := Max(Result, ACanvas.TextWidth(FAcciones[AIndice].Alterno));
end;

function TDBGridExtend.RotuloDe(AIndice: Integer): string;
var
  lCampo: TField;
begin
  Result := FAcciones[AIndice].Rotulo;
  if (FAcciones[AIndice].Campo = '') or (FGrid.DataSource = nil) or
    (FGrid.DataSource.DataSet = nil) then
    Exit;
  lCampo := FGrid.DataSource.DataSet.FindField(FAcciones[AIndice].Campo);
  if (lCampo <> nil) and not lCampo.AsBoolean then
    Result := FAcciones[AIndice].Alterno;
end;

procedure TDBGridExtend.Limpiar;
begin
  SetLength(FAcciones, 0);
end;

procedure TDBGridExtend.PonerLista(const AAcciones: array of TAccionRejilla);
var
  lAccion: TAccionRejilla;
begin
  Limpiar;
  for lAccion in AAcciones do
    if lAccion.Campo = '' then
      Agregar(lAccion.Clave, lAccion.Rotulo)
    else
      AgregarAlterna(lAccion.Clave, lAccion.Rotulo, lAccion.Alterno,
        lAccion.Campo);
  AjustarColumnas;
end;

procedure TDBGridExtend.PonerAcciones<T>(const ATodas: array of TAccionRejilla;
  const APermitidas: T);
var
  lBits: UInt64;
  lTamano, I: Integer;
  lElegidas: TArray<TAccionRejilla>;
begin
  Assert(GetTypeKind(T) = tkSet);
  lBits := 0;
  lTamano := SizeOf(T);
  if lTamano > SizeOf(lBits) then
    lTamano := SizeOf(lBits);
  Move(APermitidas, lBits, lTamano);

  lElegidas := [];
  for I := 0 to High(ATodas) do
    if (lBits and (UInt64(1) shl I)) <> 0 then
      lElegidas := lElegidas + [ATodas[I]];
  PonerLista(lElegidas);
end;

function TDBGridExtend.EsColumnaEstado(const ACampo: string): Boolean;
var
  lCampo: string;
begin
  for lCampo in FColumnasEstado do
    if SameText(lCampo, ACampo) then
      Exit(True);
  Result := False;
end;

function TDBGridExtend.AnchoAcciones: Integer;
var
  I: Integer;
  lAux: Vcl.Graphics.TBitmap;
begin
  Result := MARGEN_CELDA * 2;
  if Length(FAcciones) = 0 then
    Exit;

  lAux := Vcl.Graphics.TBitmap.Create;
  try
    FuenteDeCelda(lAux.Canvas, FGrid.Font);
    for I := 0 to High(FAcciones) do
    begin
      Inc(Result, AnchoRotulo(lAux.Canvas, I) + RELLENO_BOTON * 2);
      if I > 0 then
        Inc(Result, SEPARACION_BOTONES);
    end;
  finally
    lAux.Free;
  end;
end;

procedure TDBGridExtend.AjustarAcciones;
var
  I: Integer;
begin
  if FCampoAcciones = '' then
    Exit;

  if FGrid.FieldsFixedColumnWidth.IndexOf(FCampoAcciones) < 0 then
    FGrid.FieldsFixedColumnWidth.Add(FCampoAcciones);

  for I := 0 to FGrid.Columns.Count - 1 do
    if SameText(FGrid.Columns[I].FieldName, FCampoAcciones) then
    begin
      FGrid.Columns[I].Visible := Length(FAcciones) > 0;
      FGrid.Columns[I].Width := AnchoAcciones;
    end;
end;

procedure TDBGridExtend.AjustarColumnas;
begin
  AjustarAcciones;
  Anovo.UI.DBGridExtend.AjustarColumnas(FGrid);
end;

function TDBGridExtend.SinFilas: Boolean;
begin
  Result := (FGrid.DataSource = nil) or (FGrid.DataSource.DataSet = nil) or
    not FGrid.DataSource.DataSet.Active or FGrid.DataSource.DataSet.IsEmpty;
end;

function TDBGridExtend.FondoDeCelda(const ARect: TRect; AColumn: TColumn): TColor;
var
  lFila: Integer;
  lDatos: TDataSet;
begin
  Result := AColumn.Color;
  lFila := FGrid.MouseCoord(ARect.Left + 1, ARect.Top + 1).Y;

  if (lFila = TRejillaAbierta(FGrid).MouseOverRow) and
    (FGrid.ColorHotTrackRow <> clNone) then
    Exit(FGrid.ColorHotTrackRow);
  if (lFila = TRejillaAbierta(FGrid).Row) and (FGrid.ColorActiveRow <> clNone) then
    Exit(FGrid.ColorActiveRow);

  if not FGrid.OptionsEx2.Appearance.DrawColoredRow or
    (FGrid.ColorOddRow = clNone) then
    Exit;
  if FGrid.OptionsEx2.Appearance.PreferColumnColor and
    (AColumn.Color <> FGrid.Color) then
    Exit;

  if FGrid.DataSource <> nil then
  begin
    lDatos := FGrid.DataSource.DataSet;
    if (lDatos <> nil) and lDatos.Active and (lDatos.RecNo mod 2 = 0) then
      Result := FGrid.ColorOddRow;
  end;
end;

procedure TDBGridExtend.RellenarFondo(const ARect: TRect; AColumn: TColumn);
begin
  FGrid.Canvas.Brush.Style := bsSolid;
  FGrid.Canvas.Brush.Color := FondoDeCelda(ARect, AColumn);
  FGrid.Canvas.FillRect(ARect);
end;

procedure TDBGridExtend.DibujarEstado(const ARect: TRect; AColumn: TColumn);
var
  R: TRect;
  lValor, lEstado: string;
begin
  RellenarFondo(ARect, AColumn);
  lValor := AColumn.Field.AsString;
  if Trim(lValor) = '' then
    Exit;
  lEstado := AColumn.Field.DisplayText;
  if lEstado = lValor then
    lEstado := UpperCase(lEstado[1]) + Copy(lEstado, 2, MaxInt);

  FuenteDeCelda(FGrid.Canvas, FGrid.Font);
  R.Left := ARect.Left + MARGEN_CELDA;
  R.Top := ARect.Top + (ARect.Height - ALTO_PASTILLA) div 2;
  R.Right := R.Left + TPlanoPastilla.AnchoPara(FGrid.Canvas, lEstado);
  R.Bottom := R.Top + ALTO_PASTILLA;
  if R.Right > ARect.Right then
    R.Right := ARect.Right;

  TPlanoPastilla.DibujarEn(FGrid.Canvas, R, lEstado, EstadoPlano(lValor));
end;

function TDBGridExtend.RectDeBoton(const ACelda: TRect;
  AIndice: Integer): TRect;
var
  I, lX: Integer;
begin
  lX := ACelda.Left + MARGEN_CELDA;
  for I := 0 to AIndice - 1 do
    lX := lX + AnchoRotulo(FGrid.Canvas, I) + RELLENO_BOTON * 2 +
      SEPARACION_BOTONES;

  Result.Left := lX;
  Result.Right := lX + AnchoRotulo(FGrid.Canvas, AIndice) +
    RELLENO_BOTON * 2;
  Result.Top := ACelda.Top + (ACelda.Height - ALTO_BOTON) div 2;
  Result.Bottom := Result.Top + ALTO_BOTON;
end;

procedure TDBGridExtend.DibujarAcciones(const ARect: TRect; AColumn: TColumn);
var
  I: Integer;
  lBoton: TRect;
  lTexto: TColor;
  lRotulo: string;
begin
  RellenarFondo(ARect, AColumn);
  FuenteDeCelda(FGrid.Canvas, FGrid.Font);

  for I := 0 to High(FAcciones) do
  begin
    lBoton := RectDeBoton(ARect, I);
    if lBoton.Right > ARect.Right then
      Break;

    if (FBotonHover = I) and (ARect.Top = FTopHover) then
    begin
      PlanoRectRedondeado(FGrid.Canvas, lBoton, RADIO_BOTON,
        PaletaPlano.Kind[fkPrimary], PaletaPlano.Kind[fkPrimary], 1);
      lTexto := PlanoTextoSobre(PaletaPlano.Kind[fkPrimary]);
    end
    else
    begin
      PlanoRectRedondeado(FGrid.Canvas, lBoton, RADIO_BOTON,
        PaletaPlano.Surface, PaletaPlano.Border, 1);
      lTexto := PaletaPlano.Text;
    end;

    FGrid.Canvas.Brush.Style := bsClear;
    FGrid.Canvas.Font.Color := lTexto;
    lRotulo := RotuloDe(I);
    FGrid.Canvas.TextRect(lBoton, lRotulo,
      [tfCenter, tfVerticalCenter, tfSingleLine]);
    FGrid.Canvas.Brush.Style := bsSolid;
  end;
end;

procedure TDBGridExtend.DibujarCelda(Sender: TObject; const ARect: TRect;
  ADataCol: Integer; AColumn: TColumn; AState: TGridDrawState);
begin
  if (AColumn <> nil) and SinFilas then
  begin
    if SameText(AColumn.FieldName, FCampoAcciones) or
      EsColumnaEstado(AColumn.FieldName) then
      RellenarFondo(ARect, AColumn);
  end
  else if AColumn <> nil then
  begin
    if (FCampoAcciones <> '') and (Length(FAcciones) > 0) and
      SameText(AColumn.FieldName, FCampoAcciones) then
      DibujarAcciones(ARect, AColumn)
    else if EsColumnaEstado(AColumn.FieldName) and (AColumn.Field <> nil) then
      DibujarEstado(ARect, AColumn)
    else if (AColumn.Field <> nil) and (AColumn.Field.DataType = ftBoolean) and
      AColumn.Field.IsNull then
      RellenarFondo(ARect, AColumn);
  end;

  if Assigned(FCeldaAnterior) then
    FCeldaAnterior(Sender, ARect, ADataCol, AColumn, AState);
end;

procedure TDBGridExtend.DibujarTitulo(Sender: TObject; ACol, ARow: Longint;
  Rect: TRect; State: TGridDrawState);
var
  lIndice: Integer;
  R: TRect;
  lFormato: TTextFormat;
  lTexto: string;
begin
  if ARow = 0 then
  begin
    R := Rect;
    InflateRect(R, DESBORDE_TITULO, DESBORDE_TITULO);
    FGrid.Canvas.Brush.Style := bsSolid;
    FGrid.Canvas.Brush.Color := clAnovoMarca;
    FGrid.Canvas.FillRect(R);

    lIndice := ACol - TRejillaAbierta(FGrid).FixedCols;
    if (lIndice >= 0) and (lIndice < FGrid.Columns.Count) then
    begin
      FGrid.Canvas.Font := FGrid.TitleFont;
      FGrid.Canvas.Brush.Style := bsClear;

      lFormato := [tfVerticalCenter, tfSingleLine, tfEndEllipsis];
      case FGrid.Columns[lIndice].Title.Alignment of
        taRightJustify:
          Include(lFormato, tfRight);
        taCenter:
          Include(lFormato, tfCenter);
      else
        Include(lFormato, tfLeft);
      end;

      R := Rect;
      R.Left := R.Left + RESPIRO_TITULO;
      R.Right := R.Right - RESPIRO_TITULO;
      lTexto := FGrid.Columns[lIndice].Title.Caption;
      FGrid.Canvas.TextRect(R, lTexto, lFormato);
      FGrid.Canvas.Brush.Style := bsSolid;
    end;
  end;

  if Assigned(FTituloAnterior) then
    FTituloAnterior(Sender, ACol, ARow, Rect, State);
end;

function TDBGridExtend.BotonEnPunto(AX, AY: Integer; out ATop: Integer;
  out ACoord: TGridCoord): Integer;
var
  lCelda: TRect;
  lColumna, I: Integer;
begin
  Result := -1;
  ATop := -1;
  ACoord.X := -1;
  ACoord.Y := -1;
  if (FCampoAcciones = '') or (Length(FAcciones) = 0) or SinFilas then
    Exit;

  ACoord := FGrid.MouseCoord(AX, AY);
  if (ACoord.X < 0) or (ACoord.Y <= 0) then
    Exit;

  lColumna := ACoord.X - TRejillaAbierta(FGrid).FixedCols;
  if (lColumna < 0) or (lColumna >= FGrid.Columns.Count) or
    not SameText(FGrid.Columns[lColumna].FieldName, FCampoAcciones) then
    Exit;

  lCelda := TRejillaAbierta(FGrid).CellRect(ACoord.X, ACoord.Y);
  FuenteDeCelda(FGrid.Canvas, FGrid.Font);

  for I := 0 to High(FAcciones) do
    if PtInRect(RectDeBoton(lCelda, I), Point(AX, AY)) then
    begin
      Result := I;
      ATop := lCelda.Top;
      Exit;
    end;
end;

procedure TDBGridExtend.RepintarCelda(const ACoord: TGridCoord);
begin
  if (ACoord.X >= 0) and (ACoord.Y >= 0) then
    TRejillaAbierta(FGrid).InvalidateCell(ACoord.X, ACoord.Y);
end;

procedure TDBGridExtend.Pulsar(Sender: TObject; AButton: TMouseButton;
  AShift: TShiftState; AX, AY: Integer);
var
  lBoton, lTop: Integer;
  lCoord: TGridCoord;
begin
  if Assigned(FUpAnterior) then
    FUpAnterior(Sender, AButton, AShift, AX, AY);

  if AButton <> mbLeft then
    Exit;

  lBoton := BotonEnPunto(AX, AY, lTop, lCoord);
  if (lBoton >= 0) and Assigned(FOnAccion) then
    FOnAccion(Self, FAcciones[lBoton].Clave);
end;

procedure TDBGridExtend.Mover(Sender: TObject; AShift: TShiftState;
  AX, AY: Integer);
var
  lBoton, lTop: Integer;
  lCoord, lAnterior: TGridCoord;
begin
  if Assigned(FMoveAnterior) then
    FMoveAnterior(Sender, AShift, AX, AY);

  lBoton := BotonEnPunto(AX, AY, lTop, lCoord);
  if (lBoton = FBotonHover) and (lTop = FTopHover) then
    Exit;

  lAnterior := FCoordHover;
  FBotonHover := lBoton;
  FTopHover := lTop;
  if lBoton >= 0 then
    FCoordHover := lCoord
  else
  begin
    FCoordHover.X := -1;
    FCoordHover.Y := -1;
  end;

  if lBoton >= 0 then
    FGrid.Cursor := crHandPoint
  else
    FGrid.Cursor := crDefault;

  RepintarCelda(lAnterior);
  RepintarCelda(FCoordHover);
end;

procedure AplicarTemaGrid(AGrid: TrDBGrid; ASoloLectura: Boolean = True;
  AAltoFila: Integer = ALTO_FILA_LISTADO);
begin
  if AGrid = nil then
    Exit;

  AGrid.DrawingStyle := gdsClassic;
  AGrid.GridLookStyle := grs_Default;

  TemarTitulos(AGrid);
  AGrid.TitleLines := 1;

  AGrid.OptionsEx2.FixedCell.TitleExBtn := False;
  AGrid.OptionsEx2.FixedCell.TitleBtn := False;
  AGrid.OptionsEx2.FixedCell.FixedColBtn := False;
  AGrid.OptionsEx2.FixedCell.TitlePopup := False;

  AGrid.Color := clAnovoTarjeta;
  AGrid.Font.Name := FUENTE;
  AGrid.Font.Height := -12;
  AGrid.Font.Color := clAnovoTexto;
  AGrid.Font.Style := [];
  AGrid.RowFixHeight := AAltoFila;

  AGrid.ColorOddRow := clAnovoFilaAlterna;
  AGrid.ColorActiveRow := clAnovoSeleccion;
  AGrid.ColorHotTrackRow := clAnovoFilaAlterna;

  AGrid.OptionsEx2.Appearance.DataRowLineColor := clAnovoBorde;
  AGrid.OptionsEx2.Appearance.DataColLineColor := clNone;
  AGrid.OptionsEx2.Appearance.TitleRowLineColor := clNone;
  AGrid.OptionsEx2.Appearance.TitleColLineColor := clNone;

  AGrid.OptionsEx2.Appearance.SkipCellHighlight := True;
  AGrid.OptionsEx2.Appearance.DrawRowFocus := False;

  AGrid.Options := AGrid.Options - [dgColLines, dgIndicator, dgTitleHotTrack] +
    [dgRowLines, dgTitles, dgRowSelect, dgAlwaysShowSelection];
  if ASoloLectura then
  begin
    AGrid.Options := AGrid.Options - [dgEditing];
    AGrid.ReadOnly := True;
  end;

  AGrid.FieldsFixedColumnWidth.Text :=
    'ACCIONES'#13#10'ESTADO'#13#10'CONSENTIMIENTO_ESTADO'#13#10'PRINCIPAL';

  AGrid.BorderStyle := bsNone;
  AGrid.Ctl3D := False;

  AGrid.DoubleBuffered := True;
end;

procedure EditarCasillas(AGrid: TrDBGrid);
begin
  AGrid.Options := AGrid.Options - [dgRowSelect] + [dgEditing];
  AGrid.ReadOnly := False;
  AGrid.OptionsEx2.Editors.BoolOneClickChange := True;
end;

procedure TemarTitulos(AGrid: TrDBGrid);
var
  i: Integer;
begin
  if AGrid = nil then
    Exit;

  TDBGridExtend.De(AGrid);

  AGrid.OptionsEx2.Appearance.TitleFontStyleColor := False;

  AGrid.FixedColor := clAnovoMarca;
  AGrid.TitleFont.Name := FUENTE_SEMI;
  AGrid.TitleFont.Height := -11;
  AGrid.TitleFont.Color := clWhite;

  for i := 0 to AGrid.Columns.Count - 1 do
  begin
    AGrid.Columns[i].Title.Color := clAnovoMarca;
    AGrid.Columns[i].Title.Font.Name := FUENTE_SEMI;
    AGrid.Columns[i].Title.Font.Height := -11;
    AGrid.Columns[i].Title.Font.Color := clWhite;
  end;
end;

procedure AjustarColumnas(AGrid: TrDBGrid);
begin
  if (AGrid = nil) or (AGrid.DataSource = nil) or
     (AGrid.DataSource.DataSet = nil) or not AGrid.DataSource.DataSet.Active then
    Exit;

  AGrid.ColumnWidth := cwDataLabelWidth;
  AGrid.ColumnWidth := cwAutoWidth;
end;

procedure OcultarScrollVertical(AGrid: TrDBGrid);
var
  lBarra: Integer;
begin
  if (AGrid = nil) or (AGrid.Parent = nil) then
    Exit;

  if (AGrid.Parent.ClientWidth <= 0) or (AGrid.Parent.ClientHeight <= 0) then
    Exit;

  lBarra := GetSystemMetrics(SM_CXVSCROLL);

  AGrid.Align := alNone;
  AGrid.Anchors := [akLeft, akTop, akRight, akBottom];
  AGrid.SetBounds(0, 0, AGrid.Parent.ClientWidth + lBarra,
    AGrid.Parent.ClientHeight);
end;

procedure AlinearDerecha(AGrid: TrDBGrid; const ACampos: array of string);
var
  i, j: Integer;
begin
  if AGrid = nil then
    Exit;
  for i := 0 to AGrid.Columns.Count - 1 do
    for j := Low(ACampos) to High(ACampos) do
      if SameText(AGrid.Columns[i].FieldName, ACampos[j]) then
      begin
        AGrid.Columns[i].Alignment := taRightJustify;
        AGrid.Columns[i].Title.Alignment := taRightJustify;
      end;
end;

end.
