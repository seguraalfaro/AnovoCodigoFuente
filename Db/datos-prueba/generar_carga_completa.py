# Genera carga_completa.sql: usuarios, catalogos, 15 clientes, 25 solicitudes
# y cotizaciones en todos los estados, con cada campo lleno.
# Uso: python generar_carga_completa.py  (escribe junto a este archivo)

import hashlib
import json
import uuid
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path

AQUI = Path(__file__).parent
IMAGENES = AQUI / 'imagenes'
SALIDA = AQUI / 'carga_completa.sql'
SEMILLA = uuid.UUID('6b1f0c1e-2d7a-4c35-9a1e-5f0b8d7c2e41')

COLOR_TRAZO = -14935010
COLOR_COTA = -15763858
IVA = Decimal('13')
DOS = Decimal('0.01')

out = []


def w(texto=''):
    out.append(texto)


def uid(*partes):
    return str(uuid.uuid5(SEMILLA, '/'.join(str(p) for p in partes)))


def q(texto):
    if texto is None:
        return 'NULL'
    return "'" + str(texto).replace("'", "''") + "'"


def hace(dias, horas=0, minutos=0):
    total = dias * 1440 + horas * 60 + minutos
    return f'DATEADD(-{total} MINUTE TO CURRENT_TIMESTAMP)'


def usuario(correo):
    return f"(SELECT ID FROM USUARIOS WHERE CORREO = {q(correo)})"


def por_uuid(tabla, valor):
    return f"(SELECT ID FROM {tabla} WHERE UUID_LOCAL = {q(valor)})"


def contexto(correo, detalle):
    w(f"SELECT RDB$SET_CONTEXT('USER_SESSION', 'USUARIO_ID', {usuario(correo)}) "
      'FROM RDB$DATABASE;')
    w(f"SELECT RDB$SET_CONTEXT('USER_SESSION', 'DETALLE', {q(detalle)}) "
      'FROM RDB$DATABASE;')


def redondear(valor):
    return Decimal(valor).quantize(DOS, ROUND_HALF_UP)


SISTEMA = 'sistema@anovo.local'

USUARIOS = [
    ('asesor@anovo.test', 'Ana Asesora', 1),
    ('asesor2@anovo.test', 'Bruno Asesor', 1),
    ('asesor3@anovo.test', 'Irene Asesora', 1),
    ('asesor4@anovo.test', 'Jorge Asesor', 1),
    ('asesor5@anovo.test', 'Karen Asesora', 1),
    ('asistente@anovo.test', 'Beto Asistente', 2),
    ('asistente2@anovo.test', 'Pablo Asistente', 2),
    ('supervisor@anovo.test', 'Carla Supervisora', 3),
    ('supervisor2@anovo.test', 'Luis Supervisor', 3),
    ('gerencia@anovo.test', 'Diego Gerente', 4),
    ('admin@anovo.test', 'Eva Admin', 5),
]
ASESORES = [u[0] for u in USUARIOS if u[2] == 1]
ASISTENTES = [u[0] for u in USUARIOS if u[2] == 2]
SUPERVISORES = [u[0] for u in USUARIOS if u[2] == 3]
ANTERIORES = {'provisional@anovo.test': 'asistente2@anovo.test',
              'inactivo@anovo.test': 'asesor3@anovo.test'}

FORMAS_PAGO = ['Contado contra entrega', '50% de adelanto y 50% contra entrega',
               'Credito a 30 dias', 'Transferencia bancaria a 15 dias']
TIPOS_MATERIAL = ['Acero inoxidable', 'Hierro negro', 'Acero galvanizado',
                  'Aluminio', 'Bronce']
ACABADOS = ['Sin acabado', 'Pintura anticorrosiva', 'Pintura electrostatica',
            'Galvanizado en caliente', 'Pulido espejo']
TIPOS_TRABAJO_NUEVOS = ['Estructura metalica', 'Porton y reja',
                        'Mueble de acero inoxidable', 'Tanque y deposito']

MATERIALES = [
    ('MAT-001', 'Lamina acero inox 304 1.5mm', 'Lamina 1220x2440 mm', 'lamina', 'Acero inoxidable', 45000, 62000),
    ('MAT-002', 'Tubo redondo acero 1 pulgada', 'Tubo de 6 m, pared 1.5 mm', 'tubo', 'Hierro negro', 8500, 12000),
    ('MAT-003', 'Lamina acero negro calibre 14', 'Lamina 1220x2440 mm', 'lamina', 'Hierro negro', 31500, 42500),
    ('MAT-004', 'Lamina galvanizada calibre 20', 'Lamina 1220x2440 mm', 'lamina', 'Acero galvanizado', 21400, 28900),
    ('MAT-005', 'Tubo cuadrado 2x2 pulg chapa 16', 'Tubo de 6 m', 'tubo', 'Hierro negro', 14200, 19200),
    ('MAT-006', 'Tubo rectangular 1x2 pulg chapa 18', 'Tubo de 6 m', 'tubo', 'Hierro negro', 9800, 13300),
    ('MAT-007', 'Angular 1-1/2 x 1/8 pulg', 'Perfil de 6 m', 'tubo', 'Hierro negro', 8900, 12000),
    ('MAT-008', 'Platina 2 x 1/4 pulg', 'Platina de 6 m', 'tubo', 'Hierro negro', 11200, 15100),
    ('MAT-009', 'Tubo inox 304 1-1/2 pulg', 'Tubo pulido de 6 m', 'tubo', 'Acero inoxidable', 38500, 52000),
    ('MAT-010', 'Lamina aluminio 1/8 pulg', 'Lamina 1220x2440 mm', 'lamina', 'Aluminio', 64000, 86400),
    ('MAT-011', 'Electrodo 6013 de 1/8', 'Caja de soldadura', 'kilogramo', 'Hierro negro', 4100, 5600),
    ('MAT-012', 'Alambre MIG ER70S-6 0.9 mm', 'Rollo para soldadora MIG', 'kilogramo', 'Hierro negro', 3900, 5300),
    ('MAT-013', 'Pintura anticorrosiva gris', 'Galon de base', 'litro', 'Hierro negro', 6800, 9200),
    ('MAT-014', 'Riel para porton corredizo', 'Riel en V de 6 m', 'metro', 'Hierro negro', 5200, 7000),
    ('MAT-015', 'Rodaja en V 4 pulg', 'Rodaja con rodamiento', 'unidad', 'Hierro negro', 7400, 10000),
    ('MAT-016', 'Bisagra de pivote pesada', 'Juego para porton', 'unidad', 'Hierro negro', 12500, 16900),
]
MANO_OBRA = [
    ('MO-001', 2, 'Soldadura MIG', 'Soldadura MIG en estructura', 9500),
    ('MO-002', 1, 'Corte con cizalla', 'Corte recto de lamina con cizalla', 6200),
    ('MO-003', 1, 'Corte con plasma', 'Corte de perfil con plasma manual', 7800),
    ('MO-004', 2, 'Soldadura TIG inox', 'Soldadura TIG en acero inoxidable', 12800),
    ('MO-005', 3, 'Doblado en prensa', 'Doblado de lamina en prensa hidraulica', 7100),
    ('MO-006', 4, 'Pintura electrostatica', 'Aplicacion de pintura en polvo', 6900),
    ('MO-007', 5, 'Ensamblaje en taller', 'Armado de piezas y ajuste', 6500),
    ('MO-008', 5, 'Instalacion en sitio', 'Montaje e instalacion en sitio del cliente', 8800),
    ('MO-009', 6, 'Pulido y acabado', 'Pulido de soldaduras y acabado final', 6100),
]
MAQUINAS = [
    ('MAQ-001', 'Dobladora hidraulica', 'Prensa dobladora de 3 m', 14500),
    ('MAQ-002', 'Cortadora laser CNC', 'Mesa de 1.5 x 3 m', 28500),
    ('MAQ-003', 'Cizalla guillotina', 'Corte de lamina hasta 6 mm', 11800),
    ('MAQ-004', 'Roladora de lamina', 'Rolado de lamina y tubo', 12900),
    ('MAQ-005', 'Soldadora MIG 350 A', 'Equipo de soldadura con alimentador', 6800),
    ('MAQ-006', 'Cabina de pintura', 'Cabina con horno de curado', 15600),
]

CLIENTES = [
    ('Metalmecanica Sanchez S.A.', 2, '3101452871', '2438-5120', 'compras@metalsanchez.test', 'El Coyol, Alajuela, 300 m oeste del parque industrial', 10.0021, -84.2706, 'Maribel Sanchez', None),
    ('Estructuras del Valle S.A.', 2, '3101398114', '2552-7410', 'proyectos@estvalle.test', 'Zona Industrial, Cartago, frente a la planta de tratamiento', 9.8644, -83.9194, 'Rodrigo Valle', None),
    ('Comercializadora Quesada S.A.', 2, '3101624503', '2460-3381', 'pagos@cquesada.test', 'Ciudad Quesada, San Carlos, 200 m sur de la catedral', 10.3238, -84.4271, 'Lucia Quesada', None),
    ('Inversiones Cordero S.A.', 2, '3101287765', '2290-6612', 'administracion@icordero.test', 'La Uruca, San Jose, contiguo a la bomba', 9.9527, -84.1050, 'Esteban Cordero', None),
    ('Taller Industrial Mora S.A.', 2, '3101511236', '2263-4478', 'taller@tmora.test', 'San Rafael, Heredia, 100 m norte de la escuela', 10.0124, -84.1001, 'Patricia Mora', None),
    ('Hospital Privado del Este S.A.', 2, '3101734119', '2272-9900', 'mantenimiento@hpeste.test', 'Curridabat, San Jose, sobre la ruta 2', 9.9127, -84.0358, 'Gabriel Solis', 'AL-00118-2026'),
    ('Agroindustrial Oreamuno S.A.', 2, '3101809452', '2536-1188', 'operaciones@agrooreamuno.test', 'San Rafael de Oreamuno, Cartago, finca La Pastora', 9.8820, -83.8995, 'Andrea Oreamuno', None),
    ('Bodegas Jimenez S.A.', 2, '3101345927', '2643-7720', 'logistica@bjimenez.test', 'Puntarenas centro, 50 m este del muelle', 9.9762, -84.8338, 'Carlos Jimenez', None),
    ('Fundacion Educativa Monte Sion', 2, '3006278341', '2234-5566', 'finanzas@montesion.test', 'San Pedro, Montes de Oca, 75 m sur del templo', 9.9347, -84.0510, 'Silvia Arguedas', 'EX-2026-00452'),
    ('Panaderia La Espiga Dorada S.A.', 2, '3101902216', '2440-2290', 'gerencia@laespiga.test', 'Alajuela centro, costado norte del mercado', 10.0163, -84.2132, 'Hector Alfaro', None),
    ('Maria Fernanda Rojas Vargas', 1, '113450678', '8834-2219', 'mfrojas@correo.test', 'Santa Ana, San Jose, residencial Los Robles casa 14', 9.9326, -84.1827, 'Maria Fernanda Rojas', None),
    ('Jose Pablo Mena Ulate', 1, '204560789', '8712-6634', 'jpmena@correo.test', 'Grecia, Alajuela, 400 m oeste de la iglesia', 10.0730, -84.3115, 'Jose Pablo Mena', None),
    ('Adriana Leon Castro', 1, '304120956', '8890-1145', 'aleon@correo.test', 'Tres Rios, La Union, condominio Vista Real 8', 9.9081, -83.9864, 'Adriana Leon', None),
    ('Mauricio Chaves Brenes', 3, '186200451237', '8645-7781', 'mchaves@correo.test', 'Escazu, San Jose, calle Los Laureles 22', 9.9189, -84.1395, 'Mauricio Chaves', None),
    ('Cooperativa Agricola Atenas R.L.', 2, '3004112389', '2446-5070', 'cooperativa@coopatenas.test', 'Atenas, Alajuela, carretera a Jesus Maria km 2', 9.9787, -84.3784, 'Ricardo Alvarado', 'EX-2026-00931'),
]
AREAS = ['Compras', 'Mantenimiento', 'Produccion', 'Administracion', 'Proyectos']
PERSONAS = ['Marta Rojas', 'Luis Vargas', 'Sofia Campos', 'Randall Solis', 'Karla Ugalde',
            'Jose Pablo Mena', 'Adriana Leon', 'Mauricio Chaves', 'Daniela Segura', 'Felipe Araya',
            'Gabriela Mora', 'Alonso Picado', 'Natalia Zuniga', 'Diego Brenes', 'Valeria Soto']

PROYECTOS = [
    ('Techo de bodega norte', 'Estructura para techo de bodega de 12 x 20 m con cerchas de tubo cuadrado', 'Acceso por porton lateral. El cliente pide trabajar en horario nocturno.', [('Cercha principal', 'Estructura metalica', 'Hierro negro', 'Pintura anticorrosiva'), ('Largueros', 'Estructura metalica', 'Acero galvanizado', 'Sin acabado')]),
    ('Porton corredizo de entrada', 'Porton corredizo con riel, rodajas y motor para la entrada principal', 'Medir de nuevo el desnivel del piso antes de fabricar.', [('Hoja del porton', 'Porton y reja', 'Hierro negro', 'Pintura electrostatica'), ('Riel y soportes', 'Porton y reja', 'Hierro negro', 'Galvanizado en caliente')]),
    ('Mesas de acero para cocina', 'Dos mesas de trabajo en acero inoxidable con entrepano y salpicadero', 'Las mesas entran por una puerta de 90 cm.', [('Mesa de preparacion', 'Mueble de acero inoxidable', 'Acero inoxidable', 'Pulido espejo'), ('Mesa de emplatado', 'Mueble de acero inoxidable', 'Acero inoxidable', 'Pulido espejo')]),
    ('Reparacion de tanque de agua', 'Reparacion de fugas y refuerzo del tanque de almacenamiento de 5000 L', 'El tanque se vacia el dia anterior. Llevar escalera de 6 m.', [('Cuerpo del tanque', 'Tanque y deposito', 'Acero galvanizado', 'Pintura anticorrosiva'), ('Base de soporte', 'Reparacion', 'Hierro negro', 'Pintura anticorrosiva')]),
    ('Escalera de acceso a mezzanine', 'Escalera metalica recta con baranda y huellas antideslizantes', 'Altura de piso a mezzanine 3.20 m.', [('Zancas y huellas', 'Estructura metalica', 'Hierro negro', 'Pintura electrostatica'), ('Baranda', 'Estructura metalica', 'Acero inoxidable', 'Pulido espejo')]),
    ('Racks de producto terminado', 'Racks de carga mediana para bodega de producto terminado', 'Cada nivel soporta 500 kg. Seis modulos.', [('Marcos laterales', 'Fabricacion', 'Hierro negro', 'Pintura electrostatica'), ('Vigas de carga', 'Fabricacion', 'Hierro negro', 'Pintura electrostatica')]),
    ('Rejas de seguridad', 'Rejas para cuatro ventanas y una puerta de servicio', 'Diseno sencillo de barrotes verticales.', [('Rejas de ventana', 'Porton y reja', 'Hierro negro', 'Pintura anticorrosiva'), ('Reja de puerta', 'Porton y reja', 'Hierro negro', 'Pintura anticorrosiva')]),
    ('Mantenimiento de estructura de rotulo', 'Revision, limpieza y pintura de la estructura del rotulo exterior', 'Rotulo a 8 m de altura, requiere andamio.', [('Columna del rotulo', 'Mantenimiento', 'Hierro negro', 'Pintura anticorrosiva'), ('Marco del rotulo', 'Mantenimiento', 'Aluminio', 'Pintura electrostatica')]),
]


def croquis(pieza_uuid, medidas, variante):
    ancho = 520 + variante * 40
    alto = 260 + variante * 20
    x0, y0 = 140, 160
    trazos = [
        {'id': 1, 'tipo': 'libre', 'color': COLOR_TRAZO, 'grosor': 6,
         'puntos': [[x0, y0], [x0 + ancho, y0], [x0 + ancho, y0 + alto], [x0, y0 + alto], [x0, y0]]},
        {'id': 2, 'tipo': 'libre', 'color': COLOR_TRAZO, 'grosor': 6,
         'puntos': [[x0 + ancho // 3, y0], [x0 + ancho // 3, y0 + alto]]},
        {'id': 3, 'tipo': 'libre', 'color': COLOR_TRAZO, 'grosor': 6,
         'puntos': [[x0 + 2 * ancho // 3, y0], [x0 + 2 * ancho // 3, y0 + alto]]},
    ]
    posiciones = [
        [[x0, y0 + alto + 60], [x0 + ancho, y0 + alto + 60]],
        [[x0 + ancho + 60, y0], [x0 + ancho + 60, y0 + alto]],
        [[x0, y0 - 60], [x0 + ancho // 3, y0 - 60]],
    ]
    for i, m in enumerate(medidas):
        trazos.append({'id': 4 + i, 'tipo': 'cota', 'color': COLOR_COTA, 'grosor': 6,
                       'forma': 'lineal', 'etiqueta': m['etiqueta'], 'medida': m['tipo'],
                       'valor': m['valor'], 'unidad': 'cm', 'cantidad': m['cantidad'],
                       'puntos': posiciones[i]})
    return json.dumps({'version': 3, 'rejilla': 'iso', 'unidad_celda_m': 0.5,
                       'arista_px': 51, 'trazos': trazos}, separators=(',', ':'))


def hexa(ruta):
    datos = ruta.read_bytes()
    return datos.hex().upper(), len(datos), hashlib.sha256(datos).hexdigest()


w("""/* ============================================================================
   Anovo - Carga completa de datos de prueba  (Firebird 4.0)
   ----------------------------------------------------------------------------
   NUNCA EN PRODUCCION. Se corre sobre una base recien creada con
   esquema/anovo_completo.sql. Generado por generar_carga_completa.py: no se
   edita a mano, se cambia el generador y se vuelve a generar.

   Deja once usuarios (cinco asesores, dos asistentes, dos supervisores, un
   gerente y uno de TI), catalogos con precio, quince clientes con todos los
   campos, dos contactos cada uno y su consentimiento firmado, cinco
   solicitudes por asesor con piezas, croquis, fotos y medidas, y cotizaciones
   en los ocho estados con su historial.

   Las claves no van aqui: las cuentas quedan con el marcador
   PENDIENTE-REGENERAR y despues se corre claves_prueba.sql.
   ============================================================================ */
""")
contexto(SISTEMA, 'datos de prueba: carga completa')
w()

w('/* Lo que trae el bloque B del tramo 02: clientes de ejemplo sin uso. */')
w('DELETE FROM CLIENTE_CONSENTIMIENTO_HISTORIAL;')
w('DELETE FROM CLIENTE_CONTACTOS;')
w('DELETE FROM CLIENTES;')
w('COMMIT;')
w()

for nombre in FORMAS_PAGO:
    w(f'UPDATE OR INSERT INTO FORMAS_PAGO (NOMBRE, ACTIVO) VALUES ({q(nombre)}, TRUE) MATCHING (NOMBRE);')
for nombre in TIPOS_MATERIAL:
    w(f'UPDATE OR INSERT INTO TIPOS_MATERIAL (NOMBRE, ACTIVO) VALUES ({q(nombre)}, TRUE) MATCHING (NOMBRE);')
for nombre in ACABADOS:
    w(f'UPDATE OR INSERT INTO ACABADOS (NOMBRE, ACTIVO) VALUES ({q(nombre)}, TRUE) MATCHING (NOMBRE);')
for nombre in TIPOS_TRABAJO_NUEVOS:
    w(f'UPDATE OR INSERT INTO TIPOS_TRABAJO (NOMBRE, ACTIVO) VALUES ({q(nombre)}, TRUE) MATCHING (NOMBRE);')
w('COMMIT;')
w()

w(f"""UPDATE EMPRESA SET
  RAZON_SOCIAL = 'Anovo Soluciones Metalmecanicas S.A.',
  CEDULA_JURIDICA = '3101765432',
  DIRECCION = 'Zona Industrial de Pavas, San Jose, 400 m sur de la Embajada Americana',
  TELEFONO_FIJO = '2231-4400',
  CELULAR = '8890-4400',
  CORREO = 'cotizaciones@anovo.test',
  REPRESENTANTE_LEGAL = 'Diego Gerente',
  CUENTA_BANCARIA = 'CR05015202001026284066',
  PORCENTAJE_IVA = 13,
  DIAS_SIN_RESPUESTA = 7,
  FIRMANTE = 'Carla Supervisora',
  CARTA_PRESENTACION = 'Estimado cliente: de acuerdo con su solicitud, le presentamos la cotizacion de los trabajos descritos. Quedamos atentos a cualquier consulta.',
  FORMA_PAGO_ID = (SELECT ID FROM FORMAS_PAGO WHERE NOMBRE = {q(FORMAS_PAGO[1])}),
  PLAZO_ENTREGA_CANTIDAD = 15, PLAZO_ENTREGA_UNIDAD = 'dias_habiles',
  GARANTIA_CANTIDAD = 6, GARANTIA_UNIDAD = 'meses';""")
w()

w("""UPDATE CONSENTIMIENTO_TEXTOS SET VIGENTE = FALSE WHERE VIGENTE = TRUE;
INSERT INTO CONSENTIMIENTO_TEXTOS (VERSION, TITULO, CONTENIDO, VIGENTE, VIGENTE_DESDE, PUBLICADO_POR)
VALUES ('1.0', 'Consentimiento informado para el tratamiento de datos personales',
  'TEXTO DE PRUEBA, NO ES EL TEXTO LEGAL DE ANOVO.' || ASCII_CHAR(10) || ASCII_CHAR(10) ||
  '1. Sus datos se guardan en la base de datos de clientes de Anovo.' || ASCII_CHAR(10) ||
  '2. Se usan para preparar, enviar y dar seguimiento a cotizaciones.' || ASCII_CHAR(10) ||
  '3. Los consultan el asesor, el personal de cotizaciones y la supervision.' || ASCII_CHAR(10) ||
  '4. Dar los datos es voluntario; sin ellos no se puede preparar la cotizacion.' || ASCII_CHAR(10) ||
  '5. Puede pedir acceso, rectificacion o supresion de sus datos.' || ASCII_CHAR(10) ||
  '6. Puede revocar este consentimiento en cualquier momento.',
  TRUE, """ + hace(150) + """, (SELECT ID FROM USUARIOS WHERE CORREO = 'admin@anovo.test'));""")
w('COMMIT;')
w()

for cod, nombre, desc, unidad, tipo, costo, precio in MATERIALES:
    w(f"UPDATE OR INSERT INTO MATERIALES (CODIGO, NOMBRE, DESCRIPCION, UNIDAD_MEDIDA_ID, TIPO_MATERIAL_ID, ACTIVO) VALUES "
      f"({q(cod)}, {q(nombre)}, {q(desc)}, (SELECT ID FROM UNIDADES_MEDIDA WHERE NOMBRE = {q(unidad)}), "
      f"(SELECT ID FROM TIPOS_MATERIAL WHERE NOMBRE = {q(tipo)}), TRUE) MATCHING (CODIGO);")
w('UPDATE MATERIALES_PRECIOS SET ACTIVO = FALSE;')
for cod, nombre, desc, unidad, tipo, costo, precio in MATERIALES:
    w(f"INSERT INTO MATERIALES_PRECIOS (MATERIAL_ID, COSTO_UNITARIO, PRECIO_UNITARIO, ACTIVO, FECHA_VIGENCIA, MODIFICADO_POR) "
      f"VALUES ((SELECT ID FROM MATERIALES WHERE CODIGO = {q(cod)}), {redondear(costo * Decimal('0.93'))}, "
      f"{redondear(precio * Decimal('0.93'))}, FALSE, {hace(200)}, {usuario('supervisor@anovo.test')});")
    w(f"INSERT INTO MATERIALES_PRECIOS (MATERIAL_ID, COSTO_UNITARIO, PRECIO_UNITARIO, ACTIVO, FECHA_VIGENCIA, MODIFICADO_POR) "
      f"VALUES ((SELECT ID FROM MATERIALES WHERE CODIGO = {q(cod)}), {costo}, {precio}, TRUE, {hace(130)}, "
      f"{usuario('supervisor@anovo.test')});")
for cod, cat, nombre, desc, costo in MANO_OBRA:
    w(f"UPDATE OR INSERT INTO MANO_OBRA (CODIGO, CATEGORIA_ID, NOMBRE, DESCRIPCION, UNIDAD_MEDIDA_ID, ACTIVO) VALUES "
      f"({q(cod)}, {cat}, {q(nombre)}, {q(desc)}, (SELECT ID FROM UNIDADES_MEDIDA WHERE NOMBRE = 'hora'), TRUE) MATCHING (CODIGO);")
w('UPDATE MANO_OBRA_PRECIOS SET ACTIVO = FALSE;')
for cod, cat, nombre, desc, costo in MANO_OBRA:
    w(f"INSERT INTO MANO_OBRA_PRECIOS (MANO_OBRA_ID, COSTO_UNITARIO, ACTIVO, FECHA_VIGENCIA, MODIFICADO_POR) "
      f"VALUES ((SELECT ID FROM MANO_OBRA WHERE CODIGO = {q(cod)}), {costo}, TRUE, {hace(130)}, {usuario('supervisor@anovo.test')});")
for cod, nombre, desc, costo in MAQUINAS:
    w(f"UPDATE OR INSERT INTO MAQUINAS (CODIGO, NOMBRE, DESCRIPCION, ACTIVO) VALUES "
      f"({q(cod)}, {q(nombre)}, {q(desc)}, TRUE) MATCHING (CODIGO);")
w('UPDATE MAQUINAS_PRECIOS SET ACTIVO = FALSE;')
for cod, nombre, desc, costo in MAQUINAS:
    w(f"INSERT INTO MAQUINAS_PRECIOS (MAQUINA_ID, COSTO_HORA, ACTIVO, FECHA_VIGENCIA, MODIFICADO_POR) "
      f"VALUES ((SELECT ID FROM MAQUINAS WHERE CODIGO = {q(cod)}), {costo}, TRUE, {hace(130)}, {usuario('supervisor@anovo.test')});")
w('COMMIT;')
w()

for viejo, nuevo in ANTERIORES.items():
    nombre = next(u[1] for u in USUARIOS if u[0] == nuevo)
    rol = next(u[2] for u in USUARIOS if u[0] == nuevo)
    w(f"UPDATE USUARIOS SET CORREO = {q(nuevo)}, NOMBRE = {q(nombre)}, ROL_ID = {rol}, ACTIVO = TRUE, "
      f"DEBE_CAMBIAR_CLAVE = FALSE WHERE CORREO = {q(viejo)};")
for correo, nombre, rol in USUARIOS:
    w(f"UPDATE OR INSERT INTO USUARIOS (CORREO, NOMBRE, ROL_ID, ACTIVO, DEBE_CAMBIAR_CLAVE) VALUES "
      f"({q(correo)}, {q(nombre)}, {rol}, TRUE, FALSE) MATCHING (CORREO);")
    w(f"INSERT INTO USUARIOS_CLAVES (USUARIO_ID, CLAVE_HASH, ACTIVO) SELECT {usuario(correo)}, 'PENDIENTE-REGENERAR', TRUE "
      f"FROM RDB$DATABASE WHERE NOT EXISTS (SELECT 1 FROM USUARIOS_CLAVES WHERE ACTIVO = TRUE AND USUARIO_ID = {usuario(correo)});")
w('COMMIT;')
w()

firmas = [hexa(IMAGENES / f'firma{i}.png') for i in (1, 2, 3)]
for i, (nombre, tipo, ident, tel, correo, dire, lat, lon, cobros, exo) in enumerate(CLIENTES):
    cli = uid('cliente', i)
    firma_dias = 140 - i * 7
    asesor = ASESORES[i % 5]
    contexto(asesor, f'datos de prueba: cliente {nombre}')
    w(f"INSERT INTO CLIENTES (UUID_LOCAL, NOMBRE, TIPO_IDENTIFICACION, IDENTIFICACION, TELEFONO, CORREO, DIRECCION, "
      f"LATITUD, LONGITUD, ACTIVO, EXONERADO, CODIGO_EXONERACION, CONSENTIMIENTO_ESTADO, CONSENTIMIENTO_FECHA, "
      f"CONSENTIMIENTO_VERSION, CONTACTO, FECHA_CREACION, FECHA_MODIFICACION) VALUES ({q(cli)}, {q(nombre)}, {tipo}, "
      f"{q(ident)}, {q(tel)}, {q(correo)}, {q(dire)}, {lat}, {lon}, TRUE, {'TRUE' if exo else 'FALSE'}, {q(exo)}, "
      f"'firmado', {hace(firma_dias)}, '1.0', {q(cobros)}, {hace(firma_dias)}, {hace(firma_dias)});")
    for j in range(2):
        con = uid('contacto', i, j)
        persona = cobros if (j == 0 and tipo != 2) else PERSONAS[(i * 2 + j) % len(PERSONAS)]
        dominio = correo.split('@')[1]
        usuario_correo = persona.lower().replace(' ', '.')
        w(f"INSERT INTO CLIENTE_CONTACTOS (UUID_LOCAL, CLIENTE_ID, NOMBRE, AREA, TELEFONO, CELULAR, CORREO, PRINCIPAL, "
          f"CONSENTIMIENTO_ESTADO, CONSENTIMIENTO_FECHA, CONSENTIMIENTO_VERSION, ACTIVO, FECHA_CREACION, FECHA_MODIFICACION) "
          f"VALUES ({q(con)}, {por_uuid('CLIENTES', cli)}, {q(persona)}, {q(AREAS[(i + j) % len(AREAS)])}, "
          f"{q(tel[:5] + str(1000 + i * 37 + j * 11)[-4:])}, {q('8' + str(300 + i * 17 + j)[-3:] + '-' + str(4000 + i * 53 + j * 7)[-4:])}, "
          f"{q(usuario_correo + '@' + dominio)}, {'TRUE' if j == 0 else 'FALSE'}, 'firmado', {hace(firma_dias)}, '1.0', TRUE, "
          f"{hace(firma_dias)}, {hace(firma_dias)});")
        datos, largo, _ = firmas[(i + j) % 3]
        w(f"INSERT INTO CLIENTE_CONSENTIMIENTO_HISTORIAL (CLIENTE_ID, CLIENTE_CONTACTO_ID, ACCION, VERSION_TEXTO, FECHA, "
          f"FIRMANTE_NOMBRE, FIRMANTE_IDENTIFICACION, FIRMA_IMAGEN, FIRMA_MIME, ORIGEN) VALUES ({por_uuid('CLIENTES', cli)}, "
          f"{por_uuid('CLIENTE_CONTACTOS', con)}, 'otorgado', '1.0', {hace(firma_dias)}, {q(persona)}, "
          f"{q(str(100000000 + i * 1234567 + j * 98765)[:9])}, x'{datos}', 'image/png', 'movil');")
    w('COMMIT;')
w()

fotos = [hexa(IMAGENES / f'foto{i}.jpg') for i in range(1, 9)]
primera_foto = {}
ESTADOS_COT = ['borrador', 'pendiente', 'devuelta', 'visto_bueno', 'enviada', 'aprobada', 'rechazada', 'descartada',
               'enviada', 'aprobada', 'borrador', 'pendiente', 'devuelta', 'visto_bueno', 'enviada', 'aprobada', 'rechazada']
solicitudes = []
for a, asesor in enumerate(ASESORES):
    for k in range(5):
        n = a * 5 + k
        solicitudes.append({'n': n, 'asesor': asesor, 'cliente': (n * 4 + a) % 15,
                            'proyecto': PROYECTOS[(n * 3 + k) % len(PROYECTOS)],
                            'dias': [1, 8, 15, 45, 90][k] + a})
orden_cot = [s['n'] for s in sorted(solicitudes, key=lambda s: -s['dias'])]
asignadas = {}
libres = [n for n in orden_cot]
for estado in sorted(ESTADOS_COT, key=lambda e: e in ('borrador', 'pendiente')):
    candidato = next(n for n in libres if (estado not in ('borrador', 'pendiente') or solicitudes[n]['dias'] < 20)
                     and (estado in ('borrador', 'pendiente') or solicitudes[n]['dias'] >= 12))
    libres.remove(candidato)
    asignadas[candidato] = estado
descartada_sol = libres[0]

for s in solicitudes:
    n = s['n']
    proyecto, descripcion, observaciones, piezas = s['proyecto']
    cli = uid('cliente', s['cliente'])
    con = uid('contacto', s['cliente'], n % 2)
    sol = uid('solicitud', n)
    s['uuid'] = sol
    if n in asignadas:
        estado = 'en_cotizacion'
    elif n == descartada_sol:
        estado = 'descartada'
    else:
        estado = 'recibida'
    contexto(s['asesor'], f'datos de prueba: solicitud {proyecto}')
    w(f"INSERT INTO SOLICITUDES (UUID_LOCAL, CLIENTE_ID, CLIENTE_CONTACTO_ID, ASESOR_ID, NOMBRE_PROYECTO, DESCRIPCION, "
      f"OBSERVACIONES, FECHA_CAPTURA, FECHA_RECEPCION, ESTADO, FECHA_MODIFICACION) VALUES ({q(sol)}, {por_uuid('CLIENTES', cli)}, "
      f"{por_uuid('CLIENTE_CONTACTOS', con)}, {usuario(s['asesor'])}, {q(proyecto)}, {q(descripcion)}, {q(observaciones)}, "
      f"{hace(s['dias'], 3)}, {hace(s['dias'], 1)}, {q(estado)}, {hace(s['dias'], 1)});")
    for p, (pieza, tipo_trabajo, tipo_material, acabado) in enumerate(piezas):
        pz = uid('pieza', n, p)
        w(f"INSERT INTO SOLICITUD_PIEZAS (SOLICITUD_ID, UUID_LOCAL, NOMBRE, TIPO_TRABAJO_ID, TIPO_MATERIAL_ID, ACABADO_ID, "
          f"ORDEN, ACTIVO, FECHA_CREACION, FECHA_MODIFICACION) VALUES ({por_uuid('SOLICITUDES', sol)}, {q(pz)}, {q(pieza)}, "
          f"(SELECT ID FROM TIPOS_TRABAJO WHERE NOMBRE = {q(tipo_trabajo)}), (SELECT ID FROM TIPOS_MATERIAL WHERE NOMBRE = {q(tipo_material)}), "
          f"(SELECT ID FROM ACABADOS WHERE NOMBRE = {q(acabado)}), {p + 1}, TRUE, {hace(s['dias'], 3)}, {hace(s['dias'], 3)});")
        medidas = [
            {'etiqueta': 'A', 'tipo': 'Largo', 'valor': 180 + (n * 37 + p * 53) % 900, 'cantidad': 1 + (n + p) % 3},
            {'etiqueta': 'B', 'tipo': 'Alto', 'valor': 60 + (n * 29 + p * 41) % 250, 'cantidad': 1 + (n + 2 * p) % 2},
            {'etiqueta': 'C', 'tipo': 'Ancho', 'valor': 30 + (n * 13 + p * 17) % 120, 'cantidad': 1},
        ]
        json_croquis = croquis(pz, medidas, (n + p) % 4)
        cq = uid('croquis', n, p)
        bytes_croquis = json_croquis.encode('utf-8')
        w(f"INSERT INTO SOLICITUD_ADJUNTOS (PIEZA_ID, UUID_LOCAL, TIPO, NOMBRE_ARCHIVO, MIME, TAMANO_BYTES, CONTENIDO_JSON, "
          f"HASH_SHA256, ACTIVO, FECHA_CREACION) VALUES ({por_uuid('SOLICITUD_PIEZAS', pz)}, {q(cq)}, 'croquis', 'croquis.json', "
          f"'application/json', {len(bytes_croquis)}, {q(json_croquis)}, {q(hashlib.sha256(bytes_croquis).hexdigest())}, TRUE, "
          f"{hace(s['dias'], 3)});")
        for f in range(2):
            indice = (n * 2 + p * 3 + f) % 8
            datos, largo, huella = fotos[indice]
            foto = uid('foto', n, p, f)
            if indice in primera_foto:
                contenido = f"(SELECT CONTENIDO FROM SOLICITUD_ADJUNTOS WHERE UUID_LOCAL = {q(primera_foto[indice])})"
            else:
                contenido = f"x'{datos}'"
                primera_foto[indice] = foto
            w(f"INSERT INTO SOLICITUD_ADJUNTOS (PIEZA_ID, UUID_LOCAL, TIPO, NOMBRE_ARCHIVO, MIME, TAMANO_BYTES, CONTENIDO, "
              f"HASH_SHA256, ACTIVO, FECHA_CREACION) VALUES ({por_uuid('SOLICITUD_PIEZAS', pz)}, {q(foto)}, 'foto', "
              f"{q(f'foto-{f + 1}.jpg')}, 'image/jpeg', {largo}, {contenido}, {q(huella)}, TRUE, {hace(s['dias'], 3)});")
        for o, m in enumerate(medidas):
            w(f"INSERT INTO SOLICITUD_MEDIDAS (UUID_LOCAL, PIEZA_ID, CROQUIS_ID, ETIQUETA, TIPO_MEDIDA, VALOR, UNIDAD_MEDIDA, "
              f"CANTIDAD, OBSERVACION, ORDEN, ACTIVO, FECHA_CREACION) VALUES ({q(uid('medida', n, p, o))}, "
              f"{por_uuid('SOLICITUD_PIEZAS', pz)}, {por_uuid('SOLICITUD_ADJUNTOS', cq)}, {q(m['etiqueta'])}, {q(m['tipo'])}, "
              f"{m['valor']}, 'cm', {m['cantidad']}, {q('Medida tomada en sitio con cinta')}, {o}, TRUE, {hace(s['dias'], 3)});")
    w('COMMIT;')
w()

CAMINOS = {
    'borrador': ['borrador'],
    'pendiente': ['borrador', 'pendiente'],
    'devuelta': ['borrador', 'pendiente', 'devuelta'],
    'visto_bueno': ['borrador', 'pendiente', 'visto_bueno'],
    'enviada': ['borrador', 'pendiente', 'visto_bueno', 'enviada'],
    'aprobada': ['borrador', 'pendiente', 'devuelta', 'pendiente', 'visto_bueno', 'enviada', 'aprobada'],
    'rechazada': ['borrador', 'pendiente', 'visto_bueno', 'enviada', 'rechazada'],
    'descartada': ['borrador', 'pendiente', 'visto_bueno', 'enviada', 'descartada'],
}
precios_mat = {m[0]: Decimal(m[6]) for m in MATERIALES}
nombres_mat = {m[0]: (m[1], m[3]) for m in MATERIALES}
precios_mo = {m[0]: (Decimal(m[4]), m[3]) for m in MANO_OBRA}
precios_mq = {m[0]: (Decimal(m[3]), m[1]) for m in MAQUINAS}
envios = 0
tablas_estado = []
for c, (n, estado) in enumerate(sorted(asignadas.items(), key=lambda x: -solicitudes[x[0]]['dias'])):
    s = solicitudes[n]
    proyecto, descripcion, _, piezas = s['proyecto']
    cliente = CLIENTES[s['cliente']]
    exonerado = cliente[9] is not None
    elabora = ASISTENTES[c % 2]
    revisa = SUPERVISORES[c % 2] if c % 5 else 'gerencia@anovo.test'
    camino = CAMINOS[estado]
    if estado == 'aprobada' and c % 2:
        camino = CAMINOS['enviada'] + ['aprobada']
    if estado == 'enviada':
        dias_envio = max(1, min([3, 10, 26][envios % 3], s['dias'] - 6))
        envios += 1
    else:
        dias_envio = max(2, s['dias'] - 12)
    inicio = s['dias'] - 1
    paso = max(1, (inicio - dias_envio) // max(1, len(camino)))
    fechas = []
    for k, e in enumerate(camino):
        if e in ('enviada', 'aprobada', 'rechazada', 'descartada'):
            d = dias_envio - (camino.index(e) - camino.index('enviada')) * 2 if 'enviada' in camino else dias_envio
        else:
            d = inicio - k * paso
        fechas.append(max(1, d))
    lineas = []
    mats = list(precios_mat)
    for j in range(3):
        cod = mats[(n * 3 + j * 5) % len(mats)]
        cant = Decimal(2 + (n + j) % 7)
        lineas.append(('material', cod, nombres_mat[cod][0], nombres_mat[cod][1], cant, precios_mat[cod]))
    mos = list(precios_mo)
    for j in range(2):
        cod = mos[(n + j * 4) % len(mos)]
        cant = Decimal(4 + (n * 3 + j) % 12)
        lineas.append(('mano_obra', cod, precios_mo[cod][1], 'hora', cant, precios_mo[cod][0]))
    mqs = list(precios_mq)
    cod = mqs[n % len(mqs)]
    lineas.append(('maquina', cod, precios_mq[cod][1], 'hora', Decimal(1 + n % 5), precios_mq[cod][0]))
    sub = {'material': Decimal(0), 'mano_obra': Decimal(0), 'maquina': Decimal(0)}
    for tipo, cod, desc, uni, cant, precio in lineas:
        sub[tipo] += redondear(cant * precio)
    costo = sub['material'] + sub['mano_obra'] + sub['maquina']
    ajuste = Decimal('7.50') if n % 4 == 0 else (Decimal('-5') if n % 7 == 0 else Decimal(0))
    iva = Decimal(0) if exonerado else IVA
    ajustado = costo + costo * ajuste / 100
    impuesto = redondear(ajustado * iva / 100)
    total = redondear(ajustado) + impuesto
    numero_forma = FORMAS_PAGO[n % len(FORMAS_PAGO)]
    con_visto = 'visto_bueno' in camino
    con_envio = 'enviada' in camino
    cot_desc = f"{descripcion}. Incluye fabricacion en taller, {piezas[0][0].lower()} y {piezas[1][0].lower()}."
    contexto(elabora, f'datos de prueba: cotizacion de {proyecto}')
    w(f"INSERT INTO COTIZACIONES (NUMERO, SOLICITUD_ID, CLIENTE_ID, TIPO_TRABAJO_ID, DESCRIPCION_TRABAJO, ELABORADA_POR, "
      f"ESTADO, SUBTOTAL_MATERIALES, SUBTOTAL_MANO_OBRA, SUBTOTAL_MAQUINA, COSTO_TOTAL, PORCENTAJE_AJUSTE, MOTIVO_AJUSTE, "
      f"PORCENTAJE_IVA, MONTO_IMPUESTO, MONTO_TOTAL, FECHA_ELABORACION, FORMA_PAGO_ID, FORMA_PAGO, PLAZO_ENTREGA_CANTIDAD, "
      f"PLAZO_ENTREGA_UNIDAD, GARANTIA_CANTIDAD, GARANTIA_UNIDAD) VALUES (NEXT VALUE FOR GEN_COTIZACION_NUMERO, "
      f"{por_uuid('SOLICITUDES', s['uuid'])}, {por_uuid('CLIENTES', uid('cliente', s['cliente']))}, "
      f"(SELECT ID FROM TIPOS_TRABAJO WHERE NOMBRE = {q(piezas[0][1])}), {q(cot_desc)}, {usuario(elabora)}, 'borrador', "
      f"{sub['material']}, {sub['mano_obra']}, {sub['maquina']}, {costo}, {ajuste}, "
      f"{q('Trabajo fuera del area metropolitana' if ajuste > 0 else ('Descuento por cliente frecuente' if ajuste < 0 else None))}, "
      f"{iva}, {impuesto}, {total}, {hace(fechas[0])}, (SELECT ID FROM FORMAS_PAGO WHERE NOMBRE = {q(numero_forma)}), "
      f"{q(numero_forma)}, {10 + n % 3 * 5}, 'dias_habiles', {6 + (n % 2) * 6}, 'meses');")
    cot = f"(SELECT C.ID FROM COTIZACIONES C JOIN SOLICITUDES S ON S.ID = C.SOLICITUD_ID WHERE S.UUID_LOCAL = {q(s['uuid'])})"
    for orden, (tipo, cod, desc, uni, cant, precio) in enumerate(lineas, start=1):
        columna = {'material': 'MATERIAL_ID', 'mano_obra': 'MANO_OBRA_ID', 'maquina': 'MAQUINA_ID'}[tipo]
        tabla = {'material': 'MATERIALES', 'mano_obra': 'MANO_OBRA', 'maquina': 'MAQUINAS'}[tipo]
        w(f"INSERT INTO COTIZACION_DETALLE (COTIZACION_ID, TIPO, {columna}, DESCRIPCION, UNIDAD_MEDIDA, CANTIDAD, "
          f"PRECIO_UNITARIO, SUBTOTAL, ORDEN, ACTIVO) VALUES ({cot}, {q(tipo)}, (SELECT ID FROM {tabla} WHERE CODIGO = {q(cod)}), "
          f"{q(desc)}, {q(uni)}, {cant}, {precio}, {redondear(cant * precio)}, {orden}, TRUE);")
    w(f"INSERT INTO COTIZACION_DETALLE (COTIZACION_ID, TIPO, DESCRIPCION, CANTIDAD, PRECIO_UNITARIO, SUBTOTAL, ORDEN, ACTIVO) "
      f"VALUES ({cot}, 'nota', 'Precio valido por 15 dias. Incluye transporte dentro del GAM.', 0, 0, 0, {len(lineas) + 1}, TRUE);")
    for e in camino[1:]:
        actor = revisa if e in ('visto_bueno', 'devuelta') else elabora
        contexto(actor, f'datos de prueba: cotizacion pasa a {e}')
        extra = ''
        if e == 'devuelta':
            extra = ", MOTIVO_RECHAZO = 'Revisar el calibre de la lamina y el plazo de entrega'"
        if e == 'visto_bueno':
            extra = f", APROBADA_POR = {usuario(revisa)}, FECHA_APROBACION = {hace(fechas[camino.index('visto_bueno')])}"
        if e == 'enviada':
            extra = f", FECHA_ENVIO = {hace(fechas[camino.index('enviada')])}"
        if e == 'aprobada':
            extra = f", ORDEN_COMPRA = {q(f'OC-2026-{4100 + n * 37}')}"
        w(f"UPDATE COTIZACIONES SET ESTADO = {q(e)}{extra} WHERE ID = {cot};")
    for k, e in enumerate(camino):
        actor = revisa if e in ('visto_bueno', 'devuelta') else elabora
        tablas_estado.append((cot, e, k, fechas[k], actor, len([x for x in camino[:k] if x == e])))
    if con_envio:
        contacto_correo = f"{(CLIENTES[s['cliente']][8] if CLIENTES[s['cliente']][1] != 2 else PERSONAS[(s['cliente'] * 2 + n % 2) % len(PERSONAS)]).lower().replace(' ', '.')}@{CLIENTES[s['cliente']][4].split('@')[1]}"
        w(f"INSERT INTO COTIZACION_ENVIOS (COTIZACION_ID, FECHA, USUARIO_ID, PARA, CC, ASUNTO, REMITENTE, MODO) VALUES "
          f"({cot}, {hace(fechas[camino.index('enviada')])}, {usuario(elabora)}, {q(contacto_correo)}, {q(CLIENTES[s['cliente']][4])}, "
          f"{q('Cotizacion de ' + proyecto)}, 'cotizaciones@anovo.test', 'clave');")
    s['fechas'] = (fechas, camino, con_visto, con_envio)
    w('COMMIT;')
w()

w('/* El disparador anota cada paso con la hora de la carga; aqui se le pone la')
w('   fecha en que habria ocurrido y quien lo hizo. */')
for cot, e, k, dias, actor, repeticion in tablas_estado:
    w(f"UPDATE COTIZACION_ESTADOS SET FECHA = {hace(dias, 0, k * 7)}, USUARIO_ID = {usuario(actor)} WHERE ID = "
      f"(SELECT ID FROM COTIZACION_ESTADOS WHERE COTIZACION_ID = {cot} AND ESTADO = {q(e)} ORDER BY ID ROWS {repeticion + 1} TO {repeticion + 1});")
w('COMMIT;')
w()
w('ALTER TRIGGER TR_COTIZACIONES_BU INACTIVE;')
w('ALTER TRIGGER TR_SOLICITUDES_BU INACTIVE;')
w('COMMIT;')
w('UPDATE COTIZACIONES C SET FECHA_MODIFICACION = (SELECT MAX(E.FECHA) FROM COTIZACION_ESTADOS E WHERE E.COTIZACION_ID = C.ID);')
w('UPDATE SOLICITUDES S SET FECHA_MODIFICACION = COALESCE((SELECT MIN(C.FECHA_ELABORACION) FROM COTIZACIONES C '
  'WHERE C.SOLICITUD_ID = S.ID), S.FECHA_RECEPCION);')
w('COMMIT;')
w('ALTER TRIGGER TR_COTIZACIONES_BU ACTIVE;')
w('ALTER TRIGGER TR_SOLICITUDES_BU ACTIVE;')
w('COMMIT;')
w()

w("""/* ====================  RESUMEN  ==================== */
SELECT 'USUARIOS ACTIVOS' AS TABLA, COUNT(*) AS FILAS FROM USUARIOS WHERE ACTIVO = TRUE
UNION ALL SELECT 'CLIENTES', COUNT(*) FROM CLIENTES
UNION ALL SELECT 'CLIENTE_CONTACTOS', COUNT(*) FROM CLIENTE_CONTACTOS
UNION ALL SELECT 'CONSENTIMIENTO_HISTORIAL', COUNT(*) FROM CLIENTE_CONSENTIMIENTO_HISTORIAL
UNION ALL SELECT 'SOLICITUDES', COUNT(*) FROM SOLICITUDES
UNION ALL SELECT 'SOLICITUD_PIEZAS', COUNT(*) FROM SOLICITUD_PIEZAS
UNION ALL SELECT 'SOLICITUD_ADJUNTOS', COUNT(*) FROM SOLICITUD_ADJUNTOS
UNION ALL SELECT 'SOLICITUD_MEDIDAS', COUNT(*) FROM SOLICITUD_MEDIDAS
UNION ALL SELECT 'COTIZACIONES', COUNT(*) FROM COTIZACIONES
UNION ALL SELECT 'COTIZACION_DETALLE', COUNT(*) FROM COTIZACION_DETALLE
UNION ALL SELECT 'COTIZACION_ESTADOS', COUNT(*) FROM COTIZACION_ESTADOS
UNION ALL SELECT 'COTIZACION_ENVIOS', COUNT(*) FROM COTIZACION_ENVIOS;
SELECT ESTADO, COUNT(*) FROM COTIZACIONES GROUP BY ESTADO;""")

SALIDA.write_text('\n'.join(out) + '\n', encoding='ascii', newline='\n')
print(f'{SALIDA.name}: {SALIDA.stat().st_size} bytes, {len(asignadas)} cotizaciones')
