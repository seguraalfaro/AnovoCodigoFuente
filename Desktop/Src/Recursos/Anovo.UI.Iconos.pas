unit Anovo.UI.Iconos;

// Modulo de datos con las imagenes de iconos de la aplicacion.

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
  public
  end;

var
  dmIconos: TdmIconos;

implementation

{$R *.dfm}

end.
