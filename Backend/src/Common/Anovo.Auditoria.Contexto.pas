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

implementation

uses
  System.SysUtils,
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

end.

