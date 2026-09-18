/* ============================================================================
   06_campos_capturados_en_movil.sql
   Firebird 4.0 - base ANOVO
   16 de septiembre de 2026

   Dos datos que la app movil captura y guarda en SQLite y que Firebird no tenia
   donde recibir. Sin estas columnas se perderian en silencio al sincronizar: el
   telefono los manda, el servidor no tiene donde ponerlos, y nadie se entera.

   Se deja fuera CONTACTO de clientes, que si existe en SQLite: ningun codigo del
   movil la escribe, y repite lo que ya guarda CLIENTE_CONTACTOS.

   Se aplica sobre AnovoCodigoFuente\Db\ANOVO.FDB, la que declara
   Backend\bin\FDConnectionDefs.ini.
   ============================================================================ */

ALTER TABLE CLIENTES
  ADD TIPO_IDENTIFICACION SMALLINT;

/* Los mismos tres valores que el CHECK de SQLite y que el combo del movil. NULL
   es valido: el movil lo guarda asi cuando no se eligio tipo. */
ALTER TABLE CLIENTES
  ADD CONSTRAINT CK_CLIENTES_TIPO_IDENT
  CHECK (TIPO_IDENTIFICACION IS NULL OR TIPO_IDENTIFICACION IN (1, 2, 3));

COMMENT ON COLUMN CLIENTES.TIPO_IDENTIFICACION IS
  '1 cedula fisica, 2 cedula juridica, 3 DIMEX. Mismo valor que en SQLite.';

ALTER TABLE CLIENTE_CONTACTOS
  ADD CELULAR VARCHAR(30);

COMMENT ON COLUMN CLIENTE_CONTACTOS.CELULAR IS
  'Aparte de TELEFONO: en campo el asesor anota los dos.';

COMMIT;
