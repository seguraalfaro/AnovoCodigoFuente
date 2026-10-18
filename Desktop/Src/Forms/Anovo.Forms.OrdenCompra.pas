unit Anovo.Forms.OrdenCompra;

// Dialogo que pide el numero de orden de compra del cliente al registrar
// que aprobo la cotizacion.

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.TitleBarCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo,
  VclPlano.BotonWin,
  Anovo.Forms.Edicion;

type
  TfrmOrdenCompra = class(TfrmEdicion)
    pnlCampos: TPanel;
    lblOrden: TLabel;
    edOrden: TEdit;
    lblNota: TLabel;
    procedure btnGuardarClick(Sender: TObject);
  public
    class function Pedir(AOwner: TComponent; const ATitulo: string;
      out AOrden: string): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Textos;

class function TfrmOrdenCompra.Pedir(AOwner: TComponent;
  const ATitulo: string; out AOrden: string): Boolean;
var
  lForma: TfrmOrdenCompra;
begin
  lForma := TfrmOrdenCompra.Create(AOwner);
  try
    lForma.lblTitulo.Caption := ATitulo;
    lForma.lblSubtitulo.Caption := SOrdenCompraAyuda;
    lForma.lblOrden.Caption := SOrdenCompraRotulo;
    lForma.lblNota.Caption := SOrdenCompraNota;
    lForma.btnGuardar.Caption := SBotonRegistrarAprobacion;
    Result := lForma.ShowModal = mrOk;
    AOrden := Trim(lForma.edOrden.Text);
  finally
    lForma.Free;
  end;
end;

procedure TfrmOrdenCompra.btnGuardarClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
