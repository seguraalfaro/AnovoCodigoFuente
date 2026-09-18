unit Anovo.Auth.Permisos;

// [MVCRequiresPermiso('clientes.ver')] sobre un controller o una accion.
//
// Hereda de MVCRequiresAuthenticationAttribute: con eso el OnRequest del
// framework ya exige token, sin tocar nada mas. La decision la toma
// TAuthentication.OnAuthorization contra la cache de permisos.
//
// Varios codigos separados por ; valen como cualquiera de ellos, no todos:
// 'solicitudes.ver_propias;solicitudes.ver_todas' deja pasar a quien tenga uno
// de los dos, y el servicio decide el alcance segun cual. Ojo, al reves que
// MVCRequiresRole, cuyo valor por defecto es exigir todos.
//
// En el controller y en la accion a la vez se exigen los dos.

interface

uses
  MVCFramework;

type
  MVCRequiresPermisoAttribute = class(MVCRequiresAuthenticationAttribute)
  private
    fPermisos: string;
  public
    constructor Create(const APermisos: string);
    function GetPermisos: TArray<string>;
  end;

implementation

uses
  System.SysUtils;

constructor MVCRequiresPermisoAttribute.Create(const APermisos: string);
begin
  inherited Create;
  fPermisos := APermisos;
end;

function MVCRequiresPermisoAttribute.GetPermisos: TArray<string>;
var
  I: Integer;
begin
  Result := fPermisos.Split([';'], TStringSplitOptions.ExcludeEmpty);
  for I := 0 to High(Result) do
    Result[I] := Result[I].Trim;
end;

end.
