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
  Anovo.Forms.Edicion,
  Anovo.Vistas.Intf.Registro,
  Anovo.Presentadores.Configuracion;

type
  TfrmCambioClave = class(TfrmEdicion, IVistaRegistro)
    pnlCampos: TPanel;
    lblActual: TLabel;
    edActual: TEdit;
    lblNueva: TLabel;
    edNueva: TEdit;
    lblRepetir: TLabel;
    edRepetir: TEdit;
    lblRegla: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
  private
    FPresentador: TPresentadorCambioClave;
    FGuardado: Boolean;
    function ValidarCampos: Boolean;
    procedure Guardado(const AId: Integer);
  protected
    function ControlesEdicion: TArray<TControl>; override;
  public
    class function Mostrar(AOwner: TComponent;
      const AProvisional: Boolean): Boolean;
  end;

implementation

{$R *.dfm}

uses
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
  lblRegla.Caption := SReglaClave;
  FPresentador := TPresentadorCambioClave.Create(Self,
    TApiConfiguracion.Create);
  FGuardado := False;
end;

procedure TfrmCambioClave.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPresentador);
end;

function TfrmCambioClave.ControlesEdicion: TArray<TControl>;
begin
  Result := [pnlCampos];
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

procedure TfrmCambioClave.Guardado(const AId: Integer);
begin
  FGuardado := True;
  ModalResult := mrOk;
end;

end.
