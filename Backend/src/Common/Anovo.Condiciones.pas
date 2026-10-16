unit Anovo.Condiciones;

// Plazo de entrega y garantia como cantidad + unidad (migracion 43): los
// codigos de la base, su texto y la regla de que van juntos. Compartido.

interface

uses
  MVCFramework.Nullables;

const
  UNIDAD_DIAS = 'dias';
  UNIDAD_DIAS_HABILES = 'dias_habiles';
  UNIDAD_SEMANAS = 'semanas';
  UNIDAD_MESES = 'meses';
  UNIDAD_ANIOS = 'anios';
  UNIDADES_PLAZO: array [0 .. 4] of string = (UNIDAD_DIAS, UNIDAD_DIAS_HABILES,
    UNIDAD_SEMANAS, UNIDAD_MESES, UNIDAD_ANIOS);
  PLAZO_MAXIMO = 999;

function UnidadPlazoValida(const ACodigo: string): Boolean;
function NombreUnidadPlazo(const ACodigo: string;
  const ACantidad: Integer = 2): string;
function PlazoValido(const ACantidad: NullableInt32;
  const AUnidad: NullableString): Boolean;
function TextoPlazo(const ACantidad: NullableInt32;
  const AUnidad: NullableString): string;
function ErrorDePlazos(const AEntregaCantidad: NullableInt32;
  const AEntregaUnidad: NullableString; const AGarantiaCantidad: NullableInt32;
  const AGarantiaUnidad: NullableString): string;
function UnidadONula(const AUnidad: NullableString): NullableString;
function ACorto(const AValor: NullableInt32): NullableInt16;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  Anovo.Textos;

function UnidadPlazoValida(const ACodigo: string): Boolean;
var
  lUnidad: string;
begin
  for lUnidad in UNIDADES_PLAZO do
    if lUnidad = ACodigo then
      Exit(True);
  Result := False;
end;

function NombreUnidadPlazo(const ACodigo: string;
  const ACantidad: Integer): string;
var
  lUna: Boolean;
begin
  lUna := ACantidad = 1;
  if ACodigo = UNIDAD_DIAS then
    Result := IfThen(lUna, SUnidadDia, SUnidadDias)
  else if ACodigo = UNIDAD_DIAS_HABILES then
    Result := IfThen(lUna, SUnidadDiaHabil, SUnidadDiasHabiles)
  else if ACodigo = UNIDAD_SEMANAS then
    Result := IfThen(lUna, SUnidadSemana, SUnidadSemanas)
  else if ACodigo = UNIDAD_MESES then
    Result := IfThen(lUna, SUnidadMes, SUnidadMeses)
  else if ACodigo = UNIDAD_ANIOS then
    Result := IfThen(lUna, SUnidadAnio, SUnidadAnios)
  else
    Result := ACodigo;
end;

function PlazoValido(const ACantidad: NullableInt32;
  const AUnidad: NullableString): Boolean;
var
  lUnidad: string;
begin
  lUnidad := AUnidad.ValueOrDefault.Trim;
  if not ACantidad.HasValue and lUnidad.IsEmpty then
    Exit(True);
  Result := ACantidad.HasValue and (ACantidad.Value > 0) and
    (ACantidad.Value <= PLAZO_MAXIMO) and UnidadPlazoValida(lUnidad);
end;

function TextoPlazo(const ACantidad: NullableInt32;
  const AUnidad: NullableString): string;
begin
  if not ACantidad.HasValue or AUnidad.ValueOrDefault.IsEmpty then
    Exit('');
  Result := Format('%d %s', [ACantidad.Value,
    NombreUnidadPlazo(AUnidad.Value, ACantidad.Value)]);
end;

function ErrorDePlazos(const AEntregaCantidad: NullableInt32;
  const AEntregaUnidad: NullableString; const AGarantiaCantidad: NullableInt32;
  const AGarantiaUnidad: NullableString): string;
begin
  if not PlazoValido(AEntregaCantidad, AEntregaUnidad) then
    Exit(Format(SPlazoEntregaInvalido, [PLAZO_MAXIMO]));
  if not PlazoValido(AGarantiaCantidad, AGarantiaUnidad) then
    Exit(Format(SGarantiaInvalida, [PLAZO_MAXIMO]));
  Result := '';
end;

function UnidadONula(const AUnidad: NullableString): NullableString;
begin
  if AUnidad.ValueOrDefault.Trim.IsEmpty then
    Result.Clear
  else
    Result := AUnidad.Value.Trim;
end;

function ACorto(const AValor: NullableInt32): NullableInt16;
begin
  if AValor.HasValue then
    Result := Int16(AValor.Value)
  else
    Result.Clear;
end;

end.
