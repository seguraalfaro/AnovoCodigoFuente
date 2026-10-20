unit Anovo.Frames.Dashboard.Asesor;

// Dashboard del asesor: cifras del mes, como van sus solicitudes y los
// clientes a los que conviene llamar.

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
  TfraDashboardAsesor = class(TfraDashboard, IVistaDashboard<TDashboardAsesorDTO>)
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
    pbBarras: TPaintBox;
    tjAvisos: TPlanoTarjeta;
    lblCabeceraAvisos: TLabel;
    pbAvisos: TPaintBox;
  private
    FPresentador: TPresentadorDashboard<TDashboardAsesorDTO>;
    FBarras: TDibujoBarras;
    FAvisos: TDibujoAvisos;
    procedure MostrarDashboard(const ADatos: TDashboardAsesorDTO);
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

constructor TfraDashboardAsesor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBarras := TDibujoBarras.Crear(pbBarras);
  FAvisos := NuevosAvisos(pbAvisos);

  FPresentador := TPresentadorDashboard<TDashboardAsesorDTO>.Create(Self,
    TApiDashboard.Create,
    function(AApi: IApiDashboard): TDashboardAsesorDTO
    begin
      Result := AApi.Asesor;
    end);
  lblTitulo.Caption := FPresentador.Saludo;
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
  lblCifra1.Caption := ADatos.SolicitudesMes.ToString;
  lblCifra2.Caption := ADatos.EsperandoCotizacion.ToString;
  lblCifra3.Caption := ADatos.AprobadasMes.ToString;
  lblCifra4.Caption := TFormato.Colones(ADatos.MontoAprobadoMes);
  lblNota1.Caption := TFormato.Variacion(ADatos.VariacionSolicitudes,
    ADatos.MesAnterior);
  lblNota2.Caption := TFormato.MasAntigua(ADatos.DiasMasAntigua);
  lblNota3.Caption := Format(SNotaTasaGeneral,
    [TFormato.Tasa(ADatos.TasaAprobacion)]);
  lblNota4.Caption := TFormato.VariacionPorcentual(ADatos.VariacionMonto,
    ADatos.MesAnterior);
  FBarras.Poner(FilasDeBarras(ADatos.PorEstado));
  FAvisos.Poner(AvisosPorLlamar(ADatos.PorLlamar));
end;

end.
