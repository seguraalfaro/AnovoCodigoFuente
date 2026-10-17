import os
import re
import sys

ARCHIVO = sys.argv[1] if len(sys.argv) > 1 else os.path.join(
    os.path.dirname(os.path.abspath(__file__)), '..', '..', 'Db', 'generado', 'Anovo.Entities.Generadas.pas')
CAMPO_VERSION = re.compile(r"\[MVCTableField\('OBJVERSION'\)\](\r?\n\s*)fObjversion: NullableInt32;")
PROPIEDAD_VERSION = re.compile(r"property (Objversion|ObjVersion): NullableInt32 read fObjversion")
CLASE = re.compile(r"\[MVCTable\('(\w+)'\)\]")
SECRETOS = ('ClaveHash', 'LlaveHash', 'LlaveAnteriorHash')
PROPIEDAD_SECRETA = re.compile(r"(?<!\[MVCDoNotSerialize\]\n)(?<!\[MVCDoNotSerialize\]\r\n)^( *)property (%s):"
                               % '|'.join(SECRETOS), re.M)


def ajustar(texto):
    partes = re.split(r"(?=\[MVCTable\(')", texto)
    tablas = []
    for i, parte in enumerate(partes):
        tabla = CLASE.match(parte)
        if not tabla or tabla.group(1).upper().startswith('V_'):
            continue
        nueva, cambios = CAMPO_VERSION.subn(r"[MVCTableField('OBJVERSION', [foVersion])]\1fObjversion: Integer;", parte)
        if cambios:
            nueva = PROPIEDAD_VERSION.sub(r"property \1: Integer read fObjversion", nueva)
            partes[i] = nueva
            tablas.append(tabla.group(1))
    texto = ''.join(partes)
    salto = '\r\n' if '\r\n' in texto else '\n'
    secretos = [m.group(2) for m in PROPIEDAD_SECRETA.finditer(texto)]
    texto = PROPIEDAD_SECRETA.sub(lambda m: m.group(1) + '[MVCDoNotSerialize]' + salto + m.group(0), texto)
    return texto, tablas, secretos


def principal():
    datos = open(ARCHIVO, 'rb').read()
    bom = datos.startswith(b'\xef\xbb\xbf')
    texto = datos.decode('utf-8-sig')
    nuevo, tablas, secretos = ajustar(texto)
    if nuevo != texto:
        open(ARCHIVO, 'wb').write((b'\xef\xbb\xbf' if bom else b'') + nuevo.encode('utf-8'))
    pendientes = len(CAMPO_VERSION.findall(nuevo))
    print('OBJVERSION con foVersion: %d tablas' % len(tablas))
    for t in tablas:
        print('  ' + t)
    print('MVCDoNotSerialize agregado: %d propiedades' % len(secretos))
    for s in secretos:
        print('  ' + s)
    if pendientes:
        print('Quedan %d OBJVERSION sin ajustar (vistas)' % pendientes)


principal()
