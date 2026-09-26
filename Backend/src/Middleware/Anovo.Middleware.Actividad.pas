unit Anovo.Middleware.Actividad;

// Lo que esta pasando en el servidor, para que la ventana lo muestre.
//
// No es auditoria. La auditoria la escriben los disparadores, vive en la base
// y es la prueba de quien cambio que. Esto es volatil, vive en memoria, se
// pierde al cerrar y solo sirve para mirar el servidor mientras trabaja: que
// rutas se estan pidiendo, quien las pide, cuales fallan y cuanto tardan.
//
// Por eso tampoco guarda el cuerpo de las peticiones ni las respuestas: ahi
// viajan datos personales de los clientes y no tienen por que quedar en la
// memoria del servidor mas alla de lo que dura la peticion.
//
// Las peticiones llegan en hilos de Indy y la ventana lee desde el hilo de la
// interfaz, asi que el registro va detras de una seccion critica.

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
    // Copia de lo ultimo, de la mas reciente a la mas vieja.
    class function Ultimas: TArray<TRegistroActividad>;
    class function Servidas: Int64;
    class function Errores: Int64;
    // Cuando arranco el registro, que es cuando arranco el servidor.
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
  // Suficiente para ver que esta pasando sin que la memoria crezca sola.
  ACTIVIDAD_MAXIMA = 200;

implementation

uses
  System.SysUtils,
  System.Diagnostics;

const
  // La marca de tiempo del inicio viaja en el contexto de la peticion, que es
  // lo unico que acompana a una peticion de punta a punta.
  CLAVE_INICIO = 'anovo.inicio';

{ TActividad }

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

    // La mas reciente primero: es el orden en que se mira.
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
    // Copia: la ventana la recorre en su hilo mientras siguen entrando
    // peticiones en los de Indy.
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

{ TActividadMiddleware }

procedure TActividadMiddleware.OnBeforeRouting(AContext: TWebContext;
  var AHandled: Boolean);
begin
  AContext.Data[CLAVE_INICIO] := TStopwatch.GetTimeStamp.ToString;
end;

procedure TActividadMiddleware.OnBeforeControllerAction(AContext: TWebContext;
  const AControllerQualifiedClassName: string; const AActionName: string;
  var AHandled: Boolean);
begin
  // Nada: lo que interesa se sabe al terminar.
end;

procedure TActividadMiddleware.OnAfterControllerAction(AContext: TWebContext;
  const AControllerQualifiedClassName: string; const AActionName: string;
  const AHandled: Boolean);
begin
  // Nada: OnAfterRouting llega tambien cuando ninguna ruta coincidio, que es
  // justo uno de los casos que interesa ver.
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

  // El mismo dato que el middleware de auditoria saca del token. Sin sesion
  // -un login, o una peticion sin credenciales- queda en cero.
  lTexto := '';
  if Assigned(AContext.LoggedUser.CustomData) then
    AContext.LoggedUser.CustomData.TryGetValue('USUARIO_ID', lTexto);
  if not TryStrToInt(lTexto, lRegistro.UsuarioId) then
    lRegistro.UsuarioId := 0;

  TActividad.Registrar(lRegistro);
end;

end.
