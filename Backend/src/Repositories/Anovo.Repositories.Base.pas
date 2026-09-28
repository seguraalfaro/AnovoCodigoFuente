unit Anovo.Repositories.Base;

// Base de los repositorios: TMVCRepository<T> mas vistas, consultas con
// nombre, conteos y duplicados; solo aqui se llama a TMVCActiveRecord.

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  MVCFramework.ActiveRecord,
  MVCFramework.Repository;

const
  MAXIMO_FILAS = 1000;
  SIN_LIMITE = -1;
  CONTAR_POR_FILTRO = 'select count(*) from %s where %s';
  FILTRO_NOMBRE_DUPLICADO = 'UPPER(NOMBRE) = UPPER(?) AND ID <> ?';

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
  public
    class function TextoParaRQL(const ATexto: string): string; static;
    class function FechaParaRQL(const AFecha: TDateTime): string; static;
  end;

implementation

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

class function TAnovoRepository<T>.FechaParaRQL(const AFecha: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd', AFecha);
end;

class function TAnovoRepository<T>.TextoParaRQL(const ATexto: string): string;
begin
  Result := ATexto.Trim;
  while Result.EndsWith('\') do
    Result := Result.Substring(0, Result.Length - 1);
  Result := Result.Replace('"', '\"');
end;

end.
