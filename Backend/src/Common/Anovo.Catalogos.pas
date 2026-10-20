unit Anovo.Catalogos;

// ID fijos de los catalogos de la migracion 57 y su codigo de texto.
// El ID es la posicion en el arreglo; tiene que coincidir con la base.

interface

uses
  MVCFramework.Nullables;

const
  ESTADOS_COTIZACION: array [1 .. 8] of string = ('borrador', 'en_revision',
    'devuelta', 'visto_bueno', 'enviada', 'aprobada', 'rechazada',
    'descartada');

  ESTADOS_SOLICITUD: array [1 .. 4] of string = ('recibida', 'en_cotizacion',
    'descartada', 'capturada');

  ESTADOS_CONSENTIMIENTO: array [1 .. 3] of string = ('pendiente', 'firmado',
    'revocado');

  ACCIONES_CONSENTIMIENTO: array [1 .. 2] of string = ('otorgado', 'revocado');

  ORIGENES_REGISTRO: array [1 .. 2] of string = ('movil', 'escritorio');

  UNIDADES_PLAZO: array [1 .. 5] of string = ('dias', 'dias_habiles',
    'semanas', 'meses', 'anios');

  TIPOS_MEDIDA: array [1 .. 8] of string = ('Largo', 'Ancho', 'Alto',
    'Profundidad', 'Diámetro', 'Radio', 'Espesor', 'Ángulo');

  TIPOS_LINEA: array [1 .. 4] of string = ('material', 'mano_obra', 'maquina',
    'nota');

  ESTADOS_PRECIO: array [1 .. 3] of string = ('pendiente', 'aplicado',
    'cancelado');

  TIPOS_ADJUNTO: array [1 .. 2] of string = ('croquis', 'foto');

  TIPOS_EXCEPCION: array [1 .. 2] of string = ('otorgado', 'quitado');

  MOTIVOS_CIERRE: array [1 .. 7] of string = ('cierre', 'reuso', 'clave',
    'usuario', 'admin', 'reemplazo', 'vencido');

  MODOS_ENVIO: array [1 .. 2] of string = ('clave', 'oauth2');

  MAGNITUDES: array [1 .. 7] of string = ('tiempo', 'peso', 'longitud',
    'area', 'volumen', 'unidades', 'angulo');

  AMBITOS: array [1 .. 2] of string = ('negocio', 'administracion');

function IdDeCodigo(const ACodigos: array of string;
  const ACodigo: string): Integer;
function CodigoDeId(const ACodigos: array of string;
  const AId: Integer): string;
function IdNulable(const ACodigos: array of string;
  const ACodigo: NullableString): NullableInt32;
function CodigoNulable(const ACodigos: array of string;
  const AId: NullableInt32): NullableString;

implementation

uses
  System.SysUtils;

function IdDeCodigo(const ACodigos: array of string;
  const ACodigo: string): Integer;
var
  I: Integer;
begin
  for I := Low(ACodigos) to High(ACodigos) do
    if SameText(ACodigos[I], Trim(ACodigo)) then
      Exit(I + 1);
  Result := 0;
end;

function CodigoDeId(const ACodigos: array of string;
  const AId: Integer): string;
begin
  if (AId >= 1) and (AId <= Length(ACodigos)) then
    Result := ACodigos[AId - 1]
  else
    Result := '';
end;

function IdNulable(const ACodigos: array of string;
  const ACodigo: NullableString): NullableInt32;
var
  lId: Integer;
begin
  Result.Clear;
  if ACodigo.HasValue then
  begin
    lId := IdDeCodigo(ACodigos, ACodigo.Value);
    if lId > 0 then
      Result := lId;
  end;
end;

function CodigoNulable(const ACodigos: array of string;
  const AId: NullableInt32): NullableString;
begin
  Result.Clear;
  if AId.HasValue and (CodigoDeId(ACodigos, AId.Value) <> '') then
    Result := CodigoDeId(ACodigos, AId.Value);
end;

end.
