/* Anovo - Migracion 34: datos del documento de la cotizacion que se envia al
   cliente (formato aprobado por Javier Arias Huertas el 06/10/2026).
   EMPRESA guarda las condiciones por defecto, el firmante y la carta de
   presentacion; COTIZACIONES guarda las condiciones de cada una, que se copian
   de EMPRESA al crearla. Las columnas quedan vacias: los textos llevan tildes
   y se cargan desde Configuracion. Todo en ASCII. */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 34: documento de la cotizacion') FROM RDB$DATABASE;

ALTER TABLE EMPRESA ADD FORMA_PAGO VARCHAR(120);
ALTER TABLE EMPRESA ADD PLAZO_ENTREGA VARCHAR(120);
ALTER TABLE EMPRESA ADD GARANTIA VARCHAR(120);
ALTER TABLE EMPRESA ADD FIRMANTE D_NOMBRE;
ALTER TABLE EMPRESA ADD CARTA_PRESENTACION VARCHAR(4000);

ALTER TABLE COTIZACIONES ADD FORMA_PAGO VARCHAR(120);
ALTER TABLE COTIZACIONES ADD PLAZO_ENTREGA VARCHAR(120);
ALTER TABLE COTIZACIONES ADD GARANTIA VARCHAR(120);

COMMIT;

COMMENT ON COLUMN EMPRESA.FORMA_PAGO IS
  'Forma de pago por defecto; se copia a cada cotizacion nueva.';
COMMENT ON COLUMN EMPRESA.PLAZO_ENTREGA IS
  'Plazo de entrega por defecto; se copia a cada cotizacion nueva.';
COMMENT ON COLUMN EMPRESA.GARANTIA IS
  'Garantia por defecto; se copia a cada cotizacion nueva.';
COMMENT ON COLUMN EMPRESA.FIRMANTE IS
  'Nombre que firma el documento de la cotizacion.';
COMMENT ON COLUMN EMPRESA.CARTA_PRESENTACION IS
  'Texto de la segunda pagina del documento: servicios de la empresa.';

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (34, '34_documento_cotizacion');

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;
