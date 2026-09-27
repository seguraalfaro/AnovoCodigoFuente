unit Anovo.Repositories.Base;

// Base de los repositorios: TMVCRepository<T> mas vistas y
// duplicados; solo aqui se llama a TMVCActiveRecord.

interface

uses
  System.Generics.Collections,
  System.Variants,
  MVCFramework.ActiveRecord,
  MVCFramework.Repository;

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

end.
