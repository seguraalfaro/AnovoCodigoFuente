unit Anovo.Services.Correo.OAuth;

// Token de acceso OAuth2 del correo. ICS no es seguro fuera del hilo que lo
// crea, asi que la renovacion corre en el hilo principal de la ventana.

interface

uses
  System.SyncObjs,
  Anovo.Correo.Config;

type
  TAutorizacionCorreo = class
  private
    class var FBloqueo: TCriticalSection;
    class var FToken: string;
    class var FExpira: TDateTime;
    class procedure Renovar(const AConfig: TConfigCorreo);
  public
    class constructor Create;
    class destructor Destroy;
    class function Autorizar(const AConfig: TConfigCorreo;
      out AMensaje: string): Boolean;
    class procedure TokenVigente(const AConfig: TConfigCorreo;
      out AToken: string; out AExpira: TDateTime);
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  OverbyteIcsSslHttpOAuth,
  Anovo.Correo.Token,
  Anovo.Errors,
  Anovo.Textos;

const
  MINUTOS_MARGEN = 5;
  SEGUNDOS_INICIO_SESION = 180;

function NuevoCliente(const AConfig: TConfigCorreo): TIcsRestEmail;
begin
  Result := TIcsRestEmail.Create(nil);
  if AConfig.Proveedor = poMicrosoft then
    Result.RestEmailType := RestEmailMSSmtp
  else
    Result.RestEmailType := RestEmailGoogle;
  Result.ClientId := AConfig.ClientId;
  Result.ClientSecret := AConfig.ClientSecret;
  Result.AccountHint := AConfig.Cuenta;
  Result.OAAuthType := OAuthTypeWeb;
  Result.LoginTimeout := SEGUNDOS_INICIO_SESION;
end;

class constructor TAutorizacionCorreo.Create;
begin
  FBloqueo := TCriticalSection.Create;
end;

class destructor TAutorizacionCorreo.Destroy;
begin
  FBloqueo.Free;
end;

class procedure TAutorizacionCorreo.Renovar(const AConfig: TConfigCorreo);
var
  lCliente: TIcsRestEmail;
  lRefresco: string;
begin
  FToken := '';
  lRefresco := TTokenCorreo.Leer(AConfig.ArchivoToken);
  if lRefresco.IsEmpty then
    Exit;
  lCliente := NuevoCliente(AConfig);
  try
    lCliente.RefrToken := lRefresco;
    if not lCliente.GetNewToken(False) then
      Exit;
    FToken := lCliente.AccToken;
    FExpira := lCliente.AccExpireDT;
    if (not lCliente.RefrToken.IsEmpty) and (lCliente.RefrToken <> lRefresco) then
      TTokenCorreo.Guardar(AConfig.ArchivoToken, lCliente.RefrToken);
  finally
    lCliente.Free;
  end;
end;

class procedure TAutorizacionCorreo.TokenVigente(const AConfig: TConfigCorreo;
  out AToken: string; out AExpira: TDateTime);
begin
  FBloqueo.Enter;
  try
    if FToken.IsEmpty or (IncMinute(Now, MINUTOS_MARGEN) >= FExpira) then
    begin
      if TThread.CurrentThread.ThreadID = MainThreadID then
        Renovar(AConfig)
      else
        TThread.Synchronize(nil,
          procedure
          begin
            Renovar(AConfig);
          end);
    end;
    if FToken.IsEmpty then
      raise EServicioExterno.Create('CORREO_SIN_AUTORIZACION',
        SCorreoSinAutorizacion);
    AToken := FToken;
    AExpira := FExpira;
  finally
    FBloqueo.Leave;
  end;
end;

class function TAutorizacionCorreo.Autorizar(const AConfig: TConfigCorreo;
  out AMensaje: string): Boolean;
var
  lCliente: TIcsRestEmail;
begin
  Result := False;
  if AConfig.ClientId.IsEmpty or AConfig.Cuenta.IsEmpty then
  begin
    AMensaje := SCorreoFaltaClienteOAuth;
    Exit;
  end;
  lCliente := NuevoCliente(AConfig);
  try
    lCliente.ForceLogin := True;
    if not lCliente.GetNewToken(True) then
    begin
      AMensaje := Format(SCorreoAutorizacionFallida, [lCliente.LastError]);
      Exit;
    end;
    if (not lCliente.NewAccEmail.IsEmpty) and
      not SameText(lCliente.NewAccEmail, AConfig.Cuenta) then
    begin
      AMensaje := Format(SCorreoCuentaDistinta,
        [AConfig.Cuenta, lCliente.NewAccEmail]);
      Exit;
    end;
    if lCliente.RefrToken.IsEmpty then
    begin
      AMensaje := Format(SCorreoAutorizacionFallida, [lCliente.LastError]);
      Exit;
    end;
    TTokenCorreo.Guardar(AConfig.ArchivoToken, lCliente.RefrToken);
    AMensaje := Format(SCorreoAutorizado, [AConfig.Cuenta]);
    Result := True;
  finally
    lCliente.Free;
  end;
end;

end.
