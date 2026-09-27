unit Anovo.SQL.Dashboard;

// Consultas de los dashboards.
// Las sumas van con cast a numeric(18,2): Firebird 4 las da como INT128.

interface

uses
  Anovo.SQL.Solicitudes;

const

  DASHBOARD_ASESOR_CIFRAS =
    'select ' +
    ' (select count(*) from SOLICITUDES s ' +
    '   where s.ASESOR_ID = ? ' +
    '     and s.FECHA_CAPTURA >= ? and s.FECHA_CAPTURA < ?) ' +
    '   as SOLICITUDES_MES, ' +
    ' (select count(*) from SOLICITUDES s ' +
    '   where s.ASESOR_ID = ? ' +
    '     and s.ESTADO in (''recibida'', ''en_cotizacion'') ' +
    '     and not exists (select 1 from COTIZACIONES x ' +
    '                      where x.SOLICITUD_ID = s.ID ' +
    '                        and x.ESTADO in (''aprobada'', ''enviada''))) ' +
    '   as ESPERANDO_COTIZACION, ' +
    ' (select count(*) from COTIZACIONES c ' +
    '   join SOLICITUDES s on s.ID = c.SOLICITUD_ID ' +
    '   where s.ASESOR_ID = ? and c.ESTADO in (''aprobada'', ''enviada'') ' +
    '     and c.FECHA_APROBACION >= ? and c.FECHA_APROBACION < ?) ' +
    '   as APROBADAS_MES, ' +
    ' (select cast(coalesce(sum(c.MONTO_TOTAL), 0) as numeric(18,2)) ' +
    '   from COTIZACIONES c ' +
    '   join SOLICITUDES s on s.ID = c.SOLICITUD_ID ' +
    '   where s.ASESOR_ID = ? and c.ESTADO in (''aprobada'', ''enviada'') ' +
    '     and c.FECHA_APROBACION >= ? and c.FECHA_APROBACION < ?) ' +
    '   as MONTO_APROBADO_MES ' +
    'from RDB$DATABASE';

  DASHBOARD_ASESOR_RECIENTES = SEGUIMIENTO_ASESOR + SEGUIMIENTO_ENTRE_FECHAS +
    SEGUIMIENTO_ORDEN;

implementation

end.
