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
  -- 1 cedula fisica, 2 cedula juridica, 3 DIMEX. Coincide con el indice del combo
  -- Utils.TiposIdent, donde el 0 es la opcion vacia y aqui se guarda como NULL.
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
  descripcion       TEXT NOT NULL,
  observaciones     TEXT,
  fecha_captura     TEXT NOT NULL,
  objversion        INTEGER NOT NULL DEFAULT 0,
  estado_sync       TEXT NOT NULL DEFAULT 'pendiente',
  completa          INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_solicitudes_cliente ON solicitudes (cliente_uuid);

-- Croquis: se guarda el JSON de trazos/coordenadas relativas (contenido_json).
-- ruta_archivo puede quedar vacía para croquis (o guardar un PNG rasterizado opcional).
-- Para tipo='foto' ruta_archivo es obligatoria y contenido_json queda NULL.
CREATE TABLE IF NOT EXISTS adjuntos (
  uuid_local        TEXT PRIMARY KEY,
  id_servidor       INTEGER,
  solicitud_uuid    TEXT NOT NULL REFERENCES solicitudes(uuid_local),
  tipo              TEXT NOT NULL CHECK (tipo IN ('croquis','foto')),
  ruta_archivo      TEXT,
  contenido_json    TEXT,
  mime              TEXT,
  objversion        INTEGER NOT NULL DEFAULT 0,
  estado_sync       TEXT NOT NULL DEFAULT 'pendiente',
  CHECK ( (tipo = 'foto'    AND ruta_archivo IS NOT NULL) OR
          (tipo = 'croquis' AND contenido_json IS NOT NULL) )
);

CREATE INDEX IF NOT EXISTS idx_adjuntos_solicitud ON adjuntos (solicitud_uuid);

-- Cada fila = una medición: tipo (combo) + valor (edit) + unidad (combo).
-- Reemplaza las columnas fijas largo/ancho/alto: una pieza puede llevar varias
-- mediciones del mismo o distinto tipo. etiqueta correlaciona con un punto del croquis.
CREATE TABLE IF NOT EXISTS medidas (
  uuid_local        TEXT PRIMARY KEY,
  solicitud_uuid    TEXT NOT NULL REFERENCES solicitudes(uuid_local),
  croquis_uuid      TEXT REFERENCES adjuntos(uuid_local),
  etiqueta          TEXT,
  tipo_medida       TEXT NOT NULL,               -- Largo|Ancho|Alto|Diámetro|Espesor|Radio|Ángulo...
  valor             REAL NOT NULL,
  unidad_medida     TEXT NOT NULL DEFAULT 'cm',  -- cm|mm|m|pulg|grados...
  observacion       TEXT,
  orden             INTEGER NOT NULL DEFAULT 0,
  objversion        INTEGER NOT NULL DEFAULT 0,
  estado_sync       TEXT NOT NULL DEFAULT 'pendiente'
);

CREATE INDEX IF NOT EXISTS idx_medidas_solicitud ON medidas (solicitud_uuid);

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
                      CHECK (entidad IN ('cliente','contacto','firma','solicitud','adjunto','medida')),
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
