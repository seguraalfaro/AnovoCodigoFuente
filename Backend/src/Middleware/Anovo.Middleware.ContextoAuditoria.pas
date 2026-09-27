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
  Anovo.Auditoria.Contexto;

procedure TContextoAuditoriaMiddleware.OnBeforeRouting(Context: TWebContext;
  var Handled: Boolean);
begin

end;

procedure TContextoAuditoriaMiddleware.OnBeforeControllerAction
  (Context: TWebContext; const AControllerQualifiedClassName: string;
  const AActionName: string; var Handled: Boolean);
var
  lTexto: string;
  lUsuarioId: Integer;
begin
  lTexto := '';
  if Assigned(Context.LoggedUser.CustomData) then
    Context.LoggedUser.CustomData.TryGetValue('USUARIO_ID', lTexto);

  if not TryStrToInt(lTexto, lUsuarioId) then
  begin
    if lTexto <> '' then
      LogE(Format('Token con USUARIO_ID no numerico: %s', [lTexto]));
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
        LogE('No se pudo limpiar el contexto de auditoria: ' + E.Message);
  end;
end;

procedure TContextoAuditoriaMiddleware.OnAfterRouting(Context: TWebContext;
  const AHandled: Boolean);
begin

end;

end.
