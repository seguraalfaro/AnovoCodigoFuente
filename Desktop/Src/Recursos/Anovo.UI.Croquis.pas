unit Anovo.UI.Croquis;

// Dibuja el croquis del movil (JSON de ASDrawIso, versiones 2 y 3) escalado al
// area disponible: lineas, circulos en el plano de su cara, arcos, huecos, notas
// y cotas con su letra, incluidas las de cada lado de una figura.

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
  System.Generics.Collections,
  JsonDataObjects;

const
  MARGEN = 24;
  GROSOR_MAXIMO = 4;
  PASOS_ARCO = 32;
  RADIO_ANGULO = 24;
  DISTANCIA_ROTULO_ANGULO = 44;
  ALZA_ROTULO = 12;
  MARCA_COTA = 6;
  RELLENO_CAJA = 4;
  TIPO_COTA = 'cota';
  TIPO_BORRAR = 'borrar';
  TIPO_CIRCULO = 'circulo';
  TIPO_ARCO = 'arco';
  TIPO_TEXTO = 'texto';
  FORMA_DIAMETRO = 'diametro';
  FORMA_RADIO = 'radio';
  FORMA_ANGULO = 'angulo';
  FORMA_LADO = 'lado';
  PLANO_SUPERIOR = 'superior';
  PLANO_IZQUIERDA = 'izquierda';
  PLANO_DERECHA = 'derecha';
  PASOS_ELIPSE = 48;
  SEPARACION_LADO = 13;
  UNIDAD_GRADOS = 'grados';
  UNIDAD_PULGADAS = 'pulg';
  FORMATO_VALOR = '0.##';
  SIMBOLO_DIAMETRO = #$00D8' ';
  SIMBOLO_POR = #$00D7' ';
  SIMBOLO_GRADOS = #$00B0;
  COLOR_PENDIENTE: TColor = $0677D9;

type
  TPuntoF = record
    X, Y: Double;
  end;

function PuntoF(const AX, AY: Double): TPuntoF;
begin
  Result.X := AX;
  Result.Y := AY;
end;

function ColorAndroid(const AValor: Int64): TColor;
var
  lArgb: Cardinal;
begin
  lArgb := Cardinal(AValor);
  Result := RGB((lArgb shr 16) and $FF, (lArgb shr 8) and $FF, lArgb and $FF);
end;

function Distancia(const A, B: TPuntoF): Double;
begin
  Result := Hypot(B.X - A.X, B.Y - A.Y);
end;

function AnguloDe(const ADesde, AHacia: TPuntoF): Double;
begin
  Result := ArcTan2(AHacia.Y - ADesde.Y, AHacia.X - ADesde.X);
end;

function Positivo(const AAngulo: Double): Double;
begin
  Result := AAngulo;
  while Result < 0 do
    Result := Result + 2 * Pi;
  while Result >= 2 * Pi do
    Result := Result - 2 * Pi;
end;

function Barrido(const A1, A2: Double): Double;
begin
  Result := Positivo(A2 - A1);
  if Result > Pi then
    Result := Result - 2 * Pi;
end;

function CentroTresPuntos(const A, B, M: TPuntoF; out ACentro: TPuntoF): Boolean;
var
  lD, lA2, lB2, lM2: Double;
begin
  lD := 2 * (A.X * (B.Y - M.Y) + B.X * (M.Y - A.Y) + M.X * (A.Y - B.Y));
  Result := Abs(lD) >= 1;
  if not Result then
    Exit;
  lA2 := A.X * A.X + A.Y * A.Y;
  lB2 := B.X * B.X + B.Y * B.Y;
  lM2 := M.X * M.X + M.Y * M.Y;
  ACentro.X := (lA2 * (B.Y - M.Y) + lB2 * (M.Y - A.Y) + lM2 * (A.Y - B.Y)) / lD;
  ACentro.Y := (lA2 * (M.X - B.X) + lB2 * (A.X - M.X) + lM2 * (B.X - A.X)) / lD;
end;

function PuntosArco(const A, B, M: TPuntoF): TArray<TPuntoF>;
var
  lCentro: TPuntoF;
  lRadio, lInicio, lTotal, lAngulo: Double;
  K: Integer;
begin
  if not CentroTresPuntos(A, B, M, lCentro) then
    Exit(TArray<TPuntoF>.Create(A, B));
  lRadio := Distancia(lCentro, A);
  lInicio := AnguloDe(lCentro, A);
  lTotal := Positivo(AnguloDe(lCentro, B) - lInicio);
  if Positivo(AnguloDe(lCentro, M) - lInicio) > lTotal then
    lTotal := lTotal - 2 * Pi;
  SetLength(Result, PASOS_ARCO + 1);
  for K := 0 to PASOS_ARCO do
  begin
    lAngulo := lInicio + lTotal * K / PASOS_ARCO;
    Result[K] := PuntoF(lCentro.X + lRadio * Cos(lAngulo),
      lCentro.Y + lRadio * Sin(lAngulo));
  end;
end;

procedure EjesPlano(const APlano: string; out AE1, AE2: TPuntoF);
const
  MEDIO = 0.5;
var
  lS3: Double;
begin
  lS3 := Sqrt(3) / 2;
  AE1 := PuntoF(1, 0);
  AE2 := PuntoF(0, 1);
  if APlano = PLANO_SUPERIOR then
  begin
    AE1 := PuntoF(lS3, -MEDIO);
    AE2 := PuntoF(lS3, MEDIO);
  end
  else if APlano = PLANO_IZQUIERDA then
    AE1 := PuntoF(lS3, MEDIO)
  else if APlano = PLANO_DERECHA then
    AE1 := PuntoF(lS3, -MEDIO);
end;

function PuntosElipse(const ACentro: TPuntoF; const ARadio: Double;
  const APlano: string): TArray<TPuntoF>;
var
  lE1, lE2: TPuntoF;
  lAngulo: Double;
  K: Integer;
begin
  EjesPlano(APlano, lE1, lE2);
  SetLength(Result, PASOS_ELIPSE + 1);
  for K := 0 to PASOS_ELIPSE do
  begin
    lAngulo := 2 * Pi * K / PASOS_ELIPSE;
    Result[K] := PuntoF(
      ACentro.X + ARadio * (Cos(lAngulo) * lE1.X + Sin(lAngulo) * lE2.X),
      ACentro.Y + ARadio * (Cos(lAngulo) * lE1.Y + Sin(lAngulo) * lE2.Y));
  end;
end;

function DentroDePoligono(const APuntos: TArray<TPuntoF>; const AP: TPuntoF): Boolean;
var
  I, J: Integer;
begin
  Result := False;
  J := High(APuntos);
  for I := 0 to High(APuntos) do
  begin
    if ((APuntos[I].Y > AP.Y) <> (APuntos[J].Y > AP.Y)) and
      (AP.X < (APuntos[J].X - APuntos[I].X) * (AP.Y - APuntos[I].Y) /
      (APuntos[J].Y - APuntos[I].Y) + APuntos[I].X) then
      Result := not Result;
    J := I;
  end;
end;

function LeerPuntos(const ATrazo: TJsonObject): TArray<TPuntoF>;
var
  lPuntos: TJsonArray;
  K: Integer;
begin
  lPuntos := ATrazo.A['puntos'];
  SetLength(Result, lPuntos.Count);
  for K := 0 to lPuntos.Count - 1 do
    Result[K] := PuntoF(lPuntos.A[K].F[0], lPuntos.A[K].F[1]);
end;

function TextoCota(const ATrazo: TJsonObject): string;
var
  lUnidad: string;
begin
  if ATrazo.S['etiqueta'].IsEmpty then
    Exit(FormatFloat(FORMATO_VALOR, ATrazo.F['metros']) + ' m');
  if ATrazo.F['valor'] <= 0 then
    Exit(ATrazo.S['etiqueta'] + ' ?');
  Result := ATrazo.S['etiqueta'] + ' = ';
  if ATrazo.I['cantidad'] > 1 then
    Result := Result + IntToStr(ATrazo.I['cantidad']) + SIMBOLO_POR;
  if ATrazo.S['forma'] = FORMA_DIAMETRO then
    Result := Result + SIMBOLO_DIAMETRO
  else if ATrazo.S['forma'] = FORMA_RADIO then
    Result := Result + 'R ';
  Result := Result + FormatFloat(FORMATO_VALOR, ATrazo.F['valor']);
  lUnidad := ATrazo.S['unidad'];
  if lUnidad = UNIDAD_GRADOS then
    Result := Result + SIMBOLO_GRADOS
  else if lUnidad = UNIDAD_PULGADAS then
    Result := Result + '"'
  else
    Result := Result + ' ' + lUnidad;
end;

function DibujarCroquis(const ACanvas: TCanvas; const AArea: TRect;
  const AJson: string): Boolean;
var
  lRaiz: TJsonObject;
  lTrazos: TJsonArray;
  lPorId: TDictionary<Int64, TJsonObject>;
  lMinX, lMinY, lMaxX, lMaxY, lEscala: Double;

  procedure Abarcar(const AX, AY: Double);
  begin
    lMinX := Min(lMinX, AX);
    lMinY := Min(lMinY, AY);
    lMaxX := Max(lMaxX, AX);
    lMaxY := Max(lMaxY, AY);
  end;

  function Pantalla(const AP: TPuntoF): TPoint;
  begin
    Result := Point(AArea.Left + MARGEN + Round((AP.X - lMinX) * lEscala),
      AArea.Top + MARGEN + Round((AP.Y - lMinY) * lEscala));
  end;

  function APantalla(const APuntos: TArray<TPuntoF>): TArray<TPoint>;
  var
    K: Integer;
  begin
    SetLength(Result, Length(APuntos));
    for K := 0 to High(APuntos) do
      Result[K] := Pantalla(APuntos[K]);
  end;

  procedure Caja(const ATexto: string; const AX, AY: Integer;
    const AColor: TColor; const AAnclaje: Integer; const ABorde: Boolean);
  var
    lAncho, lAlto, lCentroX: Integer;
    lMarco: TRect;
  begin
    if ATexto.IsEmpty then
      Exit;
    lAncho := ACanvas.TextWidth(ATexto) + 2 * RELLENO_CAJA;
    lAlto := ACanvas.TextHeight(ATexto) + RELLENO_CAJA;
    lCentroX := AX;
    if AAnclaje < 0 then
      lCentroX := AX + lAncho div 2
    else if AAnclaje > 0 then
      lCentroX := AX - lAncho div 2;
    lMarco := Rect(lCentroX - lAncho div 2, AY - lAlto div 2,
      lCentroX + lAncho div 2, AY + lAlto div 2);
    if lMarco.Left < AArea.Left then
      lMarco.Offset(AArea.Left - lMarco.Left, 0);
    if lMarco.Right > AArea.Right then
      lMarco.Offset(AArea.Right - lMarco.Right, 0);
    if lMarco.Top < AArea.Top then
      lMarco.Offset(0, AArea.Top - lMarco.Top);
    if lMarco.Bottom > AArea.Bottom then
      lMarco.Offset(0, AArea.Bottom - lMarco.Bottom);
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := clWhite;
    ACanvas.Pen.Style := psSolid;
    ACanvas.Pen.Width := 1;
    ACanvas.Pen.Color := AColor;
    if ABorde then
      ACanvas.Rectangle(lMarco)
    else
      ACanvas.FillRect(lMarco);
    ACanvas.Brush.Style := bsClear;
    ACanvas.Font.Color := AColor;
    ACanvas.TextOut(lMarco.Left + RELLENO_CAJA, lMarco.Top + RELLENO_CAJA div 2,
      ATexto);
  end;

  procedure MarcasCota(const A, B: TPoint);
  var
    lAngulo, lDx, lDy: Double;
  begin
    lAngulo := ArcTan2(B.Y - A.Y, B.X - A.X) + Pi / 2;
    lDx := Cos(lAngulo) * MARCA_COTA;
    lDy := Sin(lAngulo) * MARCA_COTA;
    ACanvas.MoveTo(A.X + Round(lDx), A.Y + Round(lDy));
    ACanvas.LineTo(A.X - Round(lDx), A.Y - Round(lDy));
    ACanvas.MoveTo(B.X + Round(lDx), B.Y + Round(lDy));
    ACanvas.LineTo(B.X - Round(lDx), B.Y - Round(lDy));
  end;

  function CentroDe(const AFigura: TJsonObject; out ACentro: TPuntoF): Boolean;
  var
    lPts: TArray<TPuntoF>;
  begin
    lPts := LeerPuntos(AFigura);
    Result := False;
    if (AFigura.S['tipo'] = TIPO_CIRCULO) and (Length(lPts) >= 2) then
    begin
      ACentro := lPts[0];
      Result := True;
    end
    else if (AFigura.S['tipo'] = TIPO_ARCO) and (Length(lPts) >= 3) then
      Result := CentroTresPuntos(lPts[0], lPts[1], lPts[2], ACentro);
  end;

  procedure DibujarFigura(const ATrazo: TJsonObject);
  var
    lPts: TArray<TPuntoF>;
    lPantalla: TArray<TPoint>;
    lCentro: TPoint;
    lRadio: Integer;
    lColor: TColor;
    lHueco: Boolean;
    lE1, lE2: TPuntoF;
  begin
    lPts := LeerPuntos(ATrazo);
    if Length(lPts) = 0 then
      Exit;
    lColor := ColorAndroid(ATrazo.L['color']);
    lHueco := ATrazo.B['hueco'];
    ACanvas.Pen.Style := psSolid;
    ACanvas.Pen.Color := lColor;
    ACanvas.Pen.Width := EnsureRange(Round(ATrazo.F['grosor'] * lEscala), 1,
      GROSOR_MAXIMO);
    ACanvas.Brush.Color := lColor;
    if lHueco then
      ACanvas.Brush.Style := bsBDiagonal
    else
      ACanvas.Brush.Style := bsClear;

    if ATrazo.S['tipo'] = TIPO_TEXTO then
    begin
      lCentro := Pantalla(lPts[0]);
      Caja(ATrazo.S['texto'], lCentro.X, lCentro.Y, lColor, 0, False);
    end
    else if (ATrazo.S['tipo'] = TIPO_CIRCULO) and (Length(lPts) >= 2) then
    begin
      lCentro := Pantalla(lPts[0]);
      lRadio := Round(Distancia(lPts[0], lPts[1]) * lEscala);
      lPantalla := APantalla(PuntosElipse(lPts[0], Distancia(lPts[0], lPts[1]),
        ATrazo.S['plano']));
      if lHueco then
        ACanvas.Polygon(lPantalla)
      else
        ACanvas.Polyline(lPantalla);
      if lHueco then
      begin
        EjesPlano(ATrazo.S['plano'], lE1, lE2);
        ACanvas.Pen.Width := 1;
        lRadio := lRadio + RELLENO_CAJA;
        ACanvas.MoveTo(lCentro.X - Round(lRadio * lE1.X), lCentro.Y - Round(lRadio * lE1.Y));
        ACanvas.LineTo(lCentro.X + Round(lRadio * lE1.X), lCentro.Y + Round(lRadio * lE1.Y));
        ACanvas.MoveTo(lCentro.X - Round(lRadio * lE2.X), lCentro.Y - Round(lRadio * lE2.Y));
        ACanvas.LineTo(lCentro.X + Round(lRadio * lE2.X), lCentro.Y + Round(lRadio * lE2.Y));
      end;
    end
    else if (ATrazo.S['tipo'] = TIPO_ARCO) and (Length(lPts) >= 3) then
      ACanvas.Polyline(APantalla(PuntosArco(lPts[0], lPts[1], lPts[2])))
    else
    begin
      lPantalla := APantalla(lPts);
      if Length(lPantalla) = 1 then
        ACanvas.Ellipse(lPantalla[0].X - 2, lPantalla[0].Y - 2,
          lPantalla[0].X + 2, lPantalla[0].Y + 2)
      else if lHueco then
        ACanvas.Polygon(lPantalla)
      else
        ACanvas.Polyline(lPantalla);
    end;
  end;

  procedure DibujarLado(const ATrazo: TJsonObject; const AColor: TColor);
  var
    lFigura: TJsonObject;
    lPts: TArray<TPuntoF>;
    lLado: Integer;
    lA, lB, lMedio, lFuera: TPuntoF;
    lNormal, lSeparacion, lSentido, lDistancia: Double;
    lPos, lMedioPantalla: TPoint;
    lTexto: string;
  begin
    if not lPorId.TryGetValue(ATrazo.I['ref'], lFigura) then
      Exit;
    lPts := LeerPuntos(lFigura);
    lLado := ATrazo.I['lado'];
    if (lLado < 0) or (lLado > High(lPts) - 1) then
      Exit;
    lA := lPts[lLado];
    lB := lPts[lLado + 1];
    lNormal := AnguloDe(lA, lB) - Pi / 2;
    lSeparacion := SEPARACION_LADO / Max(lEscala, 0.01);
    lMedio := PuntoF((lA.X + lB.X) / 2, (lA.Y + lB.Y) / 2);
    lFuera := PuntoF(lMedio.X + Cos(lNormal) * lSeparacion,
      lMedio.Y + Sin(lNormal) * lSeparacion);
    lSentido := 1;
    if (Length(lPts) > 3) and (Distancia(lPts[0], lPts[High(lPts)]) < 1) and
      DentroDePoligono(lPts, lFuera) then
      lSentido := -1;
    lTexto := TextoCota(ATrazo);
    lDistancia := SEPARACION_LADO / 2 +
      Abs(Cos(lNormal)) * (ACanvas.TextWidth(lTexto) + 2 * RELLENO_CAJA) / 2 +
      Abs(Sin(lNormal)) * (ACanvas.TextHeight(lTexto) + RELLENO_CAJA) / 2;
    lMedioPantalla := Pantalla(lMedio);
    lPos := Point(lMedioPantalla.X + Round(lSentido * Cos(lNormal) * lDistancia),
      lMedioPantalla.Y + Round(lSentido * Sin(lNormal) * lDistancia));
    Caja(lTexto, lPos.X, lPos.Y, AColor, 0, True);
  end;

  procedure DibujarCota(const ATrazo: TJsonObject);
  var
    lPts, lArco: TArray<TPuntoF>;
    lA, lB, lBorde, lPos, lCentroPantalla: TPoint;
    lColor: TColor;
    lFigura: TJsonObject;
    lCentro, lVertice: TPuntoF;
    lInicio, lDelta, lMitad: Double;
    K, lAnclaje: Integer;
  begin
    lColor := ColorAndroid(ATrazo.L['color']);
    if (not ATrazo.S['etiqueta'].IsEmpty) and (ATrazo.F['valor'] <= 0) then
      lColor := COLOR_PENDIENTE;
    ACanvas.Pen.Color := lColor;
    ACanvas.Pen.Width := 1;
    ACanvas.Pen.Style := psSolid;
    ACanvas.Brush.Style := bsClear;

    if ATrazo.S['forma'] = FORMA_LADO then
    begin
      DibujarLado(ATrazo, lColor);
      Exit;
    end;
    lPts := LeerPuntos(ATrazo);
    if Length(lPts) < 2 then
      Exit;

    if (ATrazo.S['forma'] = FORMA_DIAMETRO) or (ATrazo.S['forma'] = FORMA_RADIO) then
    begin
      lBorde := Pantalla(lPts[0]);
      lPos := Pantalla(lPts[1]);
      if lPorId.TryGetValue(ATrazo.I['ref'], lFigura) and CentroDe(lFigura, lCentro) then
      begin
        lCentroPantalla := Pantalla(lCentro);
        if ATrazo.S['forma'] = FORMA_DIAMETRO then
          ACanvas.MoveTo(2 * lCentroPantalla.X - lBorde.X, 2 * lCentroPantalla.Y - lBorde.Y)
        else
          ACanvas.MoveTo(lCentroPantalla.X, lCentroPantalla.Y);
        ACanvas.LineTo(lBorde.X, lBorde.Y);
      end;
      ACanvas.MoveTo(lBorde.X, lBorde.Y);
      ACanvas.LineTo(lPos.X, lPos.Y);
      lAnclaje := 1;
      if lPos.X >= lBorde.X then
        lAnclaje := -1;
      Caja(TextoCota(ATrazo), lPos.X, lPos.Y, lColor, lAnclaje, True);
    end
    else if (ATrazo.S['forma'] = FORMA_ANGULO) and (Length(lPts) >= 3) then
    begin
      lVertice := lPts[0];
      lA := Pantalla(lPts[0]);
      lB := Pantalla(lPts[1]);
      ACanvas.MoveTo(lA.X, lA.Y);
      ACanvas.LineTo(lB.X, lB.Y);
      lB := Pantalla(lPts[2]);
      ACanvas.MoveTo(lA.X, lA.Y);
      ACanvas.LineTo(lB.X, lB.Y);
      lInicio := AnguloDe(lVertice, lPts[1]);
      lDelta := Barrido(lInicio, AnguloDe(lVertice, lPts[2]));
      SetLength(lArco, 17);
      for K := 0 to 16 do
        lArco[K] := PuntoF(lA.X + RADIO_ANGULO * Cos(lInicio + lDelta * K / 16),
          lA.Y + RADIO_ANGULO * Sin(lInicio + lDelta * K / 16));
      ACanvas.MoveTo(Round(lArco[0].X), Round(lArco[0].Y));
      for K := 1 to 16 do
        ACanvas.LineTo(Round(lArco[K].X), Round(lArco[K].Y));
      lMitad := lInicio + lDelta / 2;
      Caja(TextoCota(ATrazo), lA.X + Round(DISTANCIA_ROTULO_ANGULO * Cos(lMitad)),
        lA.Y + Round(DISTANCIA_ROTULO_ANGULO * Sin(lMitad)), lColor, 0, True);
    end
    else
    begin
      lA := Pantalla(lPts[0]);
      lB := Pantalla(lPts[1]);
      ACanvas.Pen.Style := psDash;
      ACanvas.MoveTo(lA.X, lA.Y);
      ACanvas.LineTo(lB.X, lB.Y);
      ACanvas.Pen.Style := psSolid;
      MarcasCota(lA, lB);
      Caja(TextoCota(ATrazo), (lA.X + lB.X) div 2,
        (lA.Y + lB.Y) div 2 - ALZA_ROTULO, lColor, 0, True);
    end;
  end;

var
  I: Integer;
  lTrazo: TJsonObject;
  lPts: TArray<TPuntoF>;
  lRadio: Double;
  lPunto: TPuntoF;
begin
  Result := False;
  if AJson.Trim.IsEmpty then
    Exit;

  try
    lRaiz := TJsonObject.Parse(AJson) as TJsonObject;
  except
    on EJsonException do
      Exit;
  end;
  lPorId := TDictionary<Int64, TJsonObject>.Create;
  try
    lTrazos := lRaiz.A['trazos'];
    for I := 0 to lTrazos.Count - 1 do
      if lTrazos.Types[I] <> jdtObject then
        Exit;
    lMinX := MaxDouble;
    lMinY := MaxDouble;
    lMaxX := -MaxDouble;
    lMaxY := -MaxDouble;
    for I := 0 to lTrazos.Count - 1 do
    begin
      lTrazo := lTrazos.O[I];
      if lTrazo.L['id'] > 0 then
        lPorId.AddOrSetValue(lTrazo.L['id'], lTrazo);
      lPts := LeerPuntos(lTrazo);
      for lPunto in lPts do
        Abarcar(lPunto.X, lPunto.Y);
      if (lTrazo.S['tipo'] = TIPO_CIRCULO) and (Length(lPts) >= 2) then
      begin
        lRadio := Distancia(lPts[0], lPts[1]);
        for lPunto in PuntosElipse(lPts[0], lRadio, lTrazo.S['plano']) do
          Abarcar(lPunto.X, lPunto.Y);
      end;
      if (lTrazo.S['tipo'] = TIPO_ARCO) and (Length(lPts) >= 3) then
        for lPunto in PuntosArco(lPts[0], lPts[1], lPts[2]) do
          Abarcar(lPunto.X, lPunto.Y);
    end;
    if lMinX > lMaxX then
      Exit;

    lEscala := Min((AArea.Width - 2 * MARGEN) / Max(lMaxX - lMinX, 1),
      (AArea.Height - 2 * MARGEN) / Max(lMaxY - lMinY, 1));

    SetBkMode(ACanvas.Handle, TRANSPARENT);
    for I := 0 to lTrazos.Count - 1 do
    begin
      lTrazo := lTrazos.O[I];
      if (lTrazo.S['tipo'] <> TIPO_BORRAR) and (lTrazo.S['tipo'] <> TIPO_COTA) then
        DibujarFigura(lTrazo);
    end;
    for I := 0 to lTrazos.Count - 1 do
    begin
      lTrazo := lTrazos.O[I];
      if lTrazo.S['tipo'] = TIPO_COTA then
        DibujarCota(lTrazo);
    end;
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Pen.Style := psSolid;
    Result := True;
  finally
    lPorId.Free;
    lRaiz.Free;
  end;
end;

end.
