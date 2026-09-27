unit Anovo.SQL.Usuarios;

// Consultas de usuarios y claves.

interface

const
  USUARIOS_POR_IDS = 'ID IN (%s)';

  USUARIO_CLAVE_ACTIVA =
    'USUARIO_ID = ? AND ACTIVO = TRUE ORDER BY ID DESC ROWS 1 TO 1';

  USUARIO_SISTEMA =
    'select ID from USUARIOS where CORREO = ''sistema@anovo.local''';

implementation

end.
