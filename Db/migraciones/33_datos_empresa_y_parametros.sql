/* Anovo - Migracion 33: datos de la empresa y parametros editables desde
   Configuracion (minuta 13/2026, tema 4, pendiente de aprobacion).
   Dos permisos con el mismo alcance, uno por ambito: empresa.editar para
   gerencia y empresa.administrar para TI. EMPRESA suma el plazo, en dias, de
   las cotizaciones enviadas sin respuesta del cliente. ESQUEMA_MIGRACIONES
   registra cada migracion aplicada; desde esta, cada script agrega su fila.
   Todo en ASCII. */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 33: datos de la empresa y parametros') FROM RDB$DATABASE;

CREATE TABLE ESQUEMA_MIGRACIONES (
  NUMERO  INTEGER NOT NULL PRIMARY KEY,
  NOMBRE  VARCHAR(80) NOT NULL,
  FECHA   D_TIMESTAMP
);

COMMENT ON TABLE ESQUEMA_MIGRACIONES IS
  'Una fila por migracion aplicada. La version de la base es MAX(NUMERO).';

CREATE VIEW V_VERSION_ESQUEMA AS
SELECT CAST(COALESCE(MAX(NUMERO), 0) AS INTEGER) AS NUMERO
  FROM ESQUEMA_MIGRACIONES;

GRANT SELECT ON V_VERSION_ESQUEMA TO ROL_BACKEND;

COMMIT;

ALTER TABLE EMPRESA ADD DIAS_SIN_RESPUESTA INTEGER DEFAULT 7 NOT NULL;

COMMIT;

ALTER TABLE EMPRESA ADD CONSTRAINT CK_EMPRESA_DIAS_SIN_RESPUESTA
  CHECK (DIAS_SIN_RESPUESTA BETWEEN 1 AND 90);

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO)
  VALUES (1001, 'empresa.editar', 'Modificar los datos de la empresa', 'empresa', 'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO)
  VALUES (1002, 'empresa.administrar', 'Modificar los datos de la empresa (TI)', 'empresa', 'administracion');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 1001, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (5, 1002, 'administracion');

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (33, '33_datos_empresa_y_parametros');

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;
