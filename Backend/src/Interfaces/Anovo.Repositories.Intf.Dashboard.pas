unit Anovo.Repositories.Intf.Dashboard;

// Contrato del repositorio de dashboards.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Solicitudes,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas;

type
  IDashboardRepository = interface(IMVCRepository<TSolicitudes>)
    ['{13AD56E7-B2B7-49C8-A1FB-3DFFA6145C3A}']
    function Periodo: TVPeriodoActual;
    function ResumenMes: TVResumenMes;
    function TrabajoDe(const AUsuarioId: Integer): TTrabajoUsuario;
    function AsesorMes(const AAsesorId: Integer): TAsesoresMes;
    function Productividad: TObjectList<TAsesoresMes>;
    function RecientesAsesor(const AAsesorId: Integer;
      const ADesde, AHasta: TDateTime): TObjectList<TSeguimientoAsesor>;
    function ColaPorCotizar: TObjectList<TColaSolicitudes>;
    function ColaPorAprobar(const AUsuarioId: Integer)
      : TObjectList<TBandejaCotizaciones>;
    function CotizacionesPorEstado: TObjectList<TCotizacionesPorEstado>;
    function CuentasResumen: TVCuentasResumen;
    function CambiosCuentas: TObjectList<TCambiosDeCuentas>;
    function EstadoDelAsesor(const AAsesorId: Integer)
      : TObjectList<TEstadoDelAsesor>;
    function SolicitudesDelMes(const AAsesorId, AAnio, AMes: Integer)
      : TSolicitudesDelMes;
    function EnviadasDeAsesor(const AAsesorId, ALimite: Integer)
      : TObjectList<TEnviadaSinRespuesta>;
    function EnviadasDeElaborador(const AUsuarioId: Integer)
      : TObjectList<TEnviadaSinRespuesta>;
    function ParaHoy(const AUsuarioId, ALimite: Integer)
      : TObjectList<TCotizacionEnCurso>;
    function Estancadas(const ADias, ALimite: Integer)
      : TObjectList<TCotizacionEnCurso>;
    function EtapasDe(const AUsuarioId: Integer): TObjectList<TEtapaDeUsuario>;
    function Carga: TObjectList<TCargaDePersona>;
    function PasosDe(const AUsuarioId, AAnio, AMes: Integer): TPasosDeUsuario;
    function PasosDelEquipo(const AAnio, AMes: Integer): TPasosDelEquipo;
  end;

implementation

end.
