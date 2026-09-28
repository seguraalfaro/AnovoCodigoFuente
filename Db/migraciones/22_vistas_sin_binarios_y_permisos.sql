/* ============================================================================
   Anovo - Migracion 22: vistas sin columnas binarias y matriz de permisos
   ----------------------------------------------------------------------------
   Los listados de adjuntos y de consentimientos no traen el contenido ni la
   firma: se leen de vistas sin esas columnas. La matriz rol-permiso deja de
   ser un join en el backend. Igual que la 18 y la 20: sin parametros y sin
   reglas de negocio.

   Todo en ASCII.
   ============================================================================ */

/* ----------------------------------------------------------------------------
   1. V_SOLICITUD_ADJUNTOS: los adjuntos sin CONTENIDO ni CONTENIDO_JSON. El
   contenido se pide aparte, uno por uno.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_SOLICITUD_ADJUNTOS AS
SELECT ID, SOLICITUD_ID, UUID_LOCAL, TIPO, NOMBRE_ARCHIVO, MIME,
       TAMANO_BYTES, ACTIVO, FECHA_CREACION
  FROM SOLICITUD_ADJUNTOS;

/* ----------------------------------------------------------------------------
   2. V_CONSENTIMIENTOS: el historial de consentimiento sin la imagen de la
   firma (Ley 8968: la firma solo sale cuando se pide).
   ---------------------------------------------------------------------------- */
CREATE VIEW V_CONSENTIMIENTOS AS
SELECT ID, CLIENTE_ID, CLIENTE_CONTACTO_ID, ACCION, VERSION_TEXTO, FECHA,
       FIRMANTE_NOMBRE, FIRMANTE_IDENTIFICACION, FIRMA_MIME, ORIGEN
  FROM CLIENTE_CONSENTIMIENTO_HISTORIAL;

/* ----------------------------------------------------------------------------
   3. V_PERMISOS_ROLES: la matriz rol-permiso con los codigos.
   ---------------------------------------------------------------------------- */
CREATE VIEW V_PERMISOS_ROLES AS
SELECT R.CODIGO AS ROL, P.CODIGO AS PERMISO
  FROM ROLES_PERMISOS RP
  JOIN ROLES R ON R.ID = RP.ROL_ID
  JOIN PERMISOS P ON P.ID = RP.PERMISO_ID;

COMMIT;

/* ----------------------------------------------------------------------------
   4. Permisos. Solo lectura para el backend.
   ---------------------------------------------------------------------------- */
GRANT SELECT ON V_SOLICITUD_ADJUNTOS TO ROL_BACKEND;
GRANT SELECT ON V_CONSENTIMIENTOS TO ROL_BACKEND;
GRANT SELECT ON V_PERMISOS_ROLES TO ROL_BACKEND;

COMMIT;

/* ----------------------------------------------------------------------------
   COMPROBACION

     SELECT COUNT(*) FROM V_SOLICITUD_ADJUNTOS;   -- igual que la tabla
     SELECT COUNT(*) FROM V_CONSENTIMIENTOS;      -- igual que la tabla
     SELECT COUNT(*) FROM V_PERMISOS_ROLES;       -- igual que ROLES_PERMISOS
   ---------------------------------------------------------------------------- */
