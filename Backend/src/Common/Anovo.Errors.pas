unit Anovo.Errors;

// Excepciones de dominio y el manejador que da la forma unica
// del error: { error: { codigo, mensaje, detalles } }.

interface

uses
  System.SysUtils,
  MVCFramework,
  MVCFramework.Validation,
  MVCFramework.Commons;

type
  EAnovoError = class(EMVCException)
  private
    fCodigo: string;
  public
    constructor Create(const ACodigo, AMensaje: string;
      const AStatus: UInt16); reintroduce;
    property Codigo: string read fCodigo;
  end;

  ERecursoNoEncontrado = class(EAnovoError)
  public
    constructor Create(const ARecurso: string; const AId: Integer); reintroduce;
  end;

  ESinPermiso = class(EAnovoError)
  public
    constructor Create(const AAccion: string); reintroduce;
  end;

  EVersionVencida = class(EAnovoError)
  public
    constructor Create(const ARecurso: string; const AId: Integer); reintroduce;
  end;

  EConflictoDeEstado = class(EAnovoError)
  public
    constructor Create(const ACodigo, AMensaje: string); reintroduce;
  end;

  EDatoInvalido = class(EAnovoError)
  public
    constructor Create(const AMensaje: string); reintroduce;
  end;

function ManejadorDeErrores: TMVCExceptionHandlerProc;

implementation

uses
  JsonDataObjects,
  MVCFramework.Logger,
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord,
  Anovo.Textos;

constructor EAnovoError.Create(const ACodigo, AMensaje: string;
  const AStatus: UInt16);
begin
  inherited Create(AStatus, AMensaje);
  fCodigo := ACodigo;
end;

constructor ERecursoNoEncontrado.Create(const ARecurso: string;
  const AId: Integer);
begin
  inherited Create('RECURSO_NO_ENCONTRADO',
    Format(SRecursoNoExiste, [ARecurso, AId]),
    HTTP_STATUS.NotFound);
end;

constructor ESinPermiso.Create(const AAccion: string);
begin
  inherited Create('SIN_PERMISO',
    Format(SSinPermiso, [AAccion]),
    HTTP_STATUS.Forbidden);
end;

constructor EVersionVencida.Create(const ARecurso: string;
  const AId: Integer);
begin
  inherited Create('VERSION_VENCIDA',
    Format(SVersionVencida, [ARecurso, AId]),
    HTTP_STATUS.Conflict);
end;

constructor EConflictoDeEstado.Create(const ACodigo, AMensaje: string);
begin
  inherited Create(ACodigo, AMensaje, HTTP_STATUS.Conflict);
end;

constructor EDatoInvalido.Create(const AMensaje: string);
begin
  inherited Create('DATO_INVALIDO', AMensaje,
    HTTP_STATUS.UnprocessableEntity);
end;

function ManejadorDeErrores: TMVCExceptionHandlerProc;
begin
  Result := procedure(E: Exception; SelectedController: TMVCController;
    WebContext: TWebContext; var ExceptionHandled: Boolean)
    var
      lCuerpo: TJSONObject;
      lError: TJSONObject;
      lCodigo: string;
      lMensaje: string;
      lStatus: Integer;
    begin
      if E = nil then
      begin
        lCodigo := 'RUTA_NO_ENCONTRADA';
        lMensaje := SRutaNoExiste;
        lStatus := WebContext.Response.StatusCode;
        if lStatus < 400 then
          lStatus := HTTP_STATUS.NotFound;
      end
      else if E is EAnovoError then
      begin
        lCodigo := EAnovoError(E).Codigo;
        lMensaje := E.Message;
        lStatus := EAnovoError(E).HTTPStatusCode;
      end
      else if E is EMVCValidationException then
      begin
        lCodigo := 'VALIDACION';
        lMensaje := E.Message;
        lStatus := HTTP_STATUS.UnprocessableEntity;
      end
      else if E is EMVCActiveRecordVersionedItemNotFound then
      begin
        lCodigo := 'VERSION_VENCIDA';
        lMensaje := SVersionVencidaGenerico;
        lStatus := HTTP_STATUS.Conflict;
      end
      else if E is EMVCActiveRecordNotFound then
      begin
        lCodigo := 'RECURSO_NO_ENCONTRADO';
        lMensaje := SRecursoNoExisteGenerico;
        lStatus := HTTP_STATUS.NotFound;
      end
      else if E is EMVCException then
      begin
        lCodigo := 'ERROR';
        lMensaje := E.Message;
        lStatus := EMVCException(E).HTTPStatusCode;
      end
      else
      begin
        LogE(Format('Excepcion no controlada %s: %s', [E.ClassName, E.Message]));
        lCodigo := 'ERROR_INTERNO';
        lMensaje := SErrorInterno;
        lStatus := HTTP_STATUS.InternalServerError;
      end;

      lCuerpo := TJSONObject.Create;
      try
        lError := lCuerpo.O['error'];
        lError.S['codigo'] := lCodigo;
        lError.S['mensaje'] := lMensaje;
        lError.A['detalles'];

        WebContext.Response.StatusCode := lStatus;
        WebContext.Response.ContentType := TMVCMediaType.APPLICATION_JSON;
        WebContext.Response.Content := lCuerpo.ToJSON(False);
      finally
        lCuerpo.Free;
      end;

      ExceptionHandled := True;
    end;
end;

end.
