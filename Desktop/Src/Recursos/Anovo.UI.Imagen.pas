unit Anovo.UI.Imagen;

// Ventana para ver ampliada una foto o el croquis de la solicitud, con zoom
// por la rueda del mouse, arrastre y la opcion de abrirla en el visor de Windows.

interface

uses
  System.Classes,
  Vcl.Graphics;

procedure MostrarAmpliada(AOwner: TComponent; const AGrafico: TGraphic;
  const ATitulo: string);

procedure AbrirEnVisorExterno(const AGrafico: TGraphic);

implementation

uses
  Winapi.Windows,
  Winapi.ShellAPI,
  System.SysUtils,
  System.IOUtils,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,
  rImageZoom,
  VclPlano.BotonWin,
  VclPlano.Paleta,
  Anovo.UI.Tema,
  Anovo.Textos;

const
  ANCHO_VENTANA = 1000;
  ALTO_VENTANA = 720;
  ALTO_PIE = 56;
  MARGEN = 12;
  ANCHO_BOTON = 220;
  ALTO_BOTON = 32;
  PREFIJO_ARCHIVO = 'Anovo_';
  EXTENSION_PNG = '.png';
  ACCION_ABRIR = 'open';

type
  TAccionVisor = class(TComponent)
  private
    FGrafico: TGraphic;
  public
    procedure Abrir(Sender: TObject);
  end;

procedure TAccionVisor.Abrir(Sender: TObject);
begin
  AbrirEnVisorExterno(FGrafico);
end;

procedure AbrirEnVisorExterno(const AGrafico: TGraphic);
var
  lMapa: Vcl.Graphics.TBitmap;
  lPng: TPngImage;
  lRuta: string;
begin
  if AGrafico = nil then
    Exit;
  lRuta := TPath.Combine(TPath.GetTempPath, PREFIJO_ARCHIVO +
    TGUID.NewGuid.ToString.Trim(['{', '}']) + EXTENSION_PNG);
  lMapa := Vcl.Graphics.TBitmap.Create;
  lPng := TPngImage.Create;
  try
    lMapa.Assign(AGrafico);
    lPng.Assign(lMapa);
    lPng.SaveToFile(lRuta);
  finally
    lPng.Free;
    lMapa.Free;
  end;
  ShellExecute(0, ACCION_ABRIR, PChar(lRuta), nil, nil, SW_SHOWNORMAL);
end;

procedure MostrarAmpliada(AOwner: TComponent; const AGrafico: TGraphic;
  const ATitulo: string);
var
  lForma: TForm;
  lImagen: TrImageZoom;
  lPie: TPanel;
  lBoton: TPlanoBotonWin;
  lAccion: TAccionVisor;
begin
  lForma := TForm.Create(AOwner);
  try
    lForma.Caption := ATitulo;
    lForma.Position := poScreenCenter;
    lForma.BorderIcons := [biSystemMenu, biMaximize];
    lForma.ClientWidth := ANCHO_VENTANA;
    lForma.ClientHeight := ALTO_VENTANA;
    lForma.Color := clAnovoFondo;

    lAccion := TAccionVisor.Create(lForma);
    lAccion.FGrafico := AGrafico;

    lPie := TPanel.Create(lForma);
    lPie.Parent := lForma;
    lPie.Tag := TAG_FONDO;
    lPie.Align := alBottom;
    lPie.Height := ALTO_PIE;
    lPie.BevelOuter := bvNone;

    lBoton := TPlanoBotonWin.Create(lForma);
    lBoton.Parent := lPie;
    lBoton.Kind := fkSecondary;
    lBoton.Caption := SAbrirEnVisor;
    lBoton.SetBounds(ANCHO_VENTANA - ANCHO_BOTON - MARGEN,
      (ALTO_PIE - ALTO_BOTON) div 2, ANCHO_BOTON, ALTO_BOTON);
    lBoton.Anchors := [akTop, akRight];
    lBoton.Cursor := crHandPoint;
    lBoton.OnClick := lAccion.Abrir;

    lImagen := TrImageZoom.Create(lForma);
    lImagen.Parent := lForma;
    lImagen.Tag := TAG_RAW;
    lImagen.SetBounds(MARGEN, MARGEN, ANCHO_VENTANA - 2 * MARGEN,
      ALTO_VENTANA - ALTO_PIE - MARGEN);
    lImagen.Anchors := [akLeft, akTop, akRight, akBottom];
    lImagen.ReadOnly := True;
    lImagen.ShowEditor := ieNone;
    lImagen.ScrollBar := True;
    lImagen.DragAndMove := True;
    lImagen.BackgroundColor := clAnovoFondo;
    lImagen.Picture.Assign(AGrafico);
    lImagen.Fit;

    AplicarTema(lForma);
    lForma.ShowModal;
  finally
    lForma.Free;
  end;
end;

end.
