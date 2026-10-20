unit Anovo.UI.CeldasRejilla;

// Aspecto de las rejillas con lo que ya trae RosiComp y celdas propias
// (pastillas de estado y botones de fila) dibujadas desde sus eventos.

interface

uses
  System.Types, System.Classes, Data.DB, Vcl.Controls, Vcl.Graphics, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.VirtualImage, rDBGrid,
  VclPlano.Paleta;

const
  ALTO_FILA_LISTADO = 34;

procedure AplicarTemaGrid(AGrid: TrDBGrid; ASoloLectura: Boolean = True;
  AAltoFila: Integer = ALTO_FILA_LISTADO);

procedure TemarTitulos(AGrid: TrDBGrid);

procedure EditarCasillas(AGrid: TrDBGrid);

procedure AjustarColumnas(AGrid: TrDBGrid);

procedure AnchosAutomaticos(AGrid: TrDBGrid);

function EstadoPlano(const AEstado: string): TPlanoEstado;

function ComponenteDe(AGrid: TrDBGrid; AClase: TComponentClass): TComponent;

function ColumnaDe(AGrid: TrDBGrid; const ACampo: string): TColumn;

type
  TAccionRejilla = record
    Clave: string;
    Rotulo: string;
    Alterno: string;
    Campo: string;
  end;

  TEventoAccion = procedure(Sender: TObject; const AClave: string) of object;

  TCeldasRejilla = class(TComponent)
  private
    FGrid: TrDBGrid;
    FColumnasEstado: TArray<string>;
    FCampoAcciones: string;
    FAcciones: TArray<TAccionRejilla>;
    FOnAccion: TEventoAccion;
    FCeldaAnterior: TDrawColumnCellEvent;
    FUpAnterior: TMouseEvent;
    FMoveAnterior: TMouseMoveEvent;
    FCoordHover: TGridCoord;
    FBotonHover: Integer;
    FTextoVacio: string;
    FOcupada: Boolean;
    FEnlace: TDataLink;
    FSiguiendoFuente: Boolean;
    FAviso: TPanel;
    FCirculo: TShape;
    FIcono: TVirtualImage;
    FTitulo: TLabel;
    FDetalle: TLabel;
    procedure PonerTextoVacio(const AValor: string);
    procedure CrearAviso;
    procedure UbicarAviso;
    procedure AcomodarAviso(Sender: TObject);
    function EsColumnaEstado(const ACampo: string): Boolean;
    function TextoDeEstado(const ACampo: TField): string;
    function AnchoEstado(const AColumna: TColumn): Integer;
    procedure AjustarEstados;
    function SinFilas: Boolean;
    function FondoDeCelda(const ARect: TRect; AColumn: TColumn): TColor;
    procedure RellenarFondo(const ARect: TRect; AColumn: TColumn);
    procedure DibujarEstado(const ARect: TRect; AColumn: TColumn);
    procedure DibujarAcciones(const ARect: TRect; AColumn: TColumn);
    function AnchoRotulo(ACanvas: TCanvas; AIndice: Integer): Integer;
    function RotuloDe(AIndice: Integer): string;
    function RotuloEnFila(AIndice, AFila: Integer): string;
    function RectDeBoton(const ACelda: TRect; AIndice: Integer): TRect;
    function BotonEnPunto(AX, AY: Integer; out ACoord: TGridCoord): Integer;
    procedure RepintarCelda(const ACoord: TGridCoord);
    procedure DibujarCelda(Sender: TObject; const ARect: TRect;
      ADataCol: Integer; AColumn: TColumn; AState: TGridDrawState);
    procedure Pulsar(Sender: TObject; AButton: TMouseButton;
      AShift: TShiftState; AX, AY: Integer);
    procedure Mover(Sender: TObject; AShift: TShiftState; AX, AY: Integer);
  public
    constructor Crear(AGrid: TrDBGrid);
    destructor Destroy; override;

    class function De(AGrid: TrDBGrid): TCeldasRejilla;
    class function Buscar(AGrid: TrDBGrid): TCeldasRejilla;

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
    procedure RevisarVacio;
    procedure SeguirFuente;

    property TextoVacio: string read FTextoVacio write PonerTextoVacio;
    property CampoAcciones: string read FCampoAcciones;
    property OnAccion: TEventoAccion read FOnAccion write FOnAccion;
    property Ocupada: Boolean read FOcupada write FOcupada;
  end;

implementation

uses
  Winapi.Windows, System.SysUtils, System.Math, System.UITypes,
  Vcl.Forms, RosiCompGlobalCfg, VclPlano.Dibujo, VclPlano.Pastilla, Anovo.UI.Tema, Anovo.UI.ColumnasRejilla,
  Anovo.UI.Iconos, Anovo.Textos;

const
  MARGEN_CELDA = 10;
  ALTO_PASTILLA = 18;
  ALTO_BOTON = 22;
  RADIO_BOTON = 4;
  RELLENO_BOTON = 10;
  SEPARACION_BOTONES = 6;
  DIAMETRO_VACIO = 64;
  ICONO_VACIO = 40;
  ALTO_TITULO_VACIO = 24;
  ALTO_DETALLE_VACIO = 36;
  SEPARACION_VACIO = 8;
  ICONO_BUSCAR = 'Marca\12-buscar-marca';

type
  TRejillaAbierta = class(TrDBGrid);

  TEnlaceVacio = class(TDataLink)
  private
    FDueno: TCeldasRejilla;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
  end;

procedure TEnlaceVacio.ActiveChanged;
begin
  FDueno.RevisarVacio;
end;

procedure TEnlaceVacio.DataSetChanged;
begin
  FDueno.RevisarVacio;
end;

procedure FuenteDeCelda(ACanvas: TCanvas; ABase: TFont);
begin
  ACanvas.Font := ABase;
  ACanvas.Font.Name := FUENTE_SEMI;
  ACanvas.Font.Height := -11;
end;

function EstadoPlano(const AEstado: string): TPlanoEstado;
var
  e: string;
begin
  e := LowerCase(Trim(AEstado));
  if (e = 'borrador') or (e = 'pendiente') or (e = 'devuelta') or
    (e = 'recibida') or
    (e = 'programado') or (e = 'sin_guardar') then
    Result := fsPending
  else if (e = 'aprobada') or (e = 'activo') or (e = 'firmado') or
    (e = 'adicional') then
    Result := fsSuccess
  else if (e = 'rechazada') or (e = 'descartada') or (e = 'inactivo') or
    (e = 'revocado') or (e = 'quitado') then
    Result := fsDanger
  else if (e = 'enviada') or (e = 'visto_bueno') or (e = 'en_cotizacion') or
    (e = 'en cotizacion') then
    Result := fsInfo
  else
    Result := fsNeutral;
end;

constructor TCeldasRejilla.Crear(AGrid: TrDBGrid);
begin
  inherited Create(AGrid);
  FGrid := AGrid;
  FCoordHover.X := -1;
  FCoordHover.Y := -1;
  FBotonHover := -1;

  FCeldaAnterior := FGrid.OnDrawColumnCellEnd;
  FUpAnterior := FGrid.OnMouseUp;
  FMoveAnterior := FGrid.OnMouseMove;

  FGrid.OnDrawColumnCellEnd := DibujarCelda;
  FGrid.OnMouseUp := Pulsar;
  FGrid.OnMouseMove := Mover;
end;

destructor TCeldasRejilla.Destroy;
begin
  FreeAndNil(FEnlace);
  inherited;
end;

procedure TCeldasRejilla.PonerTextoVacio(const AValor: string);
begin
  FTextoVacio := AValor;
  if FAviso = nil then
    CrearAviso;
  FDetalle.Caption := AValor;
  SeguirFuente;
  RevisarVacio;
end;

procedure TCeldasRejilla.CrearAviso;
begin
  FAviso := TPanel.Create(Self);
  FAviso.Parent := FGrid;
  FAviso.Visible := False;
  FAviso.BevelOuter := bvNone;
  FAviso.ParentBackground := False;
  FAviso.Color := clAnovoTarjeta;
  FAviso.Caption := '';
  FAviso.Align := alClient;
  FAviso.AlignWithMargins := True;
  FAviso.OnResize := AcomodarAviso;

  FCirculo := TShape.Create(Self);
  FCirculo.Parent := FAviso;
  FCirculo.Shape := stCircle;
  FCirculo.Pen.Style := psClear;
  FCirculo.Brush.Color := clAnovoAcentoSuave;

  FIcono := TVirtualImage.Create(Self);
  FIcono.Parent := FAviso;
  FIcono.ImageCollection := dmIconos.IcAnovo;
  FIcono.ImageName := ICONO_BUSCAR;

  FTitulo := TLabel.Create(Self);
  FTitulo.Parent := FAviso;
  FTitulo.AutoSize := False;
  FTitulo.Alignment := taCenter;
  FTitulo.Tag := TAG_TITULO;
  FTitulo.Caption := SSinResultados;
  AplicarTemaEtiqueta(FTitulo);

  FDetalle := TLabel.Create(Self);
  FDetalle.Parent := FAviso;
  FDetalle.AutoSize := False;
  FDetalle.Alignment := taCenter;
  FDetalle.WordWrap := True;
  FDetalle.Tag := TAG_APOYO;
  AplicarTemaEtiqueta(FDetalle);

  FEnlace := TEnlaceVacio.Create;
  TEnlaceVacio(FEnlace).FDueno := Self;
end;

procedure TCeldasRejilla.RevisarVacio;
var
  lDatos: TDataSet;
  lVacio: Boolean;
begin
  if (FAviso = nil) or FSiguiendoFuente then
    Exit;

  lVacio := False;
  if FGrid.DataSource <> nil then
  begin
    lDatos := FGrid.DataSource.DataSet;
    lVacio := (lDatos <> nil) and lDatos.Active and lDatos.IsEmpty;
  end;

  if lVacio then
    UbicarAviso;
  FAviso.Visible := lVacio;
end;

procedure TCeldasRejilla.UbicarAviso;
var
  lSobra: Integer;
begin
  FAviso.Margins.Left := 0;
  FAviso.Margins.Bottom := 0;
  if dgTitles in FGrid.Options then
    FAviso.Margins.Top := TRejillaAbierta(FGrid).RowHeights[0] + 1
  else
    FAviso.Margins.Top := 0;
  lSobra := 0;
  if FGrid.Parent <> nil then
    lSobra := FGrid.Left + FGrid.Width - FGrid.Parent.ClientWidth;
  FAviso.Margins.Right := Max(lSobra, 0);
end;

procedure TCeldasRejilla.AcomodarAviso(Sender: TObject);
var
  lConIcono: Boolean;
  lAlto, lY, lAncho: Integer;
begin
  lAncho := FAviso.ClientWidth;
  lAlto := FGrid.ScaleValue(ALTO_TITULO_VACIO + ALTO_DETALLE_VACIO);
  lConIcono := FAviso.ClientHeight >= lAlto +
    FGrid.ScaleValue(DIAMETRO_VACIO + SEPARACION_VACIO * 3);
  if lConIcono then
    Inc(lAlto, FGrid.ScaleValue(DIAMETRO_VACIO + SEPARACION_VACIO));

  lY := Max((FAviso.ClientHeight - lAlto) div 2, 0);
  FCirculo.Visible := lConIcono;
  FIcono.Visible := lConIcono;
  if lConIcono then
  begin
    FCirculo.SetBounds((lAncho - FGrid.ScaleValue(DIAMETRO_VACIO)) div 2, lY,
      FGrid.ScaleValue(DIAMETRO_VACIO), FGrid.ScaleValue(DIAMETRO_VACIO));
    FIcono.SetBounds((lAncho - FGrid.ScaleValue(ICONO_VACIO)) div 2,
      lY + FGrid.ScaleValue(DIAMETRO_VACIO - ICONO_VACIO) div 2,
      FGrid.ScaleValue(ICONO_VACIO), FGrid.ScaleValue(ICONO_VACIO));
    Inc(lY, FGrid.ScaleValue(DIAMETRO_VACIO + SEPARACION_VACIO));
  end;
  FTitulo.SetBounds(0, lY, lAncho, FGrid.ScaleValue(ALTO_TITULO_VACIO));
  FDetalle.SetBounds(FGrid.ScaleValue(SEPARACION_VACIO * 2),
    lY + FGrid.ScaleValue(ALTO_TITULO_VACIO),
    Max(lAncho - FGrid.ScaleValue(SEPARACION_VACIO * 4), 0),
    FGrid.ScaleValue(ALTO_DETALLE_VACIO));
end;

function ComponenteDe(AGrid: TrDBGrid; AClase: TComponentClass): TComponent;
var
  I: Integer;
begin
  Result := nil;
  if AGrid = nil then
    Exit;
  for I := 0 to AGrid.ComponentCount - 1 do
    if AGrid.Components[I] is AClase then
      Exit(AGrid.Components[I]);
end;

function ColumnaDe(AGrid: TrDBGrid; const ACampo: string): TColumn;
var
  I: Integer;
begin
  for I := 0 to AGrid.Columns.Count - 1 do
    if SameText(AGrid.Columns[I].FieldName, ACampo) then
      Exit(AGrid.Columns[I]);
  Result := nil;
end;

class function TCeldasRejilla.Buscar(AGrid: TrDBGrid): TCeldasRejilla;
begin
  Result := TCeldasRejilla(ComponenteDe(AGrid, TCeldasRejilla));
end;

class function TCeldasRejilla.De(AGrid: TrDBGrid): TCeldasRejilla;
begin
  Result := Buscar(AGrid);
  if Result = nil then
    Result := TCeldasRejilla.Crear(AGrid);
end;

procedure TCeldasRejilla.ColumnaEstado(const ACampo: string);
begin
  if not EsColumnaEstado(ACampo) then
    FColumnasEstado := FColumnasEstado + [ACampo];
end;

procedure TCeldasRejilla.ColumnaAcciones(const ACampo: string);
begin
  FCampoAcciones := ACampo;
end;

procedure TCeldasRejilla.Agregar(const AClave, ARotulo: string);
var
  lNueva: TAccionRejilla;
begin
  lNueva.Clave := AClave;
  lNueva.Rotulo := ARotulo;
  FAcciones := FAcciones + [lNueva];
end;

procedure TCeldasRejilla.AgregarAlterna(const AClave, ARotulo, AAlterno,
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

function TCeldasRejilla.AnchoRotulo(ACanvas: TCanvas; AIndice: Integer): Integer;
begin
  Result := ACanvas.TextWidth(FAcciones[AIndice].Rotulo);
  if FAcciones[AIndice].Alterno <> '' then
    Result := Max(Result, ACanvas.TextWidth(FAcciones[AIndice].Alterno));
end;

function TCeldasRejilla.RotuloDe(AIndice: Integer): string;
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

function TCeldasRejilla.RotuloEnFila(AIndice, AFila: Integer): string;
var
  lEnlace: TGridDataLink;
  lAnterior: Integer;
begin
  lEnlace := TRejillaAbierta(FGrid).DataLink;
  if (FAcciones[AIndice].Campo = '') or not lEnlace.Active or
    (AFila < 0) or (AFila >= lEnlace.RecordCount) then
    Exit(RotuloDe(AIndice));
  lAnterior := lEnlace.ActiveRecord;
  try
    lEnlace.ActiveRecord := AFila;
    Result := RotuloDe(AIndice);
  finally
    lEnlace.ActiveRecord := lAnterior;
  end;
end;

procedure TCeldasRejilla.Limpiar;
begin
  SetLength(FAcciones, 0);
end;

procedure TCeldasRejilla.PonerLista(const AAcciones: array of TAccionRejilla);
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

procedure TCeldasRejilla.PonerAcciones<T>(const ATodas: array of TAccionRejilla;
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

function TCeldasRejilla.EsColumnaEstado(const ACampo: string): Boolean;
var
  lCampo: string;
begin
  for lCampo in FColumnasEstado do
    if SameText(lCampo, ACampo) then
      Exit(True);
  Result := False;
end;

function TCeldasRejilla.AnchoAcciones: Integer;
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

function TCeldasRejilla.TextoDeEstado(const ACampo: TField): string;
begin
  Result := ACampo.DisplayText;
  if (Result <> '') and (Result = ACampo.AsString) then
    Result := UpperCase(Result[1]) + Copy(Result, 2, MaxInt);
end;

function TCeldasRejilla.AnchoEstado(const AColumna: TColumn): Integer;
var
  I, lAnterior: Integer;
  lEnlace: TGridDataLink;
  lAux: Vcl.Graphics.TBitmap;
begin
  lAux := Vcl.Graphics.TBitmap.Create;
  try
    FuenteDeCelda(lAux.Canvas, FGrid.Font);
    Result := lAux.Canvas.TextWidth(AColumna.Title.Caption);
    lEnlace := TRejillaAbierta(FGrid).DataLink;
    if lEnlace.Active then
    begin
      lAnterior := lEnlace.ActiveRecord;
      try
        for I := 0 to lEnlace.RecordCount - 1 do
        begin
          lEnlace.ActiveRecord := I;
          Result := Max(Result, TPlanoPastilla.AnchoPara(lAux.Canvas,
            TextoDeEstado(AColumna.Field)));
        end;
      finally
        lEnlace.ActiveRecord := lAnterior;
      end;
    end;
  finally
    lAux.Free;
  end;
  Inc(Result, MARGEN_CELDA * 2);
end;

procedure TCeldasRejilla.AjustarEstados;
var
  lCampo: string;
  lColumna: TColumn;
begin
  for lCampo in FColumnasEstado do
  begin
    lColumna := ColumnaDe(FGrid, lCampo);
    if (lColumna = nil) or (lColumna.Field = nil) then
      Continue;
    if FGrid.FieldsFixedColumnWidth.IndexOf(lCampo) < 0 then
      FGrid.FieldsFixedColumnWidth.Add(lCampo);
    lColumna.Width := AnchoEstado(lColumna);
  end;
end;

procedure TCeldasRejilla.AjustarAcciones;
var
  lColumna: TColumn;
begin
  if FCampoAcciones = '' then
    Exit;

  if FGrid.FieldsFixedColumnWidth.IndexOf(FCampoAcciones) < 0 then
    FGrid.FieldsFixedColumnWidth.Add(FCampoAcciones);

  lColumna := ColumnaDe(FGrid, FCampoAcciones);
  if lColumna = nil then
    Exit;
  lColumna.Visible := Length(FAcciones) > 0;
  lColumna.Width := AnchoAcciones;
end;

procedure TCeldasRejilla.SeguirFuente;
begin
  if (FEnlace = nil) or FSiguiendoFuente or
    (FEnlace.DataSource = FGrid.DataSource) then
    Exit;
  FSiguiendoFuente := True;
  try
    FEnlace.DataSource := FGrid.DataSource;
  finally
    FSiguiendoFuente := False;
  end;
end;

procedure TCeldasRejilla.AjustarColumnas;
begin
  AjustarAcciones;
  AjustarEstados;
  Anovo.UI.CeldasRejilla.AjustarColumnas(FGrid);
  SeguirFuente;
  RevisarVacio;
end;

function TCeldasRejilla.SinFilas: Boolean;
begin
  Result := (FGrid.DataSource = nil) or (FGrid.DataSource.DataSet = nil) or
    not FGrid.DataSource.DataSet.Active or FGrid.DataSource.DataSet.IsEmpty;
end;

function TCeldasRejilla.FondoDeCelda(const ARect: TRect; AColumn: TColumn): TColor;
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

procedure TCeldasRejilla.RellenarFondo(const ARect: TRect; AColumn: TColumn);
begin
  FGrid.Canvas.Brush.Style := bsSolid;
  FGrid.Canvas.Brush.Color := FondoDeCelda(ARect, AColumn);
  FGrid.Canvas.FillRect(ARect);
end;

procedure TCeldasRejilla.DibujarEstado(const ARect: TRect; AColumn: TColumn);
var
  R: TRect;
  lValor, lEstado: string;
begin
  RellenarFondo(ARect, AColumn);
  lValor := AColumn.Field.AsString;
  if Trim(lValor) = '' then
    Exit;
  lEstado := TextoDeEstado(AColumn.Field);

  FuenteDeCelda(FGrid.Canvas, FGrid.Font);
  R.Left := ARect.Left + MARGEN_CELDA;
  R.Top := ARect.Top + (ARect.Height - ALTO_PASTILLA) div 2;
  R.Right := R.Left + TPlanoPastilla.AnchoPara(FGrid.Canvas, lEstado);
  R.Bottom := R.Top + ALTO_PASTILLA;
  if R.Right > ARect.Right then
    R.Right := ARect.Right;

  TPlanoPastilla.DibujarEn(FGrid.Canvas, R, lEstado, EstadoPlano(lValor));
end;

function TCeldasRejilla.RectDeBoton(const ACelda: TRect;
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

procedure TCeldasRejilla.DibujarAcciones(const ARect: TRect; AColumn: TColumn);
var
  I: Integer;
  lBoton, lHover: TRect;
  lTexto: TColor;
  lRotulo: string;
begin
  RellenarFondo(ARect, AColumn);
  FuenteDeCelda(FGrid.Canvas, FGrid.Font);
  if FCoordHover.X >= 0 then
    lHover := TRejillaAbierta(FGrid).CellRect(FCoordHover.X, FCoordHover.Y);

  for I := 0 to High(FAcciones) do
  begin
    lRotulo := RotuloDe(I);
    if lRotulo = '' then
      Continue;
    lBoton := RectDeBoton(ARect, I);
    if lBoton.Right > ARect.Right then
      Break;

    if (FBotonHover = I) and (FCoordHover.X >= 0) and (lHover.Top = ARect.Top) and
      (lHover.Left = ARect.Left) then
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
    FGrid.Canvas.TextRect(lBoton, lRotulo,
      [tfCenter, tfVerticalCenter, tfSingleLine]);
    FGrid.Canvas.Brush.Style := bsSolid;
  end;
end;

procedure TCeldasRejilla.DibujarCelda(Sender: TObject; const ARect: TRect;
  ADataCol: Integer; AColumn: TColumn; AState: TGridDrawState);
begin
  if (AColumn <> nil) and SinFilas then
    RellenarFondo(ARect, AColumn)
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

function TCeldasRejilla.BotonEnPunto(AX, AY: Integer;
  out ACoord: TGridCoord): Integer;
var
  lCelda: TRect;
  lColumna, I: Integer;
begin
  Result := -1;
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
    if (RotuloEnFila(I, ACoord.Y - 1) <> '') and
      PtInRect(RectDeBoton(lCelda, I), Point(AX, AY)) then
      Exit(I);
end;

procedure TCeldasRejilla.RepintarCelda(const ACoord: TGridCoord);
begin
  if (ACoord.X >= 0) and (ACoord.Y >= 0) then
    TRejillaAbierta(FGrid).InvalidateCell(ACoord.X, ACoord.Y);
end;

procedure TCeldasRejilla.Pulsar(Sender: TObject; AButton: TMouseButton;
  AShift: TShiftState; AX, AY: Integer);
var
  lBoton: Integer;
  lCoord: TGridCoord;
begin
  if Assigned(FUpAnterior) then
    FUpAnterior(Sender, AButton, AShift, AX, AY);

  if (AButton <> mbLeft) or FOcupada then
    Exit;

  lBoton := BotonEnPunto(AX, AY, lCoord);
  if (lBoton >= 0) and Assigned(FOnAccion) then
    FOnAccion(Self, FAcciones[lBoton].Clave);
end;

procedure TCeldasRejilla.Mover(Sender: TObject; AShift: TShiftState;
  AX, AY: Integer);
var
  lBoton: Integer;
  lCoord, lAnterior: TGridCoord;
begin
  if Assigned(FMoveAnterior) then
    FMoveAnterior(Sender, AShift, AX, AY);

  lBoton := BotonEnPunto(AX, AY, lCoord);
  if (lBoton = FBotonHover) and (lCoord.X = FCoordHover.X) and
    (lCoord.Y = FCoordHover.Y) then
    Exit;

  lAnterior := FCoordHover;
  FBotonHover := lBoton;
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
  AGrid.RowVerticalAlign := taVerticalCenter;

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

  TColumnasRejilla.Activar(AGrid);
end;

procedure EditarCasillas(AGrid: TrDBGrid);
begin
  TColumnasRejilla.Quitar(AGrid);
  AGrid.Options := AGrid.Options - [dgRowSelect] + [dgEditing];
  AGrid.ReadOnly := False;
  AGrid.OptionsEx2.Editors.BoolOneClickChange := True;
  TCeldasRejilla.De(AGrid);
end;

procedure TemarTitulos(AGrid: TrDBGrid);
var
  i: Integer;
begin
  if AGrid = nil then
    Exit;

  TCeldasRejilla.De(AGrid);
  AGrid.StyleElements := [];
  AGrid.DrawingStyle := gdsGradient;
  AGrid.GradientStartColor := clAnovoMarca;
  AGrid.GradientEndColor := clAnovoMarca;
  AGrid.OptionsEx2.Appearance.TitleFontStyleColor := False;

  AGrid.FixedColor := clAnovoMarca;
  AGrid.TitleFont.Name := FUENTE_SEMI;
  AGrid.TitleFont.Height := -11;
  AGrid.TitleFont.Color := clWhite;

  for i := 0 to AGrid.Columns.Count - 1 do
  begin
    AGrid.Columns[i].Title.Color := clAnovoMarca;
    AGrid.Columns[i].Title.Font.Color := clBlack;
    AGrid.Columns[i].Title.Font.Name := FUENTE_SEMI;
    AGrid.Columns[i].Title.Font.Height := -11;
    AGrid.Columns[i].Title.Font.Color := clWhite;
    if AGrid.Columns[i].Field is TBooleanField then
      AGrid.Columns[i].Title.Alignment := taCenter
    else
      AGrid.Columns[i].Title.Alignment := AGrid.Columns[i].Alignment;
  end;
end;

procedure AnchosAutomaticos(AGrid: TrDBGrid);
var
  lTotal, I: Integer;
begin
  AGrid.ColumnWidth := cwDataLabelWidth;
  lTotal := 0;
  for I := 0 to AGrid.Columns.Count - 1 do
    if AGrid.Columns[I].Visible then
      Inc(lTotal, AGrid.Columns[I].Width);
  if lTotal <= AGrid.ClientWidth then
    AGrid.ColumnWidth := cwAutoWidth;
end;

procedure AjustarColumnas(AGrid: TrDBGrid);
begin
  if (AGrid = nil) or (AGrid.DataSource = nil) or
     (AGrid.DataSource.DataSet = nil) or not AGrid.DataSource.DataSet.Active then
    Exit;

  AnchosAutomaticos(AGrid);
  if TColumnasRejilla.De(AGrid) <> nil then
    TColumnasRejilla.De(AGrid).Aplicar;
  TemarTitulos(AGrid);
end;

end.
