unit Anovo.Frames.Login;

// Ingreso al sistema, centrado dentro de la ventana principal mientras no
// hay sesion.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Imaging.pngimage, Vcl.Buttons,
  Vcl.VirtualImage, System.Actions, Vcl.ActnList,
  Anovo.Vistas.Intf.Login,
  Anovo.Presentadores.Login, VclPlano.BotonWin;

type
  TfraLogin = class(TFrame, IVistaLogin)
    pnlMarca: TPanel;
    ImgLogo: TImage;
    ImgFondo: TImage;
    pnlForm: TRelativePanel;
    aiCargando: TActivityIndicator;
    imgFiligrana: TImage;
    lblUsuario: TLabel;
    pnlCampoUsuario: TPanel;
    lblClave: TLabel;
    pnlCampoClave: TPanel;
    pbIconoUsuario: TVirtualImage;
    pbIconoClave: TVirtualImage;
    pbOjo: TVirtualImage;
    edtUsuario: TEdit;
    edtClave: TEdit;
    lblTitulo: TLabel;
    lblOlvido: TLabel;
    lblConfigurar: TLabel;
    lblVersion: TLabel;
    VirtualImage4: TVirtualImage;
    lblMarcaNombre: TLabel;
    lblMarcaSistema: TLabel;
    ActionList1: TActionList;
    AcIngresar: TAction;
    BtnIngresar: TPlanoBotonWin;
    ComboBox1: TComboBox;
    procedure AcIngresarExecute(Sender: TObject);
    procedure pbOjoClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    FPresentador: TPresentadorLogin;
    FCargando: Boolean;
    FOnIngreso: TNotifyEvent;
    procedure CargarMarca;
    procedure lblConfigurarClick(Sender: TObject);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure IrACambioDeClave;
    procedure IrAPrincipal;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Centrar;
    property Cargando: Boolean read FCargando;
    property OnIngreso: TNotifyEvent read FOnIngreso write FOnIngreso;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Vista,
  Anovo.UI.Iconos,
  Anovo.UI.Tema,
  Anovo.Api.Autenticacion,
  Anovo.Config,
  Anovo.Sesion,
  Anovo.Textos,
  Anovo.Forms.CambioClave,
  Anovo.Forms.Conexion;

const
  ANCHO_MARCA = 420;

constructor TfraLogin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  edtUsuario.Text := ComboBox1.Text;
  CargarMarca;
  lblConfigurar.OnClick := lblConfigurarClick;
  lblVersion.Caption := 'v' + TConfig.VersionEscritorio;
  FPresentador := TPresentadorLogin.Create(Self, TApiAutenticacion.Create);
end;

destructor TfraLogin.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraLogin.Centrar;
begin
  if Parent = nil then
    Exit;
  Left := (Parent.ClientWidth - Width) div 2;
  Top := (Parent.ClientHeight - Height) div 2;
end;

procedure TfraLogin.AcIngresarExecute(Sender: TObject);
begin
  FPresentador.Ingresar(edtUsuario.Text, edtClave.Text);
end;

procedure TfraLogin.CargarMarca;
var
  lRuta: string;
  lPng: TPngImage;
begin
  lRuta := ExtractFilePath(Application.ExeName) + 'Recursos\Marca\';
  if FileExists(lRuta + 'fondo-marca.png') then
  begin
    try
      ImgFondo.Picture.LoadFromFile(lRuta + 'fondo-marca.png');
    except
      ImgFondo.Visible := False;
    end
  end;

  if FileExists(lRuta + 'logo.png') then
    try
      lPng := TPngImage.Create;
      try
        lPng.LoadFromFile(lRuta + 'logo.png');
        ImgLogo.Picture.Assign(lPng);
        ImgLogo.Width := lPng.Width;
        ImgLogo.Height := lPng.Height;
        ImgLogo.Left := (ANCHO_MARCA - 60 - ImgLogo.Width) div 2;
        ImgLogo.Top := 153 - ImgLogo.Height div 2;
      finally
        lPng.Free;
      end;
    except
    end;

  if FileExists(lRuta + 'logo-filigrana.png') then
    try
      imgFiligrana.Picture.LoadFromFile(lRuta + 'logo-filigrana.png');
    except
      imgFiligrana.Visible := False;
    end
  else
    imgFiligrana.Visible := False;
end;

procedure TfraLogin.ComboBox1Change(Sender: TObject);
begin
  edtUsuario.Text := ComboBox1.Text;
end;

procedure TfraLogin.lblConfigurarClick(Sender: TObject);
begin
  TfrmConexion.Mostrar(Self);
end;

procedure TfraLogin.IrACambioDeClave;
begin
  if TfrmCambioClave.Mostrar(Self, True) then
    Informar(SClaveCambiadaReingreso);
  TSesion.Cerrar;
  edtClave.Clear;
  edtClave.SetFocus;
end;

procedure TfraLogin.IrAPrincipal;
begin
  if Assigned(FOnIngreso) then
    FOnIngreso(Self);
end;

procedure TfraLogin.MostrarCargando(const AActivo: Boolean);
begin
  FCargando := AActivo;
  aiCargando.Visible := AActivo;
  aiCargando.Animate := AActivo;

  AcIngresar.Enabled := not AActivo;
  edtUsuario.Enabled := not AActivo;
  edtClave.Enabled := not AActivo;
end;

procedure TfraLogin.MostrarError(const AMensaje: string);
begin
  AvisarError(AMensaje);
  edtClave.Clear;
  edtClave.SetFocus;
end;

procedure TfraLogin.pbOjoClick(Sender: TObject);
begin
  if pbOjo.ImageIndex = 145 then
  begin
    pbOjo.ImageIndex := 146;
    edtClave.PasswordChar := #0
  end
  else
  begin
    pbOjo.ImageIndex := 145;
    edtClave.PasswordChar := '*';
  end;
end;

end.
