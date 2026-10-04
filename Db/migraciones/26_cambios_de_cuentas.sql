/* Anovo - Migracion 26: los cambios de cuentas del mes cuentan tambien las
   claves, la matriz de roles y los permisos por persona (migracion 25), no
   solo la tabla USUARIOS. Todo en ASCII. */

ALTER VIEW V_CUENTAS_RESUMEN AS
SELECT (SELECT CAST(COUNT(*) AS INTEGER) FROM USUARIOS U
         WHERE U.ACTIVO AND U.CORREO <> 'sistema@anovo.local')
         AS USUARIOS_ACTIVOS,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM USUARIOS U
         WHERE NOT U.ACTIVO AND U.CORREO <> 'sistema@anovo.local')
         AS USUARIOS_INACTIVOS,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM USUARIOS U
         WHERE U.ACTIVO AND U.DEBE_CAMBIAR_CLAVE)
         AS CLAVE_PENDIENTE,
       (SELECT CAST(COUNT(*) AS INTEGER) FROM AUDITORIA A
         WHERE A.ENTIDAD IN ('USUARIOS', 'USUARIOS_CLAVES', 'ROLES_PERMISOS',
                             'USUARIOS_PERMISOS')
           AND A.FECHA >= P.MES_DESDE AND A.FECHA < P.MES_HASTA)
         AS CAMBIOS_MES
  FROM V_PERIODO_ACTUAL P;

COMMIT;
