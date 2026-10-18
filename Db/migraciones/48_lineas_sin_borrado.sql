/* ============================================================================
   Anovo - Migracion 48: las lineas de cotizacion no se borran
   ----------------------------------------------------------------------------
   Quitar una linea de una cotizacion hacia DELETE sobre COTIZACION_DETALLE.
   La regla del proyecto es que nada se borra (11/10/2026): quitar es
   UPDATE ... ACTIVO = FALSE. Las medidas ya se resolvieron en la 38; quedaba
   el detalle de la cotizacion.

   - COTIZACION_DETALLE gana ACTIVO (D_BOOLEANO, verdadero por defecto). Las
     lineas que ya existen quedan activas.
   - El backend pierde DELETE sobre la tabla.
   - El backend filtra ACTIVO en el detalle, la linea y el subtotal por tipo.
     El siguiente ORDEN sigue contando todas, para no repetir numeros.

   Rompe el contrato solo hacia adentro: la entidad TCotizacionDetalle gana
   Activo y EliminarLinea inactiva. Las respuestas de la API no cambian.
   Lo encontro la revision del backend del 17/10/2026.
   Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 48: lineas de cotizacion sin borrado') FROM RDB$DATABASE;

ALTER TABLE COTIZACION_DETALLE ADD ACTIVO D_BOOLEANO;

COMMIT;

UPDATE COTIZACION_DETALLE SET ACTIVO = TRUE WHERE ACTIVO IS NULL;

REVOKE DELETE ON COTIZACION_DETALLE FROM ROL_BACKEND;

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (48, '48_lineas_sin_borrado');

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT COUNT(*) FROM RDB$RELATION_FIELDS
      WHERE RDB$RELATION_NAME = 'COTIZACION_DETALLE'
        AND RDB$FIELD_NAME = 'ACTIVO';                               -- 1
     SELECT COUNT(*) FROM COTIZACION_DETALLE WHERE ACTIVO IS NULL;   -- 0
     SELECT COUNT(*) FROM RDB$USER_PRIVILEGES
      WHERE RDB$RELATION_NAME = 'COTIZACION_DETALLE'
        AND RDB$USER = 'ROL_BACKEND' AND RDB$PRIVILEGE = 'D';        -- 0
     SELECT * FROM V_VERSION_ESQUEMA;                                -- 48
   ---------------------------------------------------------------------------- */
