/* Anovo - Migracion 31: reporte de cotizaciones limitado a lo propio.
   El permiso reportes.ver_propios no se asigna a ningun rol: se otorga a una
   persona en USUARIOS_PERMISOS y el reporte muestra solo las cotizaciones de
   sus solicitudes o las que elaboro. Por eso V_COTIZACIONES_DIA agrupa tambien
   por ELABORADA_POR. Pendiente de aprobacion en la minuta 13/2026. Todo en ASCII. */

INSERT INTO PERMISOS (ID, CODIGO, NOMBRE, MODULO, AMBITO)
  VALUES (602, 'reportes.ver_propios', 'Consultar reportes propios', 'reportes', 'negocio');

COMMIT;

ALTER VIEW V_COTIZACIONES_DIA AS
SELECT CAST(FECHA_ELABORACION AS DATE) AS FECHA,
       CAST(EXTRACT(YEAR FROM FECHA_ELABORACION) AS INTEGER) AS ANIO,
       CAST(EXTRACT(MONTH FROM FECHA_ELABORACION) AS INTEGER) AS MES,
       ESTADO, ASESOR_ID, ASESOR_NOMBRE, TIPO_TRABAJO_ID, TIPO_TRABAJO_NOMBRE,
       ELABORADA_POR,
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
 GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9;

COMMIT;
