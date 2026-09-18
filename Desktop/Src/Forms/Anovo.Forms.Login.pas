unit Anovo.Forms.Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,System.UITypes,
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
    procedure FormCreate(Sender: TObject);
    procedure AcIngresarExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FPresentador: TPresentadorLogin;
    FCargando: Boolean;
    procedure CargarMarca;
    { IVistaLogin }
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure IrACambioDeClave;
    procedure IrAPrincipal;

  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses
  Anovo.UI.Iconos,
  Anovo.UI.Tema,
  Anovo.Api.Autenticacion;

const
  ANCHO_MARCA = 420;
  { TfrmLogin }

procedure TfrmLogin.AcIngresarExecute(Sender: TObject);
begin

  FPresentador.Ingresar(edtUsuario.Text, edtClave.Text);
end;

procedure TfrmLogin.CargarMarca;
var
  lRuta: string;
  lPng: TPngImage;
begin
  { El logo va en Recursos y no incrustado en el .res: asi se reemplaza sin
    recompilar cuando Anovo mande una version nueva. Si el archivo no esta,
    FLogoCargado queda en False y el arte dibuja el engranaje de respaldo. }
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
        { Centrado sobre la mitad util del panel, la que no tapa la diagonal. }
        ImgLogo.Left := (ANCHO_MARCA - 60 - ImgLogo.Width) div 2;
        ImgLogo.Top := 153 - ImgLogo.Height div 2;

      finally
        lPng.Free;
      end;
    except
      { Un PNG ilegible no puede tumbar el arranque. }

    end;

  { La filigrana viene ya atenuada desde el archivo: TImage no tiene opacidad
    y mezclarla en tiempo de ejecucion obligaria a un TBitmap32. }
  if FileExists(lRuta + 'logo-filigrana.png') then
    try
      imgFiligrana.Picture.LoadFromFile(lRuta + 'logo-filigrana.png');
    except
      imgFiligrana.Visible := False;
    end
  else
    imgFiligrana.Visible := False;

end;

procedure TfrmLogin.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FCargando;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  CargarMarca;
  AplicarTemaBarraTitulo(Self, TitleBarPanel1);
  AplicarTema(Self);
  FPresentador := TPresentadorLogin.Create(Self, TApiAutenticacion.Create);
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
  { Sin esto, un segundo Enter lanza otro login mientras el primero sigue. }
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

end.
