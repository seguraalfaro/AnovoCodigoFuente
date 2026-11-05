unit Anovo.Forms.ConfiguracionInicial;

// Ventana del primer arranque: primer administrador y razon social de la
// empresa. Sin ella el servidor no se levanta.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  VclPlano.Tarjeta, VclPlano.BotonWin;

type
  TfrmConfiguracionInicial = class(TForm)
    lblIntro: TLabel;
    tjAdministrador: TPlanoTarjeta;
    edNombre: TLabeledEdit;
    edCorreo: TLabeledEdit;
    edClave: TLabeledEdit;
    edConfirmar: TLabeledEdit;
    tjEmpresa: TPlanoTarjeta;
    edRazonSocial: TLabeledEdit;
    edCedula: TLabeledEdit;
    btnCancelar: TPlanoBotonWin;
    btnGuardar: TPlanoBotonWin;
    procedure btnGuardarClick(Sender: TObject);
  public
    class function Mostrar: Boolean; static;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Textos,
  Anovo.Services.ConfiguracionInicial;

class function TfrmConfiguracionInicial.Mostrar: Boolean;
var
  lForma: TfrmConfiguracionInicial;
begin
  lForma := TfrmConfiguracionInicial.Create(nil);
  try
    Result := lForma.ShowModal = mrOk;
  finally
    lForma.Free;
  end;
end;

procedure TfrmConfiguracionInicial.btnGuardarClick(Sender: TObject);
var
  lDatos: TDatosIniciales;
begin
  if edClave.Text <> edConfirmar.Text then
  begin
    MessageDlg(SInicialClavesDistintas, mtWarning, [mbOK], 0);
    edConfirmar.SetFocus;
    Exit;
  end;

  lDatos.Nombre := edNombre.Text;
  lDatos.Correo := edCorreo.Text;
  lDatos.Clave := edClave.Text;
  lDatos.RazonSocial := edRazonSocial.Text;
  lDatos.CedulaJuridica := edCedula.Text;

  Screen.Cursor := crHourGlass;
  try
    try
      Configurar(lDatos);
    except
      on E: Exception do
      begin
        Screen.Cursor := crDefault;
        MessageDlg(SInicialNoSePudo + sLineBreak + sLineBreak + E.Message,
          mtError, [mbOK], 0);
        Exit;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;

  MessageDlg(SInicialLista, mtInformation, [mbOK], 0);
  ModalResult := mrOk;
end;

end.
