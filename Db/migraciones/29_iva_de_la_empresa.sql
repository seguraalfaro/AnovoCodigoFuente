/* Anovo - Migracion 29: porcentaje de IVA de la empresa.
   El IVA de cada cotizacion lo fija el servidor: el de EMPRESA, o 0 si el
   cliente esta exonerado (zona franca, minuta 06). Antes lo mandaba el
   cliente de la API. 13 es la tarifa general vigente. Todo en ASCII. */

ALTER TABLE EMPRESA ADD PORCENTAJE_IVA NUMERIC(5,2) DEFAULT 13 NOT NULL;

COMMIT;

ALTER TABLE EMPRESA ADD CONSTRAINT CK_EMPRESA_IVA
  CHECK (PORCENTAJE_IVA BETWEEN 0 AND 100);

COMMIT;
