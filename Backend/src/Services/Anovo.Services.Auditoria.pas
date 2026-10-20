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
  Anovo.Entities.Vistas.Lectura,
  Anovo.Services.Intf.Auditoria;

type
  TAuditoriaService = class(TInterfacedObject, IAuditoriaService)
  private
    fRepo: IAuditoriaRepository;
    function AListaDto(const AEntidades: TObjectList<TVAuditoria>)
      : TObjectList<TAuditoriaDTO>;
    function EntidadSegun(const AAlcance: TAlcanceAuditoria;
      const AEntidad: string): string;
  public
    [MVCInject]
    constructor Create(ARepo: IAuditoriaRepository); reintroduce;

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


constructor TAuditoriaService.Create(ARepo: IAuditoriaRepository);
begin
  inherited Create;
  fRepo := ARepo;
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
    Exit(ENTIDAD_GRUPO_CUENTAS);
  if not MatchStr(lEntidad, [ENTIDAD_GRUPO_CUENTAS, ENTIDAD_USUARIOS,
    ENTIDAD_USUARIOS_CLAVES, ENTIDAD_ROLES_PERMISOS,
    ENTIDAD_USUARIOS_PERMISOS]) then
    raise ESinPermiso.Create(SAuditoriaSoloCuentas);
  Result := lEntidad;
end;

function TAuditoriaService.Buscar(const AAlcance: TAlcanceAuditoria;
  const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer;
  const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string;
  out ATotal: Int64): TObjectList<TAuditoriaDTO>;
var
  lEntidades: TObjectList<TVAuditoria>;
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
  lEntidades: TObjectList<TVAuditoria>;
begin
  lEntidades := fRepo.DeLaEntidad(UpperCase(Trim(AEntidad)), AEntidadId);
  try
    Result := AListaDto(lEntidades);
  finally
    lEntidades.Free;
  end;
end;

function TAuditoriaService.AListaDto(const AEntidades
  : TObjectList<TVAuditoria>): TObjectList<TAuditoriaDTO>;
var
  I: Integer;
begin
  Result := TMapeo.AListaDto<TVAuditoria, TAuditoriaDTO>(AEntidades);
  for I := 0 to Result.Count - 1 do
    if not AEntidades[I].UsuarioId.HasValue then
      Result[I].Usuario := SUsuarioSistema
    else if AEntidades[I].UsuarioNombre.ValueOrDefault = '' then
      Result[I].Usuario := SUsuarioEliminado
    else
      Result[I].Usuario := AEntidades[I].UsuarioNombre.Value;
end;

end.
