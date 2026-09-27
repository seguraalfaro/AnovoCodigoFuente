/* ============================================================================
   Anovo - Migracion 17: gerencia vuelve a elaborar cotizaciones
   ----------------------------------------------------------------------------
   Revierte la 16. La minuta 07/2026 (tema 2), firmada por el patrocinador,
   dice que gerencia elabora y modifica cotizaciones; la 16 se lo habia
   quitado sin un acuerdo nuevo que la respalde. Mientras no haya una minuta
   que cambie esa matriz, manda la firmada.

   La 16 no se edita ni se borra porque ya se aplico: los scripts son
   acumulativos y un cambio es un script nuevo.

   Despues de aplicarla, invalidar la cache de permisos desde la ventana del
   servidor o reiniciarlo.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT MIN(ID) FROM USUARIOS WHERE ROL_ID = 5 AND ACTIVO = TRUE))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'Gerencia elabora cotizaciones segun la minuta 07/2026')
  FROM RDB$DATABASE;

INSERT INTO ROLES_PERMISOS (ROL_ID, PERMISO_ID, AMBITO)
  SELECT R.ID, P.ID, 'negocio'
    FROM ROLES R, PERMISOS P
   WHERE R.CODIGO = 'gerencia'
     AND P.CODIGO = 'cotizaciones.elaborar'
     AND NOT EXISTS (SELECT 1 FROM ROLES_PERMISOS RP
                      WHERE RP.ROL_ID = R.ID AND RP.PERMISO_ID = P.ID);

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* ----------------------------------------------------------------------------
   COMPROBACION

     SELECT R.CODIGO FROM ROLES_PERMISOS RP
       JOIN ROLES R ON R.ID = RP.ROL_ID
       JOIN PERMISOS P ON P.ID = RP.PERMISO_ID
      WHERE P.CODIGO = 'cotizaciones.elaborar';

   Tienen que salir asistente, supervisor y gerencia.
   ---------------------------------------------------------------------------- */
