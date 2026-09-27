/* ============================================================================
   Anovo - Migracion 20: vistas de totales
   ----------------------------------------------------------------------------
   Los totales de los dashboards y de los reportes estaban escritos como
   consultas en el backend. Pasan a vistas: los dashboards siempre muestran el
   mes en curso, asi que sus vistas lo toman de V_PERIODO_ACTUAL y no reciben
   fechas; el backend solo filtra por usuario. Los reportes usan un rango libre:
   V_COTIZACIONES_DIA las agrupa por dia y el servicio suma el rango.

   Igual que la 18: sin parametros y sin reglas de negocio. La tasa de
   aprobacion la calcula el servicio.

   Todo en ASCII.
   ============================================================================ */

/* ----------------------------------------------------------------------------
   1. V_PERIODO_ACTUAL: el mes en curso, escrito una sola vez. MES_HASTA es el
   primer dia del mes siguiente: los filtros usan >= desde y < hasta.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_PERIODO_ACTUAL AS
SELECT CAST(DATEADD(1 - EXTRACT(DAY FROM CURRENT_DATE) DAY TO CURRENT_DATE)
            AS TIMESTAMP) AS MES_DESDE,
       CAST(DATEADD(1 MONTH TO DATEADD(1 - EXTRACT(DAY FROM CURRENT_DATE)
            DAY TO CURRENT_DATE)) AS TIMESTAMP) AS MES_HASTA
  FROM RDB$DATABASE;

/* ----------------------------------------------------------------------------
   2. V_TRABAJO_USUARIO: lo que cada usuario tiene en la mesa. POR_COTIZAR es
   la cola comun, igual para todos. POR_APROBAR y DIAS_MAS_ANTIGUA cuentan las
   pendientes que el usuario no elaboro: nadie revisa lo propio.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_TRABAJO_USUARIO AS
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
         AS DIAS_MAS_ANTIGUA
  FROM USUARIOS U;

/* ----------------------------------------------------------------------------
   3. V_RESUMEN_MES: el mes de toda la empresa. Rechazadas por
   FECHA_MODIFICACION: no hay fecha propia de rechazo.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_RESUMEN_MES AS
SELECT P.MES_DESDE AS DESDE, P.MES_HASTA AS HASTA,
       (SELECT CAST(COALESCE(SUM(C.MONTO_TOTAL), 0) AS NUMERIC(18,2))
          FROM COTIZACIONES C
         WHERE C.ESTADO <> 'borrador'
           AND C.FECHA_ELABORACION >= P.MES_DESDE
           AND C.FECHA_ELABORACION < P.MES_HASTA)
         AS COTIZADO_MES,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM COTIZACIONES C
         WHERE C.ESTADO IN ('aprobada', 'enviada')
           AND C.FECHA_APROBACION >= P.MES_DESDE
           AND C.FECHA_APROBACION < P.MES_HASTA)
         AS APROBADAS_MES,
       (SELECT CAST(COALESCE(SUM(C.MONTO_TOTAL), 0) AS NUMERIC(18,2))
          FROM COTIZACIONES C
         WHERE C.ESTADO IN ('aprobada', 'enviada')
           AND C.FECHA_APROBACION >= P.MES_DESDE
           AND C.FECHA_APROBACION < P.MES_HASTA)
         AS MONTO_APROBADO_MES,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM COTIZACIONES C
         WHERE C.ESTADO = 'rechazada'
           AND C.FECHA_MODIFICACION >= P.MES_DESDE
           AND C.FECHA_MODIFICACION < P.MES_HASTA)
         AS RECHAZADAS_MES,
       (SELECT CAST(COALESCE(AVG(C.DIAS_RESPUESTA), 0) AS INTEGER)
          FROM V_COTIZACIONES C
         WHERE C.ESTADO IN ('aprobada', 'enviada')
           AND C.FECHA_APROBACION >= P.MES_DESDE
           AND C.FECHA_APROBACION < P.MES_HASTA)
         AS RESPUESTA_MEDIA,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM USUARIOS U
          JOIN ROLES R ON R.ID = U.ROL_ID
         WHERE R.CODIGO = 'asesor' AND U.ACTIVO)
         AS ASESORES_ACTIVOS
  FROM V_PERIODO_ACTUAL P;

/* ----------------------------------------------------------------------------
   4. V_ASESORES_MES: el mes de cada asesor. ESPERANDO_COTIZACION no depende
   del mes: son las suyas que siguen sin cotizacion aprobada ni enviada.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_ASESORES_MES AS
SELECT U.ID AS ASESOR_ID, U.NOMBRE AS ASESOR_NOMBRE, U.ACTIVO,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM SOLICITUDES S
         WHERE S.ASESOR_ID = U.ID
           AND S.FECHA_CAPTURA >= P.MES_DESDE
           AND S.FECHA_CAPTURA < P.MES_HASTA)
         AS SOLICITUDES_MES,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM SOLICITUDES S
         WHERE S.ASESOR_ID = U.ID
           AND S.ESTADO IN ('recibida', 'en_cotizacion')
           AND NOT EXISTS (SELECT 1 FROM COTIZACIONES X
                            WHERE X.SOLICITUD_ID = S.ID
                              AND X.ESTADO IN ('aprobada', 'enviada')))
         AS ESPERANDO_COTIZACION,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM V_COTIZACIONES C
         WHERE C.ASESOR_ID = U.ID AND C.ESTADO IN ('aprobada', 'enviada')
           AND C.FECHA_APROBACION >= P.MES_DESDE
           AND C.FECHA_APROBACION < P.MES_HASTA)
         AS APROBADAS_MES,
       (SELECT CAST(COALESCE(SUM(C.MONTO_TOTAL), 0) AS NUMERIC(18,2))
          FROM V_COTIZACIONES C
         WHERE C.ASESOR_ID = U.ID AND C.ESTADO IN ('aprobada', 'enviada')
           AND C.FECHA_APROBACION >= P.MES_DESDE
           AND C.FECHA_APROBACION < P.MES_HASTA)
         AS MONTO_APROBADO_MES
  FROM USUARIOS U
  JOIN ROLES R ON R.ID = U.ROL_ID
  CROSS JOIN V_PERIODO_ACTUAL P
 WHERE R.CODIGO = 'asesor';

/* ----------------------------------------------------------------------------
   5. V_COTIZACIONES_POR_ESTADO: todas, con el orden en que se presentan.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_COTIZACIONES_POR_ESTADO AS
SELECT ESTADO,
       CASE ESTADO WHEN 'borrador' THEN 1 WHEN 'pendiente' THEN 2
                   WHEN 'aprobada' THEN 3 WHEN 'enviada' THEN 4 ELSE 5 END
         AS ORDEN,
       CAST(COUNT(*) AS INTEGER) AS CANTIDAD,
       CAST(COALESCE(SUM(MONTO_TOTAL), 0) AS NUMERIC(18,2)) AS MONTO
  FROM COTIZACIONES
 GROUP BY ESTADO;

/* ----------------------------------------------------------------------------
   6. V_CUENTAS_RESUMEN: las cuentas, sin el usuario Sistema (migracion 13),
   que existe solo para firmar lo que el servidor hace solo.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_CUENTAS_RESUMEN AS
SELECT (SELECT CAST(COUNT(*) AS INTEGER) FROM USUARIOS U
         WHERE U.ACTIVO AND U.CORREO <> 'sistema@anovo.local')
         AS USUARIOS_ACTIVOS,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM USUARIOS U
         WHERE NOT U.ACTIVO AND U.CORREO <> 'sistema@anovo.local')
         AS USUARIOS_INACTIVOS,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM USUARIOS U
         WHERE U.ACTIVO AND U.DEBE_CAMBIAR_CLAVE)
         AS CLAVE_PENDIENTE,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM AUDITORIA A
         WHERE A.ENTIDAD = 'USUARIOS'
           AND A.FECHA >= P.MES_DESDE AND A.FECHA < P.MES_HASTA)
         AS CAMBIOS_MES
  FROM V_PERIODO_ACTUAL P;

/* ----------------------------------------------------------------------------
   7. V_AUDITORIA: la bitacora con el nombre de quien hizo cada cambio.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_AUDITORIA AS
SELECT A.ID, A.FECHA, A.USUARIO_ID, COALESCE(U.NOMBRE, '') AS USUARIO_NOMBRE,
       A.ACCION, A.ENTIDAD, A.ENTIDAD_ID, A.DETALLE
  FROM AUDITORIA A
  LEFT JOIN USUARIOS U ON U.ID = A.USUARIO_ID;

/* ----------------------------------------------------------------------------
   8. V_SEGUIMIENTO_ASESOR: las solicitudes como las ve el asesor (HU-03): el
   estado de la cotizacion si ya se aprobo o envio, si no el de la solicitud.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_SEGUIMIENTO_ASESOR AS
SELECT S.ID, S.ASESOR_ID, S.FECHA_CAPTURA, S.CLIENTE_NOMBRE, S.DESCRIPCION,
       COALESCE(K.ESTADO, S.ESTADO) AS ESTADO,
       K.ID AS COTIZACION_ID, K.MONTO_TOTAL AS MONTO_APROBADO
  FROM V_SOLICITUDES S
  LEFT JOIN COTIZACIONES K ON K.ID =
       (SELECT MAX(X.ID) FROM COTIZACIONES X
         WHERE X.SOLICITUD_ID = S.ID
           AND X.ESTADO IN ('aprobada', 'enviada'));

/* ----------------------------------------------------------------------------
   9. V_COTIZACIONES_DIA: las cotizaciones agrupadas por dia de elaboracion,
   estado, asesor y tipo de trabajo. Los reportes piden las filas de su rango
   y el servicio las suma. SUMA_DIAS_RESPUESTA y CON_RESPUESTA dan el promedio
   exacto sin promediar promedios.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_COTIZACIONES_DIA AS
SELECT CAST(FECHA_ELABORACION AS DATE) AS FECHA,
       CAST(EXTRACT(YEAR FROM FECHA_ELABORACION) AS INTEGER) AS ANIO,
       CAST(EXTRACT(MONTH FROM FECHA_ELABORACION) AS INTEGER) AS MES,
       ESTADO, ASESOR_ID, ASESOR_NOMBRE, TIPO_TRABAJO_ID, TIPO_TRABAJO_NOMBRE,
       CAST(COUNT(*) AS INTEGER) AS CANTIDAD,
       CAST(COALESCE(SUM(MONTO_TOTAL), 0) AS NUMERIC(18,2)) AS MONTO_TOTAL,
       CAST(SUM(CASE WHEN ESTADO IN ('aprobada', 'enviada') THEN 1 ELSE 0 END)
            AS INTEGER) AS APROBADAS,
       CAST(SUM(CASE WHEN ESTADO = 'rechazada' THEN 1 ELSE 0 END)
            AS INTEGER) AS RECHAZADAS,
       CAST(COALESCE(SUM(CASE WHEN ESTADO IN ('aprobada', 'enviada')
            THEN MONTO_TOTAL ELSE 0 END), 0) AS NUMERIC(18,2))
            AS MONTO_APROBADO,
       CAST(COALESCE(SUM(DIAS_RESPUESTA), 0) AS INTEGER) AS SUMA_DIAS_RESPUESTA,
       CAST(COUNT(DIAS_RESPUESTA) AS INTEGER) AS CON_RESPUESTA
  FROM V_COTIZACIONES
 GROUP BY 1, 2, 3, 4, 5, 6, 7, 8;

COMMIT;

/* ----------------------------------------------------------------------------
   10. Permisos. Solo lectura para el backend.
   ---------------------------------------------------------------------------- */
GRANT SELECT ON V_PERIODO_ACTUAL TO ROL_BACKEND;
GRANT SELECT ON V_TRABAJO_USUARIO TO ROL_BACKEND;
GRANT SELECT ON V_RESUMEN_MES TO ROL_BACKEND;
GRANT SELECT ON V_ASESORES_MES TO ROL_BACKEND;
GRANT SELECT ON V_COTIZACIONES_POR_ESTADO TO ROL_BACKEND;
GRANT SELECT ON V_CUENTAS_RESUMEN TO ROL_BACKEND;
GRANT SELECT ON V_AUDITORIA TO ROL_BACKEND;
GRANT SELECT ON V_SEGUIMIENTO_ASESOR TO ROL_BACKEND;
GRANT SELECT ON V_COTIZACIONES_DIA TO ROL_BACKEND;

COMMIT;

/* ----------------------------------------------------------------------------
   COMPROBACION

     SELECT * FROM V_PERIODO_ACTUAL;
     SELECT * FROM V_TRABAJO_USUARIO WHERE USUARIO_ID = 2;
     SELECT * FROM V_RESUMEN_MES;
     SELECT SUM(CANTIDAD) FROM V_COTIZACIONES_DIA;   -- igual que COTIZACIONES
   ---------------------------------------------------------------------------- */
