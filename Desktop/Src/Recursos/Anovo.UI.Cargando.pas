unit Anovo.UI.Cargando;

// Indicador de carga: si la carga pasa del umbral, pone un velo con una
// tarjeta y un anillo de circulos sobre cada rejilla visible de la ventana.

interface

procedure IndicadorCarga(const AActivo: Boolean);

implementation

uses
  Winapi.Windows, System.Classes, System.SysUtils, System.Math,
  System.Types, System.Generics.Collections, Vcl.Controls, Vcl.ExtCtrls,
  Vcl.Graphics, Vcl.Forms, Vcl.DBGrids, rDBGrid, Anovo.UI.Tema, Anovo.Textos;

const
  UMBRAL_MS = 250;
  GIRO_MS = 90;
  CIRCULOS = 10;
  RADIO_ANILLO = 26;
  RADIO_CIRCULO = 4;
  RADIO_CABEZA = 6;
  ANCHO_TARJETA = 260;
  ALTO_TARJETA = 170;
  RADIO_TARJETA = 16;
  CAPAS_SOMBRA = 4;
  MARGEN = 12;
  ALTO_MINIMO_TARJETA = 120;
  OPACIDAD_MINIMA = 18;
  COLOR_VELO = TColor($00E6E6E6);

type
  TRejillaVelo = class(TrDBGrid);

  TVeloCarga = class(TCustomControl)
  private
    FPaso: Integer;
    procedure DibujarAnillo(const ACentro: TPoint);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Avanzar;
  end;

  TGestorCarga = class(TComponent)
  private
    FActivo: Boolean;
    FUmbral: TTimer;
    FGiro: TTimer;
    FVelos: TList<TVeloCarga>;
    procedure Umbral(Sender: TObject);
    procedure Girar(Sender: TObject);
    procedure Poner;
    procedure Quitar;
    procedure Buscar(AControl: TWinControl);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Cambiar(const AActivo: Boolean);
  end;

var
  Gestor: TGestorCarga;

function Mezcla(const AColor, AFondo: TColor; const AOpacidad: Integer): TColor;
var
  lColor, lFondo: Cardinal;
begin
  lColor := ColorToRGB(AColor);
  lFondo := ColorToRGB(AFondo);
  Result := RGB(
    (GetRValue(lColor) * AOpacidad + GetRValue(lFondo) * (100 - AOpacidad)) div 100,
    (GetGValue(lColor) * AOpacidad + GetGValue(lFondo) * (100 - AOpacidad)) div 100,
    (GetBValue(lColor) * AOpacidad + GetBValue(lFondo) * (100 - AOpacidad)) div 100);
end;

constructor TVeloCarga.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered := True;
  ControlStyle := ControlStyle + [csOpaque];
end;

procedure TVeloCarga.Avanzar;
begin
  FPaso := (FPaso + 1) mod CIRCULOS;
  Invalidate;
end;

procedure TVeloCarga.DibujarAnillo(const ACentro: TPoint);
var
  I, lOrden, lRadio, lOpacidad: Integer;
  lAngulo: Double;
  lPunto: TPoint;
begin
  Canvas.Pen.Style := psClear;
  for I := 0 to CIRCULOS - 1 do
  begin
    lOrden := (I - FPaso + CIRCULOS) mod CIRCULOS;
    lOpacidad := OPACIDAD_MINIMA + (100 - OPACIDAD_MINIMA) * (lOrden + 1)
      div CIRCULOS;
    if lOrden = CIRCULOS - 1 then
      lRadio := ScaleValue(RADIO_CABEZA)
    else
      lRadio := ScaleValue(RADIO_CIRCULO);
    lAngulo := -Pi / 2 + I * 2 * Pi / CIRCULOS;
    lPunto.X := ACentro.X + Round(ScaleValue(RADIO_ANILLO) * Cos(lAngulo));
    lPunto.Y := ACentro.Y + Round(ScaleValue(RADIO_ANILLO) * Sin(lAngulo));
    Canvas.Brush.Color := Mezcla(clAnovoAcento, clAnovoTarjeta, lOpacidad);
    Canvas.Ellipse(lPunto.X - lRadio, lPunto.Y - lRadio, lPunto.X + lRadio,
      lPunto.Y + lRadio);
  end;
  Canvas.Pen.Style := psSolid;
end;

procedure TVeloCarga.Paint;
var
  lTarjeta: TRect;
  lAncho, lAlto, I, lRadio: Integer;
  lCentro: TPoint;
  lTexto: string;
begin
  Canvas.Brush.Color := COLOR_VELO;
  Canvas.FillRect(ClientRect);

  lAncho := Min(ScaleValue(ANCHO_TARJETA), ClientWidth - ScaleValue(MARGEN) * 2);
  lAlto := Min(ScaleValue(ALTO_TARJETA), ClientHeight - ScaleValue(MARGEN) * 2);
  lCentro := Point(ClientWidth div 2, ClientHeight div 2);

  if lAlto < ScaleValue(ALTO_MINIMO_TARJETA) then
  begin
    DibujarAnillo(lCentro);
    Exit;
  end;

  lTarjeta := Rect(lCentro.X - lAncho div 2, lCentro.Y - lAlto div 2,
    lCentro.X + lAncho div 2, lCentro.Y + lAlto div 2);
  lRadio := ScaleValue(RADIO_TARJETA);

  Canvas.Pen.Style := psClear;
  for I := CAPAS_SOMBRA downto 1 do
  begin
    Canvas.Brush.Color := Mezcla(clBlack, COLOR_VELO, 4 * (CAPAS_SOMBRA - I + 1));
    Canvas.RoundRect(lTarjeta.Left - I + 2, lTarjeta.Top - I + 4,
      lTarjeta.Right + I + 2, lTarjeta.Bottom + I + 4, lRadio + I, lRadio + I);
  end;
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Color := clAnovoBorde;
  Canvas.Brush.Color := clAnovoTarjeta;
  Canvas.RoundRect(lTarjeta, lRadio, lRadio);

  DibujarAnillo(Point(lCentro.X, lTarjeta.Top + lAlto * 2 div 5));

  Canvas.Brush.Style := bsClear;
  Canvas.Font.Name := 'Segoe UI';
  Canvas.Font.Style := [fsBold];
  Canvas.Font.Height := -ScaleValue(13);
  Canvas.Font.Color := clAnovoTexto;
  lTexto := SCargandoDatos;
  Canvas.TextOut(lCentro.X - Canvas.TextWidth(lTexto) div 2,
    lTarjeta.Top + lAlto * 2 div 3, lTexto);
  Canvas.Font.Style := [];
  Canvas.Font.Height := -ScaleValue(11);
  Canvas.Font.Color := clAnovoTextoSuave;
  lTexto := SUnMomento;
  Canvas.TextOut(lCentro.X - Canvas.TextWidth(lTexto) div 2,
    lTarjeta.Top + lAlto * 2 div 3 + ScaleValue(22), lTexto);
  Canvas.Brush.Style := bsSolid;
end;

constructor TGestorCarga.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVelos := TList<TVeloCarga>.Create;
  FUmbral := TTimer.Create(Self);
  FUmbral.Enabled := False;
  FUmbral.Interval := UMBRAL_MS;
  FUmbral.OnTimer := Umbral;
  FGiro := TTimer.Create(Self);
  FGiro.Enabled := False;
  FGiro.Interval := GIRO_MS;
  FGiro.OnTimer := Girar;
end;

destructor TGestorCarga.Destroy;
begin
  Quitar;
  FVelos.Free;
  inherited;
end;

procedure TGestorCarga.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent is TVeloCarga) and
    (FVelos <> nil) then
    FVelos.Remove(TVeloCarga(AComponent));
end;

procedure TGestorCarga.Cambiar(const AActivo: Boolean);
begin
  if AActivo = FActivo then
    Exit;
  FActivo := AActivo;
  if AActivo then
    FUmbral.Enabled := True
  else
  begin
    FUmbral.Enabled := False;
    Quitar;
  end;
end;

procedure TGestorCarga.Umbral(Sender: TObject);
begin
  FUmbral.Enabled := False;
  if FActivo then
    Poner;
end;

procedure TGestorCarga.Girar(Sender: TObject);
var
  lVelo: TVeloCarga;
begin
  for lVelo in FVelos do
    lVelo.Avanzar;
end;

procedure TGestorCarga.Buscar(AControl: TWinControl);
var
  I, lArriba: Integer;
  lHijo: TControl;
  lGrid: TrDBGrid;
  lVelo: TVeloCarga;
begin
  for I := 0 to AControl.ControlCount - 1 do
  begin
    lHijo := AControl.Controls[I];
    if not lHijo.Visible or not (lHijo is TWinControl) then
      Continue;
    if lHijo is TrDBGrid then
    begin
      lGrid := TrDBGrid(lHijo);
      if not lGrid.Showing then
        Continue;
      lArriba := 0;
      if dgTitles in lGrid.Options then
        lArriba := TRejillaVelo(lGrid).RowHeights[0] + 1;
      lVelo := TVeloCarga.Create(lGrid);
      lVelo.FreeNotification(Self);
      lVelo.Parent := lGrid;
      lVelo.SetBounds(0, lArriba, lGrid.ClientWidth,
        Max(lGrid.ClientHeight - lArriba, 0));
      lVelo.Anchors := [akLeft, akTop, akRight, akBottom];
      lVelo.BringToFront;
      FVelos.Add(lVelo);
    end
    else
      Buscar(TWinControl(lHijo));
  end;
end;

procedure TGestorCarga.Poner;
var
  lVentana: TCustomForm;
begin
  lVentana := Screen.ActiveCustomForm;
  if lVentana = nil then
    lVentana := Application.MainForm;
  if lVentana = nil then
    Exit;
  Buscar(lVentana);
  FGiro.Enabled := FVelos.Count > 0;
end;

procedure TGestorCarga.Quitar;
begin
  FGiro.Enabled := False;
  while FVelos.Count > 0 do
    FVelos.Last.Free;
end;

procedure IndicadorCarga(const AActivo: Boolean);
begin
  if Gestor = nil then
    Gestor := TGestorCarga.Create(nil);
  Gestor.Cambiar(AActivo);
end;

initialization

finalization

FreeAndNil(Gestor);

end.
