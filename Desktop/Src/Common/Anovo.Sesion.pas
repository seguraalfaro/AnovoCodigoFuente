unit Anovo.Sesion;

// Sesion del usuario en memoria: token, rol, nombre y permisos.
// Solo decide que se muestra; los permisos los aplica el servidor.
// Los hilos de trabajo leen el token bajo candado; vencer solo marca
// y el cierre lo hace el hilo principal una sola vez.

interface

uses
  System.SysUtils;

type
  TRolUsuario = (rolNinguno, rolAsesor, rolAsistente, rolSupervisor,
    rolGerencia, rolAdmin);
  TRoles = set of TRolUsuario;

  TSesion = class
  private
    class var FCandado: TObject;
    class var FToken: string;
    class var FUsuarioId: Integer;
    class var FCorreo: string;
    class var FNombre: string;
    class var FRol: TRolUsuario;
    class var FDebeCambiarClave: Boolean;
    class var FVence: TDateTime;
    class var FVencida: Boolean;
    class var FPermisos: TArray<string>;
    class var FAlVencer: TProc<string>;
    class constructor Create;
    class destructor Destroy;
    class function ObtenerToken: string; static;
    class function ObtenerPermisos: TArray<string>; static;
  public
    class procedure Abrir(const AToken: string);
    class procedure Cerrar;
    class procedure Vencer(const AMensaje: string);
    class procedure AlVencer(const AProc: TProc<string>);
    class function Iniciada: Boolean;
    class function EstaVigente: Boolean;

    class procedure AsignarPermisos(const APermisos: TArray<string>);
    class function Tiene(const APermiso: string): Boolean;
    class function TieneAlguno(const APermisos: array of string): Boolean;

    class property Token: string read ObtenerToken;
    class property UsuarioId: Integer read FUsuarioId;
    class property Correo: string read FCorreo;
    class property Nombre: string read FNombre;
    class property Rol: TRolUsuario read FRol;
    class property DebeCambiarClave: Boolean read FDebeCambiarClave;
    class property Permisos: TArray<string> read ObtenerPermisos;
  end;

function RolDesdeCodigo(const ACodigo: string): TRolUsuario;
function CodigoDeRol(ARol: TRolUsuario): string;
function NombreDeRol(ARol: TRolUsuario): string;
function InicialesDe(const ANombre: string): string;

implementation

uses
  System.Classes,
  System.StrUtils,
  System.DateUtils,
  MVCFramework.Commons,
  JsonDataObjects,
  Anovo.Textos;

const
  CODIGOS: array [TRolUsuario] of string = ('', 'asesor', 'asistente',
    'supervisor', 'gerencia', 'admin');

  NOMBRES: array [TRolUsuario] of string = (SRolSinRol, SRolAsesor,
    SRolAsistente, SRolSupervisor, SRolGerencia, SRolAdmin);

  MARGEN_SEGUNDOS = 60;

function RolDesdeCodigo(const ACodigo: string): TRolUsuario;
var
  lRol: TRolUsuario;
begin
  Result := rolNinguno;
  for lRol := Succ(rolNinguno) to High(TRolUsuario) do
    if SameText(Trim(ACodigo), CODIGOS[lRol]) then
      Exit(lRol);
end;

function CodigoDeRol(ARol: TRolUsuario): string;
begin
  Result := CODIGOS[ARol];
end;

function NombreDeRol(ARol: TRolUsuario): string;
begin
  Result := NOMBRES[ARol];
end;

function InicialesDe(const ANombre: string): string;
var
  lPartes: TArray<string>;
begin
  lPartes := SplitString(Trim(ANombre), ' ');
  if Length(lPartes) = 0 then
    Exit('?');

  Result := Copy(lPartes[0], 1, 1);
  if Length(lPartes) > 1 then
    Result := Result + Copy(lPartes[High(lPartes)], 1, 1);
  Result := UpperCase(Result);
end;

class constructor TSesion.Create;
begin
  FCandado := TObject.Create;
end;

class destructor TSesion.Destroy;
begin
  FCandado.Free;
end;

class function TSesion.ObtenerToken: string;
begin
  TMonitor.Enter(FCandado);
  try
    Result := FToken;
  finally
    TMonitor.Exit(FCandado);
  end;
end;

class function TSesion.ObtenerPermisos: TArray<string>;
begin
  TMonitor.Enter(FCandado);
  try
    Result := Copy(FPermisos);
  finally
    TMonitor.Exit(FCandado);
  end;
end;

class procedure TSesion.Abrir(const AToken: string);
var
  lPartes: TArray<string>;
  lDatos: TJsonObject;
begin
  lPartes := AToken.Split(['.']);
  if Length(lPartes) <> 3 then
    raise Exception.Create(STokenInvalido);

  lDatos := TJsonObject.Parse
    (TEncoding.UTF8.GetString(URLSafeB64DecodeBytes(lPartes[1])))
    as TJsonObject;
  try
    TMonitor.Enter(FCandado);
    try
      FToken := AToken;
      FVencida := False;
      FCorreo := lDatos.S['username'];
      FNombre := lDatos.S['NOMBRE'];
      FRol := RolDesdeCodigo(lDatos.S['roles']);
      FUsuarioId := StrToIntDef(lDatos.S['USUARIO_ID'], 0);
      FDebeCambiarClave := SameText(lDatos.S['DEBE_CAMBIAR_CLAVE'], 'True');
      FVence := UnixToDateTime(lDatos.L['exp'], False);
      FPermisos := nil;
    finally
      TMonitor.Exit(FCandado);
    end;
  finally
    lDatos.Free;
  end;
end;

class procedure TSesion.Cerrar;
begin
  TMonitor.Enter(FCandado);
  try
    FToken := '';
    FVencida := False;
    FUsuarioId := 0;
    FCorreo := '';
    FNombre := '';
    FRol := rolNinguno;
    FDebeCambiarClave := False;
    FVence := 0;
    FPermisos := nil;
  finally
    TMonitor.Exit(FCandado);
  end;
end;

class procedure TSesion.Vencer(const AMensaje: string);
var
  lAvisar: Boolean;
begin
  TMonitor.Enter(FCandado);
  try
    lAvisar := not FToken.IsEmpty and not FVencida;
    if lAvisar then
      FVencida := True;
  finally
    TMonitor.Exit(FCandado);
  end;

  if lAvisar and Assigned(FAlVencer) then
    TThread.Queue(nil,
      procedure
      begin
        if Assigned(FAlVencer) then
          FAlVencer(AMensaje);
      end);
end;

class procedure TSesion.AlVencer(const AProc: TProc<string>);
begin
  FAlVencer := AProc;
end;

class function TSesion.Iniciada: Boolean;
begin
  TMonitor.Enter(FCandado);
  try
    Result := not FToken.IsEmpty and not FVencida;
  finally
    TMonitor.Exit(FCandado);
  end;
end;

class function TSesion.EstaVigente: Boolean;
begin
  TMonitor.Enter(FCandado);
  try
    Result := not FToken.IsEmpty and not FVencida and
      (Now < IncSecond(FVence, -MARGEN_SEGUNDOS));
  finally
    TMonitor.Exit(FCandado);
  end;
end;

class procedure TSesion.AsignarPermisos(const APermisos: TArray<string>);
begin
  TMonitor.Enter(FCandado);
  try
    FPermisos := Copy(APermisos);
  finally
    TMonitor.Exit(FCandado);
  end;
end;

class function TSesion.Tiene(const APermiso: string): Boolean;
var
  lPermiso: string;
begin
  for lPermiso in ObtenerPermisos do
    if SameText(lPermiso, APermiso) then
      Exit(True);
  Result := False;
end;

class function TSesion.TieneAlguno(const APermisos: array of string): Boolean;
var
  lPermiso: string;
begin
  for lPermiso in APermisos do
    if Tiene(lPermiso) then
      Exit(True);
  Result := False;
end;

end.
