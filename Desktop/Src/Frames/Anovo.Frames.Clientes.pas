unit Anovo.Frames.Clientes;

interface

uses
  Anovo.UI.Tema,
  Anovo.UI.TemaGrid,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  VclPlano.BotonWin, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Pestanas;

type
  TfraClientes = class(TFrame)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlBarra: TPanel;
    sbBuscar: TSearchBox;
    btnExportar: TPlanoBotonWin;
    btnNuevo: TPlanoBotonWin;
    pnclient: TRelativePanel;
    pnbottom: TRelativePanel;
    pstFiltros: TPlanoPestanas;
    grClientes: TrDBGrid;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}
{ TfraClientes }

constructor TfraClientes.Create(AOwner: TComponent);
begin
  inherited;
  AplicarTemaGrid(grClientes);
end;

end.
