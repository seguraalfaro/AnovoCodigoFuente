unit Anovo.Repositories.Auditoria;

// Repositorio de la bitacora de auditoria. Solo lee.
//
// Desciende de TAnovoRepository<TAuditoria> porque de ahi sale la conexion y
// el armado del SELECT, pero el contrato que publica -IAuditoriaRepository- no
// tiene Insert ni Update: sobre AUDITORIA el backend tiene GRANT SELECT y nada
// mas, y quien escribe es el disparador.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Auditoria,
  Anovo.Entities.Auditoria;

type
  TAuditoriaRepository = class(TAnovoRepository<TAuditoria>,
    IAuditoriaRepository)
  private
    function FiltroSegun(const AUsuarioId: Integer;
      const AEntidad, AAccion, ATexto: string): string;
    function ParametrosSegun(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string)
      : TArray<Variant>;
    // El fin del dia cuando solo viene la fecha, ver el comentario de Buscar.
    function HastaElFinal(const AHasta: TDateTime): TDateTime;
  public
    function Buscar(const ADesde, AHasta: TDateTime;
      const APagina, APorPagina: Integer; const AUsuarioId: Integer = 0;
      const AEntidad: string = ''; const AAccion: string = '';
      const ATexto: string = ''): TObjectList<TAuditoria>;
    function ContarBusqueda(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer = 0; const AEntidad: string = '';
      const AAccion: string = ''; const ATexto: string = ''): Int64;
    function DeLaEntidad(const AEntidad: string; const AEntidadId: Integer)
      : TObjectList<TAuditoria>;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Anovo.SQL.Auditoria;

{ TAuditoriaRepository }

function TAuditoriaRepository.Buscar(const ADesde, AHasta: TDateTime;
  const APagina, APorPagina: Integer; const AUsuarioId: Integer;
  const AEntidad, AAccion, ATexto: string): TObjectList<TAuditoria>;
var
  lDesde, lHasta: Integer;
begin
  lDesde := ((APagina - 1) * APorPagina) + 1;
  lHasta := APagina * APorPagina;

  Result := GetWhere(FiltroSegun(AUsuarioId, AEntidad, AAccion, ATexto) +
    AUDITORIA_ORDEN_Y_PAGINA, ParametrosSegun(ADesde, AHasta, AUsuarioId,
    AEntidad, AAccion, ATexto) + [Variant(lDesde), Variant(lHasta)]);
end;

function TAuditoriaRepository.ContarBusqueda(const ADesde, AHasta: TDateTime;
  const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string): Int64;
begin
  // Count del repositorio solo acepta RQL: el total va por la conexion.
  Result := GetConnection.ExecSQLScalar(AUDITORIA_CONTAR +
    FiltroSegun(AUsuarioId, AEntidad, AAccion, ATexto),
    ParametrosSegun(ADesde, AHasta, AUsuarioId, AEntidad, AAccion, ATexto));
end;

function TAuditoriaRepository.DeLaEntidad(const AEntidad: string;
  const AEntidadId: Integer): TObjectList<TAuditoria>;
begin
  Result := GetWhere(AUDITORIA_DE_ENTIDAD, [AEntidad, AEntidadId]);
end;

function TAuditoriaRepository.FiltroSegun(const AUsuarioId: Integer;
  const AEntidad, AAccion, ATexto: string): string;
begin
  Result := AUDITORIA_FILTRO_FECHA;
  if AUsuarioId > 0 then
    Result := Result + AUDITORIA_POR_USUARIO;
  if AEntidad <> '' then
    Result := Result + AUDITORIA_POR_ENTIDAD;
  if AAccion <> '' then
    Result := Result + AUDITORIA_POR_ACCION;
  if ATexto <> '' then
    Result := Result + AUDITORIA_POR_TEXTO;
end;

// FECHA es un TIMESTAMP. Si quien llama manda el 20 de setiembre a secas, eso
// son las cero horas y el BETWEEN deja fuera todo lo del propio dia. Cuando
// AHasta no trae hora se asume el final de ese dia, que es lo que la persona
// quiso decir al escoger la fecha en la pantalla.
function TAuditoriaRepository.HastaElFinal(const AHasta: TDateTime): TDateTime;
begin
  if Frac(AHasta) = 0 then
    Result := EndOfTheDay(AHasta)
  else
    Result := AHasta;
end;

function TAuditoriaRepository.ParametrosSegun(const ADesde, AHasta: TDateTime;
  const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string)
  : TArray<Variant>;
begin
  // En el mismo orden en que FiltroSegun pone los ?.
  Result := [Variant(ADesde), Variant(HastaElFinal(AHasta))];
  if AUsuarioId > 0 then
    Result := Result + [Variant(AUsuarioId)];
  if AEntidad <> '' then
    Result := Result + [Variant(AEntidad)];
  if AAccion <> '' then
    Result := Result + [Variant(AAccion)];
  if ATexto <> '' then
    Result := Result + [Variant(ATexto)];
end;

end.
