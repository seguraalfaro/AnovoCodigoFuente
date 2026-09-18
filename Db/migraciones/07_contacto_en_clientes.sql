/* ============================================================================
   07_contacto_en_clientes.sql
   Firebird 4.0 - base ANOVO
   16 de septiembre de 2026

   Nombre de la persona de contacto que el asesor escribe en la hoja de datos del
   cliente. El 06 lo dejo fuera por error: se concluyo que no se usaba porque el
   guardado local del movil no lo inserta, cuando en realidad la pantalla lo
   captura y es el guardado el que lo pierde.

   Se aplica sobre AnovoCodigoFuente\Db\ANOVO.FDB.
   ============================================================================ */

ALTER TABLE CLIENTES
  ADD CONTACTO D_NOMBRE;

COMMENT ON COLUMN CLIENTES.CONTACTO IS
  'Persona de contacto escrita en la hoja de datos del cliente.';

COMMIT;
