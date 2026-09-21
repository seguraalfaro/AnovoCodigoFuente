unit Anovo.Formato;

// Da formato a lo que se escribe, con las mismas mascaras que Formato.bas del
// movil: 2440-8812, 2440-8812 ext 423, 3-101-284719, 155-812345678.
//
// Las funciones son puras -entra texto y sale texto-, sin VCL ni controles:
// asi se prueban solas y las usa cualquier pantalla. Quien las llama decide
// cuando aplicarlas, al escribir o al salir del campo.
//
// El formato es de la pantalla, no del dato: a la API el valor viaja
// normalizado con TValidacion.Normalizar, porque si el movil manda con
// guiones y el escritorio sin ellos, al sincronizar se duplican los clientes.

interface

uses
  Anovo.Validacion;

type
  TFormato = class
  public
    // 2440-8812. Corta en ocho digitos, como el movil.
    class function Telefono(const ATexto: string): string; static;
    // 2440-8812 ext 423. Hasta catorce digitos: ocho del numero y seis de la
    // extension.
    class function TelefonoExt(const ATexto: string): string; static;
    // Segun el tipo: la fisica va sin guiones, la juridica 3-101-284719 y el
    // DIMEX 1-55812-345678.
    class function Identificacion(const ATexto: string;
      const ATipo: TTipoIdentificacion): string; static;
    class function SoloDigitos(const ATexto: string): string; static;
    // La juridica pasa a alfanumerica (3-101-A00001) a finales de 2026, por
    // eso aqui no se filtran solo digitos.
    class function SoloAlfanumerico(const ATexto: string): string; static;
    // El correo no pasa por SoloAlfanumerico: se comeria la arroba y el punto.
    class function Correo(const ATexto: string): string; static;
  end;

const
  LARGO_IDENT_DIMEX = 12;
  LARGO_TELEFONO_EXT = 14;

implementation

uses
  System.SysUtils,
  System.Character,
  System.Math;

class function TFormato.SoloDigitos(const ATexto: string): string;
var
  lCaracter: Char;
begin
  Result := '';
  for lCaracter in ATexto do
    if lCaracter.IsDigit then
      Result := Result + lCaracter;
end;

class function TFormato.SoloAlfanumerico(const ATexto: string): string;
var
  lCaracter: Char;
begin
  Result := '';
  for lCaracter in UpperCase(ATexto) do
    if lCaracter.IsLetterOrDigit then
      Result := Result + lCaracter;
end;

class function TFormato.Correo(const ATexto: string): string;
begin
  Result := LowerCase(Trim(ATexto));
end;

class function TFormato.Telefono(const ATexto: string): string;
var
  lDigitos: string;
begin
  lDigitos := Copy(SoloDigitos(ATexto), 1, LARGO_TELEFONO);
  if Length(lDigitos) > 4 then
    Result := Copy(lDigitos, 1, 4) + '-' + Copy(lDigitos, 5, MaxInt)
  else
    Result := lDigitos;
end;

class function TFormato.TelefonoExt(const ATexto: string): string;
var
  lDigitos: string;
begin
  lDigitos := Copy(SoloDigitos(ATexto), 1, LARGO_TELEFONO_EXT);
  Result := lDigitos;
  if Length(lDigitos) > 4 then
    Result := Copy(lDigitos, 1, 4) + '-' +
      Copy(lDigitos, 5, Min(4, Length(lDigitos) - 4));
  if Length(lDigitos) > 8 then
    Result := Result + ' ext ' + Copy(lDigitos, 9, MaxInt);
end;

class function TFormato.Identificacion(const ATexto: string;
  const ATipo: TTipoIdentificacion): string;
var
  lValor: string;
begin
  case ATipo of
    tiFisica:
      Result := Copy(SoloDigitos(ATexto), 1, LARGO_IDENT_FISICA);

    tiJuridica:
      begin
        lValor := Copy(SoloAlfanumerico(ATexto), 1, LARGO_IDENT_JURIDICA);
        Result := lValor;
        if Length(lValor) > 1 then
          Result := Copy(lValor, 1, 1) + '-' +
            Copy(lValor, 2, Min(3, Length(lValor) - 1));
        if Length(lValor) > 4 then
          Result := Result + '-' + Copy(lValor, 5, MaxInt);
      end;

    tiDimex:
      begin
        lValor := Copy(SoloDigitos(ATexto), 1, LARGO_IDENT_DIMEX);
        Result := lValor;
        if Length(lValor) > 1 then
          Result := Copy(lValor, 1, 1) + '-' +
            Copy(lValor, 2, Min(4, Length(lValor) - 1));
        if Length(lValor) > 5 then
          Result := Result + '-' + Copy(lValor, 6, MaxInt);
      end;
  else
    // Sin tipo elegido no hay mascara que aplicar.
    Result := ATexto;
  end;
end;

end.
