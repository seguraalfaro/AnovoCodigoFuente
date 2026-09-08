unit Anovo.Forms.Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ActnMan,
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.TitleBarCtrls, Vcl.Buttons;

type
  TfrmLogin = class(TForm)
    TitleBarPanel1: TTitleBarPanel;
    pnlForm: TPanel;
    imgFiligrana: TImage;
    lblTitulo: TLabel;
    lblAyuda: TLabel;
    lblUsuario: TLabel;
    lblClave: TLabel;
    lblOlvido: TLabel;
    lblMensaje: TLabel;
    lblConfigurar: TLabel;
    lblVersion: TLabel;
    pbIconoConfig: TPaintBox;
    pnlCampoUsuario: TPanel;
    pbIconoUsuario: TPaintBox;
    edtUsuario: TEdit;
    pnlCampoClave: TPanel;
    pbIconoClave: TPaintBox;
    pbOjo: TPaintBox;
    edtClave: TEdit;
    pnlIngresar: TPanel;
    pbIconoEntrar: TPaintBox;
    lblIngresar: TLabel;
    aiCargando: TActivityIndicator;
    pnlMarca: TPanel;
    ImgLogo: TImage;
    ImgFondo: TImage;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
  private

    procedure CargarMarca;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses
  Anovo.UI.Iconos,
  Anovo.UI.Tema;

const
  ANCHO_MARCA = 420;
  { TfrmLogin }

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

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  CargarMarca;
  Color := clAnovoTarjeta;
  AplicarSuperficie(pnlMarca, clAnovoMarca);
  AplicarSuperficie(pnlForm, clAnovoTarjeta);
end;

end.
