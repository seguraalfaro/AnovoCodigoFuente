unit Anovo.SQL.Catalogos;

// Consultas de catalogos, precios y la lista Todos.

interface

uses
  Anovo.DTOs.Catalogos;

const

  MATERIALES_FILTRO_BUSQUEDA =
    '(MATERIALES.CODIGO CONTAINING ? OR MATERIALES.NOMBRE CONTAINING ? ' +
    ' OR MATERIALES.DESCRIPCION CONTAINING ?)';

  MATERIALES_SOLO_ACTIVOS = ' AND MATERIALES.ACTIVO = TRUE';

  MATERIALES_ORDEN_Y_PAGINA = ' ORDER BY MATERIALES.NOMBRE ROWS ? TO ?';

  MATERIALES_CONTAR = 'select count(*) from MATERIALES where ';

  MATERIALES_CON_PRECIO =
    'select MATERIALES.ID, MATERIALES.CODIGO, MATERIALES.NOMBRE, ' +
    ' MATERIALES.DESCRIPCION, MATERIALES.UNIDAD_MEDIDA, MATERIALES.ACTIVO, ' +
    ' p.COSTO_UNITARIO, p.PRECIO_UNITARIO, p.FECHA_VIGENCIA, ' +
    ' (select min(pp.FECHA_VIGENCIA) from PRECIOS_PROGRAMADOS pp ' +
    '   where pp.MATERIAL_ID = MATERIALES.ID and pp.ESTADO = ''pendiente'') ' +
    '   as PROGRAMADO_FECHA ' +
    'from MATERIALES ' +
    'left join MATERIALES_PRECIOS p ' +
    ' on p.MATERIAL_ID = MATERIALES.ID and p.ACTIVO = TRUE ' +
    'where ';

  MATERIALES_POR_CODIGO = 'MATERIALES.CODIGO = ?';

  MATERIALES_NOMBRE_DUPLICADO =
    'select first 1 ID from MATERIALES ' +
    'where UPPER(NOMBRE) = UPPER(?) and ID <> ?';

  MATERIAL_PRECIO_VIGENTE =
    'MATERIAL_ID = ? AND ACTIVO = TRUE ' +
    'ORDER BY FECHA_VIGENCIA DESC, ID DESC ROWS 1 TO 1';

  MATERIAL_PRECIOS_HISTORIAL =
    'MATERIAL_ID = ? ORDER BY FECHA_VIGENCIA DESC, ID DESC';

  MANO_OBRA_FILTRO_BUSQUEDA =
    '(MANO_OBRA.CODIGO CONTAINING ? OR MANO_OBRA.NOMBRE CONTAINING ? ' +
    ' OR MANO_OBRA.DESCRIPCION CONTAINING ?)';

  MANO_OBRA_SOLO_ACTIVOS = ' AND MANO_OBRA.ACTIVO = TRUE';

  MANO_OBRA_POR_CATEGORIA = ' AND MANO_OBRA.CATEGORIA_ID = ?';

  MANO_OBRA_ORDEN_Y_PAGINA = ' ORDER BY MANO_OBRA.NOMBRE ROWS ? TO ?';

  MANO_OBRA_CONTAR = 'select count(*) from MANO_OBRA where ';

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

  MANO_OBRA_NOMBRE_DUPLICADO =
    'select first 1 ID from MANO_OBRA ' +
    'where UPPER(NOMBRE) = UPPER(?) and ID <> ?';

  MANO_OBRA_CATEGORIAS = 'ID > 0 ORDER BY NOMBRE';

  MANO_OBRA_PRECIO_VIGENTE =
    'MANO_OBRA_ID = ? AND ACTIVO = TRUE ' +
    'ORDER BY FECHA_VIGENCIA DESC, ID DESC ROWS 1 TO 1';

  MANO_OBRA_PRECIOS_HISTORIAL =
    'MANO_OBRA_ID = ? ORDER BY FECHA_VIGENCIA DESC, ID DESC';

  MAQUINAS_FILTRO_BUSQUEDA =
    '(MAQUINAS.CODIGO CONTAINING ? OR MAQUINAS.NOMBRE CONTAINING ? ' +
    ' OR MAQUINAS.DESCRIPCION CONTAINING ?)';

  MAQUINAS_SOLO_ACTIVAS = ' AND MAQUINAS.ACTIVO = TRUE';

  MAQUINAS_ORDEN_Y_PAGINA = ' ORDER BY MAQUINAS.NOMBRE ROWS ? TO ?';

  MAQUINAS_CONTAR = 'select count(*) from MAQUINAS where ';

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

  MAQUINAS_NOMBRE_DUPLICADO =
    'select first 1 ID from MAQUINAS ' +
    'where UPPER(NOMBRE) = UPPER(?) and ID <> ?';

  MAQUINA_PRECIO_VIGENTE =
    'MAQUINA_ID = ? AND ACTIVO = TRUE ' +
    'ORDER BY FECHA_VIGENCIA DESC, ID DESC ROWS 1 TO 1';

  MAQUINA_PRECIOS_HISTORIAL =
    'MAQUINA_ID = ? ORDER BY FECHA_VIGENCIA DESC, ID DESC';

  PROGRAMADOS_POR_APLICAR =
    'ESTADO = ''pendiente'' AND FECHA_VIGENCIA <= CURRENT_TIMESTAMP ' +
    'ORDER BY FECHA_VIGENCIA, ID';

  PROGRAMADOS_DE_MATERIAL =
    'MATERIAL_ID = ? AND ESTADO = ''pendiente'' ORDER BY FECHA_VIGENCIA';
  PROGRAMADOS_DE_MANO_OBRA =
    'MANO_OBRA_ID = ? AND ESTADO = ''pendiente'' ORDER BY FECHA_VIGENCIA';
  PROGRAMADOS_DE_MAQUINA =
    'MAQUINA_ID = ? AND ESTADO = ''pendiente'' ORDER BY FECHA_VIGENCIA';

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

  CATALOGOS_TODOS = 'select t.* from ' + CATALOGOS_UNION + 'where ';
  CATALOGOS_TODOS_CONTAR = 'select count(*) from ' + CATALOGOS_UNION +
    'where ';

  CATALOGOS_TODOS_FILTRO =
    '(t.CODIGO CONTAINING ? OR t.NOMBRE CONTAINING ? ' +
    ' OR t.DESCRIPCION CONTAINING ?)';
  CATALOGOS_TODOS_SOLO_ACTIVOS = ' AND t.ACTIVO = TRUE';

  CATALOGOS_TODOS_ORDEN_Y_PAGINA =
    ' ORDER BY t.NOMBRE, t.TIPO, t.ID ROWS ? TO ?';

  TIPOS_TRABAJO_TODOS = 'ID > 0 ORDER BY NOMBRE';
  TIPOS_TRABAJO_ACTIVOS = 'ACTIVO = TRUE ORDER BY NOMBRE';

  TIPOS_TRABAJO_NOMBRE_DUPLICADO =
    'select first 1 ID from TIPOS_TRABAJO ' +
    'where UPPER(NOMBRE) = UPPER(?) and ID <> ?';

implementation

end.
