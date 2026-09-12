unit Anovo.Frames.Catalogos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  PestanasPlanas, Vcl.ComCtrls, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  rDBGrid, FlatVcl.BotonWin,
  Anovo.UI.Tema,
  Anovo.UI.TemaGrid;

type
  TfraCatalogos = class(TFrame)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    PestanasPlanas1: TPestanasPlanas;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    RelativePanel1: TRelativePanel;
    RelativePanel2: TRelativePanel;
    SearchBox1: TSearchBox;
    FlatWinButton1: TFlatWinButton;
    pnData: TPanel;
    rDBMateriales: TrDBGrid;
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

  AplicarTemaGrid(rDBMateriales);

end;

end.
