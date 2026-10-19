unit Anovo.Frames.Reportes;

// Seccion Reportes (HU-06): cifras del periodo contra el anterior, detalle por
// estado, asesor, tipo, mes y cliente, PDF, Excel y cotizaciones de cada fila.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Tarjeta, VclPlano.BotonWin, VclPlano.Pestanas,
  Anovo.Frames.Dashboard,
  Anovo.DTOs.Cotizaciones,
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
    btnPdf: TPlanoBotonWin;
    tjCifra5: TPlanoTarjeta;
    lblCifra5: TLabel;
    tjCifra6: TPlanoTarjeta;
    lblCifra6: TLabel;
    lblDelta1: TLabel;
    lblDelta2: TLabel;
    lblDelta3: TLabel;
    lblDelta4: TLabel;
    lblDelta5: TLabel;
    lblDelta6: TLabel;
    lblLeyenda: TLabel;
    pstVistas: TPlanoPestanas;
    procedure pstVistasChange(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure btnPdfClick(Sender: TObject);
    procedure grListaDblClick(Sender: TObject);
  private
    FPresentador: TPresentadorReportes;
    FSelector: TSelectorPeriodo;
    FVistaActual: TVistaReporte;
    FResumen: TResumenReporte;
    FMaximoMes: Integer;
    FMostrando: Boolean;
    procedure MostrarVistas(const ARotulos: TArray<string>);
    procedure MostrarVista(const AVista: TVistaReporte);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure PeriodoCambio(const APeriodo: TPeriodoBusqueda);
    procedure MostrarReporte(const ADatos: TReporteCotizacionesDTO;
      const AResumen: TResumenReporte; const AMaximoMes: Integer);
    procedure MostrarDetalle(const ATitulo, AAyuda: string;
      const AFilas: TObjectList<TCotizacionDTO>);
    procedure PonerCifras;
    procedure PonerPie;
    procedure PonerBarras;
    function ClaveFila: string;
    function RotuloFila: string;
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
  Anovo.UI.Tema,
  Anovo.UI.CeldasRejilla,
  Anovo.Api.Reportes,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.DTOs.Dashboard,
  Anovo.Forms.DetalleReporte,
  Anovo.Reportes.Periodo,
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

  CAMPOS_FILA: TArray<string> = ['CANTIDAD', 'APROBADAS', 'RECHAZADAS',
    'DESCARTADAS', 'MONTO_TOTAL', 'MONTO_APROBADO'];

  CAMPOS_SUMA: array [TVistaReporte] of TArray<string> = (
    ['CANTIDAD', 'MONTO'],
    [], [], [],
    ['ENVIADAS', 'APROBADAS', 'RECHAZADAS', 'EN_ESPERA', 'SIN_RESPUESTA',
    'MONTO_SIN_RESPUESTA']);

constructor TfraReportes.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TCeldasRejilla.De(grLista).ColumnaEstado(CAMPO_ESTADO);
  grLista.FooterRow.FooterVisible := True;
  grLista.FooterRow.BoldText := True;
  lblLeyenda.Caption := SReporteLeyenda;
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

procedure TfraReportes.PonerCifras;
var
  lCifras: array [TCifraReporte] of TLabel;
  lDeltas: array [TCifraReporte] of TLabel;
  lCifra: TCifraReporte;
begin
  lCifras[crEnviadas] := lblCifra1;
  lCifras[crMontoEnviado] := lblCifra2;
  lCifras[crAprobadas] := lblCifra3;
  lCifras[crMontoAprobado] := lblCifra6;
  lCifras[crTasa] := lblCifra4;
  lCifras[crRespuesta] := lblCifra5;
  lDeltas[crEnviadas] := lblDelta1;
  lDeltas[crMontoEnviado] := lblDelta2;
  lDeltas[crAprobadas] := lblDelta3;
  lDeltas[crMontoAprobado] := lblDelta6;
  lDeltas[crTasa] := lblDelta4;
  lDeltas[crRespuesta] := lblDelta5;
  for lCifra := Low(TCifraReporte) to High(TCifraReporte) do
  begin
    lCifras[lCifra].Caption := FResumen.Valores[lCifra];
    lDeltas[lCifra].Caption := FResumen.Variaciones[lCifra];
  end;
  lblPeriodo.Caption := FResumen.Comparado;
end;

procedure TfraReportes.MostrarReporte(const ADatos: TReporteCotizacionesDTO;
  const AResumen: TResumenReporte; const AMaximoMes: Integer);
begin
  FResumen := AResumen;
  FMaximoMes := AMaximoMes;
  PonerCifras;

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
  lCampos: TArray<string>;
begin
  grLista.FooterRow.FieldFooterDefs.Clear;
  grLista.FooterRow_SetSettings(CAMPO_ROTULO[FVistaActual], STotalReporte);
  if FVistaActual in [vrAsesor, vrTipo, vrMes] then
    lCampos := CAMPOS_FILA
  else
    lCampos := CAMPOS_SUMA[FVistaActual];
  for lCampo in lCampos do
    grLista.FooterRow_SetSettings(lCampo, SUMA, tadRight);
  if FVistaActual in [vrAsesor, vrTipo, vrMes] then
    grLista.FooterRow_SetSettings(CAMPO_TASA, FResumen.TasaTotal, tadRight);
  if grLista.DataSource.DataSet.Active then
    grLista.RecalculateSummaryResults;
end;

procedure TfraReportes.PonerBarras;
begin
  grLista.FieldsAsDataBar.Clear;
  case FVistaActual of
    vrAsesor, vrTipo:
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

function TfraReportes.ClaveFila: string;
begin
  Result := '';
  if grLista.DataSource.DataSet.IsEmpty then
    Exit;
  case FVistaActual of
    vrEstado:
      Result := dmMemoria.mtReporteEstadosESTADO.AsString;
    vrAsesor:
      Result := dmMemoria.mtReporteAsesoresASESOR_ID.AsString;
    vrTipo:
      Result := IntToStr(dmMemoria.mtReporteTiposTIPO_TRABAJO_ID.AsInteger);
    vrMes:
      Result := IntToStr(dmMemoria.mtReporteMesesANIO.AsInteger * 100 +
        dmMemoria.mtReporteMesesMES.AsInteger);
    vrCliente:
      Result := dmMemoria.mtReporteClientesCLIENTE_ID.AsString;
  end;
end;

function TfraReportes.RotuloFila: string;
begin
  case FVistaActual of
    vrEstado:
      Result := dmMemoria.mtReporteEstadosESTADO.AsString;
    vrAsesor:
      Result := dmMemoria.mtReporteAsesoresASESOR_NOMBRE.AsString;
    vrTipo:
      Result := dmMemoria.mtReporteTiposTIPO_TRABAJO_NOMBRE.AsString;
    vrMes:
      Result := dmMemoria.mtReporteMesesMES_NOMBRE.AsString;
    vrCliente:
      Result := dmMemoria.mtReporteClientesCLIENTE_NOMBRE.AsString;
  end;
end;

procedure TfraReportes.MostrarDetalle(const ATitulo, AAyuda: string;
  const AFilas: TObjectList<TCotizacionDTO>);
var
  lId: Integer;
begin
  lId := TfrmDetalleReporte.Mostrar(Self, ATitulo, AAyuda, AFilas);
  if lId > 0 then
    AbrirCotizacion(lId);
end;

procedure TfraReportes.pstVistasChange(Sender: TObject);
begin
  if FMostrando or (FPresentador = nil) then
    Exit;
  FPresentador.ElegirVista(pstVistas.ItemIndex);
end;

procedure TfraReportes.grListaDblClick(Sender: TObject);
begin
  FPresentador.VerDetalle(ClaveFila, RotuloFila);
end;

procedure TfraReportes.btnExportarClick(Sender: TObject);
begin
  TColumnasRejilla.ExportarRejilla(grLista);
end;

procedure TfraReportes.btnPdfClick(Sender: TObject);
begin
  if not grLista.DataSource.DataSet.Active then
    Exit;
  TReportePeriodo.VistaPrevia(FResumen, pstVistas.Items[pstVistas.ItemIndex],
    grLista.DataSource.DataSet);
end;

end.
