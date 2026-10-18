unit Anovo.Frames.Reportes;

// Seccion Reportes (HU-06): cifras del periodo y detalle por estado, asesor,
// tipo de trabajo, mes y clientes sin respuesta, con exportacion.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Tarjeta, VclPlano.BotonWin, VclPlano.Pestanas,
  Anovo.Frames.Dashboard,
  Anovo.DTOs.Reportes,
  Anovo.PeriodoBusqueda,
  Anovo.Forms.Periodo,
  Anovo.Vistas.Intf.Reportes,
  Anovo.Presentadores.Reportes;

type
  TfraReportes = class(TfraDashboard, IVistaReportes)
    pnlFiltros: TPanel;
    btnPeriodo: TPlanoBotonWin;
    btnExportar: TPlanoBotonWin;
    tjCifra5: TPlanoTarjeta;
    lblCifra5: TLabel;
    pstVistas: TPlanoPestanas;
    procedure pstVistasChange(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
  private
    FPresentador: TPresentadorReportes;
    FSelector: TSelectorPeriodo;
    FVistaActual: TVistaReporte;
    FTasaTotal: Integer;
    FMaximoMes: Integer;
    FMostrando: Boolean;
    procedure MostrarVistas(const ARotulos: TArray<string>);
    procedure MostrarVista(const AVista: TVistaReporte);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure PeriodoCambio(const APeriodo: TPeriodoBusqueda);
    procedure MostrarReporte(const ADatos: TReporteCotizacionesDTO;
      const AMaximoMes: Integer);
    procedure PonerPie;
    procedure PonerBarras;
  protected
    procedure MostrarCargando(const AActivo: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Anovo.UI.ColumnasRejilla,
  RosiCompGlobalCfg,
  Anovo.UI.Vista,
  Anovo.UI.CeldasRejilla,
  Anovo.Api.Reportes,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.DTOs.Dashboard,
  Anovo.Formato,
  Anovo.Textos;

const
  CAMPO_ESTADO = 'ESTADO';
  CAMPO_CANTIDAD = 'CANTIDAD';
  CAMPO_TASA = 'TASA_APROBACION';
  CAMPO_SIN_RESPUESTA = 'PORCENTAJE_SIN_RESPUESTA';
  SUMA = '%SUM';
  TASA_MAXIMA = 100;

  CAMPO_ROTULO: array [TVistaReporte] of string = ('ESTADO', 'ASESOR_NOMBRE',
    'TIPO_TRABAJO_NOMBRE', 'MES_NOMBRE', 'CLIENTE_NOMBRE');

  CAMPOS_SUMA: array [TVistaReporte] of TArray<string> = (
    ['CANTIDAD', 'MONTO'],
    ['CANTIDAD', 'APROBADAS', 'RECHAZADAS', 'MONTO_APROBADO', 'MONTO_TOTAL'],
    ['CANTIDAD', 'APROBADAS', 'MONTO_TOTAL'],
    ['CANTIDAD', 'APROBADAS', 'RECHAZADAS', 'MONTO_TOTAL'],
    ['ENVIADAS', 'APROBADAS', 'RECHAZADAS', 'EN_ESPERA', 'SIN_RESPUESTA',
    'MONTO_SIN_RESPUESTA']);

constructor TfraReportes.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TCeldasRejilla.De(grLista).ColumnaEstado(CAMPO_ESTADO);
  grLista.FooterRow.FooterVisible := True;
  grLista.FooterRow.BoldText := True;
  FSelector := TSelectorPeriodo.Crear(btnPeriodo, True, PeriodoCambio);
  FPresentador := TPresentadorReportes.Create(Self, TApiReportes.Create);
  FPresentador.Iniciar;
end;

destructor TfraReportes.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraReportes.MostrarCargando(const AActivo: Boolean);
begin
  inherited;
  BloquearEdicion([pnlFiltros, pstVistas], AActivo);
end;

procedure TfraReportes.MostrarVistas(const ARotulos: TArray<string>);
var
  lRotulo: string;
begin
  FMostrando := True;
  try
    pstVistas.Items.Clear;
    for lRotulo in ARotulos do
      pstVistas.Items.Add(lRotulo);
    pstVistas.ItemIndex := 0;
  finally
    FMostrando := False;
  end;
end;

procedure TfraReportes.MostrarVista(const AVista: TVistaReporte);
begin
  FVistaActual := AVista;
  case AVista of
    vrEstado:
      grLista.DataSource := dmMemoria.dsReporteEstados;
    vrAsesor:
      grLista.DataSource := dmMemoria.dsReporteAsesores;
    vrTipo:
      grLista.DataSource := dmMemoria.dsReporteTipos;
    vrMes:
      grLista.DataSource := dmMemoria.dsReporteMeses;
    vrCliente:
      grLista.DataSource := dmMemoria.dsReporteClientes;
  end;
  PonerPie;
  PonerBarras;
  Anovo.UI.CeldasRejilla.AjustarColumnas(grLista);
end;

procedure TfraReportes.MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
begin
  FSelector.Mostrar(APeriodo);
end;

procedure TfraReportes.PeriodoCambio(const APeriodo: TPeriodoBusqueda);
begin
  FPresentador.FiltrarPeriodo(APeriodo);
end;

procedure TfraReportes.MostrarReporte(const ADatos: TReporteCotizacionesDTO;
  const AMaximoMes: Integer);
begin
  lblCifra1.Caption := ADatos.Total.ToString;
  lblCifra2.Caption := TFormato.Colones(ADatos.MontoTotal);
  lblCifra3.Caption := ADatos.Aprobadas.ToString;
  lblCifra4.Caption := TFormato.Tasa(ADatos.TasaAprobacion);
  lblCifra5.Caption := TFormato.Dias(ADatos.RespuestaMedia);
  FTasaTotal := ADatos.TasaAprobacion;
  FMaximoMes := AMaximoMes;

  TMapeoDatos.AListaTabla<TCotizacionesPorEstadoDTO>(ADatos.PorEstado,
    dmMemoria.mtReporteEstados);
  TMapeoDatos.AListaTabla<TReporteAsesorDTO>(ADatos.PorAsesor,
    dmMemoria.mtReporteAsesores);
  TMapeoDatos.AListaTabla<TReporteTipoDTO>(ADatos.PorTipo,
    dmMemoria.mtReporteTipos);
  TMapeoDatos.AListaTabla<TReporteMesDTO>(ADatos.PorMes,
    dmMemoria.mtReporteMeses);
  TMapeoDatos.AListaTabla<TReporteClienteDTO>(ADatos.PorCliente,
    dmMemoria.mtReporteClientes);
  MostrarVista(FVistaActual);
end;

procedure TfraReportes.PonerPie;
var
  lCampo: string;
begin
  grLista.FooterRow.FieldFooterDefs.Clear;
  grLista.FooterRow_SetSettings(CAMPO_ROTULO[FVistaActual], STotalReporte);
  for lCampo in CAMPOS_SUMA[FVistaActual] do
    grLista.FooterRow_SetSettings(lCampo, SUMA, tadRight);
  if FVistaActual in [vrAsesor, vrMes] then
    grLista.FooterRow_SetSettings(CAMPO_TASA,
      TFormato.Tasa(FTasaTotal), tadRight);
  if grLista.DataSource.DataSet.Active then
    grLista.RecalculateSummaryResults;
end;

procedure TfraReportes.PonerBarras;
begin
  grLista.FieldsAsDataBar.Clear;
  case FVistaActual of
    vrAsesor:
      grLista.Fields_SetDataBarSettings(CAMPO_TASA, 0, TASA_MAXIMA, dbtValue);
    vrMes:
      if FMaximoMes > 0 then
        grLista.Fields_SetDataBarSettings(CAMPO_CANTIDAD, 0, FMaximoMes,
          dbtValue);
    vrCliente:
      grLista.Fields_SetDataBarSettings(CAMPO_SIN_RESPUESTA, 0, TASA_MAXIMA,
        dbtValue);
  end;
end;

procedure TfraReportes.pstVistasChange(Sender: TObject);
begin
  if FMostrando or (FPresentador = nil) then
    Exit;
  FPresentador.ElegirVista(pstVistas.ItemIndex);
end;

procedure TfraReportes.btnExportarClick(Sender: TObject);
begin
  TColumnasRejilla.ExportarRejilla(grLista);
end;

end.
