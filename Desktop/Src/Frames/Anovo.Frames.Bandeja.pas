unit Anovo.Frames.Bandeja;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.StdCtrls, VclPlano.BotonWin, VclPlano.Pestanas, Data.DB,
  Vcl.Grids, Vcl.DBGrids, rDBGrid, VclPlano.Tarjeta;

type
  TfraBandeja = class(TFrame)
    pnbottom: TRelativePanel;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlBarra: TPanel;
    sbBuscar: TSearchBox;
    btnExportar: TPlanoBotonWin;
    pnclient: TRelativePanel;
    grDatos: TrDBGrid;
    RelativePanel1: TRelativePanel;
    tpPendiente: TPlanoTarjeta;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
