unit Anovo.UI.Iconos;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  System.Actions, Vcl.ActnList;

type
  TdmIconos = class(TDataModule)
    IcAnovo: TImageCollection;
    ImageCollection3: TImageCollection;
    VIEmpresa: TVirtualImageList;
    ActionList1: TActionList;
    Action1: TAction;
    ViAnovo: TVirtualImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmIconos: TdmIconos;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
