/* ============================================================================
   Anovo - Migracion 42: el seguimiento del asesor baja al movil
   ----------------------------------------------------------------------------
   La pestana Solicitudes del movil (HU-03) muestra sus solicitudes con el
   estado como lo ve el asesor, desde SQLite. Para juntar cada fila del
   servidor con la solicitud del telefono hace falta UUID_LOCAL, y para bajar
   solo lo que cambio, una fecha. V_SEGUIMIENTO_ASESOR suma, desde SOLICITUDES:

   - UUID_LOCAL y NOMBRE_PROYECTO;
   - COTIZACION_NUMERO, el consecutivo de la cotizacion;
   - FECHA_CAMBIO: la mas reciente entre la solicitud y su ultima cotizacion,
     las dos mantenidas por TR_<TABLA>_BU.

   Las columnas que ya tenia no cambian, asi que el seguimiento del escritorio
   y /api/solicitudes/seguimiento siguen igual. Nada depende de la vista.

   Todo en ASCII.
   ============================================================================ */

ALTER VIEW V_SEGUIMIENTO_ASESOR AS
SELECT S.ID, S.ASESOR_ID, S.FECHA_CAPTURA, S.CLIENTE_NOMBRE, S.DESCRIPCION,
       COALESCE(K.ESTADO, S.ESTADO) AS ESTADO,
       K.ID AS COTIZACION_ID, K.MONTO_TOTAL AS MONTO_APROBADO,
       T.UUID_LOCAL, T.NOMBRE_PROYECTO, K.NUMERO AS COTIZACION_NUMERO,
       MAXVALUE(T.FECHA_MODIFICACION,
                COALESCE(K.FECHA_MODIFICACION, T.FECHA_MODIFICACION))
         AS FECHA_CAMBIO
  FROM V_SOLICITUDES S
  JOIN SOLICITUDES T ON T.ID = S.ID
  LEFT JOIN COTIZACIONES K ON K.ID =
       (SELECT MAX(X.ID) FROM COTIZACIONES X WHERE X.SOLICITUD_ID = S.ID);

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (42, '42_seguimiento_para_el_movil');

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT COUNT(*) FROM V_SEGUIMIENTO_ASESOR;                  -- igual que antes
     SELECT COUNT(*) FROM V_SEGUIMIENTO_ASESOR
      WHERE UUID_LOCAL IS NULL OR FECHA_CAMBIO IS NULL;          -- 0
     SELECT * FROM V_VERSION_ESQUEMA;                            -- 42
   ---------------------------------------------------------------------------- */
