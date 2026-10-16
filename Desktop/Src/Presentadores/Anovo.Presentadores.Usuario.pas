unit Anovo.Presentadores.Usuario;

// Presentador de la ventana de un usuario: carga roles, cuenta, telefonos y
// permisos; guarda datos, clave, adicionales y telefonos en una sola accion.

interface

uses
  System.Generics.Collections,
  Anovo.Api.Intf.Usuarios,
  Anovo.Api.Intf.Roles,
  Anovo.Presentadores.Base,
  Anovo.DTOs.Dispositivos,
  Anovo.DTOs.Usuarios,
  Anovo.DTOs.Roles,
  Anovo.Vistas.Intf.Usuario;

type
  TPresentadorUsuario = class(TPresentadorBase)
  private
    FVista: IVistaUsuario;
    FApiUsuarios: IApiUsuarios;
    FApiRoles: IApiRoles;
    FFilas: TObjectList<TFilaPermiso>;
    FPorId: TDictionary<Integer, TFilaPermiso>;
    FCambios: TDictionary<Integer, string>;
    FBasicos: TDictionary<Integer, Integer>;
    FTelefonos: TObjectList<TFilaTelefono>;
    FInactivar: TList<Integer>;
    FId: Integer;
    FNombre: string;
    FCorreo: string;
    FRolId: Integer;
    FAdicionales: Integer;
    FDebeCambiarClave: Boolean;
    FPedirCambio: Boolean;
    procedure TomarOriginal(const AUsuario: TUsuarioDTO);
    procedure TomarFilas(const AFilas: TObjectList<TFilaPermiso>);
    procedure TomarBasicos(const AMatriz: TMatrizPermisosDTO);
    function CambiosAEnviar(const AMotivo: string): TCambiosExcepcionesDTO;
    procedure MostrarError(AMensaje: string);
  public
    constructor Create(const AVista: IVistaUsuario;
      const AApiUsuarios: IApiUsuarios; const AApiRoles: IApiRoles);
    destructor Destroy; override;
    procedure Cargar(const AId: Integer);
    procedure MarcarPermiso(const APermisoId: Integer; const ATiene: Boolean);
    procedure MarcarTelefono(const ADispositivoId: Integer;
      const AInactivar: Boolean);
    function HayCambiosDePermisos: Boolean;
    function CambiosDePermisos: Integer;
    function BasicosDelRol(const ARolId: Integer): Integer;
    function CambioRol(const ARolId: Integer): Boolean;
    function CambioDatos(const ADatos: TUsuarioEdicionDTO): Boolean;
    function GuardaPermisos(const ARolId: Integer): Boolean;
    function PuedeRestablecer: Boolean;
    class function EsCuentaPropia(const AId: Integer): Boolean;
    class function PuedeEditarPermisos: Boolean;
    function HayCambios(const ADatos: TUsuarioEdicionDTO;
      const AConPermisos: Boolean): Boolean;
    procedure PedirCambio(const APedir: Boolean);
    class function GenerarClave: string;
    property Adicionales: Integer read FAdicionales;
    property DebeCambiarClave: Boolean read FDebeCambiarClave;
    property PideCambio: Boolean read FPedirCambio;
    procedure Guardar(const ADatos: TUsuarioEdicionDTO; const AMotivo: string;
      const AConPermisos: Boolean);
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Defaults,
  Anovo.Sesion,
  Anovo.Permisos,
  Anovo.Textos;

const
  TIPO_OTORGADO = 'otorgado';
  TIPO_QUITADO = 'quitado';
  LARGO_CLAVE_TEMPORAL = 12;
  LETRAS_CLAVE = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ';
  DIGITOS_CLAVE = '23456789';

function FilasTelefono(const ADispositivos: TObjectList<TDispositivoDTO>)
  : TObjectList<TFilaTelefono>;
var
  lDispositivo: TDispositivoDTO;
  lFila: TFilaTelefono;
begin
  Result := TObjectList<TFilaTelefono>.Create(True);
  for lDispositivo in ADispositivos do
  begin
    lFila := TFilaTelefono.Create;
    Result.Add(lFila);
    lFila.ID := lDispositivo.ID;
    lFila.Nombre := lDispositivo.Nombre.ValueOrDefault;
    lFila.Activo := lDispositivo.Activo;
    lFila.Motivo := lDispositivo.Motivo.ValueOrDefault;
    lFila.FechaCreacion := lDispositivo.FechaCreacion;
    lFila.FechaUltimoUso := lDispositivo.FechaUltimoUso;
    if lDispositivo.Activo then
      lFila.Inactivar := False;
  end;
end;

function FilasDe(const AMatriz: TMatrizPermisosDTO; const AUsuario: TUsuarioDTO;
  const AExcepciones: TObjectList<TExcepcionDTO>): TObjectList<TFilaPermiso>;
var
  lPermiso: TPermisoDTO;
  lAsignacion: TAsignacionDTO;
  lExcepcion: TExcepcionDTO;
  lFila: TFilaPermiso;
begin
  Result := TObjectList<TFilaPermiso>.Create(True);
  try
    for lPermiso in AMatriz.Permisos do
    begin
      if not SameText(lPermiso.Ambito, AUsuario.Ambito) then
        Continue;
      lFila := TFilaPermiso.Create;
      Result.Add(lFila);
      lFila.PermisoId := lPermiso.ID;
      lFila.Modulo := lPermiso.Modulo;
      lFila.Nombre := lPermiso.Nombre;
      for lAsignacion in AMatriz.Asignaciones do
        if (lAsignacion.RolId = AUsuario.RolId) and
          (lAsignacion.PermisoId = lPermiso.ID) then
          lFila.DelRol := True;
      lFila.Tiene := lFila.DelRol;
      for lExcepcion in AExcepciones do
        if lExcepcion.PermisoId = lPermiso.ID then
        begin
          lFila.Tiene := lExcepcion.Tipo = TIPO_OTORGADO;
          lFila.Motivo := lExcepcion.Motivo;
        end;
      lFila.TieneOriginal := lFila.Tiene;
    end;
    Result.Sort(TComparer<TFilaPermiso>.Construct(
      function(const A, B: TFilaPermiso): Integer
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

constructor TPresentadorUsuario.Create(const AVista: IVistaUsuario;
  const AApiUsuarios: IApiUsuarios; const AApiRoles: IApiRoles);
begin
  inherited Create;
  FVista := AVista;
  FApiUsuarios := AApiUsuarios;
  FApiRoles := AApiRoles;
  FPorId := TDictionary<Integer, TFilaPermiso>.Create;
  FCambios := TDictionary<Integer, string>.Create;
  FBasicos := TDictionary<Integer, Integer>.Create;
  FInactivar := TList<Integer>.Create;
end;

destructor TPresentadorUsuario.Destroy;
begin
  FCambios.Free;
  FBasicos.Free;
  FInactivar.Free;
  FTelefonos.Free;
  FPorId.Free;
  FFilas.Free;
  inherited;
end;

procedure TPresentadorUsuario.TomarOriginal(const AUsuario: TUsuarioDTO);
begin
  FNombre := AUsuario.Nombre;
  FCorreo := AUsuario.Correo;
  FRolId := AUsuario.RolId;
  FAdicionales := AUsuario.Excepciones;
  FDebeCambiarClave := AUsuario.DebeCambiarClave;
  FPedirCambio := False;
end;

procedure TPresentadorUsuario.TomarFilas(const AFilas: TObjectList<TFilaPermiso>);
var
  lFila: TFilaPermiso;
begin
  FFilas.Free;
  FFilas := AFilas;
  FPorId.Clear;
  FCambios.Clear;
  for lFila in FFilas do
    FPorId.Add(lFila.PermisoId, lFila);
end;

procedure TPresentadorUsuario.MarcarPermiso(const APermisoId: Integer;
  const ATiene: Boolean);
var
  lFila: TFilaPermiso;
begin
  if not FPorId.TryGetValue(APermisoId, lFila) then
    Exit;
  lFila.Tiene := ATiene;
  if ATiene = lFila.TieneOriginal then
    FCambios.Remove(APermisoId)
  else if ATiene = lFila.DelRol then
    FCambios.AddOrSetValue(APermisoId, '')
  else if ATiene then
    FCambios.AddOrSetValue(APermisoId, TIPO_OTORGADO)
  else
    FCambios.AddOrSetValue(APermisoId, TIPO_QUITADO);
end;

procedure TPresentadorUsuario.MarcarTelefono(const ADispositivoId: Integer;
  const AInactivar: Boolean);
begin
  FInactivar.Remove(ADispositivoId);
  if AInactivar then
    FInactivar.Add(ADispositivoId);
end;

procedure TPresentadorUsuario.TomarBasicos(const AMatriz: TMatrizPermisosDTO);
var
  lAsignacion: TAsignacionDTO;
  lCantidad: Integer;
begin
  FBasicos.Clear;
  for lAsignacion in AMatriz.Asignaciones do
  begin
    if not FBasicos.TryGetValue(lAsignacion.RolId, lCantidad) then
      lCantidad := 0;
    FBasicos.AddOrSetValue(lAsignacion.RolId, lCantidad + 1);
  end;
end;

function TPresentadorUsuario.BasicosDelRol(const ARolId: Integer): Integer;
begin
  if not FBasicos.TryGetValue(ARolId, Result) then
    Result := 0;
end;

function TPresentadorUsuario.CambiosDePermisos: Integer;
begin
  Result := FCambios.Count;
end;

function TPresentadorUsuario.HayCambiosDePermisos: Boolean;
begin
  Result := FCambios.Count > 0;
end;

function TPresentadorUsuario.CambioRol(const ARolId: Integer): Boolean;
begin
  Result := (FId > 0) and (ARolId <> FRolId);
end;

function TPresentadorUsuario.CambioDatos(const ADatos
  : TUsuarioEdicionDTO): Boolean;
begin
  Result := (FId = 0) or CambioRol(ADatos.RolId) or
    (ADatos.Nombre.Trim <> FNombre) or
    (ADatos.Correo.Trim.ToLower <> FCorreo);
end;

function TPresentadorUsuario.GuardaPermisos(const ARolId: Integer): Boolean;
begin
  Result := (FId > 0) and not CambioRol(ARolId) and HayCambiosDePermisos;
end;

class function TPresentadorUsuario.EsCuentaPropia(const AId: Integer): Boolean;
begin
  Result := AId = TSesion.UsuarioId;
end;

class function TPresentadorUsuario.PuedeEditarPermisos: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_PERMISOS_EDITAR);
end;

function TPresentadorUsuario.PuedeRestablecer: Boolean;
begin
  Result := (FId > 0) and (FId <> TSesion.UsuarioId);
end;

class function TPresentadorUsuario.GenerarClave: string;
var
  lBytes: TBytes;
  I: Integer;
begin
  lBytes := TGUID.NewGuid.ToByteArray;
  SetLength(Result, LARGO_CLAVE_TEMPORAL);
  for I := 1 to LARGO_CLAVE_TEMPORAL do
    if I mod 4 = 0 then
      Result[I] := DIGITOS_CLAVE[lBytes[I - 1] mod Length(DIGITOS_CLAVE) + 1]
    else
      Result[I] := LETRAS_CLAVE[lBytes[I - 1] mod Length(LETRAS_CLAVE) + 1];
end;

procedure TPresentadorUsuario.PedirCambio(const APedir: Boolean);
begin
  FPedirCambio := APedir and PuedeRestablecer and not FDebeCambiarClave;
end;

function TPresentadorUsuario.HayCambios(const ADatos: TUsuarioEdicionDTO;
  const AConPermisos: Boolean): Boolean;
begin
  Result := CambioDatos(ADatos) or not ADatos.ClaveTemporal.IsEmpty or
    FPedirCambio or AConPermisos or (FInactivar.Count > 0);
end;

function TPresentadorUsuario.CambiosAEnviar(const AMotivo: string)
  : TCambiosExcepcionesDTO;
var
  lPar: TPair<Integer, string>;
  lCambio: TCambioExcepcionDTO;
begin
  Result := TCambiosExcepcionesDTO.Create;
  Result.Motivo := AMotivo;
  for lPar in FCambios do
  begin
    lCambio := TCambioExcepcionDTO.Create;
    Result.Cambios.Add(lCambio);
    lCambio.PermisoId := lPar.Key;
    lCambio.Tipo := lPar.Value;
  end;
end;

procedure TPresentadorUsuario.MostrarError(AMensaje: string);
begin
  FVista.MostrarError(AMensaje);
end;

procedure TPresentadorUsuario.Cargar(const AId: Integer);
var
  lApiUsuarios: IApiUsuarios;
  lApiRoles: IApiRoles;
  lMatriz: TMatrizPermisosDTO;
  lUsuario: TUsuarioDTO;
  lExcepciones: TObjectList<TExcepcionDTO>;
  lFilas: TObjectList<TFilaPermiso>;
  lTelefonos: TObjectList<TFilaTelefono>;
begin
  FId := AId;
  lTelefonos := nil;
  lApiUsuarios := FApiUsuarios;
  lApiRoles := FApiRoles;
  lMatriz := nil;
  lUsuario := nil;
  lExcepciones := nil;
  lFilas := nil;

  Ejecutar(SAccionCargarUsuario,
    procedure
    var
      lDispositivos: TObjectList<TDispositivoDTO>;
    begin
      lMatriz := lApiRoles.Matriz;
      if AId > 0 then
      begin
        lUsuario := lApiUsuarios.Obtener(AId);
        lExcepciones := lApiUsuarios.Excepciones(AId);
        lFilas := FilasDe(lMatriz, lUsuario, lExcepciones);
        lDispositivos := lApiUsuarios.Dispositivos(AId);
        try
          lTelefonos := FilasTelefono(lDispositivos);
        finally
          lDispositivos.Free;
        end;
      end;
    end,
    procedure
    begin
      TomarBasicos(lMatriz);
      FVista.MostrarRoles(lMatriz.Roles);
      if lUsuario <> nil then
      begin
        TomarOriginal(lUsuario);
        FVista.MostrarUsuario(lUsuario);
        TomarFilas(lFilas);
        lFilas := nil;
        FVista.MostrarPermisos(FFilas);
        FTelefonos.Free;
        FTelefonos := lTelefonos;
        lTelefonos := nil;
        FInactivar.Clear;
        FVista.MostrarTelefonos(FTelefonos);
      end;
    end, MostrarError,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end,
    procedure
    begin
      lTelefonos.Free;
      lFilas.Free;
      lExcepciones.Free;
      lUsuario.Free;
      lMatriz.Free;
    end);
end;

procedure TPresentadorUsuario.Guardar(const ADatos: TUsuarioEdicionDTO;
  const AMotivo: string; const AConPermisos: Boolean);
var
  lApi: IApiUsuarios;
  lId: Integer;
  lClave: string;
  lPedir, lEnviarDatos: Boolean;
  lCambios: TCambiosExcepcionesDTO;
  lTelefonos: TArray<Integer>;
begin
  lId := FId;
  ADatos.Nombre := ADatos.Nombre.Trim;
  ADatos.Correo := ADatos.Correo.Trim;
  lClave := ADatos.ClaveTemporal;
  lPedir := FPedirCambio and lClave.IsEmpty;
  lEnviarDatos := CambioDatos(ADatos);
  if lId > 0 then
    ADatos.ClaveTemporal := '';
  lCambios := nil;
  if AConPermisos and HayCambiosDePermisos then
    lCambios := CambiosAEnviar(AMotivo);
  lTelefonos := FInactivar.ToArray;
  lApi := FApiUsuarios;

  Ejecutar(SAccionGuardar,
    procedure
    var
      lTelefono: Integer;
    begin
      if lId = 0 then
        lApi.Crear(ADatos).Free
      else
      begin
        if lEnviarDatos then
          lApi.Editar(lId, ADatos);
        if not lClave.IsEmpty then
          lApi.RestablecerClave(lId, lClave);
        if lPedir then
          lApi.PedirCambioClave(lId);
        if lCambios <> nil then
          lApi.CambiarExcepciones(lId, lCambios);
        for lTelefono in lTelefonos do
          lApi.InactivarDispositivo(lId, lTelefono);
      end;
    end,
    procedure
    begin
      FVista.Guardado;
    end, MostrarError,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarGuardando(AActivo);
    end,
    procedure
    begin
      ADatos.Free;
      lCambios.Free;
    end);
end;

end.
