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

  EServicioExterno = class(EAnovoError)
  public
    constructor Create(const ACodigo, AMensaje: string); reintroduce;
  end;

  EDemasiadosIntentos = class(EAnovoError)
  public
    constructor Create(const AMinutos: Integer); reintroduce;
  end;

const
  LARGO_UUID_LOCAL = 36;
  TIPO_JSON_UTF8 = 'application/json; charset=utf-8';

function ManejadorDeErrores: TMVCExceptionHandlerProc;
function CuerpoError(const ACodigo, AMensaje: string): string;
procedure ExigirLargoUuid(const AUuid: string);
function EsClaveRepetida(const AError: Exception): Boolean;

implementation

uses
  System.Generics.Collections,
  JsonDataObjects,
  MVCFramework.Logger,
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord,
  FireDAC.Stan.Error,
  Anovo.Textos;

function EsClaveRepetida(const AError: Exception): Boolean;
begin
  Result := (AError is EFDDBEngineException) and
    (EFDDBEngineException(AError).Kind = ekUKViolated);
end;

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

constructor EServicioExterno.Create(const ACodigo, AMensaje: string);
begin
  inherited Create(ACodigo, AMensaje, HTTP_STATUS.BadGateway);
end;

constructor EDemasiadosIntentos.Create(const AMinutos: Integer);
begin
  inherited Create('INGRESO_BLOQUEADO', Format(SIngresoBloqueado, [AMinutos]),
    HTTP_STATUS.TooManyRequests);
end;

function CuerpoError(const ACodigo, AMensaje: string): string;
var
  lCuerpo: TJSONObject;
  lError: TJSONObject;
begin
  lCuerpo := TJSONObject.Create;
  try
    lError := lCuerpo.O['error'];
    lError.S['codigo'] := ACodigo;
    lError.S['mensaje'] := AMensaje;
    lError.A['detalles'];
    Result := lCuerpo.ToJSON;
  finally
    lCuerpo.Free;
  end;
end;

procedure ExigirLargoUuid(const AUuid: string);
begin
  if AUuid.Length > LARGO_UUID_LOCAL then
    raise EDatoInvalido.Create(Format(SUuidLocalLargo, [LARGO_UUID_LOCAL]));
end;

const
  MARCA_DATO_PERSONAL = 'Problematic key value';

function MensajeParaBitacora(const E: Exception): string;
var
  lCorte: Integer;
begin
  Result := E.Message;
  lCorte := Pos(MARCA_DATO_PERSONAL, Result);
  if lCorte > 0 then
    Result := Trim(Copy(Result, 1, lCorte - 1));
  Result := E.ClassName + ': ' + Result;
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
      lDetalles: TJsonArray;
      lDetalle: TJsonObject;
      lErrores: TDictionary<string, string>;
      lPar: TPair<string, string>;
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
        lStatus := HTTP_STATUS.UnprocessableEntity;
        lErrores := EMVCValidationException(E).ValidationErrors;
        if (lErrores <> nil) and (lErrores.Count = 1) then
          for lPar in lErrores do
            lMensaje := lPar.Value
        else if lErrores <> nil then
          lMensaje := Format(SDatosPorCorregir, [lErrores.Count])
        else
          lMensaje := E.Message;
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
      else if (E is EMVCException) and not (E is EMVCActiveRecord) and
        (EMVCException(E).HTTPStatusCode >= 400) and
        (EMVCException(E).HTTPStatusCode < 500) then
      begin
        LogW('Pedido rechazado por el framework: ' + MensajeParaBitacora(E));
        lCodigo := 'PEDIDO_INVALIDO';
        lMensaje := SPedidoInvalido;
        lStatus := EMVCException(E).HTTPStatusCode;
      end
      else
      begin
        LogE('Excepcion no controlada ' + MensajeParaBitacora(E));
        lCodigo := 'ERROR_INTERNO';
        lMensaje := SErrorInterno;
        lStatus := HTTP_STATUS.InternalServerError;
      end;

      lCuerpo := TJSONObject.Create;
      try
        lError := lCuerpo.O['error'];
        lError.S['codigo'] := lCodigo;
        lError.S['mensaje'] := lMensaje;
        lDetalles := lError.A['detalles'];
        if E is EMVCValidationException then
        begin
          lErrores := EMVCValidationException(E).ValidationErrors;
          if lErrores <> nil then
            for lPar in lErrores do
            begin
              lDetalle := lDetalles.AddObject;
              lDetalle.S['campo'] := lPar.Key;
              lDetalle.S['mensaje'] := lPar.Value;
            end;
        end;

        WebContext.Response.StatusCode := lStatus;
        WebContext.Response.ContentType := TIPO_JSON_UTF8;
        WebContext.Response.Content := lCuerpo.ToJSON(False);
      finally
        lCuerpo.Free;
      end;

      ExceptionHandled := True;
    end;
end;

end.
