unit Anovo.SQL.Catalogos;

// Las consultas de los catalogos: materiales, mano de obra, maquinas y tipos
// de trabajo, mas las tres tablas de precios.
//
// Son fragmentos de lo que va despues del WHERE, porque MVCActiveRecord arma
// el SELECT desde la entidad. Las consultas completas van marcadas.
//
// Las columnas van calificadas con el nombre de la tabla para que el mismo
// fragmento sirva en la consulta de la ORM y en la del join, donde ACTIVO
// existe en las dos tablas y sin calificar es ambiguo. Se puede porque la ORM
// genera SELECT ... FROM TABLA sin alias; por eso la tabla principal tampoco
// lleva alias abajo.

interface

const
  // MATERIALES ---------------------------------------------------------------

  // Tres ? con el mismo texto. CONTAINING ignora mayusculas sin envolver la
  // columna en UPPER(), que dejaria fuera el indice.
  MATERIALES_FILTRO_BUSQUEDA =
    '(MATERIALES.CODIGO CONTAINING ? OR MATERIALES.NOMBRE CONTAINING ? ' +
    ' OR MATERIALES.DESCRIPCION CONTAINING ?)';

  MATERIALES_SOLO_ACTIVOS = ' AND MATERIALES.ACTIVO = TRUE';

  // Dos ?: desde y hasta. ROWS cuenta desde 1 e incluye los extremos.
  MATERIALES_ORDEN_Y_PAGINA = ' ORDER BY MATERIALES.NOMBRE ROWS ? TO ?';

  // Completa: Count<T> solo acepta RQL, y RQL se arma concatenando el texto
  // que escribio la persona. Se le pega el filtro detras.
  MATERIALES_CONTAR = 'select count(*) from MATERIALES where ';

  // Completa. Se le pegan el filtro y el orden detras, los mismos de arriba.
  //
  // LEFT y no INNER: un material recien creado todavia no tiene fila de
  // precio, y tiene que salir en la lista igual, con el precio en null. Con
  // INNER desapareceria justo despues de crearlo.
  MATERIALES_CON_PRECIO =
    'select MATERIALES.ID, MATERIALES.CODIGO, MATERIALES.NOMBRE, ' +
    ' MATERIALES.DESCRIPCION, MATERIALES.UNIDAD_MEDIDA, MATERIALES.ACTIVO, ' +
    ' p.COSTO_UNITARIO, p.PRECIO_UNITARIO, p.FECHA_VIGENCIA ' +
    'from MATERIALES ' +
    'left join MATERIALES_PRECIOS p ' +
    ' on p.MATERIAL_ID = MATERIALES.ID and p.ACTIVO = TRUE ' +
    'where ';

  MATERIALES_POR_CODIGO = 'MATERIALES.CODIGO = ?';

  // Completa. Dos ?: nombre e ID a excluir; al crear se pasa 0. El UNIQUE de
  // la tabla esta en CODIGO, no en NOMBRE, asi que la HU-05 se cumple aqui.
  MATERIALES_NOMBRE_DUPLICADO =
    'select first 1 ID from MATERIALES ' +
    'where UPPER(NOMBRE) = UPPER(?) and ID <> ?';

  // MATERIALES_PRECIOS -------------------------------------------------------

  // Un ?: el material. El ORDER BY es defensivo por si quedara mas de una
  // activa. Cambiar de precio es desactivar esta e insertar otra, nunca
  // modificarla: el historial sostiene el precio de las cotizaciones viejas.
  MATERIAL_PRECIO_VIGENTE =
    'MATERIAL_ID = ? AND ACTIVO = TRUE ' +
    'ORDER BY FECHA_VIGENCIA DESC, ID DESC ROWS 1 TO 1';

  MATERIAL_PRECIOS_HISTORIAL =
    'MATERIAL_ID = ? ORDER BY FECHA_VIGENCIA DESC, ID DESC';

  // MANO DE OBRA -------------------------------------------------------------

  // Dos ? con el mismo texto: esta tabla no tiene NOMBRE.
  MANO_OBRA_FILTRO_BUSQUEDA =
    '(MANO_OBRA.CODIGO CONTAINING ? OR MANO_OBRA.DESCRIPCION CONTAINING ?)';

  MANO_OBRA_SOLO_ACTIVOS = ' AND MANO_OBRA.ACTIVO = TRUE';

  // Un ? mas, despues de los dos del texto.
  MANO_OBRA_POR_CATEGORIA = ' AND MANO_OBRA.CATEGORIA_ID = ?';

  MANO_OBRA_ORDEN_Y_PAGINA = ' ORDER BY MANO_OBRA.DESCRIPCION ROWS ? TO ?';

  MANO_OBRA_CONTAR = 'select count(*) from MANO_OBRA where ';

  // Completa. La categoria entra con join normal porque CATEGORIA_ID es NOT
  // NULL; el precio con LEFT, por lo mismo que en materiales.
  MANO_OBRA_CON_PRECIO =
    'select MANO_OBRA.ID, MANO_OBRA.CODIGO, MANO_OBRA.CATEGORIA_ID, ' +
    ' c.NOMBRE as CATEGORIA_NOMBRE, MANO_OBRA.DESCRIPCION, ' +
    ' MANO_OBRA.UNIDAD_MEDIDA, MANO_OBRA.ACTIVO, ' +
    ' p.COSTO_UNITARIO, p.FECHA_VIGENCIA ' +
    'from MANO_OBRA ' +
    'join MANO_OBRA_CATEGORIA c on c.ID = MANO_OBRA.CATEGORIA_ID ' +
    'left join MANO_OBRA_PRECIOS p ' +
    ' on p.MANO_OBRA_ID = MANO_OBRA.ID and p.ACTIVO = TRUE ' +
    'where ';

  MANO_OBRA_POR_CODIGO = 'MANO_OBRA.CODIGO = ?';

  // Completa. Dos ?: descripcion e ID a excluir. El duplicado se mide por
  // DESCRIPCION, que es lo que se lee en la lista.
  MANO_OBRA_DESCRIPCION_DUPLICADA =
    'select first 1 ID from MANO_OBRA ' +
    'where UPPER(DESCRIPCION) = UPPER(?) and ID <> ?';

  // La condicion siempre cierta esta porque GetWhere exige un WHERE.
  MANO_OBRA_CATEGORIAS = 'ID > 0 ORDER BY NOMBRE';

  // MANO_OBRA_PRECIOS --------------------------------------------------------

  MANO_OBRA_PRECIO_VIGENTE =
    'MANO_OBRA_ID = ? AND ACTIVO = TRUE ' +
    'ORDER BY FECHA_VIGENCIA DESC, ID DESC ROWS 1 TO 1';

  MANO_OBRA_PRECIOS_HISTORIAL =
    'MANO_OBRA_ID = ? ORDER BY FECHA_VIGENCIA DESC, ID DESC';

  // MAQUINAS -----------------------------------------------------------------

  // Tres ? con el mismo texto.
  MAQUINAS_FILTRO_BUSQUEDA =
    '(MAQUINAS.CODIGO CONTAINING ? OR MAQUINAS.NOMBRE CONTAINING ? ' +
    ' OR MAQUINAS.DESCRIPCION CONTAINING ?)';

  MAQUINAS_SOLO_ACTIVAS = ' AND MAQUINAS.ACTIVO = TRUE';

  MAQUINAS_ORDEN_Y_PAGINA = ' ORDER BY MAQUINAS.NOMBRE ROWS ? TO ?';

  MAQUINAS_CONTAR = 'select count(*) from MAQUINAS where ';

  // Completa. Aqui el precio es COSTO_HORA: la maquina se cobra por tiempo,
  // no por unidad.
  MAQUINAS_CON_PRECIO =
    'select MAQUINAS.ID, MAQUINAS.CODIGO, MAQUINAS.NOMBRE, ' +
    ' MAQUINAS.DESCRIPCION, MAQUINAS.ACTIVO, ' +
    ' p.COSTO_HORA, p.FECHA_VIGENCIA ' +
    'from MAQUINAS ' +
    'left join MAQUINAS_PRECIOS p ' +
    ' on p.MAQUINA_ID = MAQUINAS.ID and p.ACTIVO = TRUE ' +
    'where ';

  MAQUINAS_POR_CODIGO = 'MAQUINAS.CODIGO = ?';

  // Completa. Dos ?: nombre e ID a excluir.
  MAQUINAS_NOMBRE_DUPLICADO =
    'select first 1 ID from MAQUINAS ' +
    'where UPPER(NOMBRE) = UPPER(?) and ID <> ?';

  // MAQUINAS_PRECIOS ---------------------------------------------------------

  MAQUINA_PRECIO_VIGENTE =
    'MAQUINA_ID = ? AND ACTIVO = TRUE ' +
    'ORDER BY FECHA_VIGENCIA DESC, ID DESC ROWS 1 TO 1';

  MAQUINA_PRECIOS_HISTORIAL =
    'MAQUINA_ID = ? ORDER BY FECHA_VIGENCIA DESC, ID DESC';

  // TIPOS DE TRABAJO ---------------------------------------------------------

  // Una docena de filas que llenan un desplegable: sin paginar.
  TIPOS_TRABAJO_TODOS = 'ID > 0 ORDER BY NOMBRE';
  TIPOS_TRABAJO_ACTIVOS = 'ACTIVO = TRUE ORDER BY NOMBRE';

  // Completa. Dos ?: nombre e ID a excluir. NOMBRE si es UNIQUE aqui; se
  // comprueba igual para devolver un error de negocio y no el del motor.
  TIPOS_TRABAJO_NOMBRE_DUPLICADO =
    'select first 1 ID from TIPOS_TRABAJO ' +
    'where UPPER(NOMBRE) = UPPER(?) and ID <> ?';

implementation

end.
