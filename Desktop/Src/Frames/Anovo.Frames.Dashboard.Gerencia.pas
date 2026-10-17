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
  Anovo.Vistas.Intf.Dashboard,
  Anovo.Presentadores.Dashboard;

type
  TfraDashboardGerencia = class(TfraDashboard, IVistaDashboard<TDashboardGerenciaDTO>)
    lblDecididas: TLabel;
    tjEstados: TPlanoTarjeta;
    grEstados: TrDBGrid;
  private
    FPresentador: TPresentadorDashboard<TDashboardGerenciaDTO>;
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
  System.Math,
  Anovo.UI.Tema,
  Anovo.UI.CeldasRejilla,
  Anovo.Mapeo.Datos,
  Anovo.Api.Intf.Dashboard,
  Anovo.Api.Dashboard,
  Anovo.Formato,
  Anovo.Textos,
  Anovo.Datos.Memoria;

const
  CAMPO_ESTADO = 'ESTADO';
  PORCENTAJE_ESTADOS = 38;
  ANCHO_ESTADOS_MINIMO = 330;
  ANCHO_ESTADOS_MAXIMO = 480;

constructor TfraDashboardGerencia.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AplicarTemaGrid(grEstados);
  TCeldasRejilla.De(grEstados).ColumnaEstado(CAMPO_ESTADO);

  FPresentador := TPresentadorDashboard<TDashboardGerenciaDTO>.Create(Self,
    TApiDashboard.Create,
    function(AApi: IApiDashboard): TDashboardGerenciaDTO
    begin
      Result := AApi.Gerencia;
    end);
  FPresentador.Iniciar;
end;

destructor TfraDashboardGerencia.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraDashboardGerencia.Resize;
begin
  inherited;
  tjEstados.Width := EnsureRange(ClientWidth * PORCENTAJE_ESTADOS div 100,
    ScaleValue(ANCHO_ESTADOS_MINIMO), ScaleValue(ANCHO_ESTADOS_MAXIMO));
  Anovo.UI.CeldasRejilla.AjustarColumnas(grEstados);
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
  Anovo.UI.CeldasRejilla.AjustarColumnas(grEstados);
end;

end.
