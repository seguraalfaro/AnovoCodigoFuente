unit Anovo.Forms.Principal;

// Ventana principal: sin sesion muestra el ingreso centrado; con sesion,
// menu lateral y frame de la seccion abierta.

interface

uses
  Anovo.Frames.Dashboard.Gerencia,
  Anovo.Frames.Reportes,
  Anovo.Frames.Catalogos,
  Anovo.Frames.Clientes,
  Anovo.Frames.Dashboard.Supervisor,
  Anovo.Frames.Dashboard.Cuentas,
  Anovo.Frames.Dashboard.Asesor,
  Anovo.Frames.Dashboard.Asistente,
  Anovo.Frames.SolicitudesAsesor,
  Anovo.Frames.SolicitudesAsistente,
  Anovo.Frames.Bandeja,
  Anovo.Frames.Cotizaciones,
  Anovo.Frames.Usuarios,
  Anovo.Frames.Roles,
  Anovo.Frames.Auditoria,
  Anovo.Frames.Configuracion,
  Anovo.Frames.Login,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.TitleBarCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Anovo.UI.Tema,
  Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.VirtualImage,
  Vcl.WinXCtrls, Anovo.UI.PanelRelativo, Vcl.CategoryButtons, Vcl.Buttons, FlatVcl.NavItem,
  VclPlano.NavItem,
  System.Actions, Vcl.ActnList, PestanasPlanas, Vcl.WinXPanels,
  Anovo.Vistas.Intf.Principal,
  Anovo.Presentadores.Principal,
  Anovo.Permisos,
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones;

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
    tmrAvisos: TTimer;
    imgCampana: TVirtualImage;
    imgContador: TVirtualImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VirtualImage1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AcSalirExecute(Sender: TObject);
    procedure tmrAvisosTimer(Sender: TObject);
    procedure imgCampanaClick(Sender: TObject);
  private
    FPresentador: TPresentadorPrincipal;
    FFrameTemp: TFrame;
    FLogin: TfraLogin;
    FSombra: TPaintBox;
    FItems: TArray<TPlanoNavItem>;
    FSeccionAbierta: TSeccion;
    FHaySeccion: Boolean;
    procedure SombraPaint(Sender: TObject);
    procedure MostrarIngreso;
    procedure SesionVencida(const AMensaje: string);
    procedure Ingreso(Sender: TObject);
    procedure ContenidoResize(Sender: TObject);
    procedure FormularioResize(Sender: TObject);
    procedure UbicarCampana;
    function ObtenerFrame(ASeccion: TSeccion): TFrame;
    procedure PonerFrame(const ASeccion: TSeccion; AFrame: TFrame);
    procedure LimpiarMenu;

    procedure AgregarItem(const ASeccion: TSeccion);
    procedure ItemMenuClick(Sender: TObject);
    procedure MostrarUsuario(const ANombre, ARol, AIniciales: string);
    procedure MostrarSecciones(const ASecciones: TArray<TSeccion>);
    procedure AbrirSeccion(const ASeccion: TSeccion);
    procedure ProgramarAvisos(const AMinutos: Integer);
    procedure MostrarAviso(const ASeccion: TSeccion;
      const ACantidad: Integer);
    procedure MostrarCampana(const AVisible: Boolean);
    procedure MostrarNotificaciones(const ACantidad: Integer);
    procedure MostrarCampanaOcupada(const AOcupada: Boolean);
    function PreguntarNotificaciones(const ACantidad: Integer): Boolean;
    function AbrirNotificaciones(const ACotizaciones
      : TObjectList<TCotizacionDTO>;
      const AAcciones: TAccionesNotificacion): Integer;
    function Confirmar(const AMensaje: string): Boolean;
    procedure MostrarError(const AMensaje: string);
    procedure AbrirCotizacion(const AId: Integer);
  public
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses
  System.Math,
  Anovo.UI.Iconos,
  Anovo.Config,
  Anovo.Datos.Memoria,
  Anovo.Sesion,
  Anovo.UI.Vista,
  Anovo.Api.Dashboard,
  Anovo.Api.Cotizaciones,
  Anovo.Forms.Recordatorio,
  Anovo.Textos;

const
  ALTO_ITEM = 40;
  ICONO_CONTADOR = 'Notificacion\contador-%d';
  ICONO_CONTADOR_MAS = 'Notificacion\contador-mas';
  MAXIMO_CONTADOR = 9;
  SEPARACION_CAMPANA = 10;
  ANCHO_BOTON_SISTEMA = 46;
  BOTONES_SISTEMA = 3;
  ALTO_FILA_BOTONES = 31;
  CORRIMIENTO_CONTADOR = 4;

  ICONOS_MENU: array [TSeccion] of string = (
     'Blanco\06-dashboard-blanco',
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
     'Blanco\06-dashboard-blanco',
     'Blanco\08-usuarios-blanco',
     'Blanco\09-roles-blanco',
     'Blanco\26-auditoria-blanco',
     'Blanco\10-configuracion-blanco');

function TituloSeccion(const ASeccion: TSeccion): string;
begin
  case ASeccion of
    secDashboardSupervisor, secDashboardCuentas, secDashboardAsesor,
    secDashboardAsistente, secGerencia:
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
  FPresentador := TPresentadorPrincipal.Create(Self, TApiDashboard.Create,
    TApiCotizaciones.Create);
  pnlContenido.OnResize := ContenidoResize;
  OnResize := FormularioResize;
  TSesion.AlVencer(
    procedure(AMensaje: string)
    begin
      SesionVencida(AMensaje);
    end);
  MostrarIngreso;
end;

procedure TfrmPrincipal.SesionVencida(const AMensaje: string);
begin
  if Assigned(FLogin) then
    Exit;
  AcSalirExecute(nil);
  if not AMensaje.IsEmpty then
    Informar(AMensaje);
end;

procedure TfrmPrincipal.MostrarIngreso;
begin
  SV.Visible := False;
  VirtualImage1.Visible := False;
  imgCampana.Visible := False;
  imgContador.Visible := False;
  pnlContenido.Color := clAnovoFondoIngreso;

  FSombra := TPaintBox.Create(Self);
  FSombra.Parent := pnlContenido;
  FSombra.Align := alClient;
  FSombra.OnPaint := SombraPaint;

  FLogin := TfraLogin.Create(Self);
  FLogin.Parent := pnlContenido;
  AplicarTemaFrame(FLogin);
  FLogin.OnIngreso := Ingreso;
  FLogin.Centrar;
  RedondearEsquinas(FLogin);
end;

procedure TfrmPrincipal.SombraPaint(Sender: TObject);
begin
  if Assigned(FLogin) then
    DibujarSombra(FSombra.Canvas, FLogin.BoundsRect, pnlContenido.Color);
end;

procedure TfrmPrincipal.Ingreso(Sender: TObject);
begin
  TThread.ForceQueue(nil,
    procedure
    begin
      FreeAndNil(FLogin);
      FreeAndNil(FSombra);
      pnlContenido.Color := clAnovoFondo;
      SV.Visible := True;
      VirtualImage1.Visible := True;
      FPresentador.Iniciar;
    end);
end;

procedure TfrmPrincipal.ContenidoResize(Sender: TObject);
begin
  if Assigned(FLogin) then
    FLogin.Centrar;
  if Assigned(FSombra) then
    FSombra.Invalidate;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  TSesion.AlVencer(nil);
  tmrAvisos.Enabled := False;
  FreeAndNil(FPresentador);
end;

procedure TfrmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not (Assigned(FLogin) and FLogin.Cargando);
  if not CanClose then
    Exit;
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
  tmrAvisos.Enabled := False;
  FreeAndNil(FFrameTemp);
  FHaySeccion := False;
  LimpiarMenu;
  MostrarUsuario('', '', '');
  FPresentador.CerrarSesion;
  dmMemoria.LimpiarTodo;
  MostrarIngreso;
end;

procedure TfrmPrincipal.AgregarItem(const ASeccion: TSeccion);
var
  lItem: TPlanoNavItem;
begin
  lItem := TPlanoNavItem.Create(Self);
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
  FPresentador.Navegar(TSeccion((Sender as TPlanoNavItem).Tag));
end;

procedure TfrmPrincipal.PonerFrame(const ASeccion: TSeccion; AFrame: TFrame);
var
  lItem: TPlanoNavItem;
begin
  for lItem in FItems do
    lItem.Selected := lItem.Tag = Ord(ASeccion);

  if Assigned(FFrameTemp) then
    FreeAndNil(FFrameTemp);
  FFrameTemp := AFrame;
  FSeccionAbierta := ASeccion;
  FHaySeccion := FFrameTemp <> nil;

  if FFrameTemp = nil then
    Exit;
  FFrameTemp.Parent := pnlContenido;
  FFrameTemp.Align := alClient;

  AplicarTemaFrame(FFrameTemp);
end;

procedure TfrmPrincipal.AbrirSeccion(const ASeccion: TSeccion);
begin
  if FHaySeccion and (FSeccionAbierta = ASeccion) and Assigned(FFrameTemp) then
    Exit;
  PonerFrame(ASeccion, ObtenerFrame(ASeccion));
end;

procedure TfrmPrincipal.ProgramarAvisos(const AMinutos: Integer);
begin
  tmrAvisos.Interval := AMinutos * MSecsPerSec * SecsPerMin;
  tmrAvisos.Enabled := True;
end;

procedure TfrmPrincipal.MostrarAviso(const ASeccion: TSeccion;
  const ACantidad: Integer);
var
  lItem: TPlanoNavItem;
begin
  for lItem in FItems do
    if lItem.Tag = Ord(ASeccion) then
      lItem.Badge := ACantidad;
end;

procedure TfrmPrincipal.FormularioResize(Sender: TObject);
begin
  UbicarCampana;
end;

procedure TfrmPrincipal.UbicarCampana;
var
  lBotones: TRect;
  lIzquierda, lAlto: Integer;
begin
  lBotones := CustomTitleBar.CaptionButtonsRect;
  if lBotones.IsEmpty then
  begin
    lIzquierda := TitleBarPanel1.ClientWidth -
      ScaleValue(ANCHO_BOTON_SISTEMA * BOTONES_SISTEMA);
    lAlto := ScaleValue(ALTO_FILA_BOTONES);
  end
  else
  begin
    lIzquierda := lBotones.Left;
    lAlto := lBotones.Height;
  end;
  imgCampana.SetBounds(lIzquierda - ScaleValue(SEPARACION_CAMPANA) -
    imgCampana.Width, (lAlto - imgCampana.Height) div 2, imgCampana.Width,
    imgCampana.Height);
  imgContador.SetBounds(imgCampana.Left + imgCampana.Width -
    imgContador.Width + ScaleValue(CORRIMIENTO_CONTADOR),
    Max(0, imgCampana.Top - ScaleValue(CORRIMIENTO_CONTADOR)),
    imgContador.Width, imgContador.Height);
end;

procedure TfrmPrincipal.MostrarCampana(const AVisible: Boolean);
begin
  UbicarCampana;
  imgCampana.Visible := AVisible;
  imgContador.Visible := False;
end;

procedure TfrmPrincipal.MostrarNotificaciones(const ACantidad: Integer);
begin
  if ACantidad > MAXIMO_CONTADOR then
    imgContador.ImageName := ICONO_CONTADOR_MAS
  else if ACantidad > 0 then
    imgContador.ImageName := Format(ICONO_CONTADOR, [ACantidad]);
  imgContador.Visible := imgCampana.Visible and (ACantidad > 0);
end;

function TfrmPrincipal.PreguntarNotificaciones(const ACantidad
  : Integer): Boolean;
var
  lMensaje: string;
begin
  if ACantidad = 1 then
    lMensaje := SNotificacionesUna
  else
    lMensaje := Format(SNotificacionesVarias, [ACantidad]);
  Result := Preguntar(lMensaje, SNotificacionesTitulo,
    SBotonVerNotificaciones, SBotonDespues);
end;

function TfrmPrincipal.AbrirNotificaciones(const ACotizaciones
  : TObjectList<TCotizacionDTO>;
  const AAcciones: TAccionesNotificacion): Integer;
begin
  Result := TfrmRecordatorio.Mostrar(Self, ACotizaciones, AAcciones,
    procedure(const AId, ANumero: Integer; const AListo: TProc;
      const AOcupado: TProc<Boolean>)
    begin
      FPresentador.Descartar(AId, ANumero, AListo, AOcupado);
    end);
end;

function TfrmPrincipal.Confirmar(const AMensaje: string): Boolean;
begin
  Result := Anovo.UI.Vista.Confirmar(AMensaje);
end;

procedure TfrmPrincipal.MostrarError(const AMensaje: string);
begin
  AvisarError(AMensaje);
end;

procedure TfrmPrincipal.MostrarCampanaOcupada(const AOcupada: Boolean);
begin
  imgCampana.Enabled := not AOcupada;
end;

procedure TfrmPrincipal.imgCampanaClick(Sender: TObject);
begin
  FPresentador.VerNotificaciones;
end;

procedure TfrmPrincipal.AbrirCotizacion(const AId: Integer);
begin
  if FFrameTemp is TfraCotizaciones then
    TfraCotizaciones(FFrameTemp).Abrir(AId)
  else
    PonerFrame(secCotizaciones, TfraCotizaciones.Crear(Self, AId));
end;

procedure TfrmPrincipal.tmrAvisosTimer(Sender: TObject);
begin
  ProgramarAvisos(TConfig.MinutosAvisos);
  FPresentador.RefrescarTodo;
end;

function TfrmPrincipal.ObtenerFrame(ASeccion: TSeccion): TFrame;
begin
  case ASeccion of
    secDashboardSupervisor:
      Result := TfraDashboardSupervisor.Create(Self);
    secDashboardCuentas:
      Result := TfraDashboardCuentas.Create(Self);
    secDashboardAsesor:
      Result := TfraDashboardAsesor.Create(Self);
    secDashboardAsistente:
      Result := TfraDashboardAsistente.Create(Self);
    secSolicitudes:
      if TPresentadorPrincipal.SolicitudesDelAsesor then
        Result := TfraSolicitudesAsesor.Create(Self)
      else
        Result := TfraSolicitudesAsistente.Create(Self);
    secBandeja:
      Result := TfraBandeja.Create(Self);
    secCotizaciones:
      Result := TfraCotizaciones.Create(Self);
    secClientes:
      Result := TfraClientes.Create(Self);
    secMateriales:
      Result := TfraCatalogos.Create(Self);
    secReportes:
      Result := TfraReportes.Create(Self);
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
