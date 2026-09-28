unit Anovo.Formato;

// Formato de telefonos, identificaciones, estados, fechas y montos.
// Mismas mascaras que Formato.bas del movil.

interface

uses
  Anovo.Validacion;

type
  TFormato = class
  public
    class function Telefono(const ATexto: string): string; static;
    class function TelefonoExt(const ATexto: string): string; static;
    class function Identificacion(const ATexto: string;
      const ATipo: TTipoIdentificacion): string; static;
    class function SoloDigitos(const ATexto: string): string; static;
    class function SoloAlfanumerico(const ATexto: string): string; static;
    class function Correo(const ATexto: string): string; static;

    class function Estado(const AValor: string): string; static;
    class function Magnitud(const AValor: string): string; static;
    class function MesAnio(const AFecha: TDateTime): string; static;
    class function Colones(const AMonto: Currency): string; static;
    class function Dias(const ADias: Integer): string; static;
    class function FechaHora(const AFecha: TDateTime): string; static;
  end;

const
  LARGO_IDENT_DIMEX = 12;
  LARGO_TELEFONO_EXT = 14;

implementation

uses
  System.SysUtils,
  System.Character,
  System.Math,
  System.DateUtils,
  System.StrUtils,
  Anovo.DTOs.Catalogos,
  Anovo.Textos;

class function TFormato.Magnitud(const AValor: string): string;
begin
  case IndexStr(AValor, [MAGNITUD_TIEMPO, MAGNITUD_PESO, MAGNITUD_LONGITUD,
    MAGNITUD_AREA, MAGNITUD_VOLUMEN, MAGNITUD_UNIDADES]) of
    0: Result := SMagnitudTiempo;
    1: Result := SMagnitudPeso;
    2: Result := SMagnitudLongitud;
    3: Result := SMagnitudArea;
    4: Result := SMagnitudVolumen;
    5: Result := SMagnitudUnidades;
  else
    Result := AValor;
  end;
end;

class function TFormato.Estado(const AValor: string): string;
var
  lValor: string;
begin
  lValor := LowerCase(Trim(AValor));
  if lValor = 'capturada' then
    Result := SEstCapturada
  else if lValor = 'recibida' then
    Result := SEstRecibida
  else if lValor = 'en_cotizacion' then
    Result := SEstEnCotizacion
  else if lValor = 'descartada' then
    Result := SEstDescartada
  else if lValor = 'borrador' then
    Result := SEstBorrador
  else if lValor = 'pendiente' then
    Result := SEstPendiente
  else if lValor = 'aprobada' then
    Result := SEstAprobada
  else if lValor = 'rechazada' then
    Result := SEstRechazada
  else if lValor = 'enviada' then
    Result := SEstEnviada
  else if lValor = '' then
    Result := ''
  else
    Result := UpperCase(lValor[1]) + Copy(lValor, 2, MaxInt);
end;

class function TFormato.MesAnio(const AFecha: TDateTime): string;
var
  lMes: string;
begin
  case MonthOf(AFecha) of
    1: lMes := SMesEnero;
    2: lMes := SMesFebrero;
    3: lMes := SMesMarzo;
    4: lMes := SMesAbril;
    5: lMes := SMesMayo;
    6: lMes := SMesJunio;
    7: lMes := SMesJulio;
    8: lMes := SMesAgosto;
    9: lMes := SMesSetiembre;
    10: lMes := SMesOctubre;
    11: lMes := SMesNoviembre;
    12: lMes := SMesDiciembre;
  else
    lMes := '';
  end;
  Result := Format(SMesAnio, [lMes, YearOf(AFecha)]);
end;

class function TFormato.Colones(const AMonto: Currency): string;
begin
  Result := Format(SColones, [FormatFloat('#,##0.00', AMonto)]);
end;

class function TFormato.Dias(const ADias: Integer): string;
begin
  if ADias = 1 then
    Result := SDiaUno
  else
    Result := Format(SDias, [ADias]);
end;

class function TFormato.FechaHora(const AFecha: TDateTime): string;
begin
  Result := FormatDateTime('dd/mm/yyyy hh:nn', AFecha);
end;

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
    Result := ATexto;
  end;
end;

end.
