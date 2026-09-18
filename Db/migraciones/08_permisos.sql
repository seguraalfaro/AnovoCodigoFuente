/* ============================================================================
   08_permisos.sql
   Firebird 4.0 - base ANOVO
   18 de septiembre de 2026

   Permisos por rol en la base, en vez de fijos en los atributos del backend y
   en el menu de cada cliente. La matriz de la minuta 06/2026 (P18 y P19) pasa a
   ser los datos iniciales de ROLES_PERMISOS.

   El AMBITO separa lo de TI de lo de negocio. Las dos FK compuestas de
   ROLES_PERMISOS impiden darle al admin un permiso de negocio y al reves, aunque
   el backend se equivoque.

   Los datos iniciales van antes del disparador de auditoria: el script no tiene
   USUARIO_ID en el contexto y el disparador los rechazaria.

   Se aplica sobre AnovoCodigoFuente\Db\ANOVO.FDB.
   ============================================================================ */

CREATE DOMAIN D_AMBITO AS VARCHAR(15)
  CHECK (VALUE IN ('negocio', 'administracion'));

/* ---- ROLES --------------------------------------------------------------- */

ALTER TABLE ROLES
  ADD AMBITO D_AMBITO DEFAULT 'negocio' NOT NULL;

COMMIT;

UPDATE ROLES SET AMBITO = 'administracion' WHERE CODIGO = 'admin';

COMMIT;

/* Redundante con la PK, pero la FK compuesta de ROLES_PERMISOS necesita un
   UNIQUE exacto sobre (ID, AMBITO) al que apuntar. */
ALTER TABLE ROLES
  ADD CONSTRAINT UQ_ROLES_ID_AMBITO UNIQUE (ID, AMBITO);

COMMENT ON COLUMN ROLES.AMBITO IS
  'negocio o administracion. Decide que permisos puede recibir el rol.';

/* ---- PERMISOS -------------------------------------------------------------
   Catalogo fijo: lo carga este script, la aplicacion solo lo lee. Un permiso
   nuevo viene con codigo nuevo en el backend, no se inventa desde la pantalla. */

CREATE TABLE PERMISOS (
  ID     INTEGER PRIMARY KEY,
  CODIGO VARCHAR(50) NOT NULL UNIQUE,
  NOMBRE D_NOMBRE    NOT NULL,
  MODULO VARCHAR(30) NOT NULL,
  AMBITO D_AMBITO    NOT NULL,
  CONSTRAINT UQ_PERMISOS_ID_AMBITO UNIQUE (ID, AMBITO)
);

COMMENT ON TABLE PERMISOS IS
  'Operaciones que el backend autoriza. El codigo es el que declara cada accion.';

/* ---- ROLES_PERMISOS -------------------------------------------------------
   Un permiso se otorga o se quita: insert o delete, sin update. Aqui el borrado
   fisico si vale, el rastro queda en AUDITORIA. */

CREATE TABLE ROLES_PERMISOS (
  ROL_ID         INTEGER   NOT NULL,
  PERMISO_ID     INTEGER   NOT NULL,
  AMBITO         D_AMBITO  NOT NULL,
  FECHA_CREACION D_TIMESTAMP,
  CONSTRAINT PK_ROLES_PERMISOS PRIMARY KEY (ROL_ID, PERMISO_ID),
  CONSTRAINT FK_ROLPERM_ROL     FOREIGN KEY (ROL_ID, AMBITO)
    REFERENCES ROLES (ID, AMBITO),
  CONSTRAINT FK_ROLPERM_PERMISO FOREIGN KEY (PERMISO_ID, AMBITO)
    REFERENCES PERMISOS (ID, AMBITO)
);

CREATE INDEX IDX_ROLPERM_PERMISO ON ROLES_PERMISOS (PERMISO_ID);

COMMENT ON COLUMN ROLES_PERMISOS.AMBITO IS
  'Copia del ambito del permiso. Si no coincide con el del rol, falla la FK.';

COMMIT;

/* ============================================================================
   DATOS INICIALES
   IDs por centena de modulo, para leer la matriz sin consultar el catalogo.
   ============================================================================ */

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (101, 'clientes.ver',            'Consultar clientes',                     'clientes',     'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (102, 'clientes.crear',          'Registrar clientes',                     'clientes',     'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (103, 'clientes.editar',         'Modificar clientes',                     'clientes',     'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (104, 'clientes.inactivar',      'Inactivar clientes',                     'clientes',     'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (105, 'clientes.consentimiento', 'Registrar el consentimiento informado',  'clientes',     'negocio');

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (201, 'solicitudes.crear',          'Registrar solicitudes',               'solicitudes',  'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (202, 'solicitudes.ver_propias',    'Consultar las solicitudes propias',   'solicitudes',  'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (203, 'solicitudes.ver_todas',      'Consultar todas las solicitudes',     'solicitudes',  'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (204, 'solicitudes.editar_propias', 'Modificar las solicitudes propias',   'solicitudes',  'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (205, 'solicitudes.editar_todas',   'Modificar todas las solicitudes',     'solicitudes',  'negocio');

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (301, 'adjuntos.crear', 'Agregar croquis y fotografias',   'adjuntos', 'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (302, 'adjuntos.ver',   'Consultar croquis y fotografias', 'adjuntos', 'negocio');

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (401, 'cotizaciones.elaborar',              'Elaborar y modificar cotizaciones',                        'cotizaciones', 'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (402, 'cotizaciones.ver_aprobadas_propias', 'Consultar cotizaciones aprobadas de las solicitudes propias', 'cotizaciones', 'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (403, 'cotizaciones.ver_todas',             'Consultar todas las cotizaciones',                         'cotizaciones', 'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (404, 'cotizaciones.aprobar',               'Aprobar o rechazar cotizaciones',                          'cotizaciones', 'negocio');

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (501, 'catalogos.ver',    'Consultar catalogos', 'catalogos', 'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (502, 'catalogos.editar', 'Modificar catalogos', 'catalogos', 'negocio');

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (601, 'reportes.ver', 'Consultar reportes e historial', 'reportes', 'negocio');

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (701, 'auditoria.ver_toda',    'Consultar toda la bitacora de auditoria',     'auditoria', 'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (702, 'auditoria.ver_cuentas', 'Consultar la auditoria de cuentas de usuario', 'auditoria', 'administracion');

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (801, 'usuarios.administrar', 'Administrar usuarios y asignar roles', 'usuarios', 'administracion');

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (901, 'permisos.ver',    'Consultar permisos por rol', 'permisos', 'administracion');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO) VALUES (902, 'permisos.editar', 'Modificar permisos por rol', 'permisos', 'administracion');

COMMIT;

/* Matriz de la minuta 06/2026. Roles: 1 asesor, 2 asistente, 3 supervisor,
   4 gerencia, 5 admin. */

/* clientes (P18) */
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 101, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 101, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 101, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 101, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 102, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 102, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 102, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 102, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 103, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 103, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 103, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 103, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 104, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 104, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 105, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 105, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 105, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 105, 'negocio');

/* solicitudes */
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 201, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 201, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 201, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 201, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 202, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 203, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 203, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 203, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 204, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 205, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 205, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 205, 'negocio');

/* adjuntos: el asesor ve solo los de sus solicitudes, eso lo filtra el servicio */
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 301, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 302, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 302, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 302, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 302, 'negocio');

/* cotizaciones */
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 401, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 401, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 401, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 402, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 403, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 403, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 403, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 404, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 404, 'negocio');

/* catalogos */
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 501, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 501, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 501, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 501, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 502, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 502, 'negocio');

/* reportes y auditoria */
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 601, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 601, 'negocio');

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 701, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (5, 702, 'administracion');

/* administracion */
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (5, 801, 'administracion');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (5, 901, 'administracion');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (5, 902, 'administracion');

COMMIT;

/* ============================================================================
   AUDITORIA
   ============================================================================ */

SET TERM ^ ;

CREATE TRIGGER TR_ROLES_PERMISOS_AUD FOR ROLES_PERMISOS
ACTIVE AFTER INSERT OR UPDATE OR DELETE POSITION 10
AS
  DECLARE VARIABLE V_USUARIO INTEGER;
  DECLARE VARIABLE V_ACCION  VARCHAR(50);
  DECLARE VARIABLE V_ROL     INTEGER;
  DECLARE VARIABLE V_PERMISO INTEGER;
BEGIN
  V_USUARIO = CAST(RDB$GET_CONTEXT('USER_SESSION', 'USUARIO_ID') AS INTEGER);
  IF (V_USUARIO IS NULL) THEN EXCEPTION E_AUDITORIA_SIN_USUARIO;
  IF (INSERTING) THEN BEGIN V_ACCION = 'insertar';   V_ROL = NEW.ROL_ID; V_PERMISO = NEW.PERMISO_ID; END
  ELSE IF (UPDATING) THEN BEGIN V_ACCION = 'actualizar'; V_ROL = NEW.ROL_ID; V_PERMISO = NEW.PERMISO_ID; END
  ELSE BEGIN V_ACCION = 'borrar'; V_ROL = OLD.ROL_ID; V_PERMISO = OLD.PERMISO_ID; END
  INSERT INTO AUDITORIA (USUARIO_ID, ACCION, ENTIDAD, ENTIDAD_ID, DETALLE)
  VALUES (:V_USUARIO, :V_ACCION, 'ROLES_PERMISOS', :V_ROL, 'permiso ' || :V_PERMISO);
END^

SET TERM ; ^

/* ============================================================================
   PERMISOS DE BASE DE DATOS
   ============================================================================ */

GRANT SELECT                 ON PERMISOS       TO ROL_BACKEND;
GRANT SELECT, INSERT, DELETE ON ROLES_PERMISOS TO ROL_BACKEND;

GRANT INSERT ON AUDITORIA TO TRIGGER TR_ROLES_PERMISOS_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_ROLES_PERMISOS_AUD;

COMMIT;
