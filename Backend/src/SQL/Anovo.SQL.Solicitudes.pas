unit Anovo.SQL.Solicitudes;

// Las consultas de solicitudes, sus medidas y sus adjuntos.
//
// Son fragmentos de lo que va despues del WHERE, porque MVCActiveRecord arma
// el SELECT desde la entidad. Las consultas completas van marcadas.

interface

const
  // SOLICITUDES --------------------------------------------------------------

  // Dos ? con el mismo texto.
  SOLICITUDES_FILTRO_BUSQUEDA =
    '(DESCRIPCION CONTAINING ? OR OBSERVACIONES CONTAINING ?)';

  // Se concatena cuando el usuario solo puede ver las suyas.
  SOLICITUDES_DEL_ASESOR = ' AND ASESOR_ID = ?';

  SOLICITUDES_POR_ESTADO = ' AND ESTADO = ?';

  // Dos ?. Por FECHA_CAPTURA y no por FECHA_RECEPCION: el usuario filtra por
  // el dia que estuvo donde el cliente, no por el dia que el telefono
  // encontro senal.
  SOLICITUDES_ENTRE_FECHAS = ' AND FECHA_CAPTURA BETWEEN ? AND ?';

  // Dos ?: desde y hasta.
  SOLICITUDES_ORDEN_Y_PAGINA = ' ORDER BY FECHA_CAPTURA DESC ROWS ? TO ?';

  // Completa. Se le pega el filtro detras.
  SOLICITUDES_CONTAR = 'select count(*) from SOLICITUDES where ';

  // Un ?: el uuid que genero el telefono antes de tener ID del servidor. Es
  // la pieza que hace idempotente reenviar una solicitud que no se sabe si
  // llego.
  SOLICITUDES_POR_UUID_LOCAL = 'UUID_LOCAL = ?';

  // Completa. Un ?: el uuid. Solo hace falta el id, no la fila entera.
  SOLICITUDES_ID_POR_UUID_LOCAL =
    'select ID from SOLICITUDES where UUID_LOCAL = ?';

  // Un ?: el estado que cuenta como lista para cotizar. El NOT EXISTS sin
  // alias sobre SOLICITUDES funciona porque la ORM no le pone uno.
  SOLICITUDES_PENDIENTES_DE_COTIZAR =
    'ESTADO = ? AND NOT EXISTS (' +
    ' select 1 from COTIZACIONES c where c.SOLICITUD_ID = SOLICITUDES.ID) ' +
    'ORDER BY FECHA_CAPTURA';

  // SOLICITUD_MEDIDAS --------------------------------------------------------

  // ORDEN es el que puso el asesor en el telefono; ID desempata.
  MEDIDAS_DE_SOLICITUD = 'SOLICITUD_ID = ? ORDER BY ORDEN, ID';

  MEDIDA_DE_SOLICITUD = 'ID = ? AND SOLICITUD_ID = ?';

  // Las medidas que cuelgan de un croquis, para pintar sus etiquetas encima.
  MEDIDAS_DE_CROQUIS = 'CROQUIS_ID = ? ORDER BY ORDEN, ID';

  MEDIDAS_POR_UUID_LOCAL = 'UUID_LOCAL = ?';

  // SOLICITUD_ADJUNTOS -------------------------------------------------------

  // Completa, y con las columnas nombradas a proposito: deja fuera CONTENIDO y
  // CONTENIDO_JSON, que son BLOB. Listar treinta fotos no debe mover treinta
  // fotos. El contenido se pide adjunto por adjunto con ADJUNTO_DE_SOLICITUD.
  ADJUNTOS_DE_SOLICITUD =
    'select ID, SOLICITUD_ID, UUID_LOCAL, TIPO, NOMBRE_ARCHIVO, MIME, ' +
    'TAMANO_BYTES, ACTIVO, FECHA_CREACION, OBJVERSION ' +
    'from SOLICITUD_ADJUNTOS where SOLICITUD_ID = ? AND ACTIVO = TRUE ' +
    'order by TIPO, FECHA_CREACION, ID';

  // Este si trae el BLOB.
  ADJUNTO_DE_SOLICITUD = 'ID = ? AND SOLICITUD_ID = ?';

  CROQUIS_DE_SOLICITUD =
    'SOLICITUD_ID = ? AND TIPO = ''croquis'' AND ACTIVO = TRUE ' +
    'ORDER BY FECHA_CREACION, ID';

  ADJUNTOS_POR_UUID_LOCAL = 'UUID_LOCAL = ?';

implementation

end.
