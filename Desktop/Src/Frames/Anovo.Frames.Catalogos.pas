unit Anovo.Frames.Catalogos;



interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXCtrls, Vcl.WinXPanels,
  Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  FlatVcl.BotonWin, VclPlano.Pestanas,
  Anovo.UI.Tema, Anovo.UI.TemaGrid, VclPlano.BotonWin;

type
  TfraCatalogos = class(TFrame)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    PlanoPestanas1: TPlanoPestanas;
    CpMain: TCardPanel;
    CardMateriales: TCard;
    CardManoObra: TCard;
    CardMaquinas: TCard;
    CardTipos: TCard;
    pnclient: TRelativePanel;
    pnbottom: TRelativePanel;
    pnTop: TRelativePanel;
    SearchBox1: TSearchBox;
    FlatWinButton1: TFlatWinButton;
    PlanoPestanas2: TPlanoPestanas;
    rDBMateriales: TrDBGrid;
    PlanoBotonWin3: TPlanoBotonWin;
    PlanoBotonWin1: TPlanoBotonWin;

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
