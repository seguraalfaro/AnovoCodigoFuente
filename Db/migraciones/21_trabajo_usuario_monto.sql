/* ============================================================================
   Anovo - Migracion 21: V_TRABAJO_USUARIO con el monto por aprobar
   ----------------------------------------------------------------------------
   La bandeja del supervisor muestra tres cifras: pendientes, dias de la mas
   antigua y monto en espera. La vista de la 20 traia las dos primeras; se
   rehace con MONTO_POR_APROBAR para que el resumen de la bandeja salga de la
   vista y no de una consulta en el backend. CREATE OR ALTER conserva el GRANT.
   ============================================================================ */

CREATE OR ALTER VIEW V_TRABAJO_USUARIO AS
SELECT U.ID AS USUARIO_ID,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM V_SOLICITUDES S
         WHERE S.ESTADO = 'recibida' AND S.TIENE_COTIZACION = FALSE)
         AS POR_COTIZAR,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM COTIZACIONES C
         WHERE C.ELABORADA_POR = U.ID AND C.ESTADO = 'borrador')
         AS MIS_BORRADORES,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM COTIZACIONES C
         WHERE C.ELABORADA_POR = U.ID AND C.ESTADO = 'pendiente')
         AS EN_APROBACION,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM COTIZACIONES C
         WHERE C.ELABORADA_POR = U.ID AND C.ESTADO = 'aprobada'
           AND C.FECHA_ENVIO IS NULL)
         AS POR_ENVIAR,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM COTIZACIONES C
         WHERE C.ESTADO = 'pendiente' AND C.ELABORADA_POR <> U.ID)
         AS POR_APROBAR,
       (SELECT CAST(COALESCE(MAX(C.DIAS_EN_ESTADO), 0) AS INTEGER)
          FROM V_COTIZACIONES C
         WHERE C.ESTADO = 'pendiente' AND C.ELABORADA_POR <> U.ID)
         AS DIAS_MAS_ANTIGUA,
       (SELECT CAST(COALESCE(SUM(C.MONTO_TOTAL), 0) AS NUMERIC(18,2))
          FROM COTIZACIONES C
         WHERE C.ESTADO = 'pendiente' AND C.ELABORADA_POR <> U.ID)
         AS MONTO_POR_APROBAR
  FROM USUARIOS U;

COMMIT;

/* ----------------------------------------------------------------------------
   COMPROBACION

     SELECT POR_APROBAR, DIAS_MAS_ANTIGUA, MONTO_POR_APROBAR
       FROM V_TRABAJO_USUARIO WHERE USUARIO_ID = 3;

   Igual al resumen de la bandeja del supervisor.
   ---------------------------------------------------------------------------- */
