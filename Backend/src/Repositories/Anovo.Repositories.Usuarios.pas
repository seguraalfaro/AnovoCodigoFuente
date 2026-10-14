unit Anovo.Repositories.Usuarios;

// Repositorios de usuarios, de sus claves, de los roles y de las
// excepciones de permisos por usuario.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Consultas,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Entities.Usuarios;

type
  TUsuarioRepository = class(TAnovoRepository<TUsuarios>, IUsuarioRepository)
  public
    function NombresDe(const AIds: TArray<Integer>)
      : TDictionary<Integer, string>;
    function IdSistema: Integer;
    function PorCorreo(const ACorreo: string): TUsuarios;
    function Buscar(const ATexto, AEstado: string;
      const APagina, APorPagina: Integer): TObjectList<TUsuariosBuscados>;
    function ContarBusqueda(const ATexto, AEstado: string): Int64;
    function Vista(const AId: Integer): TUsuariosBuscados;
    function ExisteCorreo(const ACorreo: string;
      const AExcluirId: Integer): Boolean;
    function DeRol(const ARolId: Integer): TObjectList<TUsuarios>;
  end;

  TUsuarioClaveRepository = class(TAnovoRepository<TUsuariosClaves>,
    IUsuarioClaveRepository)
  public
    function ClaveActivaDe(const AUsuarioId: Integer): TUsuariosClaves;
  end;

  TRolRepository = class(TAnovoRepository<TRoles>, IRolRepository)
  public
    function Resumen: TObjectList<TRolesOrdenados>;
  end;

  TDispositivoRepository = class(TAnovoRepository<TUsuariosDispositivos>,
    IDispositivoRepository)
  public
    function ActivosDe(const AUuidDispositivo: string)
      : TObjectList<TUsuariosDispositivos>;
    function PorLlaveAnterior(const ALlaveHash: string): TUsuariosDispositivos;
  end;

  TUsuarioPermisoRepository = class(TAnovoRepository<TUsuariosPermisos>,
    IUsuarioPermisoRepository)
  public
    function ExcepcionesDe(const AUsuarioId: Integer)
      : TObjectList<TExcepcionesDePermisos>;
    function DeUsuario(const AUsuarioId: Integer)
      : TObjectList<TUsuariosPermisos>;
    function Una(const AUsuarioId, APermisoId: Integer): TUsuariosPermisos;
  end;

implementation

uses
  System.SysUtils,
  System.Variants,
  Anovo.SQL.Usuarios;

function TUsuarioRepository.NombresDe(const AIds: TArray<Integer>)
  : TDictionary<Integer, string>;
var
  lEntidades: TObjectList<TUsuarios>;
  lUsuario: TUsuarios;
  lLista: string;
  lId: Integer;
begin
  Result := TDictionary<Integer, string>.Create;
  if Length(AIds) = 0 then
    Exit;

  lLista := '';
  for lId in AIds do
  begin
    if lLista <> '' then
      lLista := lLista + ',';
    lLista := lLista + IntToStr(lId);
  end;

  try
    lEntidades := GetWhere(Format(USUARIOS_POR_IDS, [lLista]), []);
    try
      for lUsuario in lEntidades do
        Result.AddOrSetValue(lUsuario.ID, lUsuario.Nombre);
    finally
      lEntidades.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function NombreBusqueda(const AEstado: string): string;
begin
  if SameText(AEstado, ESTADO_USUARIOS_ACTIVOS) then
    Result := CONSULTA_BUSCAR_ACTIVOS
  else if SameText(AEstado, ESTADO_USUARIOS_INACTIVOS) then
    Result := CONSULTA_BUSCAR_INACTIVOS
  else if SameText(AEstado, ESTADO_USUARIOS_CLAVE_PENDIENTE) then
    Result := CONSULTA_BUSCAR_CLAVE_PENDIENTE
  else if SameText(AEstado, ESTADO_USUARIOS_CON_ADICIONALES) then
    Result := CONSULTA_BUSCAR_CON_ADICIONALES
  else
    Result := CONSULTA_BUSCAR;
end;

function TUsuarioRepository.Buscar(const ATexto, AEstado: string;
  const APagina, APorPagina: Integer): TObjectList<TUsuariosBuscados>;
begin
  Result := ListarConsulta<TUsuariosBuscados>(NombreBusqueda(AEstado),
    [TextoParaRQL(ATexto), TextoParaRQL(ATexto), (APagina - 1) * APorPagina,
    APorPagina]);
end;

function TUsuarioRepository.ContarBusqueda(const ATexto,
  AEstado: string): Int64;
begin
  Result := ContarConsulta<TUsuariosBuscados>(NombreBusqueda(AEstado),
    [TextoParaRQL(ATexto), TextoParaRQL(ATexto), 0, 0]);
end;

function TUsuarioRepository.Vista(const AId: Integer): TUsuariosBuscados;
begin
  Result := PrimeraFilaDeConsulta<TUsuariosBuscados>(CONSULTA_POR_ID, [AId]);
end;

function TUsuarioRepository.ExisteCorreo(const ACorreo: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := ContarPorFiltro(USUARIO_CORREO_DUPLICADO, [ACorreo, AExcluirId]) > 0;
end;

function TUsuarioRepository.DeRol(const ARolId: Integer)
  : TObjectList<TUsuarios>;
begin
  Result := GetWhere(USUARIOS_DE_ROL, [ARolId]);
end;

function TUsuarioPermisoRepository.ExcepcionesDe(const AUsuarioId: Integer)
  : TObjectList<TExcepcionesDePermisos>;
begin
  Result := ListarConsulta<TExcepcionesDePermisos>(CONSULTA_DE_USUARIO,
    [AUsuarioId], SIN_LIMITE);
end;

function TUsuarioPermisoRepository.DeUsuario(const AUsuarioId: Integer)
  : TObjectList<TUsuariosPermisos>;
begin
  Result := GetWhere(EXCEPCIONES_DE_USUARIO, [AUsuarioId]);
end;

function TUsuarioPermisoRepository.Una(const AUsuarioId,
  APermisoId: Integer): TUsuariosPermisos;
begin
  Result := GetOneByWhere(EXCEPCION_DE_USUARIO, [AUsuarioId, APermisoId],
    False);
end;

function TRolRepository.Resumen: TObjectList<TRolesOrdenados>;
begin
  Result := ListarConsulta<TRolesOrdenados>(CONSULTA_ORDENADAS, [],
    SIN_LIMITE);
end;

function TUsuarioClaveRepository.ClaveActivaDe(const AUsuarioId: Integer)
  : TUsuariosClaves;
begin
  Result := GetOneByWhere(USUARIO_CLAVE_ACTIVA, [AUsuarioId], False);
end;

function TUsuarioRepository.PorCorreo(const ACorreo: string): TUsuarios;
begin
  Result := GetOneByWhere(USUARIO_POR_CORREO, [ACorreo], False);
end;

function TDispositivoRepository.ActivosDe(const AUuidDispositivo: string)
  : TObjectList<TUsuariosDispositivos>;
begin
  Result := GetWhere(DISPOSITIVOS_ACTIVOS, [AUuidDispositivo]);
end;

function TDispositivoRepository.PorLlaveAnterior(const ALlaveHash: string)
  : TUsuariosDispositivos;
begin
  Result := GetOneByWhere(DISPOSITIVO_POR_LLAVE_ANTERIOR, [ALlaveHash], False);
end;

function TUsuarioRepository.IdSistema: Integer;
var
  lSistema: TUsuarios;
begin
  lSistema := GetOneByWhere(USUARIO_SISTEMA, [], False);
  try
    Result := 0;
    if Assigned(lSistema) then
      Result := lSistema.ID.ValueOrDefault;
  finally
    lSistema.Free;
  end;
end;

end.
