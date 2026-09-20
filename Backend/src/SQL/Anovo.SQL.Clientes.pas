unit Anovo.SQL.Clientes;

// Las consultas de clientes, en un solo sitio.
//
// Sacadas del repositorio para que un cambio de columna o de orden se haga una
// vez y no haya que repasar el archivo buscando comillas. El repositorio queda
// contando que hace cada metodo; aqui esta como lo hace.
//
// Son fragmentos, no consultas enteras: MVCActiveRecord arma el SELECT a partir
// de los atributos de la entidad y lo que recibe es lo que va despues del
// WHERE. Por eso empiezan sin SELECT y sin FROM, salvo CLIENTES_CONTAR, que si
// es una consulta completa porque no pasa por la ORM.
//
// El orden de los ? importa: es el orden de los parametros en la llamada.

interface

const
  // Las cuatro columnas por las que una persona busca a un cliente cuando lo
  // tiene delante: como se llama, su cedula, el telefono que le acaba de dar,
  // o el correo al que le mando algo la vez pasada.
  //
  // CONTAINING y no LIKE: en Firebird ignora mayusculas y minusculas por si
  // solo. La alternativa, UPPER(NOMBRE) LIKE ?, envuelve la columna en una
  // funcion y con eso deja fuera cualquier indice sobre ella.
  //
  // Cuatro ? con el mismo texto.
  CLIENTES_FILTRO_BUSQUEDA =
    '(NOMBRE CONTAINING ? OR IDENTIFICACION CONTAINING ? ' +
    ' OR TELEFONO CONTAINING ? OR CORREO CONTAINING ?)';

  // Se concatena al filtro cuando no se piden los inactivos.
  CLIENTES_SOLO_ACTIVOS = ' AND ACTIVO = TRUE';

  // Se concatena al filtro cuando se pide un estado de consentimiento. Un ?
  // mas, despues de los cuatro del texto: el estado.
  CLIENTES_POR_CONSENTIMIENTO = ' AND CONSENTIMIENTO_ESTADO = ?';

  // Se concatena al final de la busqueda. Dos ? mas: desde y hasta. ROWS de
  // Firebird cuenta desde 1 e incluye los dos extremos.
  CLIENTES_ORDEN_Y_PAGINA = ' ORDER BY NOMBRE ROWS ? TO ?';

  // Consulta completa: el total de la busqueda no pasa por la ORM porque
  // Count<T> del framework solo acepta RQL, y RQL se arma concatenando el texto
  // que escribio la persona. Se le pega el filtro detras.
  CLIENTES_CONTAR = 'select count(*) from CLIENTES where ';

  // Un ?: el uuid que genero el telefono antes de tener ID del servidor.
  CLIENTES_POR_UUID_LOCAL = 'UUID_LOCAL = ?';

  // Un ?: el id del cliente. El contacto principal primero, que es al que se
  // llama por defecto.
  CONTACTOS_DE_CLIENTE =
    'CLIENTE_ID = ? AND ACTIVO = TRUE ORDER BY PRINCIPAL DESC, NOMBRE';
  // Un ?: el id del cliente. Consulta completa y no solo el WHERE: se nombran
  // las columnas para dejar fuera FIRMA_IMAGEN, que es un BLOB y el listado
  // no la muestra. El mas reciente primero; ID desempata dos registros del
  // mismo instante, como un otorgado y su revocacion seguidos.
  CONSENTIMIENTOS_DE_CLIENTE =
    'select ID, CLIENTE_ID, CLIENTE_CONTACTO_ID, ACCION, VERSION_TEXTO, ' +
    'FECHA, FIRMANTE_NOMBRE, FIRMANTE_IDENTIFICACION, FIRMA_MIME, ORIGEN ' +
    'from CLIENTE_CONSENTIMIENTO_HISTORIAL where CLIENTE_ID = ? ' +
    'order by FECHA desc, ID desc';
  // Un ?: el uuid que genero el telefono antes de tener ID del servidor.
  // Consulta completa: solo hace falta el id, no cargar el cliente entero.
  CLIENTES_ID_POR_UUID_LOCAL = 'select ID from CLIENTES where UUID_LOCAL = ?';

  CONTACTO_DE_CLIENTE = 'ID = ? AND CLIENTE_ID = ? AND ACTIVO = TRUE';

implementation

end.
