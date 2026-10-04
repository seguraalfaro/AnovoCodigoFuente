unit Anovo.Forms.ClaveTemporal;

// Ventana que muestra una sola vez la clave temporal de una cuenta,
// al registrarla o al restablecer su clave.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion;

type
  TfrmClaveTemporal = class(TfrmEdicion)
    pnlCampos: TPanel;
    edClave: TEdit;
    lblAviso: TLabel;
    procedure btnGuardarClick(Sender: TObject);
  public
    class procedure Mostrar(AOwner: TComponent; const ANombre, AClave: string);
  end;

implementation

{$R *.dfm}

uses
  Vcl.Clipbrd,
  Anovo.Textos;

class procedure TfrmClaveTemporal.Mostrar(AOwner: TComponent;
  const ANombre, AClave: string);
var
  lForma: TfrmClaveTemporal;
begin
  lForma := TfrmClaveTemporal.Create(AOwner);
  try
    lForma.lblSubtitulo.Caption := Format(SClaveTemporalDe, [ANombre]);
    lForma.edClave.Text := AClave;
    lForma.lblAviso.Caption := SClaveTemporalAviso;
    lForma.btnGuardar.Caption := SCopiar;
    lForma.btnCancelar.Caption := SListo;
    lForma.ShowModal;
  finally
    lForma.Free;
  end;
end;

procedure TfrmClaveTemporal.btnGuardarClick(Sender: TObject);
begin
  Clipboard.AsText := edClave.Text;
  lblAviso.Caption := SClaveTemporalCopiada;
end;

end.
