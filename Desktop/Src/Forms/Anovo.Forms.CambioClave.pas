unit Anovo.Forms.CambioClave;

// Ventana de cambio de la clave propia, desde Configuracion
// o al entrar con clave provisional.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.TitleBarCtrls,
  VclPlano.BotonWin,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.Configuracion;

type
  TfrmCambioClave = class(TForm, IVistaRegistro)
    TitleBarPanel1: TTitleBarPanel;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlCampos: TPanel;
    lblActual: TLabel;
    edActual: TEdit;
    lblNueva: TLabel;
    edNueva: TEdit;
    lblRepetir: TLabel;
    edRepetir: TEdit;
    lblRegla: TLabel;
    pnlPie: TPanel;
    btnGuardar: TPlanoBotonWin;
    btnCancelar: TPlanoBotonWin;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FPresentador: TPresentadorCambioClave;
    FGuardado: Boolean;
    function ValidarCampos: Boolean;
    procedure MostrarGuardando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure Guardado(const AId: Integer);
  public
    class function Mostrar(AOwner: TComponent;
      const AProvisional: Boolean): Boolean;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Tema,
  Anovo.Api.Configuracion,
  Anovo.Textos;

class function TfrmCambioClave.Mostrar(AOwner: TComponent;
  const AProvisional: Boolean): Boolean;
var
  lForma: TfrmCambioClave;
begin
  lForma := TfrmCambioClave.Create(AOwner);
  try
    if AProvisional then
    begin
      lForma.lblSubtitulo.Caption := SClaveProvisional;
      lForma.btnCancelar.Caption := SSalir;
    end;
    lForma.ShowModal;
    Result := lForma.FGuardado;
  finally
    lForma.Free;
  end;
end;

procedure TfrmCambioClave.FormCreate(Sender: TObject);
begin
  AplicarTema(Self);
  AplicarTemaBarraTitulo(Self, TitleBarPanel1);
  lblRegla.Caption := SReglaClave;
  FPresentador := TPresentadorCambioClave.Create(Self,
    TApiConfiguracion.Create);
  FGuardado := False;
end;

procedure TfrmCambioClave.FormDestroy(Sender: TObject);
begin
  FPresentador.Free;
end;

function TfrmCambioClave.ValidarCampos: Boolean;
begin
  Result := False;

  if edActual.Text = '' then
  begin
    MostrarError(SFaltaClaveActual);
    edActual.SetFocus;
    Exit;
  end;

  if edNueva.Text = '' then
  begin
    MostrarError(SFaltaClaveNueva);
    edNueva.SetFocus;
    Exit;
  end;

  if edNueva.Text <> edRepetir.Text then
  begin
    MostrarError(SClavesNoCoinciden);
    edRepetir.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TfrmCambioClave.btnGuardarClick(Sender: TObject);
begin
  if ValidarCampos then
    FPresentador.Guardar(edActual.Text, edNueva.Text);
end;

procedure TfrmCambioClave.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmCambioClave.MostrarGuardando(const AActivo: Boolean);
begin
  btnGuardar.Enabled := not AActivo;
  btnCancelar.Enabled := not AActivo;
  pnlCampos.Enabled := not AActivo;
  if AActivo then
    Screen.Cursor := crAppStart
  else
    Screen.Cursor := crDefault;
end;

procedure TfrmCambioClave.MostrarError(const AMensaje: string);
begin
  MessageDlg(AMensaje, mtError, [mbOK], 0);
end;

procedure TfrmCambioClave.Guardado(const AId: Integer);
begin
  FGuardado := True;
  ModalResult := mrOk;
end;

end.
