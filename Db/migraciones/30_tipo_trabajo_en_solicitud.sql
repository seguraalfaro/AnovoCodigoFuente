/* Anovo - Migracion 30: tipo de trabajo en la solicitud.
   Opcional. Lo indica el asesor al registrar la solicitud y la cotizacion
   lo copia al tomarla, igual que la descripcion. Pendiente de aprobacion
   en la minuta 13/2026; si se rechaza, la columna queda sin uso. Todo en ASCII. */

ALTER TABLE SOLICITUDES ADD TIPO_TRABAJO_ID INTEGER;

COMMIT;

ALTER TABLE SOLICITUDES ADD CONSTRAINT FK_SOLICITUDES_TIPO_TRABAJO
  FOREIGN KEY (TIPO_TRABAJO_ID) REFERENCES TIPOS_TRABAJO (ID);

COMMIT;
