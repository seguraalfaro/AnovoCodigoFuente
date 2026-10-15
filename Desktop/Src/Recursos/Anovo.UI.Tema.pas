unit Anovo.UI.Tema;

// Tema visual del escritorio: paleta, letras y el recorrido que
// aplica cada rol segun el Tag del control.

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Types,
  System.ImageList, Vcl.TitleBarCtrls,
  Vcl.Graphics, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.ComCtrls, Vcl.ImgList, Vcl.Buttons,
  VclPlano.Tarjeta;

const

  clAnovoMarca = TColor($005C3A1A);
  clAnovoCabecera = TColor($005C3A1A);
  clAnovoAcento = TColor($00A06029);
  clAnovoAcentoClaro = TColor($008A5C2E);
  clAnovoAcentoSuave = TColor($00F5E4D6);
  clAnovoAcentoHover = TColor($00ECD0B8);

  clAnovoLateralTexto = TColor($00E8DCD0);
  clAnovoLateralTenue = TColor($00C1B8B0);

  clAnovoFondo = TColor($00FAF7F5);
  clAnovoTarjeta = TColor($00FFFFFF);
  clAnovoBorde = TColor($00E4DED9);
  clAnovoSuave = TColor($00E8DCD0);
  clAnovoSeleccion = TColor($00F5E4D6);
  clAnovoAvisoSuave = TColor($00DAEEFA);
  clAnovoAvisoMedio = TColor($00A4D9F7);
  clAnovoErrorSuave = TColor($00E6E6FD);
  clAnovoFondoIngreso = TColor($00E5DED9);
  RADIO_TARJETA = 12;
  clAnovoFilaAlterna = TColor($00FAF7F5);
  clAnovoDeshabilitado = TColor($00C1B8B0);

  clAnovoTexto = TColor($001E1C1C);
  clAnovoTextoSuave = TColor($0080726B);
  clAnovoTextoTenue = TColor($0080726B);

  clEstBorradorBarra = TColor($000B9EF5);
  clEstBorradorFondo = TColor($000B9EF5);
  clEstBorradorTexto = TColor($001E1C1C);

  clEstPendienteBarra = TColor($000B9EF5);
  clEstPendienteFondo = TColor($000B9EF5);
  clEstPendienteTexto = TColor($001E1C1C);

  clEstAprobadaBarra = TColor($005EC522);
  clEstAprobadaFondo = TColor($005EC522);
  clEstAprobadaTexto = clWhite;

  clEstRechazadaBarra = TColor($004444EF);
  clEstRechazadaFondo = TColor($004444EF);
  clEstRechazadaTexto = clWhite;

  clEstEnviadaBarra = TColor($00A06029);
  clEstEnviadaFondo = TColor($00A06029);
  clEstEnviadaTexto = clWhite;

  MARGEN = 16;
  SEPARACION = 8;
  ALTO_FILA = 56;
  ALTO_CABECERA = 28;
  RADIO = 8;
  RADIO_KPI = 4;

  FUENTE = 'Segoe UI';
  FUENTE_SEMI = 'Segoe UI Semibold';

  TAG_NINGUNO = 0;
  TAG_RAW = 1;

  TAG_FONDO = 2;
  TAG_CARD = 3;
  TAG_CABECERA = 4;
  TAG_BARRA = 5;
  TAG_SEP = 6;

  TAG_KPI_ACENTO = 7;
  TAG_KPI_AMBAR = 8;
  TAG_KPI_VERDE = 9;
  TAG_KPI_MARCA = 10;

  TAG_TITULO = 11;
  TAG_TITULO_GRANDE = 22;
  TAG_TEXTO_LATERAL = 23;

  TAG_TEXTO_LATERAL_FUERTE = 24;

  TAG_VALOR = 25;
  TAG_SECCION = 12;
  TAG_APOYO = 13;
  TAG_ERROR = 14;
  TAG_LINK = 15;
  TAG_CIFRA = 16;

  TAG_BTN_PRIMARIO = 17;
  TAG_BTN_APROBAR = 18;
  TAG_BTN_RECHAZAR = 19;
  TAG_BTN_AVISO = 20;
  TAG_BTN_SECUNDARIO = 21;

type
  TAnovoRolTexto = (rtTituloGrande, rtTitulo, rtSeccion, rtCuerpo, rtApoyo,
    rtCifra, rtCabecera, rtCifraKPI, rtNotaKPI, rtEnlace, rtError, rtLateral,
    rtLateralFuerte, rtValor);

procedure AplicarTemaBarraTitulo(AFormulario: TCustomForm;
  APanel: TCustomTitleBarPanel; AAlto: Integer = 0);

procedure AplicarTarjeta(APanel: TPanel);
procedure AplicarSuperficie(APanel: TPanel; AColor: TColor);

function EsKPI(ATag: NativeInt): Boolean;
function EsBoton(ATag: NativeInt): Boolean;

procedure AplicarTema(AFormulario: TCustomForm);
procedure AplicarTemaControl(AControl: TControl);
procedure AplicarTemaEnCascada(AContenedor: TWinControl);

procedure AplicarTemaFrame(AFrame: TFrame);

procedure AplicarTemaPanel(APanel: TPanel);
procedure AplicarTemaBoton(ABoton: TSpeedButton);
procedure AplicarTemaEtiqueta(ALabel: TLabel);
procedure AplicarTemaGroupBox(AGroupBox: TGroupBox);
procedure AplicarTemaListView(AListView: TListView);
procedure AplicarTemaTarjeta(ATarjeta: TPlanoTarjeta);

procedure AplicarTemaControlEstandar(AControl: TControl);

procedure AplicarTemaRotuloRosi(AControl: TControl);

procedure DibujarSombra(ACanvas: TCanvas; const AMarco: TRect;
  const AFondo: TColor);

procedure RedondearEsquinas(AControl: TWinControl);

implementation

uses
  System.TypInfo,
  VclPlano.Paleta;

const
  CAPAS_SOMBRA = 10;
  INTENSIDAD_SOMBRA = 3;

procedure DibujarSombra(ACanvas: TCanvas; const AMarco: TRect;
  const AFondo: TColor);
var
  I: Integer;
  R: TRect;
  lColor: TColor;
begin
  ACanvas.Pen.Style := psSolid;
  ACanvas.Brush.Style := bsSolid;
  for I := CAPAS_SOMBRA downto 1 do
  begin
    R := AMarco;
    InflateRect(R, I, I);
    OffsetRect(R, 0, I div 2 + 2);
    lColor := PlanoMezcla(AFondo, clAnovoMarca,
      (CAPAS_SOMBRA - I + 1) * INTENSIDAD_SOMBRA);
    ACanvas.Pen.Color := lColor;
    ACanvas.Brush.Color := lColor;
    ACanvas.RoundRect(R, RADIO_TARJETA * 2 + I, RADIO_TARJETA * 2 + I);
  end;

  R := AMarco;
  InflateRect(R, 1, 1);
  ACanvas.Brush.Style := bsClear;
  ACanvas.Pen.Color := clAnovoBorde;
  ACanvas.RoundRect(R, RADIO_TARJETA * 2, RADIO_TARJETA * 2);
  ACanvas.Brush.Style := bsSolid;
end;

procedure RedondearEsquinas(AControl: TWinControl);
begin
  SetWindowRgn(AControl.Handle, CreateRoundRectRgn(0, 0, AControl.Width + 1,
    AControl.Height + 1, RADIO_TARJETA * 2, RADIO_TARJETA * 2), True);
end;

procedure AplicarTemaBarraTitulo(AFormulario: TCustomForm;
  APanel: TCustomTitleBarPanel; AAlto: Integer = 0);
begin

  if (APanel = nil) or not AFormulario.CustomTitleBar.Supported then
    Exit;

  AFormulario.CustomTitleBar.Control := APanel;
  AFormulario.CustomTitleBar.Enabled := True;
  AFormulario.CustomTitleBar.SystemColors := False;
  AFormulario.CustomTitleBar.SystemButtons := False;

  AFormulario.CustomTitleBar.SystemHeight := AAlto <= 0;
  if AAlto > 0 then
    AFormulario.CustomTitleBar.Height := AAlto;

  AFormulario.CustomTitleBar.BackgroundColor := clAnovoMarca;
  AFormulario.CustomTitleBar.ForegroundColor := clWhite;
  AFormulario.CustomTitleBar.InactiveBackgroundColor := clAnovoAcentoClaro;
  AFormulario.CustomTitleBar.InactiveForegroundColor := clAnovoLateralTexto;
  AFormulario.CustomTitleBar.ButtonBackgroundColor := clAnovoMarca;
  AFormulario.CustomTitleBar.ButtonForegroundColor := clWhite;
  AFormulario.CustomTitleBar.ButtonInactiveBackgroundColor :=
    clAnovoAcentoClaro;
  AFormulario.CustomTitleBar.ButtonInactiveForegroundColor :=
    clAnovoLateralTexto;
  AFormulario.CustomTitleBar.ButtonHoverBackgroundColor := clAnovoAcento;
  AFormulario.CustomTitleBar.ButtonHoverForegroundColor := clWhite;
  AFormulario.CustomTitleBar.ButtonPressedBackgroundColor :=
    clEstRechazadaFondo;
  AFormulario.CustomTitleBar.ButtonPressedForegroundColor := clWhite;
end;

procedure AplicarSuperficie(APanel: TPanel; AColor: TColor);
begin

  APanel.BevelOuter := bvNone;
  APanel.ParentBackground := False;
  APanel.ParentColor := False;
  APanel.StyleElements := [seFont, seBorder];
  APanel.Color := AColor;
end;

procedure AplicarTarjeta(APanel: TPanel);
begin
  AplicarSuperficie(APanel, clAnovoTarjeta);
  APanel.BorderStyle := bsSingle;
end;

procedure AplicarTexto(ALabel: TLabel; ARol: TAnovoRolTexto);
begin
  ALabel.ParentFont := False;
  ALabel.Transparent := True;
  ALabel.StyleElements := [seBorder];
  ALabel.Font.Name := FUENTE;
  case ARol of
    rtTituloGrande:
      begin
        ALabel.Font.Name := FUENTE_SEMI;
        ALabel.Font.Height := -46;
        ALabel.Font.Color := clAnovoTarjeta;
      end;
    rtTitulo:
      begin
        ALabel.Font.Name := FUENTE_SEMI;
        ALabel.Font.Height := -20;
        ALabel.Font.Color := clAnovoTexto;
      end;
    rtSeccion:
      begin
        ALabel.Font.Name := FUENTE_SEMI;
        ALabel.Font.Height := -15;
        ALabel.Font.Color := clAnovoTexto;
      end;
    rtCuerpo:
      begin
        ALabel.Font.Height := -12;
        ALabel.Font.Color := clAnovoTexto;
      end;
    rtApoyo:
      begin
        ALabel.Font.Height := -11;
        ALabel.Font.Color := clAnovoTextoSuave;
      end;
    rtCifra:
      begin
        ALabel.Font.Name := FUENTE_SEMI;
        ALabel.Font.Height := -24;
        ALabel.Font.Color := clAnovoTexto;
      end;
    rtCabecera:
      begin

        ALabel.Font.Name := FUENTE_SEMI;
        ALabel.Font.Height := -13;
        ALabel.Font.Color := clWhite;
      end;
    rtCifraKPI:
      begin
        ALabel.Font.Name := FUENTE_SEMI;
        ALabel.Font.Height := -28;
        ALabel.Font.Color := clWhite;
      end;
    rtNotaKPI:
      begin
        ALabel.Font.Height := -11;
        ALabel.Font.Color := clWhite;
      end;
    rtEnlace:
      begin
        ALabel.Font.Height := -12;
        ALabel.Font.Color := clAnovoAcento;
        ALabel.Cursor := crHandPoint;
      end;
    rtError:
      begin
        ALabel.Font.Height := -11;
        ALabel.Font.Color := clEstRechazadaBarra;
      end;
    rtLateral:
      begin
        ALabel.Font.Height := -11;
        ALabel.Font.Color := clAnovoLateralTexto;
      end;
    rtLateralFuerte:
      begin
        ALabel.Font.Name := FUENTE_SEMI;
        ALabel.Font.Height := -12;
        ALabel.Font.Color := clWhite;
      end;
    rtValor:
      begin
        ALabel.Font.Name := FUENTE_SEMI;
        ALabel.Font.Height := -12;
        ALabel.Font.Color := clAnovoTexto;
      end;
  end;
end;

procedure AplicarKPI(APanel: TPanel; AColor: TColor);
begin

  AplicarSuperficie(APanel, AColor);
end;

procedure AplicarCampo(AEdit: TCustomEdit);
begin
  AEdit.StyleElements := [seBorder];
  TEdit(AEdit).Color := clAnovoTarjeta;
  TEdit(AEdit).Font.Name := FUENTE;
  TEdit(AEdit).Font.Height := -12;
  TEdit(AEdit).Font.Color := clAnovoTexto;
end;

function EsKPI(ATag: NativeInt): Boolean;
begin
  Result := (ATag = TAG_KPI_ACENTO) or (ATag = TAG_KPI_AMBAR) or
    (ATag = TAG_KPI_VERDE) or (ATag = TAG_KPI_MARCA);
end;

function EsBoton(ATag: NativeInt): Boolean;
begin
  Result := (ATag = TAG_BTN_PRIMARIO) or (ATag = TAG_BTN_APROBAR) or
    (ATag = TAG_BTN_RECHAZAR) or (ATag = TAG_BTN_AVISO);
end;

function ColorKPI(ATag: NativeInt): TColor;
begin
  case ATag of
    TAG_KPI_AMBAR:
      Result := clEstPendienteFondo;
    TAG_KPI_VERDE:
      Result := clEstAprobadaFondo;
    TAG_KPI_MARCA:
      Result := clAnovoMarca;
  else
    Result := clAnovoAcento;
  end;
end;

function ColorBoton(ATag: NativeInt): TColor;
begin
  case ATag of
    TAG_BTN_APROBAR:
      Result := clEstAprobadaFondo;
    TAG_BTN_RECHAZAR:
      Result := clEstRechazadaFondo;
    TAG_BTN_AVISO:
      Result := clEstPendienteFondo;
    TAG_BTN_SECUNDARIO:
     Result := clAnovoMarca;
    else
      Result := clAnovoMarca;
  end;
end;

procedure AplicarTemaPanel(APanel: TPanel);
begin

  if EsKPI(APanel.Tag) then
    AplicarKPI(APanel, ColorKPI(APanel.Tag))
  else if EsBoton(APanel.Tag) then
    AplicarSuperficie(APanel, ColorBoton(APanel.Tag))
  else
    case APanel.Tag of
      TAG_FONDO:
        AplicarSuperficie(APanel, clAnovoFondo);
      TAG_CARD:
        AplicarTarjeta(APanel);
      TAG_CABECERA:
        AplicarSuperficie(APanel, clAnovoCabecera);
      TAG_BARRA:
        AplicarSuperficie(APanel, clAnovoMarca);
      TAG_SEP:
        AplicarSuperficie(APanel, clAnovoBorde);
    else

      AplicarSuperficie(APanel, clAnovoTarjeta);
    end;
end;

procedure AplicarTemaBoton(ABoton: TSpeedButton);
begin

end;

procedure AplicarTemaEtiqueta(ALabel: TLabel);
var
  lPadre: TWinControl;
begin
  lPadre := ALabel.Parent;

  case ALabel.Tag of
    TAG_TITULO_GRANDE:
      AplicarTexto(ALabel, rtTituloGrande);
    TAG_TITULO:
      AplicarTexto(ALabel, rtTitulo);
    TAG_SECCION:
      AplicarTexto(ALabel, rtSeccion);
    TAG_APOYO:
      AplicarTexto(ALabel, rtApoyo);
    TAG_ERROR:
      AplicarTexto(ALabel, rtError);
    TAG_LINK:
      AplicarTexto(ALabel, rtEnlace);
    TAG_TEXTO_LATERAL:
      AplicarTexto(ALabel, rtLateral);
    TAG_TEXTO_LATERAL_FUERTE:
      AplicarTexto(ALabel, rtLateralFuerte);
    TAG_VALOR:
      AplicarTexto(ALabel, rtValor);
    TAG_CIFRA:

      if (lPadre <> nil) and EsKPI(lPadre.Tag) then
        AplicarTexto(ALabel, rtCifraKPI)
      else
        AplicarTexto(ALabel, rtCifra);
  else
    if (lPadre <> nil) and EsKPI(lPadre.Tag) then
      AplicarTexto(ALabel, rtNotaKPI)
    else if (lPadre <> nil) and (lPadre.Tag = TAG_CABECERA) then
      AplicarTexto(ALabel, rtCabecera)
    else
      AplicarTexto(ALabel, rtCuerpo);
  end;

  if (lPadre <> nil) and (lPadre.Tag = TAG_BTN_AVISO) then
    ALabel.Font.Color := clAnovoTexto;
end;

procedure AplicarTemaGroupBox(AGroupBox: TGroupBox);
begin
  AGroupBox.ParentBackground := False;
  AGroupBox.StyleElements := [seFont, seBorder];
  AGroupBox.Color := clAnovoTarjeta;
end;

procedure AplicarTemaListView(AListView: TListView);
begin
  AListView.Color := clAnovoTarjeta;
  AListView.BorderStyle := bsNone;
  AListView.StyleElements := [seFont, seBorder];

end;

procedure AplicarEstiloPropio(AControl: TControl); forward;

procedure AplicarTemaCajaDesplazable(ACaja: TScrollBox);
begin
  ACaja.ParentColor := False;
  ACaja.StyleElements := [seFont, seBorder];
  if ACaja.Tag = TAG_FONDO then
    ACaja.Color := clAnovoFondo
  else
    ACaja.Color := clAnovoTarjeta;
end;

procedure AplicarTemaControl(AControl: TControl);
begin

  if AControl.Tag <> TAG_RAW then
    AplicarEstiloPropio(AControl);

  if AControl is TWinControl then
    AplicarTemaEnCascada(TWinControl(AControl));
end;

procedure AplicarEstiloPropio(AControl: TControl);
begin
  if AControl is TPanel then
    AplicarTemaPanel(TPanel(AControl))
  else if AControl is TSpeedButton then
    AplicarTemaBoton(TSpeedButton(AControl))
  else if AControl is TLabel then
    AplicarTemaEtiqueta(TLabel(AControl))
  else if AControl is TGroupBox then
    AplicarTemaGroupBox(TGroupBox(AControl))
  else if AControl is TCustomListView then
    AplicarTemaListView(TListView(AControl))
  else if AControl is TPlanoTarjeta then
    AplicarTemaTarjeta(TPlanoTarjeta(AControl))
  else if AControl is TScrollBox then
    AplicarTemaCajaDesplazable(TScrollBox(AControl))
  else if AControl is TCustomEdit then
    AplicarCampo(TCustomEdit(AControl))
  else
    AplicarTemaControlEstandar(AControl);

  AplicarTemaRotuloRosi(AControl);
end;

procedure AplicarTemaTarjeta(ATarjeta: TPlanoTarjeta);
begin

  ATarjeta.ParentFont := False;
  if EsKPI(ATarjeta.Tag) then
  begin
    ATarjeta.CardColor := ColorKPI(ATarjeta.Tag);
    ATarjeta.Font.Name := FUENTE;
    ATarjeta.Font.Height := -12;
    ATarjeta.Font.Style := [];
    ATarjeta.Font.Color := clWhite;
  end
  else
  begin

    ATarjeta.Font.Name := FUENTE_SEMI;
    ATarjeta.Font.Height := -15;
    ATarjeta.Font.Style := [];
    ATarjeta.Font.Color := clAnovoTexto;
  end;
end;

function EsDibujadoPropio(AControl: TControl): Boolean;
var
  lUnidad: string;
begin
  lUnidad := AControl.UnitName;
  Result := lUnidad.StartsWith('VclPlano') or lUnidad.StartsWith('FlatVcl');
end;

procedure AplicarLetra(AControl: TControl);
var
  lFuente: TFont;
begin

  if not IsPublishedProp(AControl, 'Font') then
    Exit;
  lFuente := GetObjectProp(AControl, 'Font') as TFont;
  if lFuente = nil then
    Exit;
  lFuente.Name := FUENTE;
  lFuente.Height := -12;
  lFuente.Color := clAnovoTexto;
end;

procedure AplicarTemaControlEstandar(AControl: TControl);
begin
  if EsDibujadoPropio(AControl) then
    Exit;

  if not ((AControl is TCustomComboBox) or (AControl is TCustomCheckBox) or
    (AControl is TDateTimePicker) or (AControl is TCustomListControl) or
    IsPublishedProp(AControl, 'DataField')) then
    Exit;
  AControl.StyleElements := [seBorder];
  AplicarLetra(AControl);
end;

procedure AplicarTemaRotuloRosi(AControl: TControl);
var
  lRotulo: TObject;
  lFuente: TFont;
begin
  if not IsPublishedProp(AControl, 'DBEditLabel') then
    Exit;
  lRotulo := GetObjectProp(AControl, 'DBEditLabel');
  if not (lRotulo is TControl) or not IsPublishedProp(lRotulo, 'Font') then
    Exit;
  lFuente := GetObjectProp(lRotulo, 'Font') as TFont;
  if lFuente = nil then
    Exit;

  lFuente.Name := FUENTE;
  lFuente.Height := -12;
  lFuente.Color := clAnovoTexto;
  TControl(lRotulo).StyleElements := [seBorder];
end;

procedure AplicarTemaEnCascada(AContenedor: TWinControl);
var
  i: Integer;
begin
  for i := 0 to AContenedor.ControlCount - 1 do
    AplicarTemaControl(AContenedor.Controls[i]);
end;

procedure AplicarTema(AFormulario: TCustomForm);
begin
  AFormulario.Color := clAnovoFondo;

  AplicarLetra(AFormulario);

  AplicarTemaEnCascada(AFormulario);
end;

procedure AplicarTemaFrame(AFrame: TFrame);
begin
  AFrame.ParentFont := False;
  AplicarLetra(AFrame);

  AplicarTemaEnCascada(AFrame);
end;

end.
