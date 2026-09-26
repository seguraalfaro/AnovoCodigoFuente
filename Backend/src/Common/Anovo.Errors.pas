unit Anovo.Errors;
// Excepciones de dominio y la forma unica del error.
//
// Las dos mitades van juntas a proposito. Las clases por si solas no cambian
// nada: DMVC convierte cualquier excepcion en respuesta con SU forma, asi que
// sin el manejador de abajo el cuerpo sigue siendo el del framework.
//
// La forma es la del contrato:
//
//   { "error": { "codigo": "...", "mensaje": "...", "detalles": [] } }
//
// Siempre la misma, para todos los errores, incluidos los que no lanzamos
// nosotros. B4A tiene un solo camino de parseo y no puede llevar dos.
//
// El cliente compara por 'codigo', nunca por 'mensaje': el mensaje se reescribe
// cuando alguien lo lee en pantalla y no le gusta como suena.

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

  // 404. El id no existe, o existe y el que pregunta no tiene por que saberlo.
  ERecursoNoEncontrado = class(EAnovoError)
  public
    constructor Create(const ARecurso: string; const AId: Integer); reintroduce;
  end;

  // 403. Token valido, rol corto. Distinto del 401, que es no haber entrado.
  ESinPermiso = class(EAnovoError)
  public
    constructor Create(const AAccion: string); reintroduce;
  end;

  // 409. El telefono edito sobre una version que ya no es la vigente. No es un
  // error del usuario: es el caso normal de dos personas sobre el mismo cliente.
  EVersionVencida = class(EAnovoError)
  public
    constructor Create(const ARecurso: string; const AId: Integer); reintroduce;
  end;

  // 409. La operacion no cabe en el estado actual: aprobar lo ya aprobado,
  // editar un cliente anonimizado.
  EConflictoDeEstado = class(EAnovoError)
  public
    constructor Create(const ACodigo, AMensaje: string); reintroduce;
  end;

  // 422. Regla de negocio que ningun validador por atributo puede expresar.
  EDatoInvalido = class(EAnovoError)
  public
    constructor Create(const AMensaje: string); reintroduce;
  end;

// Se registra con AEngine.SetExceptionHandler en Anovo.Config.Engine.
function ManejadorDeErrores: TMVCExceptionHandlerProc;

implementation

uses
  JsonDataObjects,
  MVCFramework.Logger,
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord;

{ EAnovoError }

constructor EAnovoError.Create(const ACodigo, AMensaje: string;
  const AStatus: UInt16);
begin
  inherited Create(AStatus, AMensaje);
  fCodigo := ACodigo;
end;

{ ERecursoNoEncontrado }

constructor ERecursoNoEncontrado.Create(const ARecurso: string;
  const AId: Integer);
begin
  inherited Create('RECURSO_NO_ENCONTRADO',
    Format('No existe %s con el numero %d.', [ARecurso, AId]),
    HTTP_STATUS.NotFound);
end;

{ ESinPermiso }

constructor ESinPermiso.Create(const AAccion: string);
begin
  inherited Create('SIN_PERMISO',
    Format('Su perfil no tiene permitido %s.', [AAccion]),
    HTTP_STATUS.Forbidden);
end;

{ EVersionVencida }

constructor EVersionVencida.Create(const ARecurso: string;
  const AId: Integer);
begin
  // El mensaje dice que hacer, no solo que fallo: quien lo lee esta a mitad de
  // una edicion y necesita saber que no perdio nada, que tiene que recargar.
  inherited Create('VERSION_VENCIDA',
    Format('Otra persona modifico %s %d mientras usted lo editaba. ' +
    'Recargue y vuelva a aplicar sus cambios.', [ARecurso, AId]),
    HTTP_STATUS.Conflict);
end;

{ EConflictoDeEstado }

constructor EConflictoDeEstado.Create(const ACodigo, AMensaje: string);
begin
  inherited Create(ACodigo, AMensaje, HTTP_STATUS.Conflict);
end;

{ EDatoInvalido }

constructor EDatoInvalido.Create(const AMensaje: string);
begin
  inherited Create('DATO_INVALIDO', AMensaje,
    HTTP_STATUS.UnprocessableEntity);
end;

{ el manejador }

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
        // Ruta sin controller. DMVC no lanza excepcion en este caso: deja el
        // 404 puesto en la respuesta y llama al manejador con E en nil
        // (MVCFramework.pas:3226-3233). Sin esta rama ningun "E is" acierta
        // -nil no es instancia de nada-, se cae al else final y el 404 sale
        // convertido en 500: al cliente se le dice que avise al administrador
        // por haber escrito mal una URL, y el log se llena de alarmas falsas.
        lCodigo := 'RUTA_NO_ENCONTRADA';
        lMensaje := 'La direccion solicitada no existe.';
        // El que ya dejo el framework, no uno fijo: si manana llama por otro
        // motivo, se respeta.
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
        // Las dos capas de validacion de la 3.5: EMVCStorageValidationException
        // desciende de EMVCValidationException, asi que este is cubre las dos.
        // El mensaje ya viene armado por
        // el framework con los campos que fallaron, y como los validadores
        // llevan texto propio en castellano, sale legible.
        lCodigo := 'VALIDACION';
        lMensaje := E.Message;
        lStatus := HTTP_STATUS.UnprocessableEntity;
      end
      else if E is EMVCActiveRecordVersionedItemNotFound then
      begin
        // ANTES que EMVCActiveRecordNotFound, del que desciende. Al reves, un
        // choque de versiones saldria como 404 y el cliente concluiria que el
        // registro se borro, cuando lo que pasa es que otro lo edito.
        //
        // El framework la lanza cuando el UPDATE con
        // ... AND OBJVERSION = :vieja  afecta cero filas.
        lCodigo := 'VERSION_VENCIDA';
        lMensaje := 'Otra persona modifico el registro mientras usted lo ' +
          'editaba. Recargue y vuelva a aplicar sus cambios.';
        lStatus := HTTP_STATUS.Conflict;
      end
      else if E is EMVCActiveRecordNotFound then
      begin
        lCodigo := 'RECURSO_NO_ENCONTRADO';
        lMensaje := 'El recurso solicitado no existe.';
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
        // Lo no previsto. Al log va todo; al cliente, nada. Un stack o un
        // fragmento de SQL en la respuesta le dice a quien lo reciba como esta
        // hecha la base por dentro.
        LogE(Format('Excepcion no controlada %s: %s', [E.ClassName, E.Message]));
        lCodigo := 'ERROR_INTERNO';
        lMensaje := 'Ocurrio un error inesperado. Intente de nuevo; ' +
          'si persiste, avise al administrador.';
        lStatus := HTTP_STATUS.InternalServerError;
      end;

      lCuerpo := TJSONObject.Create;
      try
        lError := lCuerpo.O['error'];
        lError.S['codigo'] := lCodigo;
        lError.S['mensaje'] := lMensaje;
        // Vacio salvo en validacion, pero va siempre: un campo que a veces
        // existe y a veces no obliga al cliente a preguntar antes de leerlo.
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

