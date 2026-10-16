/* ============================================================================
   Anovo - Migracion 47: quitar el indice repetido de COTIZACION_ENVIOS
   ----------------------------------------------------------------------------
   La 35 creo IDX_COTIZ_ENVIOS_COTIZACION sobre COTIZACION_ID, la misma columna
   de la clave foranea hacia COTIZACIONES. Firebird ya crea un indice por esa
   clave (RDB$FOREIGN76), asi que este no acelera ninguna consulta y si cada
   envio registrado. Es el mismo caso que la 24 resolvio para otros catorce.
   Lo encontro la revision de indices del diccionario de datos (16/10/2026).
   No toca datos ni rompe el contrato: ninguna entidad ni vista lo nombra.
   Todo en ASCII.
   ============================================================================ */

DROP INDEX IDX_COTIZ_ENVIOS_COTIZACION;

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (47, '47_indice_repetido_envios');

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT COUNT(*) FROM RDB$INDICES
      WHERE RDB$INDEX_NAME = 'IDX_COTIZ_ENVIOS_COTIZACION';          -- 0
     SELECT TRIM(S.RDB$FIELD_NAME) FROM RDB$RELATION_CONSTRAINTS C
       JOIN RDB$INDEX_SEGMENTS S ON S.RDB$INDEX_NAME = C.RDB$INDEX_NAME
      WHERE C.RDB$RELATION_NAME = 'COTIZACION_ENVIOS'
        AND C.RDB$CONSTRAINT_TYPE = 'FOREIGN KEY';                   -- COTIZACION_ID y USUARIO_ID
     SELECT * FROM V_VERSION_ESQUEMA;                                -- 47
   ---------------------------------------------------------------------------- */
