unit Anovo.Repositories.Base;

// Base de los repositorios: TMVCRepository<T> mas un Select
// con opciones de carga.

interface

uses
  System.Generics.Collections,
  MVCFramework.ActiveRecord,
  MVCFramework.Repository;

type
  TAnovoRepository<T: TMVCActiveRecord, constructor> = class(TMVCRepository<T>)

  protected
    function SelectConOpciones(const SQL: string;
      const Params: array of Variant;
      const Options: TMVCActiveRecordLoadOptions): TObjectList<T>;
  end;

implementation

function TAnovoRepository<T>.SelectConOpciones(const SQL: string;
  const Params: array of Variant; const Options: TMVCActiveRecordLoadOptions)
  : TObjectList<T>;
begin
  Result := TMVCActiveRecord.Select<T>(SQL, Params, Options);
end;

end.
