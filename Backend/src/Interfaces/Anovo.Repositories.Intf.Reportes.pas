unit Anovo.Repositories.Intf.Reportes;

// Contrato del repositorio de reportes.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Cotizaciones,
  Anovo.Entities.Consultas;

type
  TFiltroDetalleReporte = record
    Desde: TDateTime;
    Hasta: TDateTime;
    PorEnvio: Boolean;
    Estado: string;
    AsesorId: Integer;
    ClienteId: Integer;
    FiltraTipo: Boolean;
    TipoTrabajoId: Integer;
    UsuarioPropio: Integer;
  end;

  IReporteRepository = interface(IMVCRepository<TCotizaciones>)
    ['{40D3D0A7-BC12-4A39-A1C1-FEE94847A082}']
    function DiasEntre(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer): TObjectList<TCotizacionesDia>;
    function EnviadasEntre(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer): TObjectList<TClientesRespuesta>;
    function Detalle(const AFiltro: TFiltroDetalleReporte;
      const ALimite: Integer): TObjectList<TCotizacionConNombres>;
  end;

implementation

end.
