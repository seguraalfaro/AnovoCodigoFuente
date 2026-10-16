unit Anovo.Forms.Servidor;

// Ventana del servidor: estado, contadores, registro, actividad, errores,
// tunel de Cloudflare y configuracion del correo y del tunel en el .env.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXPanels, Vcl.Grids, Vcl.DBGrids,
  Data.DB, FireDAC.Comp.Client, rDBGrid,
  VclPlano.Pastilla, VclPlano.Tarjeta, VclPlano.Pestanas, VclPlano.BotonWin,
  MVCFramework.Server.Intf,
  Anovo.Tunel;

type
  TfrmServidor = class(TForm)
    pnlEncabezado: TPanel;
    lblTitulo: TLabel;
    fpEstados: TFlowPanel;
    pasServidor: TPlanoPastilla;
    pasTunel: TPlanoPastilla;
    pasCorreo: TPlanoPastilla;
    btnIniciar: TPlanoBotonWin;
    btnDetener: TPlanoBotonWin;
    gpContadores: TGridPanel;
    tjPeticiones: TPlanoTarjeta;
    lblPeticiones: TLabel;
    lblPeticionesNota: TLabel;
    tjErrores: TPlanoTarjeta;
    lblErrores: TLabel;
    lblErroresNota: TLabel;
    tjPermisos: TPlanoTarjeta;
    lblPermisos: TLabel;
    lblPermisosNota: TLabel;
    tjActivo: TPlanoTarjeta;
    lblActivo: TLabel;
    lblActivoNota: TLabel;
    pstSecciones: TPlanoPestanas;
    cpSecciones: TCardPanel;
    crdRegistro: TCard;
    memRegistro: TMemo;
    crdActividad: TCard;
    pstFiltro: TPlanoPestanas;
    grActividad: TrDBGrid;
    crdErrores: TCard;
    grErrores: TrDBGrid;
    crdTunel: TCard;
    pnlTunelBarra: TPanel;
    lblTunelRuta: TLabel;
    btnIniciarTunel: TPlanoBotonWin;
    btnDetenerTunel: TPlanoBotonWin;
    reTunel: TRichEdit;
    crdConfiguracion: TCard;
    sbConfiguracion: TScrollBox;
    tjServidor: TPlanoTarjeta;
    lblBase: TLabel;
    lblUsuarioBase: TLabel;
    lblPuerto: TLabel;
    lblVersion: TLabel;
    tjCorreo: TPlanoTarjeta;
    lblModoCorreo: TLabel;
    cbModoCorreo: TComboBox;
    lblProveedor: TLabel;
    cbProveedor: TComboBox;
    edCuenta: TLabeledEdit;
    edNombre: TLabeledEdit;
    edClave: TLabeledEdit;
    edClientId: TLabeledEdit;
    edClientSecret: TLabeledEdit;
    lblTokenCorreo: TLabel;
    btnAutorizarCorreo: TPlanoBotonWin;
    tjTunel: TPlanoTarjeta;
    edTunelExe: TLabeledEdit;
    edTunelConfig: TLabeledEdit;
    edTunelNombre: TLabeledEdit;
    chkTunelAutomatico: TCheckBox;
    lblNotaConfig: TLabel;
    btnGuardarConfig: TPlanoBotonWin;
    tmrRefresco: TTimer;
    tmrVigencias: TTimer;
    tmrTunel: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnIniciarClick(Sender: TObject);
    procedure btnDetenerClick(Sender: TObject);
    procedure tjPermisosClick(Sender: TObject);
    procedure btnAutorizarCorreoClick(Sender: TObject);
    procedure btnIniciarTunelClick(Sender: TObject);
    procedure btnDetenerTunelClick(Sender: TObject);
    procedure btnGuardarConfigClick(Sender: TObject);
    procedure cbModoCorreoChange(Sender: TObject);
    procedure ConfigCambiada(Sender: TObject);
    procedure pstFiltroChange(Sender: TObject);
    procedure tmrRefrescoTimer(Sender: TObject);
    procedure tmrVigenciasTimer(Sender: TObject);
    procedure tmrTunelTimer(Sender: TObject);
  private
    FServidor: IMVCServer;
    FDesde: TDateTime;
    FYaArranco: Boolean;
    FTunel: TTunel;
    FTunelDeseado: Boolean;
    FUltimaCuenta: Int64;
    FCargandoConfig: Boolean;
    FActividad: TFDMemTable;
    FErrores: TFDMemTable;
    procedure CrearTablas;
    function CrearTabla: TFDMemTable;
    procedure Enlazar(AGrid: TrDBGrid; ATabla: TFDMemTable);
    procedure MostrarEstado;
    procedure MostrarCorreo;
    procedure MostrarTunel;
    procedure MostrarServidor;
    procedure CargarConfiguracion;
    procedure MostrarCamposCorreo;
    function ValidarConfiguracion(out AMensaje: string): Boolean;
    procedure RelevarPrecios;
    procedure RefrescarContadores;
    procedure RefrescarListas;
    procedure AplicarFiltro;
    procedure IniciarTunel;
    procedure AgregarLineaTunel(const ALinea: string);
    procedure CambioTunel;
    function EstaEscuchando: Boolean;
  end;

var
  frmServidor: TfrmServidor;

implementation

{$R *.dfm}

uses
  System.DateUtils,
  System.Math,
  System.StrUtils,
  LoggerPro,
  LoggerPro.VCLMemoAppender,
  MVCFramework.Container,
  MVCFramework.Logger,
  MVCFramework.Commons,
  VclPlano.Paleta,
  Anovo.Bootstrap,
  Anovo.Servidor,
  Anovo.Middleware.Actividad,
  Anovo.Services.Vigencias,
  Anovo.Correo.Config,
  Anovo.Services.Correo.OAuth,
  Anovo.Services.Intf.Permisos,
  Anovo.Tunel.Config,
  Anovo.Env.Archivo,
  Anovo.UI.Rejilla;

const
  REFRESCO_MS = 1000;
  LINEAS_LOG = 500;
  LINEAS_TUNEL = 500;
  VIGENCIAS_MS = 60 * 60 * 1000;
  REINTENTO_TUNEL_MS = 10 * 1000;
  LARGO_CLAVE_APLICACION = 16;
  LARGO_HORA_ISO = 20;

  MODO_NINGUNO = 0;
  MODO_CLAVE = 1;
  MODO_OAUTH2 = 2;
  PROVEEDOR_GOOGLE = 0;
  PROVEEDOR_MICROSOFT = 1;
  PROVEEDOR_TEXTO: array [0 .. 1] of string = ('google', 'microsoft');

  FILTRO_TODAS = 0;
  FILTROS: array [1 .. 3] of string = ('ESTADO < 400',
    '(ESTADO >= 400) AND (ESTADO < 500)', 'ESTADO >= 500');

  CAMPO_HORA = 'HORA';
  CAMPO_USUARIO = 'USUARIO';
  CAMPO_VERBO = 'VERBO';
  CAMPO_RUTA = 'RUTA';
  CAMPO_ESTADO = 'ESTADO';
  CAMPO_MS = 'MS';

  COLOR_TUNEL_TEXTO = TColor($00DBD5D1);
  COLOR_TUNEL_OK = TColor($00AFEF86);
  COLOR_TUNEL_AVISO = TColor($004DD3FC);
  COLOR_TUNEL_ERROR = TColor($00A5A5FC);

  SClaveCorta = 'La contrase'#$00F1'a de aplicaci'#$00F3'n tiene 16 letras.';
  SFaltaCuenta = 'Falta la cuenta que env'#$00ED'a el correo.';
  SFaltaCliente = 'Faltan el Client ID y el Client secret de OAuth2.';
  SGuardarAntes = 'Hay cambios sin guardar en la configuraci'#$00F3'n. '#$00BF +
    'Guardarlos antes de autorizar?';
  SReiniciar = 'El servidor se reinicia para aplicar la configuraci'#$00F3'n.';

procedure TfrmServidor.FormCreate(Sender: TObject);
begin
  Caption := 'Servidor Anovo';
  Color := PaletaPlano.Background;
  FServidor := nil;
  FDesde := 0;
  FYaArranco := False;
  FTunelDeseado := False;
  FUltimaCuenta := -1;

  Boot(TVCLMemoLogAppender.Create(memRegistro, LINEAS_LOG) as ILogAppender,
    False);

  PrepararServicios;

  CrearTablas;
  FTunel := TTunel.Create(AgregarLineaTunel, CambioTunel);
  cpSecciones.ActiveCard := crdRegistro;

  MostrarServidor;
  CargarConfiguracion;
  MostrarCorreo;
  MostrarTunel;
  MostrarEstado;
  tmrRefresco.Interval := REFRESCO_MS;
  tmrRefresco.Enabled := True;
end;

procedure TfrmServidor.FormShow(Sender: TObject);
begin
  if FYaArranco then
    Exit;
  FYaArranco := True;
  btnIniciarClick(nil);
  if EstaEscuchando and TConfigTunel.Leer.Automatico and
    TConfigTunel.Leer.Configurado then
    IniciarTunel;
end;

procedure TfrmServidor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tmrRefresco.Enabled := False;
  tmrVigencias.Enabled := False;
  tmrTunel.Enabled := False;
  FTunelDeseado := False;
  FTunel.Detener;
  if EstaEscuchando then
  begin
    LogI('Cerrando el servidor desde la ventana.');
    FServidor.Stop;
    FServidor := nil;
  end;
end;

procedure TfrmServidor.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FTunel);
end;

function TfrmServidor.EstaEscuchando: Boolean;
begin
  Result := FServidor <> nil;
end;

function TfrmServidor.CrearTabla: TFDMemTable;
begin
  Result := TFDMemTable.Create(Self);
  Result.FieldDefs.Add(CAMPO_HORA, ftDateTime);
  Result.FieldDefs.Add(CAMPO_USUARIO, ftString, 20);
  Result.FieldDefs.Add(CAMPO_VERBO, ftString, 10);
  Result.FieldDefs.Add(CAMPO_RUTA, ftString, 500);
  Result.FieldDefs.Add(CAMPO_ESTADO, ftInteger);
  Result.FieldDefs.Add(CAMPO_MS, ftLargeint);
  Result.CreateDataSet;
  TDateTimeField(Result.FieldByName(CAMPO_HORA)).DisplayFormat := 'hh:nn:ss';
end;

procedure TfrmServidor.Enlazar(AGrid: TrDBGrid; ATabla: TFDMemTable);
var
  lFuente: TDataSource;
begin
  lFuente := TDataSource.Create(Self);
  lFuente.DataSet := ATabla;
  AGrid.DataSource := lFuente;
  TRejillaServidor.Aplicar(AGrid, CAMPO_ESTADO);
end;

procedure TfrmServidor.CrearTablas;
begin
  FActividad := CrearTabla;
  FErrores := CrearTabla;
  Enlazar(grActividad, FActividad);
  Enlazar(grErrores, FErrores);
end;

procedure TfrmServidor.MostrarServidor;
begin
  lblBase.Caption := 'Base:   ' + BaseConfigurada;
  lblUsuarioBase.Caption := 'Usuario:   ' + UsuarioDeBase;
  lblPuerto.Caption := 'Puerto:   ' + PuertoConfigurado.ToString + ' (HTTPS)';
  lblVersion.Caption := 'Framework:   DelphiMVCFramework ' +
    DMVCFRAMEWORK_VERSION;
end;

procedure TfrmServidor.MostrarEstado;
begin
  if EstaEscuchando then
  begin
    pasServidor.Caption := 'Escuchando en :' + PuertoConfigurado.ToString;
    pasServidor.Status := fsSuccess;
  end
  else
  begin
    pasServidor.Caption := 'Servidor detenido';
    pasServidor.Status := fsDanger;
  end;
  btnIniciar.Enabled := not EstaEscuchando;
  btnDetener.Enabled := EstaEscuchando;
end;

procedure TfrmServidor.MostrarCorreo;
var
  lConfig: TConfigCorreo;
begin
  lConfig := TConfigCorreo.Leer;
  case lConfig.Modo of
    mcClave:
      pasCorreo.Caption := 'Correo: contrase'#$00F1'a de aplicaci'#$00F3'n';
    mcOAuth2:
      pasCorreo.Caption := 'Correo: OAuth2';
  else
    pasCorreo.Caption := 'Correo sin configurar';
  end;
  if lConfig.Modo = mcNinguno then
    pasCorreo.Status := fsNeutral
  else if lConfig.Configurado then
    pasCorreo.Status := fsSuccess
  else
  begin
    pasCorreo.Caption := pasCorreo.Caption + ' (incompleto)';
    pasCorreo.Status := fsPending;
  end;

  btnAutorizarCorreo.Enabled := lConfig.Modo = mcOAuth2;
  if lConfig.Modo <> mcOAuth2 then
    lblTokenCorreo.Caption := ''
  else if FileExists(lConfig.ArchivoToken) then
    lblTokenCorreo.Caption := 'Token: autorizado'
  else
    lblTokenCorreo.Caption := 'Token: falta autorizar';
end;

procedure TfrmServidor.MostrarTunel;
var
  lConfig: TConfigTunel;
  lConexiones: Integer;
begin
  lConfig := TConfigTunel.Leer;
  lblTunelRuta.Caption := lConfig.Descripcion;
  lConexiones := FTunel.Conexiones;
  if not lConfig.Configurado and not FTunel.Corriendo then
  begin
    pasTunel.Caption := 'T'#$00FA'nel sin configurar';
    pasTunel.Status := fsNeutral;
    lblTunelRuta.Caption := 'No se encuentra cloudflared o su config.yml: ' +
      'revise la pesta'#$00F1'a Configuraci'#$00F3'n.';
  end
  else if FTunel.Corriendo and (lConexiones > 0) then
  begin
    pasTunel.Caption := 'T'#$00FA'nel conectado (' + lConexiones.ToString + ')';
    pasTunel.Status := fsSuccess;
  end
  else if FTunel.Corriendo then
  begin
    pasTunel.Caption := 'T'#$00FA'nel conectando';
    pasTunel.Status := fsPending;
  end
  else if FTunelDeseado then
  begin
    pasTunel.Caption := 'T'#$00FA'nel ca'#$00ED'do, reintentando';
    pasTunel.Status := fsDanger;
  end
  else
  begin
    pasTunel.Caption := 'T'#$00FA'nel detenido';
    pasTunel.Status := fsNeutral;
  end;
  btnIniciarTunel.Enabled := lConfig.Configurado and not FTunel.Corriendo;
  btnDetenerTunel.Enabled := FTunel.Corriendo or FTunelDeseado;
end;

procedure TfrmServidor.CargarConfiguracion;
var
  lCorreo: TConfigCorreo;
  lTunel: TConfigTunel;
begin
  FCargandoConfig := True;
  try
    lCorreo := TConfigCorreo.Leer;
    case lCorreo.Modo of
      mcClave:
        cbModoCorreo.ItemIndex := MODO_CLAVE;
      mcOAuth2:
        cbModoCorreo.ItemIndex := MODO_OAUTH2;
    else
      cbModoCorreo.ItemIndex := MODO_NINGUNO;
    end;
    if lCorreo.Proveedor = poMicrosoft then
      cbProveedor.ItemIndex := PROVEEDOR_MICROSOFT
    else
      cbProveedor.ItemIndex := PROVEEDOR_GOOGLE;
    edCuenta.Text := lCorreo.Cuenta;
    edNombre.Text := lCorreo.NombreRemitente;
    edClave.Text := lCorreo.Clave;
    edClientId.Text := lCorreo.ClientId;
    edClientSecret.Text := lCorreo.ClientSecret;

    lTunel := TConfigTunel.Leer;
    edTunelExe.Text := lTunel.Exe;
    edTunelConfig.Text := lTunel.ArchivoConfig;
    edTunelConfig.TextHint := TConfigTunel.ConfigPorDefecto;
    edTunelNombre.Text := lTunel.Nombre;
    chkTunelAutomatico.Checked := lTunel.Automatico;
  finally
    FCargandoConfig := False;
  end;
  MostrarCamposCorreo;
  btnGuardarConfig.Enabled := False;
end;

procedure TfrmServidor.MostrarCamposCorreo;
var
  lOAuth: Boolean;
begin
  lOAuth := cbModoCorreo.ItemIndex = MODO_OAUTH2;
  lblProveedor.Visible := lOAuth;
  cbProveedor.Visible := lOAuth;
  edClientId.Visible := lOAuth;
  edClientSecret.Visible := lOAuth;
  lblTokenCorreo.Visible := lOAuth;
  btnAutorizarCorreo.Visible := lOAuth;
  edClave.Visible := cbModoCorreo.ItemIndex = MODO_CLAVE;
  edCuenta.Enabled := cbModoCorreo.ItemIndex <> MODO_NINGUNO;
  edNombre.Enabled := edCuenta.Enabled;
end;

procedure TfrmServidor.cbModoCorreoChange(Sender: TObject);
begin
  MostrarCamposCorreo;
  ConfigCambiada(Sender);
end;

procedure TfrmServidor.ConfigCambiada(Sender: TObject);
begin
  if not FCargandoConfig then
    btnGuardarConfig.Enabled := True;
end;

function TfrmServidor.ValidarConfiguracion(out AMensaje: string): Boolean;
begin
  AMensaje := '';
  if (cbModoCorreo.ItemIndex <> MODO_NINGUNO) and (Trim(edCuenta.Text) = '')
  then
    AMensaje := SFaltaCuenta
  else if (cbModoCorreo.ItemIndex = MODO_CLAVE) and
    (StringReplace(edClave.Text, ' ', '', [rfReplaceAll]).Length <>
    LARGO_CLAVE_APLICACION) then
    AMensaje := SClaveCorta
  else if (cbModoCorreo.ItemIndex = MODO_OAUTH2) and
    ((Trim(edClientId.Text) = '') or (Trim(edClientSecret.Text) = '')) then
    AMensaje := SFaltaCliente;
  Result := AMensaje = '';
end;

procedure TfrmServidor.btnGuardarConfigClick(Sender: TObject);
var
  lMensaje, lModo: string;
  lServidor, lTunel: Boolean;
begin
  if not ValidarConfiguracion(lMensaje) then
  begin
    MessageDlg(lMensaje, mtWarning, [mbOK], 0);
    Exit;
  end;

  case cbModoCorreo.ItemIndex of
    MODO_CLAVE:
      lModo := MODO_CORREO_CLAVE;
    MODO_OAUTH2:
      lModo := MODO_CORREO_OAUTH2;
  else
    lModo := '';
  end;

  lServidor := EstaEscuchando;
  lTunel := FTunelDeseado;
  if lServidor then
  begin
    LogI(SReiniciar);
    btnDetenerClick(nil);
  end;
  if lTunel then
    btnDetenerTunelClick(nil);

  TArchivoEnv.Guardar([
    ValorEnv('anovo.correo.modo', lModo),
    ValorEnv('anovo.correo.oauth.proveedor',
      PROVEEDOR_TEXTO[Max(cbProveedor.ItemIndex, PROVEEDOR_GOOGLE)]),
    ValorEnv('anovo.correo.cuenta', edCuenta.Text),
    ValorEnv('anovo.correo.nombre', edNombre.Text),
    ValorEnv('anovo.correo.clave', edClave.Text),
    ValorEnv('anovo.correo.oauth.client_id', edClientId.Text),
    ValorEnv('anovo.correo.oauth.client_secret', edClientSecret.Text),
    ValorEnv(CLAVE_TUNEL_EXE, edTunelExe.Text),
    ValorEnv(CLAVE_TUNEL_CONFIG, edTunelConfig.Text),
    ValorEnv(CLAVE_TUNEL_NOMBRE, edTunelNombre.Text),
    ValorEnv(CLAVE_TUNEL_AUTOMATICO, IfThen(chkTunelAutomatico.Checked,
      'true', 'false'))]);
  LogI('Configuraci'#$00F3'n del correo y del t'#$00FA'nel guardada en ' +
    TArchivoEnv.Ruta);

  CargarConfiguracion;
  MostrarCorreo;
  if lServidor then
    btnIniciarClick(nil);
  if lTunel and TConfigTunel.Leer.Configurado then
    IniciarTunel;
  MostrarTunel;
end;

procedure TfrmServidor.btnAutorizarCorreoClick(Sender: TObject);
var
  lMensaje: string;
begin
  if btnGuardarConfig.Enabled then
  begin
    if MessageDlg(SGuardarAntes, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;
    btnGuardarConfigClick(nil);
    if btnGuardarConfig.Enabled then
      Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    if TAutorizacionCorreo.Autorizar(TConfigCorreo.Leer, lMensaje) then
    begin
      LogI(lMensaje);
      MessageDlg(lMensaje, mtInformation, [mbOK], 0);
    end
    else
    begin
      LogW(lMensaje);
      MessageDlg(lMensaje, mtWarning, [mbOK], 0);
    end;
  finally
    Screen.Cursor := crDefault;
    MostrarCorreo;
  end;
end;

procedure TfrmServidor.btnIniciarClick(Sender: TObject);
begin
  if EstaEscuchando then
    Exit;

  Screen.Cursor := crAppStart;
  try
    try
      FServidor := CrearServidor;

      RelevarPrecios;

      FServidor.Listen(PuertoConfigurado);
      tmrVigencias.Interval := VIGENCIAS_MS;
      tmrVigencias.Enabled := True;
      FDesde := Now;
      TActividad.Limpiar;
      FUltimaCuenta := -1;
      LogI('Servidor levantado desde la ventana en el puerto ' +
        PuertoConfigurado.ToString);
    except
      on E: Exception do
      begin
        FServidor := nil;
        LogE('No se pudo levantar: ' + E.ClassName + ': ' + E.Message);
        MessageDlg('No se pudo levantar el servidor.' + sLineBreak +
          sLineBreak + E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    MostrarEstado;
  end;
end;

procedure TfrmServidor.btnDetenerClick(Sender: TObject);
begin
  if not EstaEscuchando then
    Exit;

  tmrVigencias.Enabled := False;
  FServidor.Stop;
  FServidor := nil;
  FDesde := 0;
  LogI('Servidor detenido desde la ventana.');
  MostrarEstado;
end;

procedure TfrmServidor.tjPermisosClick(Sender: TObject);
var
  lCache: IPermisoCache;
begin
  lCache := NewServiceContainerResolver.Resolve(TypeInfo(IPermisoCache))
    as IPermisoCache;
  lCache.Invalidar;
  LogI('Cache de permisos invalidada desde la ventana.');
  RefrescarContadores;
end;

procedure TfrmServidor.RelevarPrecios;
begin
  try
    AplicarVigencias;
  except
    on E: Exception do
      LogE('No se pudieron relevar los precios programados: ' + E.ClassName +
        ': ' + E.Message);
  end;
end;

procedure TfrmServidor.tmrVigenciasTimer(Sender: TObject);
begin
  RelevarPrecios;
end;

procedure TfrmServidor.tmrRefrescoTimer(Sender: TObject);
begin
  RefrescarContadores;
  RefrescarListas;
end;

procedure TfrmServidor.RefrescarContadores;
var
  lCache: IPermisoCache;
  lFila: TRegistroActividad;
  lRecientes: Integer;
begin
  lblPeticiones.Caption := FormatFloat('#,##0', TActividad.Servidas);
  if FDesde > 0 then
    lblPeticionesNota.Caption := 'desde las ' + FormatDateTime('hh:nn', FDesde)
  else
    lblPeticionesNota.Caption := 'servidor detenido';

  lblErrores.Caption := FormatFloat('#,##0', TActividad.Errores);
  if TActividad.Errores > 0 then
    lblErrores.Font.Color := PaletaPlano.Kind[fkDanger]
  else
    lblErrores.Font.Color := PaletaPlano.Text;
  lRecientes := 0;
  for lFila in TActividad.Ultimas do
    if (lFila.Estado >= 400) and (MinutesBetween(Now, lFila.Hora) < 60) then
      Inc(lRecientes);
  lblErroresNota.Caption := lRecientes.ToString + ' en la '#$00FA'ltima hora';

  if FDesde > 0 then
  begin
    lblActivo.Caption := FormatDateTime('hh:nn', FDesde);
    lblActivoNota.Caption := MinutesBetween(Now, FDesde).ToString + ' min';
  end
  else
  begin
    lblActivo.Caption := #$2014;
    lblActivoNota.Caption := 'servidor detenido';
  end;

  try
    lCache := NewServiceContainerResolver.Resolve(TypeInfo(IPermisoCache))
      as IPermisoCache;
    if lCache.Cargada then
      lblPermisos.Caption := 'En cach'#$00E9
    else
      lblPermisos.Caption := 'Sin cargar';
  except
    lblPermisos.Caption := 'Sin cargar';
  end;
end;

procedure TfrmServidor.RefrescarListas;
var
  lFilas: TArray<TRegistroActividad>;
  lFila: TRegistroActividad;
  lCuenta: Int64;

  procedure Agregar(const ATabla: TFDMemTable; const AFila: TRegistroActividad);
  begin
    ATabla.Append;
    ATabla.FieldByName(CAMPO_HORA).AsDateTime := AFila.Hora;
    if AFila.UsuarioId = 0 then
      ATabla.FieldByName(CAMPO_USUARIO).AsString := '-'
    else
      ATabla.FieldByName(CAMPO_USUARIO).AsString := AFila.UsuarioId.ToString;
    ATabla.FieldByName(CAMPO_VERBO).AsString := AFila.Verbo;
    ATabla.FieldByName(CAMPO_RUTA).AsString := AFila.Ruta;
    ATabla.FieldByName(CAMPO_ESTADO).AsInteger := AFila.Estado;
    ATabla.FieldByName(CAMPO_MS).AsLargeInt := AFila.Milisegundos;
    ATabla.Post;
  end;

begin
  lCuenta := TActividad.Servidas;
  if lCuenta = FUltimaCuenta then
    Exit;
  FUltimaCuenta := lCuenta;

  lFilas := TActividad.Ultimas;
  FActividad.DisableControls;
  FErrores.DisableControls;
  try
    FActividad.EmptyDataSet;
    FErrores.EmptyDataSet;
    for lFila in lFilas do
    begin
      Agregar(FActividad, lFila);
      if lFila.Estado >= 400 then
        Agregar(FErrores, lFila);
    end;
    FActividad.First;
    FErrores.First;
  finally
    FActividad.EnableControls;
    FErrores.EnableControls;
  end;
end;

procedure TfrmServidor.AplicarFiltro;
begin
  if FActividad = nil then
    Exit;
  if pstFiltro.ItemIndex <= FILTRO_TODAS then
  begin
    FActividad.Filtered := False;
    FActividad.Filter := '';
  end
  else
  begin
    FActividad.Filter := FILTROS[pstFiltro.ItemIndex];
    FActividad.Filtered := True;
  end;
end;

procedure TfrmServidor.pstFiltroChange(Sender: TObject);
begin
  AplicarFiltro;
end;

procedure TfrmServidor.IniciarTunel;
begin
  FTunelDeseado := True;
  tmrTunel.Enabled := False;
  try
    FTunel.Iniciar(TConfigTunel.Leer);
    LogI('T'#$00FA'nel de Cloudflare iniciado desde la ventana.');
  except
    on E: Exception do
    begin
      LogE('No se pudo iniciar el t'#$00FA'nel: ' + E.Message);
      AgregarLineaTunel('ERR ' + E.Message);
      tmrTunel.Interval := REINTENTO_TUNEL_MS;
      tmrTunel.Enabled := True;
    end;
  end;
  MostrarTunel;
end;

procedure TfrmServidor.btnIniciarTunelClick(Sender: TObject);
begin
  IniciarTunel;
end;

procedure TfrmServidor.btnDetenerTunelClick(Sender: TObject);
begin
  FTunelDeseado := False;
  tmrTunel.Enabled := False;
  FTunel.Detener;
  LogI('T'#$00FA'nel de Cloudflare detenido desde la ventana.');
  MostrarTunel;
end;

procedure TfrmServidor.tmrTunelTimer(Sender: TObject);
begin
  tmrTunel.Enabled := False;
  if FTunelDeseado and not FTunel.Corriendo then
    IniciarTunel;
end;

procedure TfrmServidor.CambioTunel;
begin
  if FTunelDeseado and not FTunel.Corriendo and not tmrTunel.Enabled then
  begin
    AgregarLineaTunel('WRN cloudflared termin'#$00F3'; se reintenta en ' +
      (REINTENTO_TUNEL_MS div 1000).ToString + ' s');
    tmrTunel.Interval := REINTENTO_TUNEL_MS;
    tmrTunel.Enabled := True;
  end;
  MostrarTunel;
end;

procedure TfrmServidor.AgregarLineaTunel(const ALinea: string);
var
  lLinea: string;
  lHora: TDateTime;
begin
  lLinea := ALinea;
  if (Length(lLinea) > LARGO_HORA_ISO) and
    TryISO8601ToDate(Copy(lLinea, 1, LARGO_HORA_ISO), lHora, False) then
    lLinea := FormatDateTime('hh:nn:ss', lHora) + '  ' +
      Copy(lLinea, LARGO_HORA_ISO + 2, MaxInt)
  else
    lLinea := FormatDateTime('hh:nn:ss', Now) + '  ' + lLinea;

  reTunel.Lines.BeginUpdate;
  try
    while reTunel.Lines.Count >= LINEAS_TUNEL do
      reTunel.Lines.Delete(0);
    reTunel.SelStart := reTunel.GetTextLen;
    reTunel.SelLength := 0;
    if ContainsText(lLinea, ' ERR ') then
      reTunel.SelAttributes.Color := COLOR_TUNEL_ERROR
    else if ContainsText(lLinea, ' WRN ') then
      reTunel.SelAttributes.Color := COLOR_TUNEL_AVISO
    else if ContainsText(lLinea, 'Registered tunnel connection') and
      not ContainsText(lLinea, 'Unregistered') then
      reTunel.SelAttributes.Color := COLOR_TUNEL_OK
    else
      reTunel.SelAttributes.Color := COLOR_TUNEL_TEXTO;
    reTunel.SelText := lLinea + sLineBreak;
  finally
    reTunel.Lines.EndUpdate;
  end;
  reTunel.Perform(EM_SCROLLCARET, 0, 0);
end;

end.
