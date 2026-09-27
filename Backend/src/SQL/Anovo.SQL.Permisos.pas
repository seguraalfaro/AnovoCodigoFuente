unit Anovo.SQL.Permisos;

// Consultas de permisos.

interface

const
  PERMISOS_MATRIZ =
    'select R.CODIGO as ROL, P.CODIGO as PERMISO ' +
    '  from ROLES_PERMISOS RP ' +
    '  join ROLES R on R.ID = RP.ROL_ID ' +
    '  join PERMISOS P on P.ID = RP.PERMISO_ID ' +
    ' order by R.CODIGO, P.CODIGO';

implementation

end.
