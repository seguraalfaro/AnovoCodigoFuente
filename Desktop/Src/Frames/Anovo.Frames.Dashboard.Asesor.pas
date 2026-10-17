unit Anovo.Frames.Dashboard.Asesor;

// Dashboard del asesor: cifras del mes y solicitudes
// de la semana.

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
  Anovo.UI.CeldasRejilla,
  Anovo.Api.Intf.Dashboard,
  Anovo.Api.Dashboard,
  Anovo.Formato,
  Anovo.Datos.Memoria;

const
  CAMPO_ESTADO = 'ESTADO';

constructor TfraDashboardAsesor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TCeldasRejilla.De(grLista).ColumnaEstado(CAMPO_ESTADO);

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
  MostrarLista<TSolicitudAsesorDTO>(ADatos.Recientes,
    dmMemoria.mtDashboardAsesor);
end;

end.
