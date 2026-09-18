/* ============================================================================
   Anovo - Datos iniciales  (Firebird)
   ----------------------------------------------------------------------------
   Se corre ANTES de 03_auditoria a proposito: los catalogos son preparacion
   del sistema, no acciones de un usuario. Auditarlos seria ruido, y ademas los
   disparadores exigen usuario en contexto y aqui todavia no hay sesion.

   Bloque A: catalogo minimo, va tambien en produccion.
   Bloque B: datos de prueba, NUNCA en produccion.
   ============================================================================ */

/* ====================  A. CATALOGO  ==================== */

INSERT INTO ROLES (ID, CODIGO, NOMBRE) VALUES (1, 'asesor',     'Asesor de campo');
INSERT INTO ROLES (ID, CODIGO, NOMBRE) VALUES (2, 'asistente',  'Asistente de cotizaciones');
INSERT INTO ROLES (ID, CODIGO, NOMBRE) VALUES (3, 'supervisor', 'Supervisor');
INSERT INTO ROLES (ID, CODIGO, NOMBRE) VALUES (4, 'gerencia',   'Gerencia');
INSERT INTO ROLES (ID, CODIGO, NOMBRE) VALUES (5, 'admin',      'Administrador');

INSERT INTO MANO_OBRA_CATEGORIA (ID, CODIGO, NOMBRE) VALUES (1, 'corte',      'Corte');
INSERT INTO MANO_OBRA_CATEGORIA (ID, CODIGO, NOMBRE) VALUES (2, 'soldadura',  'Soldadura');
INSERT INTO MANO_OBRA_CATEGORIA (ID, CODIGO, NOMBRE) VALUES (3, 'doblado',    'Doblado');
INSERT INTO MANO_OBRA_CATEGORIA (ID, CODIGO, NOMBRE) VALUES (4, 'pintura',    'Pintura');
INSERT INTO MANO_OBRA_CATEGORIA (ID, CODIGO, NOMBRE) VALUES (5, 'ensamblaje', 'Ensamblaje');
INSERT INTO MANO_OBRA_CATEGORIA (ID, CODIGO, NOMBRE) VALUES (6, 'acabado',    'Acabado');

/* Fila unica ID=1. Sin ella no hay que actualizar al editar los datos de la empresa. */
INSERT INTO EMPRESA (ID, RAZON_SOCIAL, CEDULA_JURIDICA, DIRECCION)
VALUES (1, 'ANOVO (razon social pendiente)', '0-000-000000', 'Direccion pendiente de confirmar');

/* ====================  B. DATOS DE PRUEBA  ==================== */

INSERT INTO USUARIOS (CORREO, NOMBRE, ROL_ID, ACTIVO, DEBE_CAMBIAR_CLAVE) VALUES ('asesor@anovo.test',     'Ana Asesora',      1, TRUE, FALSE);
INSERT INTO USUARIOS (CORREO, NOMBRE, ROL_ID, ACTIVO, DEBE_CAMBIAR_CLAVE) VALUES ('asistente@anovo.test',  'Beto Asistente',   2, TRUE, FALSE);
INSERT INTO USUARIOS (CORREO, NOMBRE, ROL_ID, ACTIVO, DEBE_CAMBIAR_CLAVE) VALUES ('supervisor@anovo.test', 'Carla Supervisora',3, TRUE, FALSE);
INSERT INTO USUARIOS (CORREO, NOMBRE, ROL_ID, ACTIVO, DEBE_CAMBIAR_CLAVE) VALUES ('gerencia@anovo.test',   'Diego Gerente',    4, TRUE, FALSE);
INSERT INTO USUARIOS (CORREO, NOMBRE, ROL_ID, ACTIVO, DEBE_CAMBIAR_CLAVE) VALUES ('admin@anovo.test',      'Eva Admin',        5, TRUE, FALSE);

/* Marcador que NO valida contra nada: no es un hash bcrypt real. Existe solo
   para que las filas no queden vacias. Regenerar con IClaveService (bcrypt
   costo 12, prefijo $2b$) en cuanto exista el login. */
INSERT INTO USUARIOS_CLAVES (USUARIO_ID, CLAVE_HASH, ACTIVO)
  SELECT ID, 'PENDIENTE-REGENERAR-CON-BCRYPT', TRUE FROM USUARIOS;

INSERT INTO CLIENTES (NOMBRE, IDENTIFICACION, TELEFONO, CORREO, DIRECCION, LATITUD, LONGITUD, ACTIVO)
VALUES ('Dispositivos Medicos CR S.A.', '3-101-111111', '2200-1111', 'compras@dmcr.test', 'Zona Franca Coyol, Alajuela', 9.993000, -84.220000, TRUE);

INSERT INTO CLIENTES (NOMBRE, IDENTIFICACION, TELEFONO, CORREO, DIRECCION, LATITUD, LONGITUD, ACTIVO)
VALUES ('Metalurgica del Valle', NULL, '2222-3333', 'info@metalvalle.test', 'La Uruca, San Jose', 9.955000, -84.130000, TRUE);

/* Marta es PRINCIPAL: firma por la empresa en la primera visita.
   Luis queda pendiente de firmar su propio consentimiento. */
INSERT INTO CLIENTE_CONTACTOS (CLIENTE_ID, NOMBRE, AREA, TELEFONO, CORREO, PRINCIPAL, CONSENTIMIENTO_ESTADO)
  SELECT ID, 'Marta Rojas', 'Compras', '8888-0001', 'marta@dmcr.test', TRUE, 'firmado'
  FROM CLIENTES WHERE NOMBRE = 'Dispositivos Medicos CR S.A.';

INSERT INTO CLIENTE_CONTACTOS (CLIENTE_ID, NOMBRE, AREA, TELEFONO, CORREO, PRINCIPAL, CONSENTIMIENTO_ESTADO)
  SELECT ID, 'Luis Vargas', 'Mantenimiento', '8888-0002', 'luis@dmcr.test', FALSE, 'pendiente'
  FROM CLIENTES WHERE NOMBRE = 'Dispositivos Medicos CR S.A.';

/* Consentimiento de la empresa, sin imagen de firma en la semilla. */
INSERT INTO CLIENTE_CONSENTIMIENTO_HISTORIAL (CLIENTE_ID, ACCION, VERSION_TEXTO, FIRMANTE_NOMBRE, ORIGEN)
  SELECT ID, 'otorgado', '1.0', 'Marta Rojas', 'movil'
  FROM CLIENTES WHERE NOMBRE = 'Dispositivos Medicos CR S.A.';

UPDATE CLIENTES
   SET CONSENTIMIENTO_ESTADO = 'firmado',
       CONSENTIMIENTO_VERSION = '1.0',
       CONSENTIMIENTO_FECHA = CURRENT_TIMESTAMP
 WHERE NOMBRE = 'Dispositivos Medicos CR S.A.';

/* Catalogos de muestra con su precio vigente. */
INSERT INTO MATERIALES (CODIGO, NOMBRE, DESCRIPCION, UNIDAD_MEDIDA)
VALUES ('MAT-001', 'Lamina acero inox 304 1.5mm', 'Lamina 1220x2440', 'unidad');
INSERT INTO MATERIALES (CODIGO, NOMBRE, DESCRIPCION, UNIDAD_MEDIDA)
VALUES ('MAT-002', 'Tubo redondo acero 1 pulgada', 'Tubo 6m', 'unidad');

INSERT INTO MATERIALES_PRECIOS (MATERIAL_ID, COSTO_UNITARIO, PRECIO_UNITARIO, ACTIVO)
  SELECT ID, 45000.00, 62000.00, TRUE FROM MATERIALES WHERE CODIGO = 'MAT-001';
INSERT INTO MATERIALES_PRECIOS (MATERIAL_ID, COSTO_UNITARIO, PRECIO_UNITARIO, ACTIVO)
  SELECT ID, 8500.00, 12000.00, TRUE FROM MATERIALES WHERE CODIGO = 'MAT-002';

INSERT INTO MANO_OBRA (CODIGO, CATEGORIA_ID, DESCRIPCION, UNIDAD_MEDIDA)
VALUES ('MO-001', 2, 'Hora de soldadura MIG', 'hora');
INSERT INTO MANO_OBRA_PRECIOS (MANO_OBRA_ID, COSTO_UNITARIO, ACTIVO)
  SELECT ID, 6500.00, TRUE FROM MANO_OBRA WHERE CODIGO = 'MO-001';

INSERT INTO MAQUINAS (CODIGO, NOMBRE, DESCRIPCION)
VALUES ('MAQ-001', 'Dobladora hidraulica', 'Dobladora 3m');
INSERT INTO MAQUINAS_PRECIOS (MAQUINA_ID, COSTO_HORA, ACTIVO)
  SELECT ID, 9000.00, TRUE FROM MAQUINAS WHERE CODIGO = 'MAQ-001';

INSERT INTO TIPOS_TRABAJO (NOMBRE) VALUES ('Fabricacion');
INSERT INTO TIPOS_TRABAJO (NOMBRE) VALUES ('Reparacion');
INSERT INTO TIPOS_TRABAJO (NOMBRE) VALUES ('Mantenimiento');

COMMIT;
