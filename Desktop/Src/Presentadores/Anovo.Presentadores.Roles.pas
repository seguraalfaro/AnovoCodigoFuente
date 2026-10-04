unit Anovo.Presentadores.Roles;

// Presentador de Roles y permisos: arma la matriz, lleva los cambios del
// paquete basico de cada rol y los manda con su motivo.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Intf.Roles,
  Anovo.Presentadores.Base,
  Anovo.DTOs.Roles,
  Anovo.Vistas.Intf.Roles,
  Anovo.Permisos;

type
  TPresentadorRoles = class(TPresentadorBase)
  private
    FVista: IVistaRoles;
    FApi: IApiRoles;
    FRoles: TDictionary<string, Integer>;
    FOriginal: TDictionary<string, Boolean>;
    FCambios: TDictionary<string, Boolean>;
    procedure TomarMatriz(const AMatriz: TMatrizPermisosDTO);
    function FilasDe(const AMatriz: TMatrizPermisosDTO)
      : TObjectList<TFilaMatriz>;
    procedure MostrarError(AMensaje: string);
    procedure MostrarCargando(AActivo: Boolean);
  public
    constructor Create(const AVista: IVistaRoles; const AApi: IApiRoles);
    destructor Destroy; override;
    procedure Iniciar;
    function PuedeMarcar(const ARol: string): Boolean;
    procedure MarcarPermiso(const ARol: string; const APermisoId: Integer;
      const AAsignado: Boolean);
    function HayCambios: Boolean;
    function PermisoCambiado(const APermisoId: Integer): Boolean;
    procedure Guardar(const AMotivo: string);
    class function PuedeEditar: Boolean;
    class function CampoRolPropio: string;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.Generics.Defaults,
  MVCFramework.Nullables,
  Anovo.Sesion,
  Anovo.Textos;

const
  ROL_ASESOR = 'asesor';
  ROL_ASISTENTE = 'asistente';
  ROL_SUPERVISOR = 'supervisor';
  ROL_GERENCIA = 'gerencia';
  ROL_ADMIN = 'admin';
  ORDEN_ROLES: array [0 .. 4] of string = (ROL_ASESOR, ROL_ASISTENTE,
    ROL_SUPERVISOR, ROL_GERENCIA, ROL_ADMIN);

function Llave(const ARolId, APermisoId: Integer): string;
begin
  Result := ARolId.ToString + #9 + APermisoId.ToString;
end;

function RotulosDeRoles(const ARoles: TObjectList<TRolDTO>): TArray<string>;
var
  lRol: TRolDTO;
  lPosicion: Integer;
begin
  SetLength(Result, Length(ORDEN_ROLES));
  for lRol in ARoles do
  begin
    lPosicion := IndexText(lRol.Codigo, ORDEN_ROLES);
    if lPosicion >= 0 then
      Result[lPosicion] := Format(SRolConUsuarios, [lRol.Nombre,
        lRol.UsuariosActivos]);
  end;
end;

constructor TPresentadorRoles.Create(const AVista: IVistaRoles;
  const AApi: IApiRoles);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FRoles := TDictionary<string, Integer>.Create;
  FOriginal := TDictionary<string, Boolean>.Create;
  FCambios := TDictionary<string, Boolean>.Create;
end;

destructor TPresentadorRoles.Destroy;
begin
  FCambios.Free;
  FOriginal.Free;
  FRoles.Free;
  inherited;
end;

class function TPresentadorRoles.PuedeEditar: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_PERMISOS_EDITAR);
end;

procedure TPresentadorRoles.TomarMatriz(const AMatriz: TMatrizPermisosDTO);
var
  lRol: TRolDTO;
  lAsignacion: TAsignacionDTO;
begin
  FRoles.Clear;
  FOriginal.Clear;
  FCambios.Clear;
  for lRol in AMatriz.Roles do
    FRoles.AddOrSetValue(LowerCase(lRol.Codigo), lRol.ID);
  for lAsignacion in AMatriz.Asignaciones do
    FOriginal.AddOrSetValue(Llave(lAsignacion.RolId, lAsignacion.PermisoId),
      True);
end;

function TPresentadorRoles.FilasDe(const AMatriz: TMatrizPermisosDTO)
  : TObjectList<TFilaMatriz>;
var
  lPermiso: TPermisoDTO;
  lRol: TRolDTO;
  lFila: TFilaMatriz;
  lValor: NullableBoolean;
  lCodigo: string;
begin
  Result := TObjectList<TFilaMatriz>.Create(True);
  try
    for lPermiso in AMatriz.Permisos do
    begin
      lFila := TFilaMatriz.Create;
      Result.Add(lFila);
      lFila.PermisoId := lPermiso.ID;
      lFila.Modulo := lPermiso.Modulo;
      lFila.Nombre := lPermiso.Nombre;
      for lRol in AMatriz.Roles do
      begin
        if SameText(lRol.Ambito, lPermiso.Ambito) then
          lValor := FOriginal.ContainsKey(Llave(lRol.ID, lPermiso.ID))
        else
          lValor.Clear;
        lCodigo := LowerCase(lRol.Codigo);
        if lCodigo = ROL_ASESOR then
          lFila.Asesor := lValor
        else if lCodigo = ROL_ASISTENTE then
          lFila.Asistente := lValor
        else if lCodigo = ROL_SUPERVISOR then
          lFila.Supervisor := lValor
        else if lCodigo = ROL_GERENCIA then
          lFila.Gerencia := lValor
        else if lCodigo = ROL_ADMIN then
          lFila.Admin := lValor;
      end;
    end;
    Result.Sort(TComparer<TFilaMatriz>.Construct(
      function(const A, B: TFilaMatriz): Integer
      begin
        Result := CompareText(A.Modulo, B.Modulo);
        if Result = 0 then
          Result := CompareText(A.Nombre, B.Nombre);
      end));
  except
    Result.Free;
    raise;
  end;
end;

procedure TPresentadorRoles.MostrarError(AMensaje: string);
begin
  FVista.MostrarError(AMensaje);
end;

procedure TPresentadorRoles.MostrarCargando(AActivo: Boolean);
begin
  FVista.MostrarCargando(AActivo);
end;

procedure TPresentadorRoles.Iniciar;
var
  lApi: IApiRoles;
begin
  lApi := FApi;

  Ejecutar<TMatrizPermisosDTO>(SAccionCargarRoles,
    function: TMatrizPermisosDTO
    begin
      Result := lApi.Matriz;
    end,
    procedure(AMatriz: TMatrizPermisosDTO)
    var
      lFilas: TObjectList<TFilaMatriz>;
    begin
      TomarMatriz(AMatriz);
      lFilas := FilasDe(AMatriz);
      try
        FVista.MostrarRoles(RotulosDeRoles(AMatriz.Roles));
        FVista.MostrarMatriz(lFilas);
        FVista.MostrarCambios(0);
      finally
        lFilas.Free;
      end;
    end, MostrarError, MostrarCargando);
end;

class function TPresentadorRoles.CampoRolPropio: string;
begin
  Result := UpperCase(CodigoDeRol(TSesion.Rol));
end;

function TPresentadorRoles.PuedeMarcar(const ARol: string): Boolean;
begin
  Result := PuedeEditar and not SameText(ARol, CodigoDeRol(TSesion.Rol)) and
    FRoles.ContainsKey(LowerCase(ARol));
end;

procedure TPresentadorRoles.MarcarPermiso(const ARol: string;
  const APermisoId: Integer; const AAsignado: Boolean);
var
  lRolId: Integer;
  lLlave: string;
begin
  if not PuedeMarcar(ARol) or not FRoles.TryGetValue(LowerCase(ARol), lRolId) then
    Exit;

  lLlave := Llave(lRolId, APermisoId);
  if AAsignado = FOriginal.ContainsKey(lLlave) then
    FCambios.Remove(lLlave)
  else
    FCambios.AddOrSetValue(lLlave, AAsignado);
  FVista.MostrarCambios(FCambios.Count);
end;

function TPresentadorRoles.PermisoCambiado(const APermisoId: Integer): Boolean;
var
  lRolId: Integer;
begin
  for lRolId in FRoles.Values do
    if FCambios.ContainsKey(Llave(lRolId, APermisoId)) then
      Exit(True);
  Result := False;
end;

function TPresentadorRoles.HayCambios: Boolean;
begin
  Result := FCambios.Count > 0;
end;

procedure TPresentadorRoles.Guardar(const AMotivo: string);
var
  lApi: IApiRoles;
  lDto: TCambiosMatrizDTO;
  lPar: TPair<string, Boolean>;
  lCambio: TCambioPermisoDTO;
  lPartes: TArray<string>;
begin
  if not HayCambios then
    Exit;

  lDto := TCambiosMatrizDTO.Create;
  lDto.Motivo := AMotivo;
  for lPar in FCambios do
  begin
    lPartes := lPar.Key.Split([#9]);
    lCambio := TCambioPermisoDTO.Create;
    lDto.Cambios.Add(lCambio);
    lCambio.RolId := lPartes[0].ToInteger;
    lCambio.PermisoId := lPartes[1].ToInteger;
    lCambio.Asignado := lPar.Value;
  end;

  lApi := FApi;

  Ejecutar(SAccionCambiarPermisos,
    procedure
    begin
      lApi.CambiarMatriz(lDto);
    end,
    procedure
    begin
      Iniciar;
    end, MostrarError, MostrarCargando,
    procedure
    begin
      lDto.Free;
    end);
end;

end.
