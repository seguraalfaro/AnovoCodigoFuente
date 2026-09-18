/* ============================================================================
   Anovo - Usuario de conexion del backend  (Firebird)
   ----------------------------------------------------------------------------
   El backend NO se conecta como SYSDBA, por lo mismo que no se conectaba como
   'sa' en SQL Server: es el superusuario y anula cualquier control.

   ANOVO_BACKEND puede leer y escribir las tablas de negocio, y sobre AUDITORIA
   no puede nada: ahi solo escribe el disparador, que corre con los privilegios
   del dueno de la tabla y no con los del usuario.

   La clave va en el .env del servidor, nunca en este archivo ni en el
   repositorio. Antes de correrlo, sustituir CLAVE_PENDIENTE.
   ============================================================================ */

CREATE USER ANOVO_BACKEND PASSWORD 'CLAVE_PENDIENTE';
COMMIT;

CREATE ROLE ROL_BACKEND;
COMMIT;

/* Lectura y escritura sobre las tablas de negocio */
GRANT SELECT, INSERT, UPDATE, DELETE ON USUARIOS                        TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON USUARIOS_CLAVES                 TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON EMPRESA                         TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON CLIENTES                        TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON CLIENTE_CONTACTOS               TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON CLIENTE_CONSENTIMIENTO_HISTORIAL TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON SOLICITUDES                     TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON SOLICITUD_ADJUNTOS              TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON SOLICITUD_MEDIDAS               TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON MATERIALES                      TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON MATERIALES_PRECIOS              TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON MANO_OBRA                       TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON MANO_OBRA_PRECIOS               TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON MAQUINAS                        TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON MAQUINAS_PRECIOS                TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON COTIZACIONES                    TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE, DELETE ON COTIZACION_DETALLE              TO ROL_BACKEND;

/* Catalogos cerrados: solo lectura desde la aplicacion */
GRANT SELECT ON ROLES               TO ROL_BACKEND;
GRANT SELECT ON MANO_OBRA_CATEGORIA TO ROL_BACKEND;
GRANT SELECT, INSERT, UPDATE ON TIPOS_TRABAJO TO ROL_BACKEND;

/* AUDITORIA: solo lectura. La escritura es del disparador.
   Sin INSERT aqui, nadie puede fabricar ni adulterar un registro de auditoria
   desde la aplicacion, y sin DELETE nadie puede borrar el rastro. */
GRANT SELECT ON AUDITORIA TO ROL_BACKEND;

/* El generador del consecutivo de cotizaciones */
GRANT USAGE ON SEQUENCE GEN_COTIZACION_NUMERO TO ROL_BACKEND;

GRANT ROL_BACKEND TO ANOVO_BACKEND;

COMMIT;
