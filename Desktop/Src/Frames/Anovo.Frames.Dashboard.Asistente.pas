unit Anovo.Frames.Dashboard.Asistente;

// Dashboard del asistente: la cola, lo devuelto y por enviar, sus
// cotizaciones por etapa, lo que toca hoy y como va su mes.

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
  TfraDashboardAsistente = class(TfraDashboard, IVistaDashboard<TDashboardAsistenteDTO>)
    lblIcono1: TLabel;
    lblNota1: TLabel;
    lblIcono2: TLabel;
    lblNota2: TLabel;
    lblIcono3: TLabel;
    lblNota3: TLabel;
    lblIcono4: TLabel;
    lblNota4: TLabel;
    gpTarjetas: TGridPanel;
    tjEtapas: TPlanoTarjeta;
    pbEtapas: TPaintBox;
    tjAvisos: TPlanoTarjeta;
    lblCabeceraAvisos: TLabel;
    pbAvisos: TPaintBox;
    tjDatos: TPlanoTarjeta;
    pbDatos: TPaintBox;
  private
    FPresentador: TPresentadorDashboard<TDashboardAsistenteDTO>;
    FEtapas: TDibujoEtapas;
    FAvisos: TDibujoAvisos;
    FDatos: TDibujoDatos;
    procedure MostrarDashboard(const ADatos: TDashboardAsistenteDTO);
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

constructor TfraDashboardAsistente.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEtapas := TDibujoEtapas.Crear(pbEtapas);
  FAvisos := NuevosAvisos(pbAvisos);
  FDatos := TDibujoDatos.Crear(pbDatos);

  FPresentador := TPresentadorDashboard<TDashboardAsistenteDTO>.Create(Self,
    TApiDashboard.Create,
    function(AApi: IApiDashboard): TDashboardAsistenteDTO
    begin
      Result := AApi.Asistente;
    end);
  lblTitulo.Caption := FPresentador.Saludo;
  FPresentador.Iniciar;
end;

destructor TfraDashboardAsistente.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraDashboardAsistente.MostrarDashboard(const ADatos
  : TDashboardAsistenteDTO);
begin
  lblCifra1.Caption := ADatos.PorCotizar.ToString;
  lblCifra2.Caption := ADatos.Devueltas.ToString;
  lblCifra3.Caption := ADatos.PorEnviar.ToString;
  lblCifra4.Caption := ADatos.SinRespuesta.ToString;
  lblNota1.Caption := TFormato.MasAntigua(ADatos.DiasMasAntigua);
  lblNota2.Caption := SNotaCorregir;
  lblNota3.Caption := SNotaConVistoBueno;
  lblNota4.Caption := Format(SNotaFueraDePlazo, [ADatos.DiasPlazo]);
  FEtapas.Poner(RecuadrosDeEtapas(ADatos.PorEtapa));
  FAvisos.Poner(AvisosParaHoy(ADatos.ParaHoy));
  FDatos.Poner(FilasDeDatos(ADatos.MiMes));
end;

end.
