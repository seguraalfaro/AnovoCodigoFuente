/* ============================================================================
   Anovo - Migracion 41: permisos del disparador de auditoria de dispositivos
   ----------------------------------------------------------------------------
   La 40 creo TR_USUARIOS_DISPOSITIVOS_AUD sin el permiso para escribir en
   AUDITORIA ni para usar la excepcion E_AUDITORIA_SIN_USUARIO, como pide cada
   disparador de auditoria (ver la 35). La prueba sobre la copia corrio como
   SYSDBA y no lo mostro; con el usuario del backend, registrar un dispositivo
   daba "no permission for INSERT access to TABLE AUDITORIA".

   Todo en ASCII.
   ============================================================================ */

GRANT INSERT ON AUDITORIA TO TRIGGER TR_USUARIOS_DISPOSITIVOS_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_USUARIOS_DISPOSITIVOS_AUD;

INSERT INTO ESQUEMA_MIGRACIONES (NUMERO, NOMBRE)
  VALUES (41, '41_permisos_auditoria_dispositivos');

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT TRIM(RDB$USER), TRIM(RDB$RELATION_NAME), RDB$PRIVILEGE
       FROM RDB$USER_PRIVILEGES
      WHERE RDB$USER = 'TR_USUARIOS_DISPOSITIVOS_AUD';   -- AUDITORIA I y la excepcion G
     SELECT * FROM V_VERSION_ESQUEMA;                    -- 41
   ---------------------------------------------------------------------------- */
