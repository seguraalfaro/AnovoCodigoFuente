unit Anovo.Repositories.Reportes;

// Repositorio de reportes: filas de V_COTIZACIONES_DIA y V_CLIENTES_RESPUESTA
// del periodo y las cotizaciones detras de cada fila; las sumas, el servicio.

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
    function DiasEntre(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer): TObjectList<TCotizacionesDia>;
    function EnviadasEntre(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer): TObjectList<TClientesRespuesta>;
    function Detalle(const AFiltro: TFiltroDetalleReporte;
      const ALimite: Integer): TObjectList<TCotizacionConNombres>;
  end;

implementation

uses
  System.SysUtils,
  Anovo.SQL.Cotizaciones;

function TReporteRepository.DiasEntre(const ADesde, AHasta: TDateTime;
  const AUsuarioId: Integer): TObjectList<TCotizacionesDia>;
begin
  if AUsuarioId = 0 then
    Result := ListarConsulta<TCotizacionesDia>(CONSULTA_ENTRE,
      [FechaParaRQL(ADesde), FechaParaRQL(AHasta)], SIN_LIMITE)
  else
    Result := ListarConsulta<TCotizacionesDia>(CONSULTA_ENTRE_PROPIAS,
      [FechaParaRQL(ADesde), FechaParaRQL(AHasta), AUsuarioId, AUsuarioId],
      SIN_LIMITE);
end;

function TReporteRepository.EnviadasEntre(const ADesde, AHasta: TDateTime;
  const AUsuarioId: Integer): TObjectList<TClientesRespuesta>;
begin
  if AUsuarioId = 0 then
    Result := ListarConsulta<TClientesRespuesta>(CONSULTA_ENTRE,
      [FechaParaRQL(ADesde), FechaParaRQL(AHasta)], SIN_LIMITE)
  else
    Result := ListarConsulta<TClientesRespuesta>(CONSULTA_ENTRE_PROPIAS,
      [FechaParaRQL(ADesde), FechaParaRQL(AHasta), AUsuarioId, AUsuarioId],
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
