unit Anovo.Repositories.Base;

// Base de los repositorios: TMVCRepository<T> mas vistas, consultas con
// nombre y duplicados; solo aqui se llama a TMVCActiveRecord.

interface

uses
  System.Generics.Collections,
  System.Variants,
  MVCFramework.ActiveRecord,
  MVCFramework.Repository;

const
  MAXIMO_FILAS = 1000;

type
  TAnovoRepository<T: TMVCActiveRecord, constructor> = class(TMVCRepository<T>)

  protected
    function SelectConOpciones(const SQL: string;
      const Params: array of Variant;
      const Options: TMVCActiveRecordLoadOptions): TObjectList<T>;
    function SelectVista<V: TMVCActiveRecord, constructor>(const SQL: string;
      const Params: array of Variant): TObjectList<V>;
    function SelectUnaVista<V: TMVCActiveRecord, constructor>(
      const SQL: string; const Params: array of Variant): V;
    function HayOtroCon(const SQL, AValor: string;
      const AExcluirId: Integer): Boolean;
    function SelectNombrada<V: TMVCActiveRecord, constructor>(
      const ANombre: string; const AValores: array of const;
      const AMaximo: Integer = MAXIMO_FILAS): TObjectList<V>;
    function ContarNombrada<V: TMVCActiveRecord, constructor>(
      const ANombre: string; const AValores: array of const): Int64;
    function UnaNombrada<V: TMVCActiveRecord, constructor>(
      const ANombre: string; const AValores: array of const): V;
    function LeerUna<V: TMVCActiveRecord, constructor>: V;
  public
    class function Buscado(const ATexto: string): string; static;
  end;

implementation

function TAnovoRepository<T>.SelectConOpciones(const SQL: string;
  const Params: array of Variant; const Options: TMVCActiveRecordLoadOptions)
  : TObjectList<T>;
begin
  Result := TMVCActiveRecord.Select<T>(SQL, Params, Options);
end;

function TAnovoRepository<T>.SelectVista<V>(const SQL: string;
  const Params: array of Variant): TObjectList<V>;
begin
  Result := TMVCActiveRecord.Select<V>(SQL, Params);
end;

function TAnovoRepository<T>.SelectUnaVista<V>(const SQL: string;
  const Params: array of Variant): V;
begin
  Result := TMVCActiveRecord.SelectOne<V>(SQL, Params, True);
end;

function TAnovoRepository<T>.HayOtroCon(const SQL, AValor: string;
  const AExcluirId: Integer): Boolean;
var
  lId: Variant;
begin
  lId := TMVCActiveRecord.CurrentConnection.ExecSQLScalar(SQL,
    [AValor, AExcluirId]);
  Result := not VarIsNull(lId);
end;

function TAnovoRepository<T>.SelectNombrada<V>(const ANombre: string;
  const AValores: array of const; const AMaximo: Integer): TObjectList<V>;
begin
  Result := TMVCActiveRecord.SelectRQLByNamedQuery<V>(ANombre, AValores,
    AMaximo);
end;

function TAnovoRepository<T>.ContarNombrada<V>(const ANombre: string;
  const AValores: array of const): Int64;
begin
  Result := TMVCActiveRecord.CountRQLByNamedQuery<V>(ANombre, AValores);
end;

function TAnovoRepository<T>.UnaNombrada<V>(const ANombre: string;
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

function TAnovoRepository<T>.LeerUna<V>: V;
begin
  Result := TMVCActiveRecord.SelectOneByRQL<V>('', True);
end;

class function TAnovoRepository<T>.Buscado(const ATexto: string): string;
begin
  Result := ATexto.Trim;
  while Result.EndsWith('\') do
    Result := Result.Substring(0, Result.Length - 1);
  Result := Result.Replace('"', '\"');
end;

end.
