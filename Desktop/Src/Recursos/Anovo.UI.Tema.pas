unit Anovo.UI.Tema;

interface

uses System.SysUtils, System.Classes, System.Types, System.ImageList,
  Vcl.Graphics, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.ComCtrls, Vcl.ImgList;

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

  { Aplicación de estilo a controles }
procedure AplicarSuperficie(APanel: TPanel; AColor: TColor);

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

end.
