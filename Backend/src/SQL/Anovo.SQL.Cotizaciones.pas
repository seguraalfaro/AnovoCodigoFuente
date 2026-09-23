unit Anovo.SQL.Cotizaciones;

// Las consultas de cotizaciones y de su detalle.
//
// Son fragmentos de lo que va despues del WHERE, porque MVCActiveRecord arma
// el SELECT desde la entidad. Las consultas completas van marcadas.

interface

const
  // COTIZACIONES -------------------------------------------------------------

  // Un ?. El numero no entra aqui: es entero y se busca por
  // COTIZACIONES_POR_NUMERO.
  COTIZACIONES_FILTRO_BUSQUEDA = '(DESCRIPCION_TRABAJO CONTAINING ?)';

  COTIZACIONES_POR_ESTADO = ' AND ESTADO = ?';
  COTIZACIONES_DEL_CLIENTE = ' AND CLIENTE_ID = ?';

  // Se concatena cuando el usuario solo puede ver las suyas.
  COTIZACIONES_ELABORADAS_POR = ' AND ELABORADA_POR = ?';

  // Dos ?.
  COTIZACIONES_ENTRE_FECHAS = ' AND FECHA_ELABORACION BETWEEN ? AND ?';

  // Dos ?: desde y hasta. Por NUMERO y no por fecha: el consecutivo ya es el
  // orden de elaboracion y no empata nunca.
  COTIZACIONES_ORDEN_Y_PAGINA = ' ORDER BY NUMERO DESC ROWS ? TO ?';

  // Completa. Se le pega el filtro detras.
  COTIZACIONES_CONTAR = 'select count(*) from COTIZACIONES where ';

  COTIZACIONES_POR_NUMERO = 'NUMERO = ?';

  // Una solicitud puede acabar en varias cotizaciones si una se rechaza y se
  // rehace.
  COTIZACIONES_DE_SOLICITUD = 'SOLICITUD_ID = ? ORDER BY NUMERO DESC';

  // Completa. El consecutivo sale del generador y no de un max(NUMERO), que
  // entregaria el mismo valor dos veces a dos usuarios a la vez.
  COTIZACIONES_SIGUIENTE_NUMERO =
    'select next value for GEN_COTIZACION_NUMERO from RDB$DATABASE';

  // Un ?: la fecha limite, calculada en el servicio. El recordatorio de los
  // siete dias sin respuesta de la HU-07.
  COTIZACIONES_ENVIADAS_SIN_RESPUESTA =
    'ESTADO = ''enviada'' AND FECHA_ENVIO < ? ORDER BY FECHA_ENVIO';

  // COTIZACION_DETALLE -------------------------------------------------------

  COTIZACION_DETALLE_DE = 'COTIZACION_ID = ? ORDER BY ORDEN, ID';

  COTIZACION_LINEA_DE = 'ID = ? AND COTIZACION_ID = ?';

  // Completa. Un ?: la cotizacion. Empieza en 1 cuando no hay lineas.
  COTIZACION_SIGUIENTE_ORDEN =
    'select coalesce(max(ORDEN), 0) + 1 from COTIZACION_DETALLE ' +
    'where COTIZACION_ID = ?';

  // Completa. Dos ?: la cotizacion y el tipo. El coalesce evita distinguir
  // entre "no hay lineas de ese tipo" y "suman cero": para la cabecera es lo
  // mismo.
  COTIZACION_SUBTOTAL_DE_TIPO =
    'select coalesce(sum(SUBTOTAL), 0) from COTIZACION_DETALLE ' +
    'where COTIZACION_ID = ? and TIPO = ?';

implementation

end.
