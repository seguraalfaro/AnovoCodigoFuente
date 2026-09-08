unit Anovo.UI.Iconos;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TdmIconos = class(TDataModule)
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    ImageCollection2: TImageCollection;
    VirtualImageList2: TVirtualImageList;
    ImageCollection3: TImageCollection;
    VIEmpresa: TVirtualImageList;
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
