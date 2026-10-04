unit Anovo.Services.Auditoria;

// Servicio de auditoria: alcance de la bitacora por permiso
// y nombres de quien escribio.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  Anovo.DTOs.Auditoria,
  Anovo.Entities.Auditoria,
  Anovo.Repositories.Intf.Auditoria,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Services.Intf.Auditoria;

type
  TAuditoriaService = class(TInterfacedObject, IAuditoriaService)
  private
    fRepo: IAuditoriaRepository;
    fUsuarios: IUsuarioRepository;
    function AListaDto(const AEntidades: TObjectList<TAuditoria>)
      : TObjectList<TAuditoriaDTO>;
    procedure PonerNombres(const ALista: TObjectList<TAuditoriaDTO>);
    function EntidadSegun(const AAlcance: TAlcanceAuditoria;
      const AEntidad: string): string;
  public
    [MVCInject]
    constructor Create(ARepo: IAuditoriaRepository;
      AUsuarios: IUsuarioRepository); reintroduce;

    function Buscar(const AAlcance: TAlcanceAuditoria;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer;
      const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string;
      out ATotal: Int64): TObjectList<TAuditoriaDTO>;
    function DeLaEntidad(const AEntidad: string; const AEntidadId: Integer)
      : TObjectList<TAuditoriaDTO>;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Textos;

const
  ENTIDAD_USUARIOS = 'USUARIOS';
  ENTIDAD_USUARIOS_CLAVES = 'USUARIOS_CLAVES';
  ENTIDAD_ROLES_PERMISOS = 'ROLES_PERMISOS';
  ENTIDAD_USUARIOS_PERMISOS = 'USUARIOS_PERMISOS';

  USUARIO_DESCONOCIDO = 'Usuario eliminado';
  USUARIO_SISTEMA = 'Sistema';

constructor TAuditoriaService.Create(ARepo: IAuditoriaRepository;
  AUsuarios: IUsuarioRepository);
begin
  inherited Create;
  fRepo := ARepo;
  fUsuarios := AUsuarios;
end;

function TAuditoriaService.EntidadSegun(const AAlcance: TAlcanceAuditoria;
  const AEntidad: string): string;
var
  lEntidad: string;
begin
  lEntidad := UpperCase(Trim(AEntidad));

  if AAlcance = aaTodo then
    Exit(lEntidad);

  if lEntidad = '' then
    Exit(ENTIDAD_USUARIOS);
  if not MatchStr(lEntidad, [ENTIDAD_USUARIOS, ENTIDAD_USUARIOS_CLAVES,
    ENTIDAD_ROLES_PERMISOS, ENTIDAD_USUARIOS_PERMISOS]) then
    raise ESinPermiso.Create
      ('Con auditoria.ver_cuentas solo se consulta USUARIOS, ' +
      'USUARIOS_CLAVES, ROLES_PERMISOS y USUARIOS_PERMISOS.');
  Result := lEntidad;
end;

function TAuditoriaService.Buscar(const AAlcance: TAlcanceAuditoria;
  const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer;
  const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string;
  out ATotal: Int64): TObjectList<TAuditoriaDTO>;
var
  lEntidades: TObjectList<TAuditoria>;
  lEntidad: string;
begin
  if ADesde > AHasta then
    raise EDatoInvalido.Create(SPeriodoInvertido);

  lEntidad := EntidadSegun(AAlcance, AEntidad);

  ATotal := fRepo.ContarBusqueda(ADesde, AHasta, AUsuarioId, lEntidad,
    UpperCase(Trim(AAccion)), ATexto);
  lEntidades := fRepo.Buscar(ADesde, AHasta, APagina, APorPagina, AUsuarioId,
    lEntidad, UpperCase(Trim(AAccion)), ATexto);
  try
    Result := AListaDto(lEntidades);
  finally
    lEntidades.Free;
  end;
end;

function TAuditoriaService.DeLaEntidad(const AEntidad: string;
  const AEntidadId: Integer): TObjectList<TAuditoriaDTO>;
var
  lEntidades: TObjectList<TAuditoria>;
begin
  lEntidades := fRepo.DeLaEntidad(UpperCase(Trim(AEntidad)), AEntidadId);
  try
    Result := AListaDto(lEntidades);
  finally
    lEntidades.Free;
  end;
end;

function TAuditoriaService.AListaDto(const AEntidades
  : TObjectList<TAuditoria>): TObjectList<TAuditoriaDTO>;
begin
  Result := TMapeo.AListaDto<TAuditoria, TAuditoriaDTO>(AEntidades);
  try
    PonerNombres(Result);
  except
    Result.Free;
    raise;
  end;
end;

procedure TAuditoriaService.PonerNombres(const ALista
  : TObjectList<TAuditoriaDTO>);
var
  lIds: TArray<Integer>;
  lNombres: TDictionary<Integer, string>;
  lVistos: TList<Integer>;
  lFila: TAuditoriaDTO;
  lNombre: string;
begin
  lVistos := TList<Integer>.Create;
  try
    for lFila in ALista do
      if lFila.UsuarioId.HasValue and
        (lVistos.IndexOf(lFila.UsuarioId.Value) < 0) then
        lVistos.Add(lFila.UsuarioId.Value);
    lIds := lVistos.ToArray;
  finally
    lVistos.Free;
  end;

  lNombres := fUsuarios.NombresDe(lIds);
  try
    for lFila in ALista do
    begin
      if not lFila.UsuarioId.HasValue then
        lFila.Usuario := USUARIO_SISTEMA
      else if lNombres.TryGetValue(lFila.UsuarioId.Value, lNombre) then
        lFila.Usuario := lNombre
      else
        lFila.Usuario := USUARIO_DESCONOCIDO;
    end;
  finally
    lNombres.Free;
  end;
end;

end.
