unit Anovo.Middleware.LimitePeticiones;

// Envuelve el limite de peticiones de DMVC para que el 429 salga con la
// forma de error del contrato y en espanol.

interface

uses
  MVCFramework;

type
  TLimitePeticionesMiddleware = class(TInterfacedObject, IMVCMiddleware)
  private
    FLimite: IMVCMiddleware;
  public
    constructor Create(const ALimite: IMVCMiddleware);
    procedure OnBeforeRouting(AContext: TWebContext; var AHandled: Boolean);
    procedure OnBeforeControllerAction(AContext: TWebContext;
      const AControllerQualifiedClassName: string; const AActionName: string;
      var AHandled: Boolean);
    procedure OnAfterControllerAction(AContext: TWebContext;
      const AControllerQualifiedClassName: string; const AActionName: string;
      const AHandled: Boolean);
    procedure OnAfterRouting(AContext: TWebContext; const AHandled: Boolean);
  end;

implementation

uses
  MVCFramework.Commons,
  Anovo.Errors,
  Anovo.Textos;

constructor TLimitePeticionesMiddleware.Create(const ALimite: IMVCMiddleware);
begin
  inherited Create;
  FLimite := ALimite;
end;

procedure TLimitePeticionesMiddleware.OnBeforeRouting(AContext: TWebContext;
  var AHandled: Boolean);
begin
  FLimite.OnBeforeRouting(AContext, AHandled);
  if AHandled and (AContext.Response.StatusCode = HTTP_STATUS.TooManyRequests)
  then
  begin
    AContext.Response.ContentType := TIPO_JSON_UTF8;
    AContext.Response.Content := CuerpoError('DEMASIADAS_PETICIONES',
      SDemasiadasPeticiones);
  end;
end;

procedure TLimitePeticionesMiddleware.OnBeforeControllerAction(
  AContext: TWebContext; const AControllerQualifiedClassName: string;
  const AActionName: string; var AHandled: Boolean);
begin
  FLimite.OnBeforeControllerAction(AContext, AControllerQualifiedClassName,
    AActionName, AHandled);
end;

procedure TLimitePeticionesMiddleware.OnAfterControllerAction(
  AContext: TWebContext; const AControllerQualifiedClassName: string;
  const AActionName: string; const AHandled: Boolean);
begin
  FLimite.OnAfterControllerAction(AContext, AControllerQualifiedClassName,
    AActionName, AHandled);
end;

procedure TLimitePeticionesMiddleware.OnAfterRouting(AContext: TWebContext;
  const AHandled: Boolean);
begin
  FLimite.OnAfterRouting(AContext, AHandled);
end;

end.
