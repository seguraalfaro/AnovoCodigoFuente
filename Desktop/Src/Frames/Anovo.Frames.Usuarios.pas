unit Anovo.Frames.Usuarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclPlano.Pestanas,
  Vcl.StdCtrls, VclPlano.BotonWin, Vcl.WinXCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, rDBGrid;

type
  TfraUsuarios = class(TFrame)
    pnlBarra: TPanel;
    sbBuscar: TSearchBox;
    btnExportar: TPlanoBotonWin;
    btnNuevo: TPlanoBotonWin;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pstFiltros: TPlanoPestanas;
    pnbottom: TRelativePanel;
    rpCliente: TRelativePanel;
    grDatos: TrDBGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
