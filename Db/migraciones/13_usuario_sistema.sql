/* ============================================================================
   Anovo - Migracion 13: usuario Sistema, para lo que escribe el servidor solo
   ----------------------------------------------------------------------------
   Los disparadores de auditoria exigen usuario en contexto y tumban la
   escritura con E_AUDITORIA_SIN_USUARIO si no lo hay. Eso funciona porque toda
   escritura venia de una peticion con token.

   La rutina de vigencia de precios rompe ese supuesto: corre en el servidor,
   al arrancar y cada hora, sin nadie que la haya pedido. Necesita un usuario
   que ponerse, y no puede ser uno real: la auditoria diria que una persona
   cambio el precio cuando no lo hizo.

   Este usuario existe solo para aparecer en AUDITORIA. No puede entrar:

     - ACTIVO = FALSE, que el login rechaza antes de mirar la clave;
     - sin fila en USUARIOS_CLAVES, que el login vuelve a rechazar.

   Son dos barreras independientes. Si alguien lo reactivara por error, sigue
   sin clave con la cual entrar.

   El rol es el de administrador porque la columna es obligatoria y hay que
   poner alguno. No le concede nada: los permisos se revisan por peticion y
   este usuario no tiene peticiones.

   No lleva ID fijo. El servidor lo busca por correo al arrancar, asi que la
   identidad puede asignarlo como a cualquier otro.

   USUARIOS esta auditada, asi que el script se identifica como el primer
   administrador activo de la base, que es quien la esta migrando.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT MIN(ID) FROM USUARIOS WHERE ROL_ID = 5 AND ACTIVO = TRUE))
  FROM RDB$DATABASE;

INSERT INTO USUARIOS (CORREO, NOMBRE, ROL_ID, ACTIVO, DEBE_CAMBIAR_CLAVE)
  SELECT 'sistema@anovo.local', 'Sistema', 5, FALSE, FALSE
    FROM RDB$DATABASE
   WHERE NOT EXISTS (SELECT 1 FROM USUARIOS
                      WHERE CORREO = 'sistema@anovo.local');

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* ----------------------------------------------------------------------------
   COMPROBACION

     SELECT U.ID, U.CORREO, U.ACTIVO,
            (SELECT COUNT(*) FROM USUARIOS_CLAVES C WHERE C.USUARIO_ID = U.ID)
       FROM USUARIOS U
      WHERE U.CORREO = 'sistema@anovo.local';

   Tiene que salir ACTIVO en <false> y la cuenta de claves en 0.
   ---------------------------------------------------------------------------- */
