/* ============================================================================
   Anovo - Migracion 58: cifras del tablero del asesor coherentes
   ----------------------------------------------------------------------------
   Al capturar el manual (20/10/2026) el tablero del asesor decia
   "Esperando cotizacion 5" mientras "Como van mis solicitudes" mostraba 2,
   y "Aprobadas del mes 0" junto a "Tasa 100 %".

   - V_ASESORES_MES.ESPERANDO_COTIZACION: sale del grupo 'esperando' de
     V_DASH_ASESOR_GRUPOS (solicitudes sin cotizacion), el mismo de la lista.
     Antes sumaba tambien las que estaban en elaboracion.
   - V_DASH_ASESOR_RESUMEN.TASA_APROBACION: aprobadas / (aprobadas +
     rechazadas) del mes, por la fecha del cambio de estado, igual que
     APROBADAS_MES. Antes se calculaba sobre todo el historial.

   Mismas columnas y tipos: no cambia el contrato ni las entidades.
   No crea tablas ni toca datos. Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 58: tablero del asesor coherente') FROM RDB$DATABASE;

CREATE OR ALTER VIEW V_ASESORES_MES AS
SELECT U.ID AS ASESOR_ID, U.NOMBRE AS ASESOR_NOMBRE, U.ACTIVO,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM VT_SOLICITUDES S
         WHERE S.ASESOR_ID = U.ID
           AND S.FECHA_CAPTURA >= P.MES_DESDE
           AND S.FECHA_CAPTURA < P.MES_HASTA)
         AS SOLICITUDES_MES,
       (SELECT CAST(COALESCE(SUM(G.CANTIDAD), 0) AS INTEGER)
          FROM V_DASH_ASESOR_GRUPOS G
         WHERE G.ASESOR_ID = U.ID AND G.GRUPO = 'esperando')
         AS ESPERANDO_COTIZACION,
       (SELECT CAST(COUNT(*) AS INTEGER)
          FROM VT_COTIZACION_ESTADOS H JOIN V_COTIZACIONES C ON C.ID = H.COTIZACION_ID
         WHERE C.ASESOR_ID = U.ID AND H.ESTADO = 'aprobada'
           AND H.FECHA >= P.MES_DESDE AND H.FECHA < P.MES_HASTA)
         AS APROBADAS_MES,
       (SELECT CAST(COALESCE(SUM(C.MONTO_TOTAL), 0) AS NUMERIC(18,2))
          FROM VT_COTIZACION_ESTADOS H JOIN V_COTIZACIONES C ON C.ID = H.COTIZACION_ID
         WHERE C.ASESOR_ID = U.ID AND H.ESTADO = 'aprobada'
           AND H.FECHA >= P.MES_DESDE AND H.FECHA < P.MES_HASTA)
         AS MONTO_APROBADO_MES
  FROM USUARIOS U
  JOIN ROLES R ON R.ID = U.ROL_ID
  CROSS JOIN V_PERIODO_ACTUAL P
 WHERE R.CODIGO = 'asesor';

CREATE OR ALTER VIEW V_DASH_ASESOR_RESUMEN AS
SELECT R.ASESOR_ID, R.DIAS_MAS_ANTIGUA,
       CAST(COALESCE(R.APROBADAS_MES * 100.0000
            / NULLIF(R.APROBADAS_MES + R.RECHAZADAS_MES, 0), 0)
            AS NUMERIC(5,2)) AS TASA_APROBACION,
       R.SOLICITUDES_MES_ANTERIOR,
       CAST(R.SOLICITUDES_ACTUAL - R.SOLICITUDES_MES_ANTERIOR AS INTEGER)
         AS VARIACION_SOLICITUDES,
       R.MONTO_APROBADO_ANTERIOR,
       CASE WHEN R.MONTO_APROBADO_ANTERIOR > 0
            THEN CAST((R.MONTO_ACTUAL - R.MONTO_APROBADO_ANTERIOR) * 100.0000
                 / R.MONTO_APROBADO_ANTERIOR AS NUMERIC(7,2)) END
         AS VARIACION_MONTO,
       R.MES_ANTERIOR
  FROM (SELECT G.ASESOR_ID, P.MES_ANTERIOR,
               CAST(COALESCE(MAX(CASE WHEN G.GRUPO = 'esperando'
                    THEN G.DIAS_MAS_ANTIGUA END), 0) AS INTEGER)
                 AS DIAS_MAS_ANTIGUA,
               (SELECT CAST(COUNT(*) AS INTEGER)
                  FROM VT_COTIZACION_ESTADOS H
                  JOIN V_COTIZACIONES C ON C.ID = H.COTIZACION_ID
                 WHERE C.ASESOR_ID = G.ASESOR_ID AND H.ESTADO = 'aprobada'
                   AND H.FECHA >= P.MES_DESDE AND H.FECHA < P.MES_HASTA)
                 AS APROBADAS_MES,
               (SELECT CAST(COUNT(*) AS INTEGER)
                  FROM VT_COTIZACION_ESTADOS H
                  JOIN V_COTIZACIONES C ON C.ID = H.COTIZACION_ID
                 WHERE C.ASESOR_ID = G.ASESOR_ID AND H.ESTADO = 'rechazada'
                   AND H.FECHA >= P.MES_DESDE AND H.FECHA < P.MES_HASTA)
                 AS RECHAZADAS_MES,
               (SELECT CAST(COUNT(*) AS INTEGER) FROM VT_SOLICITUDES S
                 WHERE S.ASESOR_ID = G.ASESOR_ID
                   AND S.FECHA_CAPTURA >= P.MES_DESDE
                   AND S.FECHA_CAPTURA < P.MES_HASTA) AS SOLICITUDES_ACTUAL,
               (SELECT CAST(COUNT(*) AS INTEGER) FROM VT_SOLICITUDES S
                 WHERE S.ASESOR_ID = G.ASESOR_ID
                   AND S.FECHA_CAPTURA >= P.MES_ANTERIOR
                   AND S.FECHA_CAPTURA < P.MES_DESDE)
                 AS SOLICITUDES_MES_ANTERIOR,
               (SELECT CAST(COALESCE(SUM(C.MONTO_TOTAL), 0) AS NUMERIC(18,2))
                  FROM VT_COTIZACION_ESTADOS H
                  JOIN V_COTIZACIONES C ON C.ID = H.COTIZACION_ID
                 WHERE C.ASESOR_ID = G.ASESOR_ID AND H.ESTADO = 'aprobada'
                   AND H.FECHA >= P.MES_DESDE AND H.FECHA < P.MES_HASTA)
                 AS MONTO_ACTUAL,
               (SELECT CAST(COALESCE(SUM(C.MONTO_TOTAL), 0) AS NUMERIC(18,2))
                  FROM VT_COTIZACION_ESTADOS H
                  JOIN V_COTIZACIONES C ON C.ID = H.COTIZACION_ID
                 WHERE C.ASESOR_ID = G.ASESOR_ID AND H.ESTADO = 'aprobada'
                   AND H.FECHA >= P.MES_ANTERIOR AND H.FECHA < P.MES_DESDE)
                 AS MONTO_APROBADO_ANTERIOR
          FROM V_DASH_ASESOR_GRUPOS G
         CROSS JOIN V_PERIODO_ACTUAL P
         GROUP BY G.ASESOR_ID, P.MES_DESDE, P.MES_HASTA, P.MES_ANTERIOR) R;

GRANT SELECT ON V_ASESORES_MES TO ROL_BACKEND;
GRANT SELECT ON V_DASH_ASESOR_RESUMEN TO ROL_BACKEND;

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (58, '58_tablero_asesor_coherente');

COMMIT;

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT M.ASESOR_ID, M.ESPERANDO_COTIZACION, G.CANTIDAD
       FROM V_ASESORES_MES M
       LEFT JOIN V_DASH_ASESOR_GRUPOS G
         ON G.ASESOR_ID = M.ASESOR_ID AND G.GRUPO = 'esperando';  -- iguales
     SELECT ASESOR_ID, TASA_APROBACION FROM V_DASH_ASESOR_RESUMEN;  -- del mes
     SELECT * FROM V_VERSION_ESQUEMA;                                -- 58
   ---------------------------------------------------------------------------- */
