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
  VclPlano.NavItem,
  Anovo.Vistas.Intf.Principal,
  Anovo.Presentadores.Principal;

type
  TfrmPrincipal = class(TForm, IVistaPrincipal)
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
    procedure FormDestroy(Sender: TObject);
    procedure VirtualImage1Click(Sender: TObject);
    procedure AcDashboardExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FPresentador: TPresentadorPrincipal;
    FFrameTemp: TFrame;
    function ObtenerFrame(ASeccion: TSeccion): TFrame;
    { IVistaPrincipal }
    procedure MostrarUsuario(const ANombre, ARol, AIniciales: string);
    procedure MostrarSecciones(const ASecciones: TSecciones);
    procedure AbrirSeccion(const ASeccion: TSeccion);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses
  Anovo.UI.Iconos;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  AplicarTemaBarraTitulo(Self, TitleBarPanel1, 55);
  AplicarTema(Self);
  FPresentador := TPresentadorPrincipal.Create(Self);
  FPresentador.Iniciar;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  FPresentador.Free;
end;

procedure TfrmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(FFrameTemp) then
    FreeAndNil(FFrameTemp);
end;

procedure TfrmPrincipal.AcDashboardExecute(Sender: TObject);
begin
  FPresentador.Navegar(secDashboard);
end;

procedure TfrmPrincipal.VirtualImage1Click(Sender: TObject);
begin
  SV.Opened := not SV.Opened;
end;

procedure TfrmPrincipal.MostrarUsuario(const ANombre, ARol, AIniciales: string);
begin
  lblUsuario.Caption := ANombre;
  lblRol.Caption := ARol;
  lblIniciales.Caption := AIniciales;
end;

procedure TfrmPrincipal.MostrarSecciones(const ASecciones: TSecciones);
begin
  { Oculta, no deshabilitada: un boton gris invita a preguntar por que no
    funciona. }
  AcDashboard.Visible := secDashboard in ASecciones;
  AcCotizaciones.Visible := secCotizaciones in ASecciones;
  acNueva.Visible := secGeneracion in ASecciones;
  AcMateriales.Visible := secMateriales in ASecciones;
  AcClientes.Visible := secClientes in ASecciones;
  AcReportes.Visible := secReportes in ASecciones;
  AcBandeja.Visible := secBandeja in ASecciones;
  AcUsuarios.Visible := secUsuarios in ASecciones;
  AcRoles.Visible := secRoles in ASecciones;
  AcConfiguracion.Visible := secConfiguracion in ASecciones;
end;

procedure TfrmPrincipal.AbrirSeccion(const ASeccion: TSeccion);
begin
  if Assigned(FFrameTemp) then
    FreeAndNil(FFrameTemp);
  FFrameTemp := ObtenerFrame(ASeccion);
  { Mientras haya secciones sin frame, el panel queda vacio en vez de caerse. }
  if FFrameTemp = nil then
    Exit;
  FFrameTemp.Parent := pnlContenido;
  FFrameTemp.Align := alClient;
end;

function TfrmPrincipal.ObtenerFrame(ASeccion: TSeccion): TFrame;
begin
  case ASeccion of
    secDashboard:
      Result := TfraGeneracionCotizacion.Create(Self);
  else
    Result := nil;
  end;
end;

end.
