unit Anovo.PeriodoBusqueda;

// Periodo de busqueda de los listados: atajo, Desde y Hasta (0 = sin limite)
// y el texto que muestra el boton del periodo.

interface

type
  TAtajoPeriodo = (apTodas, apHoy, apEstaSemana, apEsteMes, apMesAnterior,
    apTresMeses, apEsteAnio, apPersonalizado);

  TPeriodoBusqueda = record
    Desde: TDateTime;
    Hasta: TDateTime;
    Atajo: TAtajoPeriodo;
    class function De(const AAtajo: TAtajoPeriodo): TPeriodoBusqueda;
      overload; static;
    class function De(const AAtajo: TAtajoPeriodo; const AHoy: TDateTime)
      : TPeriodoBusqueda; overload; static;
    class function Personalizado(const ADesde, AHasta: TDateTime)
      : TPeriodoBusqueda; static;
    class function Nombre(const AAtajo: TAtajoPeriodo): string; static;
    function Activo: Boolean;
    function Validar(out AMensaje: string): Boolean;
    function Igual(const AOtro: TPeriodoBusqueda): Boolean;
    function Texto: string;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Anovo.Formato,
  Anovo.Textos;

const
  NOMBRE_ATAJO: array [TAtajoPeriodo] of string = (SPeriodoTodas, SPeriodoHoy,
    SPeriodoEstaSemana, SPeriodoEsteMes, SPeriodoMesAnterior, SPeriodoTresMeses,
    SPeriodoEsteAnio, SPeriodoPersonalizado);

class function TPeriodoBusqueda.De(const AAtajo: TAtajoPeriodo)
  : TPeriodoBusqueda;
begin
  Result := De(AAtajo, Date);
end;

class function TPeriodoBusqueda.De(const AAtajo: TAtajoPeriodo;
  const AHoy: TDateTime): TPeriodoBusqueda;
var
  lHoy: TDateTime;
begin
  lHoy := DateOf(AHoy);
  Result.Atajo := AAtajo;
  Result.Desde := 0;
  Result.Hasta := lHoy;
  case AAtajo of
    apTodas, apPersonalizado:
      begin
        Result.Atajo := apTodas;
        Result.Hasta := 0;
      end;
    apHoy:
      Result.Desde := lHoy;
    apEstaSemana:
      Result.Desde := StartOfTheWeek(lHoy);
    apEsteMes:
      Result.Desde := StartOfTheMonth(lHoy);
    apMesAnterior:
      begin
        Result.Desde := StartOfTheMonth(IncMonth(lHoy, -1));
        Result.Hasta := DateOf(EndOfTheMonth(Result.Desde));
      end;
    apTresMeses:
      Result.Desde := StartOfTheMonth(IncMonth(lHoy, -2));
    apEsteAnio:
      Result.Desde := StartOfTheYear(lHoy);
  end;
end;

class function TPeriodoBusqueda.Personalizado(const ADesde, AHasta: TDateTime)
  : TPeriodoBusqueda;
begin
  Result.Desde := 0;
  Result.Hasta := 0;
  if ADesde > 0 then
    Result.Desde := DateOf(ADesde);
  if AHasta > 0 then
    Result.Hasta := DateOf(AHasta);
  if Result.Activo then
    Result.Atajo := apPersonalizado
  else
    Result.Atajo := apTodas;
end;

class function TPeriodoBusqueda.Nombre(const AAtajo: TAtajoPeriodo): string;
begin
  Result := NOMBRE_ATAJO[AAtajo];
end;

function TPeriodoBusqueda.Activo: Boolean;
begin
  Result := (Desde > 0) or (Hasta > 0);
end;

function TPeriodoBusqueda.Validar(out AMensaje: string): Boolean;
begin
  AMensaje := '';
  Result := (Desde = 0) or (Hasta = 0) or (Desde <= Hasta);
  if not Result then
    AMensaje := SPeriodoInvertido;
end;

function TPeriodoBusqueda.Igual(const AOtro: TPeriodoBusqueda): Boolean;
begin
  Result := (Atajo = AOtro.Atajo) and SameDate(Desde, AOtro.Desde) and
    SameDate(Hasta, AOtro.Hasta);
end;

function TPeriodoBusqueda.Texto: string;
var
  lRango: string;
begin
  if not Activo then
    Exit(SPeriodoTodas);
  if Hasta = 0 then
    Exit(Format(SPeriodoDesde, [TFormato.Fecha(Desde)]));
  if Desde = 0 then
    Exit(Format(SPeriodoHasta, [TFormato.Fecha(Hasta)]));

  if SameDate(Desde, Hasta) then
    lRango := TFormato.Fecha(Hasta)
  else if YearOf(Desde) = YearOf(Hasta) then
    lRango := Format(SPeriodoEntre, [TFormato.DiaMes(Desde),
      TFormato.Fecha(Hasta)])
  else
    lRango := Format(SPeriodoEntre, [TFormato.Fecha(Desde),
      TFormato.Fecha(Hasta)]);

  if Atajo in [apTodas, apPersonalizado] then
    Result := lRango
  else
    Result := Format(SPeriodoConAtajo, [NOMBRE_ATAJO[Atajo], lRango]);
end;

end.
