unit Anovo.Forms.Principal;

// Ventana principal: menu lateral y frame de la seccion abierta.

interface

uses
  Anovo.Frames.Dashboard.Gerencia,
  Anovo.Frames.Catalogos,
  Anovo.Frames.Clientes,
  Anovo.Frames.Dashboard,
  Anovo.Frames.Dashboard.Asesor,
  Anovo.Frames.Solicitudes,
  Anovo.Frames.GeneracionCotizacion,
  Anovo.Frames.Bandeja,
  Anovo.Frames.Cotizaciones,
  Anovo.Frames.Usuarios,
  Anovo.Frames.Roles,
  Anovo.Frames.Auditoria,
  Anovo.Frames.Configuracion,
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
    procedure AcSalirExecute(Sender: TObject);
  private
    FPresentador: TPresentadorPrincipal;
    FFrameTemp: TFrame;
    FItems: TArray<TFlatNavItem>;
    function ObtenerFrame(ASeccion: TSeccion): TFrame;
    procedure LimpiarMenu;

    procedure AgregarItem(const ASeccion: TSeccion);
    procedure ItemMenuClick(Sender: TObject);
    procedure MostrarUsuario(const ANombre, ARol, AIniciales: string);
    procedure MostrarSecciones(const ASecciones: TArray<TSeccion>);
    procedure AbrirSeccion(const ASeccion: TSeccion);
  public
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses
  Anovo.UI.Iconos,
  Anovo.Textos;

const
  ALTO_ITEM = 40;

  ICONOS_MENU: array [TSeccion] of string = (
     'Blanco\06-dashboard-blanco',
     'Blanco\06-dashboard-blanco',
     'Blanco\06-dashboard-blanco',
     'Blanco\00-cotizaciones-blanco',
     'Blanco\04-bandeja-blanco',
     'Blanco\00-cotizaciones-blanco',
     'Blanco\01-nueva-blanco',
     'Blanco\00-cotizaciones-blanco',
     'Blanco\02-clientes-blanco',
     'Blanco\03-materiales-blanco',
     'Blanco\05-reportes-blanco',
     'Blanco\07-gerencia-blanco',
     'Blanco\08-usuarios-blanco',
     'Blanco\09-roles-blanco',
     'Blanco\26-auditoria-blanco',
     'Blanco\10-configuracion-blanco');

function TituloSeccion(const ASeccion: TSeccion): string;
begin
  case ASeccion of
    secDashboard, secDashboardCuentas, secDashboardAsesor:
      Result := SMenuDashboard;
    secSolicitudes:
      Result := SMenuSolicitudes;
    secBandeja:
      Result := SMenuBandeja;
    secCotizaciones:
      Result := SMenuCotizaciones;
    secGeneracion:
      Result := SMenuNuevaCotizacion;
    secDetalle:
      Result := SMenuDetalle;
    secClientes:
      Result := SMenuClientes;
    secMateriales:
      Result := SMenuMateriales;
    secReportes:
      Result := SMenuReportes;
    secGerencia:
      Result := SMenuGerencia;
    secUsuarios:
      Result := SMenuUsuarios;
    secRoles:
      Result := SMenuRoles;
    secAuditoria:
      Result := SMenuAuditoria;
    secConfiguracion:
      Result := SMenuConfiguracion;
  else
    Result := '';
  end;
end;

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

procedure TfrmPrincipal.AcSalirExecute(Sender: TObject);
begin
  close;
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
  lItem.Caption := TituloSeccion(ASeccion);
  lItem.Images := dmIconos.ViAnovo;
  lItem.ImageIndex := dmIconos.ViAnovo.GetIndexByName
    (ICONOS_MENU[ASeccion]);
  lItem.SelectedColor := clGrayText;
  lItem.ShowHint := False;
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

  AplicarTemaFrame(FFrameTemp);
end;

function TfrmPrincipal.ObtenerFrame(ASeccion: TSeccion): TFrame;
begin
  case ASeccion of
    secDashboard:
      Result := TfraDashboard.Create(Self);
    secDashboardAsesor:
      Result := TfraDashboardAsesor.Create(Self);
    secSolicitudes:
      Result := TfraSolicitudes.Create(Self);
    secBandeja:
      Result := TfraBandeja.Create(Self);
    secCotizaciones:
      Result := TfraCotizaciones.Create(Self);
    secGeneracion:
      Result := TfraGeneracionCotizacion.Create(Self);
    secClientes:
      Result := TfraClientes.Create(Self);
    secMateriales:
      Result := TfraCatalogos.Create(Self);
    secGerencia:
      Result := TfraDashboardGerencia.Create(Self);
    secUsuarios:
      Result := TfraUsuarios.Create(Self);
    secRoles:
      Result := TfraRoles.Create(Self);
    secAuditoria:
      Result := TfraAuditoria.Create(Self);
    secConfiguracion:
      Result := TfraConfiguracion.Create(Self);
  else
    Result := nil;
  end;
end;

end.
