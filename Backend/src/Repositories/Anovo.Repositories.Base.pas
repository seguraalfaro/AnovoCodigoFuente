unit Anovo.Repositories.Base;

// Base de los repositorios del proyecto: TMVCRepository<T> mas lo que le
// falta.
//
// Hoy le falta una cosa: los Select del repositorio de DMVC no reciben
// TMVCActiveRecordLoadOptions, asi que una consulta que nombra sus columnas
// para dejar alguna fuera (un BLOB en un listado) falla al cargar, porque la
// entidad espera todas. Aqui se agrega sin tocar el fuente del framework.
//
// Es protected: la usa cada repositorio por dentro, el servicio no la ve.

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
