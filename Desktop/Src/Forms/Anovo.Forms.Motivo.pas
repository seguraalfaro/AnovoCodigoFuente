unit Anovo.Forms.Motivo;

// Dialogo que pide el motivo obligatorio para devolver o
// rechazar una cotizacion.

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.TitleBarCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion;

type
  TfrmMotivo = class(TfrmEdicion)
    pnlCampos: TPanel;
    lblMotivo: TLabel;
    mmMotivo: TMemo;
    procedure btnGuardarClick(Sender: TObject);
  public
    class function Pedir(AOwner: TComponent; const ATitulo, AAyuda,
      ABoton: string; out AMotivo: string): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Textos;

class function TfrmMotivo.Pedir(AOwner: TComponent; const ATitulo, AAyuda,
  ABoton: string; out AMotivo: string): Boolean;
var
  lForma: TfrmMotivo;
begin
  lForma := TfrmMotivo.Create(AOwner);
  try
    lForma.lblTitulo.Caption := ATitulo;
    lForma.lblSubtitulo.Caption := AAyuda;
    lForma.btnGuardar.Caption := ABoton;
    Result := lForma.ShowModal = mrOk;
    AMotivo := Trim(lForma.mmMotivo.Text);
  finally
    lForma.Free;
  end;
end;

procedure TfrmMotivo.btnGuardarClick(Sender: TObject);
begin
  if Trim(mmMotivo.Text) = '' then
  begin
    MostrarError(SMotivoFalta);
    mmMotivo.SetFocus;
    Exit;
  end;
  ModalResult := mrOk;
end;

end.
