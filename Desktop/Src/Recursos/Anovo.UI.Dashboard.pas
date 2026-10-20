unit Anovo.UI.Dashboard;

// Dibujo de las tarjetas de los dashboards sobre un TPaintBox: barras,
// avisos con pastillas, recuadros de etapa y filas de datos.

interface

uses
  System.SysUtils, System.Classes, System.Types,
  Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls;

type
  TFilaBarra = record
    Etiqueta: string;
    Cantidad: Integer;
    Color: TColor;
  end;

  TFilaAviso = record
    Id: Integer;
    Pastilla: string;
    ColorPastilla: TColor;
    Texto: string;
    Derecha: string;
    ColorDerecha: TColor;
    DerechaEnPastilla: Boolean;
  end;

  TRecuadroEtapa = record
    Etiqueta: string;
    Cantidad: Integer;
    Color: TColor;
  end;

  TFilaDato = record
    Concepto: string;
    Valor: string;
  end;

  TDibujoTarjeta = class(TComponent)
  private
    FPintura: TPaintBox;
    procedure Pintar(Sender: TObject);
  protected
    function AltoFila(ACanvas: TCanvas): Integer;
    function HayFilas: Boolean; virtual; abstract;
    procedure Dibujar(ACanvas: TCanvas; const AArea: TRect); virtual; abstract;
    procedure TextoEn(ACanvas: TCanvas; const ARect: TRect; const ATexto: string;
      AColor: TColor; ANegrita: Boolean; AAlineacion: Cardinal);
    procedure Pastilla(ACanvas: TCanvas; const ARect: TRect;
      const ATexto: string; AColor: TColor);
    function AnchoPastilla(ACanvas: TCanvas; const ATexto: string): Integer;
    procedure Separador(ACanvas: TCanvas; AIzquierda, ADerecha, AY: Integer);
    property Pintura: TPaintBox read FPintura;
  public
    constructor Crear(APintura: TPaintBox); virtual;
  end;

  TDibujoBarras = class(TDibujoTarjeta)
  private
    FFilas: TArray<TFilaBarra>;
  protected
    function HayFilas: Boolean; override;
    procedure Dibujar(ACanvas: TCanvas; const AArea: TRect); override;
  public
    procedure Poner(const AFilas: TArray<TFilaBarra>);
  end;

  TDibujoAvisos = class(TDibujoTarjeta)
  private
    FFilas: TArray<TFilaAviso>;
    FEncima: Integer;
    FOnAbrir: TProc<Integer>;
    function FilaEn(AY: Integer): Integer;
    procedure Mover(Sender: TObject; AShift: TShiftState; AX, AY: Integer);
    procedure Salir(Sender: TObject);
    procedure Pulsar(Sender: TObject);
  protected
    function HayFilas: Boolean; override;
    procedure Dibujar(ACanvas: TCanvas; const AArea: TRect); override;
  public
    constructor Crear(APintura: TPaintBox); override;
    procedure Poner(const AFilas: TArray<TFilaAviso>);
    property OnAbrir: TProc<Integer> read FOnAbrir write FOnAbrir;
  end;

  TDibujoEtapas = class(TDibujoTarjeta)
  private
    FRecuadros: TArray<TRecuadroEtapa>;
  protected
    function HayFilas: Boolean; override;
    procedure Dibujar(ACanvas: TCanvas; const AArea: TRect); override;
  public
    procedure Poner(const ARecuadros: TArray<TRecuadroEtapa>);
  end;

  TDibujoDatos = class(TDibujoTarjeta)
  private
    FFilas: TArray<TFilaDato>;
  protected
    function HayFilas: Boolean; override;
    procedure Dibujar(ACanvas: TCanvas; const AArea: TRect); override;
  public
    procedure Poner(const AFilas: TArray<TFilaDato>);
  end;

function ColorDeGrupo(const AGrupo: string): TColor;
function ColorDeNivel(const ANivel: string): TColor;
function ColorDeEstado(const AEstado: string): TColor;

implementation

uses
  Winapi.Windows, System.Math,
  VclPlano.Dibujo, VclPlano.Paleta,
  Anovo.UI.Tema,
  Anovo.Textos;

const
  FUENTE_NORMAL = 'Segoe UI';
  FUENTE_NEGRITA = 'Segoe UI Semibold';
  ALTO_LETRA = -13;
  MEZCLA_SUAVE = 86;
  MEZCLA_TEXTO = 30;
  MEZCLA_RIEL = 55;

function ColorDeGrupo(const AGrupo: string): TColor;
begin
  if AGrupo = 'esperando' then
    Result := clEstPendienteBarra
  else if AGrupo = 'elaboracion' then
    Result := clAnovoMarca
  else if AGrupo = 'enviada' then
    Result := clAnovoAcento
  else if AGrupo = 'aprobada' then
    Result := clEstAprobadaBarra
  else if (AGrupo = 'rechazada') or (AGrupo = 'devuelta') then
    Result := clEstRechazadaBarra
  else if AGrupo = 'sin_respuesta' then
    Result := clAnovoTextoSuave
  else
    Result := clAnovoMarca;
end;

function ColorDeNivel(const ANivel: string): TColor;
begin
  if ANivel = 'alto' then
    Result := clEstRechazadaBarra
  else if ANivel = 'medio' then
    Result := clEstPendienteBarra
  else
    Result := clAnovoTextoSuave;
end;

function ColorDeEstado(const AEstado: string): TColor;
begin
  if AEstado = 'borrador' then
    Result := clAnovoTextoSuave
  else if AEstado = 'en_revision' then
    Result := clEstPendienteBarra
  else if AEstado = 'devuelta' then
    Result := clEstRechazadaBarra
  else if (AEstado = 'visto_bueno') or (AEstado = 'enviada') then
    Result := clAnovoAcento
  else if AEstado = 'aprobada' then
    Result := clEstAprobadaBarra
  else
    Result := ColorDeGrupo(AEstado);
end;

function Suave(AColor: TColor): TColor;
begin
  Result := PlanoMezcla(AColor, clWhite, MEZCLA_SUAVE);
end;

function Fuerte(AColor: TColor): TColor;
begin
  Result := PlanoMezcla(AColor, clBlack, MEZCLA_TEXTO);
end;


constructor TDibujoTarjeta.Crear(APintura: TPaintBox);
begin
  inherited Create(APintura);
  FPintura := APintura;
  FPintura.OnPaint := Pintar;
end;

function TDibujoTarjeta.AltoFila(ACanvas: TCanvas): Integer;
begin
  Result := ACanvas.TextHeight('Ag') * 2 + 2;
end;

procedure TDibujoTarjeta.Pintar(Sender: TObject);
var
  lCanvas: TCanvas;
  lArea: TRect;
begin
  lCanvas := FPintura.Canvas;
  lArea := FPintura.ClientRect;
  lCanvas.Brush.Color := clAnovoTarjeta;
  lCanvas.FillRect(lArea);
  lCanvas.Font.Name := FUENTE_NORMAL;
  lCanvas.Font.Height := ALTO_LETRA;
  lCanvas.Font.Style := [];
  if HayFilas then
    Dibujar(lCanvas, lArea)
  else
    TextoEn(lCanvas, lArea, SVacioDashboard, clAnovoTextoSuave, False,
      DT_CENTER or DT_VCENTER);
end;

procedure TDibujoTarjeta.TextoEn(ACanvas: TCanvas; const ARect: TRect;
  const ATexto: string; AColor: TColor; ANegrita: Boolean;
  AAlineacion: Cardinal);
var
  R: TRect;
begin
  R := ARect;
  if ANegrita then
    ACanvas.Font.Name := FUENTE_NEGRITA
  else
    ACanvas.Font.Name := FUENTE_NORMAL;
  ACanvas.Font.Color := AColor;
  ACanvas.Brush.Style := bsClear;
  DrawText(ACanvas.Handle, PChar(ATexto), Length(ATexto), R,
    AAlineacion or DT_SINGLELINE or DT_VCENTER or DT_END_ELLIPSIS or
    DT_NOPREFIX);
  ACanvas.Brush.Style := bsSolid;
  ACanvas.Font.Name := FUENTE_NORMAL;
end;

function TDibujoTarjeta.AnchoPastilla(ACanvas: TCanvas;
  const ATexto: string): Integer;
begin
  ACanvas.Font.Height := ALTO_LETRA + 2;
  Result := ACanvas.TextWidth(ATexto) + ACanvas.TextHeight('Ag');
  ACanvas.Font.Height := ALTO_LETRA;
end;

procedure TDibujoTarjeta.Pastilla(ACanvas: TCanvas; const ARect: TRect;
  const ATexto: string; AColor: TColor);
begin
  PlanoRectRedondeado(ACanvas, ARect, ARect.Height div 2, Suave(AColor),
    clNone, 0);
  ACanvas.Font.Height := ALTO_LETRA + 2;
  TextoEn(ACanvas, ARect, ATexto, Fuerte(AColor), False, DT_CENTER);
  ACanvas.Font.Height := ALTO_LETRA;
end;

procedure TDibujoTarjeta.Separador(ACanvas: TCanvas; AIzquierda, ADerecha,
  AY: Integer);
begin
  ACanvas.Pen.Color := clAnovoBorde;
  ACanvas.Pen.Width := 1;
  ACanvas.MoveTo(AIzquierda, AY);
  ACanvas.LineTo(ADerecha, AY);
end;


procedure TDibujoBarras.Poner(const AFilas: TArray<TFilaBarra>);
begin
  FFilas := AFilas;
  Pintura.Invalidate;
end;

function TDibujoBarras.HayFilas: Boolean;
begin
  Result := Length(FFilas) > 0;
end;

procedure TDibujoBarras.Dibujar(ACanvas: TCanvas; const AArea: TRect);
var
  lFila: TFilaBarra;
  lAlto, lY, lMaximo, lRotulo, lCuenta, lGrueso, lAncho: Integer;
  lRiel, lLleno: TRect;
begin
  lAlto := AltoFila(ACanvas) - 4;
  lMaximo := 1;
  for lFila in FFilas do
    lMaximo := Max(lMaximo, lFila.Cantidad);
  lRotulo := Round(AArea.Width * 0.42);
  lCuenta := ACanvas.TextWidth('0000');
  lGrueso := Max(6, ACanvas.TextHeight('Ag') div 2);
  lY := AArea.Top;
  for lFila in FFilas do
  begin
    if lY + lAlto > AArea.Bottom then
      Break;
    TextoEn(ACanvas, Rect(AArea.Left, lY, AArea.Left + lRotulo - 8, lY + lAlto),
      lFila.Etiqueta, clAnovoTexto, False, DT_LEFT);
    lRiel := Rect(AArea.Left + lRotulo, lY + (lAlto - lGrueso) div 2,
      AArea.Right - lCuenta - 8, lY + (lAlto - lGrueso) div 2 + lGrueso);
    PlanoRectRedondeado(ACanvas, lRiel, lGrueso div 2,
      PlanoMezcla(clAnovoBorde, clWhite, MEZCLA_RIEL), clNone, 0);
    lAncho := Round(lRiel.Width * lFila.Cantidad / lMaximo);
    if lAncho > 0 then
    begin
      lLleno := lRiel;
      lLleno.Right := lLleno.Left + Max(lAncho, lGrueso);
      PlanoRectRedondeado(ACanvas, lLleno, lGrueso div 2, lFila.Color,
        clNone, 0);
    end;
    TextoEn(ACanvas, Rect(AArea.Right - lCuenta, lY, AArea.Right, lY + lAlto),
      lFila.Cantidad.ToString, clAnovoTexto, True, DT_RIGHT);
    Inc(lY, lAlto);
  end;
end;


constructor TDibujoAvisos.Crear(APintura: TPaintBox);
begin
  inherited Crear(APintura);
  FEncima := -1;
  APintura.OnMouseMove := Mover;
  APintura.OnMouseLeave := Salir;
  APintura.OnClick := Pulsar;
end;

procedure TDibujoAvisos.Poner(const AFilas: TArray<TFilaAviso>);
begin
  FFilas := AFilas;
  FEncima := -1;
  Pintura.Invalidate;
end;

function TDibujoAvisos.HayFilas: Boolean;
begin
  Result := Length(FFilas) > 0;
end;

function TDibujoAvisos.FilaEn(AY: Integer): Integer;
var
  lAlto: Integer;
begin
  Pintura.Canvas.Font.Name := FUENTE_NORMAL;
  Pintura.Canvas.Font.Height := ALTO_LETRA;
  lAlto := AltoFila(Pintura.Canvas);
  Result := AY div lAlto;
  if (Result < 0) or (Result >= Length(FFilas)) or
    ((Result + 1) * lAlto > Pintura.Height) then
    Result := -1;
end;

procedure TDibujoAvisos.Mover(Sender: TObject; AShift: TShiftState;
  AX, AY: Integer);
var
  lFila: Integer;
begin
  lFila := FilaEn(AY);
  if lFila = FEncima then
    Exit;
  FEncima := lFila;
  if (lFila >= 0) and Assigned(FOnAbrir) then
    Pintura.Cursor := crHandPoint
  else
    Pintura.Cursor := crDefault;
  Pintura.Invalidate;
end;

procedure TDibujoAvisos.Salir(Sender: TObject);
begin
  FEncima := -1;
  Pintura.Cursor := crDefault;
  Pintura.Invalidate;
end;

procedure TDibujoAvisos.Pulsar(Sender: TObject);
begin
  if (FEncima >= 0) and Assigned(FOnAbrir) then
    FOnAbrir(FFilas[FEncima].Id);
end;

procedure TDibujoAvisos.Dibujar(ACanvas: TCanvas; const AArea: TRect);
var
  I, lAlto, lY, lX, lDerecha, lAltoPastilla, lAncho: Integer;
  lFila: TFilaAviso;
begin
  lAlto := AltoFila(ACanvas);
  lAltoPastilla := ACanvas.TextHeight('Ag') + 4;
  lY := AArea.Top;
  for I := 0 to High(FFilas) do
  begin
    if lY + lAlto > AArea.Bottom then
      Break;
    lFila := FFilas[I];
    if I = FEncima then
    begin
      ACanvas.Brush.Color := clAnovoFondo;
      ACanvas.FillRect(Rect(AArea.Left, lY, AArea.Right, lY + lAlto));
    end;

    lX := AArea.Left + 2;
    if lFila.Pastilla <> '' then
    begin
      lAncho := AnchoPastilla(ACanvas, lFila.Pastilla);
      Pastilla(ACanvas, Rect(lX, lY + (lAlto - lAltoPastilla) div 2,
        lX + lAncho, lY + (lAlto - lAltoPastilla) div 2 + lAltoPastilla),
        lFila.Pastilla, lFila.ColorPastilla);
      Inc(lX, lAncho + 6);
    end;

    lDerecha := AArea.Right - 2;
    if lFila.Derecha <> '' then
    begin
      if lFila.DerechaEnPastilla then
      begin
        lAncho := AnchoPastilla(ACanvas, lFila.Derecha);
        Pastilla(ACanvas, Rect(lDerecha - lAncho, lY + (lAlto - lAltoPastilla)
          div 2, lDerecha, lY + (lAlto - lAltoPastilla) div 2 + lAltoPastilla),
          lFila.Derecha, lFila.ColorDerecha);
      end
      else
      begin
        lAncho := ACanvas.TextWidth(lFila.Derecha) + 4;
        TextoEn(ACanvas, Rect(lDerecha - lAncho, lY, lDerecha, lY + lAlto),
          lFila.Derecha, clAnovoTextoSuave, False, DT_RIGHT);
      end;
      Dec(lDerecha, lAncho + 8);
    end;

    TextoEn(ACanvas, Rect(lX, lY, lDerecha, lY + lAlto), lFila.Texto,
      clAnovoTexto, False, DT_LEFT);
    if I < High(FFilas) then
      Separador(ACanvas, AArea.Left, AArea.Right, lY + lAlto - 1);
    Inc(lY, lAlto);
  end;
end;


procedure TDibujoEtapas.Poner(const ARecuadros: TArray<TRecuadroEtapa>);
begin
  FRecuadros := ARecuadros;
  Pintura.Invalidate;
end;

function TDibujoEtapas.HayFilas: Boolean;
begin
  Result := Length(FRecuadros) > 0;
end;

procedure TDibujoEtapas.Dibujar(ACanvas: TCanvas; const AArea: TRect);
const
  SEPARACION = 8;
var
  I, lAncho, lX, lMedio: Integer;
  R: TRect;
  lRecuadro: TRecuadroEtapa;
begin
  lAncho := (AArea.Width - SEPARACION * (Length(FRecuadros) - 1)) div
    Length(FRecuadros);
  lX := AArea.Left;
  for I := 0 to High(FRecuadros) do
  begin
    lRecuadro := FRecuadros[I];
    R := Rect(lX, AArea.Top, lX + lAncho, AArea.Bottom);
    PlanoRectRedondeado(ACanvas, R, 6, Suave(lRecuadro.Color), clNone, 0);
    lMedio := R.Top + R.Height div 2;
    TextoEn(ACanvas, Rect(R.Left + 4, R.Top, R.Right - 4, lMedio),
      lRecuadro.Etiqueta, Fuerte(lRecuadro.Color), False, DT_CENTER or
      DT_BOTTOM);
    TextoEn(ACanvas, Rect(R.Left + 4, lMedio, R.Right - 4, R.Bottom - 4),
      lRecuadro.Cantidad.ToString, clAnovoTexto, True, DT_CENTER or DT_TOP);
    Inc(lX, lAncho + SEPARACION);
  end;
end;


procedure TDibujoDatos.Poner(const AFilas: TArray<TFilaDato>);
begin
  FFilas := AFilas;
  Pintura.Invalidate;
end;

function TDibujoDatos.HayFilas: Boolean;
begin
  Result := Length(FFilas) > 0;
end;

procedure TDibujoDatos.Dibujar(ACanvas: TCanvas; const AArea: TRect);
var
  I, lAlto, lY: Integer;
begin
  lAlto := AltoFila(ACanvas);
  lY := AArea.Top;
  for I := 0 to High(FFilas) do
  begin
    if lY + lAlto > AArea.Bottom then
      Break;
    TextoEn(ACanvas, Rect(AArea.Left + 2, lY, AArea.Right - 2, lY + lAlto),
      FFilas[I].Concepto, clAnovoTexto, False, DT_LEFT);
    TextoEn(ACanvas, Rect(AArea.Left + 2, lY, AArea.Right - 2, lY + lAlto),
      FFilas[I].Valor, clAnovoTexto, True, DT_RIGHT);
    if I < High(FFilas) then
      Separador(ACanvas, AArea.Left, AArea.Right, lY + lAlto - 1);
    Inc(lY, lAlto);
  end;
end;

end.
