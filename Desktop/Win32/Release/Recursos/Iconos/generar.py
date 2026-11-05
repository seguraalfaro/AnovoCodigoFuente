#!/usr/bin/env python3
# Genera los 20 iconos de Anovo en PNG 128x128, en dos variantes de color.
# Trazo sobre rejilla de 24, grosor 1.8, extremos y uniones redondeadas.

import os, cairosvg

# (indice, nombre, contenido SVG en viewBox 0 0 24 24)
ICONOS = [
 (0,  "cotizaciones", '<path d="M6 3h8l4 4v14H6z"/><path d="M14 3v4h4"/><path d="M9 12h6M9 16h4"/>'),
 (1,  "nueva",        '<path d="M6 3h8l4 4v14H6z"/><path d="M14 3v4h4"/><path d="M12 11v6M9 14h6"/>'),
 (2,  "clientes",     '<circle cx="12" cy="8" r="3.2"/><path d="M5.5 20c0-3.6 2.9-6 6.5-6s6.5 2.4 6.5 6"/>'),
 (3,  "materiales",   '<path d="M12 3l8 4.5v9L12 21l-8-4.5v-9z"/><path d="M4 7.5l8 4.5 8-4.5M12 12v9"/>'),
 (4,  "bandeja",      '<path d="M4 13l2.5-7h11L20 13v6H4z"/><path d="M4 13h4l1.2 2.2h5.6L16 13h4"/>'),
 (5,  "reportes",     '<path d="M4 20h16"/><path d="M7 20v-6M12 20V7M17 20v-9"/>'),
 (6,  "dashboard",    '<rect x="4" y="4" width="7" height="7" rx="1.2"/><rect x="13" y="4" width="7" height="4.5" rx="1.2"/><rect x="4" y="13" width="7" height="7" rx="1.2"/><rect x="13" y="10.5" width="7" height="9.5" rx="1.2"/>'),
 (7,  "gerencia",     '<path d="M3 20h18"/><path d="M6 20V5h9v15"/><path d="M15 20v-9h4v9"/><path d="M8.5 8h1.2M12 8h1.2M8.5 11.5h1.2M12 11.5h1.2M8.5 15h1.2M12 15h1.2M17 14.5h0.6"/>'),
 (8,  "usuarios",     '<circle cx="9" cy="8.5" r="3"/><path d="M3 19c0-3.3 2.7-5.5 6-5.5s6 2.2 6 5.5"/><path d="M16 6.2a3 3 0 010 5.6M17.5 19c0-2.4-.8-4.1-2.2-5.2"/>'),
 (9,  "roles",        '<path d="M12 3l7 3v6c0 4.2-2.9 7.6-7 9-4.1-1.4-7-4.8-7-9V6z"/><path d="M9.2 12.2l2 2 3.6-3.9"/>'),
 (10, "configuracion",'<path d="M16.40 9.85 L18.85 10.54 L18.85 13.46 L16.40 14.15 L16.06 14.74 L16.68 17.20 L14.16 18.66 L12.34 16.89 L11.66 16.89 L9.84 18.66 L7.32 17.20 L7.94 14.74 L7.60 14.15 L5.15 13.46 L5.15 10.54 L7.60 9.85 L7.94 9.26 L7.32 6.80 L9.84 5.34 L11.66 7.11 L12.34 7.11 L14.16 5.34 L16.68 6.80 L16.06 9.26 Z"/><circle cx="12" cy="12" r="2.8"/>'),
 (11, "salir",        '<path d="M14 4H6v16h8"/><path d="M11 12h9M17 9l3 3-3 3"/>'),
 (12, "buscar",       '<circle cx="11" cy="11" r="6"/><path d="M15.5 15.5L20 20"/>'),
 (13, "agregar",      '<circle cx="12" cy="12" r="8"/><path d="M12 8.5v7M8.5 12h7"/>'),
 (14, "quitar",       '<circle cx="12" cy="12" r="8"/><path d="M8.5 12h7"/>'),
 (15, "guardar",      '<path d="M5 4h11l3 3v13H5z"/><path d="M8 4v5h7V4"/><rect x="8" y="13" width="8" height="7"/>'),
 (16, "volver",       '<path d="M20 12H4"/><path d="M10 6l-6 6 6 6"/>'),
 (17, "camara",       '<path d="M3 8h4l1.5-2.2h7L17 8h4v11H3z"/><circle cx="12" cy="13" r="3.4"/>'),
 (18, "croquis",      '<path d="M4 20l1.2-4.2L15 6l3 3-9.8 9.8z"/><path d="M13.5 7.5l3 3"/><path d="M4 20h6"/>'),
 (19, "descargar",    '<path d="M12 4v10"/><path d="M8 10.5l4 3.5 4-3.5"/><path d="M5 18h14"/>'),
]

VARIANTES = {
    "Oscuro": "#2C2C2A",   # sobre tarjeta blanca / area de contenido
    "Claro":  "#FFFFFF",   # sobre la barra lateral azul
}

PLANTILLA = ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24" '
             'fill="none" stroke="{color}" stroke-width="1.8" stroke-linecap="round" '
             'stroke-linejoin="round">{cuerpo}</svg>')

base = os.path.dirname(os.path.abspath(__file__))
for variante, color in VARIANTES.items():
    destino = os.path.join(base, variante)
    os.makedirs(destino, exist_ok=True)
    for indice, nombre, cuerpo in ICONOS:
        svg = PLANTILLA.format(color=color, cuerpo=cuerpo)
        salida = os.path.join(destino, "%02d-%s.png" % (indice, nombre))
        cairosvg.svg2png(bytestring=svg.encode("utf-8"),
                         write_to=salida, output_width=128, output_height=128)
        # SVG de origen, por si luego se pasa a Delphi 12 (que sí admite SVG)
        with open(os.path.join(destino, "%02d-%s.svg" % (indice, nombre)), "w") as f:
            f.write(svg)

print("Generados %d iconos x %d variantes" % (len(ICONOS), len(VARIANTES)))
