unit Anovo.Auth.Intentos;

// Intentos fallidos de ingreso por cuenta y por IP: pasado el maximo dentro de
// la ventana, se bloquea un rato. Vive en memoria y se reinicia con el servidor.

interface

type
  TIntentosIngreso = class
  public
    class constructor Create;
    class destructor Destroy;
    class function Bloqueado(const ACorreo, AIp: string;
      out AMinutos: Integer): Boolean;
    class function RegistrarFallo(const ACorreo, AIp: string): Boolean;
    class procedure RegistrarExito(const ACorreo: string);
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  System.DateUtils,
  System.SyncObjs,
  System.Generics.Collections,
  MVCFramework.Commons;

type
  TRegistroIntentos = record
    Fallos: Integer;
    Desde: TDateTime;
    BloqueadoHasta: TDateTime;
  end;

var
  gBloqueo: TCriticalSection;
  gRegistros: TDictionary<string, TRegistroIntentos>;

const
  PREFIJO_CUENTA = 'c:';
  PREFIJO_IP = 'i:';
  MAXIMO_REGISTROS = 5000;

function MaximoCuenta: Integer;
begin
  Result := dotEnv.Env('anovo.ingreso.max_fallos_cuenta', 5);
end;

function MaximoIp: Integer;
begin
  Result := dotEnv.Env('anovo.ingreso.max_fallos_ip', 20);
end;

function MinutosVentana: Integer;
begin
  Result := dotEnv.Env('anovo.ingreso.ventana_minutos', 15);
end;

function MinutosBloqueo: Integer;
begin
  Result := dotEnv.Env('anovo.ingreso.bloqueo_minutos', 15);
end;

function LlaveCuenta(const ACorreo: string): string;
begin
  Result := PREFIJO_CUENTA + ACorreo.Trim.ToLower;
end;

function LlaveIp(const AIp: string): string;
begin
  Result := PREFIJO_IP + AIp;
end;

procedure Depurar;
var
  lVencidas: TList<string>;
  lPar: TPair<string, TRegistroIntentos>;
  lLlave: string;
  lLimite: TDateTime;
begin
  if gRegistros.Count < MAXIMO_REGISTROS then
    Exit;
  lLimite := IncMinute(Now, -MinutosVentana);
  lVencidas := TList<string>.Create;
  try
    for lPar in gRegistros do
      if (lPar.Value.Desde < lLimite) and (lPar.Value.BloqueadoHasta < Now) then
        lVencidas.Add(lPar.Key);
    for lLlave in lVencidas do
      gRegistros.Remove(lLlave);
  finally
    lVencidas.Free;
  end;
end;

function MinutosRestantes(const ALlave: string): Integer;
var
  lRegistro: TRegistroIntentos;
begin
  Result := 0;
  if gRegistros.TryGetValue(ALlave, lRegistro) and
    (lRegistro.BloqueadoHasta > Now) then
    Result := MinutesBetween(lRegistro.BloqueadoHasta, Now) + 1;
end;

function Sumar(const ALlave: string; const AMaximo: Integer): Boolean;
var
  lRegistro: TRegistroIntentos;
begin
  if not gRegistros.TryGetValue(ALlave, lRegistro) or
    (lRegistro.Desde < IncMinute(Now, -MinutosVentana)) then
  begin
    lRegistro.Fallos := 0;
    lRegistro.Desde := Now;
    lRegistro.BloqueadoHasta := 0;
  end;
  Inc(lRegistro.Fallos);
  Result := lRegistro.Fallos >= AMaximo;
  if Result then
  begin
    lRegistro.BloqueadoHasta := IncMinute(Now, MinutosBloqueo);
    lRegistro.Fallos := 0;
    lRegistro.Desde := Now;
  end;
  gRegistros.AddOrSetValue(ALlave, lRegistro);
end;

class constructor TIntentosIngreso.Create;
begin
  gBloqueo := TCriticalSection.Create;
  gRegistros := TDictionary<string, TRegistroIntentos>.Create;
end;

class destructor TIntentosIngreso.Destroy;
begin
  gRegistros.Free;
  gBloqueo.Free;
end;

class function TIntentosIngreso.Bloqueado(const ACorreo, AIp: string;
  out AMinutos: Integer): Boolean;
begin
  gBloqueo.Enter;
  try
    AMinutos := Max(MinutosRestantes(LlaveCuenta(ACorreo)),
      MinutosRestantes(LlaveIp(AIp)));
    Result := AMinutos > 0;
  finally
    gBloqueo.Leave;
  end;
end;

class function TIntentosIngreso.RegistrarFallo(const ACorreo,
  AIp: string): Boolean;
var
  lCuenta, lIp: Boolean;
begin
  gBloqueo.Enter;
  try
    Depurar;
    lCuenta := Sumar(LlaveCuenta(ACorreo), MaximoCuenta);
    lIp := Sumar(LlaveIp(AIp), MaximoIp);
    Result := lCuenta or lIp;
  finally
    gBloqueo.Leave;
  end;
end;

class procedure TIntentosIngreso.RegistrarExito(const ACorreo: string);
begin
  gBloqueo.Enter;
  try
    gRegistros.Remove(LlaveCuenta(ACorreo));
  finally
    gBloqueo.Leave;
  end;
end;

end.
