unit Anovo.Repositories.Reportes;

// Repositorio de reportes: fija el periodo en la sesion y lee las vistas
// V_REPORTE_*, que traen todo calculado; y las cotizaciones de cada fila.

interface

uses
  System.Generics.Collections,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Reportes,
  Anovo.Entities.Cotizaciones,
  Anovo.Entities.Consultas;

type
  TReporteRepository = class(TAnovoRepository<TCotizaciones>,
    IReporteRepository)
  public
    procedure FijarPeriodo(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer);
    function Resumen: TObjectList<TResumenDelReporte>;
    function PorEstado: TObjectList<TReportePorEstado>;
    function PorAsesor: TObjectList<TReportePorAsesor>;
    function PorTipo: TObjectList<TReportePorTipo>;
    function PorMes: TObjectList<TReportePorMes>;
    function PorCliente: TObjectList<TReportePorCliente>;
    function Detalle(const AFiltro: TFiltroDetalleReporte;
      const ALimite: Integer): TObjectList<TCotizacionConNombres>;
  end;

implementation

uses
  System.SysUtils,
  Anovo.SQL.Cotizaciones;

procedure TReporteRepository.FijarPeriodo(const ADesde, AHasta: TDateTime;
  const AUsuarioId: Integer);
begin
  FijarContexto(REPORTE_CONTEXTO_DESDE, FechaParaRQL(ADesde));
  FijarContexto(REPORTE_CONTEXTO_HASTA, FechaParaRQL(AHasta));
  FijarContexto(REPORTE_CONTEXTO_USUARIO, AUsuarioId.ToString);
end;

function TReporteRepository.Resumen: TObjectList<TResumenDelReporte>;
begin
  Result := ListarConsulta<TResumenDelReporte>(CONSULTA_ORDENADAS, [],
    SIN_LIMITE);
end;

function TReporteRepository.PorEstado: TObjectList<TReportePorEstado>;
begin
  Result := ListarConsulta<TReportePorEstado>(CONSULTA_ORDENADAS, [],
    SIN_LIMITE);
end;

function TReporteRepository.PorAsesor: TObjectList<TReportePorAsesor>;
begin
  Result := ListarConsulta<TReportePorAsesor>(CONSULTA_ORDENADAS, [],
    SIN_LIMITE);
end;

function TReporteRepository.PorTipo: TObjectList<TReportePorTipo>;
begin
  Result := ListarConsulta<TReportePorTipo>(CONSULTA_ORDENADAS, [],
    SIN_LIMITE);
end;

function TReporteRepository.PorMes: TObjectList<TReportePorMes>;
begin
  Result := ListarConsulta<TReportePorMes>(CONSULTA_ORDENADAS, [], SIN_LIMITE);
end;

function TReporteRepository.PorCliente: TObjectList<TReportePorCliente>;
begin
  Result := ListarConsulta<TReportePorCliente>(CONSULTA_ORDENADAS, [],
    SIN_LIMITE);
end;

function TReporteRepository.Detalle(const AFiltro: TFiltroDetalleReporte;
  const ALimite: Integer): TObjectList<TCotizacionConNombres>;
var
  lSql, lIds: string;
  lParametros: TArray<Variant>;
  lFilas: TObjectList<TCotizaciones>;
  lFila: TCotizaciones;
begin
  lParametros := [Variant(AFiltro.Desde), Variant(AFiltro.Hasta)];
  if AFiltro.PorEnvio then
    lSql := REPORTE_ENVIADAS_EN
  else if AFiltro.Estado <> '' then
  begin
    lSql := REPORTE_CON_PASO + REPORTE_PASO_EN_ESTADO;
    lParametros := lParametros + [Variant(AFiltro.Estado)];
  end
  else
    lSql := REPORTE_CON_PASO + REPORTE_PASO_DEL_CLIENTE;
  if AFiltro.AsesorId > 0 then
  begin
    lSql := lSql + COTIZACIONES_DEL_ASESOR;
    lParametros := lParametros + [Variant(AFiltro.AsesorId)];
  end;
  if AFiltro.ClienteId > 0 then
  begin
    lSql := lSql + COTIZACIONES_DEL_CLIENTE;
    lParametros := lParametros + [Variant(AFiltro.ClienteId)];
  end;
  if AFiltro.FiltraTipo and (AFiltro.TipoTrabajoId > 0) then
  begin
    lSql := lSql + REPORTE_DEL_TIPO;
    lParametros := lParametros + [Variant(AFiltro.TipoTrabajoId)];
  end
  else if AFiltro.FiltraTipo then
    lSql := lSql + REPORTE_SIN_TIPO;
  if AFiltro.UsuarioPropio > 0 then
  begin
    lSql := lSql + REPORTE_PROPIAS;
    lParametros := lParametros + [Variant(AFiltro.UsuarioPropio),
      Variant(AFiltro.UsuarioPropio)];
  end;

  lFilas := GetWhere(lSql + REPORTE_ORDEN, lParametros + [Variant(ALimite)]);
  try
    lIds := '';
    for lFila in lFilas do
    begin
      if lIds <> '' then
        lIds := lIds + ',';
      lIds := lIds + lFila.ID.Value.ToString;
    end;
  finally
    lFilas.Free;
  end;
  if lIds = '' then
    Exit(TObjectList<TCotizacionConNombres>.Create(True));
  Result := ListarConsulta<TCotizacionConNombres>(CONSULTA_DE_IDS, [lIds],
    SIN_LIMITE);
end;

end.
