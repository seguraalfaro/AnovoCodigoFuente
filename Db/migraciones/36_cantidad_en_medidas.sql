/* Anovo - Migracion 36: cantidad en cada medida de la solicitud. El croquis
   del movil rotula cotas con letra y una misma cota puede valer por varias
   piezas iguales (cuatro agujeros de 1/2"). El asistente la necesita como
   numero para cotizar la mano de obra. Las filas existentes quedan en 1.
   Todo en ASCII. */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 36: cantidad en las medidas') FROM RDB$DATABASE;

ALTER TABLE SOLICITUD_MEDIDAS
  ADD CANTIDAD SMALLINT DEFAULT 1 NOT NULL;

ALTER TABLE SOLICITUD_MEDIDAS
  ADD CONSTRAINT CK_SOLICITUD_MEDIDAS_CANTIDAD CHECK (CANTIDAD > 0);

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (36, '36_cantidad_en_medidas');

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;
