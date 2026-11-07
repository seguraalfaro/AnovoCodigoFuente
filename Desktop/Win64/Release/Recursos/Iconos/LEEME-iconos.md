# Iconos de Anovo

20 iconos, trazo de 1.8 sobre rejilla de 24, extremos redondeados. Originales,
generados con el script `generar.py` que va incluido: si hace falta cambiar un
icono, se edita su ruta SVG ahí y se vuelve a ejecutar.

## Dos variantes, y por qué

La VCL **no recolorea** un PNG de una `TImageCollection`. Como la barra lateral es
azul oscuro y el resto de la aplicación es blanco, el mismo icono en un solo color
se pierde en uno de los dos sitios. Por eso hay dos carpetas:

- `Oscuro/` — trazo `#2C2C2A`. Para el área de contenido, botones y encabezados.
- `Claro/` — trazo `#FFFFFF`. Para la barra lateral.

Cada PNG es de 128×128 con fondo transparente; la `TImageCollection` escala hacia
abajo a 16, 20 y 24 sin pérdida apreciable.

## Cómo cargarlos

1. Abrir `Anovo.UI.Iconos` (el data module) y doble clic en `icnAnovo`.
2. **Add** y seleccionar los 20 PNG de `Oscuro/` **en orden de número de archivo**.
   El orden importa: los índices 0..19 deben coincidir con las constantes
   `icoCotizaciones`..`icoDescargar` de esa misma unidad.
3. Repetir en la segunda colección, `icnAnovoClaro`, con los 20 de `Claro/`.
   Si esa colección todavía no existe, agregar un segundo `TImageCollection` al
   data module con ese nombre; la barra lateral apunta ahí.

Los nombres de archivo ya llevan el índice delante (`00-cotizaciones.png`), así que
ordenando por nombre en el diálogo de selección quedan en la posición correcta.

## Si en algún momento migran a Delphi 12

`TImageCollection` admite SVG desde la versión 12. Por eso van también los `.svg`
de cada icono: se cargan directamente, quedan nítidos a cualquier DPI y desaparece
la necesidad de dos variantes de color, porque el SVG sí se puede recolorear.
