/* ============================================================================
   Anovo - Migracion 45: vista del historial de estados de una cotizacion
   ----------------------------------------------------------------------------
   COTIZACION_ESTADOS ya guarda cada paso (disparador TR_COTIZACIONES_ESTADOS,
   migracion 32) con fecha, usuario y motivo, pero no se podia leer desde los
   clientes. Las lecturas van por vistas, y el nombre del usuario sale de
   USUARIOS:

   - V_COTIZACION_HISTORIAL: cada paso con el nombre de quien lo hizo.
   - ROL_BACKEND con SELECT.

   No crea tablas ni toca datos. Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 45: historial de estados') FROM RDB$DATABASE;

CREATE VIEW V_COTIZACION_HISTORIAL AS
SELECT H.ID, H.COTIZACION_ID, H.ESTADO, H.FECHA, H.USUARIO_ID,
       COALESCE(U.NOMBRE, '') AS USUARIO_NOMBRE, H.MOTIVO, H.ACTIVO
  FROM COTIZACION_ESTADOS H
  LEFT JOIN USUARIOS U ON U.ID = H.USUARIO_ID;

GRANT SELECT ON V_COTIZACION_HISTORIAL TO ROL_BACKEND;

COMMENT ON VIEW V_COTIZACION_HISTORIAL IS
  'Pasos de cada cotizacion con el nombre de quien los hizo (HU-07).';

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (45, '45_historial_de_estados');

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT COUNT(*) FROM RDB$RELATIONS WHERE RDB$RELATION_NAME = 'V_COTIZACION_HISTORIAL'; -- 1
     SELECT COUNT(*) FROM V_COTIZACION_HISTORIAL;          -- igual a COTIZACION_ESTADOS
     SELECT * FROM V_VERSION_ESQUEMA;                      -- 45
   ---------------------------------------------------------------------------- */
