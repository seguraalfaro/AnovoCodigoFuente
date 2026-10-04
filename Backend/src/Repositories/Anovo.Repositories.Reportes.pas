unit Anovo.Repositories.Reportes;

// Repositorio de reportes: las filas por dia de V_COTIZACIONES_DIA del
// periodo, de todos o de una persona; las sumas las hace el servicio.

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

end.
