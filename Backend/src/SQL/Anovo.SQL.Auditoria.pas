unit Anovo.SQL.Auditoria;

// Las consultas de la bitacora, en un solo sitio.
//
// Fragmentos, no consultas enteras: MVCActiveRecord arma el SELECT desde los
// atributos de la entidad y lo que recibe es lo que va despues del WHERE. La
// excepcion es AUDITORIA_CONTAR, que si es completa porque no pasa por la ORM.
//
// El orden de los ? importa: es el orden de los parametros en la llamada.

interface

const
  // La ventana de tiempo es el filtro base y siempre va. Dos ?: desde y hasta,
  // los dos incluidos.
  AUDITORIA_FILTRO_FECHA = 'FECHA BETWEEN ? AND ?';

  // Los que se concatenan si vienen, en este orden. Un ? cada uno.
  AUDITORIA_POR_USUARIO = ' AND USUARIO_ID = ?';
  AUDITORIA_POR_ENTIDAD = ' AND ENTIDAD = ?';
  AUDITORIA_POR_ACCION  = ' AND ACCION = ?';

  // CONTAINING y no LIKE: en Firebird ignora mayusculas y minusculas por si
  // solo, sin envolver la columna en UPPER().
  AUDITORIA_POR_TEXTO = ' AND DETALLE CONTAINING ?';

  // Al final de la busqueda. Dos ? mas: desde y hasta de la pagina. La mas
  // reciente primero; ID desempata dos filas del mismo instante, que en una
  // escritura que toca varias tablas es lo normal.
  AUDITORIA_ORDEN_Y_PAGINA = ' ORDER BY FECHA DESC, ID DESC ROWS ? TO ?';

  // Consulta completa: Count<T> del framework solo acepta RQL, y aqui el
  // filtro se arma concatenando. Se le pega el filtro detras.
  AUDITORIA_CONTAR = 'select count(*) from AUDITORIA where ';

  // Dos ?: la entidad y su numero. Sin ventana de tiempo: la bitacora de una
  // fila es corta por definicion.
  AUDITORIA_DE_ENTIDAD =
    'ENTIDAD = ? AND ENTIDAD_ID = ? ORDER BY FECHA DESC, ID DESC';

implementation

end.
