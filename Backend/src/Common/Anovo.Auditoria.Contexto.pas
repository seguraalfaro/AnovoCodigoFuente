unit Anovo.Auditoria.Contexto;

// Contexto de sesion de Firebird para los disparadores de
// auditoria: quien escribe y por que.

interface

procedure FijarUsuario(const AUsuarioId: Integer);
procedure LimpiarUsuario;

function UsuarioActual: Integer;

procedure FijarDetalle(const ADetalle: string);
procedure LimpiarDetalle;

implementation

uses
  System.SysUtils,
  System.Variants,
  MVCFramework.ActiveRecord;

const
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
  lValor := TMVCActiveRecord.CurrentConnection.ExecSQLScalar(SQL_USUARIO);
  if VarIsNull(lValor) or not TryStrToInt(VarToStr(lValor), Result) then
    Result := 0;
end;

procedure FijarDetalle(const ADetalle: string);
begin
  TMVCActiveRecord.CurrentConnection.ExecSQLScalar
    (Format(SQL_DETALLE, [QuotedStr(Copy(ADetalle, 1, 500))]));
end;

procedure LimpiarDetalle;
begin
  TMVCActiveRecord.CurrentConnection.ExecSQLScalar
    (Format(SQL_DETALLE, ['null']));
end;

end.
