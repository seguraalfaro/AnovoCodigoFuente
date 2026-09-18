unit Anovo.Forms.Principal;

{ Ventana principal: menu lateral y el frame de la seccion abierta.

  El menu se arma en ejecucion con lo que manda el presentador, ya filtrado y
  ordenado. Aqui solo se decide como se ve: texto e icono de cada seccion. Un
  item que no corresponde no se oculta, no se crea: asi no quedan huecos. }

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
    pnlMenu: TPanel;
    ActionList1: TActionList;
    pnlBottom: TRelativePanel;
    pnlsepBottom: TRelativePanel;
    FlatNavItem1: TFlatNavItem;
    AcSalir: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VirtualImage1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FPresentador: TPresentadorPrincipal;
    FFrameTemp: TFrame;
    FItems: TArray<TFlatNavItem>;
    function ObtenerFrame(ASeccion: TSeccion): TFrame;
    procedure LimpiarMenu;

    procedure AgregarItem(const ASeccion: TSeccion);
    procedure ItemMenuClick(Sender: TObject);
    { IVistaPrincipal }
    procedure MostrarUsuario(const ANombre, ARol, AIniciales: string);
    procedure MostrarSecciones(const ASecciones: TArray<TSeccion>);
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

type
  TItemMenu = record
    Titulo: string;
    Icono: string;
  end;

const
  ALTO_ITEM = 40;

  ITEMS_MENU: array [TSeccion] of TItemMenu = (
    { secDashboard } (Titulo: 'Dashboard'; Icono: 'Blanco\06-dashboard-blanco'),
    { secDashboardCuentas } (Titulo: 'Dashboard';
    Icono: 'Blanco\06-dashboard-blanco'),
    { secSolicitudes } (Titulo: 'Solicitudes';
    Icono: 'Blanco\00-cotizaciones-blanco'),
    { secBandeja } (Titulo: 'Bandeja'; Icono: 'Blanco\04-bandeja-blanco'),
    { secCotizaciones } (Titulo: 'Cotizaciones';
    Icono: 'Blanco\00-cotizaciones-blanco'),
    { secGeneracion } (Titulo: 'Nueva cotizaci'#243'n';
    Icono: 'Blanco\01-nueva-blanco'),
    { secDetalle } (Titulo: 'Detalle'; Icono: 'Blanco\00-cotizaciones-blanco'),
    { secClientes } (Titulo: 'Clientes'; Icono: 'Blanco\02-clientes-blanco'),
    { secMateriales } (Titulo: 'Materiales';
    Icono: 'Blanco\03-materiales-blanco'),
    { secReportes } (Titulo: 'Reportes'; Icono: 'Blanco\05-reportes-blanco'),
    { secGerencia } (Titulo: 'Vista de gerencia';
    Icono: 'Blanco\07-gerencia-blanco'),
    { secUsuarios } (Titulo: 'Usuarios'; Icono: 'Blanco\08-usuarios-blanco'),
    { secRoles } (Titulo: 'Roles'; Icono: 'Blanco\09-roles-blanco'),
    { secConfiguracion } (Titulo: 'Configuraci'#243'n';
    Icono: 'Blanco\10-configuracion-blanco'));

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

procedure TfrmPrincipal.LimpiarMenu;
var
  I: Integer;
begin
  FItems := nil;
  for I := pnlMenu.ControlCount - 1 downto 0 do
    pnlMenu.Controls[I].Free;
end;

procedure TfrmPrincipal.AgregarItem(const ASeccion: TSeccion);
var
  lItem: TFlatNavItem;
begin
  lItem := TFlatNavItem.Create(Self);
  lItem.Top := MaxInt div 2;
  lItem.Parent := pnlMenu;
  lItem.Align := alTop;
  lItem.Height := ALTO_ITEM;
  lItem.Caption := ITEMS_MENU[ASeccion].Titulo;
  lItem.Images := dmIconos.ViAnovo;
  lItem.ImageIndex := dmIconos.ViAnovo.GetIndexByName
    (ITEMS_MENU[ASeccion].Icono);
  lItem.SelectedColor := clGrayText;
  lItem.ShowHint := False;
  { El Tag guarda la seccion. pnlMenu lleva TAG_RAW, asi que el tema no lo lee. }
  lItem.Tag := Ord(ASeccion);
  lItem.OnClick := ItemMenuClick;
  FItems := FItems + [lItem];
end;

procedure TfrmPrincipal.MostrarSecciones(const ASecciones: TArray<TSeccion>);
var
  lSeccion: TSeccion;
begin
  LimpiarMenu;
  for lSeccion in ASecciones do
  begin
    AgregarItem(lSeccion);
  end;
end;

procedure TfrmPrincipal.ItemMenuClick(Sender: TObject);
begin
  FPresentador.Navegar(TSeccion((Sender as TFlatNavItem).Tag));
end;

procedure TfrmPrincipal.AbrirSeccion(const ASeccion: TSeccion);
var
  lItem: TFlatNavItem;
begin
  for lItem in FItems do
    lItem.Selected := lItem.Tag = Ord(ASeccion);

  if Assigned(FFrameTemp) then
    FreeAndNil(FFrameTemp);
  FFrameTemp := ObtenerFrame(ASeccion);

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
