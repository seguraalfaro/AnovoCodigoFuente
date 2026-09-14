unit AnovoFrames.GeneracionCotizacion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, VclPlano.Tarjeta, VclPlano.BotonWin, Vcl.ExtCtrls, Vcl.WinXCtrls;

type
  TFrame2 = class(TFrame)
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
