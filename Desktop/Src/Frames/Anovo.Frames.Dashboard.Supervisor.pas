unit Anovo.Frames.Dashboard.Supervisor;

// Dashboard del supervisor: lo que espera revision, como va el mes, la carga
// del equipo y las cotizaciones estancadas.

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
  TfraDashboardSupervisor = class(TfraDashboard, IVistaDashboard<TDashboardSupervisorDTO>)
    lblNota1: TLabel;
    lblNota2: TLabel;
    lblNota3: TLabel;
    lblNota4: TLabel;
    gpTarjetas: TGridPanel;
    tjBarras: TPlanoTarjeta;
    grBarras: TrDBGrid;
    tjAvisos: TPlanoTarjeta;
    grAvisos: TrDBGrid;
  private
    FPresentador: TPresentadorDashboard<TDashboardSupervisorDTO>;
    procedure MostrarDashboard(const ADatos: TDashboardSupervisorDTO);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Textos,
  Anovo.Vistas.Intf.Principal,
  Anovo.Mensajes,
  Anovo.Api.Intf.Dashboard,
  Anovo.Api.Dashboard,
  Anovo.Formato,
  Anovo.Datos.Memoria;

constructor TfraDashboardSupervisor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  PrepararRejilla(grBarras);
  PrepararAvisos(grAvisos);

  FPresentador := TPresentadorDashboard<TDashboardSupervisorDTO>.Create(Self,
    TApiDashboard.Create,
    function(AApi: IApiDashboard): TDashboardSupervisorDTO
    begin
      Result := AApi.Supervisor;
    end);
  FPresentador.Iniciar;
end;

destructor TfraDashboardSupervisor.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraDashboardSupervisor.MostrarDashboard(const ADatos
  : TDashboardSupervisorDTO);
begin
  lblPeriodo.Caption := TFormato.MesAnio(ADatos.Desde);
  lblCifra1.Caption := ADatos.PorAprobar.ToString;
  lblCifra2.Caption := ADatos.VistoBuenoMes.ToString;
  lblCifra3.Caption := TFormato.Tasa(ADatos.TasaAprobacion);
  lblCifra4.Caption := TFormato.Colones(ADatos.MontoAprobadoMes);
  lblNota1.Caption := TFormato.MasAntigua(ADatos.DiasMasAntigua);
  lblNota2.Caption := Format(SNotaDevueltasMes, [ADatos.DevueltasMes]);
  lblNota3.Caption := Format(SNotaRespuestasMes, [ADatos.AprobadasMes,
    ADatos.RechazadasMes]);
  lblNota4.Caption := TFormato.VariacionPorcentual(ADatos.MontoAprobadoMes,
    ADatos.MontoAprobadoAnterior);
  MostrarBarras(grBarras, ADatos.Carga);
  MostrarAvisos(grAvisos, ADatos.Estancadas);
end;

end.
