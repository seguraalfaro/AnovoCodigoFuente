unit Anovo.Services.Correo;

// Envio de correo por SMTP con ICS sobre TLS: contrasena de aplicacion u
// OAuth2 (XOAUTH2) segun el .env. Valida y reintenta una vez si falla.

interface

uses
  MVCFramework,
  Anovo.Correo.Config,
  Anovo.DTOs.Correo,
  Anovo.Services.Intf.Correo;

type
  TCorreoService = class(TInterfacedObject, ICorreoService)
  private
    procedure Validar(const AMensaje: TMensajeCorreo);
    function Intentar(const AConfig: TConfigCorreo;
      const AMensaje: TMensajeCorreo; const ARutaAdjunto: string;
      out ACodigo: Integer; out ARespuesta: string): Boolean;
    procedure Fallo(const AConfig: TConfigCorreo; const ACodigo: Integer;
      const ARespuesta: string);
  public
    [MVCInject]
    constructor Create; reintroduce;
    function Estado: TEstadoCorreoDTO;
    function Remitente: string;
    function Modo: string;
    procedure Enviar(const AMensaje: TMensajeCorreo);
  end;

const
  MAXIMO_DESTINATARIOS = 10;
  MAXIMO_ADJUNTO = 3 * 1024 * 1024;
  LARGO_ASUNTO = 200;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  MVCFramework.Logger,
  OverbyteIcsTypes,
  OverbyteIcsSslBase,
  OverbyteIcsSmtpProt,
  Anovo.Errors,
  Anovo.Services.Correo.OAuth,
  Anovo.Textos;

const
  INTENTOS = 2;
  ESPERA_REINTENTO_MS = 2000;
  CODIGO_TIEMPO_AGOTADO = 426;
  CODIGO_AUTENTICACION_MIN = 530;
  CODIGO_AUTENTICACION_MAX = 535;
  CODIGO_BUZON = 550;
  CODIGO_DESTINATARIO = 553;
  NOMBRE_EQUIPO = 'anovo-cotizaciones';
  CARACTERES_ADJUNTO = ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '-', '_', '.'];

function CorreoValido(const ACorreo: string): Boolean;
var
  lArroba: Integer;
begin
  lArroba := ACorreo.IndexOf('@');
  Result := (lArroba > 0) and (ACorreo.IndexOf('.', lArroba) > lArroba + 1) and
    not ACorreo.EndsWith('.') and not ACorreo.Contains(' ') and
    (ACorreo.CountChar('@') = 1);
end;

function TieneSaltos(const ATexto: string): Boolean;
begin
  Result := ATexto.Contains(#13) or ATexto.Contains(#10);
end;

function NombreSeguro(const ANombre: string): string;
var
  lCaracter: Char;
begin
  Result := '';
  for lCaracter in ANombre do
    if CharInSet(lCaracter, CARACTERES_ADJUNTO) then
      Result := Result + lCaracter;
  if Result.IsEmpty or not Result.ToLower.EndsWith('.pdf') then
    Result := Result + '.pdf';
end;

function DireccionRemitente(const AConfig: TConfigCorreo): string;
begin
  if AConfig.NombreRemitente.IsEmpty then
    Result := AConfig.Cuenta
  else
    Result := Format('"%s" <%s>', [AConfig.NombreRemitente.Replace('"', ''),
      AConfig.Cuenta]);
end;

constructor TCorreoService.Create;
begin
  inherited Create;
end;

function TCorreoService.Estado: TEstadoCorreoDTO;
var
  lConfig: TConfigCorreo;
begin
  lConfig := TConfigCorreo.Leer;
  Result := TEstadoCorreoDTO.Create;
  Result.Configurado := lConfig.Configurado;
  Result.Modo := lConfig.CodigoModo;
  if Result.Configurado then
    Result.Remitente := lConfig.Cuenta;
end;

function TCorreoService.Remitente: string;
begin
  Result := TConfigCorreo.Leer.Cuenta;
end;

function TCorreoService.Modo: string;
begin
  Result := TConfigCorreo.Leer.CodigoModo;
end;

procedure TCorreoService.Validar(const AMensaje: TMensajeCorreo);
var
  lCorreo: string;
begin
  if Length(AMensaje.Para) = 0 then
    raise EDatoInvalido.Create(SCorreoFaltaDestinatario);
  if Length(AMensaje.Para) + Length(AMensaje.Copia) > MAXIMO_DESTINATARIOS then
    raise EDatoInvalido.Create(Format(SCorreoDemasiadosDestinatarios,
      [MAXIMO_DESTINATARIOS]));
  for lCorreo in AMensaje.Para + AMensaje.Copia do
    if TieneSaltos(lCorreo) or not CorreoValido(lCorreo) then
      raise EDatoInvalido.Create(Format(SCorreoDestinatarioInvalido, [lCorreo]));
  if AMensaje.Asunto.Trim.IsEmpty then
    raise EDatoInvalido.Create(SCorreoFaltaAsunto);
  if TieneSaltos(AMensaje.Asunto) or (AMensaje.Asunto.Length > LARGO_ASUNTO) then
    raise EDatoInvalido.Create(Format(SCorreoAsuntoInvalido, [LARGO_ASUNTO]));
  if Length(AMensaje.Adjunto) > MAXIMO_ADJUNTO then
    raise EDatoInvalido.Create(Format(SCorreoAdjuntoGrande,
      [MAXIMO_ADJUNTO div (1024 * 1024)]));
end;

function TCorreoService.Intentar(const AConfig: TConfigCorreo;
  const AMensaje: TMensajeCorreo; const ARutaAdjunto: string;
  out ACodigo: Integer; out ARespuesta: string): Boolean;
var
  lSmtp: TSslHtmlSmtpCli;
  lContexto: TSslContext;
  lCorreo, lToken: string;
  lExpira: TDateTime;
begin
  ACodigo := 0;
  ARespuesta := '';
  lContexto := TSslContext.Create(nil);
  lSmtp := TSslHtmlSmtpCli.Create(nil);
  try
    lSmtp.MultiThreaded := True;
    lContexto.SslVerifyPeer := True;
    lContexto.UseSharedCAStore := True;
    lSmtp.SslContext := lContexto;
    lSmtp.SslCertVerMethod := CertVerBundle;
    if AConfig.Implicito then
      lSmtp.SslType := smtpTlsImplicit
    else
      lSmtp.SslType := smtpTlsExplicit;
    lSmtp.Host := AConfig.Servidor;
    lSmtp.Port := AConfig.Puerto;
    lSmtp.Timeout := AConfig.TimeoutSegundos;
    lSmtp.SignOn := NOMBRE_EQUIPO;
    lSmtp.Username := AConfig.Cuenta;

    if AConfig.Modo = mcOAuth2 then
    begin
      TAutorizacionCorreo.TokenVigente(AConfig, lToken, lExpira);
      lSmtp.AuthType := smtpAuthXOAuth2;
      lSmtp.OAuthToken := lToken;
      lSmtp.TokenExpireDT := lExpira;
    end
    else
    begin
      lSmtp.AuthType := smtpAuthLogin;
      lSmtp.Password := AConfig.Clave;
    end;

    lSmtp.CharSet := 'utf-8';
    lSmtp.ConvertToCharset := True;
    lSmtp.FromName := DireccionRemitente(AConfig);
    lSmtp.HdrFrom := DireccionRemitente(AConfig);
    lSmtp.HdrTo := string.Join(', ', AMensaje.Para);
    lSmtp.HdrCc := string.Join(', ', AMensaje.Copia);
    lSmtp.HdrSubject := AMensaje.Asunto.Trim;
    lSmtp.RcptName.Clear;
    for lCorreo in AMensaje.Para + AMensaje.Copia do
      lSmtp.RcptName.Add(lCorreo);
    lSmtp.ContentType := smtpPlainText;
    lSmtp.PlainText.Text := AMensaje.Texto;
    lSmtp.EmailFiles.Clear;
    if not ARutaAdjunto.IsEmpty then
      lSmtp.EmailFiles.Add(ARutaAdjunto);

    Result := lSmtp.OpenSync and lSmtp.MailSync;
    ARespuesta := lSmtp.ErrorMessage;
    if ARespuesta.IsEmpty then
      ARespuesta := lSmtp.LastResponse;
    ACodigo := StrToIntDef(Copy(ARespuesta.Trim, 1, 3), 0);
    if Result then
      lSmtp.QuitSync
    else
      lSmtp.Abort;
  finally
    lSmtp.Free;
    lContexto.Free;
  end;
end;

procedure TCorreoService.Fallo(const AConfig: TConfigCorreo;
  const ACodigo: Integer; const ARespuesta: string);
begin
  LogE(Format('Correo no enviado por %s:%s (%d) %s',
    [AConfig.Servidor, AConfig.Puerto, ACodigo, ARespuesta]));
  if (ACodigo >= CODIGO_AUTENTICACION_MIN) and
    (ACodigo <= CODIGO_AUTENTICACION_MAX) then
  begin
    if AConfig.Modo = mcOAuth2 then
      raise EServicioExterno.Create('CORREO_RECHAZADO', SCorreoOAuthRechazado)
    else
      raise EServicioExterno.Create('CORREO_RECHAZADO', SCorreoClaveRechazada);
  end;
  if (ACodigo = CODIGO_BUZON) or (ACodigo = CODIGO_DESTINATARIO) then
    raise EDatoInvalido.Create(SCorreoDestinatarioRechazado);
  if (ACodigo = 0) or (ACodigo = CODIGO_TIEMPO_AGOTADO) then
    raise EServicioExterno.Create('CORREO_SIN_CONEXION', SCorreoSinConexion);
  raise EServicioExterno.Create('CORREO_FALLIDO',
    Format(SCorreoFallido, [ACodigo]));
end;

procedure TCorreoService.Enviar(const AMensaje: TMensajeCorreo);
var
  lConfig: TConfigCorreo;
  lCarpeta, lRuta, lRespuesta: string;
  lCodigo, lIntento: Integer;
begin
  lConfig := TConfigCorreo.Leer;
  if not lConfig.Configurado then
    raise EConflictoDeEstado.Create('CORREO_NO_CONFIGURADO',
      SCorreoNoConfigurado);
  Validar(AMensaje);

  lCarpeta := TPath.Combine(TPath.GetTempPath,
    'AnovoCorreo-' + TGUID.NewGuid.ToString);
  ForceDirectories(lCarpeta);
  try
    lRuta := '';
    if Length(AMensaje.Adjunto) > 0 then
    begin
      lRuta := TPath.Combine(lCarpeta, NombreSeguro(AMensaje.NombreAdjunto));
      TFile.WriteAllBytes(lRuta, AMensaje.Adjunto);
    end;

    for lIntento := 1 to INTENTOS do
    begin
      if Intentar(lConfig, AMensaje, lRuta, lCodigo, lRespuesta) then
        Exit;
      if (lCodigo >= CODIGO_AUTENTICACION_MIN) and
        (lCodigo <= CODIGO_AUTENTICACION_MAX) then
        Break;
      if (lCodigo >= 500) and (lCodigo <> CODIGO_TIEMPO_AGOTADO) then
        Break;
      if lIntento < INTENTOS then
        Sleep(ESPERA_REINTENTO_MS);
    end;
    Fallo(lConfig, lCodigo, lRespuesta);
  finally
    TDirectory.Delete(lCarpeta, True);
  end;
end;

end.
