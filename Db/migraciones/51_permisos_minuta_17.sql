/* ============================================================================
   Anovo - Migracion 51: permisos de la minuta 17/2026
   ----------------------------------------------------------------------------
   Matriz revisada con los usuarios el 18/10/2026 (Entregables/permisos/
   matriz-permisos.xlsx). Cambia la minuta 09/2026 (P19).

   - Permisos nuevos: solicitudes.tomar, cotizaciones.elaborar_propias,
     cotizaciones.ver_propias y cotizaciones.responder (enviar al cliente y
     registrar su respuesta: aprobada, rechazada o descartada).
   - cotizaciones.aprobar queda solo para el visto bueno y la devolucion.
   - adjuntos.crear y adjuntos.ver pasan al modulo solicitudes con codigo
     solicitudes.adjuntos.crear y solicitudes.adjuntos.ver.
   - acceso.movil y acceso.escritorio deciden quien entra a cada aplicacion.
     Son de negocio: TI entra al escritorio por su rol, para que nadie
     pueda dejar el sistema sin administrador.
   - Por rol: lo que se quita se inactiva (ACTIVO = FALSE), no se borra.

   Solo datos. El backend y los clientes se ajustan aparte: hasta entonces
   los codigos nuevos y los renombrados no los reconoce el codigo.

   Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 51: permisos de la minuta 17') FROM RDB$DATABASE;

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO)
  VALUES (206, 'solicitudes.tomar', 'Tomar solicitudes para cotizar',
          'solicitudes', 'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO)
  VALUES (405, 'cotizaciones.elaborar_propias',
          'Elaborar y modificar las cotizaciones propias', 'cotizaciones',
          'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO)
  VALUES (406, 'cotizaciones.ver_propias', 'Consultar las cotizaciones tomadas',
          'cotizaciones', 'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO)
  VALUES (407, 'cotizaciones.responder',
          'Enviar al cliente y registrar su respuesta', 'cotizaciones',
          'negocio');

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO)
  VALUES (1101, 'acceso.movil', 'Ingresar a la aplicacion movil', 'acceso',
          'negocio');
INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO)
  VALUES (1102, 'acceso.escritorio', 'Ingresar a la aplicacion de escritorio',
          'acceso', 'negocio');

UPDATE PERMISOS SET CODIGO = 'solicitudes.adjuntos.crear', MODULO = 'solicitudes'
 WHERE ID = 301;
UPDATE PERMISOS SET CODIGO = 'solicitudes.adjuntos.ver', MODULO = 'solicitudes'
 WHERE ID = 302;
UPDATE PERMISOS SET NOMBRE = 'Dar visto bueno o devolver cotizaciones'
 WHERE ID = 404;

COMMIT;

UPDATE ROLES_PERMISOS SET ACTIVO = FALSE
 WHERE (ROL_ID IN (2, 3, 4) AND PERMISO_ID IN (201, 205))
    OR (ROL_ID = 2 AND PERMISO_ID IN (401, 403))
    OR (ROL_ID = 4 AND PERMISO_ID = 401);

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 206, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 206, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 405, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 406, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 407, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 407, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 407, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 1101, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (1, 1102, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (2, 1102, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (3, 1102, 'negocio');
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO) VALUES (4, 1102, 'negocio');

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (51, '51_permisos_minuta_17');

COMMIT;

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT COUNT(*) FROM PERMISOS;                                  -- 33
     SELECT COUNT(*) FROM ROLES_PERMISOS WHERE ACTIVO = TRUE;        -- 62
     SELECT COUNT(*) FROM ROLES_PERMISOS WHERE ACTIVO = FALSE;       -- 9
     SELECT * FROM V_VERSION_ESQUEMA;                                -- 51
   ---------------------------------------------------------------------------- */
