unit Anovo.Presentadores.Base;

// Base de los presentadores: corre el trabajo en segundo plano y
// entrega el resultado en el hilo de la pantalla, si sigue abierta.

interface

uses
  System.SysUtils,
  Anovo.Cancelacion;

type
  TPresentadorBase = class
  private
    FCancelacion: ICancelacion;
    FSolicitud: Integer;
  protected
    function Cancelacion: ICancelacion;
    procedure CancelarPendientes;
    procedure Ejecutar(const AAccion: string; const ATrabajo: TProc;
      const AListo: TProc; const AError: TProc<string>;
      const AOcupado: TProc<Boolean> = nil;
      const ALiberar: TProc = nil); overload;
    procedure Ejecutar<T: class>(const AAccion: string;
      const ATrabajo: TFunc<T>; const AListo: TProc<T>;
      const AError: TProc<string>;
      const AOcupado: TProc<Boolean> = nil); overload;
    procedure EjecutarUltima<T: class>(const AAccion: string;
      const ATrabajo: TFunc<T>; const AListo: TProc<T>;
      const AError: TProc<string>; const AOcupado: TProc<Boolean>);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.Classes,
  System.Threading,
  Anovo.Api.Base,
  Anovo.Textos;

constructor TPresentadorBase.Create;
begin
  inherited Create;
  FCancelacion := TCancelacion.Create;
end;

destructor TPresentadorBase.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

function TPresentadorBase.Cancelacion: ICancelacion;
begin
  Result := FCancelacion;
end;

procedure TPresentadorBase.CancelarPendientes;
begin
  FCancelacion.Cancelar;
  FCancelacion := TCancelacion.Create;
end;

procedure TPresentadorBase.Ejecutar(const AAccion: string;
  const ATrabajo: TProc; const AListo: TProc; const AError: TProc<string>;
  const AOcupado: TProc<Boolean>; const ALiberar: TProc);
var
  lCancelacion: ICancelacion;
begin
  lCancelacion := FCancelacion;
  if Assigned(AOcupado) then
    AOcupado(True);

  TTask.Run(
    procedure
    var
      lError: string;
    begin
      lError := '';
      try
        ATrabajo();
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := Format(SErrorInesperado, [AAccion]);
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada then
              Exit;
            if Assigned(AOcupado) then
              AOcupado(False);
            if lError.IsEmpty then
              AListo()
            else if Assigned(AError) then
              AError(lError);
          finally
            if Assigned(ALiberar) then
              ALiberar();
          end;
        end);
    end);
end;

procedure TPresentadorBase.Ejecutar<T>(const AAccion: string;
  const ATrabajo: TFunc<T>; const AListo: TProc<T>;
  const AError: TProc<string>; const AOcupado: TProc<Boolean>);
var
  lResultado: T;
begin
  lResultado := nil;
  Ejecutar(AAccion,
    procedure
    begin
      lResultado := ATrabajo();
    end,
    procedure
    begin
      AListo(lResultado);
    end, AError, AOcupado,
    procedure
    begin
      lResultado.Free;
    end);
end;

procedure TPresentadorBase.EjecutarUltima<T>(const AAccion: string;
  const ATrabajo: TFunc<T>; const AListo: TProc<T>;
  const AError: TProc<string>; const AOcupado: TProc<Boolean>);
var
  lNumero: Integer;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;

  Ejecutar<T>(AAccion, ATrabajo,
    procedure(AResultado: T)
    begin
      if lNumero = FSolicitud then
        AListo(AResultado);
    end,
    procedure(AMensaje: string)
    begin
      if (lNumero = FSolicitud) and Assigned(AError) then
        AError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      if (lNumero = FSolicitud) and Assigned(AOcupado) then
        AOcupado(AActivo);
    end);
end;

end.
