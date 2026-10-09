unit Anovo.Frames.Configuracion;

// Seccion Configuracion: cuenta propia, conexion, versiones, datos de la
// empresa y parametros.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls,
  rDBComponents,
  VclPlano.Tarjeta, VclPlano.BotonWin,
  Anovo.DTOs.Empresa,
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
    lblPermisosRot: TLabel;
    lblPermisos: TLabel;
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
    btnCambiarServidor: TPlanoBotonWin;
    tjAcercaDe: TPlanoTarjeta;
    lblVerEscritorioRot: TLabel;
    lblVerEscritorio: TLabel;
    lblVerServidorRot: TLabel;
    lblVerServidor: TLabel;
    lblVerBaseRot: TLabel;
    lblVerBase: TLabel;
    lblVerMovilRot: TLabel;
    lblVerMovil: TLabel;
    lblVerAvisoRot: TLabel;
    lblVerAviso: TLabel;
    tjEmpresa: TPlanoTarjeta;
    edRazonSocial: TrDBEdit;
    edCedula: TrDBEdit;
    edRepresentante: TrDBEdit;
    edCorreoEmpresa: TrDBEdit;
    edTelefono: TrDBEdit;
    edCelular: TrDBEdit;
    edDireccion: TrDBEdit;
    edCuenta: TrDBEdit;
    edIva: TrDBEdit;
    lblNotaIva: TLabel;
    btnDocumentoEmpresa: TPlanoBotonWin;
    btnDeshacer: TPlanoBotonWin;
    btnGuardarEmpresa: TPlanoBotonWin;
    tjParametros: TPlanoTarjeta;
    edMinutos: TrDBEdit;
    lblNotaMinutos: TLabel;
    edDias: TrDBEdit;
    lblNotaDias: TLabel;
    btnGuardarParametros: TPlanoBotonWin;
    procedure btnCambiarClaveClick(Sender: TObject);
    procedure btnProbarClick(Sender: TObject);
    procedure btnCambiarServidorClick(Sender: TObject);
    procedure btnDeshacerClick(Sender: TObject);
    procedure btnDocumentoEmpresaClick(Sender: TObject);
    procedure btnGuardarEmpresaClick(Sender: TObject);
    procedure btnGuardarParametrosClick(Sender: TObject);
  private
    FPresentador: TPresentadorConfiguracion;
    function ValidarEmpresa: Boolean;
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarCuenta(const ADatos: TCuentaDTO);
    procedure MostrarPermisosPropios(const ATexto: string);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarMinutosAvisos(const AMinutos: Integer);
    procedure MostrarSeccionEmpresa(const AVisible: Boolean);
    procedure MostrarEmpresa(const AEmpresa: TEmpresaDTO);
    procedure EmpresaGuardada;
    procedure ParametrosGuardados;
    procedure MostrarProbando;
    procedure MostrarConexion(const AResultado: TResultadoConexion);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Vista,
  System.Net.URLClient,
  Anovo.UI.Tema,
  Anovo.Api.Configuracion,
  Anovo.Config,
  Anovo.Formato,
  Anovo.Sesion,
  Anovo.Forms.CambioClave,
  Anovo.Forms.Conexion,
  Anovo.Forms.DocumentoEmpresa,
  Anovo.Datos.Memoria,
  Anovo.Mapeo.Datos,
  Anovo.Validacion,
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
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraConfiguracion.btnCambiarClaveClick(Sender: TObject);
begin
  if TfrmCambioClave.Mostrar(Self, False) then
    TSesion.Vencer(SClaveCambiadaReingreso);
end;

procedure TfraConfiguracion.btnProbarClick(Sender: TObject);
begin
  FPresentador.Probar;
end;

procedure TfraConfiguracion.btnCambiarServidorClick(Sender: TObject);
begin
  TfrmConexion.Mostrar(Self);
  lblServidor.Caption := Anfitrion(TConfig.UrlServidor);
  FPresentador.Probar;
end;

procedure TfraConfiguracion.btnDocumentoEmpresaClick(Sender: TObject);
begin
  if TfrmDocumentoEmpresa.Editar(Self) then
    btnGuardarEmpresaClick(Sender);
end;

procedure TfraConfiguracion.btnDeshacerClick(Sender: TObject);
begin
  dmMemoria.mtEmpresa.Cancel;
  FPresentador.DeshacerEmpresa;
end;

function TfraConfiguracion.ValidarEmpresa: Boolean;
var
  lReparos: TStringList;
  lMensaje: string;
  I: Integer;
begin
  lReparos := TStringList.Create;
  try
    with dmMemoria do
    begin
      if not TValidacion.Texto(mtEmpresaRAZON_SOCIAL.AsString) then
        lReparos.Add(SEmpresaFaltaRazonSocial);

      if not TValidacion.Texto(mtEmpresaCEDULA_JURIDICA.AsString) then
        lReparos.Add(SEmpresaFaltaCedula);

      if (mtEmpresaCORREO.AsString.Trim <> '') and
        not TValidacion.Correo(mtEmpresaCORREO.AsString) then
        lReparos.Add(SValCorreo);
    end;

    Result := lReparos.Count = 0;
    if Result then
      Exit;

    if lReparos.Count = 1 then
      lMensaje := lReparos[0]
    else
    begin
      lMensaje := SReparosEmpresa + sLineBreak;
      for I := 0 to lReparos.Count - 1 do
        lMensaje := lMensaje + sLineBreak + '   ' + #$2022 + '  ' + lReparos[I];
    end;
    MostrarError(lMensaje);
  finally
    lReparos.Free;
  end;
end;

procedure TfraConfiguracion.btnGuardarEmpresaClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtEmpresa);

  if not ValidarEmpresa then
    Exit;

  FPresentador.GuardarEmpresa(
    TMapeoDatos.ADto<TEmpresaDTO>(dmMemoria.mtEmpresa));
end;

procedure TfraConfiguracion.btnGuardarParametrosClick(Sender: TObject);
begin
  dmMemoria.Confirmar(dmMemoria.mtParametros);
  FPresentador.GuardarParametros(
    dmMemoria.mtParametrosDIAS_SIN_RESPUESTA.AsInteger,
    dmMemoria.mtParametrosMINUTOS_AVISOS.AsInteger);
end;

procedure TfraConfiguracion.MostrarCargando(const AActivo: Boolean);
begin
  CursorOcupado(AActivo);
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

procedure TfraConfiguracion.MostrarPermisosPropios(const ATexto: string);
begin
  lblPermisos.Caption := ATexto;
end;

procedure TfraConfiguracion.MostrarMinutosAvisos(const AMinutos: Integer);
begin
  dmMemoria.PrepararParametros(AMinutos);
end;

procedure TfraConfiguracion.MostrarSeccionEmpresa(const AVisible: Boolean);
begin
  tjEmpresa.Visible := AVisible;
  edDias.Visible := AVisible;
  lblNotaDias.Visible := AVisible;
  if not AVisible then
    tjParametros.Left := tjEmpresa.Left;
end;

procedure TfraConfiguracion.MostrarEmpresa(const AEmpresa: TEmpresaDTO);
begin
  TMapeoDatos.ATabla(AEmpresa, dmMemoria.mtEmpresa);
  dmMemoria.FijarDiasSinRespuesta(AEmpresa.DiasSinRespuesta);
end;

procedure TfraConfiguracion.EmpresaGuardada;
begin
  Informar(SEmpresaGuardada);
end;

procedure TfraConfiguracion.ParametrosGuardados;
begin
  Informar(SParametrosGuardados);
end;

procedure TfraConfiguracion.MostrarError(const AMensaje: string);
begin
  AvisarError(AMensaje);
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
  lblVerBase.Caption := AResultado.VersionBaseDatos;
end;

end.
