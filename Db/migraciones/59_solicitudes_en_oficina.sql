/* ============================================================================
   Anovo - Migracion 59: registro de solicitudes en la oficina
   ----------------------------------------------------------------------------
   Minuta 19/2026 (07/11/2026): el asistente y el supervisor registran una
   solicitud desde la aplicacion de escritorio con los datos basicos (cliente,
   contacto, nombre del proyecto, descripcion y observaciones), sin croquis,
   medidas ni fotografias. Cambia la minuta 17/2026, que dejaba el registro
   solo al asesor desde el movil.

   - Permiso nuevo solicitudes.registrar_oficina, por rol al asistente y al
     supervisor. A otra cuenta se da como excepcion por usuario.
   - solicitudes.crear no cambia: sigue siendo el registro desde el movil.

   Solo datos. Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 59: solicitudes en la oficina') FROM RDB$DATABASE;

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO_ID, AMBITO_ID)
  VALUES (207, 'solicitudes.registrar_oficina',
          'Registrar solicitudes en la oficina',
          (SELECT ID FROM MODULOS WHERE CODIGO = 'solicitudes'),
          (SELECT ID FROM AMBITOS WHERE CODIGO = 'negocio'));

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO_ID)
  VALUES (2, 207, (SELECT ID FROM AMBITOS WHERE CODIGO = 'negocio'));
INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO_ID)
  VALUES (3, 207, (SELECT ID FROM AMBITOS WHERE CODIGO = 'negocio'));

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (59, '59_solicitudes_en_oficina');

COMMIT;

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT P.CODIGO, R.ROL_ID, R.ACTIVO FROM ROLES_PERMISOS R
       JOIN PERMISOS P ON P.ID = R.PERMISO_ID
      WHERE P.ID = 207;                                   -- roles 2 y 3
     SELECT * FROM V_VERSION_ESQUEMA;                      -- 59
   ---------------------------------------------------------------------------- */
