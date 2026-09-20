unit Anovo.Frames.Catalogos;



interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXCtrls, Vcl.WinXPanels,
  Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  FlatVcl.BotonWin, VclPlano.Pestanas,
  Anovo.UI.Tema, Anovo.UI.DBGridExtend, VclPlano.BotonWin;

type
  TfraCatalogos = class(TFrame)
    pnbottom: TRelativePanel;
    pnlBarra: TPanel;
    sbBuscar: TSearchBox;
    btnExportar: TPlanoBotonWin;
    btnNuevo: TPlanoBotonWin;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pstCatalogo: TPlanoPestanas;
    pnclient: TRelativePanel;
    grDatos: TrDBGrid;

  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}
{ TfraCatalogos }

constructor TfraCatalogos.Create(AOwner: TComponent);
begin
  inherited;
  AplicarTemaGrid(grDatos);

end;



end.
