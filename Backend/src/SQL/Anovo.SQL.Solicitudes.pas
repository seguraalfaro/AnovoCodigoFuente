unit Anovo.SQL.Solicitudes;

// Consultas de solicitudes, medidas y adjuntos.

interface

const

  SOLICITUDES_FILTRO_BUSQUEDA =
    '(DESCRIPCION CONTAINING ? OR OBSERVACIONES CONTAINING ?)';

  SOLICITUDES_DEL_ASESOR = ' AND ASESOR_ID = ?';

  SOLICITUDES_POR_ESTADO = ' AND ESTADO = ?';

  SOLICITUDES_ENTRE_FECHAS = ' AND FECHA_CAPTURA BETWEEN ? AND ?';

  SOLICITUDES_ORDEN_Y_PAGINA = ' ORDER BY FECHA_CAPTURA DESC ROWS ? TO ?';

  SOLICITUDES_CONTAR = 'select count(*) from SOLICITUDES where ';

  SOLICITUDES_POR_UUID_LOCAL = 'UUID_LOCAL = ?';

  SOLICITUDES_ID_POR_UUID_LOCAL =
    'select ID from SOLICITUDES where UUID_LOCAL = ?';

  SOLICITUDES_PENDIENTES_DE_COTIZAR =
    'ESTADO = ? AND NOT EXISTS (' +
    ' select 1 from COTIZACIONES c where c.SOLICITUD_ID = SOLICITUDES.ID) ' +
    'ORDER BY FECHA_CAPTURA';

  SEGUIMIENTO_ASESOR =
    'select s.ID, s.FECHA_CAPTURA, c.NOMBRE as CLIENTE_NOMBRE, ' +
    '  s.DESCRIPCION, ' +
    '  coalesce(a.ESTADO, s.ESTADO) as ESTADO, ' +
    '  a.ID as COTIZACION_ID, a.MONTO_TOTAL as MONTO_APROBADO ' +
    'from SOLICITUDES s ' +
    'join CLIENTES c on c.ID = s.CLIENTE_ID ' +
    'left join COTIZACIONES a on a.ID = ' +
    '  (select max(x.ID) from COTIZACIONES x ' +
    '    where x.SOLICITUD_ID = s.ID ' +
    '      and x.ESTADO in (''aprobada'', ''enviada'')) ' +
    'where s.ASESOR_ID = ? ';

  SEGUIMIENTO_CONTAR =
    'select count(*) from SOLICITUDES s ' +
    'join CLIENTES c on c.ID = s.CLIENTE_ID ' +
    'where s.ASESOR_ID = ? ';

  SEGUIMIENTO_FILTRO_TEXTO =
    ' and (c.NOMBRE containing ? or s.DESCRIPCION containing ?)';
  SEGUIMIENTO_ENTRE_FECHAS =
    ' and s.FECHA_CAPTURA >= ? and s.FECHA_CAPTURA < ?';
  SEGUIMIENTO_ORDEN = ' order by s.FECHA_CAPTURA desc, s.ID desc';
  SEGUIMIENTO_PAGINA = ' rows ? to ?';

  MEDIDAS_DE_SOLICITUD = 'SOLICITUD_ID = ? ORDER BY ORDEN, ID';

  MEDIDA_DE_SOLICITUD = 'ID = ? AND SOLICITUD_ID = ?';

  MEDIDAS_DE_CROQUIS = 'CROQUIS_ID = ? ORDER BY ORDEN, ID';

  MEDIDAS_POR_UUID_LOCAL = 'UUID_LOCAL = ?';

  ADJUNTOS_DE_SOLICITUD =
    'select ID, SOLICITUD_ID, UUID_LOCAL, TIPO, NOMBRE_ARCHIVO, MIME, ' +
    'TAMANO_BYTES, ACTIVO, FECHA_CREACION, OBJVERSION ' +
    'from SOLICITUD_ADJUNTOS where SOLICITUD_ID = ? AND ACTIVO = TRUE ' +
    'order by TIPO, FECHA_CREACION, ID';

  ADJUNTO_DE_SOLICITUD = 'ID = ? AND SOLICITUD_ID = ?';

  CROQUIS_DE_SOLICITUD =
    'SOLICITUD_ID = ? AND TIPO = ''croquis'' AND ACTIVO = TRUE ' +
    'ORDER BY FECHA_CREACION, ID';

  ADJUNTOS_POR_UUID_LOCAL = 'UUID_LOCAL = ?';

implementation

end.
