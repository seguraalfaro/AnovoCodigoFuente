unit Anovo.Frames.Configuracion;

// Seccion Configuracion: cuenta propia, conexion y versiones.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  VclPlano.Tarjeta, VclPlano.BotonWin,
  Anovo.DTOs.Sesion,
  Anovo.Vistas.Intf.Configuracion,
  Anovo.Presentadores.Configuracion;

type
  TfraConfiguracion = class(TFrame, IVistaConfiguracion)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    pnlCuerpo: TPanel;
    tjCuenta: TPlanoTarjeta;
    lblNombreRot: TLabel;
    lblNombre: TLabel;
    lblCorreoRot: TLabel;
    lblCorreo: TLabel;
    lblRolRot: TLabel;
    lblRol: TLabel;
    lblClaveRot: TLabel;
    lblClave: TLabel;
    btnCambiarClave: TPlanoBotonWin;
    tjConexion: TPlanoTarjeta;
    lblServidorRot: TLabel;
    lblServidor: TLabel;
    lblEstadoRot: TLabel;
    lblEstado: TLabel;
    lblRespuestaRot: TLabel;
    lblRespuesta: TLabel;
    btnProbar: TPlanoBotonWin;
    tjAcercaDe: TPlanoTarjeta;
    lblVerEscritorioRot: TLabel;
    lblVerEscritorio: TLabel;
    lblVerServidorRot: TLabel;
    lblVerServidor: TLabel;
    lblVerMovilRot: TLabel;
    lblVerMovil: TLabel;
    lblVerAvisoRot: TLabel;
    lblVerAviso: TLabel;
    procedure btnCambiarClaveClick(Sender: TObject);
    procedure btnProbarClick(Sender: TObject);
  private
    FPresentador: TPresentadorConfiguracion;
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarCuenta(const ADatos: TCuentaDTO);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarProbando;
    procedure MostrarConexion(const AResultado: TResultadoConexion);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  System.Net.URLClient,
  Anovo.UI.Tema,
  Anovo.Api.Configuracion,
  Anovo.Config,
  Anovo.Formato,
  Anovo.Sesion,
  Anovo.Forms.CambioClave,
  Anovo.Textos;

function Anfitrion(const AUrl: string): string;
begin
  try
    Result := TURI.Create(AUrl).Host;
  except
    Result := AUrl;
  end;
end;

procedure PintarEstado(ALabel: TLabel; const AConectado: Boolean);
begin
  if AConectado then
    ALabel.Tag := TAG_VALOR
  else
    ALabel.Tag := TAG_ERROR;
  AplicarTemaEtiqueta(ALabel);
end;

constructor TfraConfiguracion.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  lblServidor.Caption := Anfitrion(TConfig.UrlServidor);
  lblVerEscritorio.Caption := TConfig.VersionEscritorio;

  FPresentador := TPresentadorConfiguracion.Create(Self,
    TApiConfiguracion.Create);
  FPresentador.Iniciar;
end;

destructor TfraConfiguracion.Destroy;
begin
  FPresentador.Free;
  inherited;
end;

procedure TfraConfiguracion.btnCambiarClaveClick(Sender: TObject);
begin
  if TfrmCambioClave.Mostrar(Self, False) then
    MessageDlg(SClaveCambiada, mtInformation, [mbOK], 0);
end;

procedure TfraConfiguracion.btnProbarClick(Sender: TObject);
begin
  FPresentador.Probar;
end;

procedure TfraConfiguracion.MostrarCargando(const AActivo: Boolean);
begin
  if AActivo then
    Screen.Cursor := crAppStart
  else
    Screen.Cursor := crDefault;
end;

procedure TfraConfiguracion.MostrarCuenta(const ADatos: TCuentaDTO);
begin
  lblNombre.Caption := ADatos.Nombre;
  lblCorreo.Caption := ADatos.Correo;
  lblRol.Caption := NombreDeRol(RolDesdeCodigo(ADatos.Rol));
  if ADatos.ClaveCambiada.HasValue then
    lblClave.Caption := TFormato.FechaHora(ADatos.ClaveCambiada.Value)
  else
    lblClave.Caption := SSinDato;
end;

procedure TfraConfiguracion.MostrarError(const AMensaje: string);
begin
  MessageDlg(AMensaje, mtWarning, [mbOK], 0);
end;

procedure TfraConfiguracion.MostrarProbando;
begin
  btnProbar.Enabled := False;
  lblEstado.Caption := SProbando;
  lblRespuesta.Caption := SSinDato;
end;

procedure TfraConfiguracion.MostrarConexion(const AResultado
  : TResultadoConexion);
begin
  btnProbar.Enabled := True;
  PintarEstado(lblEstado, AResultado.Conectado);

  if not AResultado.Conectado then
  begin
    lblEstado.Caption := SSinRespuesta;
    lblEstado.Hint := AResultado.Mensaje;
    lblEstado.ShowHint := True;
    Exit;
  end;

  lblEstado.Caption := SConectado;
  lblEstado.ShowHint := False;
  lblRespuesta.Caption := Format(SMilisegundos, [AResultado.Milisegundos]);

  lblVerServidor.Caption := AResultado.VersionServidor;
  if AResultado.VersionMovil.IsEmpty then
    lblVerMovil.Caption := SSinDato
  else
    lblVerMovil.Caption := AResultado.VersionMovil;
  lblVerAviso.Caption := AResultado.VersionAviso;
end;

end.
