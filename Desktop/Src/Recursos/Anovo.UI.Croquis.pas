unit Anovo.UI.Croquis;

// Dibuja el croquis del movil (trazos en JSON, version 2 de ASDrawIso)
// escalado al area disponible, con las cotas y su medida.

interface

uses
  System.Types,
  System.UITypes,
  Vcl.Graphics;

function DibujarCroquis(const ACanvas: TCanvas; const AArea: TRect;
  const AJson: string): Boolean;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  System.Math,
  JsonDataObjects;

const
  MARGEN = 12;
  GROSOR_MAXIMO = 4;
  TIPO_COTA = 'cota';
  TIPO_BORRAR = 'borrar';
  FORMATO_METROS = '0.## m';

function ColorAndroid(const AValor: Int64): TColor;
var
  lArgb: Cardinal;
begin
  lArgb := Cardinal(AValor);
  Result := RGB((lArgb shr 16) and $FF, (lArgb shr 8) and $FF, lArgb and $FF);
end;

function DibujarCroquis(const ACanvas: TCanvas; const AArea: TRect;
  const AJson: string): Boolean;
var
  lRaiz: TJsonObject;
  lTrazos, lPuntos: TJsonArray;
  lTrazo: TJsonObject;
  I, K: Integer;
  lMinX, lMinY, lMaxX, lMaxY, lEscala: Double;
  lX, lY: Double;
  lPts: TArray<TPoint>;
  lMedio: TPoint;
  lTexto: string;
begin
  Result := False;
  if AJson.Trim.IsEmpty then
    Exit;

  lRaiz := TJsonObject.Parse(AJson) as TJsonObject;
  try
    lTrazos := lRaiz.A['trazos'];
    lMinX := MaxDouble;
    lMinY := MaxDouble;
    lMaxX := -MaxDouble;
    lMaxY := -MaxDouble;
    for I := 0 to lTrazos.Count - 1 do
    begin
      lPuntos := lTrazos.O[I].A['puntos'];
      for K := 0 to lPuntos.Count - 1 do
      begin
        lX := lPuntos.A[K].F[0];
        lY := lPuntos.A[K].F[1];
        lMinX := Min(lMinX, lX);
        lMinY := Min(lMinY, lY);
        lMaxX := Max(lMaxX, lX);
        lMaxY := Max(lMaxY, lY);
      end;
    end;
    if lMinX > lMaxX then
      Exit;

    lEscala := Min((AArea.Width - 2 * MARGEN) / Max(lMaxX - lMinX, 1),
      (AArea.Height - 2 * MARGEN) / Max(lMaxY - lMinY, 1));

    for I := 0 to lTrazos.Count - 1 do
    begin
      lTrazo := lTrazos.O[I];
      if lTrazo.S['tipo'] = TIPO_BORRAR then
        Continue;
      lPuntos := lTrazo.A['puntos'];
      SetLength(lPts, lPuntos.Count);
      for K := 0 to lPuntos.Count - 1 do
        lPts[K] := Point(AArea.Left + MARGEN +
          Round((lPuntos.A[K].F[0] - lMinX) * lEscala),
          AArea.Top + MARGEN + Round((lPuntos.A[K].F[1] - lMinY) * lEscala));
      if Length(lPts) = 0 then
        Continue;

      ACanvas.Pen.Color := ColorAndroid(lTrazo.L['color']);
      ACanvas.Pen.Width := EnsureRange(Round(lTrazo.F['grosor'] * lEscala),
        1, GROSOR_MAXIMO);
      if Length(lPts) = 1 then
        ACanvas.Ellipse(lPts[0].X - 2, lPts[0].Y - 2, lPts[0].X + 2,
          lPts[0].Y + 2)
      else
        ACanvas.Polyline(lPts);

      if (lTrazo.S['tipo'] = TIPO_COTA) and (Length(lPts) >= 2) then
      begin
        lMedio := Point((lPts[0].X + lPts[1].X) div 2,
          (lPts[0].Y + lPts[1].Y) div 2);
        lTexto := FormatFloat(FORMATO_METROS, lTrazo.F['metros']);
        ACanvas.Brush.Style := bsClear;
        ACanvas.Font.Color := ACanvas.Pen.Color;
        ACanvas.TextOut(lMedio.X + 4, lMedio.Y - ACanvas.TextHeight(lTexto) - 2,
          lTexto);
      end;
    end;
    Result := True;
  finally
    lRaiz.Free;
  end;
end;

end.
