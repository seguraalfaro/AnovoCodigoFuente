unit Anovo.Auditoria.Contexto;


// Contexto de sesion de Firebird para la auditoria.
//
// Los once disparadores de 03_auditoria.sql leen quien escribe de
// RDB$GET_CONTEXT('USER_SESSION', 'USUARIO_ID') y, si viene vacio, lanzan
// E_AUDITORIA_SIN_USUARIO y tumban la operacion. Un disparador solo conoce al
// usuario de la conexion -ANOVO_BACKEND para todo el mundo-, asi que quien
// escribe de verdad hay que pasarselo por aqui.
//
// Va en unidad aparte porque hay dos sitios que lo necesitan y son distintos:
// el middleware, para cualquier peticion con token, y el handler de
// autenticacion, que reescribe la clave durante el login, cuando todavia no
// hay token del que sacar nada.

interface

procedure FijarUsuario(const AUsuarioId: Integer);
procedure LimpiarUsuario;

// Quien escribe, leido del mismo contexto que fijo el middleware. Es para las
// columnas MODIFICADO_POR, que no las pone ningun disparador. Devuelve 0 si no
// hay usuario, y entonces la escritura va a fallar en el disparador de todos
// modos.
function UsuarioActual: Integer;

// El por que del cambio, que el disparador copia a AUDITORIA.DETALLE. Lo
// pone el servicio justo antes de escribir, porque es el unico que conoce
// la intencion: el disparador solo ve que cambio una fila.
procedure FijarDetalle(const ADetalle: string);
procedure LimpiarDetalle;

implementation

uses
  System.SysUtils,
  System.Variants,
  MVCFramework.ActiveRecord;

const
  // RDB$SET_CONTEXT es una funcion, no una sentencia: hay que consumir lo que
  // devuelve. De ahi el select contra RDB$DATABASE, que es la tabla de una
  // sola fila que Firebird trae para esto.
  SQL_FIJAR =
    'select rdb$set_context(''USER_SESSION'', ''USUARIO_ID'', ''%d'') ' +
    'from rdb$database';
  SQL_LIMPIAR =
    'select rdb$set_context(''USER_SESSION'', ''USUARIO_ID'', null) ' +
    'from rdb$database';
  SQL_DETALLE =
    'select rdb$set_context(''USER_SESSION'', ''DETALLE'', %s) ' +
    'from rdb$database';
  SQL_USUARIO =
    'select rdb$get_context(''USER_SESSION'', ''USUARIO_ID'') ' +
    'from rdb$database';

procedure FijarUsuario(const AUsuarioId: Integer);
begin
  // El id va concatenado y no como parametro a proposito: es un Integer, no
  // texto que venga de la peticion, asi que no hay nada que inyectar. Con
  // parametro habria que pelearse con como FireDAC interpreta los dos puntos
  // dentro de la llamada.
  TMVCActiveRecord.CurrentConnection.ExecSQLScalar
    (Format(SQL_FIJAR, [AUsuarioId]));
end;

procedure LimpiarUsuario;
begin
  TMVCActiveRecord.CurrentConnection.ExecSQLScalar(SQL_LIMPIAR);
end;

function UsuarioActual: Integer;
var
  lValor: Variant;
begin
  // RDB$GET_CONTEXT devuelve texto: lo que se fijo con Format.
  lValor := TMVCActiveRecord.CurrentConnection.ExecSQLScalar(SQL_USUARIO);
  if VarIsNull(lValor) or not TryStrToInt(VarToStr(lValor), Result) then
    Result := 0;
end;

procedure FijarDetalle(const ADetalle: string);
begin
  // QuotedStr y no parametro, por lo mismo que arriba. El texto lo escribe el
  // servicio y no llega de la peticion, pero se escapa igual: una comilla
  // suelta en un nombre partiria la sentencia.
  TMVCActiveRecord.CurrentConnection.ExecSQLScalar
    (Format(SQL_DETALLE, [QuotedStr(Copy(ADetalle, 1, 500))]));
end;

procedure LimpiarDetalle;
begin
  // El contexto dura lo que la conexion, y la conexion se reutiliza entre
  // peticiones: sin esto, la siguiente escritura hereda este detalle.
  TMVCActiveRecord.CurrentConnection.ExecSQLScalar
    (Format(SQL_DETALLE, ['null']));
end;

end.

