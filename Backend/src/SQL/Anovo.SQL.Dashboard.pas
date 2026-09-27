unit Anovo.SQL.Dashboard;

// Consultas de los dashboards.
// Las sumas van con cast a numeric(18,2): Firebird 4 las da como INT128.

interface

uses
  Anovo.SQL.Solicitudes;

const

  DASHBOARD_ASESOR_CIFRAS =
    'select ' +
    ' (select cast(count(*) as integer) from SOLICITUDES s ' +
    '   where s.ASESOR_ID = ? ' +
    '     and s.FECHA_CAPTURA >= ? and s.FECHA_CAPTURA < ?) ' +
    '   as SOLICITUDES_MES, ' +
    ' (select cast(count(*) as integer) from SOLICITUDES s ' +
    '   where s.ASESOR_ID = ? ' +
    '     and s.ESTADO in (''recibida'', ''en_cotizacion'') ' +
    '     and not exists (select 1 from COTIZACIONES x ' +
    '                      where x.SOLICITUD_ID = s.ID ' +
    '                        and x.ESTADO in (''aprobada'', ''enviada''))) ' +
    '   as ESPERANDO_COTIZACION, ' +
    ' (select cast(count(*) as integer) from COTIZACIONES c ' +
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

  DASHBOARD_ASISTENTE_CIFRAS =
    'select ' +
    ' (select cast(count(*) as integer) from SOLICITUDES s ' +
    '   where s.ESTADO = ''recibida'' ' +
    '     and not exists (select 1 from COTIZACIONES x ' +
    '                      where x.SOLICITUD_ID = s.ID)) as POR_COTIZAR, ' +
    ' (select cast(count(*) as integer) from COTIZACIONES c ' +
    '   where c.ELABORADA_POR = ? and c.ESTADO = ''borrador'') ' +
    '   as MIS_BORRADORES, ' +
    ' (select cast(count(*) as integer) from COTIZACIONES c ' +
    '   where c.ELABORADA_POR = ? and c.ESTADO = ''pendiente'') ' +
    '   as EN_APROBACION, ' +
    ' (select cast(count(*) as integer) from COTIZACIONES c ' +
    '   where c.ELABORADA_POR = ? and c.ESTADO = ''aprobada'' ' +
    '     and c.FECHA_ENVIO is null) as POR_ENVIAR ' +
    'from RDB$DATABASE';

  DASHBOARD_ASISTENTE_COLA =
    'select s.ID, coalesce(s.FECHA_RECEPCION, s.FECHA_CAPTURA) ' +
    '  as FECHA_RECEPCION, c.NOMBRE as CLIENTE_NOMBRE, ' +
    '  a.NOMBRE as ASESOR_NOMBRE, s.DESCRIPCION, ' +
    '  cast(datediff(day from coalesce(s.FECHA_RECEPCION, s.FECHA_CAPTURA) ' +
    '    to current_timestamp) as integer) as DIAS_ESPERA ' +
    'from SOLICITUDES s ' +
    'join CLIENTES c on c.ID = s.CLIENTE_ID ' +
    'join USUARIOS a on a.ID = s.ASESOR_ID ' +
    'where s.ESTADO = ''recibida'' ' +
    '  and not exists (select 1 from COTIZACIONES x ' +
    '                   where x.SOLICITUD_ID = s.ID) ' +
    'order by 2, s.ID rows 1 to 50';

  DASHBOARD_SUPERVISOR_CIFRAS =
    'select ' +
    ' (select cast(count(*) as integer) from COTIZACIONES c ' +
    '   where c.ESTADO = ''pendiente'' and c.ELABORADA_POR <> ?) ' +
    '   as POR_APROBAR, ' +
    ' (select cast(coalesce(max(datediff(day from c.FECHA_MODIFICACION ' +
    '     to current_timestamp)), 0) as integer) ' +
    '   from COTIZACIONES c ' +
    '   where c.ESTADO = ''pendiente'' and c.ELABORADA_POR <> ?) ' +
    '   as DIAS_MAS_ANTIGUA, ' +
    ' (select cast(count(*) as integer) from COTIZACIONES c ' +
    '   where c.ESTADO in (''aprobada'', ''enviada'') ' +
    '     and c.FECHA_APROBACION >= ? and c.FECHA_APROBACION < ?) ' +
    '   as APROBADAS_MES, ' +
    ' (select cast(coalesce(sum(c.MONTO_TOTAL), 0) as numeric(18,2)) ' +
    '   from COTIZACIONES c ' +
    '   where c.ESTADO in (''aprobada'', ''enviada'') ' +
    '     and c.FECHA_APROBACION >= ? and c.FECHA_APROBACION < ?) ' +
    '   as MONTO_APROBADO_MES, ' +
    ' (select cast(count(*) as integer) from COTIZACIONES c ' +
    '   where c.ESTADO = ''rechazada'' ' +
    '     and c.FECHA_MODIFICACION >= ? and c.FECHA_MODIFICACION < ?) ' +
    '   as RECHAZADAS_MES ' +
    'from RDB$DATABASE';

  DASHBOARD_SUPERVISOR_COLA =
    'select c.ID, c.NUMERO, c.FECHA_MODIFICACION as FECHA_PRESENTADA, ' +
    '  cl.NOMBRE as CLIENTE_NOMBRE, e.NOMBRE as ELABORADA_POR_NOMBRE, ' +
    '  c.MONTO_TOTAL, ' +
    '  cast(datediff(day from c.FECHA_MODIFICACION to current_timestamp) ' +
    '    as integer) as DIAS_ESPERA ' +
    'from COTIZACIONES c ' +
    'join CLIENTES cl on cl.ID = c.CLIENTE_ID ' +
    'join USUARIOS e on e.ID = c.ELABORADA_POR ' +
    'where c.ESTADO = ''pendiente'' and c.ELABORADA_POR <> ? ' +
    'order by c.FECHA_MODIFICACION, c.ID rows 1 to 50';

implementation

end.
