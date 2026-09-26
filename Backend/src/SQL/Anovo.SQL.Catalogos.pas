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

uses
  // Los codigos de TIPO del listado unificado. Viven en la unidad de DTO
  // porque el escritorio los lee para decidir que ventana abrir.
  Anovo.DTOs.Catalogos;

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
    ' p.COSTO_UNITARIO, p.PRECIO_UNITARIO, p.FECHA_VIGENCIA, ' +
    // La fecha del proximo cambio en cola, nula si no hay. Viaja con el
    // listado para no pedirla aparte por cada fila.
    ' (select min(pp.FECHA_VIGENCIA) from PRECIOS_PROGRAMADOS pp ' +
    '   where pp.MATERIAL_ID = MATERIALES.ID and pp.ESTADO = ''pendiente'') ' +
    '   as PROGRAMADO_FECHA ' +
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

  // Tres ? con el mismo texto.
  MANO_OBRA_FILTRO_BUSQUEDA =
    '(MANO_OBRA.CODIGO CONTAINING ? OR MANO_OBRA.NOMBRE CONTAINING ? ' +
    ' OR MANO_OBRA.DESCRIPCION CONTAINING ?)';

  MANO_OBRA_SOLO_ACTIVOS = ' AND MANO_OBRA.ACTIVO = TRUE';

  // Un ? mas, despues de los dos del texto.
  MANO_OBRA_POR_CATEGORIA = ' AND MANO_OBRA.CATEGORIA_ID = ?';

  MANO_OBRA_ORDEN_Y_PAGINA = ' ORDER BY MANO_OBRA.NOMBRE ROWS ? TO ?';

  MANO_OBRA_CONTAR = 'select count(*) from MANO_OBRA where ';

  // Completa. La categoria entra con join normal porque CATEGORIA_ID es NOT
  // NULL; el precio con LEFT, por lo mismo que en materiales.
  MANO_OBRA_CON_PRECIO =
    'select MANO_OBRA.ID, MANO_OBRA.CODIGO, MANO_OBRA.CATEGORIA_ID, ' +
    ' c.NOMBRE as CATEGORIA_NOMBRE, MANO_OBRA.NOMBRE, ' +
    ' MANO_OBRA.DESCRIPCION, ' +
    ' MANO_OBRA.UNIDAD_MEDIDA, MANO_OBRA.ACTIVO, ' +
    ' p.COSTO_UNITARIO, p.FECHA_VIGENCIA, ' +
    ' (select min(pp.FECHA_VIGENCIA) from PRECIOS_PROGRAMADOS pp ' +
    '   where pp.MANO_OBRA_ID = MANO_OBRA.ID and pp.ESTADO = ''pendiente'') ' +
    '   as PROGRAMADO_FECHA ' +
    'from MANO_OBRA ' +
    'join MANO_OBRA_CATEGORIA c on c.ID = MANO_OBRA.CATEGORIA_ID ' +
    'left join MANO_OBRA_PRECIOS p ' +
    ' on p.MANO_OBRA_ID = MANO_OBRA.ID and p.ACTIVO = TRUE ' +
    'where ';

  MANO_OBRA_POR_CODIGO = 'MANO_OBRA.CODIGO = ?';

  // Completa. Dos ?: nombre e ID a excluir. Desde la migracion 12 se mide por
  // NOMBRE, igual que en los otros dos catalogos.
  MANO_OBRA_NOMBRE_DUPLICADO =
    'select first 1 ID from MANO_OBRA ' +
    'where UPPER(NOMBRE) = UPPER(?) and ID <> ?';

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
    ' p.COSTO_HORA, p.FECHA_VIGENCIA, ' +
    ' (select min(pp.FECHA_VIGENCIA) from PRECIOS_PROGRAMADOS pp ' +
    '   where pp.MAQUINA_ID = MAQUINAS.ID and pp.ESTADO = ''pendiente'') ' +
    '   as PROGRAMADO_FECHA ' +
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

  // PRECIOS PROGRAMADOS ------------------------------------------------------

  // Un cambio de precio con fecha futura no se guarda como precio: espera aqui
  // hasta que llega su fecha. Ver migracion 14 y Anovo.Services.Vigencias.

  // La cola que el servidor vacia al arrancar y cada hora. Sin ?: la fecha la
  // resuelve el motor, no el reloj del equipo que pregunta.
  PROGRAMADOS_POR_APLICAR =
    'ESTADO = ''pendiente'' AND FECHA_VIGENCIA <= CURRENT_TIMESTAMP ' +
    'ORDER BY FECHA_VIGENCIA, ID';

  // Un ?: el item. Lo que tiene esperando, para avisarlo en el catalogo.
  PROGRAMADOS_DE_MATERIAL =
    'MATERIAL_ID = ? AND ESTADO = ''pendiente'' ORDER BY FECHA_VIGENCIA';
  PROGRAMADOS_DE_MANO_OBRA =
    'MANO_OBRA_ID = ? AND ESTADO = ''pendiente'' ORDER BY FECHA_VIGENCIA';
  PROGRAMADOS_DE_MAQUINA =
    'MAQUINA_ID = ? AND ESTADO = ''pendiente'' ORDER BY FECHA_VIGENCIA';

  // TODOS LOS CATALOGOS ------------------------------------------------------

  // Materiales, mano de obra y maquinas en una sola lista, paginada y buscable
  // en el servidor. Si la uniera el escritorio, pidiendo una pagina de cada
  // uno, la pestana mostraria los primeros 50 de cada catalogo y el total no
  // cuadraria con nada.
  //
  // Cada rama devuelve las mismas columnas en el mismo orden. Lo que no aplica
  // va nulo, con CAST: en un UNION el tipo lo fija la primera rama, y un NULL
  // sin tipo no le dice nada al motor. El TIPO va como VARCHAR para que
  // 'material' no salga rellenado con un espacio al lado de 'mano_obra'.
  //
  // Las columnas se llaman igual que en el listado de cada catalogo. La
  // ventana del item lee la fila por nombre, y asi abre igual desde aqui que
  // desde su pestana. COSTO es la columna comun para mostrar: el costo
  // unitario en materiales y mano de obra, el costo por hora en maquinas.
  //
  // Tipos de trabajo no entra: no tiene codigo ni precio que comparar.
  CATALOGOS_UNION =
    '(select cast(''' + TIPO_MATERIAL + ''' as varchar(10)) as TIPO, ' +
    '   m.ID, m.CODIGO, m.NOMBRE, m.DESCRIPCION, m.UNIDAD_MEDIDA, ' +
    '   cast(null as integer) as CATEGORIA_ID, ' +
    '   p.COSTO_UNITARIO, p.PRECIO_UNITARIO, ' +
    '   cast(null as numeric(15,2)) as COSTO_HORA, ' +
    '   p.COSTO_UNITARIO as COSTO, p.FECHA_VIGENCIA, m.ACTIVO, ' +
    '   (select min(pp.FECHA_VIGENCIA) from PRECIOS_PROGRAMADOS pp ' +
    '     where pp.MATERIAL_ID = m.ID and pp.ESTADO = ''pendiente'') ' +
    '     as PROGRAMADO_FECHA ' +
    '  from MATERIALES m ' +
    '  left join MATERIALES_PRECIOS p ' +
    '    on p.MATERIAL_ID = m.ID and p.ACTIVO = TRUE ' +
    ' union all ' +
    ' select cast(''' + TIPO_MANO_OBRA + ''' as varchar(10)), ' +
    '   mo.ID, mo.CODIGO, mo.NOMBRE, mo.DESCRIPCION, mo.UNIDAD_MEDIDA, ' +
    '   mo.CATEGORIA_ID, ' +
    '   p.COSTO_UNITARIO, cast(null as numeric(15,2)), ' +
    '   cast(null as numeric(15,2)), ' +
    '   p.COSTO_UNITARIO, p.FECHA_VIGENCIA, mo.ACTIVO, ' +
    '   (select min(pp.FECHA_VIGENCIA) from PRECIOS_PROGRAMADOS pp ' +
    '     where pp.MANO_OBRA_ID = mo.ID and pp.ESTADO = ''pendiente'') ' +
    '  from MANO_OBRA mo ' +
    '  left join MANO_OBRA_PRECIOS p ' +
    '    on p.MANO_OBRA_ID = mo.ID and p.ACTIVO = TRUE ' +
    ' union all ' +
    // Maquinas no tiene unidad: se cobra por hora, y eso es lo que se ve.
    ' select cast(''' + TIPO_MAQUINA + ''' as varchar(10)), ' +
    '   q.ID, q.CODIGO, q.NOMBRE, q.DESCRIPCION, ' +
    '   cast(''hora'' as varchar(20)), cast(null as integer), ' +
    '   cast(null as numeric(15,2)), cast(null as numeric(15,2)), ' +
    '   p.COSTO_HORA, ' +
    '   p.COSTO_HORA, p.FECHA_VIGENCIA, q.ACTIVO, ' +
    '   (select min(pp.FECHA_VIGENCIA) from PRECIOS_PROGRAMADOS pp ' +
    '     where pp.MAQUINA_ID = q.ID and pp.ESTADO = ''pendiente'') ' +
    '  from MAQUINAS q ' +
    '  left join MAQUINAS_PRECIOS p ' +
    '    on p.MAQUINA_ID = q.ID and p.ACTIVO = TRUE) t ';

  // Se les pegan detras el filtro y, al listado, el orden con la pagina.
  CATALOGOS_TODOS = 'select t.* from ' + CATALOGOS_UNION + 'where ';
  CATALOGOS_TODOS_CONTAR = 'select count(*) from ' + CATALOGOS_UNION +
    'where ';

  // Tres ? con el mismo texto.
  CATALOGOS_TODOS_FILTRO =
    '(t.CODIGO CONTAINING ? OR t.NOMBRE CONTAINING ? ' +
    ' OR t.DESCRIPCION CONTAINING ?)';
  CATALOGOS_TODOS_SOLO_ACTIVOS = ' AND t.ACTIVO = TRUE';

  // Dos ?: desde y hasta. TIPO e ID desempatan: dos catalogos pueden tener
  // un item con el mismo nombre, y sin desempate la pagina podria repetir o
  // saltarse filas entre una consulta y la siguiente.
  CATALOGOS_TODOS_ORDEN_Y_PAGINA =
    ' ORDER BY t.NOMBRE, t.TIPO, t.ID ROWS ? TO ?';

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
