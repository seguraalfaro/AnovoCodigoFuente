unit Anovo.Validacion;

// Validaciones reutilizables, las mismas que Validacion.bas del movil.
//
// Sin VCL y sin base de datos a proposito: devuelven si el valor sirve o no, y
// quien llama decide que hacer con eso. Asi las usa un formulario, un
// presentador o una prueba con DUnitX sin abrir ninguna ventana.
//
// Los largos y el patron del correo son los del movil, no otros: si el
// escritorio aceptara un telefono de seis digitos y el telefono no, el mismo
// cliente entraria distinto segun por donde se registre.

interface

type
  // Los mismos tres valores que el CHECK de CLIENTES y el combo del movil.
  TTipoIdentificacion = (tiSinEspecificar, tiFisica, tiJuridica, tiDimex);

  TValidacion = class
  public
    // Forma del correo, no que el dominio exista.
    class function Correo(const ATexto: string): Boolean; static;
    // Ocho digitos, como en Costa Rica. Los guiones y espacios no cuentan.
    class function Telefono(const ATexto: string): Boolean; static;
    // Con extension: el numero sigue siendo de ocho y la extension es
    // opcional, igual que RevisarTelefonoExt del movil.
    class function TelefonoExt(const ATexto: string): Boolean; static;
    // El largo depende del tipo: 9 la fisica, 10 la juridica, 11 el DIMEX.
    class function Identificacion(const ATipo: TTipoIdentificacion;
      const ATexto: string): Boolean; static;
    // Texto con sentido: largo minimo y una proporcion de vocales que
    // descarta el teclazo suelto, como 'asdf'.
    class function Texto(const ATexto: string): Boolean; static;
    class function TextoMinimo(const ATexto: string;
      const AMinimo: Integer): Boolean; static;
    // Al menos uno de los dos con contenido: telefono o correo, por ejemplo.
    class function AlgunoConValor(const A, B: string): Boolean; static;
    // Lo que se guarda y se manda a la API: solo digitos y letras. Si el
    // movil manda con guiones y el escritorio sin ellos, al sincronizar se
    // duplican los clientes.
    class function Normalizar(const ATexto: string): string; static;
  end;

const
  // Los mismos rotulos del movil (Utils.TiposIdent). El indice es el valor
  // que guarda la columna: 1 fisica, 2 juridica, 3 DIMEX, que es lo que
  // admite CK_CLIENTES_TIPO_IDENT. El cero no se guarda: sin tipo elegido la
  // columna va nula.
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
  // RFC 5322 simplificada, la misma cadena que PATRON_CORREO del movil.
  PATRON_CORREO = '(?i)^[a-z0-9!#$%&''*+/=?^_`{|}~-]+' +
    '(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?' +
    '\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])$';

  VOCALES = 'AEIOUÁÉÍÓÚÜ';

// Cuanto de lo escrito son vocales. Un nombre real anda por 0.4; 'asdf' da 0.
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
    // Sin tipo no hay largo que exigir: basta con que no sea un teclazo.
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
