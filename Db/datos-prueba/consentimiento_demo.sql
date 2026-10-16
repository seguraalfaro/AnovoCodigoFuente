/* ============================================================================
   Anovo - Texto del consentimiento de demostracion  (Firebird 4.0)
   ----------------------------------------------------------------------------
   NUNCA EN PRODUCCION. La migracion 44 dejo CONSENTIMIENTO_TEXTOS vacio: el
   texto real lo redacta Anovo, se valida en minuta y lo publica TI o gerencia
   desde Configuracion. Esta version "demo-1" permite probar la descarga al
   movil y la firma. Va sin tildes porque los scripts son ASCII.

   Se puede volver a correr: si la version ya existe no hace nada.

   Uso:
     isql -u SYSDBA -p <clave> -i consentimiento_demo.sql localhost/3050:F:\...\ANOVO.FDB

   Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'datos de prueba: texto del consentimiento') FROM RDB$DATABASE;

UPDATE CONSENTIMIENTO_TEXTOS SET VIGENTE = FALSE
 WHERE VIGENTE = TRUE
   AND NOT EXISTS (SELECT 1 FROM CONSENTIMIENTO_TEXTOS WHERE VERSION = 'demo-1');

INSERT INTO CONSENTIMIENTO_TEXTOS (VERSION, TITULO, CONTENIDO, VIGENTE,
  VIGENTE_DESDE, PUBLICADO_POR)
SELECT 'demo-1', 'Consentimiento informado (TEXTO DE PRUEBA)',
  'TEXTO DE PRUEBA, NO ES EL TEXTO LEGAL DE ANOVO.' || ASCII_CHAR(10) || ASCII_CHAR(10) ||
  '1. Sus datos se guardan en la base de datos de clientes de Anovo.' || ASCII_CHAR(10) ||
  '2. Se usan para preparar, enviar y dar seguimiento a cotizaciones.' || ASCII_CHAR(10) ||
  '3. Los consultan el asesor, el personal de cotizaciones y la supervision.' || ASCII_CHAR(10) ||
  '4. Dar los datos es voluntario.' || ASCII_CHAR(10) ||
  '5. Sin ellos no se puede preparar la cotizacion.' || ASCII_CHAR(10) ||
  '6. Puede pedir acceso, rectificacion o supresion de sus datos.' || ASCII_CHAR(10) ||
  '7. Responsable: Anovo, direccion pendiente de confirmar.' || ASCII_CHAR(10) ||
  '8. Puede revocar este consentimiento en cualquier momento.',
  TRUE, CURRENT_TIMESTAMP,
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local')
  FROM RDB$DATABASE
 WHERE NOT EXISTS (SELECT 1 FROM CONSENTIMIENTO_TEXTOS WHERE VERSION = 'demo-1');

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT VERSION, TITULO, VIGENTE FROM CONSENTIMIENTO_TEXTOS;   -- demo-1 vigente
   ---------------------------------------------------------------------------- */
