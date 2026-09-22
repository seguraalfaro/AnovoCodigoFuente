unit Anovo.SQL.Usuarios;

// Las consultas de usuarios, en un solo sitio.

interface

const
  // El %s es la lista de numeros, ya armada. No lleva ? porque los numeros
  // salen de la base, no de lo que alguien escribio.
  USUARIOS_POR_IDS = 'ID IN (%s)';

implementation

end.
