/* ============================================================================
   Anovo - Migracion 50: orden de compra y clientes sin respuesta
   ----------------------------------------------------------------------------
   Dos pedidos del 18/10/2026:

   - COTIZACIONES gana ORDEN_COMPRA: el numero de orden de compra (PO) que da
     el cliente al aprobar. Se pide al registrar la respuesta aceptada; es
     obligatorio para clientes con cedula juridica.
   - V_CLIENTES_RESPUESTA: una fila por cotizacion enviada al cliente, con
     su estado actual, el asesor y el plazo de seguimiento de la empresa. De
     ahi el reporte de gerencia arma, por cliente, cuantas se respondieron y
     cuantas quedaron sin respuesta (descartadas o vencidas).

   Rompe el contrato solo hacia afuera con campos nuevos: orden_compra en la
   cotizacion y en la respuesta, y por_cliente en el reporte. Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 50: orden de compra y clientes sin respuesta') FROM RDB$DATABASE;

ALTER TABLE COTIZACIONES ADD ORDEN_COMPRA VARCHAR(40);

COMMIT;

CREATE VIEW V_CLIENTES_RESPUESTA AS
SELECT K.ID, K.NUMERO, K.CLIENTE_ID, C.NOMBRE AS CLIENTE_NOMBRE,
       S.ASESOR_ID, K.ELABORADA_POR, K.ESTADO, K.FECHA_ENVIO, K.MONTO_TOTAL,
       E.DIAS_SIN_RESPUESTA
  FROM COTIZACIONES K
  JOIN CLIENTES C ON C.ID = K.CLIENTE_ID
  JOIN SOLICITUDES S ON S.ID = K.SOLICITUD_ID
  CROSS JOIN EMPRESA E
 WHERE K.FECHA_ENVIO IS NOT NULL;

GRANT SELECT ON V_CLIENTES_RESPUESTA TO ROL_BACKEND;

COMMENT ON VIEW V_CLIENTES_RESPUESTA IS
  'Cotizaciones enviadas al cliente, para el reporte de clientes sin respuesta.';
COMMENT ON COLUMN COTIZACIONES.ORDEN_COMPRA IS
  'Orden de compra del cliente, registrada al aprobar la cotizacion.';

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (50, '50_orden_compra_y_clientes_sin_respuesta');

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT COUNT(*) FROM RDB$RELATION_FIELDS
      WHERE RDB$RELATION_NAME = 'COTIZACIONES'
        AND RDB$FIELD_NAME = 'ORDEN_COMPRA';                       -- 1
     SELECT COUNT(*) FROM V_CLIENTES_RESPUESTA;   -- cotizaciones con FECHA_ENVIO
     SELECT * FROM V_VERSION_ESQUEMA;                              -- 50
   ---------------------------------------------------------------------------- */
