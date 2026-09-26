/* ============================================================================
   Anovo - Datos de prueba para trabajar en las pantallas  (Firebird 4.0)
   ----------------------------------------------------------------------------
   NUNCA EN PRODUCCION. Llena catalogos, clientes con contactos y
   consentimiento, solicitudes con adjuntos y medidas, y cotizaciones con su
   detalle, con fechas repartidas en los ultimos seis meses para que los
   reportes y el dashboard tengan de donde sacar numeros.

   Se puede volver a correr: al inicio borra lo que genero la vez anterior,
   reconocible por el prefijo 'demo-' en UUID_LOCAL y por los codigos que
   empiezan en DEMO-. Lo que venia de 02_datos.sql no se toca.

   Los disparadores de auditoria exigen el usuario en contexto, asi que lo
   primero es fijarlo. Queda tambien auditoria, que es lo que se quiere: la
   pantalla de auditoria necesita filas.

   Uso:
     isql -u SYSDBA -p <clave> -i carga_demo.sql localhost/3050:F:\...\ANOVO.FDB
   ============================================================================ */

SET TERM ^ ;

/* El usuario en contexto: se usa el asistente, que es quien recibe
   solicitudes y elabora cotizaciones. */
EXECUTE BLOCK AS
  DECLARE VARIABLE V VARCHAR(10);
BEGIN
  V = RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', '2');
END^

/* ====================  LIMPIEZA DE LA CORRIDA ANTERIOR  ====================
   En orden inverso al de las llaves foraneas. */
EXECUTE BLOCK AS
BEGIN
  DELETE FROM COTIZACION_DETALLE WHERE COTIZACION_ID IN
    (SELECT C.ID FROM COTIZACIONES C JOIN SOLICITUDES S ON S.ID = C.SOLICITUD_ID
      WHERE S.UUID_LOCAL STARTING WITH 'demo-');
  DELETE FROM COTIZACIONES WHERE SOLICITUD_ID IN
    (SELECT ID FROM SOLICITUDES WHERE UUID_LOCAL STARTING WITH 'demo-');
  DELETE FROM SOLICITUD_MEDIDAS WHERE SOLICITUD_ID IN
    (SELECT ID FROM SOLICITUDES WHERE UUID_LOCAL STARTING WITH 'demo-');
  DELETE FROM SOLICITUD_ADJUNTOS WHERE SOLICITUD_ID IN
    (SELECT ID FROM SOLICITUDES WHERE UUID_LOCAL STARTING WITH 'demo-');
  DELETE FROM SOLICITUDES WHERE UUID_LOCAL STARTING WITH 'demo-';

  DELETE FROM CLIENTE_CONSENTIMIENTO_HISTORIAL WHERE CLIENTE_ID IN
    (SELECT ID FROM CLIENTES WHERE UUID_LOCAL STARTING WITH 'demo-');
  DELETE FROM CLIENTE_CONTACTOS WHERE CLIENTE_ID IN
    (SELECT ID FROM CLIENTES WHERE UUID_LOCAL STARTING WITH 'demo-');
  DELETE FROM CLIENTES WHERE UUID_LOCAL STARTING WITH 'demo-';

  DELETE FROM MATERIALES_PRECIOS WHERE MATERIAL_ID IN
    (SELECT ID FROM MATERIALES WHERE CODIGO STARTING WITH 'DEMO-');
  DELETE FROM MATERIALES WHERE CODIGO STARTING WITH 'DEMO-';
  DELETE FROM MANO_OBRA_PRECIOS WHERE MANO_OBRA_ID IN
    (SELECT ID FROM MANO_OBRA WHERE CODIGO STARTING WITH 'DEMO-');
  DELETE FROM MANO_OBRA WHERE CODIGO STARTING WITH 'DEMO-';
  DELETE FROM MAQUINAS_PRECIOS WHERE MAQUINA_ID IN
    (SELECT ID FROM MAQUINAS WHERE CODIGO STARTING WITH 'DEMO-');
  DELETE FROM MAQUINAS WHERE CODIGO STARTING WITH 'DEMO-';
  DELETE FROM TIPOS_TRABAJO WHERE NOMBRE STARTING WITH 'Demo ';
END^

/* ====================  CATALOGOS  ==================== */

/* 30 materiales de lamina, tubo, perfil y consumibles, con dos precios cada
   uno: el vigente y uno anterior, para que el historial de precios muestre
   algo. */
EXECUTE BLOCK AS
  DECLARE VARIABLE I INTEGER;
  DECLARE VARIABLE ID_MAT INTEGER;
  DECLARE VARIABLE NOMBRE VARCHAR(120);
  DECLARE VARIABLE UNIDAD VARCHAR(20);
  DECLARE VARIABLE COSTO NUMERIC(15,2);
BEGIN
  I = 1;
  WHILE (I <= 30) DO
  BEGIN
    IF (MOD(I, 5) = 1) THEN BEGIN
      NOMBRE = 'Lamina acero negro calibre ' || (14 + MOD(I, 6));
      UNIDAD = 'lamina'; COSTO = 18500 + (I * 420);
    END ELSE IF (MOD(I, 5) = 2) THEN BEGIN
      NOMBRE = 'Tubo cuadrado ' || (1 + MOD(I, 4)) || ' pulg';
      UNIDAD = 'metro'; COSTO = 3200 + (I * 95);
    END ELSE IF (MOD(I, 5) = 3) THEN BEGIN
      NOMBRE = 'Angular ' || (1 + MOD(I, 3)) || 'x' || (1 + MOD(I, 3)) || ' pulg';
      UNIDAD = 'metro'; COSTO = 2750 + (I * 80);
    END ELSE IF (MOD(I, 5) = 4) THEN BEGIN
      NOMBRE = 'Lamina galvanizada calibre ' || (18 + MOD(I, 4));
      UNIDAD = 'lamina'; COSTO = 21400 + (I * 510);
    END ELSE BEGIN
      NOMBRE = 'Electrodo 6013 de ' || (1 + MOD(I, 3)) || '/8';
      UNIDAD = 'kilo'; COSTO = 4100 + (I * 65);
    END

    INSERT INTO MATERIALES (CODIGO, NOMBRE, DESCRIPCION, UNIDAD_MEDIDA, ACTIVO)
      VALUES ('DEMO-MAT-' || LPAD(:I, 3, '0'), :NOMBRE,
              'Material de prueba para el catalogo', :UNIDAD, TRUE)
      RETURNING ID INTO :ID_MAT;

    /* El anterior, vigente hasta hace tres meses. */
    INSERT INTO MATERIALES_PRECIOS (MATERIAL_ID, COSTO_UNITARIO,
      PRECIO_UNITARIO, ACTIVO, FECHA_VIGENCIA, MODIFICADO_POR)
      VALUES (:ID_MAT, :COSTO * 0.92, :COSTO * 1.25, FALSE,
              DATEADD(-120 DAY TO CURRENT_TIMESTAMP), 3);
    INSERT INTO MATERIALES_PRECIOS (MATERIAL_ID, COSTO_UNITARIO,
      PRECIO_UNITARIO, ACTIVO, FECHA_VIGENCIA, MODIFICADO_POR)
      VALUES (:ID_MAT, :COSTO, :COSTO * 1.35, TRUE,
              DATEADD(-90 DAY TO CURRENT_TIMESTAMP), 3);
    I = I + 1;
  END
END^

/* 12 tareas de mano de obra, repartidas en las seis categorias que ya existen. */
EXECUTE BLOCK AS
  DECLARE VARIABLE I INTEGER;
  DECLARE VARIABLE ID_MO INTEGER;
  DECLARE VARIABLE CAT INTEGER;
  DECLARE VARIABLE DESCR VARCHAR(500);
  DECLARE VARIABLE COSTO NUMERIC(15,2);
BEGIN
  I = 1;
  WHILE (I <= 12) DO
  BEGIN
    CAT = 1 + MOD(I - 1, 6);
    DESCR = CASE CAT
      WHEN 1 THEN 'Corte de lamina con cizalla'
      WHEN 2 THEN 'Soldadura MIG en estructura'
      WHEN 3 THEN 'Doblado en prensa'
      WHEN 4 THEN 'Pintura electrostatica'
      WHEN 5 THEN 'Ensamblaje de piezas'
      ELSE 'Acabado y pulido' END;
    COSTO = 4200 + (I * 180);

    INSERT INTO MANO_OBRA (CODIGO, CATEGORIA_ID, NOMBRE, DESCRIPCION,
      UNIDAD_MEDIDA, ACTIVO)
      VALUES ('DEMO-MO-' || LPAD(:I, 3, '0'), :CAT,
              :DESCR,
              :DESCR || ' (nivel ' || (1 + MOD(:I, 3)) || ')', 'hora', TRUE)
      RETURNING ID INTO :ID_MO;

    INSERT INTO MANO_OBRA_PRECIOS (MANO_OBRA_ID, COSTO_UNITARIO, ACTIVO,
      FECHA_VIGENCIA, MODIFICADO_POR)
      VALUES (:ID_MO, :COSTO * 0.9, FALSE,
              DATEADD(-150 DAY TO CURRENT_TIMESTAMP), 4);
    INSERT INTO MANO_OBRA_PRECIOS (MANO_OBRA_ID, COSTO_UNITARIO, ACTIVO,
      FECHA_VIGENCIA, MODIFICADO_POR)
      VALUES (:ID_MO, :COSTO, TRUE,
              DATEADD(-60 DAY TO CURRENT_TIMESTAMP), 4);
    I = I + 1;
  END
END^

/* 8 maquinas con su costo por hora. */
EXECUTE BLOCK AS
  DECLARE VARIABLE I INTEGER;
  DECLARE VARIABLE ID_MQ INTEGER;
  DECLARE VARIABLE NOMBRE VARCHAR(120);
  DECLARE VARIABLE COSTO NUMERIC(15,2);
BEGIN
  I = 1;
  WHILE (I <= 8) DO
  BEGIN
    NOMBRE = CASE I
      WHEN 1 THEN 'Cortadora laser CNC'
      WHEN 2 THEN 'Plegadora hidraulica'
      WHEN 3 THEN 'Torno paralelo'
      WHEN 4 THEN 'Fresadora vertical'
      WHEN 5 THEN 'Cizalla guillotina'
      WHEN 6 THEN 'Cabina de pintura'
      WHEN 7 THEN 'Roladora de lamina'
      ELSE 'Taladro de pedestal' END;
    COSTO = 9500 + (I * 1350);

    INSERT INTO MAQUINAS (CODIGO, NOMBRE, DESCRIPCION, ACTIVO)
      VALUES ('DEMO-MQ-' || LPAD(:I, 3, '0'), :NOMBRE,
              'Maquina de prueba del taller', TRUE)
      RETURNING ID INTO :ID_MQ;

    INSERT INTO MAQUINAS_PRECIOS (MAQUINA_ID, COSTO_HORA, ACTIVO,
      FECHA_VIGENCIA, MODIFICADO_POR)
      VALUES (:ID_MQ, :COSTO, TRUE,
              DATEADD(-75 DAY TO CURRENT_TIMESTAMP), 4);
    I = I + 1;
  END
END^

/* 6 tipos de trabajo. */
EXECUTE BLOCK AS
BEGIN
  INSERT INTO TIPOS_TRABAJO (NOMBRE, ACTIVO) VALUES ('Demo estructura metalica', TRUE);
  INSERT INTO TIPOS_TRABAJO (NOMBRE, ACTIVO) VALUES ('Demo mueble de acero inoxidable', TRUE);
  INSERT INTO TIPOS_TRABAJO (NOMBRE, ACTIVO) VALUES ('Demo porton y reja', TRUE);
  INSERT INTO TIPOS_TRABAJO (NOMBRE, ACTIVO) VALUES ('Demo tanque y deposito', TRUE);
  INSERT INTO TIPOS_TRABAJO (NOMBRE, ACTIVO) VALUES ('Demo reparacion en sitio', TRUE);
  INSERT INTO TIPOS_TRABAJO (NOMBRE, ACTIVO) VALUES ('Demo fabricacion de piezas', TRUE);
END^

/* ====================  CLIENTES, CONTACTOS Y CONSENTIMIENTO  ====================
   25 clientes: 15 firmados, 7 pendientes y 3 revocados, para que el listado
   muestre las tres pastillas y el filtro tenga que hacer algo. */
EXECUTE BLOCK AS
  DECLARE VARIABLE I INTEGER;
  DECLARE VARIABLE ID_CLI INTEGER;
  DECLARE VARIABLE ID_CON INTEGER;
  DECLARE VARIABLE NOMBRE VARCHAR(120);
  DECLARE VARIABLE LUGAR VARCHAR(120);
  DECLARE VARIABLE ESTADO VARCHAR(20);
  DECLARE VARIABLE FIRMA TIMESTAMP;
  DECLARE VARIABLE CUANTOS INTEGER;
  DECLARE VARIABLE J INTEGER;
  DECLARE VARIABLE PERSONA VARCHAR(120);
BEGIN
  I = 1;
  WHILE (I <= 25) DO
  BEGIN
    NOMBRE = CASE MOD(I, 5)
      WHEN 0 THEN 'Taller Industrial '
      WHEN 1 THEN 'Metalmecanica '
      WHEN 2 THEN 'Estructuras '
      WHEN 3 THEN 'Inversiones '
      ELSE 'Comercializadora ' END ||
      CASE MOD(I, 7)
      WHEN 0 THEN 'Del Valle'
      WHEN 1 THEN 'Sanchez'
      WHEN 2 THEN 'Oreamuno'
      WHEN 3 THEN 'Cordero'
      WHEN 4 THEN 'Quesada'
      WHEN 5 THEN 'Jimenez'
      ELSE 'Mora' END || ' S.A.';
    LUGAR = CASE MOD(I, 6)
      WHEN 0 THEN 'Zona Industrial, Cartago'
      WHEN 1 THEN 'El Coyol, Alajuela'
      WHEN 2 THEN 'La Uruca, San Jose'
      WHEN 3 THEN 'Curridabat, San Jose'
      WHEN 4 THEN 'San Rafael, Heredia'
      ELSE 'Puntarenas centro' END;

    IF (I <= 15) THEN ESTADO = 'firmado';
    ELSE IF (I <= 22) THEN ESTADO = 'pendiente';
    ELSE ESTADO = 'revocado';

    FIRMA = DATEADD(-(160 - (I * 5)) DAY TO CURRENT_TIMESTAMP);

    INSERT INTO CLIENTES (UUID_LOCAL, NOMBRE, IDENTIFICACION, TELEFONO, CORREO,
      DIRECCION, LATITUD, LONGITUD, ACTIVO, EXONERADO, CODIGO_EXONERACION,
      CONSENTIMIENTO_ESTADO, CONSENTIMIENTO_FECHA, CONSENTIMIENTO_VERSION)
      VALUES ('demo-cli-' || LPAD(:I, 3, '0'), :NOMBRE,
              '3-101-' || LPAD(200000 + (:I * 137), 6, '0'),
              '2' || LPAD(200 + :I, 3, '0') || '-' || LPAD(1000 + (:I * 7), 4, '0'),
              'compras' || :I || '@demo.test', :LUGAR,
              9.80 + (:I * 0.011), -84.30 + (:I * 0.013),
              /* Dos inactivos, para que el filtro de inactivos tenga que hacer
                 algo. */
              CASE WHEN :I IN (19, 24) THEN FALSE ELSE TRUE END,
              CASE WHEN MOD(:I, 8) = 0 THEN TRUE ELSE FALSE END,
              CASE WHEN MOD(:I, 8) = 0 THEN 'EX-' || LPAD(:I, 5, '0') ELSE NULL END,
              :ESTADO,
              CASE WHEN :ESTADO = 'pendiente' THEN NULL ELSE :FIRMA END,
              CASE WHEN :ESTADO = 'pendiente' THEN NULL ELSE '1.1' END)
      RETURNING ID INTO :ID_CLI;

    /* De uno a tres contactos, el primero principal. */
    CUANTOS = 1 + MOD(I, 3);
    J = 1;
    WHILE (J <= CUANTOS) DO
    BEGIN
      PERSONA = CASE MOD(I + J, 8)
        WHEN 0 THEN 'Marta Rojas'
        WHEN 1 THEN 'Luis Vargas'
        WHEN 2 THEN 'Sofia Campos'
        WHEN 3 THEN 'Randall Solis'
        WHEN 4 THEN 'Karla Ugalde'
        WHEN 5 THEN 'Jose Pablo Mena'
        WHEN 6 THEN 'Adriana Leon'
        ELSE 'Mauricio Chaves' END;

      INSERT INTO CLIENTE_CONTACTOS (UUID_LOCAL, CLIENTE_ID, NOMBRE, AREA,
        TELEFONO, CORREO, PRINCIPAL, CONSENTIMIENTO_ESTADO,
        CONSENTIMIENTO_FECHA, CONSENTIMIENTO_VERSION, ACTIVO)
        VALUES ('demo-con-' || LPAD(:I, 3, '0') || '-' || :J, :ID_CLI, :PERSONA,
                CASE MOD(:J, 3) WHEN 1 THEN 'Compras' WHEN 2 THEN 'Mantenimiento'
                  ELSE 'Produccion' END,
                '8' || LPAD(100 + :I, 3, '0') || '-' || LPAD(2000 + (:J * 11), 4, '0'),
                'contacto' || :I || :J || '@demo.test',
                CASE WHEN :J = 1 THEN TRUE ELSE FALSE END,
                CASE WHEN :J = 1 THEN :ESTADO ELSE 'pendiente' END,
                CASE WHEN (:J = 1) AND (:ESTADO <> 'pendiente') THEN :FIRMA ELSE NULL END,
                CASE WHEN (:J = 1) AND (:ESTADO <> 'pendiente') THEN '1.1' ELSE NULL END,
                TRUE)
        RETURNING ID INTO :ID_CON;

      /* El historial: el otorgado del contacto que firmo. */
      IF ((J = 1) AND (:ESTADO <> 'pendiente')) THEN
        INSERT INTO CLIENTE_CONSENTIMIENTO_HISTORIAL (CLIENTE_ID,
          CLIENTE_CONTACTO_ID, ACCION, VERSION_TEXTO, FECHA, FIRMANTE_NOMBRE,
          FIRMANTE_IDENTIFICACION, FIRMA_MIME, ORIGEN)
          VALUES (:ID_CLI, :ID_CON, 'otorgado', '1.1', :FIRMA, :PERSONA,
                  '1-' || LPAD(1000 + :I, 4, '0') || '-' || LPAD(:I * 3, 4, '0'),
                  'image/png', 'movil');
      J = J + 1;
    END

    /* Y la revocacion de los tres ultimos, un mes despues de firmar. */
    IF (:ESTADO = 'revocado') THEN
      INSERT INTO CLIENTE_CONSENTIMIENTO_HISTORIAL (CLIENTE_ID, ACCION,
        VERSION_TEXTO, FECHA, FIRMANTE_NOMBRE, ORIGEN)
        VALUES (:ID_CLI, 'revocado', '1.1', DATEADD(30 DAY TO :FIRMA),
                'Solicitado por el cliente', 'escritorio');
    I = I + 1;
  END
END^

/* ====================  SOLICITUDES, ADJUNTOS Y MEDIDAS  ====================
   40 solicitudes de los dos asesores (1 Ana, 6 Bruno), repartidas en los
   ultimos seis meses y en los cuatro estados. */
EXECUTE BLOCK AS
  DECLARE VARIABLE I INTEGER;
  DECLARE VARIABLE ID_SOL INTEGER;
  DECLARE VARIABLE ID_ADJ INTEGER;
  DECLARE VARIABLE ID_CLI INTEGER;
  DECLARE VARIABLE ASESOR INTEGER;
  DECLARE VARIABLE ESTADO VARCHAR(20);
  DECLARE VARIABLE CAPTURA TIMESTAMP;
  DECLARE VARIABLE DESCR VARCHAR(500);
  DECLARE VARIABLE CUANTAS INTEGER;
  DECLARE VARIABLE J INTEGER;
BEGIN
  I = 1;
  WHILE (I <= 40) DO
  BEGIN
    /* Sobre los clientes con consentimiento firmado: sin firma no se le
       levanta trabajo a nadie. */
    SELECT ID FROM CLIENTES
      WHERE UUID_LOCAL = 'demo-cli-' || LPAD(1 + MOD(:I, 15), 3, '0')
      INTO :ID_CLI;

    ASESOR = CASE WHEN MOD(I, 2) = 0 THEN 1 ELSE 6 END;
    ESTADO = CASE MOD(I, 10)
      WHEN 0 THEN 'descartada'
      WHEN 1 THEN 'capturada'
      WHEN 2 THEN 'recibida'
      WHEN 3 THEN 'recibida'
      ELSE 'en_cotizacion' END;
    CAPTURA = DATEADD(-(180 - (I * 4)) DAY TO CURRENT_TIMESTAMP);
    DESCR = CASE MOD(I, 6)
      WHEN 0 THEN 'Fabricacion de mesa de trabajo en acero inoxidable'
      WHEN 1 THEN 'Estructura para techo de bodega'
      WHEN 2 THEN 'Porton corredizo con riel y motor'
      WHEN 3 THEN 'Reparacion de tanque de almacenamiento'
      WHEN 4 THEN 'Escalera metalica con baranda'
      ELSE 'Racks para bodega de producto terminado' END;

    INSERT INTO SOLICITUDES (UUID_LOCAL, CLIENTE_ID, ASESOR_ID, DESCRIPCION,
      OBSERVACIONES, FECHA_CAPTURA, FECHA_RECEPCION, ESTADO)
      VALUES ('demo-sol-' || LPAD(:I, 3, '0'), :ID_CLI, :ASESOR, :DESCR,
              'Medidas tomadas en sitio. Cliente pide entrega en dos semanas.',
              :CAPTURA, DATEADD(6 HOUR TO :CAPTURA), :ESTADO)
      RETURNING ID INTO :ID_SOL;

    /* Un croquis con sus trazos, y en la mitad de los casos una foto. El
       contenido es minimo a proposito: aqui interesa que la fila exista. */
    INSERT INTO SOLICITUD_ADJUNTOS (SOLICITUD_ID, UUID_LOCAL, TIPO,
      NOMBRE_ARCHIVO, MIME, TAMANO_BYTES, CONTENIDO_JSON, ACTIVO)
      VALUES (:ID_SOL, 'demo-adj-' || LPAD(:I, 3, '0') || '-c', 'croquis',
              'croquis-' || :I || '.json', 'application/json', 120,
              '{"trazos":[{"x1":10,"y1":10,"x2":120,"y2":10},' ||
              '{"x1":120,"y1":10,"x2":120,"y2":80}],"version":1}', TRUE)
      RETURNING ID INTO :ID_ADJ;

    IF (MOD(I, 2) = 0) THEN
      INSERT INTO SOLICITUD_ADJUNTOS (SOLICITUD_ID, UUID_LOCAL, TIPO,
        NOMBRE_ARCHIVO, MIME, TAMANO_BYTES, CONTENIDO, ACTIVO)
        VALUES (:ID_SOL, 'demo-adj-' || LPAD(:I, 3, '0') || '-f', 'foto',
                'foto-' || :I || '.png', 'image/png', 67,
                /* PNG de 1x1 transparente: 67 bytes, lo minimo que es una
                   imagen valida. */
                CAST(x'89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000A49444154789C63000100000500010D0A2DB40000000049454E44AE426082' AS BLOB SUB_TYPE BINARY),
                TRUE);

    /* De una a tres medidas, atadas al croquis. */
    CUANTAS = 1 + MOD(I, 3);
    J = 1;
    WHILE (J <= CUANTAS) DO
    BEGIN
      INSERT INTO SOLICITUD_MEDIDAS (UUID_LOCAL, SOLICITUD_ID, CROQUIS_ID,
        ETIQUETA, TIPO_MEDIDA, VALOR, UNIDAD_MEDIDA, OBSERVACION, ORDEN)
        VALUES ('demo-med-' || LPAD(:I, 3, '0') || '-' || :J, :ID_SOL, :ID_ADJ,
                CASE :J WHEN 1 THEN 'A' WHEN 2 THEN 'B' ELSE 'C' END,
                CASE :J WHEN 1 THEN 'largo' WHEN 2 THEN 'ancho' ELSE 'alto' END,
                40 + (:I * 3) + (:J * 17), 'cm',
                CASE WHEN :J = 1 THEN 'Medida sobre pared existente' ELSE NULL END,
                :J);
      J = J + 1;
    END
    I = I + 1;
  END
END^

/* ====================  COTIZACIONES Y DETALLE  ====================
   Una por cada solicitud en cotizacion, con lineas de material, mano de obra
   y maquina. Los totales se calculan con lo que se inserto, no a mano. */
EXECUTE BLOCK AS
  DECLARE VARIABLE ID_SOL INTEGER;
  DECLARE VARIABLE ID_CLI INTEGER;
  DECLARE VARIABLE ID_COT INTEGER;
  DECLARE VARIABLE ID_TT INTEGER;
  DECLARE VARIABLE ID_REF INTEGER;
  DECLARE VARIABLE PRECIO NUMERIC(15,2);
  DECLARE VARIABLE CANT NUMERIC(12,3);
  DECLARE VARIABLE I INTEGER;
  DECLARE VARIABLE J INTEGER;
  DECLARE VARIABLE LINEAS INTEGER;
  DECLARE VARIABLE ESTADO VARCHAR(20);
  DECLARE VARIABLE ELABORA INTEGER;
  DECLARE VARIABLE APRUEBA INTEGER;
  DECLARE VARIABLE AJUSTE NUMERIC(5,2);
  DECLARE VARIABLE FECHA TIMESTAMP;
  DECLARE VARIABLE SUB_MAT NUMERIC(15,2);
  DECLARE VARIABLE SUB_MO NUMERIC(15,2);
  DECLARE VARIABLE SUB_MQ NUMERIC(15,2);
  DECLARE VARIABLE COSTO NUMERIC(15,2);
  DECLARE VARIABLE IMPUESTO NUMERIC(15,2);
BEGIN
  I = 0;
  FOR SELECT S.ID, S.CLIENTE_ID, S.FECHA_CAPTURA
        FROM SOLICITUDES S
        WHERE S.UUID_LOCAL STARTING WITH 'demo-sol-'
          AND S.ESTADO = 'en_cotizacion'
        ORDER BY S.ID
        INTO :ID_SOL, :ID_CLI, :FECHA DO
  BEGIN
    I = I + 1;
    /* Estados repartidos: dos borradores, tres pendientes de aprobacion, y el
       resto aprobadas, enviadas o rechazadas. */
    ESTADO = CASE MOD(I, 6)
      WHEN 0 THEN 'borrador'
      WHEN 1 THEN 'pendiente'
      WHEN 2 THEN 'aprobada'
      WHEN 3 THEN 'enviada'
      WHEN 4 THEN 'rechazada'
      ELSE 'aprobada' END;
    ELABORA = CASE WHEN MOD(I, 3) = 0 THEN 3 ELSE 2 END;
    APRUEBA = CASE WHEN :ESTADO IN ('aprobada', 'enviada') THEN
      CASE WHEN MOD(I, 2) = 0 THEN 3 ELSE 4 END ELSE NULL END;
    AJUSTE = CASE WHEN MOD(I, 4) = 0 THEN 7.50 ELSE 0 END;
    /* Rota entre los seis tipos de trabajo de prueba. */
    SELECT T.ID FROM TIPOS_TRABAJO T
      WHERE T.NOMBRE STARTING WITH 'Demo '
      ORDER BY MOD(T.ID + :I, 6), T.ID
      ROWS 1
      INTO :ID_TT;

    INSERT INTO COTIZACIONES (NUMERO, SOLICITUD_ID, CLIENTE_ID, TIPO_TRABAJO_ID,
      DESCRIPCION_TRABAJO, ELABORADA_POR, APROBADA_POR, ESTADO,
      SUBTOTAL_MATERIALES, SUBTOTAL_MANO_OBRA, SUBTOTAL_MAQUINA, COSTO_TOTAL,
      PORCENTAJE_AJUSTE, MOTIVO_AJUSTE, PORCENTAJE_IVA, MONTO_IMPUESTO,
      MONTO_TOTAL, MOTIVO_RECHAZO, FECHA_ELABORACION, FECHA_APROBACION,
      FECHA_ENVIO)
      VALUES (NEXT VALUE FOR GEN_COTIZACION_NUMERO, :ID_SOL, :ID_CLI, :ID_TT,
              'Trabajo cotizado a partir de la solicitud ' || :ID_SOL,
              :ELABORA, :APRUEBA, :ESTADO, 0, 0, 0, 0,
              :AJUSTE,
              CASE WHEN :AJUSTE > 0 THEN 'Trabajo fuera del area metropolitana'
                ELSE NULL END,
              13.00, 0, 0,
              CASE WHEN :ESTADO = 'rechazada' THEN
                'El cliente pidio bajar el alcance del trabajo' ELSE NULL END,
              DATEADD(2 DAY TO :FECHA),
              CASE WHEN :APRUEBA IS NULL THEN NULL
                ELSE DATEADD(4 DAY TO :FECHA) END,
              CASE WHEN :ESTADO = 'enviada' THEN DATEADD(5 DAY TO :FECHA)
                ELSE NULL END)
      RETURNING ID INTO :ID_COT;

    SUB_MAT = 0; SUB_MO = 0; SUB_MQ = 0;
    LINEAS = 3 + MOD(I, 6);
    J = 1;
    WHILE (J <= LINEAS) DO
    BEGIN
      IF (MOD(J, 3) = 1) THEN
      BEGIN
        SELECT M.ID, P.PRECIO_UNITARIO
          FROM MATERIALES M
          JOIN MATERIALES_PRECIOS P ON P.MATERIAL_ID = M.ID AND P.ACTIVO = TRUE
          WHERE M.CODIGO STARTING WITH 'DEMO-MAT-'
          ORDER BY MOD(M.ID + :I + :J, 30), M.ID
          ROWS 1
          INTO :ID_REF, :PRECIO;
        CANT = 2 + MOD(I + J, 9);
        INSERT INTO COTIZACION_DETALLE (COTIZACION_ID, TIPO, MATERIAL_ID,
          DESCRIPCION, UNIDAD_MEDIDA, CANTIDAD, PRECIO_UNITARIO, SUBTOTAL, ORDEN)
          SELECT :ID_COT, 'material', M.ID, M.NOMBRE, M.UNIDAD_MEDIDA, :CANT,
                 :PRECIO, :CANT * :PRECIO, :J
            FROM MATERIALES M WHERE M.ID = :ID_REF;
        SUB_MAT = SUB_MAT + (CANT * PRECIO);
      END
      ELSE IF (MOD(J, 3) = 2) THEN
      BEGIN
        SELECT O.ID, P.COSTO_UNITARIO
          FROM MANO_OBRA O
          JOIN MANO_OBRA_PRECIOS P ON P.MANO_OBRA_ID = O.ID AND P.ACTIVO = TRUE
          WHERE O.CODIGO STARTING WITH 'DEMO-MO-'
          ORDER BY MOD(O.ID + :I + :J, 12), O.ID
          ROWS 1
          INTO :ID_REF, :PRECIO;
        CANT = 1 + MOD(I + J, 6);
        INSERT INTO COTIZACION_DETALLE (COTIZACION_ID, TIPO, MANO_OBRA_ID,
          DESCRIPCION, UNIDAD_MEDIDA, CANTIDAD, PRECIO_UNITARIO, SUBTOTAL, ORDEN)
          SELECT :ID_COT, 'mano_obra', O.ID, O.DESCRIPCION, O.UNIDAD_MEDIDA,
                 :CANT, :PRECIO, :CANT * :PRECIO, :J
            FROM MANO_OBRA O WHERE O.ID = :ID_REF;
        SUB_MO = SUB_MO + (CANT * PRECIO);
      END
      ELSE
      BEGIN
        SELECT Q.ID, P.COSTO_HORA
          FROM MAQUINAS Q
          JOIN MAQUINAS_PRECIOS P ON P.MAQUINA_ID = Q.ID AND P.ACTIVO = TRUE
          WHERE Q.CODIGO STARTING WITH 'DEMO-MQ-'
          ORDER BY MOD(Q.ID + :I + :J, 8), Q.ID
          ROWS 1
          INTO :ID_REF, :PRECIO;
        CANT = 1 + MOD(I + J, 4);
        INSERT INTO COTIZACION_DETALLE (COTIZACION_ID, TIPO, MAQUINA_ID,
          DESCRIPCION, UNIDAD_MEDIDA, CANTIDAD, PRECIO_UNITARIO, SUBTOTAL, ORDEN)
          SELECT :ID_COT, 'maquina', Q.ID, Q.NOMBRE, 'hora', :CANT, :PRECIO,
                 :CANT * :PRECIO, :J
            FROM MAQUINAS Q WHERE Q.ID = :ID_REF;
        SUB_MQ = SUB_MQ + (CANT * PRECIO);
      END
      J = J + 1;
    END

    /* Una nota al final, que no suma. */
    INSERT INTO COTIZACION_DETALLE (COTIZACION_ID, TIPO, DESCRIPCION, CANTIDAD,
      PRECIO_UNITARIO, SUBTOTAL, ORDEN)
      VALUES (:ID_COT, 'nota',
              'Precio valido por 15 dias. No incluye instalacion en sitio.',
              0, 0, 0, :LINEAS + 1);

    COSTO = SUB_MAT + SUB_MO + SUB_MQ;
    COSTO = COSTO + (COSTO * AJUSTE / 100);
    IMPUESTO = COSTO * 0.13;

    UPDATE COTIZACIONES SET
      SUBTOTAL_MATERIALES = :SUB_MAT,
      SUBTOTAL_MANO_OBRA  = :SUB_MO,
      SUBTOTAL_MAQUINA    = :SUB_MQ,
      COSTO_TOTAL         = :COSTO,
      MONTO_IMPUESTO      = :IMPUESTO,
      MONTO_TOTAL         = :COSTO + :IMPUESTO
      WHERE ID = :ID_COT;
  END
END^

SET TERM ; ^

COMMIT;

/* ====================  RESUMEN  ==================== */
SELECT 'CLIENTES' AS TABLA, COUNT(*) AS FILAS FROM CLIENTES
UNION ALL SELECT 'CLIENTE_CONTACTOS', COUNT(*) FROM CLIENTE_CONTACTOS
UNION ALL SELECT 'CONSENTIMIENTO_HISTORIAL', COUNT(*) FROM CLIENTE_CONSENTIMIENTO_HISTORIAL
UNION ALL SELECT 'MATERIALES', COUNT(*) FROM MATERIALES
UNION ALL SELECT 'MATERIALES_PRECIOS', COUNT(*) FROM MATERIALES_PRECIOS
UNION ALL SELECT 'MANO_OBRA', COUNT(*) FROM MANO_OBRA
UNION ALL SELECT 'MAQUINAS', COUNT(*) FROM MAQUINAS
UNION ALL SELECT 'TIPOS_TRABAJO', COUNT(*) FROM TIPOS_TRABAJO
UNION ALL SELECT 'SOLICITUDES', COUNT(*) FROM SOLICITUDES
UNION ALL SELECT 'SOLICITUD_ADJUNTOS', COUNT(*) FROM SOLICITUD_ADJUNTOS
UNION ALL SELECT 'SOLICITUD_MEDIDAS', COUNT(*) FROM SOLICITUD_MEDIDAS
UNION ALL SELECT 'COTIZACIONES', COUNT(*) FROM COTIZACIONES
UNION ALL SELECT 'COTIZACION_DETALLE', COUNT(*) FROM COTIZACION_DETALLE
UNION ALL SELECT 'AUDITORIA', COUNT(*) FROM AUDITORIA;
