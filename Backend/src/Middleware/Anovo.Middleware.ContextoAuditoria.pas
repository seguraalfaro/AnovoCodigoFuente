unit Anovo.Middleware.ContextoAuditoria;

// Pasa el usuario del token al contexto de sesion de Firebird, que es de donde
// los disparadores de auditoria sacan quien escribio.
//
// Va despues del JWT en la lista de middleware y no antes: hasta que el JWT no
// valida el token, Context.LoggedUser esta vacio. Y despues del de
// ActiveRecord, porque necesita la conexion abierta.
//
// Trabaja en OnBeforeControllerAction, que es donde el JWT ya dejo puesto al
// usuario. En OnBeforeRouting todavia no esta.

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

  // Si no hay usuario que poner, hay que borrar lo que hubiera. FireDAC
  // reutiliza conexiones de un pozo comun y el contexto de sesion vive en la
  // conexion, no en la peticion: sin este borrado, una peticion sin token
  // heredaria el usuario de la anterior que uso esa misma conexion y la
  // auditoria registraria escrituras a nombre de quien no las hizo.
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
  // La conexion sigue abierta: el middleware de ActiveRecord la cierra en
  // OnAfterRouting, que corre despues de esto.
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
