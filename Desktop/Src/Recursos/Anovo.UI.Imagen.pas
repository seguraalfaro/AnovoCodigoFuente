unit Anovo.UI.Imagen;

// Ventana para ver ampliada una foto o el croquis de la solicitud.

interface

uses
  System.Classes,
  Vcl.Graphics;

procedure MostrarAmpliada(AOwner: TComponent; const AGrafico: TGraphic;
  const ATitulo: string);

implementation

uses
  Vcl.Forms,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Anovo.UI.Tema;

const
  ANCHO_VENTANA = 1000;
  ALTO_VENTANA = 720;
  MARGEN = 12;

procedure MostrarAmpliada(AOwner: TComponent; const AGrafico: TGraphic;
  const ATitulo: string);
var
  lForma: TForm;
  lImagen: TImage;
begin
  lForma := TForm.Create(AOwner);
  try
    lForma.Caption := ATitulo;
    lForma.Position := poScreenCenter;
    lForma.BorderIcons := [biSystemMenu, biMaximize];
    lForma.ClientWidth := ANCHO_VENTANA;
    lForma.ClientHeight := ALTO_VENTANA;
    lForma.Color := clAnovoFondo;
    lImagen := TImage.Create(lForma);
    lImagen.Parent := lForma;
    lImagen.AlignWithMargins := True;
    lImagen.Margins.SetBounds(MARGEN, MARGEN, MARGEN, MARGEN);
    lImagen.Align := alClient;
    lImagen.Center := True;
    lImagen.Proportional := True;
    lImagen.Stretch := True;
    lImagen.Picture.Assign(AGrafico);
    lForma.ShowModal;
  finally
    lForma.Free;
  end;
end;

end.
