unit Anovo.Validacion;

// Validaciones reutilizables, las mismas que Validacion.bas del movil.

interface

type
  TTipoIdentificacion = (tiSinEspecificar, tiFisica, tiJuridica, tiDimex);

  TValidacion = class
  public
    class function Correo(const ATexto: string): Boolean; static;
    class function Telefono(const ATexto: string): Boolean; static;
    class function TelefonoExt(const ATexto: string): Boolean; static;
    class function Identificacion(const ATipo: TTipoIdentificacion;
      const ATexto: string): Boolean; static;
    class function Texto(const ATexto: string): Boolean; static;
    class function TextoMinimo(const ATexto: string;
      const AMinimo: Integer): Boolean; static;
    class function AlgunoConValor(const A, B: string): Boolean; static;
    class function Normalizar(const ATexto: string): string; static;
  end;

const
  TIPOS_IDENTIFICACION: array [TTipoIdentificacion] of string =
    ('', 'Cedula fisica', 'Cedula juridica', 'DIMEX');

const
  LARGO_TELEFONO = 8;
  LARGO_IDENT_FISICA = 9;
  LARGO_IDENT_JURIDICA = 10;
  LARGO_IDENT_DIMEX_MIN = 11;
  LARGO_MINIMO_TEXTO = 3;
  VOCALES_MINIMO = 0.2;

implementation

uses
  System.SysUtils,
  System.Character,
  System.RegularExpressions;

const
  PATRON_CORREO = '(?i)^[a-z0-9!#$%&''*+/=?^_`{|}~-]+' +
    '(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?' +
    '\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])$';

  VOCALES = 'AEIOUÁÉÍÓÚÜ';

function ProporcionVocales(const ATexto: string): Double;
var
  lCaracter: Char;
  lLetras, lVocales: Integer;
begin
  lLetras := 0;
  lVocales := 0;
  for lCaracter in UpperCase(ATexto) do
    if lCaracter.IsLetter then
    begin
      Inc(lLetras);
      if Pos(lCaracter, VOCALES) > 0 then
        Inc(lVocales);
    end;
  if lLetras = 0 then
    Exit(0);
  Result := lVocales / lLetras;
end;

class function TValidacion.Correo(const ATexto: string): Boolean;
begin
  Result := TRegEx.IsMatch(Trim(ATexto), PATRON_CORREO);
end;

class function TValidacion.Normalizar(const ATexto: string): string;
var
  lCaracter: Char;
begin
  Result := '';
  for lCaracter in ATexto do
    if lCaracter.IsLetterOrDigit then
      Result := Result + lCaracter;
end;

class function TValidacion.Telefono(const ATexto: string): Boolean;
begin
  Result := not(Length(Normalizar(ATexto)) <> LARGO_TELEFONO);
end;

class function TValidacion.TelefonoExt(const ATexto: string): Boolean;
begin
  Result := Telefono(ATexto);
end;

class function TValidacion.Identificacion(const ATipo: TTipoIdentificacion;
  const ATexto: string): Boolean;
var
  lLargo: Integer;
begin
  lLargo := Length(Normalizar(ATexto));
  case ATipo of
    tiFisica:
      Result := lLargo >= LARGO_IDENT_FISICA;
    tiJuridica:
      Result := lLargo >= LARGO_IDENT_JURIDICA;
    tiDimex:
      Result := lLargo >= LARGO_IDENT_DIMEX_MIN;
  else
    Result := lLargo >= LARGO_MINIMO_TEXTO;
  end;
end;

class function TValidacion.Texto(const ATexto: string): Boolean;
var
  lTexto: string;
begin
  lTexto := Trim(ATexto);
  Result := (Length(lTexto) >= LARGO_MINIMO_TEXTO) and
    (ProporcionVocales(lTexto) >= VOCALES_MINIMO);
end;

class function TValidacion.TextoMinimo(const ATexto: string;
  const AMinimo: Integer): Boolean;
begin
  Result := Length(Trim(ATexto)) >= AMinimo;
end;

class function TValidacion.AlgunoConValor(const A, B: string): Boolean;
begin
  Result := (Trim(A) <> '') or (Trim(B) <> '');
end;

end.
