unit Anovo.Repositories.Reportes;

// Repositorio de reportes: filas de V_COTIZACIONES_DIA y V_CLIENTES_RESPUESTA
// del periodo, de todos o de una persona; las sumas las hace el servicio.

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
  end;

implementation

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

end.
