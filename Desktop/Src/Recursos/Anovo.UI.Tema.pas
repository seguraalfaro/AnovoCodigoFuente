unit Anovo.UI.Tema;

{ Tema visual del cliente de escritorio.

  Un único lugar donde viven la paleta, las fuentes y los dibujos compartidos
  (pastilla de estado, tarjeta, barra de color). Si un color aparece escrito a
  mano en un formulario, ya empezó a divergir.

  PALETA COMPARTIDA
  Los valores son los mismos del módulo Colores de la aplicación móvil, que a
  su vez salen del anteproyecto aprobado (Estilo Visual > Paleta de colores,
  figura 25). El nombre de la constante móvil va en el comentario de cada
  línea: al cambiar un color hay que cambiarlo en las dos plataformas, o el
  informe deja de ser cierto cuando afirma que comparten lenguaje visual.

  Roles, tal como los fija el anteproyecto: el azul primario va en barras de
  navegación, encabezados de tabla y botón de acción principal; el azul medio
  en iconos activos, bordes con foco, enlaces y selección.

  Todo se resuelve con VCL nativa: los controles llevan Color propio y
  StyleElements sin seClient, y lo que no da el control se pinta en el Canvas. }

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Types,
  System.ImageList, Vcl.TitleBarCtrls,
  Vcl.Graphics, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.ComCtrls, Vcl.ImgList, Vcl.Buttons;

const
  { Paleta. Las constantes van en TColor (BGR), el comentario en el hex de
    diseño y el nombre que tiene en el módulo Colores del móvil. }
  clAnovoMarca = TColor($005C3A1A); // #1A3A5C  COLOR_PRIMARIO
  clAnovoCabecera = TColor($005C3A1A); // #1A3A5C  COLOR_PRIMARIO
  clAnovoAcento = TColor($00A06029); // #2960A0  COLOR_MEDIO
  clAnovoAcentoClaro = TColor($008A5C2E); // #2E5C8A  COLOR_PRIMARIO_CLARO
  clAnovoAcentoSuave = TColor($00F5E4D6); // #D6E4F5  COLOR_PRIMARIO_TENUE
  clAnovoAcentoHover = TColor($00ECD0B8); // #B8D0EC  COLOR_PRIMARIO_SUAVE

  clAnovoLateralTexto = TColor($00E8DCD0); // #D0DCE8  COLOR_FONDO_SUAVE
  clAnovoLateralTenue = TColor($00C1B8B0); // #B0B8C1  COLOR_DESHABILITADO

  clAnovoFondo = TColor($00FAF7F5); // #F5F7FA  COLOR_FONDO_PANTALLA
  clAnovoTarjeta = TColor($00FFFFFF); // #FFFFFF  COLOR_SUPERFICIE
  clAnovoBorde = TColor($00E4DED9); // #D9DEE4  COLOR_BORDE
  clAnovoSuave = TColor($00E8DCD0); // #D0DCE8  COLOR_FONDO_SUAVE
  clAnovoSeleccion = TColor($00F5E4D6); // #D6E4F5  COLOR_PRIMARIO_TENUE
  clAnovoFilaAlterna = TColor($00FAF7F5); // #F5F7FA  COLOR_FONDO_PANTALLA
  clAnovoDeshabilitado = TColor($00C1B8B0); // #B0B8C1  COLOR_DESHABILITADO

  clAnovoTexto = TColor($001E1C1C); // #1C1C1E  COLOR_TEXTO_PRIMARIO
  clAnovoTextoSuave = TColor($0080726B); // #6B7280  COLOR_TEXTO_SECUNDARIO
  clAnovoTextoTenue = TColor($0080726B); // #6B7280  COLOR_TEXTO_SECUNDARIO

  { Estados. El móvil pinta borrador y pendiente con el mismo ámbar
    (Colores.ColorDeEstado), así que aquí también: la distinción la hace el
    texto de la pastilla, no el color. Está pendiente de confirmar con Anovo.
    Sobre ámbar el texto va oscuro; sobre los otros tres, blanco. }
  clEstBorradorBarra = TColor($000B9EF5); // #F59E0B  COLOR_BORRADOR_PENDIENTE
  clEstBorradorFondo = TColor($000B9EF5);
  clEstBorradorTexto = TColor($001E1C1C); // #1C1C1E

  clEstPendienteBarra = TColor($000B9EF5); // #F59E0B  COLOR_BORRADOR_PENDIENTE
  clEstPendienteFondo = TColor($000B9EF5);
  clEstPendienteTexto = TColor($001E1C1C); // #1C1C1E

  clEstAprobadaBarra = TColor($005EC522); // #22C55E  COLOR_APROBADA
  clEstAprobadaFondo = TColor($005EC522);
  clEstAprobadaTexto = clWhite;

  clEstRechazadaBarra = TColor($004444EF); // #EF4444  COLOR_RECHAZADA_ERROR
  clEstRechazadaFondo = TColor($004444EF);
  clEstRechazadaTexto = clWhite;

  clEstEnviadaBarra = TColor($00A06029); // #2960A0  COLOR_MEDIO
  clEstEnviadaFondo = TColor($00A06029);
  clEstEnviadaTexto = clWhite;

  { Rejilla }
  MARGEN = 16;
  SEPARACION = 8;
  ALTO_FILA = 56;
  ALTO_CABECERA = 28;
  RADIO = 8;
  RADIO_KPI = 4;

  FUENTE = 'Segoe UI';
  FUENTE_SEMI = 'Segoe UI Semibold';

  { ETIQUETAS DE ROL

    El equivalente de los TAG_* del modulo UI del movil, con una diferencia:
    en la VCL Tag es NativeInt, no cadena. Un rol por control, del 1 al 20; no
    se combinan.

    Tag = 0 deja el trato neutro. TAG_RAW corta la rama entera: sirve para el
    arte del Login y para cualquier control que se pinte solo.

    El rol se lee en TPanel y TLabel; el TSpeedButton toma el de su panel. En
    el resto el Tag sigue libre para la aplicacion, salvo TAG_RAW, que se
    respeta en cualquier control. Ojo con los TSpeedButton del filtro de
    Cotizaciones, que usan el Tag como indice.

    En el .dfm se ve un numero y no un nombre; NombreDeEtiqueta lo traduce. }
  TAG_NINGUNO = 0;
  TAG_RAW = 1; // no tocar este control ni sus hijos

  { Superficies }
  TAG_FONDO = 2;
  TAG_CARD = 3;
  TAG_CABECERA = 4; // franja azul con titulo
  TAG_BARRA = 5;
  TAG_SEP = 6;

  { Tarjetas de cifras. Las etiquetas de dentro no necesitan Tag: la cifra se
    marca con TAG_CIFRA y el resto sale como nota. }
  TAG_KPI_ACENTO = 7;
  TAG_KPI_AMBAR = 8;
  TAG_KPI_VERDE = 9;
  TAG_KPI_MARCA = 10;

  { Texto }
  TAG_TITULO = 11;
  TAG_TITULO_GRANDE = 22;
  TAG_TEXTO_LATERAL = 23;
  TAG_SECCION = 12;
  TAG_APOYO = 13;
  TAG_ERROR = 14;
  TAG_LINK = 15;
  TAG_CIFRA = 16;

  { Botones de panel mas etiqueta. El Tag va en el panel; el rotulo sale de su
    primer TLabel hijo, que no lleva Tag propio. }
  TAG_BTN_PRIMARIO = 17;
  TAG_BTN_APROBAR = 18;
  TAG_BTN_RECHAZAR = 19;
  TAG_BTN_AVISO = 20;
  TAG_BTN_SECUNDARIO = 21;

type
  TAnovoRolTexto = (rtTituloGrande, rtTitulo, rtSeccion, rtCuerpo, rtApoyo,
    rtCifra, rtCabecera, rtCifraKPI, rtNotaKPI, rtEnlace, rtError, rtLateral);

  { interface }
procedure AplicarTemaBarraTitulo(AFormulario: TCustomForm;
  APanel: TCustomTitleBarPanel; AAlto: Integer = 0);

{ Aplicación de estilo a controles }
procedure AplicarTarjeta(APanel: TPanel);
procedure AplicarSuperficie(APanel: TPanel; AColor: TColor);

{ Etiquetas }
function EsKPI(ATag: NativeInt): Boolean;
function EsBoton(ATag: NativeInt): Boolean;

{ Recorrido }
procedure AplicarTema(AFormulario: TCustomForm);
procedure AplicarTemaControl(AControl: TControl);
procedure AplicarTemaEnCascada(AContenedor: TWinControl);

{ Cada tipo por separado. La cascada llama a estas, y se pueden llamar sueltas
  para un control creado en tiempo de ejecucion, que no pasa por el .dfm. }
procedure AplicarTemaPanel(APanel: TPanel);
procedure AplicarTemaBoton(ABoton: TSpeedButton);
procedure AplicarTemaEtiqueta(ALabel: TLabel);
procedure AplicarTemaGroupBox(AGroupBox: TGroupBox);
procedure AplicarTemaListView(AListView: TListView);

implementation

procedure AplicarTemaBarraTitulo(AFormulario: TCustomForm;
  APanel: TCustomTitleBarPanel; AAlto: Integer = 0);
begin

  if (APanel = nil) or not AFormulario.CustomTitleBar.Supported then
    Exit;

  AFormulario.CustomTitleBar.Control := APanel;
  AFormulario.CustomTitleBar.Enabled := True;
  AFormulario.CustomTitleBar.SystemColors := False;
  AFormulario.CustomTitleBar.SystemButtons := False;

  { AAlto en cero deja el alto del sistema, que es lo que quiere un dialogo. }
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
  { Sin seClient el estilo VCL deja de pintar el fondo y respeta Color. }
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
        { Título dentro de una franja azul: el color lo pone la franja. }
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
  end;
end;

procedure AplicarKPI(APanel: TPanel; AColor: TColor);
begin
  { Las cuatro tarjetas de cifras del panel de control: fondo saturado,
    texto blanco, sin borde. }
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
      { Sin etiqueta queda de superficie blanca }
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
    TAG_CIFRA:
      { Dentro de un KPI la cifra va blanca y grande; fuera, oscura. }
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

  { Sobre el ambar el blanco no se lee. }
  if (lPadre <> nil) and ((lPadre.Tag = TAG_KPI_AMBAR) or
    (lPadre.Tag = TAG_BTN_AVISO)) then
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

procedure AplicarTemaControl(AControl: TControl);
begin
  if AControl.Tag = TAG_RAW then
    Exit;

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
  else if AControl is TCustomEdit then
    AplicarCampo(TCustomEdit(AControl));

  if AControl is TWinControl then
    AplicarTemaEnCascada(TWinControl(AControl));
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

  AplicarTemaEnCascada(AFormulario);
end;

end.
