unit Anovo.Presentadores.Registro;

// Presentadores de las ventanas de cliente nuevo y
// contacto nuevo.

interface

uses
  Anovo.Api.Intf.Clientes,
  Anovo.Cancelacion,
  Anovo.DTOs.Clientes,
  Anovo.Vistas.Intf.Registro;

type
  TPresentadorClienteNuevo = class
  private
    FVista: IVistaRegistro;
    FApi: IApiClientes;
    FCancelacion: ICancelacion;
  public
    constructor Create(const AVista: IVistaRegistro; const AApi: IApiClientes);
    destructor Destroy; override;
    procedure Guardar(const ADto: TClienteNuevoDTO);
  end;

  TPresentadorContactoNuevo = class
  private
    FVista: IVistaRegistro;
    FApi: IApiClientes;
    FCancelacion: ICancelacion;
    FClienteId: Integer;
  public
    constructor Create(const AVista: IVistaRegistro; const AApi: IApiClientes;
      const AClienteId: Integer);
    destructor Destroy; override;
    procedure Guardar(const ADto: TContactoNuevoDTO);
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  Anovo.Api.Base,
  Anovo.Textos;

function MensajeInesperado: string;
begin
  Result := Format(SErrorInesperado, [SAccionGuardar]);
end;

constructor TPresentadorClienteNuevo.Create(const AVista: IVistaRegistro;
  const AApi: IApiClientes);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
end;

destructor TPresentadorClienteNuevo.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorClienteNuevo.Guardar(const ADto: TClienteNuevoDTO);
var
  lCancelacion: ICancelacion;
  lApi: IApiClientes;
begin
  lCancelacion := FCancelacion;
  lApi := FApi;
  FVista.MostrarGuardando(True);

  TTask.Run(
    procedure
    var
      lId: Integer;
      lError: string;
    begin
      lId := 0;
      lError := '';
      try
        try
          lId := lApi.Crear(ADto);
        except
          on E: EAnovoCliente do
            lError := E.Message;
          on E: Exception do
            lError := MensajeInesperado;
        end;
      finally
        ADto.Free;
      end;

      TThread.Queue(nil,
        procedure
        begin
          if lCancelacion.Cancelada then
            Exit;
          FVista.MostrarGuardando(False);
          if lError.IsEmpty then
            FVista.Guardado(lId)
          else

            FVista.MostrarError(lError);
        end);
    end);
end;

constructor TPresentadorContactoNuevo.Create(const AVista: IVistaRegistro;
const AApi: IApiClientes; const AClienteId: Integer);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FClienteId := AClienteId;
  FCancelacion := TCancelacion.Create;
end;

destructor TPresentadorContactoNuevo.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorContactoNuevo.Guardar(const ADto: TContactoNuevoDTO);
var
  lCancelacion: ICancelacion;
  lApi: IApiClientes;
  lCliente: Integer;
begin
  lCancelacion := FCancelacion;
  lApi := FApi;
  lCliente := FClienteId;
  FVista.MostrarGuardando(True);

  TTask.Run(
    procedure
    var
      lId: Integer;
      lError: string;
    begin
      lId := 0;
      lError := '';
      try
        try
          lId := lApi.CrearContacto(lCliente, ADto);
        except
          on E: EAnovoCliente do
            lError := E.Message;
          on E: Exception do
            lError := MensajeInesperado;
        end;
      finally
        ADto.Free;
      end;

      TThread.Queue(nil,
        procedure
        begin
          if lCancelacion.Cancelada then
            Exit;
          FVista.MostrarGuardando(False);
          if lError.IsEmpty then
            FVista.Guardado(lId)
          else
            FVista.MostrarError(lError);
        end);
    end);
end;

end.
