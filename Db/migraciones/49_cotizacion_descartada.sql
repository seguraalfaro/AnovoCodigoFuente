/* ============================================================================
   Anovo - Migracion 49: estado descartada de la cotizacion
   ----------------------------------------------------------------------------
   Las cotizaciones enviadas que pasan el plazo de DIAS_SIN_RESPUESTA salen en
   las notificaciones del escritorio. Quien elabora puede descartarlas: dejan
   de avisarse y no cuentan como respondidas. Si el cliente responde despues,
   la respuesta se registra igual (descartada -> aprobada o rechazada).

   - CK_COTIZ_ESTADO y CK_COTIZ_ESTADOS_ESTADO aceptan 'descartada'.
   - El disparador TR_COTIZACIONES_ESTADOS no cambia: deja la fila del paso.

   No crea tablas ni toca datos. Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 49: cotizacion descartada') FROM RDB$DATABASE;

ALTER TABLE COTIZACIONES DROP CONSTRAINT CK_COTIZ_ESTADO;
ALTER TABLE COTIZACION_ESTADOS DROP CONSTRAINT CK_COTIZ_ESTADOS_ESTADO;

COMMIT;

ALTER TABLE COTIZACIONES ADD CONSTRAINT CK_COTIZ_ESTADO CHECK (ESTADO IN
  ('borrador', 'pendiente', 'devuelta', 'visto_bueno', 'enviada', 'aprobada',
   'rechazada', 'descartada'));
ALTER TABLE COTIZACION_ESTADOS ADD CONSTRAINT CK_COTIZ_ESTADOS_ESTADO CHECK
  (ESTADO IN ('borrador', 'pendiente', 'devuelta', 'visto_bueno', 'enviada',
   'aprobada', 'rechazada', 'descartada'));

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (49, '49_cotizacion_descartada');

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT COUNT(*) FROM RDB$CHECK_CONSTRAINTS C
       JOIN RDB$TRIGGERS T ON T.RDB$TRIGGER_NAME = C.RDB$TRIGGER_NAME
      WHERE C.RDB$CONSTRAINT_NAME IN ('CK_COTIZ_ESTADO',
            'CK_COTIZ_ESTADOS_ESTADO')
        AND T.RDB$TRIGGER_SOURCE CONTAINING 'descartada';            -- 4
     SELECT * FROM V_VERSION_ESQUEMA;                                -- 49
   ---------------------------------------------------------------------------- */
