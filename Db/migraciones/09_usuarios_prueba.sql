/* ============================================================================
   09_usuarios_prueba.sql
   Firebird 4.0 - base ANOVO
   18 de septiembre de 2026

   Tres usuarios de prueba para los casos que los cinco del 02 no cubren:

     asesor2      segundo asesor: un asesor no ve lo del otro
     provisional  clave provisional: token clave_vencida, sin permisos
     inactivo     cuenta inactiva: el login lo rechaza igual que una clave mala

   Datos de prueba, no van en produccion.

   La clave se copia del hash de asesor@anovo.test en vez de escribirlo aqui:
   la carpeta esta en git. En una base reconstruida desde cero ese hash todavia
   es el marcador del 02, y estos tres tampoco entran hasta regenerarlo.

   USUARIOS y USUARIOS_CLAVES estan auditadas: el script se identifica como el
   admin de prueba para que los disparadores no lo rechacen.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'admin@anovo.test'))
  FROM RDB$DATABASE;

INSERT INTO USUARIOS (CORREO, NOMBRE, ROL_ID, ACTIVO, DEBE_CAMBIAR_CLAVE)
  VALUES ('asesor2@anovo.test',     'Bruno Asesor',      1, TRUE,  FALSE);
INSERT INTO USUARIOS (CORREO, NOMBRE, ROL_ID, ACTIVO, DEBE_CAMBIAR_CLAVE)
  VALUES ('provisional@anovo.test', 'Pablo Provisional', 2, TRUE,  TRUE);
INSERT INTO USUARIOS (CORREO, NOMBRE, ROL_ID, ACTIVO, DEBE_CAMBIAR_CLAVE)
  VALUES ('inactivo@anovo.test',    'Ines Inactiva',     1, FALSE, FALSE);

INSERT INTO USUARIOS_CLAVES (USUARIO_ID, CLAVE_HASH, ACTIVO)
  SELECT U.ID, C.CLAVE_HASH, TRUE
    FROM USUARIOS U
    CROSS JOIN USUARIOS_CLAVES C
   WHERE U.CORREO IN ('asesor2@anovo.test', 'provisional@anovo.test',
                      'inactivo@anovo.test')
     AND C.ACTIVO = TRUE
     AND C.USUARIO_ID = (SELECT ID FROM USUARIOS
                          WHERE CORREO = 'asesor@anovo.test');

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;
