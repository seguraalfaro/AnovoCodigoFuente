unit Anovo.Forms.Revocacion;

// Dialogo que pide quien solicita revocar el consentimiento del cliente.

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.TitleBarCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion;

type
  TfrmRevocacion = class(TfrmEdicion)
    pnlCampos: TPanel;
    lblNombre: TLabel;
    edNombre: TEdit;
    lblIdentificacion: TLabel;
    edIdentificacion: TEdit;
    procedure btnGuardarClick(Sender: TObject);
  public
    class function Pedir(AOwner: TComponent; const ACliente: string;
      var ANombre, AIdentificacion: string): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Textos;

class function TfrmRevocacion.Pedir(AOwner: TComponent;
  const ACliente: string; var ANombre, AIdentificacion: string): Boolean;
var
  lForma: TfrmRevocacion;
begin
  lForma := TfrmRevocacion.Create(AOwner);
  try
    lForma.lblTitulo.Caption := SRevocarTitulo;
    lForma.lblSubtitulo.Caption := Format(SRevocarAyuda, [ACliente]);
    lForma.btnGuardar.Caption := SRevocarTitulo;
    lForma.lblNombre.Caption := SRevocanteNombre;
    lForma.lblIdentificacion.Caption := SRevocanteIdentificacion;
    lForma.edNombre.Text := ANombre;
    lForma.edIdentificacion.Text := AIdentificacion;
    Result := lForma.ShowModal = mrOk;
    ANombre := Trim(lForma.edNombre.Text);
    AIdentificacion := Trim(lForma.edIdentificacion.Text);
  finally
    lForma.Free;
  end;
end;

procedure TfrmRevocacion.btnGuardarClick(Sender: TObject);
begin
  if Trim(edNombre.Text) = '' then
  begin
    MostrarError(SRevocanteNombreFalta);
    edNombre.SetFocus;
    Exit;
  end;
  if Trim(edIdentificacion.Text) = '' then
  begin
    MostrarError(SRevocanteIdentificacionFalta);
    edIdentificacion.SetFocus;
    Exit;
  end;
  ModalResult := mrOk;
end;

end.
