/* ============================================================================
   Anovo - Migracion 24: quitar indices duplicados
   ----------------------------------------------------------------------------
   Firebird crea un indice por cada PRIMARY KEY, FOREIGN KEY y UNIQUE. Estos
   indices repetian el de una clave foranea: trece con las mismas columnas y
   IDX_ROLPERM_PERMISO con la primera columna de FK_ROLPERM_PERMISO
   (PERMISO_ID, AMBITO), que el optimizador usa tambien para buscar solo por
   PERMISO_ID. No aceleraban ninguna consulta y si cada escritura.

   Se quedan los que combinan columnas o atienden estado y fecha:
   *_MOD, *_PRECIO_ACTIVO, IDX_PRECIOPROG_PENDIENTE, IDX_CLAVES_USUARIO_ACTIVO,
   IDX_COTIZ_ESTADO, IDX_COTIZ_FECHA, IDX_AUDITORIA_* y
   UQ_UNIDADES_MEDIDA_NOMBRE.

   Todo en ASCII.
   ============================================================================ */

DROP INDEX IDX_CONTACTOS_CLIENTE;
DROP INDEX IDX_CONSHIST_CLIENTE;
DROP INDEX IDX_SOLICITUDES_ASESOR;
DROP INDEX IDX_SOLICITUDES_CLIENTE;
DROP INDEX IDX_ADJUNTOS_SOLICITUD;
DROP INDEX IDX_MEDIDAS_SOLICITUD;
DROP INDEX IDX_MANO_OBRA_CATEGORIA;
DROP INDEX IDX_MATERIALES_UNIDAD;
DROP INDEX IDX_MANO_OBRA_UNIDAD;
DROP INDEX IDX_PRECIOPROG_MATERIAL;
DROP INDEX IDX_PRECIOPROG_MANO_OBRA;
DROP INDEX IDX_PRECIOPROG_MAQUINA;
DROP INDEX IDX_DETALLE_COTIZ;
DROP INDEX IDX_ROLPERM_PERMISO;

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT RDB$INDEX_NAME FROM RDB$INDICES I
      WHERE COALESCE(I.RDB$SYSTEM_FLAG, 0) = 0
        AND NOT EXISTS (SELECT 1 FROM RDB$RELATION_CONSTRAINTS C
                         WHERE C.RDB$INDEX_NAME = I.RDB$INDEX_NAME);
     -- quedan 14: los 13 que combinan columnas o atienden estado y fecha,
     -- y UQ_UNIDADES_MEDIDA_NOMBRE
   ---------------------------------------------------------------------------- */
