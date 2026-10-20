unit Anovo.Presentadores.Registro;

// Presentadores de las ventanas de cliente nuevo y
// contacto nuevo.

interface

uses
  System.SysUtils,
  Anovo.Api.Intf.Clientes,
  Anovo.Presentadores.Base,
  Anovo.DTOs.Clientes,
  Anovo.Vistas.Intf.Registro;

type
  TPresentadorRegistro = class(TPresentadorBase)
  protected
    FVista: IVistaRegistro;
    FApi: IApiClientes;
    procedure Enviar(const ACrear: TFunc<Integer>; const ADto: TObject);
  public
    constructor Create(const AVista: IVistaRegistro; const AApi: IApiClientes);
  end;

  TPresentadorClienteNuevo = class(TPresentadorRegistro)
  public
    procedure Guardar(const ADto: TClienteNuevoDTO);
  end;

  TPresentadorContactoNuevo = class(TPresentadorRegistro)
  private
    FClienteId: Integer;
  public
    constructor Create(const AVista: IVistaRegistro; const AApi: IApiClientes;
      const AClienteId: Integer);
    procedure Guardar(const ADto: TContactoNuevoDTO);
    procedure Actualizar(const AContactoId: Integer;
      const ADto: TContactoEdicionDTO);
  end;

implementation

uses
  Anovo.Textos;

constructor TPresentadorRegistro.Create(const AVista: IVistaRegistro;
  const AApi: IApiClientes);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
end;

procedure TPresentadorRegistro.Enviar(const ACrear: TFunc<Integer>;
  const ADto: TObject);
var
  lId: Integer;
begin
  lId := 0;

  Ejecutar(SAccionGuardar,
    procedure
    begin
      lId := ACrear();
    end,
    procedure
    begin
      FVista.Guardado(lId);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarGuardando(AActivo);
    end,
    procedure
    begin
      ADto.Free;
    end);
end;

procedure TPresentadorClienteNuevo.Guardar(const ADto: TClienteNuevoDTO);
var
  lApi: IApiClientes;
begin
  lApi := FApi;
  Enviar(
    function: Integer
    begin
      Result := lApi.Crear(ADto);
    end, ADto);
end;

constructor TPresentadorContactoNuevo.Create(const AVista: IVistaRegistro;
  const AApi: IApiClientes; const AClienteId: Integer);
begin
  inherited Create(AVista, AApi);
  FClienteId := AClienteId;
end;

procedure TPresentadorContactoNuevo.Guardar(const ADto: TContactoNuevoDTO);
var
  lApi: IApiClientes;
  lCliente: Integer;
begin
  lApi := FApi;
  lCliente := FClienteId;
  Enviar(
    function: Integer
    begin
      Result := lApi.CrearContacto(lCliente, ADto);
    end, ADto);
end;

procedure TPresentadorContactoNuevo.Actualizar(const AContactoId: Integer;
  const ADto: TContactoEdicionDTO);
var
  lApi: IApiClientes;
  lCliente: Integer;
begin
  lApi := FApi;
  lCliente := FClienteId;
  Enviar(
    function: Integer
    begin
      lApi.ActualizarContacto(lCliente, AContactoId, ADto);
      Result := AContactoId;
    end, ADto);
end;

end.
