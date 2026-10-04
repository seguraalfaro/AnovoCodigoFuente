unit Anovo.Presentadores.Roles;

// Presentador de Roles y permisos: arma la matriz, lleva los cambios del
// paquete basico de cada rol y los manda con su motivo.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Intf.Roles,
  Anovo.Cancelacion,
  Anovo.DTOs.Roles,
  Anovo.Vistas.Intf.Roles;

type
  TPresentadorRoles = class
  private
    FVista: IVistaRoles;
    FApi: IApiRoles;
    FCancelacion: ICancelacion;
    FRoles: TDictionary<string, Integer>;
    FOriginal: TDictionary<string, Boolean>;
    FCambios: TDictionary<string, Boolean>;
    procedure TomarMatriz(const AMatriz: TMatrizPermisosDTO);
    function FilasDe(const AMatriz: TMatrizPermisosDTO)
      : TObjectList<TFilaMatriz>;
  public
    constructor Create(const AVista: IVistaRoles; const AApi: IApiRoles);
    destructor Destroy; override;
    procedure Iniciar;
    function PuedeMarcar(const ARol: string): Boolean;
    procedure MarcarPermiso(const ARol: string; const APermisoId: Integer;
      const AAsignado: Boolean);
    function HayCambios: Boolean;
    procedure Guardar(const AMotivo: string);
    class function PuedeEditar: Boolean;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.Threading,
  System.Generics.Defaults,
  MVCFramework.Nullables,
  Anovo.Api.Base,
  Anovo.Sesion,
  Anovo.Textos;

const
  PERMISO_EDITAR = 'permisos.editar';
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

function MensajeInesperado(const AAccion: string): string;
begin
  Result := Format(SErrorInesperado, [AAccion]);
end;

constructor TPresentadorRoles.Create(const AVista: IVistaRoles;
  const AApi: IApiRoles);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
  FRoles := TDictionary<string, Integer>.Create;
  FOriginal := TDictionary<string, Boolean>.Create;
  FCambios := TDictionary<string, Boolean>.Create;
end;

destructor TPresentadorRoles.Destroy;
begin
  FCancelacion.Cancelar;
  FCambios.Free;
  FOriginal.Free;
  FRoles.Free;
  inherited;
end;

class function TPresentadorRoles.PuedeEditar: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_EDITAR);
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

procedure TPresentadorRoles.Iniciar;
var
  lCancelacion: ICancelacion;
  lApi: IApiRoles;
begin
  lCancelacion := FCancelacion;
  lApi := FApi;
  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lMatriz: TMatrizPermisosDTO;
      lError: string;
    begin
      lMatriz := nil;
      lError := '';
      try
        lMatriz := lApi.Matriz;
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MensajeInesperado(SAccionCargarRoles);
      end;

      TThread.Queue(nil,
        procedure
        var
          lFilas: TObjectList<TFilaMatriz>;
        begin
          try
            if lCancelacion.Cancelada then
              Exit;
            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
            begin
              FVista.MostrarError(lError);
              Exit;
            end;
            TomarMatriz(lMatriz);
            lFilas := FilasDe(lMatriz);
            try
              FVista.MostrarRoles(RotulosDeRoles(lMatriz.Roles));
              FVista.MostrarMatriz(lFilas);
              FVista.MostrarCambios(0);
            finally
              lFilas.Free;
            end;
          finally
            lMatriz.Free;
          end;
        end);
    end);
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

function TPresentadorRoles.HayCambios: Boolean;
begin
  Result := FCambios.Count > 0;
end;

procedure TPresentadorRoles.Guardar(const AMotivo: string);
var
  lCancelacion: ICancelacion;
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

  lCancelacion := FCancelacion;
  lApi := FApi;
  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lError: string;
    begin
      lError := '';
      try
        try
          lApi.CambiarMatriz(lDto);
        except
          on E: EAnovoCliente do
            lError := E.Message;
          on E: Exception do
            lError := MensajeInesperado(SAccionCambiarPermisos);
        end;
      finally
        lDto.Free;
      end;

      TThread.Queue(nil,
        procedure
        begin
          if lCancelacion.Cancelada then
            Exit;
          FVista.MostrarCargando(False);
          if not lError.IsEmpty then
          begin
            FVista.MostrarError(lError);
            Exit;
          end;
          Iniciar;
        end);
    end);
end;

end.
