unit Anovo.Presentadores.Base;

// Base de los presentadores: corre el trabajo en segundo plano y
// entrega el resultado en el hilo de la pantalla, si sigue abierta.
// El estado ocupado se lleva por contador de llamadas en vuelo.

interface

uses
  System.SysUtils,
  Anovo.Cancelacion;

type
  TPresentadorBase = class
  private
    FCancelacion: ICancelacion;
    FSolicitud: Integer;
    FEnVuelo: Integer;
    FApagar: TProc<Boolean>;
    procedure Encender(const AOcupado: TProc<Boolean>);
    procedure Apagar;
    procedure ApagarTodo;
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
    procedure Diferir(const AProc: TProc; const ALiberar: TProc = nil);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.Classes,
  System.Math,
  System.Threading,
  Anovo.Api.Base,
  Anovo.Textos;

const
  HILOS_MINIMOS = 8;

constructor TPresentadorBase.Create;
begin
  inherited Create;
  FCancelacion := TCancelacion.Create;
end;

destructor TPresentadorBase.Destroy;
begin
  FCancelacion.Cancelar;
  ApagarTodo;
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
  ApagarTodo;
end;

procedure TPresentadorBase.Encender(const AOcupado: TProc<Boolean>);
begin
  if not Assigned(AOcupado) then
    Exit;
  Inc(FEnVuelo);
  if FEnVuelo = 1 then
  begin
    FApagar := AOcupado;
    AOcupado(True);
  end;
end;

procedure TPresentadorBase.Apagar;
begin
  if FEnVuelo = 0 then
    Exit;
  Dec(FEnVuelo);
  if (FEnVuelo = 0) and Assigned(FApagar) then
  begin
    FApagar(False);
    FApagar := nil;
  end;
end;

procedure TPresentadorBase.ApagarTodo;
begin
  if (FEnVuelo > 0) and Assigned(FApagar) then
    FApagar(False);
  FEnVuelo := 0;
  FApagar := nil;
end;

procedure TPresentadorBase.Diferir(const AProc: TProc; const ALiberar: TProc);
var
  lCancelacion: ICancelacion;
begin
  lCancelacion := FCancelacion;
  TThread.ForceQueue(nil,
    procedure
    begin
      try
        if not lCancelacion.Cancelada then
          AProc();
      finally
        if Assigned(ALiberar) then
          ALiberar();
      end;
    end);
end;

procedure TPresentadorBase.Ejecutar(const AAccion: string;
  const ATrabajo: TProc; const AListo: TProc; const AError: TProc<string>;
  const AOcupado: TProc<Boolean>; const ALiberar: TProc);
var
  lCancelacion: ICancelacion;
  lConOcupado: Boolean;
begin
  lCancelacion := FCancelacion;
  lConOcupado := Assigned(AOcupado);
  Encender(AOcupado);

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
            if lConOcupado then
              Apagar;
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
    end, AOcupado);
end;

initialization

TThreadPool.Default.SetMinWorkerThreads(Max(HILOS_MINIMOS,
  TThread.ProcessorCount));

end.
