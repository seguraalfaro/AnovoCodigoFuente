unit Anovo.Repositories.Base;

// Base de los repositorios: TMVCRepository<T> mas vistas, consultas con
// nombre, conteos, duplicados y variables de la sesion que leen las vistas;
// solo aqui se llama a TMVCActiveRecord.

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  MVCFramework.ActiveRecord,
  MVCFramework.Nullables,
  MVCFramework.Repository;

const
  MAXIMO_FILAS = 1000;
  SIN_LIMITE = -1;
  CONTAR_POR_FILTRO = 'select count(*) from %s where %s';
  FILTRO_NOMBRE_DUPLICADO = 'UPPER(NOMBRE) = UPPER(?) AND ID <> ?';
  FIJAR_CONTEXTO =
    'select rdb$set_context(''USER_SESSION'', ?, ?) from rdb$database';

type
  TAnovoRepository<T: TMVCActiveRecord, constructor> = class(TMVCRepository<T>)

  protected
    function ContarPorFiltro(const AFiltro: string;
      const AParams: array of Variant): Int64;
    function NombreDuplicado(const ANombre: string;
      const AExcluirId: Integer): Boolean;
    function ListarConsulta<V: TMVCActiveRecord, constructor>(
      const ANombre: string; const AValores: array of const;
      const AMaximo: Integer = MAXIMO_FILAS): TObjectList<V>;
    function ContarConsulta<V: TMVCActiveRecord, constructor>(
      const ANombre: string; const AValores: array of const): Int64;
    function PrimeraFilaDeConsulta<V: TMVCActiveRecord, constructor>(
      const ANombre: string; const AValores: array of const): V;
    function LeerVistaUnica<V: TMVCActiveRecord, constructor>: V;
    procedure FijarContexto(const AVariable, AValor: string);
  public
    function ParaBajar(const ADesde: NullableTDateTime;
      const AConUuid: Boolean = False): TObjectList<T>;
    class function TextoParaRQL(const ATexto: string): string; static;
    class function FechaParaRQL(const AFecha: TDateTime): string; static;
    class function FechaHoraParaRQL(const AFecha: TDateTime): string; static;
  end;

implementation

uses
  Anovo.SQL.Sincronizacion;

function TAnovoRepository<T>.ParaBajar(const ADesde: NullableTDateTime;
  const AConUuid: Boolean): TObjectList<T>;
var
  lPrefijo: string;
begin
  lPrefijo := '';
  if AConUuid then
    lPrefijo := BAJADA_CON_UUID;
  if ADesde.HasValue then
    Result := GetWhere(lPrefijo + BAJADA_DESDE, [ADesde.Value])
  else
    Result := GetWhere(lPrefijo + BAJADA_COMPLETA, []);
end;

function TAnovoRepository<T>.ContarPorFiltro(const AFiltro: string;
  const AParams: array of Variant): Int64;
var
  lEntidad: T;
begin
  lEntidad := T.Create;
  try
    Result := TMVCActiveRecord.CurrentConnection.ExecSQLScalar
      (Format(CONTAR_POR_FILTRO, [lEntidad.TableName, AFiltro]), AParams);
  finally
    lEntidad.Free;
  end;
end;

function TAnovoRepository<T>.NombreDuplicado(const ANombre: string;
  const AExcluirId: Integer): Boolean;
begin
  Result := ContarPorFiltro(FILTRO_NOMBRE_DUPLICADO, [ANombre, AExcluirId]) > 0;
end;

function TAnovoRepository<T>.ListarConsulta<V>(const ANombre: string;
  const AValores: array of const; const AMaximo: Integer): TObjectList<V>;
begin
  Result := TMVCActiveRecord.SelectRQLByNamedQuery<V>(ANombre, AValores,
    AMaximo);
end;

function TAnovoRepository<T>.ContarConsulta<V>(const ANombre: string;
  const AValores: array of const): Int64;
begin
  Result := TMVCActiveRecord.CountRQLByNamedQuery<V>(ANombre, AValores);
end;

function TAnovoRepository<T>.PrimeraFilaDeConsulta<V>(const ANombre: string;
  const AValores: array of const): V;
var
  lLista: TObjectList<V>;
begin
  lLista := TMVCActiveRecord.SelectRQLByNamedQuery<V>(ANombre, AValores, 1);
  try
    if lLista.Count = 0 then
      Exit(nil);
    Result := lLista.Extract(lLista[0]);
  finally
    lLista.Free;
  end;
end;

function TAnovoRepository<T>.LeerVistaUnica<V>: V;
begin
  Result := TMVCActiveRecord.SelectOneByRQL<V>('', True);
end;

procedure TAnovoRepository<T>.FijarContexto(const AVariable, AValor: string);
begin
  TMVCActiveRecord.CurrentConnection.ExecSQLScalar(FIJAR_CONTEXTO,
    [AVariable, AValor]);
end;

class function TAnovoRepository<T>.FechaParaRQL(const AFecha: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd', AFecha, TFormatSettings.Invariant);
end;

class function TAnovoRepository<T>.FechaHoraParaRQL(const AFecha: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', AFecha,
    TFormatSettings.Invariant);
end;

class function TAnovoRepository<T>.TextoParaRQL(const ATexto: string): string;
begin
  Result := ATexto.Trim;
  while Result.EndsWith('\') do
    Result := Result.Substring(0, Result.Length - 1);
  Result := Result.Replace('"', '\"');
end;

end.
