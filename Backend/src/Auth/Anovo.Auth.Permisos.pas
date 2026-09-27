unit Anovo.Auth.Permisos;

// Atributo [MVCRequiresPermiso] para controllers y acciones.
// Exige token y deja la decision al handler de autenticacion.

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
