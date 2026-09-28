unit Anovo.Frames.Dashboard.Gerencia;

// Dashboard de gerencia: cifras del mes, productividad
// por asesor y cotizaciones por estado.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Tarjeta,
  Anovo.Frames.Dashboard,
  Anovo.DTOs.Dashboard,
  Anovo.Vistas.Intf.DashboardGerencia,
  Anovo.Presentadores.DashboardGerencia;

type
  TfraDashboardGerencia = class(TfraDashboard, IVistaDashboardGerencia)
    lblDecididas: TLabel;
    tjEstados: TPlanoTarjeta;
    grEstados: TrDBGrid;
  private
    FPresentador: TPresentadorDashboardGerencia;
    procedure MostrarDashboard(const ADatos: TDashboardGerenciaDTO);
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  Anovo.Mapeo.Datos,
  Anovo.Api.Dashboard,
  Anovo.Formato,
  Anovo.Textos,
  Anovo.Datos.Memoria;

const
  CAMPO_ESTADO = 'ESTADO';

constructor TfraDashboardGerencia.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grEstados);
  TDBGridExtend.De(grEstados).ColumnaEstado(CAMPO_ESTADO);

  FPresentador := TPresentadorDashboardGerencia.Create(Self,
    TApiDashboard.Create);
  FPresentador.Iniciar;
end;

destructor TfraDashboardGerencia.Destroy;
begin
  FPresentador.Free;
  inherited;
end;

procedure TfraDashboardGerencia.Resize;
begin
  inherited;
  Anovo.UI.DBGridExtend.AjustarColumnas(grEstados);
end;

procedure TfraDashboardGerencia.MostrarDashboard(const ADatos
  : TDashboardGerenciaDTO);
begin
  lblPeriodo.Caption := TFormato.MesAnio(ADatos.Desde);
  lblCifra1.Caption := TFormato.Colones(ADatos.CotizadoMes);
  lblCifra2.Caption := Format(SPorcentaje, [ADatos.TasaAprobacion]);
  lblDecididas.Caption := Format(SDecididasMes, [ADatos.AprobadasMes,
    ADatos.AprobadasMes + ADatos.RechazadasMes]);
  lblCifra3.Caption := TFormato.Dias(ADatos.RespuestaMedia);
  lblCifra4.Caption := ADatos.AsesoresActivos.ToString;
  MostrarLista<TProductividadAsesorDTO>(ADatos.Productividad,
    dmMemoria.mtDashboardGerencia);
  TMapeoDatos.AListaTabla<TCotizacionesPorEstadoDTO>(ADatos.Estados,
    dmMemoria.mtDashboardEstados);
  Anovo.UI.DBGridExtend.AjustarColumnas(grEstados);
end;

end.
