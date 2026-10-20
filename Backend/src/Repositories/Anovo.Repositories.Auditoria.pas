unit Anovo.Repositories.Auditoria;

// Repositorio de la bitacora de auditoria. Solo lectura; las filas salen de
// V_AUDITORIA, con el nombre del usuario.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Auditoria,
  Anovo.Entities.Auditoria,
  Anovo.Entities.Vistas.Lectura;

type
  TAuditoriaRepository = class(TAnovoRepository<TAuditoria>,
    IAuditoriaRepository)
  private
    function FiltroSegun(const AUsuarioId: Integer;
      const AEntidad, AAccion, ATexto: string): string;
    function ParametrosSegun(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string)
      : TArray<Variant>;
    function FinExclusivo(const AHasta: TDateTime): TDateTime;
  public
    function Buscar(const ADesde, AHasta: TDateTime;
      const APagina, APorPagina: Integer; const AUsuarioId: Integer = 0;
      const AEntidad: string = ''; const AAccion: string = '';
      const ATexto: string = ''): TObjectList<TVAuditoria>;
    function ContarBusqueda(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer = 0; const AEntidad: string = '';
      const AAccion: string = ''; const ATexto: string = ''): Int64;
    function DeLaEntidad(const AEntidad: string; const AEntidadId: Integer)
      : TObjectList<TVAuditoria>;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Anovo.SQL.Auditoria;

function TAuditoriaRepository.Buscar(const ADesde, AHasta: TDateTime;
  const APagina, APorPagina: Integer; const AUsuarioId: Integer;
  const AEntidad, AAccion, ATexto: string): TObjectList<TVAuditoria>;
var
  lDesde, lHasta: Integer;
begin
  lDesde := ((APagina - 1) * APorPagina) + 1;
  lHasta := APagina * APorPagina;

  Result := ListarDonde<TVAuditoria>(FiltroSegun(AUsuarioId, AEntidad,
    AAccion, ATexto) +
    AUDITORIA_ORDEN_Y_PAGINA, ParametrosSegun(ADesde, AHasta, AUsuarioId,
    AEntidad, AAccion, ATexto) + [Variant(lDesde), Variant(lHasta)]);
end;

function TAuditoriaRepository.ContarBusqueda(const ADesde, AHasta: TDateTime;
  const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string): Int64;
begin
  Result := ContarPorFiltro(FiltroSegun(AUsuarioId, AEntidad, AAccion, ATexto),
    ParametrosSegun(ADesde, AHasta, AUsuarioId, AEntidad, AAccion, ATexto));
end;

function TAuditoriaRepository.DeLaEntidad(const AEntidad: string;
  const AEntidadId: Integer): TObjectList<TVAuditoria>;
begin
  Result := ListarDonde<TVAuditoria>(AUDITORIA_DE_ENTIDAD,
    [AEntidad, AEntidadId]);
end;

function TAuditoriaRepository.FiltroSegun(const AUsuarioId: Integer;
  const AEntidad, AAccion, ATexto: string): string;
begin
  Result := AUDITORIA_FILTRO_FECHA;
  if AUsuarioId > 0 then
    Result := Result + AUDITORIA_POR_USUARIO;
  if AEntidad = ENTIDAD_GRUPO_CUENTAS then
    Result := Result + AUDITORIA_DE_CUENTAS
  else if AEntidad <> '' then
    Result := Result + AUDITORIA_POR_ENTIDAD;
  if AAccion <> '' then
    Result := Result + AUDITORIA_POR_ACCION;
  if ATexto <> '' then
    Result := Result + AUDITORIA_POR_TEXTO;
end;

function TAuditoriaRepository.FinExclusivo(const AHasta: TDateTime): TDateTime;
begin
  if Frac(AHasta) = 0 then
    Result := IncDay(AHasta)
  else
    Result := AHasta;
end;

function TAuditoriaRepository.ParametrosSegun(const ADesde, AHasta: TDateTime;
  const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string)
  : TArray<Variant>;
begin
  Result := [Variant(ADesde), Variant(FinExclusivo(AHasta))];
  if AUsuarioId > 0 then
    Result := Result + [Variant(AUsuarioId)];
  if (AEntidad <> '') and (AEntidad <> ENTIDAD_GRUPO_CUENTAS) then
    Result := Result + [Variant(AEntidad)];
  if AAccion <> '' then
    Result := Result + [Variant(AAccion)];
  if ATexto <> '' then
    Result := Result + [Variant(ATexto)];
end;

end.
