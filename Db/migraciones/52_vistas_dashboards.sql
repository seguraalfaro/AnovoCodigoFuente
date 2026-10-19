/* ============================================================================
   Anovo - Migracion 52: vistas de los dashboards del escritorio
   ----------------------------------------------------------------------------
   Los dashboards del asesor, el asistente y el supervisor dejan de repetir una
   lista y muestran como va el trabajo y que necesita atencion (18/10/2026).
   Los conteos y los dias salen calculados de estas vistas; el backend solo
   las lee y las pasa a los DTO.

   - V_DASH_ESTADO_ASESOR: solicitudes del asesor por estado, con o sin
     cotizacion, y los dias de la mas antigua.
   - V_DASH_SOLICITUDES_MES: solicitudes del asesor por mes de captura.
   - V_DASH_ENVIADAS: cotizaciones enviadas que esperan respuesta, con los
     dias desde el envio y el plazo de la empresa.
   - V_DASH_EN_CURSO: cotizaciones en borrador, revision, devueltas o con
     visto bueno, con los dias en ese estado.
   - V_DASH_ETAPAS: cotizaciones por persona que las tomo y estado.
   - V_DASH_CARGA: cotizaciones en curso por persona.
   - V_DASH_PASOS_MES y V_DASH_PASOS_EQUIPO: pasos del flujo por mes, por
     persona y del equipo (presentadas, visto bueno, devueltas, aprobadas,
     rechazadas y monto aprobado).

   No crea tablas ni toca datos. Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 52: vistas de los dashboards') FROM RDB$DATABASE;

CREATE VIEW V_DASH_ESTADO_ASESOR AS
SELECT ASESOR_ID, ESTADO, (COTIZACION_ID IS NOT NULL) AS CON_COTIZACION,
       CAST(COUNT(*) AS INTEGER) AS CANTIDAD,
       CAST(COALESCE(MAX(DATEDIFF(DAY FROM CAST(FECHA_CAPTURA AS DATE)
         TO CURRENT_DATE)), 0) AS INTEGER) AS DIAS_MAS_ANTIGUA
  FROM V_SEGUIMIENTO_ASESOR
 GROUP BY 1, 2, 3;

CREATE VIEW V_DASH_SOLICITUDES_MES AS
SELECT ASESOR_ID,
       CAST(EXTRACT(YEAR FROM FECHA_CAPTURA) AS INTEGER) AS ANIO,
       CAST(EXTRACT(MONTH FROM FECHA_CAPTURA) AS INTEGER) AS MES,
       CAST(COUNT(*) AS INTEGER) AS CANTIDAD
  FROM V_SEGUIMIENTO_ASESOR
 GROUP BY 1, 2, 3;

CREATE VIEW V_DASH_ENVIADAS AS
SELECT ID AS COTIZACION_ID, NUMERO, CLIENTE_NOMBRE, ASESOR_ID, ELABORADA_POR,
       FECHA_ENVIO, DIAS_SIN_RESPUESTA,
       CAST(DATEDIFF(DAY FROM CAST(FECHA_ENVIO AS DATE) TO CURRENT_DATE)
         AS INTEGER) AS DIAS
  FROM V_CLIENTES_RESPUESTA
 WHERE ESTADO = 'enviada';

CREATE VIEW V_DASH_EN_CURSO AS
SELECT ID AS COTIZACION_ID, NUMERO, CLIENTE_NOMBRE, ESTADO, ELABORADA_POR,
       ELABORADA_POR_NOMBRE, MOTIVO_RECHAZO, FECHA_MODIFICACION,
       CAST(COALESCE(DIAS_EN_ESTADO, 0) AS INTEGER) AS DIAS
  FROM V_COTIZACIONES
 WHERE ESTADO IN ('borrador', 'pendiente', 'devuelta', 'visto_bueno');

CREATE VIEW V_DASH_ETAPAS AS
SELECT ELABORADA_POR, ESTADO, CAST(COUNT(*) AS INTEGER) AS CANTIDAD
  FROM COTIZACIONES
 WHERE ESTADO IN ('borrador', 'pendiente', 'devuelta', 'visto_bueno',
                  'enviada')
 GROUP BY 1, 2;

CREATE VIEW V_DASH_CARGA AS
SELECT ELABORADA_POR, ELABORADA_POR_NOMBRE, CAST(COUNT(*) AS INTEGER) AS CANTIDAD
  FROM V_DASH_EN_CURSO
 GROUP BY 1, 2;

CREATE VIEW V_DASH_PASOS_MES AS
SELECT ELABORADA_POR, ANIO, MES,
       CAST(SUM(CASE WHEN ESTADO = 'pendiente' THEN CANTIDAD ELSE 0 END)
            AS INTEGER) AS PRESENTADAS,
       CAST(SUM(CASE WHEN ESTADO = 'visto_bueno' THEN CANTIDAD ELSE 0 END)
            AS INTEGER) AS VISTO_BUENO,
       CAST(SUM(CASE WHEN ESTADO = 'devuelta' THEN CANTIDAD ELSE 0 END)
            AS INTEGER) AS DEVUELTAS,
       CAST(SUM(APROBADAS) AS INTEGER) AS APROBADAS,
       CAST(SUM(RECHAZADAS) AS INTEGER) AS RECHAZADAS,
       CAST(COALESCE(SUM(MONTO_APROBADO), 0) AS NUMERIC(18,2)) AS MONTO_APROBADO
  FROM V_COTIZACIONES_DIA
 GROUP BY 1, 2, 3;

CREATE VIEW V_DASH_PASOS_EQUIPO AS
SELECT ANIO, MES,
       CAST(SUM(PRESENTADAS) AS INTEGER) AS PRESENTADAS,
       CAST(SUM(VISTO_BUENO) AS INTEGER) AS VISTO_BUENO,
       CAST(SUM(DEVUELTAS) AS INTEGER) AS DEVUELTAS,
       CAST(SUM(APROBADAS) AS INTEGER) AS APROBADAS,
       CAST(SUM(RECHAZADAS) AS INTEGER) AS RECHAZADAS,
       CAST(COALESCE(SUM(MONTO_APROBADO), 0) AS NUMERIC(18,2)) AS MONTO_APROBADO
  FROM V_DASH_PASOS_MES
 GROUP BY 1, 2;

GRANT SELECT ON V_DASH_ESTADO_ASESOR TO ROL_BACKEND;
GRANT SELECT ON V_DASH_SOLICITUDES_MES TO ROL_BACKEND;
GRANT SELECT ON V_DASH_ENVIADAS TO ROL_BACKEND;
GRANT SELECT ON V_DASH_EN_CURSO TO ROL_BACKEND;
GRANT SELECT ON V_DASH_ETAPAS TO ROL_BACKEND;
GRANT SELECT ON V_DASH_CARGA TO ROL_BACKEND;
GRANT SELECT ON V_DASH_PASOS_MES TO ROL_BACKEND;
GRANT SELECT ON V_DASH_PASOS_EQUIPO TO ROL_BACKEND;

COMMENT ON VIEW V_DASH_ESTADO_ASESOR IS
  'Solicitudes del asesor por estado, para el dashboard del asesor.';
COMMENT ON VIEW V_DASH_SOLICITUDES_MES IS
  'Solicitudes del asesor por mes de captura.';
COMMENT ON VIEW V_DASH_ENVIADAS IS
  'Cotizaciones enviadas que esperan respuesta del cliente, con sus dias.';
COMMENT ON VIEW V_DASH_EN_CURSO IS
  'Cotizaciones en curso con los dias en su estado.';
COMMENT ON VIEW V_DASH_ETAPAS IS
  'Cotizaciones por persona que las tomo y estado.';
COMMENT ON VIEW V_DASH_CARGA IS
  'Cotizaciones en curso por persona.';
COMMENT ON VIEW V_DASH_PASOS_MES IS
  'Pasos del flujo por persona y mes.';
COMMENT ON VIEW V_DASH_PASOS_EQUIPO IS
  'Pasos del flujo del equipo por mes.';

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (52, '52_vistas_dashboards');

COMMIT;

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT COUNT(*) FROM RDB$RELATIONS
      WHERE RDB$RELATION_NAME STARTING WITH 'V_DASH_';               -- 8
     SELECT SUM(CANTIDAD) FROM V_DASH_SOLICITUDES_MES;   -- = solicitudes de asesores
     SELECT COUNT(*) FROM V_DASH_PASOS_EQUIPO;           -- meses con movimiento
     SELECT * FROM V_VERSION_ESQUEMA;                                -- 52
   ---------------------------------------------------------------------------- */
