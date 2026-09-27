unit Anovo.Frames.Dashboard.Asesor;

// Dashboard del asesor: cifras del mes y solicitudes
// de la semana.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Tarjeta,
  Anovo.DTOs.Dashboard,
  Anovo.Vistas.Intf.DashboardAsesor,
  Anovo.Presentadores.DashboardAsesor;

type
  TfraDashboardAsesor = class(TFrame, IVistaDashboardAsesor)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    lblPeriodo: TLabel;
    pnlKpi: TPanel;
    tjSolicitudes: TPlanoTarjeta;
    lblSolicitudes: TLabel;
    tjEsperando: TPlanoTarjeta;
    lblEsperando: TLabel;
    tjAprobadas: TPlanoTarjeta;
    lblAprobadas: TLabel;
    tjMonto: TPlanoTarjeta;
    lblMonto: TLabel;
    tjRecientes: TPlanoTarjeta;
    grSolicitudes: TrDBGrid;
  private
    FPresentador: TPresentadorDashboardAsesor;
    procedure EstadoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarDashboard(const ADatos: TDashboardAsesorDTO);
    procedure MostrarError(const AMensaje: string);
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
  Anovo.Api.Dashboard,
  Anovo.Mapeo.Datos,
  Anovo.Formato,
  Anovo.Datos.Memoria;

const
  CAMPO_ESTADO = 'ESTADO';

constructor TfraDashboardAsesor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  AplicarTemaGrid(grSolicitudes);
  TDBGridExtend.De(grSolicitudes).ColumnaEstado(CAMPO_ESTADO);

  dmMemoria.mtDashboardAsesorESTADO.OnGetText := EstadoGetText;

  FPresentador := TPresentadorDashboardAsesor.Create(Self,
    TApiDashboard.Create);
  FPresentador.Iniciar;
end;

destructor TfraDashboardAsesor.Destroy;
begin
  dmMemoria.mtDashboardAsesorESTADO.OnGetText := nil;
  FPresentador.Free;
  inherited;
end;

procedure TfraDashboardAsesor.Resize;
begin
  inherited;
  Anovo.UI.DBGridExtend.AjustarColumnas(grSolicitudes);
end;

procedure TfraDashboardAsesor.EstadoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := TFormato.Estado(Sender.AsString);
end;

procedure TfraDashboardAsesor.MostrarCargando(const AActivo: Boolean);
begin
  if AActivo then
    Screen.Cursor := crAppStart
  else
    Screen.Cursor := crDefault;
end;

procedure TfraDashboardAsesor.MostrarDashboard(const ADatos
  : TDashboardAsesorDTO);
begin
  lblPeriodo.Caption := TFormato.MesAnio(ADatos.Desde);
  lblSolicitudes.Caption := ADatos.SolicitudesMes.ToString;
  lblEsperando.Caption := ADatos.EsperandoCotizacion.ToString;
  lblAprobadas.Caption := ADatos.AprobadasMes.ToString;
  lblMonto.Caption := TFormato.Colones(ADatos.MontoAprobadoMes);

  TMapeoDatos.AListaTabla<TSolicitudAsesorDTO>(ADatos.Recientes,
    dmMemoria.mtDashboardAsesor);
  Anovo.UI.DBGridExtend.AjustarColumnas(grSolicitudes);
end;

procedure TfraDashboardAsesor.MostrarError(const AMensaje: string);
begin
  MessageDlg(AMensaje, mtWarning, [mbOK], 0);
end;

end.
