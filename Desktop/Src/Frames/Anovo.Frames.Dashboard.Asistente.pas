unit Anovo.Frames.Dashboard.Asistente;

// Dashboard del asistente: solicitudes por cotizar
// y cotizaciones en curso.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Tarjeta,
  Anovo.Frames.Dashboard,
  Anovo.DTOs.Dashboard,
  Anovo.Vistas.Intf.Dashboard,
  Anovo.Presentadores.Dashboard;

type
  TfraDashboardAsistente = class(TfraDashboard, IVistaDashboard<TDashboardAsistenteDTO>)
  private
    FPresentador: TPresentadorDashboard<TDashboardAsistenteDTO>;
    procedure MostrarDashboard(const ADatos: TDashboardAsistenteDTO);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Api.Intf.Dashboard,
  Anovo.Api.Dashboard,
  Anovo.Datos.Memoria;

constructor TfraDashboardAsistente.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPresentador := TPresentadorDashboard<TDashboardAsistenteDTO>.Create(Self,
    TApiDashboard.Create,
    function(AApi: IApiDashboard): TDashboardAsistenteDTO
    begin
      Result := AApi.Asistente;
    end);
  FPresentador.Iniciar;
end;

destructor TfraDashboardAsistente.Destroy;
begin
  FPresentador.Free;
  inherited;
end;

procedure TfraDashboardAsistente.MostrarDashboard(const ADatos
  : TDashboardAsistenteDTO);
begin
  lblCifra1.Caption := ADatos.PorCotizar.ToString;
  lblCifra2.Caption := ADatos.MisBorradores.ToString;
  lblCifra3.Caption := ADatos.EnAprobacion.ToString;
  lblCifra4.Caption := ADatos.PorEnviar.ToString;
  MostrarLista<TSolicitudPorCotizarDTO>(ADatos.Cola,
    dmMemoria.mtDashboardAsistente);
end;

end.
