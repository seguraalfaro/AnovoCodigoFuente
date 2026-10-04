unit Anovo.SQL.Usuarios;

// Consultas de usuarios y claves.

interface

const
  USUARIOS_POR_IDS = 'ID IN (%s)';

  USUARIO_POR_CORREO = 'CORREO = ?';

  USUARIO_CLAVE_ACTIVA =
    'USUARIO_ID = ? AND ACTIVO = TRUE ORDER BY ID DESC ROWS 1 TO 1';

  USUARIO_SISTEMA = 'CORREO = ''sistema@anovo.local''';

  USUARIO_CORREO_DUPLICADO = 'UPPER(CORREO) = UPPER(?) AND ID <> ?';

  USUARIOS_DE_ROL = 'ROL_ID = ?';

  EXCEPCIONES_DE_USUARIO = 'USUARIO_ID = ?';

  EXCEPCION_DE_USUARIO = 'USUARIO_ID = ? AND PERMISO_ID = ?';

implementation

end.
