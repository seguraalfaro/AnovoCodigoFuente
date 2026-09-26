/* ============================================================================
   Anovo - Migracion 12: mano de obra tiene nombre, como los otros catalogos
   ----------------------------------------------------------------------------
   MATERIALES y MAQUINAS tienen NOMBRE obligatorio y DESCRIPCION opcional.
   MANO_OBRA no tenia nombre y usaba la descripcion en su lugar, obligatoria.
   Eso obligaba a tratarla distinto en todas partes: la columna del listado,
   el campo del formulario, el texto que identifica la fila, la comprobacion
   de duplicados y la busqueda.

   Aqui se iguala. Las tres tablas de catalogo quedan con la misma forma:

     CODIGO       obligatorio y unico
     NOMBRE       obligatorio, hasta 120
     DESCRIPCION  opcional, hasta 500

   El nombre de las trece filas que ya existen se copia de su descripcion,
   truncada a 120. Son textos que ya leen como nombre -"Hora de soldadura MIG",
   "Corte de lamina con cizalla (nivel 2)"-, asi que el resultado es razonable;
   aun asi conviene repasarlos despues, porque la descripcion queda con el
   mismo texto y lo normal es que la una sea mas corta que la otra.

   MANO_OBRA no tiene disparador de auditoria -lo sensible es el precio, no el
   nombre del articulo, segun la cabecera de 03_auditoria.sql-, asi que el
   UPDATE de relleno no necesita usuario en contexto.

   Los COMMIT entre pasos no sobran: un cambio de metadatos sobre una tabla con
   escrituras sin confirmar muere con "object TABLE is in use", y ese fallo
   deja al motor en bugcheck.
   ============================================================================ */

/* 1. La columna, todavia admitiendo nulos: las filas que ya estan no tienen
      con que llenarla hasta el paso 2. */
ALTER TABLE MANO_OBRA ADD NOMBRE D_NOMBRE;

COMMIT;

/* 2. El nombre sale de la descripcion. SUBSTRING porque DESCRIPCION admite 500
      y NOMBRE 120. */
UPDATE MANO_OBRA
   SET NOMBRE = SUBSTRING(DESCRIPCION FROM 1 FOR 120)
 WHERE NOMBRE IS NULL;

COMMIT;

/* 3. Ya con todas llenas, se exige. */
ALTER TABLE MANO_OBRA ALTER NOMBRE SET NOT NULL;

COMMIT;

/* 4. Y la descripcion pasa a ser opcional, como en materiales y maquinas. Lo
      que identifica al item es el nombre; la descripcion es el detalle. */
ALTER TABLE MANO_OBRA ALTER DESCRIPCION DROP NOT NULL;

COMMIT;

/* ----------------------------------------------------------------------------
   LO QUE ESTO OBLIGA A CAMBIAR FUERA DE LA BASE

   Backend
     - la entidad TManoObra suma NOMBRE (MVCEntGen no lo pone solo si no se
       regenera);
     - MANO_OBRA_FILTRO_BUSQUEDA pasa a buscar tambien por NOMBRE;
     - MANO_OBRA_CON_PRECIO devuelve NOMBRE;
     - ExisteDescripcion se vuelve ExisteNombre, porque la regla de la HU-05 es
       que no haya nombres repetidos en el mismo catalogo;
     - los DTO de mano de obra suman Nombre y su descripcion pasa a nullable.

   Escritorio
     - mtManoObra suma NOMBRE;
     - la columna de la rejilla deja de mostrar DESCRIPCION como si fuera el
       nombre;
     - la tarjeta CarManoObra suma el campo;
     - NombreDeLaFila deja de tratar mano de obra como caso aparte.
   ---------------------------------------------------------------------------- */
