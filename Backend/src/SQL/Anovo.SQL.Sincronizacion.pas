unit Anovo.SQL.Sincronizacion;

// Filtros de la bajada al movil, comunes a clientes, contactos y catalogos.

interface

const
  BAJADA_COMPLETA = 'ACTIVO = TRUE ORDER BY ID';

  BAJADA_DESDE = 'FECHA_MODIFICACION > ? ORDER BY ID';

  BAJADA_CON_UUID = 'UUID_LOCAL IS NOT NULL AND ';

implementation

end.
