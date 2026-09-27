/* ============================================================================
   Anovo - Migracion 16: gerencia revisa y aprueba, no elabora
   ----------------------------------------------------------------------------
   Gerencia tenia cotizaciones.elaborar desde la matriz inicial. Con la cola
   comun de solicitudes eso le permitia tomar solicitudes y crear cotizaciones,
   y Marcos definio el 27/09/2026 que gerencia solo revisa y aprueba: tomar de
   la cola es del asistente y del supervisor.

   Se quita el permiso en la base, no solo en el menu: el servidor evalua los
   permisos en cada peticion contra ROLES_PERMISOS, y un boton oculto no
   impide llamar a la API.

   ROLES_PERMISOS esta auditada: el script se identifica como el primer
   administrador activo, que es quien migra, como en la migracion 13.

   Despues de aplicarla, invalidar la cache de permisos desde la ventana del
   servidor o reiniciarlo.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT MIN(ID) FROM USUARIOS WHERE ROL_ID = 5 AND ACTIVO = TRUE))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'Gerencia revisa y aprueba cotizaciones; no las elabora')
  FROM RDB$DATABASE;

DELETE FROM ROLES_PERMISOS
 WHERE ROL_ID = (SELECT ID FROM ROLES WHERE CODIGO = 'gerencia')
   AND PERMISO_ID = (SELECT ID FROM PERMISOS
                      WHERE CODIGO = 'cotizaciones.elaborar');

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* ----------------------------------------------------------------------------
   COMPROBACION

     SELECT R.CODIGO, P.CODIGO
       FROM ROLES_PERMISOS RP
       JOIN ROLES R ON R.ID = RP.ROL_ID
       JOIN PERMISOS P ON P.ID = RP.PERMISO_ID
      WHERE P.CODIGO = 'cotizaciones.elaborar';

   Tienen que salir solo asistente y supervisor.
   ---------------------------------------------------------------------------- */
