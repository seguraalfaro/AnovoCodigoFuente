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

  procedure TfrmPrincipal.FormCreate(Sender: TObject);
  begin
    AplicarTemaBarraTitulo(Self, TitleBarPanel1, 55);
    AplicarTema(Self);

  end;

  procedure TfrmPrincipal.IrAFormulario(ASeccion: TSeccion);
  begin
    if not Assigned(FFrameTemp) then
      FreeAndNil(FFrameTemp);
    FFrameTemp := ObtenerFrame(ASeccion);
    FFrameTemp.Parent := pnlContenido;
    FFrameTemp.Align := alClient;
  end;

  function TfrmPrincipal.ObtenerFrame(ASeccion: TSeccion): TFrame;
  begin
    { case ASeccion of
      secDashboard:
      begin
      if not Assigned(FfraDashboard) then
      FfraDashboard := TfraDashboard.Create(Self);
      Result := FfraDashboard;
      end;
      secCotizaciones:
      begin
      if not Assigned(FfraCotizaciones) then
      FfraCotizaciones := TfraCotizaciones.Create(Self);
      Result := FfraCotizaciones;
      end;
      secGeneracion:
      begin
      if not Assigned(FfraGeneracion) then
      FfraGeneracion := TfraGeneracion.Create(Self);
      Result := FfraGeneracion;
      end;
      secDetalle:
      begin
      if not Assigned(FfraDetalle) then
      FfraDetalle := TfraDetalle.Create(Self);
      Result := FfraDetalle;
      end;
      secMateriales:
      begin
      if not Assigned(FfraMateriales) then
      FfraMateriales := TfraMateriales.Create(Self);
      Result := FfraMateriales;
      end;
      secClientes:
      begin
      if not Assigned(FfraClientes) then
      FfraClientes := TfraClientes.Create(Self);
      Result := FfraClientes;
      end;
      secReportes:
      begin
      if not Assigned(FfraReportes) then
      FfraReportes := TfraReportes.Create(Self);
      Result := FfraReportes;
      end;
      secBandeja:
      begin
      if not Assigned(FfraBandeja) then
      FfraBandeja := TfraBandeja.Create(Self);
      Result := FfraBandeja;
      end;
      secGerencia:
      begin
      if not Assigned(FfraGerencia) then
      FfraGerencia := TfraGerencia.Create(Self);
      Result := FfraGerencia;
      end;
      secUsuarios:
      begin
      if not Assigned(FfraUsuarios) then
      FfraUsuarios := TfraUsuarios.Create(Self);
      Result := FfraUsuarios;
      end;
      secRoles:
      begin
      if not Assigned(FfraRoles) then
      FfraRoles := TfraRoles.Create(Self);
      Result := FfraRoles;
      end;
      else
      Result := nil;
      end; }
  end;

  procedure TfrmPrincipal.VirtualImage1Click(Sender: TObject);
  begin
    SV.Opened := not SV.Opened;
  end;

end.
