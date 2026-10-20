unit Anovo.Entities.Vistas.Lectura;

// Entidades de las vistas de lectura (migraciones 18 a 25), de solo lectura.
// Generadas por MVCEntGen; al regenerar, partir de Db/generado.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  MVCFramework.ActiveRecord,
  MVCFramework.Validators;

type

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_ASESORES_MES')]
  TVAsesoresMes = class(TMVCActiveRecord)
  private
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ASESOR_NOMBRE')]
    [MVCMaxLength(120)]
    fAsesorNombre: NullableString;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('SOLICITUDES_MES')]
    fSolicitudesMes: NullableInt32;
    [MVCTableField('ESPERANDO_COTIZACION')]
    fEsperandoCotizacion: NullableInt32;
    [MVCTableField('APROBADAS_MES')]
    fAprobadasMes: NullableInt32;
    [MVCTableField('MONTO_APROBADO_MES')]
    fMontoAprobadoMes: NullableCurrency;
  public
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property AsesorNombre: NullableString read fAsesorNombre write fAsesorNombre;
    property Activo: NullableBoolean read fActivo write fActivo;
    property SolicitudesMes: NullableInt32 read fSolicitudesMes write fSolicitudesMes;
    property EsperandoCotizacion: NullableInt32 read fEsperandoCotizacion write fEsperandoCotizacion;
    property AprobadasMes: NullableInt32 read fAprobadasMes write fAprobadasMes;
    property MontoAprobadoMes: NullableCurrency read fMontoAprobadoMes write fMontoAprobadoMes;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_AUDITORIA')]
  TVAuditoria = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('FECHA')]
    fFecha: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('USUARIO_ID')]
    fUsuarioId: NullableInt32;
    [MVCTableField('USUARIO_NOMBRE')]
    [MVCMaxLength(120)]
    fUsuarioNombre: NullableString;
    [MVCTableField('ACCION')]
    [MVCMaxLength(50)]
    fAccion: NullableString;
    [MVCTableField('ENTIDAD')]
    [MVCMaxLength(50)]
    fEntidad: NullableString;
    [MVCTableField('ENTIDAD_ID')]
    fEntidadId: NullableInt32;
    [MVCTableField('DETALLE')]
    [MVCMaxLength(500)]
    fDetalle: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property Fecha: NullableTDateTime {dtDateTimeStamp} read fFecha write fFecha;
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    property UsuarioNombre: NullableString read fUsuarioNombre write fUsuarioNombre;
    property Accion: NullableString read fAccion write fAccion;
    property Entidad: NullableString read fEntidad write fEntidad;
    property EntidadId: NullableInt32 read fEntidadId write fEntidadId;
    property Detalle: NullableString read fDetalle write fDetalle;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_CATALOGO_ITEMS')]
  TVCatalogoItems = class(TMVCActiveRecord)
  private
    [MVCTableField('TIPO')]
    [MVCMaxLength(10)]
    fTipo: NullableString;
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('CODIGO')]
    [MVCMaxLength(30)]
    fCodigo: NullableString;
    [MVCTableField('NOMBRE')]
    [MVCMaxLength(120)]
    fNombre: NullableString;
    [MVCTableField('DESCRIPCION')]
    [MVCMaxLength(500)]
    fDescripcion: NullableString;
    [MVCTableField('UNIDAD_MEDIDA_ID')]
    fUnidadMedidaId: NullableInt32;
    [MVCTableField('UNIDAD_MEDIDA')]
    [MVCMaxLength(20)]
    fUnidadMedida: NullableString;
    [MVCTableField('CATEGORIA_ID')]
    fCategoriaId: NullableInt32;
    [MVCTableField('CATEGORIA_NOMBRE')]
    [MVCMaxLength(120)]
    fCategoriaNombre: NullableString;
    [MVCTableField('COSTO_UNITARIO')]
    fCostoUnitario: NullableCurrency;
    [MVCTableField('PRECIO_UNITARIO')]
    fPrecioUnitario: NullableCurrency;
    [MVCTableField('COSTO_HORA')]
    fCostoHora: NullableCurrency;
    [MVCTableField('COSTO')]
    fCosto: NullableCurrency;
    [MVCTableField('FECHA_VIGENCIA')]
    fFechaVigencia: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('PROGRAMADO_FECHA')]
    fProgramadoFecha: NullableTDateTime {dtDateTimeStamp};
  public
    property Tipo: NullableString read fTipo write fTipo;
    property ID: NullableInt32 read fID write fID;
    property Codigo: NullableString read fCodigo write fCodigo;
    property Nombre: NullableString read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedidaId: NullableInt32 read fUnidadMedidaId write fUnidadMedidaId;
    property UnidadMedida: NullableString read fUnidadMedida write fUnidadMedida;
    property CategoriaId: NullableInt32 read fCategoriaId write fCategoriaId;
    property CategoriaNombre: NullableString read fCategoriaNombre write fCategoriaNombre;
    property CostoUnitario: NullableCurrency read fCostoUnitario write fCostoUnitario;
    property PrecioUnitario: NullableCurrency read fPrecioUnitario write fPrecioUnitario;
    property CostoHora: NullableCurrency read fCostoHora write fCostoHora;
    property Costo: NullableCurrency read fCosto write fCosto;
    property FechaVigencia: NullableTDateTime {dtDateTimeStamp} read fFechaVigencia write fFechaVigencia;
    property Activo: NullableBoolean read fActivo write fActivo;
    property ProgramadoFecha: NullableTDateTime {dtDateTimeStamp} read fProgramadoFecha write fProgramadoFecha;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_COTIZACIONES')]
  TVCotizaciones = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('NUMERO')]
    fNumero: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('DESCRIPCION_TRABAJO')]
    [MVCMaxLength(500)]
    fDescripcionTrabajo: NullableString;
    [MVCTableField('SUBTOTAL_MATERIALES')]
    fSubtotalMateriales: NullableCurrency;
    [MVCTableField('SUBTOTAL_MANO_OBRA')]
    fSubtotalManoObra: NullableCurrency;
    [MVCTableField('SUBTOTAL_MAQUINA')]
    fSubtotalMaquina: NullableCurrency;
    [MVCTableField('COSTO_TOTAL')]
    fCostoTotal: NullableCurrency;
    [MVCTableField('PORCENTAJE_AJUSTE')]
    fPorcentajeAjuste: NullableCurrency;
    [MVCTableField('MOTIVO_AJUSTE')]
    [MVCMaxLength(500)]
    fMotivoAjuste: NullableString;
    [MVCTableField('PORCENTAJE_IVA')]
    fPorcentajeIva: NullableCurrency;
    [MVCTableField('MONTO_IMPUESTO')]
    fMontoImpuesto: NullableCurrency;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
    [MVCTableField('MOTIVO_RECHAZO')]
    [MVCMaxLength(500)]
    fMotivoRechazo: NullableString;
    [MVCTableField('FECHA_ELABORACION')]
    fFechaElaboracion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_APROBACION')]
    fFechaAprobacion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_ENVIO')]
    fFechaEnvio: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('SOLICITUD_ID')]
    fSolicitudId: NullableInt32;
    [MVCTableField('FECHA_RECEPCION')]
    fFechaRecepcion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('CLIENTE_ID')]
    fClienteId: NullableInt32;
    [MVCTableField('CLIENTE_NOMBRE')]
    [MVCMaxLength(120)]
    fClienteNombre: NullableString;
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ASESOR_NOMBRE')]
    [MVCMaxLength(120)]
    fAsesorNombre: NullableString;
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('ELABORADA_POR_NOMBRE')]
    [MVCMaxLength(120)]
    fElaboradaPorNombre: NullableString;
    [MVCTableField('APROBADA_POR')]
    fAprobadaPor: NullableInt32;
    [MVCTableField('APROBADA_POR_NOMBRE')]
    [MVCMaxLength(120)]
    fAprobadaPorNombre: NullableString;
    [MVCTableField('TIPO_TRABAJO_ID')]
    fTipoTrabajoId: NullableInt32;
    [MVCTableField('TIPO_TRABAJO_NOMBRE')]
    [MVCMaxLength(120)]
    fTipoTrabajoNombre: NullableString;
    [MVCTableField('DEVUELTA')]
    fDevuelta: NullableBoolean;
    [MVCTableField('DIAS_EN_ESTADO')]
    fDiasEnEstado: NullableInt32;
    [MVCTableField('DIAS_RESPUESTA')]
    fDiasRespuesta: NullableInt32;
  public
    property ID: NullableInt32 read fID write fID;
    property Numero: NullableInt32 read fNumero write fNumero;
    property Estado: NullableString read fEstado write fEstado;
    property DescripcionTrabajo: NullableString read fDescripcionTrabajo write fDescripcionTrabajo;
    property SubtotalMateriales: NullableCurrency read fSubtotalMateriales write fSubtotalMateriales;
    property SubtotalManoObra: NullableCurrency read fSubtotalManoObra write fSubtotalManoObra;
    property SubtotalMaquina: NullableCurrency read fSubtotalMaquina write fSubtotalMaquina;
    property CostoTotal: NullableCurrency read fCostoTotal write fCostoTotal;
    property PorcentajeAjuste: NullableCurrency read fPorcentajeAjuste write fPorcentajeAjuste;
    property MotivoAjuste: NullableString read fMotivoAjuste write fMotivoAjuste;
    property PorcentajeIva: NullableCurrency read fPorcentajeIva write fPorcentajeIva;
    property MontoImpuesto: NullableCurrency read fMontoImpuesto write fMontoImpuesto;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property MotivoRechazo: NullableString read fMotivoRechazo write fMotivoRechazo;
    property FechaElaboracion: NullableTDateTime {dtDateTimeStamp} read fFechaElaboracion write fFechaElaboracion;
    property FechaAprobacion: NullableTDateTime {dtDateTimeStamp} read fFechaAprobacion write fFechaAprobacion;
    property FechaEnvio: NullableTDateTime {dtDateTimeStamp} read fFechaEnvio write fFechaEnvio;
    property FechaModificacion: NullableTDateTime {dtDateTimeStamp} read fFechaModificacion write fFechaModificacion;
    property SolicitudId: NullableInt32 read fSolicitudId write fSolicitudId;
    property FechaRecepcion: NullableTDateTime {dtDateTimeStamp} read fFechaRecepcion write fFechaRecepcion;
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property ClienteNombre: NullableString read fClienteNombre write fClienteNombre;
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property AsesorNombre: NullableString read fAsesorNombre write fAsesorNombre;
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property ElaboradaPorNombre: NullableString read fElaboradaPorNombre write fElaboradaPorNombre;
    property AprobadaPor: NullableInt32 read fAprobadaPor write fAprobadaPor;
    property AprobadaPorNombre: NullableString read fAprobadaPorNombre write fAprobadaPorNombre;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId write fTipoTrabajoId;
    property TipoTrabajoNombre: NullableString read fTipoTrabajoNombre write fTipoTrabajoNombre;
    property Devuelta: NullableBoolean read fDevuelta write fDevuelta;
    property DiasEnEstado: NullableInt32 read fDiasEnEstado write fDiasEnEstado;
    property DiasRespuesta: NullableInt32 read fDiasRespuesta write fDiasRespuesta;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_CLIENTES_RESPUESTA')]
  TVClientesRespuesta = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('NUMERO')]
    fNumero: NullableInt32;
    [MVCTableField('CLIENTE_ID')]
    fClienteId: NullableInt32;
    [MVCTableField('CLIENTE_NOMBRE')]
    [MVCMaxLength(120)]
    fClienteNombre: NullableString;
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('FECHA_ENVIO')]
    fFechaEnvio: NullableTDateTime;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
    [MVCTableField('DIAS_SIN_RESPUESTA')]
    fDiasSinRespuesta: NullableInt32;
  public
    property ID: NullableInt32 read fID write fID;
    property Numero: NullableInt32 read fNumero write fNumero;
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property ClienteNombre: NullableString read fClienteNombre write fClienteNombre;
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property Estado: NullableString read fEstado write fEstado;
    property FechaEnvio: NullableTDateTime read fFechaEnvio write fFechaEnvio;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property DiasSinRespuesta: NullableInt32 read fDiasSinRespuesta write fDiasSinRespuesta;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_COTIZACIONES_DIA')]
  TVCotizacionesDia = class(TMVCActiveRecord)
  private
    [MVCTableField('FECHA')]
    fFecha: NullableTDate;
    [MVCTableField('ANIO')]
    fAnio: NullableInt32;
    [MVCTableField('MES')]
    fMes: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ASESOR_NOMBRE')]
    [MVCMaxLength(120)]
    fAsesorNombre: NullableString;
    [MVCTableField('TIPO_TRABAJO_ID')]
    fTipoTrabajoId: NullableInt32;
    [MVCTableField('TIPO_TRABAJO_NOMBRE')]
    [MVCMaxLength(120)]
    fTipoTrabajoNombre: NullableString;
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
    [MVCTableField('APROBADAS')]
    fAprobadas: NullableInt32;
    [MVCTableField('RECHAZADAS')]
    fRechazadas: NullableInt32;
    [MVCTableField('MONTO_APROBADO')]
    fMontoAprobado: NullableCurrency;
    [MVCTableField('SUMA_DIAS_RESPUESTA')]
    fSumaDiasRespuesta: NullableInt32;
    [MVCTableField('CON_RESPUESTA')]
    fConRespuesta: NullableInt32;
  public
    property Fecha: NullableTDate read fFecha write fFecha;
    property Anio: NullableInt32 read fAnio write fAnio;
    property Mes: NullableInt32 read fMes write fMes;
    property Estado: NullableString read fEstado write fEstado;
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property AsesorNombre: NullableString read fAsesorNombre write fAsesorNombre;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId write fTipoTrabajoId;
    property TipoTrabajoNombre: NullableString read fTipoTrabajoNombre write fTipoTrabajoNombre;
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property Aprobadas: NullableInt32 read fAprobadas write fAprobadas;
    property Rechazadas: NullableInt32 read fRechazadas write fRechazadas;
    property MontoAprobado: NullableCurrency read fMontoAprobado write fMontoAprobado;
    property SumaDiasRespuesta: NullableInt32 read fSumaDiasRespuesta write fSumaDiasRespuesta;
    property ConRespuesta: NullableInt32 read fConRespuesta write fConRespuesta;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_COTIZACIONES_POR_ESTADO')]
  TVCotizacionesPorEstado = class(TMVCActiveRecord)
  private
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('ORDEN')]
    fOrden: NullableInt32;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
    [MVCTableField('MONTO')]
    fMonto: NullableCurrency;
  public
    property Estado: NullableString read fEstado write fEstado;
    property Orden: NullableInt32 read fOrden write fOrden;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
    property Monto: NullableCurrency read fMonto write fMonto;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_CUENTAS_RESUMEN')]
  TVCuentasResumen = class(TMVCActiveRecord)
  private
    [MVCTableField('USUARIOS_ACTIVOS')]
    fUsuariosActivos: NullableInt32;
    [MVCTableField('USUARIOS_INACTIVOS')]
    fUsuariosInactivos: NullableInt32;
    [MVCTableField('CLAVE_PENDIENTE')]
    fClavePendiente: NullableInt32;
    [MVCTableField('CAMBIOS_MES')]
    fCambiosMes: NullableInt32;
  public
    property UsuariosActivos: NullableInt32 read fUsuariosActivos write fUsuariosActivos;
    property UsuariosInactivos: NullableInt32 read fUsuariosInactivos write fUsuariosInactivos;
    property ClavePendiente: NullableInt32 read fClavePendiente write fClavePendiente;
    property CambiosMes: NullableInt32 read fCambiosMes write fCambiosMes;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_PERIODO_ACTUAL')]
  TVPeriodoActual = class(TMVCActiveRecord)
  private
    [MVCTableField('MES_DESDE')]
    fMesDesde: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('MES_HASTA')]
    fMesHasta: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('SEMANA_DESDE')]
    fSemanaDesde: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('SEMANA_HASTA')]
    fSemanaHasta: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('MES_ANTERIOR')]
    fMesAnterior: NullableTDateTime {dtDateTimeStamp};
  public
    property MesDesde: NullableTDateTime {dtDateTimeStamp} read fMesDesde write fMesDesde;
    property MesHasta: NullableTDateTime {dtDateTimeStamp} read fMesHasta write fMesHasta;
    property SemanaDesde: NullableTDateTime {dtDateTimeStamp} read fSemanaDesde write fSemanaDesde;
    property SemanaHasta: NullableTDateTime {dtDateTimeStamp} read fSemanaHasta write fSemanaHasta;
    property MesAnterior: NullableTDateTime {dtDateTimeStamp} read fMesAnterior write fMesAnterior;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_RESUMEN_MES')]
  TVResumenMes = class(TMVCActiveRecord)
  private
    [MVCTableField('DESDE')]
    fDesde: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('HASTA')]
    fHasta: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('COTIZADO_MES')]
    fCotizadoMes: NullableCurrency;
    [MVCTableField('APROBADAS_MES')]
    fAprobadasMes: NullableInt32;
    [MVCTableField('MONTO_APROBADO_MES')]
    fMontoAprobadoMes: NullableCurrency;
    [MVCTableField('RECHAZADAS_MES')]
    fRechazadasMes: NullableInt32;
    [MVCTableField('RESPUESTA_MEDIA')]
    fRespuestaMedia: NullableInt32;
    [MVCTableField('ASESORES_ACTIVOS')]
    fAsesoresActivos: NullableInt32;
    [MVCTableField('TASA_APROBACION')]
    fTasaAprobacion: NullableCurrency;
  public
    property Desde: NullableTDateTime {dtDateTimeStamp} read fDesde write fDesde;
    property Hasta: NullableTDateTime {dtDateTimeStamp} read fHasta write fHasta;
    property CotizadoMes: NullableCurrency read fCotizadoMes write fCotizadoMes;
    property AprobadasMes: NullableInt32 read fAprobadasMes write fAprobadasMes;
    property MontoAprobadoMes: NullableCurrency read fMontoAprobadoMes write fMontoAprobadoMes;
    property RechazadasMes: NullableInt32 read fRechazadasMes write fRechazadasMes;
    property RespuestaMedia: NullableInt32 read fRespuestaMedia write fRespuestaMedia;
    property AsesoresActivos: NullableInt32 read fAsesoresActivos write fAsesoresActivos;
    property TasaAprobacion: NullableCurrency read fTasaAprobacion write fTasaAprobacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_SEGUIMIENTO_ASESOR')]
  TVSeguimientoAsesor = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('FECHA_CAPTURA')]
    fFechaCaptura: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('CLIENTE_NOMBRE')]
    [MVCMaxLength(120)]
    fClienteNombre: NullableString;
    [MVCTableField('DESCRIPCION')]
    [MVCMaxLength(500)]
    fDescripcion: NullableString;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('COTIZACION_ID')]
    fCotizacionId: NullableInt32;
    [MVCTableField('MONTO_APROBADO')]
    fMontoAprobado: NullableCurrency;
    [MVCTableField('UUID_LOCAL')]
    [MVCMaxLength(36)]
    fUuidLocal: NullableString;
    [MVCTableField('NOMBRE_PROYECTO')]
    [MVCMaxLength(120)]
    fNombreProyecto: NullableString;
    [MVCTableField('COTIZACION_NUMERO')]
    fCotizacionNumero: NullableInt32;
    [MVCTableField('FECHA_CAMBIO')]
    fFechaCambio: NullableTDateTime {dtDateTimeStamp};
  public
    property ID: NullableInt32 read fID write fID;
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property FechaCaptura: NullableTDateTime {dtDateTimeStamp} read fFechaCaptura write fFechaCaptura;
    property ClienteNombre: NullableString read fClienteNombre write fClienteNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property Estado: NullableString read fEstado write fEstado;
    property CotizacionId: NullableInt32 read fCotizacionId write fCotizacionId;
    property MontoAprobado: NullableCurrency read fMontoAprobado write fMontoAprobado;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property NombreProyecto: NullableString read fNombreProyecto write fNombreProyecto;
    property CotizacionNumero: NullableInt32 read fCotizacionNumero write fCotizacionNumero;
    property FechaCambio: NullableTDateTime {dtDateTimeStamp} read fFechaCambio write fFechaCambio;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_SOLICITUDES')]
  TVSolicitudes = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('DESCRIPCION')]
    [MVCMaxLength(500)]
    fDescripcion: NullableString;
    [MVCTableField('FECHA_CAPTURA')]
    fFechaCaptura: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_RECEPCION')]
    fFechaRecepcion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('CLIENTE_ID')]
    fClienteId: NullableInt32;
    [MVCTableField('CLIENTE_NOMBRE')]
    [MVCMaxLength(120)]
    fClienteNombre: NullableString;
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ASESOR_NOMBRE')]
    [MVCMaxLength(120)]
    fAsesorNombre: NullableString;
    [MVCTableField('DIAS_ESPERA')]
    fDiasEspera: NullableInt32;
    [MVCTableField('TIENE_COTIZACION')]
    fTieneCotizacion: NullableBoolean;
  public
    property ID: NullableInt32 read fID write fID;
    property Estado: NullableString read fEstado write fEstado;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property FechaCaptura: NullableTDateTime {dtDateTimeStamp} read fFechaCaptura write fFechaCaptura;
    property FechaRecepcion: NullableTDateTime {dtDateTimeStamp} read fFechaRecepcion write fFechaRecepcion;
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property ClienteNombre: NullableString read fClienteNombre write fClienteNombre;
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property AsesorNombre: NullableString read fAsesorNombre write fAsesorNombre;
    property DiasEspera: NullableInt32 read fDiasEspera write fDiasEspera;
    property TieneCotizacion: NullableBoolean read fTieneCotizacion write fTieneCotizacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_TRABAJO_USUARIO')]
  TVTrabajoUsuario = class(TMVCActiveRecord)
  private
    [MVCTableField('USUARIO_ID')]
    fUsuarioId: NullableInt32;
    [MVCTableField('POR_COTIZAR')]
    fPorCotizar: NullableInt32;
    [MVCTableField('MIS_BORRADORES')]
    fMisBorradores: NullableInt32;
    [MVCTableField('EN_APROBACION')]
    fEnAprobacion: NullableInt32;
    [MVCTableField('POR_ENVIAR')]
    fPorEnviar: NullableInt32;
    [MVCTableField('POR_APROBAR')]
    fPorAprobar: NullableInt32;
    [MVCTableField('DIAS_MAS_ANTIGUA')]
    fDiasMasAntigua: NullableInt32;
    [MVCTableField('MONTO_POR_APROBAR')]
    fMontoPorAprobar: NullableCurrency;
  public
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    property PorCotizar: NullableInt32 read fPorCotizar write fPorCotizar;
    property MisBorradores: NullableInt32 read fMisBorradores write fMisBorradores;
    property EnAprobacion: NullableInt32 read fEnAprobacion write fEnAprobacion;
    property PorEnviar: NullableInt32 read fPorEnviar write fPorEnviar;
    property PorAprobar: NullableInt32 read fPorAprobar write fPorAprobar;
    property DiasMasAntigua: NullableInt32 read fDiasMasAntigua write fDiasMasAntigua;
    property MontoPorAprobar: NullableCurrency read fMontoPorAprobar write fMontoPorAprobar;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_SOLICITUD_ADJUNTOS')]
  TVSolicitudAdjuntos = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('SOLICITUD_ID')]
    fSolicitudId: NullableInt32;
    [MVCTableField('PIEZA_ID')]
    fPiezaId: NullableInt32;
    [MVCTableField('PIEZA_NOMBRE')]
    [MVCMaxLength(120)]
    fPiezaNombre: NullableString;
    [MVCTableField('UUID_LOCAL')]
    [MVCMaxLength(36)]
    fUuidLocal: NullableString;
    [MVCTableField('TIPO')]
    [MVCMaxLength(10)]
    fTipo: NullableString;
    [MVCTableField('NOMBRE_ARCHIVO')]
    [MVCMaxLength(120)]
    fNombreArchivo: NullableString;
    [MVCTableField('MIME')]
    [MVCMaxLength(40)]
    fMime: NullableString;
    [MVCTableField('TAMANO_BYTES')]
    fTamanoBytes: NullableInt32;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime {dtDateTimeStamp};
  public
    property ID: NullableInt32 read fID write fID;
    property SolicitudId: NullableInt32 read fSolicitudId write fSolicitudId;
    property PiezaId: NullableInt32 read fPiezaId write fPiezaId;
    property PiezaNombre: NullableString read fPiezaNombre write fPiezaNombre;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property Tipo: NullableString read fTipo write fTipo;
    property NombreArchivo: NullableString read fNombreArchivo write fNombreArchivo;
    property Mime: NullableString read fMime write fMime;
    property TamanoBytes: NullableInt32 read fTamanoBytes write fTamanoBytes;
    property Activo: NullableBoolean read fActivo write fActivo;
    property FechaCreacion: NullableTDateTime {dtDateTimeStamp} read fFechaCreacion write fFechaCreacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_SOLICITUD_MEDIDAS')]
  TVSolicitudMedidas = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('SOLICITUD_ID')]
    fSolicitudId: NullableInt32;
    [MVCTableField('PIEZA_ID')]
    fPiezaId: NullableInt32;
    [MVCTableField('PIEZA_NOMBRE')]
    [MVCMaxLength(120)]
    fPiezaNombre: NullableString;
    [MVCTableField('UUID_LOCAL')]
    [MVCMaxLength(36)]
    fUuidLocal: NullableString;
    [MVCTableField('CROQUIS_ID')]
    fCroquisId: NullableInt32;
    [MVCTableField('ETIQUETA')]
    [MVCMaxLength(5)]
    fEtiqueta: NullableString;
    [MVCTableField('TIPO_MEDIDA')]
    [MVCMaxLength(30)]
    fTipoMedida: NullableString;
    [MVCTableField('VALOR')]
    fValor: NullableCurrency;
    [MVCTableField('UNIDAD_MEDIDA')]
    [MVCMaxLength(10)]
    fUnidadMedida: NullableString;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt16;
    [MVCTableField('OBSERVACION')]
    [MVCMaxLength(500)]
    fObservacion: NullableString;
    [MVCTableField('ORDEN')]
    fOrden: NullableInt16;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
  public
    property ID: NullableInt32 read fID write fID;
    property SolicitudId: NullableInt32 read fSolicitudId write fSolicitudId;
    property PiezaId: NullableInt32 read fPiezaId write fPiezaId;
    property PiezaNombre: NullableString read fPiezaNombre write fPiezaNombre;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property CroquisId: NullableInt32 read fCroquisId write fCroquisId;
    property Etiqueta: NullableString read fEtiqueta write fEtiqueta;
    property TipoMedida: NullableString read fTipoMedida write fTipoMedida;
    property Valor: NullableCurrency read fValor write fValor;
    property UnidadMedida: NullableString read fUnidadMedida write fUnidadMedida;
    property Cantidad: NullableInt16 read fCantidad write fCantidad;
    property Observacion: NullableString read fObservacion write fObservacion;
    property Orden: NullableInt16 read fOrden write fOrden;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_SOLICITUD_PIEZAS')]
  TVSolicitudPiezas = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('SOLICITUD_ID')]
    fSolicitudId: NullableInt32;
    [MVCTableField('UUID_LOCAL')]
    [MVCMaxLength(36)]
    fUuidLocal: NullableString;
    [MVCTableField('NOMBRE')]
    [MVCMaxLength(120)]
    fNombre: NullableString;
    [MVCTableField('ORDEN')]
    fOrden: NullableInt16;
    [MVCTableField('TIPO_TRABAJO_ID')]
    fTipoTrabajoId: NullableInt32;
    [MVCTableField('TIPO_TRABAJO_NOMBRE')]
    [MVCMaxLength(120)]
    fTipoTrabajoNombre: NullableString;
    [MVCTableField('TIPO_MATERIAL_ID')]
    fTipoMaterialId: NullableInt32;
    [MVCTableField('TIPO_MATERIAL_NOMBRE')]
    [MVCMaxLength(120)]
    fTipoMaterialNombre: NullableString;
    [MVCTableField('ACABADO_ID')]
    fAcabadoId: NullableInt32;
    [MVCTableField('ACABADO_NOMBRE')]
    [MVCMaxLength(120)]
    fAcabadoNombre: NullableString;
    [MVCTableField('MEDIDAS')]
    fMedidas: NullableInt32;
    [MVCTableField('FOTOS')]
    fFotos: NullableInt32;
    [MVCTableField('CROQUIS')]
    fCroquis: NullableInt32;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
  public
    property ID: NullableInt32 read fID write fID;
    property SolicitudId: NullableInt32 read fSolicitudId write fSolicitudId;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property Nombre: NullableString read fNombre write fNombre;
    property Orden: NullableInt16 read fOrden write fOrden;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId write fTipoTrabajoId;
    property TipoTrabajoNombre: NullableString read fTipoTrabajoNombre write fTipoTrabajoNombre;
    property TipoMaterialId: NullableInt32 read fTipoMaterialId write fTipoMaterialId;
    property TipoMaterialNombre: NullableString read fTipoMaterialNombre write fTipoMaterialNombre;
    property AcabadoId: NullableInt32 read fAcabadoId write fAcabadoId;
    property AcabadoNombre: NullableString read fAcabadoNombre write fAcabadoNombre;
    property Medidas: NullableInt32 read fMedidas write fMedidas;
    property Fotos: NullableInt32 read fFotos write fFotos;
    property Croquis: NullableInt32 read fCroquis write fCroquis;
    property Activo: NullableBoolean read fActivo write fActivo;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_CONSENTIMIENTOS')]
  TVConsentimientos = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('CLIENTE_ID')]
    fClienteId: NullableInt32;
    [MVCTableField('CLIENTE_CONTACTO_ID')]
    fClienteContactoId: NullableInt32;
    [MVCTableField('ACCION')]
    [MVCMaxLength(20)]
    fAccion: NullableString;
    [MVCTableField('VERSION_TEXTO')]
    [MVCMaxLength(10)]
    fVersionTexto: NullableString;
    [MVCTableField('FECHA')]
    fFecha: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FIRMANTE_NOMBRE')]
    [MVCMaxLength(120)]
    fFirmanteNombre: NullableString;
    [MVCTableField('FIRMANTE_IDENTIFICACION')]
    [MVCMaxLength(30)]
    fFirmanteIdentificacion: NullableString;
    [MVCTableField('FIRMA_MIME')]
    [MVCMaxLength(40)]
    fFirmaMime: NullableString;
    [MVCTableField('ORIGEN')]
    [MVCMaxLength(20)]
    fOrigen: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property ClienteContactoId: NullableInt32 read fClienteContactoId write fClienteContactoId;
    property Accion: NullableString read fAccion write fAccion;
    property VersionTexto: NullableString read fVersionTexto write fVersionTexto;
    property Fecha: NullableTDateTime {dtDateTimeStamp} read fFecha write fFecha;
    property FirmanteNombre: NullableString read fFirmanteNombre write fFirmanteNombre;
    property FirmanteIdentificacion: NullableString read fFirmanteIdentificacion write fFirmanteIdentificacion;
    property FirmaMime: NullableString read fFirmaMime write fFirmaMime;
    property Origen: NullableString read fOrigen write fOrigen;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_PERMISOS_ROLES')]
  TVPermisosRoles = class(TMVCActiveRecord)
  private
    [MVCTableField('ROL')]
    [MVCMaxLength(20)]
    fRol: NullableString;
    [MVCTableField('PERMISO')]
    [MVCMaxLength(50)]
    fPermiso: NullableString;
  public
    property Rol: NullableString read fRol write fRol;
    property Permiso: NullableString read fPermiso write fPermiso;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_ROLES')]
  TVRoles = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('CODIGO')]
    [MVCMaxLength(20)]
    fCodigo: NullableString;
    [MVCTableField('NOMBRE')]
    [MVCMaxLength(120)]
    fNombre: NullableString;
    [MVCTableField('AMBITO')]
    [MVCMaxLength(15)]
    fAmbito: NullableString;
    [MVCTableField('USUARIOS_ACTIVOS')]
    fUsuariosActivos: NullableInt32;
  public
    property ID: NullableInt32 read fID write fID;
    property Codigo: NullableString read fCodigo write fCodigo;
    property Nombre: NullableString read fNombre write fNombre;
    property Ambito: NullableString read fAmbito write fAmbito;
    property UsuariosActivos: NullableInt32 read fUsuariosActivos write fUsuariosActivos;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_USUARIOS')]
  TVUsuarios = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('CORREO')]
    [MVCMaxLength(150)]
    fCorreo: NullableString;
    [MVCTableField('NOMBRE')]
    [MVCMaxLength(120)]
    fNombre: NullableString;
    [MVCTableField('ROL_ID')]
    fRolId: NullableInt32;
    [MVCTableField('ROL')]
    [MVCMaxLength(20)]
    fRol: NullableString;
    [MVCTableField('ROL_NOMBRE')]
    [MVCMaxLength(120)]
    fRolNombre: NullableString;
    [MVCTableField('AMBITO')]
    [MVCMaxLength(15)]
    fAmbito: NullableString;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('DEBE_CAMBIAR_CLAVE')]
    fDebeCambiarClave: NullableBoolean;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_CLAVE')]
    fFechaClave: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('EXCEPCIONES')]
    fExcepciones: NullableInt32;
  public
    property ID: NullableInt32 read fID write fID;
    property Correo: NullableString read fCorreo write fCorreo;
    property Nombre: NullableString read fNombre write fNombre;
    property RolId: NullableInt32 read fRolId write fRolId;
    property Rol: NullableString read fRol write fRol;
    property RolNombre: NullableString read fRolNombre write fRolNombre;
    property Ambito: NullableString read fAmbito write fAmbito;
    property Activo: NullableBoolean read fActivo write fActivo;
    property DebeCambiarClave: NullableBoolean read fDebeCambiarClave write fDebeCambiarClave;
    property FechaCreacion: NullableTDateTime {dtDateTimeStamp} read fFechaCreacion write fFechaCreacion;
    property FechaModificacion: NullableTDateTime {dtDateTimeStamp} read fFechaModificacion write fFechaModificacion;
    property FechaClave: NullableTDateTime {dtDateTimeStamp} read fFechaClave write fFechaClave;
    property Excepciones: NullableInt32 read fExcepciones write fExcepciones;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_USUARIOS_PERMISOS')]
  TVUsuariosPermisos = class(TMVCActiveRecord)
  private
    [MVCTableField('USUARIO_ID')]
    fUsuarioId: NullableInt32;
    [MVCTableField('PERMISO_ID')]
    fPermisoId: NullableInt32;
    [MVCTableField('PERMISO')]
    [MVCMaxLength(50)]
    fPermiso: NullableString;
    [MVCTableField('NOMBRE')]
    [MVCMaxLength(120)]
    fNombre: NullableString;
    [MVCTableField('MODULO')]
    [MVCMaxLength(30)]
    fModulo: NullableString;
    [MVCTableField('TIPO')]
    [MVCMaxLength(10)]
    fTipo: NullableString;
    [MVCTableField('MOTIVO')]
    [MVCMaxLength(500)]
    fMotivo: NullableString;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime {dtDateTimeStamp};
  public
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    property PermisoId: NullableInt32 read fPermisoId write fPermisoId;
    property Permiso: NullableString read fPermiso write fPermiso;
    property Nombre: NullableString read fNombre write fNombre;
    property Modulo: NullableString read fModulo write fModulo;
    property Tipo: NullableString read fTipo write fTipo;
    property Motivo: NullableString read fMotivo write fMotivo;
    property FechaCreacion: NullableTDateTime {dtDateTimeStamp} read fFechaCreacion write fFechaCreacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_VERSION_ESQUEMA')]
  TVVersionEsquema = class(TMVCActiveRecord)
  private
    [MVCTableField('NUMERO')]
    fNumero: NullableInt32;
  public
    property Numero: NullableInt32 read fNumero write fNumero;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_COTIZACION_HISTORIAL')]
  TVCotizacionHistorial = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('COTIZACION_ID')]
    fCotizacionId: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('FECHA')]
    fFecha: NullableTDateTime;
    [MVCTableField('USUARIO_ID')]
    fUsuarioId: NullableInt32;
    [MVCTableField('USUARIO_NOMBRE')]
    [MVCMaxLength(120)]
    fUsuarioNombre: NullableString;
    [MVCTableField('MOTIVO')]
    [MVCMaxLength(500)]
    fMotivo: NullableString;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
  public
    property ID: NullableInt32 read fID write fID;
    property CotizacionId: NullableInt32 read fCotizacionId write fCotizacionId;
    property Estado: NullableString read fEstado write fEstado;
    property Fecha: NullableTDateTime read fFecha write fFecha;
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    property UsuarioNombre: NullableString read fUsuarioNombre write fUsuarioNombre;
    property Motivo: NullableString read fMotivo write fMotivo;
    property Activo: NullableBoolean read fActivo write fActivo;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_CARGA')]
  TVDashCarga = class(TMVCActiveRecord)
  private
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('ELABORADA_POR_NOMBRE')]
    [MVCMaxLength(120)]
    fElaboradaPorNombre: NullableString;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
  public
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property ElaboradaPorNombre: NullableString read fElaboradaPorNombre write fElaboradaPorNombre;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_ENVIADAS')]
  TVDashEnviadas = class(TMVCActiveRecord)
  private
    [MVCTableField('COTIZACION_ID')]
    fCotizacionId: NullableInt32;
    [MVCTableField('NUMERO')]
    fNumero: NullableInt32;
    [MVCTableField('CLIENTE_NOMBRE')]
    [MVCMaxLength(120)]
    fClienteNombre: NullableString;
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('FECHA_ENVIO')]
    fFechaEnvio: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('DIAS_SIN_RESPUESTA')]
    fDiasSinRespuesta: NullableInt32;
    [MVCTableField('DIAS')]
    fDias: NullableInt32;
    [MVCTableField('NIVEL')]
    [MVCMaxLength(5)]
    fNivel: NullableString;
  public
    property CotizacionId: NullableInt32 read fCotizacionId write fCotizacionId;
    property Numero: NullableInt32 read fNumero write fNumero;
    property ClienteNombre: NullableString read fClienteNombre write fClienteNombre;
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property FechaEnvio: NullableTDateTime {dtDateTimeStamp} read fFechaEnvio write fFechaEnvio;
    property DiasSinRespuesta: NullableInt32 read fDiasSinRespuesta write fDiasSinRespuesta;
    property Dias: NullableInt32 read fDias write fDias;
    property Nivel: NullableString read fNivel write fNivel;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_EN_CURSO')]
  TVDashEnCurso = class(TMVCActiveRecord)
  private
    [MVCTableField('COTIZACION_ID')]
    fCotizacionId: NullableInt32;
    [MVCTableField('NUMERO')]
    fNumero: NullableInt32;
    [MVCTableField('CLIENTE_NOMBRE')]
    [MVCMaxLength(120)]
    fClienteNombre: NullableString;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('ELABORADA_POR_NOMBRE')]
    [MVCMaxLength(120)]
    fElaboradaPorNombre: NullableString;
    [MVCTableField('MOTIVO_RECHAZO')]
    [MVCMaxLength(500)]
    fMotivoRechazo: NullableString;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('DIAS')]
    fDias: NullableInt32;
    [MVCTableField('ESTANCADA')]
    fEstancada: NullableBoolean;
    [MVCTableField('NIVEL')]
    [MVCMaxLength(5)]
    fNivel: NullableString;
  public
    property CotizacionId: NullableInt32 read fCotizacionId write fCotizacionId;
    property Numero: NullableInt32 read fNumero write fNumero;
    property ClienteNombre: NullableString read fClienteNombre write fClienteNombre;
    property Estado: NullableString read fEstado write fEstado;
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property ElaboradaPorNombre: NullableString read fElaboradaPorNombre write fElaboradaPorNombre;
    property MotivoRechazo: NullableString read fMotivoRechazo write fMotivoRechazo;
    property FechaModificacion: NullableTDateTime {dtDateTimeStamp} read fFechaModificacion write fFechaModificacion;
    property Dias: NullableInt32 read fDias write fDias;
    property Estancada: NullableBoolean read fEstancada write fEstancada;
    property Nivel: NullableString read fNivel write fNivel;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_ESTADO_ASESOR')]
  TVDashEstadoAsesor = class(TMVCActiveRecord)
  private
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('CON_COTIZACION')]
    fConCotizacion: NullableBoolean;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
    [MVCTableField('DIAS_MAS_ANTIGUA')]
    fDiasMasAntigua: NullableInt32;
  public
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property Estado: NullableString read fEstado write fEstado;
    property ConCotizacion: NullableBoolean read fConCotizacion write fConCotizacion;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
    property DiasMasAntigua: NullableInt32 read fDiasMasAntigua write fDiasMasAntigua;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_ETAPAS')]
  TVDashEtapas = class(TMVCActiveRecord)
  private
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
  public
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property Estado: NullableString read fEstado write fEstado;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_PASOS_EQUIPO')]
  TVDashPasosEquipo = class(TMVCActiveRecord)
  private
    [MVCTableField('ANIO')]
    fAnio: NullableInt32;
    [MVCTableField('MES')]
    fMes: NullableInt32;
    [MVCTableField('PRESENTADAS')]
    fPresentadas: NullableInt32;
    [MVCTableField('VISTO_BUENO')]
    fVistoBueno: NullableInt32;
    [MVCTableField('DEVUELTAS')]
    fDevueltas: NullableInt32;
    [MVCTableField('APROBADAS')]
    fAprobadas: NullableInt32;
    [MVCTableField('RECHAZADAS')]
    fRechazadas: NullableInt32;
    [MVCTableField('MONTO_APROBADO')]
    fMontoAprobado: NullableCurrency;
  public
    property Anio: NullableInt32 read fAnio write fAnio;
    property Mes: NullableInt32 read fMes write fMes;
    property Presentadas: NullableInt32 read fPresentadas write fPresentadas;
    property VistoBueno: NullableInt32 read fVistoBueno write fVistoBueno;
    property Devueltas: NullableInt32 read fDevueltas write fDevueltas;
    property Aprobadas: NullableInt32 read fAprobadas write fAprobadas;
    property Rechazadas: NullableInt32 read fRechazadas write fRechazadas;
    property MontoAprobado: NullableCurrency read fMontoAprobado write fMontoAprobado;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_PASOS_MES')]
  TVDashPasosMes = class(TMVCActiveRecord)
  private
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('ANIO')]
    fAnio: NullableInt32;
    [MVCTableField('MES')]
    fMes: NullableInt32;
    [MVCTableField('PRESENTADAS')]
    fPresentadas: NullableInt32;
    [MVCTableField('VISTO_BUENO')]
    fVistoBueno: NullableInt32;
    [MVCTableField('DEVUELTAS')]
    fDevueltas: NullableInt32;
    [MVCTableField('APROBADAS')]
    fAprobadas: NullableInt32;
    [MVCTableField('RECHAZADAS')]
    fRechazadas: NullableInt32;
    [MVCTableField('MONTO_APROBADO')]
    fMontoAprobado: NullableCurrency;
  public
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property Anio: NullableInt32 read fAnio write fAnio;
    property Mes: NullableInt32 read fMes write fMes;
    property Presentadas: NullableInt32 read fPresentadas write fPresentadas;
    property VistoBueno: NullableInt32 read fVistoBueno write fVistoBueno;
    property Devueltas: NullableInt32 read fDevueltas write fDevueltas;
    property Aprobadas: NullableInt32 read fAprobadas write fAprobadas;
    property Rechazadas: NullableInt32 read fRechazadas write fRechazadas;
    property MontoAprobado: NullableCurrency read fMontoAprobado write fMontoAprobado;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_SOLICITUDES_MES')]
  TVDashSolicitudesMes = class(TMVCActiveRecord)
  private
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ANIO')]
    fAnio: NullableInt32;
    [MVCTableField('MES')]
    fMes: NullableInt32;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
  public
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property Anio: NullableInt32 read fAnio write fAnio;
    property Mes: NullableInt32 read fMes write fMes;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_ASESOR_GRUPOS')]
  TVDashAsesorGrupos = class(TMVCActiveRecord)
  private
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('GRUPO')]
    [MVCMaxLength(15)]
    fGrupo: NullableString;
    [MVCTableField('ORDEN')]
    fOrden: NullableInt32;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
    [MVCTableField('DIAS_MAS_ANTIGUA')]
    fDiasMasAntigua: NullableInt32;
  public
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property Grupo: NullableString read fGrupo write fGrupo;
    property Orden: NullableInt32 read fOrden write fOrden;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
    property DiasMasAntigua: NullableInt32 read fDiasMasAntigua write fDiasMasAntigua;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_ASESOR_RESUMEN')]
  TVDashAsesorResumen = class(TMVCActiveRecord)
  private
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('DIAS_MAS_ANTIGUA')]
    fDiasMasAntigua: NullableInt32;
    [MVCTableField('TASA_APROBACION')]
    fTasaAprobacion: NullableCurrency;
    [MVCTableField('SOLICITUDES_MES_ANTERIOR')]
    fSolicitudesMesAnterior: NullableInt32;
    [MVCTableField('VARIACION_SOLICITUDES')]
    fVariacionSolicitudes: NullableInt32;
    [MVCTableField('MONTO_APROBADO_ANTERIOR')]
    fMontoAprobadoAnterior: NullableCurrency;
    [MVCTableField('VARIACION_MONTO')]
    fVariacionMonto: NullableCurrency;
    [MVCTableField('MES_ANTERIOR')]
    fMesAnterior: NullableTDateTime {dtDateTimeStamp};
  public
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property DiasMasAntigua: NullableInt32 read fDiasMasAntigua write fDiasMasAntigua;
    property TasaAprobacion: NullableCurrency read fTasaAprobacion write fTasaAprobacion;
    property SolicitudesMesAnterior: NullableInt32 read fSolicitudesMesAnterior write fSolicitudesMesAnterior;
    property VariacionSolicitudes: NullableInt32 read fVariacionSolicitudes write fVariacionSolicitudes;
    property MontoAprobadoAnterior: NullableCurrency read fMontoAprobadoAnterior write fMontoAprobadoAnterior;
    property VariacionMonto: NullableCurrency read fVariacionMonto write fVariacionMonto;
    property MesAnterior: NullableTDateTime {dtDateTimeStamp} read fMesAnterior write fMesAnterior;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_ASISTENTE_RESUMEN')]
  TVDashAsistenteResumen = class(TMVCActiveRecord)
  private
    [MVCTableField('USUARIO_ID')]
    fUsuarioId: NullableInt32;
    [MVCTableField('DIAS_MAS_ANTIGUA')]
    fDiasMasAntigua: NullableInt32;
    [MVCTableField('DEVUELTAS')]
    fDevueltas: NullableInt32;
    [MVCTableField('SIN_RESPUESTA')]
    fSinRespuesta: NullableInt32;
    [MVCTableField('PRESENTADAS_MES')]
    fPresentadasMes: NullableInt32;
    [MVCTableField('APROBADAS_MES')]
    fAprobadasMes: NullableInt32;
    [MVCTableField('RECHAZADAS_MES')]
    fRechazadasMes: NullableInt32;
    [MVCTableField('MONTO_APROBADO_MES')]
    fMontoAprobadoMes: NullableCurrency;
    [MVCTableField('TASA_MES')]
    fTasaMes: NullableCurrency;
    [MVCTableField('DIAS_PLAZO')]
    fDiasPlazo: NullableInt32;
  public
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    property DiasMasAntigua: NullableInt32 read fDiasMasAntigua write fDiasMasAntigua;
    property Devueltas: NullableInt32 read fDevueltas write fDevueltas;
    property SinRespuesta: NullableInt32 read fSinRespuesta write fSinRespuesta;
    property PresentadasMes: NullableInt32 read fPresentadasMes write fPresentadasMes;
    property AprobadasMes: NullableInt32 read fAprobadasMes write fAprobadasMes;
    property RechazadasMes: NullableInt32 read fRechazadasMes write fRechazadasMes;
    property MontoAprobadoMes: NullableCurrency read fMontoAprobadoMes write fMontoAprobadoMes;
    property TasaMes: NullableCurrency read fTasaMes write fTasaMes;
    property DiasPlazo: NullableInt32 read fDiasPlazo write fDiasPlazo;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_ETAPAS_USUARIO')]
  TVDashEtapasUsuario = class(TMVCActiveRecord)
  private
    [MVCTableField('USUARIO_ID')]
    fUsuarioId: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(15)]
    fEstado: NullableString;
    [MVCTableField('ORDEN')]
    fOrden: NullableInt32;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
  public
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    property Estado: NullableString read fEstado write fEstado;
    property Orden: NullableInt32 read fOrden write fOrden;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_DASH_SUPERVISOR_RESUMEN')]
  TVDashSupervisorResumen = class(TMVCActiveRecord)
  private
    [MVCTableField('VISTO_BUENO_MES')]
    fVistoBuenoMes: NullableInt32;
    [MVCTableField('DEVUELTAS_MES')]
    fDevueltasMes: NullableInt32;
    [MVCTableField('APROBADAS_MES')]
    fAprobadasMes: NullableInt32;
    [MVCTableField('RECHAZADAS_MES')]
    fRechazadasMes: NullableInt32;
    [MVCTableField('MONTO_APROBADO_MES')]
    fMontoAprobadoMes: NullableCurrency;
    [MVCTableField('TASA_APROBACION')]
    fTasaAprobacion: NullableCurrency;
    [MVCTableField('TASA_ANTERIOR')]
    fTasaAnterior: NullableCurrency;
    [MVCTableField('MONTO_APROBADO_ANTERIOR')]
    fMontoAprobadoAnterior: NullableCurrency;
    [MVCTableField('MES_ANTERIOR')]
    fMesAnterior: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('VARIACION_TASA')]
    fVariacionTasa: NullableCurrency;
    [MVCTableField('VARIACION_MONTO')]
    fVariacionMonto: NullableCurrency;
  public
    property VistoBuenoMes: NullableInt32 read fVistoBuenoMes write fVistoBuenoMes;
    property DevueltasMes: NullableInt32 read fDevueltasMes write fDevueltasMes;
    property AprobadasMes: NullableInt32 read fAprobadasMes write fAprobadasMes;
    property RechazadasMes: NullableInt32 read fRechazadasMes write fRechazadasMes;
    property MontoAprobadoMes: NullableCurrency read fMontoAprobadoMes write fMontoAprobadoMes;
    property TasaAprobacion: NullableCurrency read fTasaAprobacion write fTasaAprobacion;
    property TasaAnterior: NullableCurrency read fTasaAnterior write fTasaAnterior;
    property MontoAprobadoAnterior: NullableCurrency read fMontoAprobadoAnterior write fMontoAprobadoAnterior;
    property MesAnterior: NullableTDateTime {dtDateTimeStamp} read fMesAnterior write fMesAnterior;
    property VariacionTasa: NullableCurrency read fVariacionTasa write fVariacionTasa;
    property VariacionMonto: NullableCurrency read fVariacionMonto write fVariacionMonto;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_REPORTE_ASESOR')]
  TVReporteAsesor = class(TMVCActiveRecord)
  private
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ASESOR_NOMBRE')]
    [MVCMaxLength(120)]
    fAsesorNombre: NullableString;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
    [MVCTableField('APROBADAS')]
    fAprobadas: NullableInt32;
    [MVCTableField('RECHAZADAS')]
    fRechazadas: NullableInt32;
    [MVCTableField('DESCARTADAS')]
    fDescartadas: NullableInt32;
    [MVCTableField('MONTO_APROBADO')]
    fMontoAprobado: NullableCurrency;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
    [MVCTableField('TASA_APROBACION')]
    fTasaAprobacion: NullableCurrency;
  public
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property AsesorNombre: NullableString read fAsesorNombre write fAsesorNombre;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
    property Aprobadas: NullableInt32 read fAprobadas write fAprobadas;
    property Rechazadas: NullableInt32 read fRechazadas write fRechazadas;
    property Descartadas: NullableInt32 read fDescartadas write fDescartadas;
    property MontoAprobado: NullableCurrency read fMontoAprobado write fMontoAprobado;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property TasaAprobacion: NullableCurrency read fTasaAprobacion write fTasaAprobacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_REPORTE_CLIENTE')]
  TVReporteCliente = class(TMVCActiveRecord)
  private
    [MVCTableField('CLIENTE_ID')]
    fClienteId: NullableInt32;
    [MVCTableField('CLIENTE_NOMBRE')]
    [MVCMaxLength(120)]
    fClienteNombre: NullableString;
    [MVCTableField('ENVIADAS')]
    fEnviadas: NullableInt32;
    [MVCTableField('ULTIMO_ENVIO')]
    fUltimoEnvio: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('APROBADAS')]
    fAprobadas: NullableInt32;
    [MVCTableField('RECHAZADAS')]
    fRechazadas: NullableInt32;
    [MVCTableField('SIN_RESPUESTA')]
    fSinRespuesta: NullableInt32;
    [MVCTableField('MONTO_SIN_RESPUESTA')]
    fMontoSinRespuesta: NullableCurrency;
    [MVCTableField('EN_ESPERA')]
    fEnEspera: NullableInt32;
    [MVCTableField('PORCENTAJE_SIN_RESPUESTA')]
    fPorcentajeSinRespuesta: NullableCurrency;
  public
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property ClienteNombre: NullableString read fClienteNombre write fClienteNombre;
    property Enviadas: NullableInt32 read fEnviadas write fEnviadas;
    property UltimoEnvio: NullableTDateTime {dtDateTimeStamp} read fUltimoEnvio write fUltimoEnvio;
    property Aprobadas: NullableInt32 read fAprobadas write fAprobadas;
    property Rechazadas: NullableInt32 read fRechazadas write fRechazadas;
    property SinRespuesta: NullableInt32 read fSinRespuesta write fSinRespuesta;
    property MontoSinRespuesta: NullableCurrency read fMontoSinRespuesta write fMontoSinRespuesta;
    property EnEspera: NullableInt32 read fEnEspera write fEnEspera;
    property PorcentajeSinRespuesta: NullableCurrency read fPorcentajeSinRespuesta write fPorcentajeSinRespuesta;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_REPORTE_DIA')]
  TVReporteDia = class(TMVCActiveRecord)
  private
    [MVCTableField('PERIODO')]
    [MVCMaxLength(8)]
    fPeriodo: NullableString;
    [MVCTableField('FECHA')]
    fFecha: NullableTDate;
    [MVCTableField('ANIO')]
    fAnio: NullableInt32;
    [MVCTableField('MES')]
    fMes: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ASESOR_NOMBRE')]
    [MVCMaxLength(120)]
    fAsesorNombre: NullableString;
    [MVCTableField('TIPO_TRABAJO_ID')]
    fTipoTrabajoId: NullableInt32;
    [MVCTableField('TIPO_TRABAJO_NOMBRE')]
    [MVCMaxLength(120)]
    fTipoTrabajoNombre: NullableString;
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
    [MVCTableField('APROBADAS')]
    fAprobadas: NullableInt32;
    [MVCTableField('RECHAZADAS')]
    fRechazadas: NullableInt32;
    [MVCTableField('MONTO_APROBADO')]
    fMontoAprobado: NullableCurrency;
    [MVCTableField('SUMA_DIAS_RESPUESTA')]
    fSumaDiasRespuesta: NullableInt32;
    [MVCTableField('CON_RESPUESTA')]
    fConRespuesta: NullableInt32;
    [MVCTableField('ENVIADAS')]
    fEnviadas: NullableInt32;
    [MVCTableField('MONTO_ENVIADO')]
    fMontoEnviado: NullableCurrency;
    [MVCTableField('DESCARTADAS')]
    fDescartadas: NullableInt32;
    [MVCTableField('DEL_CLIENTE')]
    fDelCliente: NullableBoolean;
  public
    property Periodo: NullableString read fPeriodo write fPeriodo;
    property Fecha: NullableTDate read fFecha write fFecha;
    property Anio: NullableInt32 read fAnio write fAnio;
    property Mes: NullableInt32 read fMes write fMes;
    property Estado: NullableString read fEstado write fEstado;
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property AsesorNombre: NullableString read fAsesorNombre write fAsesorNombre;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId write fTipoTrabajoId;
    property TipoTrabajoNombre: NullableString read fTipoTrabajoNombre write fTipoTrabajoNombre;
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property Aprobadas: NullableInt32 read fAprobadas write fAprobadas;
    property Rechazadas: NullableInt32 read fRechazadas write fRechazadas;
    property MontoAprobado: NullableCurrency read fMontoAprobado write fMontoAprobado;
    property SumaDiasRespuesta: NullableInt32 read fSumaDiasRespuesta write fSumaDiasRespuesta;
    property ConRespuesta: NullableInt32 read fConRespuesta write fConRespuesta;
    property Enviadas: NullableInt32 read fEnviadas write fEnviadas;
    property MontoEnviado: NullableCurrency read fMontoEnviado write fMontoEnviado;
    property Descartadas: NullableInt32 read fDescartadas write fDescartadas;
    property DelCliente: NullableBoolean read fDelCliente write fDelCliente;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_REPORTE_ESTADO')]
  TVReporteEstado = class(TMVCActiveRecord)
  private
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('ORDEN')]
    fOrden: NullableInt32;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
    [MVCTableField('MONTO')]
    fMonto: NullableCurrency;
  public
    property Estado: NullableString read fEstado write fEstado;
    property Orden: NullableInt32 read fOrden write fOrden;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
    property Monto: NullableCurrency read fMonto write fMonto;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_REPORTE_MES')]
  TVReporteMes = class(TMVCActiveRecord)
  private
    [MVCTableField('ANIO')]
    fAnio: NullableInt32;
    [MVCTableField('MES')]
    fMes: NullableInt32;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
    [MVCTableField('APROBADAS')]
    fAprobadas: NullableInt32;
    [MVCTableField('RECHAZADAS')]
    fRechazadas: NullableInt32;
    [MVCTableField('DESCARTADAS')]
    fDescartadas: NullableInt32;
    [MVCTableField('MONTO_APROBADO')]
    fMontoAprobado: NullableCurrency;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
    [MVCTableField('TASA_APROBACION')]
    fTasaAprobacion: NullableCurrency;
  public
    property Anio: NullableInt32 read fAnio write fAnio;
    property Mes: NullableInt32 read fMes write fMes;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
    property Aprobadas: NullableInt32 read fAprobadas write fAprobadas;
    property Rechazadas: NullableInt32 read fRechazadas write fRechazadas;
    property Descartadas: NullableInt32 read fDescartadas write fDescartadas;
    property MontoAprobado: NullableCurrency read fMontoAprobado write fMontoAprobado;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property TasaAprobacion: NullableCurrency read fTasaAprobacion write fTasaAprobacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_REPORTE_PERIODO')]
  TVReportePeriodo = class(TMVCActiveRecord)
  private
    [MVCTableField('PERIODO')]
    [MVCMaxLength(8)]
    fPeriodo: NullableString;
    [MVCTableField('DESDE')]
    fDesde: NullableTDate;
    [MVCTableField('HASTA')]
    fHasta: NullableTDate;
    [MVCTableField('USUARIO')]
    fUsuario: NullableInt32;
  public
    property Periodo: NullableString read fPeriodo write fPeriodo;
    property Desde: NullableTDate read fDesde write fDesde;
    property Hasta: NullableTDate read fHasta write fHasta;
    property Usuario: NullableInt32 read fUsuario write fUsuario;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_REPORTE_RESUMEN')]
  TVReporteResumen = class(TMVCActiveRecord)
  private
    [MVCTableField('PERIODO')]
    [MVCMaxLength(8)]
    fPeriodo: NullableString;
    [MVCTableField('DESDE')]
    fDesde: NullableTDate;
    [MVCTableField('HASTA')]
    fHasta: NullableTDate;
    [MVCTableField('TOTAL')]
    fTotal: NullableInt32;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
    [MVCTableField('APROBADAS')]
    fAprobadas: NullableInt32;
    [MVCTableField('MONTO_APROBADO')]
    fMontoAprobado: NullableCurrency;
    [MVCTableField('RECHAZADAS')]
    fRechazadas: NullableInt32;
    [MVCTableField('DESCARTADAS')]
    fDescartadas: NullableInt32;
    [MVCTableField('RESPUESTA_MEDIA')]
    fRespuestaMedia: NullableInt32;
    [MVCTableField('TASA_APROBACION')]
    fTasaAprobacion: NullableCurrency;
  public
    property Periodo: NullableString read fPeriodo write fPeriodo;
    property Desde: NullableTDate read fDesde write fDesde;
    property Hasta: NullableTDate read fHasta write fHasta;
    property Total: NullableInt32 read fTotal write fTotal;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property Aprobadas: NullableInt32 read fAprobadas write fAprobadas;
    property MontoAprobado: NullableCurrency read fMontoAprobado write fMontoAprobado;
    property Rechazadas: NullableInt32 read fRechazadas write fRechazadas;
    property Descartadas: NullableInt32 read fDescartadas write fDescartadas;
    property RespuestaMedia: NullableInt32 read fRespuestaMedia write fRespuestaMedia;
    property TasaAprobacion: NullableCurrency read fTasaAprobacion write fTasaAprobacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_REPORTE_TIPO')]
  TVReporteTipo = class(TMVCActiveRecord)
  private
    [MVCTableField('TIPO_TRABAJO_ID')]
    fTipoTrabajoId: NullableInt32;
    [MVCTableField('TIPO_TRABAJO_NOMBRE')]
    [MVCMaxLength(120)]
    fTipoTrabajoNombre: NullableString;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt32;
    [MVCTableField('APROBADAS')]
    fAprobadas: NullableInt32;
    [MVCTableField('RECHAZADAS')]
    fRechazadas: NullableInt32;
    [MVCTableField('DESCARTADAS')]
    fDescartadas: NullableInt32;
    [MVCTableField('MONTO_APROBADO')]
    fMontoAprobado: NullableCurrency;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
    [MVCTableField('TASA_APROBACION')]
    fTasaAprobacion: NullableCurrency;
  public
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId write fTipoTrabajoId;
    property TipoTrabajoNombre: NullableString read fTipoTrabajoNombre write fTipoTrabajoNombre;
    property Cantidad: NullableInt32 read fCantidad write fCantidad;
    property Aprobadas: NullableInt32 read fAprobadas write fAprobadas;
    property Rechazadas: NullableInt32 read fRechazadas write fRechazadas;
    property Descartadas: NullableInt32 read fDescartadas write fDescartadas;
    property MontoAprobado: NullableCurrency read fMontoAprobado write fMontoAprobado;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property TasaAprobacion: NullableCurrency read fTasaAprobacion write fTasaAprobacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_COTIZACION_LINEAS')]
  TVCotizacionLineas = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('COTIZACION_ID')]
    fCotizacionId: NullableInt32;
    [MVCTableField('TIPO')]
    [MVCMaxLength(10)]
    fTipo: NullableString;
    [MVCTableField('SUBTOTAL')]
    fSubtotal: NullableCurrency;
  public
    property ID: NullableInt32 read fID write fID;
    property CotizacionId: NullableInt32 read fCotizacionId write fCotizacionId;
    property Tipo: NullableString read fTipo write fTipo;
    property Subtotal: NullableCurrency read fSubtotal write fSubtotal;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_COTIZACION_TOTALES')]
  TVCotizacionTotales = class(TMVCActiveRecord)
  private
    [MVCTableField('COTIZACION_ID')]
    fCotizacionId: NullableInt32;
    [MVCTableField('SUBTOTAL_MATERIALES')]
    fSubtotalMateriales: NullableCurrency;
    [MVCTableField('SUBTOTAL_MANO_OBRA')]
    fSubtotalManoObra: NullableCurrency;
    [MVCTableField('SUBTOTAL_MAQUINA')]
    fSubtotalMaquina: NullableCurrency;
    [MVCTableField('COSTO_TOTAL')]
    fCostoTotal: NullableCurrency;
    [MVCTableField('MONTO_AJUSTE')]
    fMontoAjuste: NullableCurrency;
    [MVCTableField('MONTO_IMPUESTO')]
    fMontoImpuesto: NullableCurrency;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
  public
    property CotizacionId: NullableInt32 read fCotizacionId write fCotizacionId;
    property SubtotalMateriales: NullableCurrency read fSubtotalMateriales write fSubtotalMateriales;
    property SubtotalManoObra: NullableCurrency read fSubtotalManoObra write fSubtotalManoObra;
    property SubtotalMaquina: NullableCurrency read fSubtotalMaquina write fSubtotalMaquina;
    property CostoTotal: NullableCurrency read fCostoTotal write fCostoTotal;
    property MontoAjuste: NullableCurrency read fMontoAjuste write fMontoAjuste;
    property MontoImpuesto: NullableCurrency read fMontoImpuesto write fMontoImpuesto;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_COTIZACIONES_LISTADO')]
  TVCotizacionesListado = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('NUMERO')]
    fNumero: NullableInt32;
    [MVCTableField('SOLICITUD_ID')]
    fSolicitudId: NullableInt32;
    [MVCTableField('CLIENTE_ID')]
    fClienteId: NullableInt32;
    [MVCTableField('TIPO_TRABAJO_ID')]
    fTipoTrabajoId: NullableInt32;
    [MVCTableField('DESCRIPCION_TRABAJO')]
    [MVCMaxLength(500)]
    fDescripcionTrabajo: NullableString;
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('APROBADA_POR')]
    fAprobadaPor: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('SUBTOTAL_MATERIALES')]
    fSubtotalMateriales: NullableCurrency;
    [MVCTableField('SUBTOTAL_MANO_OBRA')]
    fSubtotalManoObra: NullableCurrency;
    [MVCTableField('SUBTOTAL_MAQUINA')]
    fSubtotalMaquina: NullableCurrency;
    [MVCTableField('COSTO_TOTAL')]
    fCostoTotal: NullableCurrency;
    [MVCTableField('PORCENTAJE_AJUSTE')]
    fPorcentajeAjuste: NullableCurrency;
    [MVCTableField('MOTIVO_AJUSTE')]
    [MVCMaxLength(500)]
    fMotivoAjuste: NullableString;
    [MVCTableField('PORCENTAJE_IVA')]
    fPorcentajeIva: NullableCurrency;
    [MVCTableField('MONTO_IMPUESTO')]
    fMontoImpuesto: NullableCurrency;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
    [MVCTableField('MOTIVO_RECHAZO')]
    [MVCMaxLength(500)]
    fMotivoRechazo: NullableString;
    [MVCTableField('FECHA_ELABORACION')]
    fFechaElaboracion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_APROBACION')]
    fFechaAprobacion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_ENVIO')]
    fFechaEnvio: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('OBJVERSION')]
    fObjversion: NullableInt32;
    [MVCTableField('FORMA_PAGO')]
    [MVCMaxLength(120)]
    fFormaPago: NullableString;
    [MVCTableField('FORMA_PAGO_ID')]
    fFormaPagoId: NullableInt32;
    [MVCTableField('PLAZO_ENTREGA_CANTIDAD')]
    fPlazoEntregaCantidad: NullableInt16;
    [MVCTableField('PLAZO_ENTREGA_UNIDAD')]
    [MVCMaxLength(15)]
    fPlazoEntregaUnidad: NullableString;
    [MVCTableField('GARANTIA_CANTIDAD')]
    fGarantiaCantidad: NullableInt16;
    [MVCTableField('GARANTIA_UNIDAD')]
    [MVCMaxLength(15)]
    fGarantiaUnidad: NullableString;
    [MVCTableField('ORDEN_COMPRA')]
    [MVCMaxLength(40)]
    fOrdenCompra: NullableString;
    [MVCTableField('FECHA_RECEPCION')]
    fFechaRecepcion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('CLIENTE_NOMBRE')]
    [MVCMaxLength(120)]
    fClienteNombre: NullableString;
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ASESOR_NOMBRE')]
    [MVCMaxLength(120)]
    fAsesorNombre: NullableString;
    [MVCTableField('ELABORADA_POR_NOMBRE')]
    [MVCMaxLength(120)]
    fElaboradaPorNombre: NullableString;
    [MVCTableField('APROBADA_POR_NOMBRE')]
    [MVCMaxLength(120)]
    fAprobadaPorNombre: NullableString;
    [MVCTableField('TIPO_TRABAJO_NOMBRE')]
    [MVCMaxLength(120)]
    fTipoTrabajoNombre: NullableString;
    [MVCTableField('DEVUELTA')]
    fDevuelta: NullableBoolean;
    [MVCTableField('DIAS_EN_ESTADO')]
    fDiasEnEstado: NullableInt32;
    [MVCTableField('DIAS_RESPUESTA')]
    fDiasRespuesta: NullableInt32;
    [MVCTableField('MONTO_AJUSTE')]
    fMontoAjuste: NullableCurrency;
  public
    property ID: NullableInt32 read fID write fID;
    property Numero: NullableInt32 read fNumero write fNumero;
    property SolicitudId: NullableInt32 read fSolicitudId write fSolicitudId;
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId write fTipoTrabajoId;
    property DescripcionTrabajo: NullableString read fDescripcionTrabajo write fDescripcionTrabajo;
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property AprobadaPor: NullableInt32 read fAprobadaPor write fAprobadaPor;
    property Estado: NullableString read fEstado write fEstado;
    property SubtotalMateriales: NullableCurrency read fSubtotalMateriales write fSubtotalMateriales;
    property SubtotalManoObra: NullableCurrency read fSubtotalManoObra write fSubtotalManoObra;
    property SubtotalMaquina: NullableCurrency read fSubtotalMaquina write fSubtotalMaquina;
    property CostoTotal: NullableCurrency read fCostoTotal write fCostoTotal;
    property PorcentajeAjuste: NullableCurrency read fPorcentajeAjuste write fPorcentajeAjuste;
    property MotivoAjuste: NullableString read fMotivoAjuste write fMotivoAjuste;
    property PorcentajeIva: NullableCurrency read fPorcentajeIva write fPorcentajeIva;
    property MontoImpuesto: NullableCurrency read fMontoImpuesto write fMontoImpuesto;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property MotivoRechazo: NullableString read fMotivoRechazo write fMotivoRechazo;
    property FechaElaboracion: NullableTDateTime {dtDateTimeStamp} read fFechaElaboracion write fFechaElaboracion;
    property FechaAprobacion: NullableTDateTime {dtDateTimeStamp} read fFechaAprobacion write fFechaAprobacion;
    property FechaEnvio: NullableTDateTime {dtDateTimeStamp} read fFechaEnvio write fFechaEnvio;
    property FechaModificacion: NullableTDateTime {dtDateTimeStamp} read fFechaModificacion write fFechaModificacion;
    property Objversion: NullableInt32 read fObjversion write fObjversion;
    property FormaPago: NullableString read fFormaPago write fFormaPago;
    property FormaPagoId: NullableInt32 read fFormaPagoId write fFormaPagoId;
    property PlazoEntregaCantidad: NullableInt16 read fPlazoEntregaCantidad write fPlazoEntregaCantidad;
    property PlazoEntregaUnidad: NullableString read fPlazoEntregaUnidad write fPlazoEntregaUnidad;
    property GarantiaCantidad: NullableInt16 read fGarantiaCantidad write fGarantiaCantidad;
    property GarantiaUnidad: NullableString read fGarantiaUnidad write fGarantiaUnidad;
    property OrdenCompra: NullableString read fOrdenCompra write fOrdenCompra;
    property FechaRecepcion: NullableTDateTime {dtDateTimeStamp} read fFechaRecepcion write fFechaRecepcion;
    property ClienteNombre: NullableString read fClienteNombre write fClienteNombre;
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property AsesorNombre: NullableString read fAsesorNombre write fAsesorNombre;
    property ElaboradaPorNombre: NullableString read fElaboradaPorNombre write fElaboradaPorNombre;
    property AprobadaPorNombre: NullableString read fAprobadaPorNombre write fAprobadaPorNombre;
    property TipoTrabajoNombre: NullableString read fTipoTrabajoNombre write fTipoTrabajoNombre;
    property Devuelta: NullableBoolean read fDevuelta write fDevuelta;
    property DiasEnEstado: NullableInt32 read fDiasEnEstado write fDiasEnEstado;
    property DiasRespuesta: NullableInt32 read fDiasRespuesta write fDiasRespuesta;
    property MontoAjuste: NullableCurrency read fMontoAjuste write fMontoAjuste;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_COTIZACIONES_SIN_RESPUESTA')]
  TVCotizacionesSinRespuesta = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('NUMERO')]
    fNumero: NullableInt32;
    [MVCTableField('SOLICITUD_ID')]
    fSolicitudId: NullableInt32;
    [MVCTableField('CLIENTE_ID')]
    fClienteId: NullableInt32;
    [MVCTableField('TIPO_TRABAJO_ID')]
    fTipoTrabajoId: NullableInt32;
    [MVCTableField('DESCRIPCION_TRABAJO')]
    [MVCMaxLength(500)]
    fDescripcionTrabajo: NullableString;
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('APROBADA_POR')]
    fAprobadaPor: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('SUBTOTAL_MATERIALES')]
    fSubtotalMateriales: NullableCurrency;
    [MVCTableField('SUBTOTAL_MANO_OBRA')]
    fSubtotalManoObra: NullableCurrency;
    [MVCTableField('SUBTOTAL_MAQUINA')]
    fSubtotalMaquina: NullableCurrency;
    [MVCTableField('COSTO_TOTAL')]
    fCostoTotal: NullableCurrency;
    [MVCTableField('PORCENTAJE_AJUSTE')]
    fPorcentajeAjuste: NullableCurrency;
    [MVCTableField('MOTIVO_AJUSTE')]
    [MVCMaxLength(500)]
    fMotivoAjuste: NullableString;
    [MVCTableField('PORCENTAJE_IVA')]
    fPorcentajeIva: NullableCurrency;
    [MVCTableField('MONTO_IMPUESTO')]
    fMontoImpuesto: NullableCurrency;
    [MVCTableField('MONTO_TOTAL')]
    fMontoTotal: NullableCurrency;
    [MVCTableField('MOTIVO_RECHAZO')]
    [MVCMaxLength(500)]
    fMotivoRechazo: NullableString;
    [MVCTableField('FECHA_ELABORACION')]
    fFechaElaboracion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_APROBACION')]
    fFechaAprobacion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_ENVIO')]
    fFechaEnvio: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('OBJVERSION')]
    fObjversion: NullableInt32;
    [MVCTableField('FORMA_PAGO')]
    [MVCMaxLength(120)]
    fFormaPago: NullableString;
    [MVCTableField('FORMA_PAGO_ID')]
    fFormaPagoId: NullableInt32;
    [MVCTableField('PLAZO_ENTREGA_CANTIDAD')]
    fPlazoEntregaCantidad: NullableInt16;
    [MVCTableField('PLAZO_ENTREGA_UNIDAD')]
    [MVCMaxLength(15)]
    fPlazoEntregaUnidad: NullableString;
    [MVCTableField('GARANTIA_CANTIDAD')]
    fGarantiaCantidad: NullableInt16;
    [MVCTableField('GARANTIA_UNIDAD')]
    [MVCMaxLength(15)]
    fGarantiaUnidad: NullableString;
    [MVCTableField('ORDEN_COMPRA')]
    [MVCMaxLength(40)]
    fOrdenCompra: NullableString;
    [MVCTableField('FECHA_RECEPCION')]
    fFechaRecepcion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('CLIENTE_NOMBRE')]
    [MVCMaxLength(120)]
    fClienteNombre: NullableString;
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('ASESOR_NOMBRE')]
    [MVCMaxLength(120)]
    fAsesorNombre: NullableString;
    [MVCTableField('ELABORADA_POR_NOMBRE')]
    [MVCMaxLength(120)]
    fElaboradaPorNombre: NullableString;
    [MVCTableField('APROBADA_POR_NOMBRE')]
    [MVCMaxLength(120)]
    fAprobadaPorNombre: NullableString;
    [MVCTableField('TIPO_TRABAJO_NOMBRE')]
    [MVCMaxLength(120)]
    fTipoTrabajoNombre: NullableString;
    [MVCTableField('DEVUELTA')]
    fDevuelta: NullableBoolean;
    [MVCTableField('DIAS_EN_ESTADO')]
    fDiasEnEstado: NullableInt32;
    [MVCTableField('DIAS_RESPUESTA')]
    fDiasRespuesta: NullableInt32;
    [MVCTableField('MONTO_AJUSTE')]
    fMontoAjuste: NullableCurrency;
  public
    property ID: NullableInt32 read fID write fID;
    property Numero: NullableInt32 read fNumero write fNumero;
    property SolicitudId: NullableInt32 read fSolicitudId write fSolicitudId;
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId write fTipoTrabajoId;
    property DescripcionTrabajo: NullableString read fDescripcionTrabajo write fDescripcionTrabajo;
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property AprobadaPor: NullableInt32 read fAprobadaPor write fAprobadaPor;
    property Estado: NullableString read fEstado write fEstado;
    property SubtotalMateriales: NullableCurrency read fSubtotalMateriales write fSubtotalMateriales;
    property SubtotalManoObra: NullableCurrency read fSubtotalManoObra write fSubtotalManoObra;
    property SubtotalMaquina: NullableCurrency read fSubtotalMaquina write fSubtotalMaquina;
    property CostoTotal: NullableCurrency read fCostoTotal write fCostoTotal;
    property PorcentajeAjuste: NullableCurrency read fPorcentajeAjuste write fPorcentajeAjuste;
    property MotivoAjuste: NullableString read fMotivoAjuste write fMotivoAjuste;
    property PorcentajeIva: NullableCurrency read fPorcentajeIva write fPorcentajeIva;
    property MontoImpuesto: NullableCurrency read fMontoImpuesto write fMontoImpuesto;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property MotivoRechazo: NullableString read fMotivoRechazo write fMotivoRechazo;
    property FechaElaboracion: NullableTDateTime {dtDateTimeStamp} read fFechaElaboracion write fFechaElaboracion;
    property FechaAprobacion: NullableTDateTime {dtDateTimeStamp} read fFechaAprobacion write fFechaAprobacion;
    property FechaEnvio: NullableTDateTime {dtDateTimeStamp} read fFechaEnvio write fFechaEnvio;
    property FechaModificacion: NullableTDateTime {dtDateTimeStamp} read fFechaModificacion write fFechaModificacion;
    property Objversion: NullableInt32 read fObjversion write fObjversion;
    property FormaPago: NullableString read fFormaPago write fFormaPago;
    property FormaPagoId: NullableInt32 read fFormaPagoId write fFormaPagoId;
    property PlazoEntregaCantidad: NullableInt16 read fPlazoEntregaCantidad write fPlazoEntregaCantidad;
    property PlazoEntregaUnidad: NullableString read fPlazoEntregaUnidad write fPlazoEntregaUnidad;
    property GarantiaCantidad: NullableInt16 read fGarantiaCantidad write fGarantiaCantidad;
    property GarantiaUnidad: NullableString read fGarantiaUnidad write fGarantiaUnidad;
    property OrdenCompra: NullableString read fOrdenCompra write fOrdenCompra;
    property FechaRecepcion: NullableTDateTime {dtDateTimeStamp} read fFechaRecepcion write fFechaRecepcion;
    property ClienteNombre: NullableString read fClienteNombre write fClienteNombre;
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property AsesorNombre: NullableString read fAsesorNombre write fAsesorNombre;
    property ElaboradaPorNombre: NullableString read fElaboradaPorNombre write fElaboradaPorNombre;
    property AprobadaPorNombre: NullableString read fAprobadaPorNombre write fAprobadaPorNombre;
    property TipoTrabajoNombre: NullableString read fTipoTrabajoNombre write fTipoTrabajoNombre;
    property Devuelta: NullableBoolean read fDevuelta write fDevuelta;
    property DiasEnEstado: NullableInt32 read fDiasEnEstado write fDiasEnEstado;
    property DiasRespuesta: NullableInt32 read fDiasRespuesta write fDiasRespuesta;
    property MontoAjuste: NullableCurrency read fMontoAjuste write fMontoAjuste;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('V_CONTACTOS_BAJADA')]
  TVContactosBajada = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('UUID_LOCAL')]
    [MVCMaxLength(36)]
    fUuidLocal: NullableString;
    [MVCTableField('CLIENTE_ID')]
    fClienteId: NullableInt32;
    [MVCTableField('NOMBRE')]
    [MVCMaxLength(120)]
    fNombre: NullableString;
    [MVCTableField('AREA')]
    [MVCMaxLength(80)]
    fArea: NullableString;
    [MVCTableField('TELEFONO')]
    [MVCMaxLength(30)]
    fTelefono: NullableString;
    [MVCTableField('CORREO')]
    [MVCMaxLength(150)]
    fCorreo: NullableString;
    [MVCTableField('PRINCIPAL')]
    fPrincipal: NullableBoolean;
    [MVCTableField('CONSENTIMIENTO_ESTADO')]
    [MVCMaxLength(20)]
    fConsentimientoEstado: NullableString;
    [MVCTableField('CONSENTIMIENTO_FECHA')]
    fConsentimientoFecha: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('CONSENTIMIENTO_VERSION')]
    [MVCMaxLength(10)]
    fConsentimientoVersion: NullableString;
    [MVCTableField('ANONIMIZADO')]
    fAnonimizado: NullableBoolean;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('OBJVERSION')]
    fObjversion: NullableInt32;
    [MVCTableField('CELULAR')]
    [MVCMaxLength(30)]
    fCelular: NullableString;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime {dtDateTimeStamp};
    [MVCTableField('CLIENTE_UUID')]
    [MVCMaxLength(36)]
    fClienteUuid: NullableString;
    [MVCTableField('CLIENTE_ACTIVO')]
    fClienteActivo: NullableBoolean;
  public
    property ID: NullableInt32 read fID write fID;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property Nombre: NullableString read fNombre write fNombre;
    property Area: NullableString read fArea write fArea;
    property Telefono: NullableString read fTelefono write fTelefono;
    property Correo: NullableString read fCorreo write fCorreo;
    property Principal: NullableBoolean read fPrincipal write fPrincipal;
    property ConsentimientoEstado: NullableString read fConsentimientoEstado write fConsentimientoEstado;
    property ConsentimientoFecha: NullableTDateTime {dtDateTimeStamp} read fConsentimientoFecha write fConsentimientoFecha;
    property ConsentimientoVersion: NullableString read fConsentimientoVersion write fConsentimientoVersion;
    property Anonimizado: NullableBoolean read fAnonimizado write fAnonimizado;
    property Activo: NullableBoolean read fActivo write fActivo;
    property FechaCreacion: NullableTDateTime {dtDateTimeStamp} read fFechaCreacion write fFechaCreacion;
    property Objversion: NullableInt32 read fObjversion write fObjversion;
    property Celular: NullableString read fCelular write fCelular;
    property FechaModificacion: NullableTDateTime {dtDateTimeStamp} read fFechaModificacion write fFechaModificacion;
    property ClienteUuid: NullableString read fClienteUuid write fClienteUuid;
    property ClienteActivo: NullableBoolean read fClienteActivo write fClienteActivo;
  end;

implementation

end.
