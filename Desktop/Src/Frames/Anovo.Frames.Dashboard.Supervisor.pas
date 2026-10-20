unit Anovo.Frames.Dashboard.Supervisor;

// Dashboard del supervisor: lo que espera revision, el visto bueno y la
// tasa del mes, la carga de cada persona y lo estancado.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Tarjeta,
  Anovo.UI.Dashboard,
  Anovo.Frames.Dashboard,
  Anovo.DTOs.Dashboard,
  Anovo.Vistas.Intf.Dashboard,
  Anovo.Presentadores.Dashboard;

type
  TfraDashboardSupervisor = class(TfraDashboard, IVistaDashboard<TDashboardSupervisorDTO>)
    lblIcono1: TLabel;
    lblNota1: TLabel;
    lblIcono2: TLabel;
    lblNota2: TLabel;
    lblIcono3: TLabel;
    lblNota3: TLabel;
    lblIcono4: TLabel;
    lblNota4: TLabel;
    gpTarjetas: TGridPanel;
    tjBarras: TPlanoTarjeta;
    lblCabeceraBarras: TLabel;
    pbBarras: TPaintBox;
    tjAvisos: TPlanoTarjeta;
    lblCabeceraAvisos: TLabel;
    pbAvisos: TPaintBox;
  private
    FPresentador: TPresentadorDashboard<TDashboardSupervisorDTO>;
    FBarras: TDibujoBarras;
    FAvisos: TDibujoAvisos;
    procedure MostrarDashboard(const ADatos: TDashboardSupervisorDTO);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Textos,
  Anovo.Api.Intf.Dashboard,
  Anovo.Api.Dashboard,
  Anovo.UI.Tema,
  Anovo.Formato;

constructor TfraDashboardSupervisor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBarras := TDibujoBarras.Crear(pbBarras);
  FAvisos := NuevosAvisos(pbAvisos);

  FPresentador := TPresentadorDashboard<TDashboardSupervisorDTO>.Create(Self,
    TApiDashboard.Create,
    function(AApi: IApiDashboard): TDashboardSupervisorDTO
    begin
      Result := AApi.Supervisor;
    end);
  lblTitulo.Caption := FPresentador.Saludo;
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
  lblCifra1.Caption := ADatos.PorAprobar.ToString;
  lblCifra2.Caption := ADatos.VistoBuenoMes.ToString;
  lblCifra3.Caption := TFormato.Tasa(ADatos.TasaAprobacion);
  lblCifra4.Caption := TFormato.Colones(ADatos.MontoAprobadoMes);
  lblNota1.Caption := TFormato.MasAntigua(ADatos.DiasMasAntigua);
  lblNota2.Caption := Format(SNotaDevueltasMes, [ADatos.DevueltasMes]);
  lblNota3.Caption := TFormato.VariacionPuntos(ADatos.VariacionTasa);
  lblNota4.Caption := TFormato.VariacionPorcentual(ADatos.VariacionMonto);
  FBarras.Poner(FilasDeBarras(ADatos.Carga, clAnovoMarca));
  FAvisos.Poner(AvisosEstancados(ADatos.Estancadas));
end;

end.
