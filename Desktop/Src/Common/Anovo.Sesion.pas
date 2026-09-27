unit Anovo.Sesion;

// Sesion del usuario en memoria: token, rol, nombre y permisos.
// Solo decide que se muestra; los permisos los aplica el servidor.

interface

type
  TRolUsuario = (rolNinguno, rolAsesor, rolAsistente, rolSupervisor,
    rolGerencia, rolAdmin);
  TRoles = set of TRolUsuario;

  TSesion = class
  private
    class var FToken: string;
    class var FUsuarioId: Integer;
    class var FCorreo: string;
    class var FNombre: string;
    class var FRol: TRolUsuario;
    class var FDebeCambiarClave: Boolean;
    class var FVence: TDateTime;
    class var FPermisos: TArray<string>;
  public
    class procedure Abrir(const AToken: string);
    class procedure Cerrar;
    class function Iniciada: Boolean;
    class function EstaVigente: Boolean;

    class procedure AsignarPermisos(const APermisos: TArray<string>);
    class function Tiene(const APermiso: string): Boolean;
    class function TieneAlguno(const APermisos: array of string): Boolean;

    class property Token: string read FToken;
    class property UsuarioId: Integer read FUsuarioId;
    class property Correo: string read FCorreo;
    class property Nombre: string read FNombre;
    class property Rol: TRolUsuario read FRol;
    class property DebeCambiarClave: Boolean read FDebeCambiarClave;
    class property Permisos: TArray<string> read FPermisos;
  end;

function RolDesdeCodigo(const ACodigo: string): TRolUsuario;
function CodigoDeRol(ARol: TRolUsuario): string;
function NombreDeRol(ARol: TRolUsuario): string;
function InicialesDe(const ANombre: string): string;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.DateUtils,
  MVCFramework.Commons,
  JsonDataObjects;

const
  CODIGOS: array [TRolUsuario] of string = ('', 'asesor', 'asistente',
    'supervisor', 'gerencia', 'admin');

  NOMBRES: array [TRolUsuario] of string = ('Sin rol', 'Asesor comercial',
    'Asistente de cotizaciones', 'Supervisor', 'Gerencia',
    'Administrador del sistema');

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

class procedure TSesion.Abrir(const AToken: string);
var
  lPartes: TArray<string>;
  lDatos: TJsonObject;
begin
  lPartes := AToken.Split(['.']);
  if Length(lPartes) <> 3 then
    raise Exception.Create
      ('El servidor devolvio un token con formato invalido.');

  lDatos := TJsonObject.Parse
    (TEncoding.UTF8.GetString(URLSafeB64DecodeBytes(lPartes[1])))
    as TJsonObject;
  try
    FToken := AToken;
    FCorreo := lDatos.S['username'];
    FNombre := lDatos.S['NOMBRE'];
    FRol := RolDesdeCodigo(lDatos.S['roles']);
    FUsuarioId := StrToIntDef(lDatos.S['USUARIO_ID'], 0);
    FDebeCambiarClave := SameText(lDatos.S['DEBE_CAMBIAR_CLAVE'], 'True');
    FVence := UnixToDateTime(lDatos.L['exp'], False);
    FPermisos := nil;
  finally
    lDatos.Free;
  end;
end;

class procedure TSesion.Cerrar;
begin
  FToken := '';
  FUsuarioId := 0;
  FCorreo := '';
  FNombre := '';
  FRol := rolNinguno;
  FDebeCambiarClave := False;
  FVence := 0;
  FPermisos := nil;
end;

class function TSesion.Iniciada: Boolean;
begin
  Result := not FToken.IsEmpty;
end;

class function TSesion.EstaVigente: Boolean;
begin
  Result := Iniciada and (Now < IncSecond(FVence, -MARGEN_SEGUNDOS));
end;

class procedure TSesion.AsignarPermisos(const APermisos: TArray<string>);
begin
  FPermisos := APermisos;
end;

class function TSesion.Tiene(const APermiso: string): Boolean;
var
  lPermiso: string;
begin
  for lPermiso in FPermisos do
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
