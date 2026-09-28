unit Anovo.Frames.Dashboard.Supervisor;

// Dashboard del supervisor: cifras del mes y cola
// de cotizaciones por aprobar.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Tarjeta,
  Anovo.Frames.Dashboard,
  Anovo.DTOs.Dashboard,
  Anovo.Vistas.Intf.DashboardSupervisor,
  Anovo.Presentadores.DashboardSupervisor;

type
  TfraDashboardSupervisor = class(TfraDashboard, IVistaDashboardSupervisor)
    lblMontoAprobado: TLabel;
    procedure grListaDblClick(Sender: TObject);
  private
    FPresentador: TPresentadorDashboardSupervisor;
    procedure MostrarDashboard(const ADatos: TDashboardSupervisorDTO);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Vistas.Intf.Principal,
  Anovo.Mensajes,
  Anovo.Api.Dashboard,
  Anovo.Formato,
  Anovo.Datos.Memoria;

constructor TfraDashboardSupervisor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPresentador := TPresentadorDashboardSupervisor.Create(Self,
    TApiDashboard.Create);
  FPresentador.Iniciar;
end;

destructor TfraDashboardSupervisor.Destroy;
begin
  FPresentador.Free;
  inherited;
end;

procedure TfraDashboardSupervisor.MostrarDashboard(const ADatos
  : TDashboardSupervisorDTO);
begin
  lblPeriodo.Caption := TFormato.MesAnio(ADatos.Desde);
  lblCifra1.Caption := ADatos.PorAprobar.ToString;
  lblCifra2.Caption := TFormato.Dias(ADatos.DiasMasAntigua);
  lblCifra3.Caption := ADatos.AprobadasMes.ToString;
  lblMontoAprobado.Caption := TFormato.Colones(ADatos.MontoAprobadoMes);
  lblCifra4.Caption := ADatos.RechazadasMes.ToString;
  MostrarLista<TCotizacionPorAprobarDTO>(ADatos.Cola,
    dmMemoria.mtDashboardSupervisor);
end;

procedure TfraDashboardSupervisor.grListaDblClick(Sender: TObject);
begin
  if not dmMemoria.mtDashboardSupervisor.IsEmpty then
    PedirSeccion(secBandeja);
end;

end.
