unit Anovo.Middleware.Actividad;

// Registro en memoria de peticiones y errores para la
// ventana del servidor. No es auditoria.

interface

uses
  System.Classes,
  System.SyncObjs,
  MVCFramework;

type
  TRegistroActividad = record
    Hora: TDateTime;
    UsuarioId: Integer;
    Verbo: string;
    Ruta: string;
    Estado: Integer;
    Milisegundos: Int64;
  end;

  TActividad = class
  private
    class var FSeccion: TCriticalSection;
    class var FUltimas: TArray<TRegistroActividad>;
    class var FServidas: Int64;
    class var FErrores: Int64;
    class var FDesde: TDateTime;
  public
    class constructor Create;
    class destructor Destroy;

    class procedure Registrar(const ARegistro: TRegistroActividad);
    class function Ultimas: TArray<TRegistroActividad>;
    class function Servidas: Int64;
    class function Errores: Int64;
    class function Desde: TDateTime;
    class procedure Limpiar;
  end;

  TActividadMiddleware = class(TInterfacedObject, IMVCMiddleware)
  public
    procedure OnBeforeRouting(AContext: TWebContext; var AHandled: Boolean);
    procedure OnBeforeControllerAction(AContext: TWebContext;
      const AControllerQualifiedClassName: string; const AActionName: string;
      var AHandled: Boolean);
    procedure OnAfterControllerAction(AContext: TWebContext;
      const AControllerQualifiedClassName: string; const AActionName: string;
      const AHandled: Boolean);
    procedure OnAfterRouting(AContext: TWebContext; const AHandled: Boolean);
  end;

const
  ACTIVIDAD_MAXIMA = 200;

implementation

uses
  System.SysUtils,
  System.Diagnostics;

const
  CLAVE_INICIO = 'anovo.inicio';

class constructor TActividad.Create;
begin
  FSeccion := TCriticalSection.Create;
  SetLength(FUltimas, 0);
  FServidas := 0;
  FErrores := 0;
  FDesde := Now;
end;

class destructor TActividad.Destroy;
begin
  FSeccion.Free;
end;

class procedure TActividad.Registrar(const ARegistro: TRegistroActividad);
var
  I: Integer;
begin
  FSeccion.Enter;
  try
    Inc(FServidas);
    if ARegistro.Estado >= 400 then
      Inc(FErrores);

    if Length(FUltimas) < ACTIVIDAD_MAXIMA then
      SetLength(FUltimas, Length(FUltimas) + 1);
    for I := High(FUltimas) downto 1 do
      FUltimas[I] := FUltimas[I - 1];
    FUltimas[0] := ARegistro;
  finally
    FSeccion.Leave;
  end;
end;

class function TActividad.Ultimas: TArray<TRegistroActividad>;
begin
  FSeccion.Enter;
  try
    Result := Copy(FUltimas, 0, Length(FUltimas));
  finally
    FSeccion.Leave;
  end;
end;

class function TActividad.Servidas: Int64;
begin
  FSeccion.Enter;
  try
    Result := FServidas;
  finally
    FSeccion.Leave;
  end;
end;

class function TActividad.Errores: Int64;
begin
  FSeccion.Enter;
  try
    Result := FErrores;
  finally
    FSeccion.Leave;
  end;
end;

class function TActividad.Desde: TDateTime;
begin
  Result := FDesde;
end;

class procedure TActividad.Limpiar;
begin
  FSeccion.Enter;
  try
    SetLength(FUltimas, 0);
    FServidas := 0;
    FErrores := 0;
    FDesde := Now;
  finally
    FSeccion.Leave;
  end;
end;

procedure TActividadMiddleware.OnBeforeRouting(AContext: TWebContext;
  var AHandled: Boolean);
begin
  AContext.Data[CLAVE_INICIO] := TStopwatch.GetTimeStamp.ToString;
end;

procedure TActividadMiddleware.OnBeforeControllerAction(AContext: TWebContext;
  const AControllerQualifiedClassName: string; const AActionName: string;
  var AHandled: Boolean);
begin
end;

procedure TActividadMiddleware.OnAfterControllerAction(AContext: TWebContext;
  const AControllerQualifiedClassName: string; const AActionName: string;
  const AHandled: Boolean);
begin
end;

procedure TActividadMiddleware.OnAfterRouting(AContext: TWebContext;
  const AHandled: Boolean);
var
  lRegistro: TRegistroActividad;
  lInicio: Int64;
  lTexto: string;
begin
  lRegistro := Default (TRegistroActividad);
  lRegistro.Hora := Now;
  lRegistro.Verbo := AContext.Request.HTTPMethodAsString;
  lRegistro.Ruta := AContext.Request.PathInfo;
  lRegistro.Estado := AContext.Response.StatusCode;

  lTexto := '';
  if AContext.Data.TryGetValue(CLAVE_INICIO, lTexto) and
    TryStrToInt64(lTexto, lInicio) then
    lRegistro.Milisegundos :=
      (TStopwatch.GetTimeStamp - lInicio) * 1000 div TStopwatch.Frequency;

  lTexto := '';
  if Assigned(AContext.LoggedUser.CustomData) then
    AContext.LoggedUser.CustomData.TryGetValue('USUARIO_ID', lTexto);
  if not TryStrToInt(lTexto, lRegistro.UsuarioId) then
    lRegistro.UsuarioId := 0;

  TActividad.Registrar(lRegistro);
end;

end.
