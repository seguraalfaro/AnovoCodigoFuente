unit Anovo.Forms.Conexion;

// Ventana de conexion desde el login: prueba la URL del
// servidor y la guarda en el .ini.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls,
  VclPlano.BotonWin,
  Anovo.Vistas.Intf.Configuracion,
  Anovo.Presentadores.Configuracion;

type
  TfrmConexion = class(TForm, IVistaConexion)
    TitleBarPanel1: TTitleBarPanel;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlCampos: TPanel;
    lblUrl: TLabel;
    edUrl: TEdit;
    lblNota: TLabel;
    lblPruebaRot: TLabel;
    lblPrueba: TLabel;
    pnlPie: TPanel;
    btnGuardar: TPlanoBotonWin;
    btnCancelar: TPlanoBotonWin;
    btnProbar: TPlanoBotonWin;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnProbarClick(Sender: TObject);
  private
    FPresentador: TPresentadorConexion;
    procedure MostrarProbando;
    procedure MostrarConexion(const AResultado: TResultadoConexion);
    procedure MostrarUrlInvalida(const AMensaje: string);
    procedure UrlGuardada;
  public
    class procedure Mostrar(AOwner: TComponent);
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Tema,
  Anovo.UI.Vista,
  Anovo.Api.Configuracion,
  Anovo.Config,
  Anovo.Textos;

class procedure TfrmConexion.Mostrar(AOwner: TComponent);
var
  lForma: TfrmConexion;
begin
  lForma := TfrmConexion.Create(AOwner);
  try
    lForma.ShowModal;
  finally
    lForma.Free;
  end;
end;

procedure TfrmConexion.FormCreate(Sender: TObject);
begin
  AplicarTema(Self);
  AplicarTemaBarraTitulo(Self, TitleBarPanel1);
  edUrl.Text := TConfig.UrlGuardada;
  FPresentador := TPresentadorConexion.Create(Self, TApiConfiguracion.Create);
end;

procedure TfrmConexion.FormDestroy(Sender: TObject);
begin
  FPresentador.Free;
end;

procedure TfrmConexion.btnProbarClick(Sender: TObject);
begin
  FPresentador.Probar(edUrl.Text);
end;

procedure TfrmConexion.btnGuardarClick(Sender: TObject);
begin
  FPresentador.Guardar(edUrl.Text);
end;

procedure TfrmConexion.MostrarUrlInvalida(const AMensaje: string);
begin
  AvisarError(AMensaje);
  edUrl.SetFocus;
end;

procedure TfrmConexion.UrlGuardada;
begin
  ModalResult := mrOk;
end;

procedure TfrmConexion.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmConexion.MostrarProbando;
begin
  btnProbar.Enabled := False;
  lblPrueba.Caption := SProbando;
end;

procedure TfrmConexion.MostrarConexion(const AResultado: TResultadoConexion);
begin
  btnProbar.Enabled := True;
  if AResultado.Conectado then
  begin
    lblPrueba.Tag := TAG_VALOR;
    lblPrueba.Caption := Format(SRespondeEn, [AResultado.Milisegundos]);
  end
  else
  begin
    lblPrueba.Tag := TAG_ERROR;
    lblPrueba.Caption := SSinRespuesta;
    AvisarError(AResultado.Mensaje);
  end;
  AplicarTemaEtiqueta(lblPrueba);
end;

end.
