/* ============================================================================
   Anovo - Migracion 54: totales de la cotizacion y datos cruzados en vistas
   ----------------------------------------------------------------------------
   Lo que el backend todavia calculaba o armaba por su cuenta pasa a la base
   (19/10/2026):

   - V_COTIZACION_LINEAS: subtotal de cada linea (cantidad por precio).
   - V_COTIZACION_TOTALES: subtotales por tipo, costo, ajuste, IVA y total.
     El servicio los lee y los guarda; no hay disparador porque es regla de
     negocio. Los pasos intermedios van con 4 decimales y lo guardado con 2,
     como hacia el servicio con Currency.
   - V_COTIZACIONES_LISTADO: la cotizacion completa con los nombres y el monto
     del ajuste, en una sola fila. Reemplaza las dos consultas que se juntaban
     en el servicio (listado, detalle de reportes y una cotizacion).
   - V_COTIZACIONES_SIN_RESPUESTA: enviadas que pasaron el plazo de la empresa.
   - V_CONTACTOS_BAJADA: contactos con el uuid y el estado de su cliente, para
     la bajada al movil sin cruzarlos en el servicio.
   - V_PERIODO_ACTUAL: suma la semana en curso (de lunes a lunes).

   La auditoria ya trae el nombre del usuario en V_AUDITORIA.

   No crea tablas ni toca datos. Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 54: totales y datos cruzados en vistas') FROM RDB$DATABASE;

CREATE VIEW V_COTIZACION_LINEAS AS
SELECT ID, COTIZACION_ID, TIPO,
       CAST(CANTIDAD * PRECIO_UNITARIO AS NUMERIC(15,2)) AS SUBTOTAL
  FROM COTIZACION_DETALLE
 WHERE ACTIVO = TRUE;

CREATE VIEW V_COTIZACION_TOTALES AS
SELECT S.COTIZACION_ID, S.SUBTOTAL_MATERIALES, S.SUBTOTAL_MANO_OBRA,
       S.SUBTOTAL_MAQUINA, S.COSTO_TOTAL,
       CAST(S.COSTO_TOTAL * S.PORCENTAJE_AJUSTE / 100 AS NUMERIC(18,2))
         AS MONTO_AJUSTE,
       CAST(CAST((S.COSTO_TOTAL + S.COSTO_TOTAL * S.PORCENTAJE_AJUSTE / 100)
            AS NUMERIC(18,4)) * S.PORCENTAJE_IVA / 100 AS NUMERIC(18,2))
         AS MONTO_IMPUESTO,
       CAST(CAST((S.COSTO_TOTAL + S.COSTO_TOTAL * S.PORCENTAJE_AJUSTE / 100)
            AS NUMERIC(18,4))
          + CAST(CAST((S.COSTO_TOTAL + S.COSTO_TOTAL * S.PORCENTAJE_AJUSTE / 100)
            AS NUMERIC(18,4)) * S.PORCENTAJE_IVA / 100 AS NUMERIC(18,4))
            AS NUMERIC(18,2)) AS MONTO_TOTAL
  FROM (SELECT K.ID AS COTIZACION_ID, K.PORCENTAJE_AJUSTE, K.PORCENTAJE_IVA,
               CAST(COALESCE(SUM(CASE WHEN L.TIPO = 'material'
                    THEN L.SUBTOTAL END), 0) AS NUMERIC(18,2))
                 AS SUBTOTAL_MATERIALES,
               CAST(COALESCE(SUM(CASE WHEN L.TIPO = 'mano_obra'
                    THEN L.SUBTOTAL END), 0) AS NUMERIC(18,2))
                 AS SUBTOTAL_MANO_OBRA,
               CAST(COALESCE(SUM(CASE WHEN L.TIPO = 'maquina'
                    THEN L.SUBTOTAL END), 0) AS NUMERIC(18,2))
                 AS SUBTOTAL_MAQUINA,
               CAST(COALESCE(SUM(CASE WHEN L.TIPO IN ('material', 'mano_obra',
                    'maquina') THEN L.SUBTOTAL END), 0) AS NUMERIC(18,2))
                 AS COSTO_TOTAL
          FROM COTIZACIONES K
          LEFT JOIN V_COTIZACION_LINEAS L ON L.COTIZACION_ID = K.ID
         GROUP BY K.ID, K.PORCENTAJE_AJUSTE, K.PORCENTAJE_IVA) S;

CREATE VIEW V_COTIZACIONES_LISTADO AS
SELECT K.*,
       V.FECHA_RECEPCION, V.CLIENTE_NOMBRE, V.ASESOR_ID, V.ASESOR_NOMBRE,
       V.ELABORADA_POR_NOMBRE, V.APROBADA_POR_NOMBRE, V.TIPO_TRABAJO_NOMBRE,
       V.DEVUELTA, V.DIAS_EN_ESTADO, V.DIAS_RESPUESTA,
       CAST(K.COSTO_TOTAL * K.PORCENTAJE_AJUSTE / 100 AS NUMERIC(18,2))
         AS MONTO_AJUSTE
  FROM COTIZACIONES K
  JOIN V_COTIZACIONES V ON V.ID = K.ID;

CREATE VIEW V_COTIZACIONES_SIN_RESPUESTA AS
SELECT L.*
  FROM V_COTIZACIONES_LISTADO L
 CROSS JOIN (SELECT COALESCE(MAX(E.DIAS_SIN_RESPUESTA), 7) AS DIAS
               FROM EMPRESA E) P
 WHERE L.ESTADO = 'enviada'
   AND L.FECHA_ENVIO < DATEADD(-P.DIAS DAY TO CURRENT_TIMESTAMP);

CREATE VIEW V_CONTACTOS_BAJADA AS
SELECT CC.*, C.UUID_LOCAL AS CLIENTE_UUID, C.ACTIVO AS CLIENTE_ACTIVO
  FROM CLIENTE_CONTACTOS CC
  JOIN CLIENTES C ON C.ID = CC.CLIENTE_ID;

CREATE OR ALTER VIEW V_PERIODO_ACTUAL AS
SELECT CAST(DATEADD(1 - EXTRACT(DAY FROM CURRENT_DATE) DAY TO CURRENT_DATE)
            AS TIMESTAMP) AS MES_DESDE,
       CAST(DATEADD(1 MONTH TO DATEADD(1 - EXTRACT(DAY FROM CURRENT_DATE)
            DAY TO CURRENT_DATE)) AS TIMESTAMP) AS MES_HASTA,
       CAST(DATEADD(-MOD(EXTRACT(WEEKDAY FROM CURRENT_DATE) + 6, 7) DAY
            TO CURRENT_DATE) AS TIMESTAMP) AS SEMANA_DESDE,
       CAST(DATEADD(7 - MOD(EXTRACT(WEEKDAY FROM CURRENT_DATE) + 6, 7) DAY
            TO CURRENT_DATE) AS TIMESTAMP) AS SEMANA_HASTA
  FROM RDB$DATABASE;

GRANT SELECT ON V_COTIZACION_LINEAS TO ROL_BACKEND;
GRANT SELECT ON V_COTIZACION_TOTALES TO ROL_BACKEND;
GRANT SELECT ON V_COTIZACIONES_LISTADO TO ROL_BACKEND;
GRANT SELECT ON V_COTIZACIONES_SIN_RESPUESTA TO ROL_BACKEND;
GRANT SELECT ON V_CONTACTOS_BAJADA TO ROL_BACKEND;
GRANT SELECT ON V_PERIODO_ACTUAL TO ROL_BACKEND;

COMMENT ON VIEW V_COTIZACION_LINEAS IS
  'Subtotal de cada linea activa: cantidad por precio unitario.';
COMMENT ON VIEW V_COTIZACION_TOTALES IS
  'Subtotales por tipo, costo, ajuste, IVA y total de cada cotizacion.';
COMMENT ON VIEW V_COTIZACIONES_LISTADO IS
  'Cotizacion completa con los nombres y el monto del ajuste.';
COMMENT ON VIEW V_COTIZACIONES_SIN_RESPUESTA IS
  'Enviadas que pasaron el plazo de respuesta de la empresa.';
COMMENT ON VIEW V_CONTACTOS_BAJADA IS
  'Contactos con el uuid y el estado de su cliente, para la bajada al movil.';

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (54, '54_datos_listos_en_vistas');

COMMIT;

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT COUNT(*) FROM COTIZACIONES K
       JOIN V_COTIZACION_TOTALES T ON T.COTIZACION_ID = K.ID
      WHERE T.MONTO_TOTAL <> K.MONTO_TOTAL;            -- 0: igual que lo guardado
     SELECT COUNT(*) FROM COTIZACION_DETALLE D
       JOIN V_COTIZACION_LINEAS L ON L.ID = D.ID
      WHERE L.SUBTOTAL <> D.SUBTOTAL;                   -- 0
     SELECT * FROM V_PERIODO_ACTUAL;                    -- mes y semana
     SELECT * FROM V_VERSION_ESQUEMA;                                -- 54
   ---------------------------------------------------------------------------- */
