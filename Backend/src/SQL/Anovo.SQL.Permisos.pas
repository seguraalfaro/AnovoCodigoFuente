unit Anovo.SQL.Permisos;

// Las consultas de permisos, en un solo sitio.
//
// PERMISOS_MATRIZ es consulta completa, no fragmento: devuelve codigos de dos
// tablas y no pasa por la ORM.

interface

const
  // Sin ?. La matriz entera, rol y permiso por codigo. Es lo que carga la
  // cache: 57 filas hoy, no vale la pena traerla por partes.
  PERMISOS_MATRIZ =
    'select R.CODIGO as ROL, P.CODIGO as PERMISO ' +
    '  from ROLES_PERMISOS RP ' +
    '  join ROLES R on R.ID = RP.ROL_ID ' +
    '  join PERMISOS P on P.ID = RP.PERMISO_ID ' +
    ' order by R.CODIGO, P.CODIGO';

implementation

end.
