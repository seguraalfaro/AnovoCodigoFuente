unit Anovo.Frames.GeneracionCotizacion;

// Seccion Generacion de cotizacion.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, VclPlano.Tarjeta, VclPlano.BotonWin, Vcl.ExtCtrls, Vcl.WinXCtrls,
  rImprovedComps, Vcl.Imaging.pngimage, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid;

type
  TfraGeneracionCotizacion = class(TFrame)
    rpTop: TRelativePanel;
    PlanoBotonWin1: TPlanoBotonWin;
    PlanoBotonWin2: TPlanoBotonWin;
    tjCabecera: TPlanoTarjeta;
    lblCliente: TLabel;
    lblContacto: TLabel;
    lblTipo: TLabel;
    lblFecha: TLabel;
    lblValidez: TLabel;
    cboCliente: TComboBox;
    cboContacto: TComboBox;
    cboTipo: TComboBox;
    dtpFecha: TDateTimePicker;
    edtValidez: TEdit;
    Panel1: TPanel;
    PlanoTarjeta1: TPlanoTarjeta;
    PlanoTarjeta2: TPlanoTarjeta;
    PlanoTarjeta3: TPlanoTarjeta;
    PlanoTarjeta4: TPlanoTarjeta;
    grLineas: TrDBGrid;
    RelativePanel1: TRelativePanel;
    lblLineas: TLabel;
    btnNota: TPlanoBotonWin;
    btnAjuste: TPlanoBotonWin;
    btnAgregar: TPlanoBotonWin;
    RelativePanel2: TRelativePanel;
    lblSubtotalRot: TLabel;
    lblAjusteRot: TLabel;
    lblImpuestoRot: TLabel;
    lblTotalRot: TLabel;
    lblTotal: TLabel;
    lblImpuesto: TLabel;
    lblAjuste: TLabel;
    lblSubtotal: TLabel;
  private
  public
  end;

implementation

{$R *.dfm}

end.
