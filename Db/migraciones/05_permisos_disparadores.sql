/* ============================================================================
   PERMISO DE ESCRITURA PARA LOS DISPARADORES DE AUDITORIA
   Firebird 4.0 - base ANOVO
   15 de septiembre de 2026

   Por que hace falta.

   04_usuario.sql le da a ROL_BACKEND solo SELECT sobre AUDITORIA, con el
   razonamiento de que la escritura la hace el disparador y el disparador corre
   con los privilegios del dueno de la tabla. Esa segunda parte es falsa en
   Firebird 4: salvo que se diga lo contrario, las rutinas y los disparadores
   corren como SQL SECURITY INVOKER, o sea con los privilegios de quien invoca.
   Quien invoca es ANOVO_BACKEND, que no tiene ninguno sobre AUDITORIA.

   El sintoma es un INSERT de negocio que muere con
   "no permission for INSERT access to TABLE AUDITORIA", como si el problema lo
   tuviera la aplicacion, cuando lo tiene el disparador.

   Por que asi y no de otra forma.

   La alternativa seria GRANT INSERT ON AUDITORIA TO ROL_BACKEND, y eso echaria
   abajo lo que el diseno buscaba: si la aplicacion puede insertar en AUDITORIA,
   tambien puede fabricar registros de auditoria, y entonces la auditoria deja
   de probar nada.

   Concediendoselo al disparador, el permiso lo tiene el objeto y no el usuario:
   ANOVO_BACKEND sigue sin poder tocar AUDITORIA por su cuenta -ni con un INSERT
   directo, ni con UPDATE, ni con DELETE- y la unica via de escritura sigue
   siendo el disparador, que la base dispara sola y nadie puede saltarse.

   La otra alternativa, ALTER TRIGGER ... SQL SECURITY DEFINER, tambien
   funcionaria, pero le daria al disparador todos los privilegios del dueno de
   la base en vez del unico que necesita.
   ============================================================================ */

/* La base que usa el servidor es la que declara Backend\bin\FDConnectionDefs.ini.
   Hay otro ejemplar en db-firebird\ANOVO.FDB: aplicar sobre el equivocado deja el
   sintoma intacto y hace perder una tarde. */
CONNECT 'localhost:F:\Uned\TFG\AnovoCodigoFuente\Db\ANOVO.FDB'
  USER 'SYSDBA' PASSWORD 'CLAVE_SYSDBA';

GRANT INSERT ON AUDITORIA TO TRIGGER TR_USUARIOS_AUD;
GRANT INSERT ON AUDITORIA TO TRIGGER TR_USUARIOS_CLAVES_AUD;
GRANT INSERT ON AUDITORIA TO TRIGGER TR_CLIENTES_AUD;
GRANT INSERT ON AUDITORIA TO TRIGGER TR_CLIENTE_CONTACTOS_AUD;
GRANT INSERT ON AUDITORIA TO TRIGGER TR_CONSHIST_AUD;
GRANT INSERT ON AUDITORIA TO TRIGGER TR_SOLICITUDES_AUD;
GRANT INSERT ON AUDITORIA TO TRIGGER TR_COTIZACIONES_AUD;
GRANT INSERT ON AUDITORIA TO TRIGGER TR_MATERIALES_PRECIOS_AUD;
GRANT INSERT ON AUDITORIA TO TRIGGER TR_MANO_OBRA_PRECIOS_AUD;
GRANT INSERT ON AUDITORIA TO TRIGGER TR_MAQUINAS_PRECIOS_AUD;
GRANT INSERT ON AUDITORIA TO TRIGGER TR_EMPRESA_AUD;

/* Lanzar una excepcion con nombre tambien pide privilegio en Firebird 4, y por la
   misma razon: el disparador corre con los privilegios de quien lo invoca. Sin
   esto la escritura sin contexto se rechaza igual -la garantia no corre peligro-
   pero el mensaje habla de permisos en vez de decir que falto el usuario, que es
   lo unico que le sirve a quien lo esta diagnosticando. */
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_USUARIOS_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_USUARIOS_CLAVES_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_CLIENTES_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_CLIENTE_CONTACTOS_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_CONSHIST_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_SOLICITUDES_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_COTIZACIONES_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_MATERIALES_PRECIOS_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_MANO_OBRA_PRECIOS_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_MAQUINAS_PRECIOS_AUD;
GRANT USAGE ON EXCEPTION E_AUDITORIA_SIN_USUARIO TO TRIGGER TR_EMPRESA_AUD;

COMMIT;

/* ----------------------------------------------------------------------------
   COMPROBACION

   1. Con la aplicacion, crear un cliente. Tiene que quedar la fila:

      SELECT ID, USUARIO_ID, ACCION, ENTIDAD, ENTIDAD_ID, FECHA
        FROM AUDITORIA ORDER BY ID DESC ROWS 5;

   2. Conectado como ANOVO_BACKEND, intentar escribir a mano. Tiene que seguir
      fallando, y este es el caso que sostiene el diseno:

      INSERT INTO AUDITORIA (USUARIO_ID, ACCION, ENTIDAD, ENTIDAD_ID)
      VALUES (3, 'insertar', 'CLIENTES', 1);
      -- esperado: no permission for INSERT access to TABLE AUDITORIA

   3. Conectado como ANOVO_BACKEND, escribir sin fijar el contexto. Tiene que dar la
      excepcion propia, no un mensaje de permisos:

      INSERT INTO CLIENTES (NOMBRE) VALUES ('Prueba sin contexto');
      -- esperado: E_AUDITORIA_SIN_USUARIO
      --           "No hay USUARIO_ID en el contexto de sesion..."

   Si la 1 pasa y la 2 falla, el permiso quedo donde tenia que quedar: en el
   disparador, no en el usuario. La 3 confirma que el mensaje apunta a la causa real.

   Aplicado y comprobado el 15/09/2026 sobre AnovoCodigoFuente\Db\ANOVO.FDB. Ver
   Entregables\pruebas\CP-02-auditoria-por-disparadores.md.
---------------------------------------------------------------------------- */
