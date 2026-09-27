/* ============================================================================
   Anovo - Migracion 18: vistas de lectura
   ----------------------------------------------------------------------------
   Las consultas de lectura repetian los mismos joins en varios archivos
   Anovo.SQL.*: solicitud con cliente y asesor, cotizacion con cliente,
   asesor y quien la elaboro, y los tres catalogos con su precio vigente.
   Pasan a vistas: se escriben una vez, el generador de entidades las lee
   como cualquier tabla (sin llave primaria, de solo lectura) y los reportes
   se arman sobre ellas.

   Las vistas describen los datos, no deciden nada: sin parametros y sin
   reglas de negocio. Quien consulta, que estados cuentan como en curso y la
   paginacion siguen en el repositorio, como filtros sobre la vista.

   Todo en ASCII, como el resto de los scripts.
   ============================================================================ */

/* ----------------------------------------------------------------------------
   1. V_SOLICITUDES. FECHA_RECEPCION cae a la de captura mientras la solicitud
   no se ha recibido, y DIAS_ESPERA se cuenta desde ahi.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_SOLICITUDES AS
SELECT S.ID, S.ESTADO, S.DESCRIPCION, S.FECHA_CAPTURA,
       COALESCE(S.FECHA_RECEPCION, S.FECHA_CAPTURA) AS FECHA_RECEPCION,
       S.CLIENTE_ID, C.NOMBRE AS CLIENTE_NOMBRE,
       S.ASESOR_ID, A.NOMBRE AS ASESOR_NOMBRE,
       CAST(DATEDIFF(DAY FROM COALESCE(S.FECHA_RECEPCION, S.FECHA_CAPTURA)
                     TO CURRENT_TIMESTAMP) AS INTEGER) AS DIAS_ESPERA,
       CASE WHEN EXISTS (SELECT 1 FROM COTIZACIONES X
                          WHERE X.SOLICITUD_ID = S.ID)
            THEN TRUE ELSE FALSE END AS TIENE_COTIZACION
  FROM SOLICITUDES S
  JOIN CLIENTES C ON C.ID = S.CLIENTE_ID
  JOIN USUARIOS A ON A.ID = S.ASESOR_ID;

/* ----------------------------------------------------------------------------
   2. V_COTIZACIONES. DEVUELTA: borrador con observacion del supervisor.
   DIAS_EN_ESTADO se mide con FECHA_MODIFICACION, porque no hay fecha propia
   de presentacion ni de rechazo. DIAS_RESPUESTA va de la recepcion de la
   solicitud a la aprobacion; nulo si no se aprobo.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_COTIZACIONES AS
SELECT K.ID, K.NUMERO, K.ESTADO, K.DESCRIPCION_TRABAJO,
       K.SUBTOTAL_MATERIALES, K.SUBTOTAL_MANO_OBRA, K.SUBTOTAL_MAQUINA,
       K.COSTO_TOTAL, K.PORCENTAJE_AJUSTE, K.MOTIVO_AJUSTE, K.PORCENTAJE_IVA,
       K.MONTO_IMPUESTO, K.MONTO_TOTAL, K.MOTIVO_RECHAZO,
       K.FECHA_ELABORACION, K.FECHA_APROBACION, K.FECHA_ENVIO,
       K.FECHA_MODIFICACION,
       K.SOLICITUD_ID,
       COALESCE(S.FECHA_RECEPCION, S.FECHA_CAPTURA) AS FECHA_RECEPCION,
       K.CLIENTE_ID, C.NOMBRE AS CLIENTE_NOMBRE,
       S.ASESOR_ID, A.NOMBRE AS ASESOR_NOMBRE,
       K.ELABORADA_POR, E.NOMBRE AS ELABORADA_POR_NOMBRE,
       K.APROBADA_POR, P.NOMBRE AS APROBADA_POR_NOMBRE,
       K.TIPO_TRABAJO_ID, T.NOMBRE AS TIPO_TRABAJO_NOMBRE,
       CASE WHEN K.ESTADO = 'borrador' AND K.MOTIVO_RECHAZO IS NOT NULL
            THEN TRUE ELSE FALSE END AS DEVUELTA,
       CAST(DATEDIFF(DAY FROM K.FECHA_MODIFICACION TO CURRENT_TIMESTAMP)
            AS INTEGER) AS DIAS_EN_ESTADO,
       CASE WHEN K.FECHA_APROBACION IS NOT NULL
            THEN CAST(DATEDIFF(DAY FROM COALESCE(S.FECHA_RECEPCION,
                      S.FECHA_CAPTURA) TO K.FECHA_APROBACION) AS INTEGER)
       END AS DIAS_RESPUESTA
  FROM COTIZACIONES K
  JOIN SOLICITUDES S ON S.ID = K.SOLICITUD_ID
  JOIN CLIENTES C ON C.ID = K.CLIENTE_ID
  JOIN USUARIOS A ON A.ID = S.ASESOR_ID
  JOIN USUARIOS E ON E.ID = K.ELABORADA_POR
  LEFT JOIN USUARIOS P ON P.ID = K.APROBADA_POR
  LEFT JOIN TIPOS_TRABAJO T ON T.ID = K.TIPO_TRABAJO_ID;

/* ----------------------------------------------------------------------------
   3. V_CATALOGO_ITEMS. Los tres catalogos con su precio vigente y el proximo
   cambio programado. COSTO es el costo comparable entre tipos: el unitario en
   materiales y mano de obra, el de la hora en maquinas, que se miden en hora.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_CATALOGO_ITEMS AS
SELECT CAST('material' AS VARCHAR(10)) AS TIPO,
       M.ID, M.CODIGO, M.NOMBRE, M.DESCRIPCION,
       M.UNIDAD_MEDIDA_ID, U.NOMBRE AS UNIDAD_MEDIDA,
       CAST(NULL AS INTEGER) AS CATEGORIA_ID,
       P.COSTO_UNITARIO, P.PRECIO_UNITARIO,
       CAST(NULL AS NUMERIC(15,2)) AS COSTO_HORA,
       P.COSTO_UNITARIO AS COSTO, P.FECHA_VIGENCIA, M.ACTIVO,
       (SELECT MIN(PP.FECHA_VIGENCIA) FROM PRECIOS_PROGRAMADOS PP
         WHERE PP.MATERIAL_ID = M.ID AND PP.ESTADO = 'pendiente')
         AS PROGRAMADO_FECHA
  FROM MATERIALES M
  JOIN UNIDADES_MEDIDA U ON U.ID = M.UNIDAD_MEDIDA_ID
  LEFT JOIN MATERIALES_PRECIOS P
    ON P.MATERIAL_ID = M.ID AND P.ACTIVO = TRUE
UNION ALL
SELECT CAST('mano_obra' AS VARCHAR(10)),
       MO.ID, MO.CODIGO, MO.NOMBRE, MO.DESCRIPCION,
       MO.UNIDAD_MEDIDA_ID, U.NOMBRE,
       MO.CATEGORIA_ID,
       P.COSTO_UNITARIO, CAST(NULL AS NUMERIC(15,2)),
       CAST(NULL AS NUMERIC(15,2)),
       P.COSTO_UNITARIO, P.FECHA_VIGENCIA, MO.ACTIVO,
       (SELECT MIN(PP.FECHA_VIGENCIA) FROM PRECIOS_PROGRAMADOS PP
         WHERE PP.MANO_OBRA_ID = MO.ID AND PP.ESTADO = 'pendiente')
  FROM MANO_OBRA MO
  JOIN UNIDADES_MEDIDA U ON U.ID = MO.UNIDAD_MEDIDA_ID
  LEFT JOIN MANO_OBRA_PRECIOS P
    ON P.MANO_OBRA_ID = MO.ID AND P.ACTIVO = TRUE
UNION ALL
SELECT CAST('maquina' AS VARCHAR(10)),
       Q.ID, Q.CODIGO, Q.NOMBRE, Q.DESCRIPCION,
       CAST(NULL AS INTEGER), CAST('hora' AS VARCHAR(20)),
       CAST(NULL AS INTEGER),
       CAST(NULL AS NUMERIC(15,2)), CAST(NULL AS NUMERIC(15,2)),
       P.COSTO_HORA,
       P.COSTO_HORA, P.FECHA_VIGENCIA, Q.ACTIVO,
       (SELECT MIN(PP.FECHA_VIGENCIA) FROM PRECIOS_PROGRAMADOS PP
         WHERE PP.MAQUINA_ID = Q.ID AND PP.ESTADO = 'pendiente')
  FROM MAQUINAS Q
  LEFT JOIN MAQUINAS_PRECIOS P
    ON P.MAQUINA_ID = Q.ID AND P.ACTIVO = TRUE;

COMMIT;

/* ----------------------------------------------------------------------------
   4. Permisos. Solo lectura para el backend.
   ---------------------------------------------------------------------------- */
GRANT SELECT ON V_SOLICITUDES TO ROL_BACKEND;
GRANT SELECT ON V_COTIZACIONES TO ROL_BACKEND;
GRANT SELECT ON V_CATALOGO_ITEMS TO ROL_BACKEND;

COMMIT;

/* ----------------------------------------------------------------------------
   COMPROBACION

     SELECT COUNT(*) FROM V_SOLICITUDES;      -- igual que SOLICITUDES
     SELECT COUNT(*) FROM V_COTIZACIONES;     -- igual que COTIZACIONES
     SELECT TIPO, COUNT(*) FROM V_CATALOGO_ITEMS GROUP BY TIPO;
   ---------------------------------------------------------------------------- */
