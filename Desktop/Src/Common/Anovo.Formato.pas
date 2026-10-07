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
    class function Modulo(const AValor: string): string; static;
    class function AccionAuditoria(const AValor: string): string; static;
    class function EntidadAuditoria(const AValor: string): string; static;
    class function MesAnio(const AFecha: TDateTime): string; static;
    class function Colones(const AMonto: Currency): string; static;
    class function Dias(const ADias: Integer): string; static;
    class function Fecha(const AFecha: TDateTime): string; static;
    class function FechaHora(const AFecha: TDateTime): string; static;
    class function Porcentaje(const AValor: Double): string; static;
    class function ClaveEnGrupos(const AClave: string): string; static;
    class function Cantidad(const ACantidad: Integer;
      const AUno, AVarios: string): string; static;
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

const
  FORMATO_FECHA = 'dd/mm/yyyy';
  FORMATO_FECHA_HORA = 'dd/mm/yyyy hh:nn';
  FORMATO_MONTO = '#,##0.00';
  FORMATO_PORCENTAJE = '0.##';

class function TFormato.AccionAuditoria(const AValor: string): string;
begin
  case IndexText(AValor, ['insertar', 'actualizar', 'borrar']) of
    0:
      Result := SAccionAudRegistro;
    1:
      Result := SAccionAudCambio;
    2:
      Result := SAccionAudBorrado;
  else
    Result := AValor;
  end;
end;

class function TFormato.EntidadAuditoria(const AValor: string): string;
begin
  case IndexText(AValor, ['USUARIOS', 'USUARIOS_CLAVES', 'ROLES_PERMISOS',
    'USUARIOS_PERMISOS', 'CLIENTES', 'CLIENTE_CONTACTOS', 'CONSENTIMIENTO',
    'COTIZACIONES', 'SOLICITUDES', 'EMPRESA', 'UNIDADES_MEDIDA',
    'MATERIALES_PRECIOS', 'MAQUINAS_PRECIOS', 'MANO_OBRA_PRECIOS',
    'PRECIOS_PROGRAMADOS', 'MANO_OBRA_CATEGORIA']) of
    0:
      Result := SEntUsuario;
    1:
      Result := SEntClave;
    2:
      Result := SEntPermisoRol;
    3:
      Result := SEntPermisoPersona;
    4:
      Result := SEntCliente;
    5:
      Result := SEntContacto;
    6:
      Result := SEntConsentimiento;
    7:
      Result := SEntCotizacion;
    8:
      Result := SEntSolicitud;
    9:
      Result := SEntEmpresa;
    10:
      Result := SEntUnidadMedida;
    11, 12, 13:
      Result := SEntPrecio;
    14:
      Result := SEntPrecioProgramado;
    15:
      Result := SEntCategoriaManoObra;
  else
    Result := AValor;
  end;
end;

class function TFormato.Modulo(const AValor: string): string;
begin
  case IndexStr(AValor, ['adjuntos', 'auditoria', 'catalogos', 'clientes',
    'cotizaciones', 'permisos', 'reportes', 'solicitudes', 'usuarios']) of
    0: Result := SModuloAdjuntos;
    1: Result := SModuloAuditoria;
    2: Result := SModuloCatalogos;
    3: Result := SModuloClientes;
    4: Result := SModuloCotizaciones;
    5: Result := SModuloPermisos;
    6: Result := SModuloReportes;
    7: Result := SModuloSolicitudes;
    8: Result := SModuloUsuarios;
  else
    Result := AValor;
  end;
end;

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
  else if lValor = 'devuelta' then
    Result := SEstDevuelta
  else if lValor = 'visto_bueno' then
    Result := SEstVistoBueno
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
  Result := Format(SColones, [FormatFloat(FORMATO_MONTO, AMonto)]);
end;

class function TFormato.Dias(const ADias: Integer): string;
begin
  if ADias = 1 then
    Result := SDiaUno
  else
    Result := Format(SDias, [ADias]);
end;

class function TFormato.Fecha(const AFecha: TDateTime): string;
begin
  Result := FormatDateTime(FORMATO_FECHA, AFecha);
end;

class function TFormato.FechaHora(const AFecha: TDateTime): string;
begin
  Result := FormatDateTime(FORMATO_FECHA_HORA, AFecha);
end;

class function TFormato.Porcentaje(const AValor: Double): string;
begin
  Result := FormatFloat(FORMATO_PORCENTAJE, AValor);
end;

class function TFormato.Cantidad(const ACantidad: Integer;
  const AUno, AVarios: string): string;
begin
  if ACantidad = 1 then
    Result := Format(AUno, [ACantidad])
  else
    Result := Format(AVarios, [ACantidad]);
end;

class function TFormato.ClaveEnGrupos(const AClave: string): string;
const
  LARGO_GRUPO = 4;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AClave) do
  begin
    if (I > 1) and ((I - 1) mod LARGO_GRUPO = 0) then
      Result := Result + ' ';
    Result := Result + AClave[I];
  end;
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
