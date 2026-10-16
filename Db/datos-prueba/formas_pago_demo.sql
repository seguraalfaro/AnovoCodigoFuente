/* ============================================================================
   Anovo - Formas de pago y condiciones por defecto de demostracion  (Firebird 4.0)
   ----------------------------------------------------------------------------
   NUNCA EN PRODUCCION. La migracion 43 dejo FORMAS_PAGO vacio a proposito: la
   lista real se valida con Anovo en minuta y se carga desde la pantalla.
   Mientras tanto, estos valores permiten escoger la forma de pago en la
   cotizacion. Llevan el prefijo 'Demo ' como los demas catalogos de prueba.

   Ademas deja en EMPRESA las condiciones por defecto (forma de pago, entrega
   en 8 dias habiles y garantia de 6 meses), que se copian a cada cotizacion
   nueva. Las cotizaciones que ya existen no cambian.

   Se puede volver a correr: UPDATE OR INSERT por NOMBRE no duplica.

   Uso:
     isql -u SYSDBA -p <clave> -i formas_pago_demo.sql localhost/3050:F:\...\ANOVO.FDB

   Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'datos de prueba: formas de pago') FROM RDB$DATABASE;

UPDATE OR INSERT INTO FORMAS_PAGO (NOMBRE, ACTIVO) VALUES ('Demo contado', TRUE) MATCHING (NOMBRE);
UPDATE OR INSERT INTO FORMAS_PAGO (NOMBRE, ACTIVO) VALUES ('Demo 50 por ciento de adelanto y 50 contra entrega', TRUE) MATCHING (NOMBRE);
UPDATE OR INSERT INTO FORMAS_PAGO (NOMBRE, ACTIVO) VALUES ('Demo credito a 30 dias', TRUE) MATCHING (NOMBRE);
UPDATE OR INSERT INTO FORMAS_PAGO (NOMBRE, ACTIVO) VALUES ('Demo transferencia contra entrega', TRUE) MATCHING (NOMBRE);

UPDATE EMPRESA SET
  FORMA_PAGO_ID = (SELECT ID FROM FORMAS_PAGO
                    WHERE NOMBRE = 'Demo 50 por ciento de adelanto y 50 contra entrega'),
  PLAZO_ENTREGA_CANTIDAD = 8, PLAZO_ENTREGA_UNIDAD = 'dias_habiles',
  GARANTIA_CANTIDAD = 6, GARANTIA_UNIDAD = 'meses';

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT ID, NOMBRE FROM FORMAS_PAGO WHERE ACTIVO;              -- 4 filas Demo
     SELECT FORMA_PAGO_ID, PLAZO_ENTREGA_CANTIDAD, PLAZO_ENTREGA_UNIDAD,
            GARANTIA_CANTIDAD, GARANTIA_UNIDAD FROM EMPRESA;       -- 8 dias_habiles, 6 meses
   ---------------------------------------------------------------------------- */
