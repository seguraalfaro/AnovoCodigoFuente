-- Anovo — esquema local SQLite  (pestaña Files del proyecto B4A)
-- Todo con CREATE ... IF NOT EXISTS: se ejecuta en cada arranque sin efecto si ya existe.
-- Cambió el esquema? Se reemplaza este archivo y se activa BORRAR_BASE una vez.
-- Requisito del parser: sin triggers y sin ";" ni "--" dentro de literales de texto.
--
-- objversion: version del registro tal como la mando el servidor. NO se toca en el movil.
-- Se guarda al descargar y se devuelve igual al sincronizar. Si el servidor ya tiene una
-- mas nueva responde 409 y la fila queda en estado_sync='conflicto' para que decida el asesor.

CREATE TABLE IF NOT EXISTS clientes (
  uuid_local              TEXT PRIMARY KEY,
  id_servidor             INTEGER,
  nombre                  TEXT NOT NULL,
  identificacion          TEXT,
  -- 1 cedula fisica, 2 cedula juridica, 3 DIMEX: la posicion en el combo
  -- Utils.TiposIdent mas uno. Sin tipo elegido se guarda NULL.
  tipo_identificacion     INTEGER CHECK (tipo_identificacion IN (1,2,3)),
  telefono                TEXT,
  correo                  TEXT,
  contacto                TEXT,
  direccion               TEXT,
  latitud                 REAL,
  longitud                REAL,
  consentimiento_estado   TEXT NOT NULL DEFAULT 'pendiente'
                            CHECK (consentimiento_estado IN ('pendiente','firmado','revocado')),
  objversion              INTEGER NOT NULL DEFAULT 0,
  estado_sync             TEXT NOT NULL DEFAULT 'pendiente'
                            CHECK (estado_sync IN ('pendiente','enviando','confirmado','error','conflicto'))
);

CREATE TABLE IF NOT EXISTS cliente_contactos (
  uuid_local              TEXT PRIMARY KEY,
  id_servidor             INTEGER,
  cliente_uuid            TEXT NOT NULL REFERENCES clientes(uuid_local),
  nombre                  TEXT NOT NULL,
  area                    TEXT,
  telefono                TEXT,
  celular                TEXT,
  correo                  TEXT,
  principal               INTEGER NOT NULL DEFAULT 0,
  consentimiento_estado   TEXT NOT NULL DEFAULT 'pendiente'
                            CHECK (consentimiento_estado IN ('pendiente','firmado','revocado')),
  consentimiento_version  TEXT,
  consentimiento_fecha    TEXT,
  objversion              INTEGER NOT NULL DEFAULT 0,
  estado_sync             TEXT NOT NULL DEFAULT 'pendiente'
);

CREATE INDEX IF NOT EXISTS idx_contactos_cliente ON cliente_contactos (cliente_uuid);

CREATE TABLE IF NOT EXISTS consentimiento_firmas (
  uuid_local              TEXT PRIMARY KEY,
  id_servidor             INTEGER,
  cliente_uuid            TEXT NOT NULL REFERENCES clientes(uuid_local),
  cliente_contacto_uuid   TEXT REFERENCES cliente_contactos(uuid_local),
  accion                  TEXT NOT NULL DEFAULT 'otorgado'
                            CHECK (accion IN ('otorgado','revocado')),
  version_texto           TEXT NOT NULL,
  fecha                   TEXT NOT NULL,
  firmante_nombre         TEXT,
  firmante_identificacion TEXT,
  firma                   BLOB,
  mime                    TEXT,
  estado_sync             TEXT NOT NULL DEFAULT 'pendiente'
);

CREATE INDEX IF NOT EXISTS idx_firmas_cliente ON consentimiento_firmas (cliente_uuid);

CREATE TABLE IF NOT EXISTS solicitudes (
  uuid_local        TEXT PRIMARY KEY,
  id_servidor       INTEGER,
  cliente_uuid      TEXT NOT NULL REFERENCES clientes(uuid_local),
  cliente_contacto_uuid TEXT REFERENCES cliente_contactos(uuid_local),
  nombre_proyecto   TEXT,
  descripcion       TEXT NOT NULL,
  observaciones     TEXT,
  fecha_captura     TEXT NOT NULL,
  objversion        INTEGER NOT NULL DEFAULT 0,
  estado_sync       TEXT NOT NULL DEFAULT 'pendiente',
  completa          INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_solicitudes_cliente ON solicitudes (cliente_uuid);

-- Una fila por pieza de la solicitud (migracion 37 de Firebird). El tipo de trabajo,
-- el tipo de material y el acabado son id_servidor de los catalogos locales.
CREATE TABLE IF NOT EXISTS piezas (
  uuid_local        TEXT PRIMARY KEY,
  id_servidor       INTEGER,
  solicitud_uuid    TEXT NOT NULL REFERENCES solicitudes(uuid_local),
  nombre            TEXT NOT NULL,
  tipo_trabajo_id   INTEGER REFERENCES tipos_trabajo(id_servidor),
  tipo_material_id  INTEGER REFERENCES tipos_material(id_servidor),
  acabado_id        INTEGER REFERENCES acabados(id_servidor),
  orden             INTEGER NOT NULL DEFAULT 0,
  objversion        INTEGER NOT NULL DEFAULT 0,
  estado_sync       TEXT NOT NULL DEFAULT 'pendiente'
);

CREATE INDEX IF NOT EXISTS idx_piezas_solicitud ON piezas (solicitud_uuid);

-- Croquis: se guarda el JSON de trazos/coordenadas relativas (contenido_json).
-- ruta_archivo puede quedar vacía para croquis (o guardar un PNG rasterizado opcional).
-- Para tipo='foto' ruta_archivo es obligatoria y contenido_json queda NULL.
-- Croquis y fotos son de la pieza, no de la solicitud.
CREATE TABLE IF NOT EXISTS adjuntos (
  uuid_local        TEXT PRIMARY KEY,
  id_servidor       INTEGER,
  pieza_uuid        TEXT NOT NULL REFERENCES piezas(uuid_local),
  tipo              TEXT NOT NULL CHECK (tipo IN ('croquis','foto')),
  ruta_archivo      TEXT,
  contenido_json    TEXT,
  mime              TEXT,
  objversion        INTEGER NOT NULL DEFAULT 0,
  estado_sync       TEXT NOT NULL DEFAULT 'pendiente',
  CHECK ( (tipo = 'foto'    AND ruta_archivo IS NOT NULL) OR
          (tipo = 'croquis' AND contenido_json IS NOT NULL) )
);

CREATE INDEX IF NOT EXISTS idx_adjuntos_pieza ON adjuntos (pieza_uuid);

-- Cada fila = una medición: tipo (combo) + valor (edit) + unidad (combo).
-- Reemplaza las columnas fijas largo/ancho/alto: una pieza puede llevar varias
-- mediciones del mismo o distinto tipo. etiqueta correlaciona con un punto del croquis.
-- Cada cota del croquis de la pieza es una fila.
CREATE TABLE IF NOT EXISTS medidas (
  uuid_local        TEXT PRIMARY KEY,
  pieza_uuid        TEXT NOT NULL REFERENCES piezas(uuid_local),
  croquis_uuid      TEXT REFERENCES adjuntos(uuid_local),
  etiqueta          TEXT,
  tipo_medida       TEXT NOT NULL,               -- Largo|Ancho|Alto|Diámetro|Espesor|Radio|Ángulo...
  valor             REAL NOT NULL,
  cantidad          INTEGER NOT NULL DEFAULT 1,
  unidad_medida     TEXT NOT NULL DEFAULT 'cm',  -- cm|mm|m|pulg|grados...
  observacion       TEXT,
  orden             INTEGER NOT NULL DEFAULT 0,
  objversion        INTEGER NOT NULL DEFAULT 0,
  estado_sync       TEXT NOT NULL DEFAULT 'pendiente'
);

CREATE INDEX IF NOT EXISTS idx_medidas_pieza ON medidas (pieza_uuid);

-- Catalogos que baja el Sincronizador. La clave es el ID de Firebird.
CREATE TABLE IF NOT EXISTS tipos_trabajo (
  id_servidor       INTEGER PRIMARY KEY,
  nombre            TEXT NOT NULL,
  activo            INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS tipos_material (
  id_servidor       INTEGER PRIMARY KEY,
  nombre            TEXT NOT NULL,
  activo            INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS acabados (
  id_servidor       INTEGER PRIMARY KEY,
  nombre            TEXT NOT NULL,
  activo            INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS cotizaciones_estado (
  id_servidor       INTEGER PRIMARY KEY,
  numero            INTEGER NOT NULL,
  estado            TEXT NOT NULL,
  monto_total       TEXT,
  fecha_ultima_sync TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS cola_sync (
  id                INTEGER PRIMARY KEY AUTOINCREMENT,
  entidad           TEXT NOT NULL
                      CHECK (entidad IN ('cliente','contacto','firma','solicitud','pieza','adjunto','medida')),
  uuid_local        TEXT NOT NULL,
  objversion        INTEGER NOT NULL DEFAULT 0,
  intentos          INTEGER NOT NULL DEFAULT 0,
  ultimo_error      TEXT,
  fecha_encolado    TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_cola_entidad ON cola_sync (entidad);

CREATE TABLE IF NOT EXISTS config (
  clave  TEXT PRIMARY KEY,
  valor  TEXT
);
