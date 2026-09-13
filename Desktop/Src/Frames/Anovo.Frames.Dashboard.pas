unit Anovo.Frames.Dashboard;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Actions, System.ImageList,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons, Vcl.ActnList, Vcl.ImgList,
  Vcl.CheckLst, Vcl.WinXCtrls, Vcl.WinXPanels, Vcl.TitleBarCtrls,
  Vcl.VirtualImage, Vcl.Imaging.pngimage,
  Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Boton, VclPlano.BotonWin, VclPlano.Pastilla, VclPlano.NavItem,
  VclPlano.Tarjeta, VclPlano.Pestanas;

type
  TfraDashboard = class(TFrame)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlKpi: TPanel;
    tjBorradores: TPlanoTarjeta;
    lblBorradores: TLabel;
    tjPendientes: TPlanoTarjeta;
    lblPendientes: TLabel;
    tjAprobadas: TPlanoTarjeta;
    lblAprobadas: TLabel;
    tjMontoMes: TPlanoTarjeta;
    lblMontoMes: TLabel;
    dsCotizaciones: TDataSource;
    PlanoTarjeta1: TPlanoTarjeta;
    grCotizaciones: TrDBGrid;
  end;

implementation

{$R *.dfm}

end.
