unit Anovo.Repositories.Dashboard;

// Repositorio de dashboards: lee las vistas de totales con sus consultas
// con nombre; el mes en curso lo decide la base (V_PERIODO_ACTUAL).

interface

uses
  System.Generics.Collections,
  Anovo.Repositories.Base,
  Anovo.Repositories.Intf.Dashboard,
  Anovo.Entities.Solicitudes,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas;

type
  TDashboardRepository = class(TAnovoRepository<TSolicitudes>,
    IDashboardRepository)
  public
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

const
  FILAS_COLA = 50;
  FILAS_RECIENTES = 1000;

function TDashboardRepository.Periodo: TVPeriodoActual;
begin
  Result := LeerVistaUnica<TVPeriodoActual>;
end;

function TDashboardRepository.ResumenMes: TVResumenMes;
begin
  Result := LeerVistaUnica<TVResumenMes>;
end;

function TDashboardRepository.TrabajoDe(const AUsuarioId: Integer)
  : TTrabajoUsuario;
begin
  Result := PrimeraFilaDeConsulta<TTrabajoUsuario>(CONSULTA_DE_USUARIO, [AUsuarioId]);
end;

function TDashboardRepository.AsesorMes(const AAsesorId: Integer)
  : TAsesoresMes;
begin
  Result := PrimeraFilaDeConsulta<TAsesoresMes>(CONSULTA_DE_ASESOR, [AAsesorId]);
end;

function TDashboardRepository.Productividad: TObjectList<TAsesoresMes>;
begin
  Result := ListarConsulta<TAsesoresMes>(CONSULTA_PRODUCTIVIDAD, []);
end;

function TDashboardRepository.RecientesAsesor(const AAsesorId: Integer;
  const ADesde, AHasta: TDateTime): TObjectList<TSeguimientoAsesor>;
begin
  Result := ListarConsulta<TSeguimientoAsesor>(CONSULTA_DE_ASESOR_ENTRE,
    [AAsesorId, FechaParaRQL(ADesde), FechaParaRQL(AHasta), '', '', 0,
    FILAS_RECIENTES]);
end;

function TDashboardRepository.ColaPorCotizar: TObjectList<TColaSolicitudes>;
begin
  Result := ListarConsulta<TColaSolicitudes>(CONSULTA_BUSCAR,
    ['', '', 0, FILAS_COLA]);
end;

function TDashboardRepository.EstadoDelAsesor(const AAsesorId: Integer)
  : TObjectList<TEstadoDelAsesor>;
begin
  Result := ListarConsulta<TEstadoDelAsesor>(CONSULTA_DE_ASESOR, [AAsesorId],
    SIN_LIMITE);
end;

function TDashboardRepository.SolicitudesDelMes(const AAsesorId, AAnio,
  AMes: Integer): TSolicitudesDelMes;
begin
  Result := PrimeraFilaDeConsulta<TSolicitudesDelMes>(CONSULTA_DE_ASESOR_MES,
    [AAsesorId, AAnio, AMes]);
end;

function TDashboardRepository.EnviadasDeAsesor(const AAsesorId,
  ALimite: Integer): TObjectList<TEnviadaSinRespuesta>;
begin
  Result := ListarConsulta<TEnviadaSinRespuesta>(CONSULTA_DE_ASESOR,
    [AAsesorId], ALimite);
end;

function TDashboardRepository.EnviadasDeElaborador(const AUsuarioId: Integer)
  : TObjectList<TEnviadaSinRespuesta>;
begin
  Result := ListarConsulta<TEnviadaSinRespuesta>(CONSULTA_DE_ELABORADOR,
    [AUsuarioId], SIN_LIMITE);
end;

function TDashboardRepository.ParaHoy(const AUsuarioId, ALimite: Integer)
  : TObjectList<TCotizacionEnCurso>;
begin
  Result := ListarConsulta<TCotizacionEnCurso>(CONSULTA_PARA_HOY, [AUsuarioId],
    ALimite);
end;

function TDashboardRepository.Estancadas(const ADias, ALimite: Integer)
  : TObjectList<TCotizacionEnCurso>;
begin
  Result := ListarConsulta<TCotizacionEnCurso>(CONSULTA_ESTANCADAS, [ADias],
    ALimite);
end;

function TDashboardRepository.EtapasDe(const AUsuarioId: Integer)
  : TObjectList<TEtapaDeUsuario>;
begin
  Result := ListarConsulta<TEtapaDeUsuario>(CONSULTA_DE_ELABORADOR,
    [AUsuarioId], SIN_LIMITE);
end;

function TDashboardRepository.Carga: TObjectList<TCargaDePersona>;
begin
  Result := ListarConsulta<TCargaDePersona>(CONSULTA_ORDENADAS, [], SIN_LIMITE);
end;

function TDashboardRepository.PasosDe(const AUsuarioId, AAnio,
  AMes: Integer): TPasosDeUsuario;
begin
  Result := PrimeraFilaDeConsulta<TPasosDeUsuario>(CONSULTA_DE_ELABORADOR_MES,
    [AUsuarioId, AAnio, AMes]);
end;

function TDashboardRepository.PasosDelEquipo(const AAnio, AMes: Integer)
  : TPasosDelEquipo;
begin
  Result := PrimeraFilaDeConsulta<TPasosDelEquipo>(CONSULTA_DEL_MES,
    [AAnio, AMes]);
end;

function TDashboardRepository.ColaPorAprobar(const AUsuarioId: Integer)
  : TObjectList<TBandejaCotizaciones>;
begin
  Result := ListarConsulta<TBandejaCotizaciones>(CONSULTA_DE_OTROS,
    [AUsuarioId, '', '', 0, FILAS_COLA]);
end;

function TDashboardRepository.CotizacionesPorEstado
  : TObjectList<TCotizacionesPorEstado>;
begin
  Result := ListarConsulta<TCotizacionesPorEstado>(CONSULTA_ORDENADAS, []);
end;

function TDashboardRepository.CuentasResumen: TVCuentasResumen;
begin
  Result := LeerVistaUnica<TVCuentasResumen>;
end;

function TDashboardRepository.CambiosCuentas: TObjectList<TCambiosDeCuentas>;
begin
  Result := ListarConsulta<TCambiosDeCuentas>(CONSULTA_RECIENTES, []);
end;

end.
