unit Anovo.Forms.Principal;

interface

uses
  Anovo.Frames.Catalogos,
  Anovo.Frames.Clientes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.TitleBarCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Anovo.UI.Tema,
  Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.VirtualImage,
  Vcl.WinXCtrls, Vcl.CategoryButtons, Vcl.Buttons, FlatVcl.NavItem,
  System.Actions, Vcl.ActnList, PestanasPlanas, Vcl.WinXPanels;

type
  TfrmPrincipal = class(TForm)
    TitleBarPanel1: TTitleBarPanel;
    VirtualImage1: TVirtualImage;
    pnlContenido: TPanel;
    SV: TSplitView;
    pnlUsuario: TRelativePanel;
    lblRol: TLabel;
    lblUsuario: TLabel;
    pnlAvatar: TPanel;
    lblIniciales: TLabel;
    pnsep: TRelativePanel;
    RelativePanel1: TRelativePanel;
    FnDashboard: TFlatNavItem;
    ActionList1: TActionList;
    AcDashboard: TAction;
    FnCotizaciones: TFlatNavItem;
    Fnueva: TFlatNavItem;
    AcCotizaciones: TAction;
    acNueva: TAction;
    AcClientes: TAction;
    AcMateriales: TAction;
    AcReportes: TAction;
    FnClientes: TFlatNavItem;
    AcBandeja: TAction;
    FnBandeja: TFlatNavItem;
    FnReportes: TFlatNavItem;
    pnlBottom: TRelativePanel;
    pnlsepBottom: TRelativePanel;
    FlatNavItem1: TFlatNavItem;
    AcSalir: TAction;
    AcConfiguracion: TAction;
    AcRoles: TAction;
    AcUsuarios: TAction;
    FnUsuarios: TFlatNavItem;
    FnRoles: TFlatNavItem;
    FnConfiguracion: TFlatNavItem;
    procedure FormCreate(Sender: TObject);
    procedure VirtualImage1Click(Sender: TObject);
    procedure AcDashboardExecute(Sender: TObject);
  private
    { Private declarations }
    FFrameTemp: TFrame;
    FfraCatalogos: TfraCatalogos;

    /// function ObtenerFrame(ASeccion: TSeccion): TFrame;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses
  Anovo.UI.Iconos;

procedure TfrmPrincipal.AcDashboardExecute(Sender: TObject);
begin
  var
    s: string

    end;

  procedure TfrmPrincipal.FormCreate(Sender: TObject);
  begin
    AplicarTemaBarraTitulo(Self, TitleBarPanel1, 55);
    AplicarTema(Self);

    FFrameTemp := TfraClientes.Create(Self);
    FFrameTemp.Parent := pnlContenido;
    FFrameTemp.Align := alClient;
  end;

  procedure TfrmPrincipal.VirtualImage1Click(Sender: TObject);
  begin
    SV.Opened := not SV.Opened;
  end;

end.
