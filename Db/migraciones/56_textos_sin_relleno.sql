/* ============================================================================
   Anovo - Migracion 56: textos de los dashboards sin espacios de relleno
   ----------------------------------------------------------------------------
   Un CASE con literales de distinto largo devuelve CHAR del largo mayor, y
   el CAST a VARCHAR conserva los espacios: 'alto ' y 'esperando    '. El
   escritorio compara con 'alto' y 'esperando', no coincide y pinta gris
   (19/10/2026). Se recortan con TRIM en las tres vistas que lo tenian.

   - V_DASH_ENVIADAS y V_DASH_EN_CURSO: NIVEL.
   - V_DASH_ASESOR_GRUPOS: GRUPO.

   No crea tablas ni toca datos. Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 56: textos de los dashboards sin relleno') FROM RDB$DATABASE;

CREATE OR ALTER VIEW V_DASH_ENVIADAS AS
SELECT ID AS COTIZACION_ID, NUMERO, CLIENTE_NOMBRE, ASESOR_ID, ELABORADA_POR,
       FECHA_ENVIO, DIAS_SIN_RESPUESTA,
       CAST(DATEDIFF(DAY FROM CAST(FECHA_ENVIO AS DATE) TO CURRENT_DATE)
         AS INTEGER) AS DIAS,
       CAST(TRIM(CASE
         WHEN DATEDIFF(DAY FROM CAST(FECHA_ENVIO AS DATE) TO CURRENT_DATE)
              >= COALESCE(DIAS_SIN_RESPUESTA, 0) * 1.5 THEN 'alto'
         WHEN DATEDIFF(DAY FROM CAST(FECHA_ENVIO AS DATE) TO CURRENT_DATE)
              >= COALESCE(DIAS_SIN_RESPUESTA, 0) THEN 'medio'
         ELSE 'bajo' END) AS VARCHAR(5)) AS NIVEL
  FROM V_CLIENTES_RESPUESTA
 WHERE ESTADO = 'enviada';

CREATE OR ALTER VIEW V_DASH_EN_CURSO AS
SELECT ID AS COTIZACION_ID, NUMERO, CLIENTE_NOMBRE, ESTADO, ELABORADA_POR,
       ELABORADA_POR_NOMBRE, MOTIVO_RECHAZO, FECHA_MODIFICACION,
       CAST(COALESCE(DIAS_EN_ESTADO, 0) AS INTEGER) AS DIAS,
       (COALESCE(DIAS_EN_ESTADO, 0) >= 5) AS ESTANCADA,
       CAST(TRIM(CASE WHEN COALESCE(DIAS_EN_ESTADO, 0) >= 8 THEN 'alto'
                      WHEN COALESCE(DIAS_EN_ESTADO, 0) >= 5 THEN 'medio'
                      ELSE 'bajo' END) AS VARCHAR(5)) AS NIVEL
  FROM V_COTIZACIONES
 WHERE ESTADO IN ('borrador', 'pendiente', 'devuelta', 'visto_bueno');

CREATE OR ALTER VIEW V_DASH_ASESOR_GRUPOS AS
SELECT ASESOR_ID, GRUPO,
       CAST(CASE GRUPO WHEN 'esperando' THEN 1 WHEN 'elaboracion' THEN 2
                       WHEN 'enviada' THEN 3 WHEN 'aprobada' THEN 4
                       WHEN 'rechazada' THEN 5 ELSE 6 END AS INTEGER) AS ORDEN,
       CAST(SUM(CANTIDAD) AS INTEGER) AS CANTIDAD,
       CAST(MAX(DIAS_MAS_ANTIGUA) AS INTEGER) AS DIAS_MAS_ANTIGUA
  FROM (SELECT ASESOR_ID, CANTIDAD, DIAS_MAS_ANTIGUA,
               CAST(TRIM(CASE
                 WHEN ESTADO = 'descartada' AND CON_COTIZACION
                   THEN 'sin_respuesta'
                 WHEN ESTADO IN ('borrador', 'pendiente', 'devuelta',
                                 'visto_bueno') THEN 'elaboracion'
                 WHEN ESTADO = 'enviada' THEN 'enviada'
                 WHEN ESTADO = 'aprobada' THEN 'aprobada'
                 WHEN ESTADO IN ('rechazada', 'descartada') THEN 'rechazada'
                 ELSE 'esperando' END) AS VARCHAR(15)) AS GRUPO
          FROM V_DASH_ESTADO_ASESOR)
 GROUP BY ASESOR_ID, GRUPO;

GRANT SELECT ON V_DASH_ENVIADAS TO ROL_BACKEND;
GRANT SELECT ON V_DASH_EN_CURSO TO ROL_BACKEND;
GRANT SELECT ON V_DASH_ASESOR_GRUPOS TO ROL_BACKEND;

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (56, '56_textos_sin_relleno');

COMMIT;

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT DISTINCT '|' || NIVEL || '|' FROM V_DASH_EN_CURSO;      -- sin espacios
     SELECT DISTINCT '|' || GRUPO || '|' FROM V_DASH_ASESOR_GRUPOS; -- sin espacios
     SELECT * FROM V_VERSION_ESQUEMA;                                -- 56
   ---------------------------------------------------------------------------- */
