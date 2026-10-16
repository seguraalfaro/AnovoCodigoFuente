unit Anovo.Periodo;

// Periodo de busqueda con fechas opcionales: sin desde no hay limite inicial,
// sin hasta no hay limite final, y el fin es el dia siguiente al hasta.

interface

type
  TPeriodo = record
    Inicio: TDateTime;
    Fin: TDateTime;
    class function De(const ADesde, AHasta: TDateTime): TPeriodo; static;
    function Activo: Boolean;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Anovo.Errors,
  Anovo.Textos;

const
  SIN_LIMITE_INICIO = 36526;
  SIN_LIMITE_FIN = 73051;

class function TPeriodo.De(const ADesde, AHasta: TDateTime): TPeriodo;
begin
  if (ADesde > 0) and (AHasta > 0) and (Trunc(ADesde) > Trunc(AHasta)) then
    raise EDatoInvalido.Create(SPeriodoInvertido);

  Result.Inicio := 0;
  Result.Fin := 0;
  if (ADesde <= 0) and (AHasta <= 0) then
    Exit;

  Result.Inicio := SIN_LIMITE_INICIO;
  if ADesde > 0 then
    Result.Inicio := Trunc(ADesde);
  Result.Fin := SIN_LIMITE_FIN;
  if AHasta > 0 then
    Result.Fin := IncDay(Trunc(AHasta));
end;

function TPeriodo.Activo: Boolean;
begin
  Result := Fin > 0;
end;

end.
