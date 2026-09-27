unit Anovo.Forms.Login;

// Ventana de inicio de sesion.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ActnMan,
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.TitleBarCtrls, Vcl.Buttons,
  Vcl.VirtualImage, System.Actions, Vcl.ActnList,
  Anovo.Vistas.Intf.Login,
  Anovo.Presentadores.Login, VclPlano.BotonWin;

type
  TfrmLogin = class(TForm, IVistaLogin)
    TitleBarPanel1: TTitleBarPanel;
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
    procedure FormCreate(Sender: TObject);
    procedure AcIngresarExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pbOjoClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    FPresentador: TPresentadorLogin;
    FCargando: Boolean;
    procedure CargarMarca;
    procedure lblConfigurarClick(Sender: TObject);

    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure IrACambioDeClave;
    procedure IrAPrincipal;

  public

  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses
  Anovo.UI.Iconos,
  Anovo.UI.Tema,
  Anovo.Api.Autenticacion,
  Anovo.Config,
  Anovo.Forms.Conexion;

const
  ANCHO_MARCA = 420;

procedure TfrmLogin.AcIngresarExecute(Sender: TObject);
begin

  FPresentador.Ingresar(edtUsuario.Text, edtClave.Text);
end;

procedure TfrmLogin.CargarMarca;
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

procedure TfrmLogin.ComboBox1Change(Sender: TObject);
begin
edtUsuario.Text:=ComboBox1.Text;
end;

procedure TfrmLogin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FCargando;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
edtUsuario.Text:=ComboBox1.Text;
  CargarMarca;
  AplicarTemaBarraTitulo(Self, TitleBarPanel1);
  AplicarTema(Self);
  lblConfigurar.OnClick := lblConfigurarClick;
  lblVersion.Caption := 'v' + TConfig.VersionEscritorio;
  FPresentador := TPresentadorLogin.Create(Self, TApiAutenticacion.Create);
end;

procedure TfrmLogin.lblConfigurarClick(Sender: TObject);
begin
  TfrmConexion.Mostrar(Self);
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
  FPresentador.Free;
end;

procedure TfrmLogin.IrACambioDeClave;
begin
  ModalResult := mrRetry;
end;

procedure TfrmLogin.IrAPrincipal;
begin
  ModalResult := mrOk;
end;

procedure TfrmLogin.MostrarCargando(const AActivo: Boolean);
begin
  FCargando := AActivo;
  aiCargando.Visible := AActivo;
  aiCargando.Animate := AActivo;

  AcIngresar.Enabled := not AActivo;
  edtUsuario.Enabled := not AActivo;
  edtClave.Enabled := not AActivo;
end;

procedure TfrmLogin.MostrarError(const AMensaje: string);
begin
  MessageDlg(AMensaje, mtWarning, [mbOK], 0);
  edtClave.Clear;
  edtClave.SetFocus;
end;

procedure TfrmLogin.pbOjoClick(Sender: TObject);
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
