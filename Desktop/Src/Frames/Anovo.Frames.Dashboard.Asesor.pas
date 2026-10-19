unit Anovo.Frames.Dashboard.Asesor;

// Dashboard del asesor: cifras del mes, como van sus solicitudes y los
// clientes a los que conviene llamar.

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
  TfraDashboardAsesor = class(TfraDashboard, IVistaDashboard<TDashboardAsesorDTO>)
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
    FPresentador: TPresentadorDashboard<TDashboardAsesorDTO>;
    procedure MostrarDashboard(const ADatos: TDashboardAsesorDTO);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Textos,
  Anovo.UI.CeldasRejilla,
  Anovo.Api.Intf.Dashboard,
  Anovo.Api.Dashboard,
  Anovo.Formato,
  Anovo.Datos.Memoria;


constructor TfraDashboardAsesor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  PrepararRejilla(grBarras);
  PrepararAvisos(grAvisos);

  FPresentador := TPresentadorDashboard<TDashboardAsesorDTO>.Create(Self,
    TApiDashboard.Create,
    function(AApi: IApiDashboard): TDashboardAsesorDTO
    begin
      Result := AApi.Asesor;
    end);
  FPresentador.Iniciar;
end;

destructor TfraDashboardAsesor.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraDashboardAsesor.MostrarDashboard(const ADatos
  : TDashboardAsesorDTO);
begin
  lblPeriodo.Caption := TFormato.MesAnio(ADatos.Desde);
  lblCifra1.Caption := ADatos.SolicitudesMes.ToString;
  lblCifra2.Caption := ADatos.EsperandoCotizacion.ToString;
  lblCifra3.Caption := ADatos.AprobadasMes.ToString;
  lblCifra4.Caption := TFormato.Colones(ADatos.MontoAprobadoMes);
  lblNota1.Caption := TFormato.Variacion(ADatos.SolicitudesMes,
    ADatos.SolicitudesMesAnterior);
  lblNota2.Caption := TFormato.MasAntigua(ADatos.DiasMasAntigua);
  lblNota3.Caption := Format(SNotaTasaGeneral, [ADatos.TasaAprobacion]);
  lblNota4.Caption := '';
  MostrarBarras(grBarras, ADatos.PorEstado);
  MostrarAvisos(grAvisos, ADatos.PorLlamar);
end;

end.
