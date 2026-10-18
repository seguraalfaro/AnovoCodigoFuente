unit Anovo.Middleware.ContextoAuditoria;

// Pasa el usuario del token al contexto de Firebird
// que leen los disparadores de auditoria.

interface

uses
  MVCFramework;

type
  TContextoAuditoriaMiddleware = class(TInterfacedObject, IMVCMiddleware)
  protected
    procedure OnBeforeRouting(Context: TWebContext; var Handled: Boolean);
    procedure OnBeforeControllerAction(Context: TWebContext;
      const AControllerQualifiedClassName: string; const AActionName: string;
      var Handled: Boolean);
    procedure OnAfterControllerAction(Context: TWebContext;
      const AControllerQualifiedClassName: string; const AActionName: string;
      const AHandled: Boolean);
    procedure OnAfterRouting(Context: TWebContext; const AHandled: Boolean);
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Logger,
  Anovo.Auth.Permisos,
  Anovo.Auditoria.Contexto,
  Anovo.Textos;

procedure TContextoAuditoriaMiddleware.OnBeforeRouting(Context: TWebContext;
  var Handled: Boolean);
begin

end;

procedure TContextoAuditoriaMiddleware.OnBeforeControllerAction
  (Context: TWebContext; const AControllerQualifiedClassName: string;
  const AActionName: string; var Handled: Boolean);
var
  lUsuarioId: Integer;
begin
  lUsuarioId := UsuarioDelToken(Context);
  if lUsuarioId <= 0 then
  begin
    if Assigned(Context.LoggedUser.CustomData) and
      Context.LoggedUser.CustomData.ContainsKey(DATO_USUARIO_ID) then
      LogW(SLogTokenUsuarioInvalido);
    LimpiarUsuario;
    Exit;
  end;

  FijarUsuario(lUsuarioId);
end;

procedure TContextoAuditoriaMiddleware.OnAfterControllerAction
  (Context: TWebContext; const AControllerQualifiedClassName: string;
  const AActionName: string; const AHandled: Boolean);
begin
  try
    LimpiarUsuario;
    LimpiarDetalle;
  except
    on E: Exception do
      LogE(SLogContextoNoLimpio + E.ClassName);
  end;
end;

procedure TContextoAuditoriaMiddleware.OnAfterRouting(Context: TWebContext;
  const AHandled: Boolean);
begin
end;

end.
