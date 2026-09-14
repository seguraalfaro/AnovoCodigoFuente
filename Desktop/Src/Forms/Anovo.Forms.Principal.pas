unit Anovo.Forms.Principal;

interface

uses
  Anovo.Frames.Dashboard.Gerencia,
  Anovo.Frames.Catalogos,
  Anovo.Frames.Clientes,
  Anovo.Frames.Dashboard,
  Anovo.Frames.GeneracionCotizacion,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.TitleBarCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Anovo.UI.Tema,
  Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.VirtualImage,
  Vcl.WinXCtrls, Vcl.CategoryButtons, Vcl.Buttons, FlatVcl.NavItem,
  System.Actions, Vcl.ActnList, PestanasPlanas, Vcl.WinXPanels,
  VclPlano.NavItem;

type
  TSeccion = (secDashboard, secCotizaciones, secGeneracion, secDetalle,
    secMateriales, secClientes, secReportes, secBandeja, secGerencia,
    secUsuarios, secRoles, secConfiguracion);

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
    AcCotizaciones: TAction;
    acNueva: TAction;
    AcClientes: TAction;
    AcMateriales: TAction;
    AcReportes: TAction;
    FnClientes: TFlatNavItem;
    AcBandeja: TAction;
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
    PlanoNavItem1: TPlanoNavItem;
    procedure FormCreate(Sender: TObject);
    procedure VirtualImage1Click(Sender: TObject);
    procedure AcDashboardExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FFrameTemp: TFrame;

    function ObtenerFrame(ASeccion: TSeccion): TFrame;
  public
    { Public declarations }
    procedure IrAFormulario(ASeccion: TSeccion);
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

  procedure TfrmPrincipal.FormCloseQuery(Sender: TObject;
    var CanClose: Boolean);
  begin
    if  Assigned(FFrameTemp) then
      FreeAndNil(FFrameTemp);
  end;

  procedure TfrmPrincipal.FormCreate(Sender: TObject);
  begin
    AplicarTemaBarraTitulo(Self, TitleBarPanel1, 55);
    AplicarTema(Self);
    IrAFormulario(secDashboard)
  end;

  procedure TfrmPrincipal.IrAFormulario(ASeccion: TSeccion);
  begin
    if  Assigned(FFrameTemp) then
      FreeAndNil(FFrameTemp);
    FFrameTemp := ObtenerFrame(ASeccion);
    FFrameTemp.Parent := pnlContenido;
    FFrameTemp.Align := alClient;
  end;

  function TfrmPrincipal.ObtenerFrame(ASeccion: TSeccion): TFrame;
  begin
    case ASeccion of
      secDashboard:
        begin
          Result := TfraGeneracionCotizacion.Create(Self);

        end
    else
      Result := nil;
    end;

  end;

  procedure TfrmPrincipal.VirtualImage1Click(Sender: TObject);
  begin
    SV.Opened := not SV.Opened;
  end;

end.
