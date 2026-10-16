unit Anovo.Auth.Permisos;

// Atributo [MVCRequiresPermiso] para controllers y acciones.
// Exige token y deja la decision al handler de autenticacion.

interface

uses
  MVCFramework;

const
  DATO_USUARIO_ID = 'USUARIO_ID';
  DATO_DISPOSITIVO_ID = 'DISPOSITIVO_ID';
  SEPARADOR_PERMISOS = ';';

type
  MVCRequiresPermisoAttribute = class(MVCRequiresAuthenticationAttribute)
  private
    fPermisos: string;
  public
    constructor Create(const APermisos: string);
    function GetPermisos: TArray<string>;
  end;

function UsuarioDelToken(const AContext: TWebContext): Integer;
function DispositivoDelToken(const AContext: TWebContext): Integer;

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
  Result := fPermisos.Split([SEPARADOR_PERMISOS],
    TStringSplitOptions.ExcludeEmpty);
  for I := 0 to High(Result) do
    Result[I] := Result[I].Trim;
end;

function EnteroDelToken(const AContext: TWebContext;
  const ADato: string): Integer;
var
  lTexto: string;
begin
  lTexto := '';
  if Assigned(AContext.LoggedUser.CustomData) then
    AContext.LoggedUser.CustomData.TryGetValue(ADato, lTexto);
  if not TryStrToInt(lTexto, Result) then
    Result := 0;
end;

function UsuarioDelToken(const AContext: TWebContext): Integer;
begin
  Result := EnteroDelToken(AContext, DATO_USUARIO_ID);
end;

function DispositivoDelToken(const AContext: TWebContext): Integer;
begin
  Result := EnteroDelToken(AContext, DATO_DISPOSITIVO_ID);
end;

end.
