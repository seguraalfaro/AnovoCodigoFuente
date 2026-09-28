unit Anovo.Presentadores.DashboardGerencia;

// Presentador del dashboard de gerencia.

interface

uses
  Anovo.Api.Intf.Dashboard,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.DashboardGerencia;

type
  TPresentadorDashboardGerencia = class
  private
    FVista: IVistaDashboardGerencia;
    FApi: IApiDashboard;
    FCancelacion: ICancelacion;
  public
    constructor Create(const AVista: IVistaDashboardGerencia;
      const AApi: IApiDashboard);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Recargar;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  Anovo.Api.Base,
  Anovo.DTOs.Dashboard,
  Anovo.Textos;

function MensajeInesperado: string;
begin
  Result := Format(SErrorInesperado, [SAccionCargarDashboard]);
end;

constructor TPresentadorDashboardGerencia.Create(const AVista
  : IVistaDashboardGerencia; const AApi: IApiDashboard);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
end;

destructor TPresentadorDashboardGerencia.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorDashboardGerencia.Iniciar;
begin
  Recargar;
end;

procedure TPresentadorDashboardGerencia.Recargar;
var
  lCancelacion: ICancelacion;
  lApi: IApiDashboard;
begin
  lCancelacion := FCancelacion;
  lApi := FApi;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lDatos: TDashboardGerenciaDTO;
      lError: string;
    begin
      lDatos := nil;
      lError := '';
      try
        lDatos := lApi.Gerencia;
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MensajeInesperado;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FVista.MostrarDashboard(lDatos);
          finally
            lDatos.Free;
          end;
        end);
    end);
end;

end.
