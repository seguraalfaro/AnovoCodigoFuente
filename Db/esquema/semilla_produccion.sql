/* ============================================================================
   semilla_produccion.sql
   Firebird 4.0 - datos iniciales de la base de produccion

   Lo carga Herramientas/produccion/base_produccion.py despues de crear la
   base, con juego de caracteres UTF8. No es una migracion: lleva tildes.
   Texto del consentimiento v1.1, formas de pago y valores por defecto del
   documento de la cotizacion. El firmante queda vacio: lo pone Anovo.
   ============================================================================ */

SET NAMES UTF8;

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local')) FROM RDB$DATABASE;

INSERT INTO FORMAS_PAGO (NOMBRE, ACTIVO) VALUES ('Contado contra entrega', TRUE);
INSERT INTO FORMAS_PAGO (NOMBRE, ACTIVO) VALUES ('50% de adelanto y 50% contra entrega', TRUE);
INSERT INTO FORMAS_PAGO (NOMBRE, ACTIVO) VALUES ('Crédito a 30 días', TRUE);
INSERT INTO FORMAS_PAGO (NOMBRE, ACTIVO) VALUES ('Transferencia bancaria a 15 días', TRUE);

INSERT INTO CONSENTIMIENTO_TEXTOS (VERSION, TITULO, CONTENIDO, VIGENTE, VIGENTE_DESDE, PUBLICADO_POR)
VALUES ('1.1', 'Consentimiento informado para el tratamiento de datos personales',
'Tratamiento de sus datos personales. A NOVO MS SA, cédula jurídica 3-101-255874, con domicilio en Santa Rosa de Santo Domingo, Heredia, le informa lo siguiente antes de registrar sus datos.



Qué datos registramos. Nuestro asesor registrará su nombre, número de identificación, teléfono, correo electrónico si lo brinda, la dirección del sitio donde se realizará el trabajo, la ubicación geográfica de ese sitio, y las fotografías y croquis que se levanten durante la visita.



Para qué los usamos. Para tres cosas: elaborar la cotización que usted solicita y darle seguimiento; permitir que otro asesor de Anovo ubique el sitio con facilidad si debe visitarlo posteriormente, que es la razón por la que se registra la ubicación geográfica; y, si usted acepta la cotización, completar los datos necesarios para emitir la factura correspondiente en el sistema de facturación de la empresa. No los usamos para ningún otro fin, no los vendemos, no los distribuimos ni los difundimos a terceros.



Quiénes pueden consultarlos. Solo el personal de Anovo autorizado según su función: el asesor comercial que lo atiende, el asistente de cotizaciones, el supervisor que aprueba la cotización, la gerencia y el administrador del sistema. Cada acceso queda registrado.



Qué es obligatorio y qué no. Son obligatorios su nombre y la descripción del trabajo por cotizar. El resto, es decir, teléfono, correo, dirección, ubicación, fotografías y croquis, es facultativo, aunque sin esos datos la cotización puede ser menos precisa y no podremos facturar sin solicitárselos después.



Qué pasa si no acepta. Anovo no registrará sus datos personales en el sistema y la cotización deberá tramitarse por otra vía.



Sus derechos. En cualquier momento puede solicitar el acceso a sus datos, su rectificación si están incorrectos y su supresión. También puede revocar este consentimiento. Anovo atenderá su solicitud de forma gratuita dentro de los cinco días hábiles siguientes. Si ejerce la supresión, sus datos personales, fotografías y croquis se eliminan; las cotizaciones ya emitidas se conservan sin quedar asociadas a usted, por razones de control comercial y contable.



Cuánto tiempo los conservamos. Mientras exista relación comercial con Anovo y hasta diez años después de terminada, conforme a la política de retención de la empresa. Si la cotización deriva en una factura, los plazos de conservación tributaria pueden ser distintos.



A quién dirigirse. Para ejercer cualquiera de estos derechos escriba a anovoms@gmail.com o llame al 4030-7542 o al 8992-1499.',
TRUE, CURRENT_TIMESTAMP, (SELECT ID FROM USUARIOS WHERE CORREO = 'sistema@anovo.local'));

UPDATE CONSENTIMIENTO_TEXTOS
  SET CONTENIDO = REPLACE(CONTENIDO, ASCII_CHAR(10), ASCII_CHAR(13) || ASCII_CHAR(10))
  WHERE VERSION = '1.1';

UPDATE EMPRESA SET
  FORMA_PAGO_ID = (SELECT ID FROM FORMAS_PAGO WHERE NOMBRE = '50% de adelanto y 50% contra entrega'),
  PLAZO_ENTREGA_CANTIDAD = 15, PLAZO_ENTREGA_UNIDAD_ID = 2,
  GARANTIA_CANTIDAD = 6, GARANTIA_UNIDAD_ID = 4,
  CARTA_PRESENTACION = 'Estimado cliente: de acuerdo con su solicitud, le presentamos la cotización de los trabajos descritos. Quedamos atentos a cualquier consulta.';

SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', NULL) FROM RDB$DATABASE;

COMMIT;
