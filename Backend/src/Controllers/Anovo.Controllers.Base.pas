unit Anovo.Controllers.Base;

// Base de los controllers: el usuario y los roles del token, y la
// lectura de las fechas de la URL, en un solo lugar.

interface

uses
  MVCFramework,
  MVCFramework.Nullables;

type
  TControllerBase = class(TMVCController)
  protected
    function UsuarioId: Integer;
    function Rol: string;
    function Roles: TArray<string>;
    function ComoFecha(const ATexto: string;
      const APorDefecto: TDateTime = 0): TDateTime;
    function ComoFechaHora(const ATexto: string): NullableTDateTime;
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Serializer.Commons,
  Anovo.Auth.Permisos,
  Anovo.Errors,
  Anovo.Textos;

const
  FORMATO_FECHA = 'yyyy-mm-dd';
  SEPARADOR_FECHA = '-';

function TControllerBase.UsuarioId: Integer;
begin
  Result := UsuarioDelToken(Context);
end;

function TControllerBase.Rol: string;
begin
  Result := '';
  if Context.LoggedUser.Roles.Count > 0 then
    Result := Context.LoggedUser.Roles[0];
end;

function TControllerBase.Roles: TArray<string>;
begin
  Result := Context.LoggedUser.Roles.ToArray;
end;

function TControllerBase.ComoFecha(const ATexto: string;
  const APorDefecto: TDateTime): TDateTime;
var
  lFormato: TFormatSettings;
begin
  if ATexto.Trim.IsEmpty then
    Exit(APorDefecto);

  lFormato := TFormatSettings.Create;
  lFormato.DateSeparator := SEPARADOR_FECHA;
  lFormato.ShortDateFormat := FORMATO_FECHA;
  if not TryStrToDate(ATexto.Trim, Result, lFormato) then
    raise EDatoInvalido.Create(Format(SFechaInvalida, [ATexto]));
end;

function TControllerBase.ComoFechaHora(const ATexto: string)
  : NullableTDateTime;
begin
  Result.Clear;
  if ATexto.Trim.IsEmpty then
    Exit;
  try
    Result := ISOTimeStampToDateTime(ATexto.Trim);
  except
    on Exception do
      raise EDatoInvalido.Create(Format(SFechaHoraInvalida, [ATexto]));
  end;
end;

end.
