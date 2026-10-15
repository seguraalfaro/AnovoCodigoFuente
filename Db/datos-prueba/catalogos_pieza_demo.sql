/* ============================================================================
   Anovo - Tipos de material y acabados de demostracion  (Firebird 4.0)
   ----------------------------------------------------------------------------
   NUNCA EN PRODUCCION. La migracion 38 dejo TIPOS_MATERIAL y ACABADOS vacios a
   proposito: la lista real se valida con Anovo en minuta y se carga desde la
   pantalla. Mientras tanto, estos valores permiten elegir material y acabado
   en la pieza del movil. Llevan el prefijo 'Demo ' como los tipos de trabajo
   de carga_demo.sql.

   Se puede volver a correr: UPDATE OR INSERT por NOMBRE no duplica.

   Uso:
     isql -u SYSDBA -p <clave> -i catalogos_pieza_demo.sql localhost/3050:F:\...\ANOVO.FDB
   Despues: python exportar_demo_movil.py, para que el movil los traiga.

   Todo en ASCII.
   ============================================================================ */

UPDATE OR INSERT INTO TIPOS_MATERIAL (NOMBRE, ACTIVO) VALUES ('Demo acero inoxidable', TRUE) MATCHING (NOMBRE);
UPDATE OR INSERT INTO TIPOS_MATERIAL (NOMBRE, ACTIVO) VALUES ('Demo hierro negro', TRUE) MATCHING (NOMBRE);
UPDATE OR INSERT INTO TIPOS_MATERIAL (NOMBRE, ACTIVO) VALUES ('Demo acero galvanizado', TRUE) MATCHING (NOMBRE);
UPDATE OR INSERT INTO TIPOS_MATERIAL (NOMBRE, ACTIVO) VALUES ('Demo aluminio', TRUE) MATCHING (NOMBRE);
UPDATE OR INSERT INTO TIPOS_MATERIAL (NOMBRE, ACTIVO) VALUES ('Demo bronce', TRUE) MATCHING (NOMBRE);

UPDATE OR INSERT INTO ACABADOS (NOMBRE, ACTIVO) VALUES ('Demo sin acabado', TRUE) MATCHING (NOMBRE);
UPDATE OR INSERT INTO ACABADOS (NOMBRE, ACTIVO) VALUES ('Demo pintura anticorrosiva', TRUE) MATCHING (NOMBRE);
UPDATE OR INSERT INTO ACABADOS (NOMBRE, ACTIVO) VALUES ('Demo pintura electrostatica', TRUE) MATCHING (NOMBRE);
UPDATE OR INSERT INTO ACABADOS (NOMBRE, ACTIVO) VALUES ('Demo galvanizado en caliente', TRUE) MATCHING (NOMBRE);
UPDATE OR INSERT INTO ACABADOS (NOMBRE, ACTIVO) VALUES ('Demo pulido', TRUE) MATCHING (NOMBRE);

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT ID, NOMBRE FROM TIPOS_MATERIAL WHERE ACTIVO;   -- 5 filas Demo
     SELECT ID, NOMBRE FROM ACABADOS WHERE ACTIVO;         -- 5 filas Demo
   ---------------------------------------------------------------------------- */
