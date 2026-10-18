/* ============================================================================
   claves_prueba.sql
   Firebird 4.0 - base ANOVO
   23 de septiembre de 2026

   Le pone la misma clave a los ocho usuarios de prueba:

       Anovo2026

   POR QUE ESTE ARCHIVO EXISTE

   Los scripts de esquema y las migraciones dejan CLAVE_HASH en el marcador
   'PENDIENTE-REGENERAR' a proposito: la carpeta esta en git y una clave real
   no viaja en el repositorio. El efecto es que una base reconstruida desde
   cero queda completa y correcta, y sin que nadie pueda entrar.

   Esto lo cierra, y por eso vive en datos-prueba y no en migraciones: es un
   dato de prueba, del mismo tipo que carga_demo.sql.

   NO VA EN PRODUCCION. La clave esta escrita arriba y los hashes estan en el
   repositorio: quien tenga el repositorio entra a cualquier base sembrada con
   esto. En el servidor de Anovo las claves se asignan una por una y se
   cambian en el primer ingreso.

   Los hashes son bcrypt con costo 12, el mismo que usa Anovo.Services.Clave,
   y cada uno lleva su propia sal: dos usuarios con la misma clave no tienen
   el mismo hash, que es como debe ser.

   USUARIOS_CLAVES esta auditada: el script se identifica como el admin de
   prueba para que los disparadores no lo rechacen.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'admin@anovo.test'))
  FROM RDB$DATABASE;

UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$Xk8AFdFutuf.tK/6w/M0mOS/IqRXUDVzB7Ptt9J9ZCI04cZ/yK87.'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'admin@anovo.test');
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$g7OkBNvTOMUBuuPAVhKSje8hVYabbRCSlZr5ONEkpz40.H.cf3dd.'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'asesor@anovo.test');
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$wFMO7Wp2XRBi.u34PO9A/OSZMfYSTjQ/LHa0HAgz/b/J5iX27Lw9i'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'asesor2@anovo.test');
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$IlEyPBDnz9G42...xDkvluI/o0raOYoDFgNBxNpXP/3CvjuUKqSd.'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'asistente@anovo.test');
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$kvRpi8veER.Hm3KM.FqoIOOhG4WA0dMUNga6Q/s0m/Euy7dUbgrOG'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'gerencia@anovo.test');
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$EGmm5JkByIf53ayPcDcvMOVBMLaS/n2XAnEAiWbqdHVYjZtOgywA2'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'inactivo@anovo.test');
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$Y9b74Lf1wOfRsz8/t5S6J.Xi8KT.t4WesDWeh3Fla1Z1VgJsKlMOK'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'provisional@anovo.test');
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$Od2z1HpmH23wPBGPFbT75.wU.5rNg.UhjnQmyS3uqGSrMVKQEF9My'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'supervisor@anovo.test');

/* Cuentas que suma carga_completa.sql (18/10/2026). */
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$6gnW2Wg6unG3GpT9kFqhZ.rFp88GogyF.Qw6MY5abqXBKAWUZdb3u'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'asesor3@anovo.test');
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$aRh6blC0vyJhCFyn73B/Y.T2KQVeUvBFNp9BgjOIaaAvIVsnIe9u2'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'asesor4@anovo.test');
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$46qtwjO3NFkfxzLqhnP/Hel5oVv8x8ZrZT0IDkaph7lCVQmSeBtXK'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'asesor5@anovo.test');
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$pXZGQQga51X8QpZOrDRhVuQzCjdqQED5ke7azB1hmnT/nCFU.S6pq'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'asistente2@anovo.test');
UPDATE USUARIOS_CLAVES SET CLAVE_HASH = '$2b$12$OPg4smtYz4GQlQT3atU8Yeu75leIhvBf.fV5s88OqpdpamkbDG5mK'
  WHERE ACTIVO = TRUE
    AND USUARIO_ID = (SELECT ID FROM USUARIOS WHERE CORREO = 'supervisor2@anovo.test');

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* Comprobacion: los ocho tienen que salir con $2b$12$ y ninguno con
   PENDIENTE-REGENERAR. */
SELECT U.CORREO, SUBSTRING(C.CLAVE_HASH FROM 1 FOR 7) AS INICIO
  FROM USUARIOS U
  JOIN USUARIOS_CLAVES C ON C.USUARIO_ID = U.ID AND C.ACTIVO = TRUE
 ORDER BY U.CORREO;
