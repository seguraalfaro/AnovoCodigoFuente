/* ============================================================================
   Anovo - Migracion 37: permisos por rol y por persona sin borrado fisico
   ----------------------------------------------------------------------------
   Regla del proyecto: en la base nada se borra, se inactiva. ROLES_PERMISOS y
   USUARIOS_PERMISOS eran las unicas tablas de cuentas que el backend borraba:
   quitar un permiso de un rol, retirar una excepcion de una persona y
   descartar sus excepciones al cambiarle el rol. Ese borrado fallaba ademas
   con FireDAC -308 (CP-07, 11/10/2026).

   - ACTIVO en las dos tablas, TRUE en las filas que ya existen.
   - FECHA_MODIFICACION en las dos, mantenida por TR_<TABLA>_BU: dice en la
     misma fila cuando se inactivo o se reactivo. El quien y el motivo
     quedan en AUDITORIA.
   - V_PERMISOS_ROLES, V_USUARIOS_PERMISOS y el conteo EXCEPCIONES de
     V_USUARIOS leen solo las filas activas.
   - El backend pasa de DELETE a UPDATE: se le da UPDATE y se le quita DELETE,
     para que la regla la sostenga tambien la base.

   Va antes que la de piezas (38), que no esta aplicada y rompe el contrato
   de medidas y adjuntos: esta se puede aplicar sin esperar a esa.

   Rompe el contrato: entidades TRolesPermisos y TUsuariosPermisos (se
   regeneran con MVCEntGen) y los servicios de roles, usuarios y sesion.

   Todo en ASCII.
   ============================================================================ */

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID',
  (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'))
  FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE',
  'migracion 37: permisos sin borrado fisico') FROM RDB$DATABASE;

/* ----------------------------------------------------------------------------
   1. Columna ACTIVO
   ---------------------------------------------------------------------------- */
ALTER TABLE ROLES_PERMISOS
  ADD ACTIVO D_BOOLEANO DEFAULT TRUE NOT NULL;
ALTER TABLE ROLES_PERMISOS
  ADD FECHA_MODIFICACION D_TIMESTAMP;

ALTER TABLE USUARIOS_PERMISOS
  ADD ACTIVO D_BOOLEANO DEFAULT TRUE NOT NULL;
ALTER TABLE USUARIOS_PERMISOS
  ADD FECHA_MODIFICACION D_TIMESTAMP;

COMMIT;

COMMENT ON COLUMN ROLES_PERMISOS.ACTIVO IS
  'FALSE cuando se quita el permiso del rol. Volver a darlo reactiva la fila.';

COMMENT ON COLUMN USUARIOS_PERMISOS.ACTIVO IS
  'FALSE cuando se retira la excepcion o se cambia el rol. Volver a darla reactiva la fila.';

COMMENT ON TABLE USUARIOS_PERMISOS IS
  'Excepciones de una persona sobre los permisos de su rol. Insert o update, sin delete.';

/* ----------------------------------------------------------------------------
   2. Valores por defecto (migracion 28) y fecha de modificacion
   ---------------------------------------------------------------------------- */
SET TERM ^ ;

CREATE OR ALTER TRIGGER TR_ROLES_PERMISOS_BI_DEF FOR ROLES_PERMISOS ACTIVE BEFORE INSERT POSITION 0 AS
BEGIN
  IF (NEW.ACTIVO IS NULL) THEN NEW.ACTIVO = TRUE;
  IF (NEW.FECHA_CREACION IS NULL) THEN NEW.FECHA_CREACION = CURRENT_TIMESTAMP;
  IF (NEW.FECHA_MODIFICACION IS NULL) THEN NEW.FECHA_MODIFICACION = CURRENT_TIMESTAMP;
END^

CREATE OR ALTER TRIGGER TR_USUARIOS_PERMISOS_BI_DEF FOR USUARIOS_PERMISOS ACTIVE BEFORE INSERT POSITION 0 AS
BEGIN
  IF (NEW.ACTIVO IS NULL) THEN NEW.ACTIVO = TRUE;
  IF (NEW.FECHA_CREACION IS NULL) THEN NEW.FECHA_CREACION = CURRENT_TIMESTAMP;
  IF (NEW.FECHA_MODIFICACION IS NULL) THEN NEW.FECHA_MODIFICACION = CURRENT_TIMESTAMP;
END^

CREATE TRIGGER TR_ROLES_PERMISOS_BU FOR ROLES_PERMISOS ACTIVE BEFORE UPDATE POSITION 0 AS
BEGIN NEW.FECHA_MODIFICACION = CURRENT_TIMESTAMP; END^

CREATE TRIGGER TR_USUARIOS_PERMISOS_BU FOR USUARIOS_PERMISOS ACTIVE BEFORE UPDATE POSITION 0 AS
BEGIN NEW.FECHA_MODIFICACION = CURRENT_TIMESTAMP; END^

SET TERM ; ^

/* ----------------------------------------------------------------------------
   3. Vistas: solo filas activas
   ---------------------------------------------------------------------------- */
ALTER VIEW V_PERMISOS_ROLES AS
SELECT R.CODIGO AS ROL, P.CODIGO AS PERMISO
  FROM ROLES_PERMISOS RP
  JOIN ROLES R ON R.ID = RP.ROL_ID
  JOIN PERMISOS P ON P.ID = RP.PERMISO_ID
 WHERE RP.ACTIVO = TRUE;

ALTER VIEW V_USUARIOS_PERMISOS AS
SELECT UP.USUARIO_ID, UP.PERMISO_ID, P.CODIGO AS PERMISO, P.NOMBRE,
       P.MODULO, UP.TIPO, UP.MOTIVO, UP.FECHA_CREACION
  FROM USUARIOS_PERMISOS UP
  JOIN PERMISOS P ON P.ID = UP.PERMISO_ID
 WHERE UP.ACTIVO = TRUE;

ALTER VIEW V_USUARIOS AS
SELECT U.ID, U.CORREO, U.NOMBRE, U.ROL_ID, R.CODIGO AS ROL,
       R.NOMBRE AS ROL_NOMBRE, U.AMBITO, U.ACTIVO, U.DEBE_CAMBIAR_CLAVE,
       U.FECHA_CREACION, U.FECHA_MODIFICACION,
       (SELECT MAX(C.FECHA_CAMBIO) FROM USUARIOS_CLAVES C
         WHERE C.USUARIO_ID = U.ID AND C.ACTIVO = TRUE) AS FECHA_CLAVE,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM USUARIOS_PERMISOS P
         WHERE P.USUARIO_ID = U.ID AND P.ACTIVO = TRUE) AS EXCEPCIONES
  FROM USUARIOS U
  JOIN ROLES R ON R.ID = U.ROL_ID;

COMMIT;

/* ----------------------------------------------------------------------------
   4. Permisos del backend: UPDATE en lugar de DELETE
   ---------------------------------------------------------------------------- */
GRANT UPDATE ON ROLES_PERMISOS TO ROL_BACKEND;
GRANT UPDATE ON USUARIOS_PERMISOS TO ROL_BACKEND;
REVOKE DELETE ON ROLES_PERMISOS FROM ROL_BACKEND;
REVOKE DELETE ON USUARIOS_PERMISOS FROM ROL_BACKEND;

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (37, '37_permisos_sin_borrado');

SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', NULL) FROM RDB$DATABASE;
SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT COUNT(*) FROM ROLES_PERMISOS WHERE ACTIVO = TRUE;     -- igual a la siguiente
     SELECT COUNT(*) FROM V_PERMISOS_ROLES;
     SELECT COUNT(*) FROM USUARIOS_PERMISOS WHERE ACTIVO = TRUE;  -- igual a la siguiente
     SELECT COUNT(*) FROM V_USUARIOS_PERMISOS;
     SELECT COUNT(*) FROM USUARIOS_PERMISOS
      WHERE FECHA_MODIFICACION IS NULL;                         -- 0
     SELECT RDB$PRIVILEGE FROM RDB$USER_PRIVILEGES
      WHERE RDB$USER = 'ROL_BACKEND'
        AND RDB$RELATION_NAME IN ('ROLES_PERMISOS', 'USUARIOS_PERMISOS');
                                          -- S, I y U en cada una; ninguna D
     SELECT * FROM V_VERSION_ESQUEMA;                              -- 37
   ---------------------------------------------------------------------------- */
