/* ============================================================================
   Anovo - Migracion 19: V_CATALOGO_ITEMS con el nombre de la categoria
   ----------------------------------------------------------------------------
   El listado de mano de obra muestra la categoria por nombre y la vista de
   la 18 solo traia CATEGORIA_ID. Se rehace con CATEGORIA_NOMBRE, nulo en
   materiales y maquinas. CREATE OR ALTER conserva el GRANT de la 18.
   ============================================================================ */

CREATE OR ALTER VIEW V_CATALOGO_ITEMS AS
SELECT CAST('material' AS VARCHAR(10)) AS TIPO,
       M.ID, M.CODIGO, M.NOMBRE, M.DESCRIPCION,
       M.UNIDAD_MEDIDA_ID, U.NOMBRE AS UNIDAD_MEDIDA,
       CAST(NULL AS INTEGER) AS CATEGORIA_ID,
       CAST(NULL AS VARCHAR(120)) AS CATEGORIA_NOMBRE,
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
       MO.CATEGORIA_ID, CAT.NOMBRE,
       P.COSTO_UNITARIO, CAST(NULL AS NUMERIC(15,2)),
       CAST(NULL AS NUMERIC(15,2)),
       P.COSTO_UNITARIO, P.FECHA_VIGENCIA, MO.ACTIVO,
       (SELECT MIN(PP.FECHA_VIGENCIA) FROM PRECIOS_PROGRAMADOS PP
         WHERE PP.MANO_OBRA_ID = MO.ID AND PP.ESTADO = 'pendiente')
  FROM MANO_OBRA MO
  JOIN MANO_OBRA_CATEGORIA CAT ON CAT.ID = MO.CATEGORIA_ID
  JOIN UNIDADES_MEDIDA U ON U.ID = MO.UNIDAD_MEDIDA_ID
  LEFT JOIN MANO_OBRA_PRECIOS P
    ON P.MANO_OBRA_ID = MO.ID AND P.ACTIVO = TRUE
UNION ALL
SELECT CAST('maquina' AS VARCHAR(10)),
       Q.ID, Q.CODIGO, Q.NOMBRE, Q.DESCRIPCION,
       CAST(NULL AS INTEGER), CAST('hora' AS VARCHAR(20)),
       CAST(NULL AS INTEGER), CAST(NULL AS VARCHAR(120)),
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
   COMPROBACION

     SELECT TIPO, COUNT(*), COUNT(CATEGORIA_NOMBRE)
       FROM V_CATALOGO_ITEMS GROUP BY TIPO;

   CATEGORIA_NOMBRE solo tiene valor en mano_obra, en todas sus filas.
   ---------------------------------------------------------------------------- */
