unit Anovo.Presentadores.Dashboard;

// Presentador de los dashboards: pide a la API los datos del rol
// con la funcion que recibe y se los entrega a la vista.

interface

uses
  System.SysUtils,
  Anovo.Api.Intf.Dashboard,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Dashboard,
  Anovo.Textos;

type
  TPresentadorDashboard<T: class> = class(TPresentadorBase)
  private
    FVista: IVistaDashboard<T>;
    FApi: IApiDashboard;
    FPedir: TFunc<IApiDashboard, T>;
  public
    constructor Create(const AVista: IVistaDashboard<T>;
      const AApi: IApiDashboard; const APedir: TFunc<IApiDashboard, T>);
    procedure Iniciar;
    procedure Recargar;
  end;

implementation

constructor TPresentadorDashboard<T>.Create(const AVista: IVistaDashboard<T>;
  const AApi: IApiDashboard; const APedir: TFunc<IApiDashboard, T>);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FPedir := APedir;
end;

procedure TPresentadorDashboard<T>.Iniciar;
begin
  Recargar;
end;

procedure TPresentadorDashboard<T>.Recargar;
var
  lApi: IApiDashboard;
  lPedir: TFunc<IApiDashboard, T>;
begin
  lApi := FApi;
  lPedir := FPedir;

  Ejecutar<T>(SAccionCargarDashboard,
    function: T
    begin
      Result := lPedir(lApi);
    end,
    procedure(ADatos: T)
    begin
      FVista.MostrarDashboard(ADatos);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end);
end;

end.
