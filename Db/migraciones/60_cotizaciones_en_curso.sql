/* ============================================================================
   Anovo - Migracion 60: cotizaciones en curso de cada usuario
   ----------------------------------------------------------------------------
   Al preparar el video (15/11/2026) el menu Cotizaciones del escritorio
   mostraba el mismo numero de la campana (enviadas sin respuesta) y no
   coincidia con lo que la persona tiene en trabajo.

   - V_TRABAJO_USUARIO.EN_CURSO: cotizaciones que el usuario elaboro y que
     todavia no terminan: borrador, devuelta, en revision, con visto bueno o
     enviada. No cuenta las aprobadas, las rechazadas ni las descartadas.

   Agrega una columna al final de la vista; las demas quedan igual.
   No crea tablas ni toca datos. Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 60: cotizaciones en curso') FROM RDB$DATABASE;

CREATE OR ALTER VIEW V_TRABAJO_USUARIO AS
SELECT U.ID AS USUARIO_ID,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM V_SOLICITUDES S
         WHERE S.ESTADO = 'recibida' AND S.TIENE_COTIZACION = FALSE)
         AS POR_COTIZAR,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM VT_COTIZACIONES C
         WHERE C.ELABORADA_POR = U.ID AND C.ESTADO IN ('borrador', 'devuelta'))
         AS MIS_BORRADORES,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM VT_COTIZACIONES C
         WHERE C.ELABORADA_POR = U.ID AND C.ESTADO = 'en_revision')
         AS EN_APROBACION,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM VT_COTIZACIONES C
         WHERE C.ELABORADA_POR = U.ID AND C.ESTADO = 'visto_bueno')
         AS POR_ENVIAR,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM VT_COTIZACIONES C
         WHERE C.ESTADO = 'en_revision' AND C.ELABORADA_POR <> U.ID)
         AS POR_APROBAR,
       (SELECT CAST(COALESCE(MAX(C.DIAS_EN_ESTADO), 0) AS INTEGER)
          FROM V_COTIZACIONES C
         WHERE C.ESTADO = 'en_revision' AND C.ELABORADA_POR <> U.ID)
         AS DIAS_MAS_ANTIGUA,
       (SELECT CAST(COALESCE(SUM(C.MONTO_TOTAL), 0) AS NUMERIC(18,2))
          FROM VT_COTIZACIONES C
         WHERE C.ESTADO = 'en_revision' AND C.ELABORADA_POR <> U.ID)
         AS MONTO_POR_APROBAR,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM VT_COTIZACIONES C
         WHERE C.ELABORADA_POR = U.ID
           AND C.ESTADO IN ('borrador', 'devuelta', 'en_revision',
                            'visto_bueno', 'enviada'))
         AS EN_CURSO
  FROM USUARIOS U;

GRANT SELECT ON V_TRABAJO_USUARIO TO ROL_BACKEND;

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (60, '60_cotizaciones_en_curso');

COMMIT;

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT T.USUARIO_ID, T.EN_CURSO,
            (SELECT COUNT(*) FROM VT_COTIZACIONES C
              WHERE C.ELABORADA_POR = T.USUARIO_ID
                AND C.ESTADO NOT IN ('aprobada', 'rechazada', 'descartada'))
       FROM V_TRABAJO_USUARIO T;                           -- iguales
     SELECT * FROM V_VERSION_ESQUEMA;                      -- 60
   ---------------------------------------------------------------------------- */
