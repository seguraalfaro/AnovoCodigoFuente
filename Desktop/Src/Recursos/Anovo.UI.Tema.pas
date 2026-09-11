unit Anovo.UI.Tema;

interface

uses System.SysUtils, System.Classes, System.Types, System.ImageList,
  Vcl.Graphics, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.ComCtrls, Vcl.ImgList, Vcl.Buttons;

const
 { Paleta base, con los nombres de la figura 25. Estan para poder citar la
    figura desde el codigo; el resto del tema usa los roles de abajo. }
  clAzulInstitucional  = TColor($005C3A1A);   // #1A3A5C  AZUL_INSTITUCIONAL
  clAzulSecundario     = TColor($00A06029);   // #2960A0  AZUL_SECUNDARIO
  clAzulClaro          = TColor($00E8DCD0);   // #D0DCE8  AZUL_CLARO
  clVerdeExito         = TColor($005EC522);   // #22C55E  VERDE_EXITO
  clAmbar              = TColor($000B9EF5);   // #F59E0B  AMBAR
  clRojoError          = TColor($004444EF);   // #EF4444  ROJO_ERROR

  { Paleta. Las constantes van en TColor (BGR), el comentario en el hex de
    diseno y el nombre que tiene el color en el movil. }
  clAnovoMarca         = TColor($005C3A1A);   // #1A3A5C  COLOR_PRIMARIO
  clAnovoCabecera      = TColor($005C3A1A);   // #1A3A5C  COLOR_PRIMARIO
  clAnovoAcento        = TColor($00A06029);   // #2960A0  COLOR_MEDIO
  clAnovoAcentoClaro   = TColor($008A5C2E);   // #2E5C8A  COLOR_PRIMARIO_CLARO
  clAnovoAcentoSuave   = TColor($00F5E4D6);   // #D6E4F5  COLOR_PRIMARIO_TENUE
  clAnovoAcentoHover   = TColor($00ECD0B8);   // #B8D0EC  COLOR_PRIMARIO_SUAVE
  clAnovoSuave         = TColor($00E8DCD0);   // #D0DCE8  COLOR_FONDO_SUAVE
  clAnovoLateralTexto  = TColor($00E8DCD0);   // #D0DCE8  COLOR_FONDO_SUAVE
  clAnovoLateralTenue  = TColor($00C1B8B0);   // #B0B8C1  COLOR_DESHABILITADO

  clAnovoFondo         = TColor($00FAF7F5);   // #F5F7FA  COLOR_FONDO_PANTALLA
  clAnovoFilaAlterna   = TColor($00FAF7F5);   // #F5F7FA  COLOR_FONDO_PANTALLA
  clAnovoTarjeta       = TColor($00FFFFFF);   // #FFFFFF  COLOR_SUPERFICIE
  clAnovoBorde         = TColor($00E4DED9);   // #D9DEE4  COLOR_BORDE
  clAnovoSeleccion     = TColor($00F5E4D6);   // #D6E4F5  COLOR_PRIMARIO_TENUE

  clAnovoTexto         = TColor($001E1C1C);   // #1C1C1E  COLOR_TEXTO_PRIMARIO
  clAnovoTextoSuave    = TColor($0080726B);   // #6B7280  COLOR_TEXTO_SECUNDARIO
  clAnovoTextoTenue    = TColor($0080726B);   // #6B7280  COLOR_TEXTO_SECUNDARIO
  clAnovoDeshabilitado = TColor($00C1B8B0);   // #B0B8C1  COLOR_DESHABILITADO
  clAnovoTextoSobre    = TColor($00FFFFFF);   // #FFFFFF  COLOR_TEXTO_SOBRE_PRIMARIO

  { Rojos y ambares del tema anterior del movil. Conviven con ROJO_ERROR y
    AMBAR de la figura 25, que son los que usa el resto del tema. }
  clAnovoError         = TColor($001E26B3);   // #B3261E  COLOR_ERROR
  clAnovoErrorClaro    = TColor($00424AD1);   // #D14A42  COLOR_ERROR_CLARO
  clAnovoAdvertencia   = TColor($001775BA);   // #BA7517  COLOR_ADVERTENCIA
  clAnovoAdvTenue      = TColor($00DAEEFA);   // #FAEEDA  COLOR_ADVERTENCIA_TENUE

  { Estados. Borrador y pendiente comparten el ambar, igual que en
    Colores.ColorDeEstado del movil: los separa el texto de la pastilla.
    Sobre ambar el texto va oscuro; blanco sobre #F59E0B no da contraste. }
  clEstBorradorBarra   = TColor($000B9EF5);   // #F59E0B  COLOR_BORRADOR_PENDIENTE
  clEstBorradorFondo   = TColor($000B9EF5);
  clEstBorradorTexto   = clAnovoTexto;

  clEstPendienteBarra  = TColor($000B9EF5);   // #F59E0B  COLOR_BORRADOR_PENDIENTE
  clEstPendienteFondo  = TColor($000B9EF5);
  clEstPendienteTexto  = clAnovoTexto;

  clEstAprobadaBarra   = TColor($005EC522);   // #22C55E  COLOR_APROBADA
  clEstAprobadaFondo   = TColor($005EC522);
  clEstAprobadaTexto   = clAnovoTextoSobre;

  clEstRechazadaBarra  = TColor($004444EF);   // #EF4444  COLOR_RECHAZADA_ERROR
  clEstRechazadaFondo  = TColor($004444EF);
  clEstRechazadaTexto  = clAnovoTextoSobre;

  clEstEnviadaBarra    = TColor($00A06029);   // #2960A0  COLOR_MEDIO
  clEstEnviadaFondo    = TColor($00A06029);
  clEstEnviadaTexto    = clAnovoTextoSobre;

  { En revision no esta en el vocabulario acordado (borrador, pendiente,
    aprobada, rechazada, enviada). Mismo ambar, marcado como provisional con
    borde rojo en la interfaz, hasta que Anovo lo confirme. }
  clEstRevisionBarra   = TColor($000B9EF5);   // #F59E0B  COLOR_EN_REVISION_PROVISIONAL
  clEstRevisionFondo   = TColor($000B9EF5);
  clEstRevisionBorde   = TColor($004444EF);   // #EF4444  ROJO_ERROR

  { Rejilla }
  MARGEN        = 16;
  SEPARACION    = 8;
  ALTO_FILA     = 56;
  ALTO_CABECERA = 28;
  RADIO         = 8;
  RADIO_KPI     = 4;

  FUENTE      = 'Segoe UI';
  FUENTE_SEMI = 'Segoe UI Semibold';

  { Tabla de roles. En el .dfm se ve el numero, no el nombre; para eso esta
    NombreDeEtiqueta, que lo traduce en los volcados de ListarEtiquetas. }
  TAG_NINGUNO      = 0;
  TAG_RAW          = 1;    // no tocar este control ni sus hijos

  { Superficies }
  TAG_FONDO        = 2;
  TAG_CARD         = 3;
  TAG_CABECERA     = 4;    // franja azul con titulo
  TAG_BARRA        = 5;
  TAG_SEP          = 6;

  { Tarjetas de cifras. Las etiquetas de dentro no necesitan Tag: la cifra se
    marca con TAG_CIFRA y el resto sale como nota. }
  TAG_KPI_ACENTO   = 7;
  TAG_KPI_AMBAR    = 8;
  TAG_KPI_VERDE    = 9;
  TAG_KPI_MARCA    = 10;

  { Texto }
  TAG_TITULO       = 11;
  TAG_SECCION      = 12;
  TAG_APOYO        = 13;
  TAG_ERROR        = 14;
  TAG_LINK         = 15;
  TAG_CIFRA        = 16;

  { Botones de panel mas etiqueta. El Tag va en el panel; el rotulo sale de su
    primer TLabel hijo, que no lleva Tag propio. }
  TAG_BTN_PRIMARIO = 17;
  TAG_BTN_APROBAR  = 18;
  TAG_BTN_RECHAZAR = 19;
  TAG_BTN_AVISO    = 20;

  { Aplicación de estilo a controles }
procedure AplicarTema(AFormulario: TCustomForm);
procedure AplicarTemaEnCascada(AContenedor: TWinControl);
procedure AplicarTemaControl(AControl: TControl);

procedure AplicarSuperficie(APanel: TPanel; AColor: TColor);
procedure AplicarTemaButton(ASpeedButton: TSpeedButton);

implementation

procedure AplicarSuperficie(APanel: TPanel; AColor: TColor);
begin
  { Sin seClient el estilo VCL deja de pintar el fondo y respeta Color. }
  APanel.BevelOuter := bvNone;
  APanel.ParentBackground := False;
  APanel.ParentColor := False;
  APanel.StyleElements := [seFont, seBorder];
  APanel.Color := AColor;
end;

procedure AplicarTema(AFormulario: TCustomForm);
begin
  TForm(AFormulario).Color := clAnovoFondo;
  AplicarTemaEnCascada(AFormulario);
end;

procedure AplicarTemaEnCascada(AContenedor: TWinControl);
var
  i: Integer;
begin
  for i := 0 to AContenedor.ControlCount - 1 do
    AplicarTemaControl(AContenedor.Controls[i]);
end;

procedure AplicarTemaControl(AControl: TControl);
begin
  if AControl.Tag = TAG_RAW then
    Exit;

  if AControl is TSpeedButton then
    AplicarTemaButton(TSpeedButton(AControl));

  { if AControl is TPanel then
    ' AplicarTemaPanel(TPanel(AControl))
    else if AControl is TLabel then
    'AplicarTemaLabel(TLabel(AControl))
    else if AControl is TGroupBox then
    begin
    TGroupBox(AControl).ParentBackground := False;
    TGroupBox(AControl).StyleElements := [seFont, seBorder];
    TGroupBox(AControl).Color := clAnovoTarjeta;
    end
    else if AControl is TCustomListView then
    begin
    TListView(AControl).Color := clAnovoTarjeta;
    TListView(AControl).BorderStyle := bsNone;
    TListView(AControl).StyleElements := [seFont, seBorder];
    end
    else if AControl is TCustomEdit then
    begin
    ' AplicarCampo(TCustomEdit(AControl));
    else if Acontrol is TSpeedButton then }

  if AControl is TWinControl then
    AplicarTemaEnCascada(TWinControl(AControl));

end;

procedure AplicarTemaButton(ASpeedButton: TSpeedButton);
begin

end;

end.
