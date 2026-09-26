unit Anovo.SQL.Usuarios;

// Las consultas de usuarios, en un solo sitio.

interface

const
  // El %s es la lista de numeros, ya armada. No lleva ? porque los numeros
  // salen de la base, no de lo que alguien escribio.
  USUARIOS_POR_IDS = 'ID IN (%s)';

  // El usuario que se pone el servidor cuando escribe por su cuenta, para que
  // los disparadores de auditoria lo dejen. Se busca por correo y no por ID
  // fijo: la identidad se lo asigna como a cualquier otro. Ver migracion 13.
  USUARIO_SISTEMA =
    'select ID from USUARIOS where CORREO = ''sistema@anovo.local''';

implementation

end.
