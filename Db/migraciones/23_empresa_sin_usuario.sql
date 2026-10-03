/* ============================================================================
   Anovo - Migracion 23: EMPRESA sin relacion con USUARIOS
   ----------------------------------------------------------------------------
   EMPRESA guarda los datos de Anovo para el encabezado de la cotizacion y no
   se relaciona con las cuentas de usuario. MODIFICADO_POR no lo leia ni lo
   escribia nadie: quien cambia los datos de la empresa queda en AUDITORIA por
   TR_EMPRESA_AUD, que toma el usuario del contexto de la sesion.

   La clave foranea se creo sin nombre (INTEG_nn), por eso se busca antes de
   quitar la columna; Firebird no deja borrar una columna con una restriccion.

   Todo en ASCII.
   ============================================================================ */

SET TERM ^ ;

EXECUTE BLOCK AS
  DECLARE VARIABLE V_FK VARCHAR(63);
BEGIN
  SELECT TRIM(RC.RDB$CONSTRAINT_NAME)
    FROM RDB$RELATION_CONSTRAINTS RC
    JOIN RDB$INDEX_SEGMENTS S ON S.RDB$INDEX_NAME = RC.RDB$INDEX_NAME
   WHERE RC.RDB$RELATION_NAME = 'EMPRESA'
     AND RC.RDB$CONSTRAINT_TYPE = 'FOREIGN KEY'
     AND S.RDB$FIELD_NAME = 'MODIFICADO_POR'
    INTO :V_FK;
  IF (V_FK IS NOT NULL) THEN
    EXECUTE STATEMENT 'ALTER TABLE EMPRESA DROP CONSTRAINT ' || V_FK;
END^

SET TERM ; ^

COMMIT;

ALTER TABLE EMPRESA DROP MODIFICADO_POR;

COMMIT;

/* ----------------------------------------------------------------------------
   Verificacion:
     SELECT RDB$FIELD_NAME FROM RDB$RELATION_FIELDS
      WHERE RDB$RELATION_NAME = 'EMPRESA';          -- sin MODIFICADO_POR
     SELECT * FROM EMPRESA;                         -- la fila ID = 1 intacta
   ---------------------------------------------------------------------------- */
