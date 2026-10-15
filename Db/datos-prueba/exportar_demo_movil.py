import json, os, re, subprocess
ENV = r'F:\Uned\TFG\AnovoCodigoFuente\Db\generador.env'
ISQL = r'F:\Program Files (x86)\Firebird\Firebird_4_0\isql.exe'
DB = r'localhost:F:\Uned\TFG\AnovoCodigoFuente\Db\ANOVO.FDB'
SEP = '~|~'
clave = [l.split('=', 1)[1].strip() for l in open(ENV, encoding='utf-8') if re.match(r'\s*PASSWORD\s*=', l)][0]


def consulta(campos, desde, vacio=False):
    expr = (" || '%s' || " % SEP).join("COALESCE(CAST(%s AS VARCHAR(400)), '')" % c for c in campos)
    sql = "SET HEADING OFF;\nSELECT '@@' || %s FROM %s;\n" % (expr, desde)
    env = dict(os.environ, ISC_PASSWORD=clave)
    r = subprocess.run([ISQL, '-user', 'SYSDBA', '-ch', 'UTF8', '-q', DB], input=sql.encode('utf-8'),
                       capture_output=True, env=env)
    filas = []
    for l in r.stdout.decode('utf-8').splitlines():
        l = l.strip()
        if l.startswith('@@'):
            filas.append(l[2:].split(SEP))
    assert filas or (vacio and not r.stderr), r.stderr.decode('utf-8', 'replace')
    return filas


def nulo(v):
    return v if v != '' else None


cli = consulta(['ID', 'UUID_LOCAL', 'NOMBRE', 'IDENTIFICACION', 'TIPO_IDENTIFICACION', 'TELEFONO', 'CORREO',
                'CONTACTO', 'DIRECCION', 'LATITUD', 'LONGITUD', 'CONSENTIMIENTO_ESTADO'],
               'CLIENTES WHERE ACTIVO AND NOT ANONIMIZADO AND UUID_LOCAL IS NOT NULL ORDER BY ID')
uuid_de = {}
clientes = []
for f in cli:
    uuid_de[f[0]] = f[1]
    tipo = nulo(f[4])
    if tipo is None:
        tipo = 2 if f[3].startswith('3-') else 1
    clientes.append({'id': int(f[0]), 'uuid': f[1], 'nombre': f[2], 'identificacion': nulo(f[3]),
                     'tipo_identificacion': int(tipo), 'telefono': nulo(f[5]), 'correo': nulo(f[6]),
                     'contacto': nulo(f[7]), 'direccion': nulo(f[8]),
                     'latitud': float(f[9]) if f[9] else None, 'longitud': float(f[10]) if f[10] else None,
                     'consentimiento': f[11]})
con = consulta(['ID', 'UUID_LOCAL', 'CLIENTE_ID', 'NOMBRE', 'AREA', 'TELEFONO', 'CELULAR', 'CORREO',
                'IIF(PRINCIPAL, 1, 0)', 'CONSENTIMIENTO_ESTADO'],
               'CLIENTE_CONTACTOS WHERE ACTIVO AND NOT ANONIMIZADO AND UUID_LOCAL IS NOT NULL ORDER BY CLIENTE_ID, ID')
contactos = [{'id': int(f[0]), 'uuid': f[1], 'cliente_uuid': uuid_de[f[2]], 'nombre': f[3], 'area': nulo(f[4]),
              'telefono': nulo(f[5]), 'celular': nulo(f[6]), 'correo': nulo(f[7]), 'principal': int(f[8]),
              'consentimiento': f[9]} for f in con if f[2] in uuid_de]
cat = {}
for t in ('TIPOS_TRABAJO', 'TIPOS_MATERIAL', 'ACABADOS'):
    cat[t.lower()] = [{'id': int(f[0]), 'nombre': f[1]} for f in consulta(['ID', 'NOMBRE'], t + ' WHERE ACTIVO ORDER BY ID', True)]
datos = {'clientes': clientes, 'contactos': contactos, **cat}
dest = r'F:\Uned\TFG\AnovoCodigoFuente\AppMovil\B4A\Files\datos_prueba.json'
json.dump(datos, open(dest, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('clientes', len(clientes), 'contactos', len(contactos), {k: len(v) for k, v in cat.items()})
print('contactos sin uuid o de clientes fuera:', len(con) - len(contactos))

