unit Anovo.Frames.Dashboard.Asistente;

// Dashboard del asistente: la cola, su trabajo por etapa, lo que tiene para
// hoy y como va su mes.

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
    lblNota1: TLabel;
    lblNota2: TLabel;
    lblNota3: TLabel;
    lblNota4: TLabel;
    gpTarjetas: TGridPanel;
    tjBarras: TPlanoTarjeta;
    grBarras: TrDBGrid;
    tjAvisos: TPlanoTarjeta;
    grAvisos: TrDBGrid;
    tjDatos: TPlanoTarjeta;
    grDatos: TrDBGrid;
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
  Anovo.Formato,
  Anovo.Textos,
  Anovo.Api.Intf.Dashboard,
  Anovo.Api.Dashboard,
  Anovo.Datos.Memoria;

constructor TfraDashboardAsistente.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  PrepararRejilla(grBarras);
  PrepararAvisos(grAvisos);
  PrepararRejilla(grDatos);

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
  lblNota4.Caption := SNotaFueraDePlazo;
  MostrarBarras(grBarras, ADatos.PorEtapa);
  MostrarAvisos(grAvisos, ADatos.ParaHoy);
  MostrarDatos(grDatos, ADatos.MiMes);
end;

end.
