"""Quita los comentarios de las unidades Delphi y deja solo su encabezado.

El encabezado son las lineas // que van justo debajo de unit o program, hasta
tres. Todo lo demas se quita: // , { } y (* *). Se respetan las cadenas, las
directivas {$...} y las marcas {frmX} del .dpr, que el IDE necesita.

Antes de escribir cada archivo comprueba que el codigo sin comentarios quede
identico al original; si no, lo deja como estaba y lo informa.

Uso:
    python quitar_comentarios.py <carpeta o archivos...>            informa
    python quitar_comentarios.py <carpeta o archivos...> --aplicar  escribe

Ejemplo, desde la raiz del repositorio:
    python Herramientas/quitar_comentarios.py Backend Desktop --aplicar
"""
import os
import re
import sys

MAX_ENCABEZADO = 3
EXCLUIDAS = ('__history', '__recovery')


def quitar(texto, es_dpr):
    salida = []
    i, n = 0, len(texto)
    while i < n:
        c = texto[i]
        if c == "'":
            j = i + 1
            while j < n:
                if texto[j] == "'":
                    if j + 1 < n and texto[j + 1] == "'":
                        j += 2
                        continue
                    break
                if texto[j] == '\n':
                    break
                j += 1
            salida.append(texto[i:j + 1])
            i = j + 1
        elif texto.startswith('//', i):
            j = texto.find('\n', i)
            i = n if j < 0 else j
        elif c == '{':
            j = texto.find('}', i)
            j = n - 1 if j < 0 else j
            bloque = texto[i:j + 1]
            linea = texto[texto.rfind('\n', 0, i) + 1:i]
            if bloque.startswith('{$') or (es_dpr and " in '" in linea):
                salida.append(bloque)
            i = j + 1
        elif texto.startswith('(*', i):
            j = texto.find('*)', i)
            j = n - 2 if j < 0 else j
            bloque = texto[i:j + 2]
            if bloque.startswith('(*$'):
                salida.append(bloque)
            i = j + 2
        else:
            salida.append(c)
            i += 1
    return ''.join(salida)


def limpiar(original, sin):
    lo = original.split('\n')
    ls = sin.split('\n')
    if len(lo) == len(ls):
        lineas = [b.rstrip() for a, b in zip(lo, ls)
                  if not (b.strip() == '' and a.strip() != '')]
    else:
        lineas = [b.rstrip() for b in ls]
    final = []
    for l in lineas:
        if l == '' and final and final[-1] == '':
            continue
        final.append(l)
    return '\n'.join(final)


def separar_encabezado(texto):
    """Devuelve (lo anterior a unit, la linea unit, el encabezado, el resto)."""
    m = re.search(r'^[ \t]*(unit|program) [\w.]+;[ \t]*\n', texto, re.M)
    if not m:
        return None
    resto = texto[m.end():]
    lineas = resto.split('\n')
    k = 0
    while k < len(lineas) and lineas[k].strip() == '':
        k += 1
    encabezado = []
    while k < len(lineas) and lineas[k].strip().startswith('//'):
        encabezado.append(lineas[k].strip())
        k += 1
    return texto[:m.start()], m.group(0).strip(), encabezado, '\n'.join(lineas[k:])


def solo_codigo(texto, es_dpr):
    return re.sub(r'\s+', '', quitar(texto, es_dpr))


def procesar(ruta, aplicar):
    crudo = open(ruta, 'rb').read()
    bom = crudo.startswith(b'\xef\xbb\xbf')
    try:
        texto = crudo.decode('utf-8-sig')
        enc = 'utf-8'
    except UnicodeDecodeError:
        texto = crudo.decode('cp1252')
        enc = 'cp1252'
    crlf = '\r\n' in texto
    texto = texto.replace('\r\n', '\n')
    es_dpr = ruta.lower().endswith('.dpr')

    partes = separar_encabezado(texto)
    if partes is None:
        return 'sin unit', None
    previo, unidad, encabezado, cuerpo = partes
    aviso = ''
    if not encabezado:
        aviso = 'sin encabezado'
    elif len(encabezado) > MAX_ENCABEZADO:
        aviso = 'encabezado de %d lineas' % len(encabezado)

    previo = limpiar(previo, quitar(previo, es_dpr)).strip('\n')
    cuerpo = limpiar(cuerpo, quitar(cuerpo, es_dpr)).lstrip('\n')
    nuevo = (previo + '\n\n' if previo else '') + unidad + '\n\n'
    if encabezado:
        nuevo += '\n'.join(encabezado) + '\n\n'
    nuevo += cuerpo

    if solo_codigo(nuevo, es_dpr) != solo_codigo(texto, es_dpr):
        return 'el codigo cambiaria; no se toca', None
    if nuevo == texto:
        return aviso, False
    if aplicar:
        if crlf:
            nuevo = nuevo.replace('\n', '\r\n')
        open(ruta, 'wb').write((b'\xef\xbb\xbf' if bom else b'') + nuevo.encode(enc))
    return aviso, True


def unidades(rutas):
    for r in rutas:
        if os.path.isfile(r):
            yield r
            continue
        for raiz, dirs, archivos in os.walk(r):
            dirs[:] = [d for d in dirs if d not in EXCLUIDAS]
            for a in archivos:
                if a.lower().endswith(('.pas', '.dpr')):
                    yield os.path.join(raiz, a)


def main():
    aplicar = '--aplicar' in sys.argv
    rutas = [a for a in sys.argv[1:] if not a.startswith('--')]
    if not rutas:
        print(__doc__)
        return 1
    cambian = 0
    for ruta in sorted(unidades(rutas)):
        aviso, cambia = procesar(ruta, aplicar)
        if cambia:
            cambian += 1
        if cambia or aviso:
            estado = 'cambia' if cambia else 'igual'
            print('%-8s %s %s' % (estado, ruta, ('(' + aviso + ')') if aviso else ''))
    verbo = 'cambiados' if aplicar else 'por cambiar'
    print('\n%d archivos %s' % (cambian, verbo))
    return 0


if __name__ == '__main__':
    sys.exit(main())
