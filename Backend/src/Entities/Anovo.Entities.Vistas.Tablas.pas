unit Anovo.Entities.Vistas.Tablas;

// Entidades de las vistas VT_ (migracion 57): cada tabla con sus codigos
// resueltos. Se lee de aqui y se escribe en la entidad de la tabla.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  MVCFramework.ActiveRecord,
  MVCFramework.Validators;

type

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_CLIENTES')]
  TVtClientes = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('UUID_LOCAL')]
    [MVCMaxLength(36)]
    fUuidLocal: NullableString;
    [MVCTableField('NOMBRE')]
    [MVCMaxLength(120)]
    fNombre: NullableString;
    [MVCTableField('IDENTIFICACION')]
    [MVCMaxLength(30)]
    fIdentificacion: NullableString;
    [MVCTableField('TELEFONO')]
    [MVCMaxLength(30)]
    fTelefono: NullableString;
    [MVCTableField('CORREO')]
    [MVCMaxLength(150)]
    fCorreo: NullableString;
    [MVCTableField('DIRECCION')]
    [MVCMaxLength(500)]
    fDireccion: NullableString;
    [MVCTableField('LATITUD')]
    fLatitud: NullableCurrency;
    [MVCTableField('LONGITUD')]
    fLongitud: NullableCurrency;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('EXONERADO')]
    fExonerado: NullableBoolean;
    [MVCTableField('CODIGO_EXONERACION')]
    [MVCMaxLength(30)]
    fCodigoExoneracion: NullableString;
    [MVCTableField('CONSENTIMIENTO_FECHA')]
    fConsentimientoFecha: NullableTDateTime;
    [MVCTableField('CONSENTIMIENTO_VERSION')]
    [MVCMaxLength(10)]
    fConsentimientoVersion: NullableString;
    [MVCTableField('ANONIMIZADO')]
    fAnonimizado: NullableBoolean;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('OBJVERSION')]
    fObjversion: NullableInt32;
    [MVCTableField('TIPO_IDENTIFICACION_ID')]
    fTipoIdentificacionId: NullableInt16;
    [MVCTableField('CONTACTO')]
    [MVCMaxLength(120)]
    fContacto: NullableString;
    [MVCTableField('CONSENTIMIENTO_ESTADO_ID')]
    fConsentimientoEstadoId: NullableInt32;
    [MVCTableField('CONSENTIMIENTO_ESTADO')]
    [MVCMaxLength(20)]
    fConsentimientoEstado: NullableString;
    [MVCTableField('TIPO_IDENTIFICACION')]
    fTipoIdentificacion: NullableInt16;
    [MVCTableField('TIPO_IDENTIFICACION_NOMBRE')]
    [MVCMaxLength(120)]
    fTipoIdentificacionNombre: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property Nombre: NullableString read fNombre write fNombre;
    property Identificacion: NullableString read fIdentificacion write fIdentificacion;
    property Telefono: NullableString read fTelefono write fTelefono;
    property Correo: NullableString read fCorreo write fCorreo;
    property Direccion: NullableString read fDireccion write fDireccion;
    property Latitud: NullableCurrency read fLatitud write fLatitud;
    property Longitud: NullableCurrency read fLongitud write fLongitud;
    property Activo: NullableBoolean read fActivo write fActivo;
    property Exonerado: NullableBoolean read fExonerado write fExonerado;
    property CodigoExoneracion: NullableString read fCodigoExoneracion write fCodigoExoneracion;
    property ConsentimientoFecha: NullableTDateTime read fConsentimientoFecha write fConsentimientoFecha;
    property ConsentimientoVersion: NullableString read fConsentimientoVersion write fConsentimientoVersion;
    property Anonimizado: NullableBoolean read fAnonimizado write fAnonimizado;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
    property Objversion: NullableInt32 read fObjversion write fObjversion;
    property TipoIdentificacionId: NullableInt16 read fTipoIdentificacionId write fTipoIdentificacionId;
    property Contacto: NullableString read fContacto write fContacto;
    property ConsentimientoEstadoId: NullableInt32 read fConsentimientoEstadoId write fConsentimientoEstadoId;
    property ConsentimientoEstado: NullableString read fConsentimientoEstado write fConsentimientoEstado;
    property TipoIdentificacion: NullableInt16 read fTipoIdentificacion write fTipoIdentificacion;
    property TipoIdentificacionNombre: NullableString read fTipoIdentificacionNombre write fTipoIdentificacionNombre;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_CLIENTE_CONTACTOS')]
  TVtClienteContactos = class(TMVCActiveRecord)
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
    [MVCTableField('CONSENTIMIENTO_FECHA')]
    fConsentimientoFecha: NullableTDateTime;
    [MVCTableField('CONSENTIMIENTO_VERSION')]
    [MVCMaxLength(10)]
    fConsentimientoVersion: NullableString;
    [MVCTableField('ANONIMIZADO')]
    fAnonimizado: NullableBoolean;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('OBJVERSION')]
    fObjversion: NullableInt32;
    [MVCTableField('CELULAR')]
    [MVCMaxLength(30)]
    fCelular: NullableString;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('CONSENTIMIENTO_ESTADO_ID')]
    fConsentimientoEstadoId: NullableInt32;
    [MVCTableField('CONSENTIMIENTO_ESTADO')]
    [MVCMaxLength(20)]
    fConsentimientoEstado: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property Nombre: NullableString read fNombre write fNombre;
    property Area: NullableString read fArea write fArea;
    property Telefono: NullableString read fTelefono write fTelefono;
    property Correo: NullableString read fCorreo write fCorreo;
    property Principal: NullableBoolean read fPrincipal write fPrincipal;
    property ConsentimientoFecha: NullableTDateTime read fConsentimientoFecha write fConsentimientoFecha;
    property ConsentimientoVersion: NullableString read fConsentimientoVersion write fConsentimientoVersion;
    property Anonimizado: NullableBoolean read fAnonimizado write fAnonimizado;
    property Activo: NullableBoolean read fActivo write fActivo;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property Objversion: NullableInt32 read fObjversion write fObjversion;
    property Celular: NullableString read fCelular write fCelular;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
    property ConsentimientoEstadoId: NullableInt32 read fConsentimientoEstadoId write fConsentimientoEstadoId;
    property ConsentimientoEstado: NullableString read fConsentimientoEstado write fConsentimientoEstado;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_CONSENTIMIENTO_HISTORIAL')]
  TVtConsentimientoHistorial = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('CLIENTE_ID')]
    fClienteId: NullableInt32;
    [MVCTableField('CLIENTE_CONTACTO_ID')]
    fClienteContactoId: NullableInt32;
    [MVCTableField('ACCION_ID')]
    fAccionId: NullableInt32;
    [MVCTableField('ORIGEN_ID')]
    fOrigenId: NullableInt32;
    [MVCTableField('VERSION_TEXTO')]
    [MVCMaxLength(10)]
    fVersionTexto: NullableString;
    [MVCTableField('FECHA')]
    fFecha: NullableTDateTime;
    [MVCTableField('FIRMANTE_NOMBRE')]
    [MVCMaxLength(120)]
    fFirmanteNombre: NullableString;
    [MVCTableField('FIRMANTE_IDENTIFICACION')]
    [MVCMaxLength(30)]
    fFirmanteIdentificacion: NullableString;
    [MVCTableField('FIRMA_MIME')]
    [MVCMaxLength(40)]
    fFirmaMime: NullableString;
    [MVCTableField('ACCION')]
    [MVCMaxLength(20)]
    fAccion: NullableString;
    [MVCTableField('ORIGEN')]
    [MVCMaxLength(20)]
    fOrigen: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property ClienteContactoId: NullableInt32 read fClienteContactoId write fClienteContactoId;
    property AccionId: NullableInt32 read fAccionId write fAccionId;
    property OrigenId: NullableInt32 read fOrigenId write fOrigenId;
    property VersionTexto: NullableString read fVersionTexto write fVersionTexto;
    property Fecha: NullableTDateTime read fFecha write fFecha;
    property FirmanteNombre: NullableString read fFirmanteNombre write fFirmanteNombre;
    property FirmanteIdentificacion: NullableString read fFirmanteIdentificacion write fFirmanteIdentificacion;
    property FirmaMime: NullableString read fFirmaMime write fFirmaMime;
    property Accion: NullableString read fAccion write fAccion;
    property Origen: NullableString read fOrigen write fOrigen;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_COTIZACIONES')]
  TVtCotizaciones = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('NUMERO')]
    fNumero: NullableInt32;
    [MVCTableField('SOLICITUD_ID')]
    fSolicitudId: NullableInt32;
    [MVCTableField('TIPO_TRABAJO_ID')]
    fTipoTrabajoId: NullableInt32;
    [MVCTableField('DESCRIPCION_TRABAJO')]
    [MVCMaxLength(500)]
    fDescripcionTrabajo: NullableString;
    [MVCTableField('ELABORADA_POR')]
    fElaboradaPor: NullableInt32;
    [MVCTableField('APROBADA_POR')]
    fAprobadaPor: NullableInt32;
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
    fFechaElaboracion: NullableTDateTime;
    [MVCTableField('FECHA_APROBACION')]
    fFechaAprobacion: NullableTDateTime;
    [MVCTableField('FECHA_ENVIO')]
    fFechaEnvio: NullableTDateTime;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('OBJVERSION')]
    fObjversion: NullableInt32;
    [MVCTableField('FORMA_PAGO_ID')]
    fFormaPagoId: NullableInt32;
    [MVCTableField('PLAZO_ENTREGA_CANTIDAD')]
    fPlazoEntregaCantidad: NullableInt16;
    [MVCTableField('GARANTIA_CANTIDAD')]
    fGarantiaCantidad: NullableInt16;
    [MVCTableField('ORDEN_COMPRA')]
    [MVCMaxLength(40)]
    fOrdenCompra: NullableString;
    [MVCTableField('ESTADO_ID')]
    fEstadoId: NullableInt32;
    [MVCTableField('PLAZO_ENTREGA_UNIDAD_ID')]
    fPlazoEntregaUnidadId: NullableInt32;
    [MVCTableField('GARANTIA_UNIDAD_ID')]
    fGarantiaUnidadId: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('ESTADO_NOMBRE')]
    [MVCMaxLength(120)]
    fEstadoNombre: NullableString;
    [MVCTableField('CLIENTE_ID')]
    fClienteId: NullableInt32;
    [MVCTableField('FORMA_PAGO')]
    [MVCMaxLength(120)]
    fFormaPago: NullableString;
    [MVCTableField('PLAZO_ENTREGA_UNIDAD')]
    [MVCMaxLength(20)]
    fPlazoEntregaUnidad: NullableString;
    [MVCTableField('GARANTIA_UNIDAD')]
    [MVCMaxLength(20)]
    fGarantiaUnidad: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property Numero: NullableInt32 read fNumero write fNumero;
    property SolicitudId: NullableInt32 read fSolicitudId write fSolicitudId;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId write fTipoTrabajoId;
    property DescripcionTrabajo: NullableString read fDescripcionTrabajo write fDescripcionTrabajo;
    property ElaboradaPor: NullableInt32 read fElaboradaPor write fElaboradaPor;
    property AprobadaPor: NullableInt32 read fAprobadaPor write fAprobadaPor;
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
    property FechaElaboracion: NullableTDateTime read fFechaElaboracion write fFechaElaboracion;
    property FechaAprobacion: NullableTDateTime read fFechaAprobacion write fFechaAprobacion;
    property FechaEnvio: NullableTDateTime read fFechaEnvio write fFechaEnvio;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
    property Objversion: NullableInt32 read fObjversion write fObjversion;
    property FormaPagoId: NullableInt32 read fFormaPagoId write fFormaPagoId;
    property PlazoEntregaCantidad: NullableInt16 read fPlazoEntregaCantidad write fPlazoEntregaCantidad;
    property GarantiaCantidad: NullableInt16 read fGarantiaCantidad write fGarantiaCantidad;
    property OrdenCompra: NullableString read fOrdenCompra write fOrdenCompra;
    property EstadoId: NullableInt32 read fEstadoId write fEstadoId;
    property PlazoEntregaUnidadId: NullableInt32 read fPlazoEntregaUnidadId write fPlazoEntregaUnidadId;
    property GarantiaUnidadId: NullableInt32 read fGarantiaUnidadId write fGarantiaUnidadId;
    property Estado: NullableString read fEstado write fEstado;
    property EstadoNombre: NullableString read fEstadoNombre write fEstadoNombre;
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property FormaPago: NullableString read fFormaPago write fFormaPago;
    property PlazoEntregaUnidad: NullableString read fPlazoEntregaUnidad write fPlazoEntregaUnidad;
    property GarantiaUnidad: NullableString read fGarantiaUnidad write fGarantiaUnidad;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_COTIZACION_DETALLE')]
  TVtCotizacionDetalle = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('COTIZACION_ID')]
    fCotizacionId: NullableInt32;
    [MVCTableField('MATERIAL_ID')]
    fMaterialId: NullableInt32;
    [MVCTableField('MANO_OBRA_ID')]
    fManoObraId: NullableInt32;
    [MVCTableField('MAQUINA_ID')]
    fMaquinaId: NullableInt32;
    [MVCTableField('DESCRIPCION')]
    [MVCMaxLength(500)]
    fDescripcion: NullableString;
    [MVCTableField('UNIDAD_MEDIDA')]
    [MVCMaxLength(20)]
    fUnidadMedida: NullableString;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableCurrency;
    [MVCTableField('PRECIO_UNITARIO')]
    fPrecioUnitario: NullableCurrency;
    [MVCTableField('SUBTOTAL')]
    fSubtotal: NullableCurrency;
    [MVCTableField('ORDEN')]
    fOrden: NullableInt16;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('TIPO_LINEA_ID')]
    fTipoLineaId: NullableInt32;
    [MVCTableField('TIPO')]
    [MVCMaxLength(20)]
    fTipo: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property CotizacionId: NullableInt32 read fCotizacionId write fCotizacionId;
    property MaterialId: NullableInt32 read fMaterialId write fMaterialId;
    property ManoObraId: NullableInt32 read fManoObraId write fManoObraId;
    property MaquinaId: NullableInt32 read fMaquinaId write fMaquinaId;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: NullableString read fUnidadMedida write fUnidadMedida;
    property Cantidad: NullableCurrency read fCantidad write fCantidad;
    property PrecioUnitario: NullableCurrency read fPrecioUnitario write fPrecioUnitario;
    property Subtotal: NullableCurrency read fSubtotal write fSubtotal;
    property Orden: NullableInt16 read fOrden write fOrden;
    property Activo: NullableBoolean read fActivo write fActivo;
    property TipoLineaId: NullableInt32 read fTipoLineaId write fTipoLineaId;
    property Tipo: NullableString read fTipo write fTipo;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_COTIZACION_ENVIOS')]
  TVtCotizacionEnvios = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('COTIZACION_ID')]
    fCotizacionId: NullableInt32;
    [MVCTableField('FECHA')]
    fFecha: NullableTDateTime;
    [MVCTableField('USUARIO_ID')]
    fUsuarioId: NullableInt32;
    [MVCTableField('PARA')]
    [MVCMaxLength(300)]
    fPara: NullableString;
    [MVCTableField('CC')]
    [MVCMaxLength(300)]
    fCC: NullableString;
    [MVCTableField('ASUNTO')]
    [MVCMaxLength(200)]
    fAsunto: NullableString;
    [MVCTableField('REMITENTE')]
    [MVCMaxLength(150)]
    fRemitente: NullableString;
    [MVCTableField('MODO_ENVIO_ID')]
    fModoEnvioId: NullableInt32;
    [MVCTableField('MODO')]
    [MVCMaxLength(20)]
    fModo: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property CotizacionId: NullableInt32 read fCotizacionId write fCotizacionId;
    property Fecha: NullableTDateTime read fFecha write fFecha;
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    property Para: NullableString read fPara write fPara;
    property CC: NullableString read fCC write fCC;
    property Asunto: NullableString read fAsunto write fAsunto;
    property Remitente: NullableString read fRemitente write fRemitente;
    property ModoEnvioId: NullableInt32 read fModoEnvioId write fModoEnvioId;
    property Modo: NullableString read fModo write fModo;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_COTIZACION_ESTADOS')]
  TVtCotizacionEstados = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('COTIZACION_ID')]
    fCotizacionId: NullableInt32;
    [MVCTableField('FECHA')]
    fFecha: NullableTDateTime;
    [MVCTableField('USUARIO_ID')]
    fUsuarioId: NullableInt32;
    [MVCTableField('MOTIVO')]
    [MVCMaxLength(500)]
    fMotivo: NullableString;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('ESTADO_ID')]
    fEstadoId: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('ESTADO_NOMBRE')]
    [MVCMaxLength(120)]
    fEstadoNombre: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property CotizacionId: NullableInt32 read fCotizacionId write fCotizacionId;
    property Fecha: NullableTDateTime read fFecha write fFecha;
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    property Motivo: NullableString read fMotivo write fMotivo;
    property Activo: NullableBoolean read fActivo write fActivo;
    property EstadoId: NullableInt32 read fEstadoId write fEstadoId;
    property Estado: NullableString read fEstado write fEstado;
    property EstadoNombre: NullableString read fEstadoNombre write fEstadoNombre;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_EMPRESA')]
  TVtEmpresa = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('RAZON_SOCIAL')]
    [MVCMaxLength(120)]
    fRazonSocial: NullableString;
    [MVCTableField('CEDULA_JURIDICA')]
    [MVCMaxLength(20)]
    fCedulaJuridica: NullableString;
    [MVCTableField('DIRECCION')]
    [MVCMaxLength(500)]
    fDireccion: NullableString;
    [MVCTableField('TELEFONO_FIJO')]
    [MVCMaxLength(30)]
    fTelefonoFijo: NullableString;
    [MVCTableField('CELULAR')]
    [MVCMaxLength(30)]
    fCelular: NullableString;
    [MVCTableField('CORREO')]
    [MVCMaxLength(150)]
    fCorreo: NullableString;
    [MVCTableField('REPRESENTANTE_LEGAL')]
    [MVCMaxLength(120)]
    fRepresentanteLegal: NullableString;
    [MVCTableField('CUENTA_BANCARIA')]
    [MVCMaxLength(60)]
    fCuentaBancaria: NullableString;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('PORCENTAJE_IVA')]
    fPorcentajeIva: NullableCurrency;
    [MVCTableField('DIAS_SIN_RESPUESTA')]
    fDiasSinRespuesta: NullableInt32;
    [MVCTableField('FIRMANTE')]
    [MVCMaxLength(120)]
    fFirmante: NullableString;
    [MVCTableField('CARTA_PRESENTACION')]
    [MVCMaxLength(4000)]
    fCartaPresentacion: NullableString;
    [MVCTableField('FORMA_PAGO_ID')]
    fFormaPagoId: NullableInt32;
    [MVCTableField('PLAZO_ENTREGA_CANTIDAD')]
    fPlazoEntregaCantidad: NullableInt16;
    [MVCTableField('GARANTIA_CANTIDAD')]
    fGarantiaCantidad: NullableInt16;
    [MVCTableField('PLAZO_ENTREGA_UNIDAD_ID')]
    fPlazoEntregaUnidadId: NullableInt32;
    [MVCTableField('GARANTIA_UNIDAD_ID')]
    fGarantiaUnidadId: NullableInt32;
    [MVCTableField('PLAZO_ENTREGA_UNIDAD')]
    [MVCMaxLength(20)]
    fPlazoEntregaUnidad: NullableString;
    [MVCTableField('GARANTIA_UNIDAD')]
    [MVCMaxLength(20)]
    fGarantiaUnidad: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property RazonSocial: NullableString read fRazonSocial write fRazonSocial;
    property CedulaJuridica: NullableString read fCedulaJuridica write fCedulaJuridica;
    property Direccion: NullableString read fDireccion write fDireccion;
    property TelefonoFijo: NullableString read fTelefonoFijo write fTelefonoFijo;
    property Celular: NullableString read fCelular write fCelular;
    property Correo: NullableString read fCorreo write fCorreo;
    property RepresentanteLegal: NullableString read fRepresentanteLegal write fRepresentanteLegal;
    property CuentaBancaria: NullableString read fCuentaBancaria write fCuentaBancaria;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
    property PorcentajeIva: NullableCurrency read fPorcentajeIva write fPorcentajeIva;
    property DiasSinRespuesta: NullableInt32 read fDiasSinRespuesta write fDiasSinRespuesta;
    property Firmante: NullableString read fFirmante write fFirmante;
    property CartaPresentacion: NullableString read fCartaPresentacion write fCartaPresentacion;
    property FormaPagoId: NullableInt32 read fFormaPagoId write fFormaPagoId;
    property PlazoEntregaCantidad: NullableInt16 read fPlazoEntregaCantidad write fPlazoEntregaCantidad;
    property GarantiaCantidad: NullableInt16 read fGarantiaCantidad write fGarantiaCantidad;
    property PlazoEntregaUnidadId: NullableInt32 read fPlazoEntregaUnidadId write fPlazoEntregaUnidadId;
    property GarantiaUnidadId: NullableInt32 read fGarantiaUnidadId write fGarantiaUnidadId;
    property PlazoEntregaUnidad: NullableString read fPlazoEntregaUnidad write fPlazoEntregaUnidad;
    property GarantiaUnidad: NullableString read fGarantiaUnidad write fGarantiaUnidad;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_MAQUINAS')]
  TVtMaquinas = class(TMVCActiveRecord)
  private
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
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('UNIDAD_MEDIDA_ID')]
    fUnidadMedidaId: NullableInt32;
    [MVCTableField('UNIDAD_MEDIDA')]
    [MVCMaxLength(20)]
    fUnidadMedida: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property Codigo: NullableString read fCodigo write fCodigo;
    property Nombre: NullableString read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property Activo: NullableBoolean read fActivo write fActivo;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
    property UnidadMedidaId: NullableInt32 read fUnidadMedidaId write fUnidadMedidaId;
    property UnidadMedida: NullableString read fUnidadMedida write fUnidadMedida;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_PERMISOS')]
  TVtPermisos = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('CODIGO')]
    [MVCMaxLength(50)]
    fCodigo: NullableString;
    [MVCTableField('NOMBRE')]
    [MVCMaxLength(120)]
    fNombre: NullableString;
    [MVCTableField('MODULO_ID')]
    fModuloId: NullableInt32;
    [MVCTableField('AMBITO_ID')]
    fAmbitoId: NullableInt32;
    [MVCTableField('MODULO')]
    [MVCMaxLength(30)]
    fModulo: NullableString;
    [MVCTableField('AMBITO')]
    [MVCMaxLength(20)]
    fAmbito: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property Codigo: NullableString read fCodigo write fCodigo;
    property Nombre: NullableString read fNombre write fNombre;
    property ModuloId: NullableInt32 read fModuloId write fModuloId;
    property AmbitoId: NullableInt32 read fAmbitoId write fAmbitoId;
    property Modulo: NullableString read fModulo write fModulo;
    property Ambito: NullableString read fAmbito write fAmbito;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_PRECIOS_PROGRAMADOS')]
  TVtPreciosProgramados = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('MATERIAL_ID')]
    fMaterialId: NullableInt32;
    [MVCTableField('MANO_OBRA_ID')]
    fManoObraId: NullableInt32;
    [MVCTableField('MAQUINA_ID')]
    fMaquinaId: NullableInt32;
    [MVCTableField('COSTO_UNITARIO')]
    fCostoUnitario: NullableCurrency;
    [MVCTableField('PRECIO_UNITARIO')]
    fPrecioUnitario: NullableCurrency;
    [MVCTableField('COSTO_HORA')]
    fCostoHora: NullableCurrency;
    [MVCTableField('FECHA_VIGENCIA')]
    fFechaVigencia: NullableTDateTime;
    [MVCTableField('FECHA_APLICACION')]
    fFechaAplicacion: NullableTDateTime;
    [MVCTableField('CREADO_POR')]
    fCreadoPor: NullableInt32;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('ESTADO_ID')]
    fEstadoId: NullableInt32;
    [MVCTableField('MATERIAL_PRECIO_ID')]
    fMaterialPrecioId: NullableInt32;
    [MVCTableField('MANO_OBRA_PRECIO_ID')]
    fManoObraPrecioId: NullableInt32;
    [MVCTableField('MAQUINA_PRECIO_ID')]
    fMaquinaPrecioId: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property MaterialId: NullableInt32 read fMaterialId write fMaterialId;
    property ManoObraId: NullableInt32 read fManoObraId write fManoObraId;
    property MaquinaId: NullableInt32 read fMaquinaId write fMaquinaId;
    property CostoUnitario: NullableCurrency read fCostoUnitario write fCostoUnitario;
    property PrecioUnitario: NullableCurrency read fPrecioUnitario write fPrecioUnitario;
    property CostoHora: NullableCurrency read fCostoHora write fCostoHora;
    property FechaVigencia: NullableTDateTime read fFechaVigencia write fFechaVigencia;
    property FechaAplicacion: NullableTDateTime read fFechaAplicacion write fFechaAplicacion;
    property CreadoPor: NullableInt32 read fCreadoPor write fCreadoPor;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property EstadoId: NullableInt32 read fEstadoId write fEstadoId;
    property MaterialPrecioId: NullableInt32 read fMaterialPrecioId write fMaterialPrecioId;
    property ManoObraPrecioId: NullableInt32 read fManoObraPrecioId write fManoObraPrecioId;
    property MaquinaPrecioId: NullableInt32 read fMaquinaPrecioId write fMaquinaPrecioId;
    property Estado: NullableString read fEstado write fEstado;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_ROLES')]
  TVtRoles = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('CODIGO')]
    [MVCMaxLength(20)]
    fCodigo: NullableString;
    [MVCTableField('NOMBRE')]
    [MVCMaxLength(120)]
    fNombre: NullableString;
    [MVCTableField('AMBITO_ID')]
    fAmbitoId: NullableInt32;
    [MVCTableField('AMBITO')]
    [MVCMaxLength(20)]
    fAmbito: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property Codigo: NullableString read fCodigo write fCodigo;
    property Nombre: NullableString read fNombre write fNombre;
    property AmbitoId: NullableInt32 read fAmbitoId write fAmbitoId;
    property Ambito: NullableString read fAmbito write fAmbito;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_ROLES_PERMISOS')]
  TVtRolesPermisos = class(TMVCActiveRecord)
  private
    [MVCTableField('ROL_ID')]
    fRolId: NullableInt32;
    [MVCTableField('PERMISO_ID')]
    fPermisoId: NullableInt32;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('AMBITO_ID')]
    fAmbitoId: NullableInt32;
    [MVCTableField('AMBITO')]
    [MVCMaxLength(20)]
    fAmbito: NullableString;
  public
    property RolId: NullableInt32 read fRolId write fRolId;
    property PermisoId: NullableInt32 read fPermisoId write fPermisoId;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property Activo: NullableBoolean read fActivo write fActivo;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
    property AmbitoId: NullableInt32 read fAmbitoId write fAmbitoId;
    property Ambito: NullableString read fAmbito write fAmbito;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_SOLICITUDES')]
  TVtSolicitudes = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('UUID_LOCAL')]
    [MVCMaxLength(36)]
    fUuidLocal: NullableString;
    [MVCTableField('CLIENTE_ID')]
    fClienteId: NullableInt32;
    [MVCTableField('ASESOR_ID')]
    fAsesorId: NullableInt32;
    [MVCTableField('DESCRIPCION')]
    [MVCMaxLength(500)]
    fDescripcion: NullableString;
    [MVCTableField('OBSERVACIONES')]
    [MVCMaxLength(500)]
    fObservaciones: NullableString;
    [MVCTableField('FECHA_CAPTURA')]
    fFechaCaptura: NullableTDateTime;
    [MVCTableField('FECHA_RECEPCION')]
    fFechaRecepcion: NullableTDateTime;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('OBJVERSION')]
    fObjversion: NullableInt32;
    [MVCTableField('CLIENTE_CONTACTO_ID')]
    fClienteContactoId: NullableInt32;
    [MVCTableField('NOMBRE_PROYECTO')]
    [MVCMaxLength(120)]
    fNombreProyecto: NullableString;
    [MVCTableField('ESTADO_ID')]
    fEstadoId: NullableInt32;
    [MVCTableField('ESTADO')]
    [MVCMaxLength(20)]
    fEstado: NullableString;
    [MVCTableField('ESTADO_NOMBRE')]
    [MVCMaxLength(120)]
    fEstadoNombre: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property ClienteId: NullableInt32 read fClienteId write fClienteId;
    property AsesorId: NullableInt32 read fAsesorId write fAsesorId;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property Observaciones: NullableString read fObservaciones write fObservaciones;
    property FechaCaptura: NullableTDateTime read fFechaCaptura write fFechaCaptura;
    property FechaRecepcion: NullableTDateTime read fFechaRecepcion write fFechaRecepcion;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
    property Objversion: NullableInt32 read fObjversion write fObjversion;
    property ClienteContactoId: NullableInt32 read fClienteContactoId write fClienteContactoId;
    property NombreProyecto: NullableString read fNombreProyecto write fNombreProyecto;
    property EstadoId: NullableInt32 read fEstadoId write fEstadoId;
    property Estado: NullableString read fEstado write fEstado;
    property EstadoNombre: NullableString read fEstadoNombre write fEstadoNombre;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_SOLICITUD_ADJUNTOS')]
  TVtSolicitudAdjuntos = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('UUID_LOCAL')]
    [MVCMaxLength(36)]
    fUuidLocal: NullableString;
    [MVCTableField('TIPO_ADJUNTO_ID')]
    fTipoAdjuntoId: NullableInt32;
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
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('OBJVERSION')]
    fObjversion: NullableInt32;
    [MVCTableField('PIEZA_ID')]
    fPiezaId: NullableInt32;
    [MVCTableField('HASH_SHA256')]
    [MVCMaxLength(64)]
    fHashSha256: NullableString;
    [MVCTableField('TIPO')]
    [MVCMaxLength(20)]
    fTipo: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property TipoAdjuntoId: NullableInt32 read fTipoAdjuntoId write fTipoAdjuntoId;
    property NombreArchivo: NullableString read fNombreArchivo write fNombreArchivo;
    property Mime: NullableString read fMime write fMime;
    property TamanoBytes: NullableInt32 read fTamanoBytes write fTamanoBytes;
    property Activo: NullableBoolean read fActivo write fActivo;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property Objversion: NullableInt32 read fObjversion write fObjversion;
    property PiezaId: NullableInt32 read fPiezaId write fPiezaId;
    property HashSha256: NullableString read fHashSha256 write fHashSha256;
    property Tipo: NullableString read fTipo write fTipo;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_SOLICITUD_MEDIDAS')]
  TVtSolicitudMedidas = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('UUID_LOCAL')]
    [MVCMaxLength(36)]
    fUuidLocal: NullableString;
    [MVCTableField('CROQUIS_ID')]
    fCroquisId: NullableInt32;
    [MVCTableField('ETIQUETA')]
    [MVCMaxLength(5)]
    fEtiqueta: NullableString;
    [MVCTableField('VALOR')]
    fValor: NullableCurrency;
    [MVCTableField('OBSERVACION')]
    [MVCMaxLength(500)]
    fObservacion: NullableString;
    [MVCTableField('ORDEN')]
    fOrden: NullableInt16;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('OBJVERSION')]
    fObjversion: NullableInt32;
    [MVCTableField('CANTIDAD')]
    fCantidad: NullableInt16;
    [MVCTableField('PIEZA_ID')]
    fPiezaId: NullableInt32;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('TIPO_MEDIDA_ID')]
    fTipoMedidaId: NullableInt32;
    [MVCTableField('UNIDAD_MEDIDA_ID')]
    fUnidadMedidaId: NullableInt32;
    [MVCTableField('TIPO_MEDIDA')]
    [MVCMaxLength(120)]
    fTipoMedida: NullableString;
    [MVCTableField('UNIDAD_MEDIDA')]
    [MVCMaxLength(10)]
    fUnidadMedida: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property CroquisId: NullableInt32 read fCroquisId write fCroquisId;
    property Etiqueta: NullableString read fEtiqueta write fEtiqueta;
    property Valor: NullableCurrency read fValor write fValor;
    property Observacion: NullableString read fObservacion write fObservacion;
    property Orden: NullableInt16 read fOrden write fOrden;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property Objversion: NullableInt32 read fObjversion write fObjversion;
    property Cantidad: NullableInt16 read fCantidad write fCantidad;
    property PiezaId: NullableInt32 read fPiezaId write fPiezaId;
    property Activo: NullableBoolean read fActivo write fActivo;
    property TipoMedidaId: NullableInt32 read fTipoMedidaId write fTipoMedidaId;
    property UnidadMedidaId: NullableInt32 read fUnidadMedidaId write fUnidadMedidaId;
    property TipoMedida: NullableString read fTipoMedida write fTipoMedida;
    property UnidadMedida: NullableString read fUnidadMedida write fUnidadMedida;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_UNIDADES_MEDIDA')]
  TVtUnidadesMedida = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('NOMBRE')]
    [MVCMaxLength(20)]
    fNombre: NullableString;
    [MVCTableField('ABREVIATURA')]
    [MVCMaxLength(10)]
    fAbreviatura: NullableString;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('MAGNITUD_ID')]
    fMagnitudId: NullableInt32;
    [MVCTableField('MAGNITUD')]
    [MVCMaxLength(20)]
    fMagnitud: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property Nombre: NullableString read fNombre write fNombre;
    property Abreviatura: NullableString read fAbreviatura write fAbreviatura;
    property Activo: NullableBoolean read fActivo write fActivo;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
    property MagnitudId: NullableInt32 read fMagnitudId write fMagnitudId;
    property Magnitud: NullableString read fMagnitud write fMagnitud;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_USUARIOS')]
  TVtUsuarios = class(TMVCActiveRecord)
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
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('DEBE_CAMBIAR_CLAVE')]
    fDebeCambiarClave: NullableBoolean;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('AMBITO_ID')]
    fAmbitoId: NullableInt32;
    [MVCTableField('AMBITO')]
    [MVCMaxLength(20)]
    fAmbito: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property Correo: NullableString read fCorreo write fCorreo;
    property Nombre: NullableString read fNombre write fNombre;
    property RolId: NullableInt32 read fRolId write fRolId;
    property Activo: NullableBoolean read fActivo write fActivo;
    property DebeCambiarClave: NullableBoolean read fDebeCambiarClave write fDebeCambiarClave;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
    property AmbitoId: NullableInt32 read fAmbitoId write fAmbitoId;
    property Ambito: NullableString read fAmbito write fAmbito;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_USUARIOS_DISPOSITIVOS')]
  TVtUsuariosDispositivos = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('USUARIO_ID')]
    fUsuarioId: NullableInt32;
    [MVCTableField('UUID_DISPOSITIVO')]
    [MVCMaxLength(36)]
    fUuidDispositivo: NullableString;
    [MVCTableField('NOMBRE')]
    [MVCMaxLength(120)]
    fNombre: NullableString;
    [MVCTableField('LLAVE_HASH')]
    [MVCMaxLength(64)]
    fLlaveHash: NullableString;
    [MVCTableField('LLAVE_ANTERIOR_HASH')]
    [MVCMaxLength(64)]
    fLlaveAnteriorHash: NullableString;
    [MVCTableField('FECHA_VENCE')]
    fFechaVence: NullableTDateTime;
    [MVCTableField('FECHA_ULTIMO_USO')]
    fFechaUltimoUso: NullableTDateTime;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('OBJVERSION')]
    fObjversion: NullableInt32;
    [MVCTableField('MOTIVO_CIERRE_ID')]
    fMotivoCierreId: NullableInt32;
    [MVCTableField('MOTIVO')]
    [MVCMaxLength(20)]
    fMotivo: NullableString;
  public
    property ID: NullableInt32 read fID write fID;
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    property UuidDispositivo: NullableString read fUuidDispositivo write fUuidDispositivo;
    property Nombre: NullableString read fNombre write fNombre;
    [MVCDoNotSerialize]
    property LlaveHash: NullableString read fLlaveHash write fLlaveHash;
    [MVCDoNotSerialize]
    property LlaveAnteriorHash: NullableString read fLlaveAnteriorHash write fLlaveAnteriorHash;
    property FechaVence: NullableTDateTime read fFechaVence write fFechaVence;
    property FechaUltimoUso: NullableTDateTime read fFechaUltimoUso write fFechaUltimoUso;
    property Activo: NullableBoolean read fActivo write fActivo;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
    property Objversion: NullableInt32 read fObjversion write fObjversion;
    property MotivoCierreId: NullableInt32 read fMotivoCierreId write fMotivoCierreId;
    property Motivo: NullableString read fMotivo write fMotivo;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_USUARIOS_PERMISOS')]
  TVtUsuariosPermisos = class(TMVCActiveRecord)
  private
    [MVCTableField('USUARIO_ID')]
    fUsuarioId: NullableInt32;
    [MVCTableField('PERMISO_ID')]
    fPermisoId: NullableInt32;
    [MVCTableField('MOTIVO')]
    [MVCMaxLength(500)]
    fMotivo: NullableString;
    [MVCTableField('FECHA_CREACION')]
    fFechaCreacion: NullableTDateTime;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('FECHA_MODIFICACION')]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('TIPO_EXCEPCION_ID')]
    fTipoExcepcionId: NullableInt32;
    [MVCTableField('AMBITO_ID')]
    fAmbitoId: NullableInt32;
    [MVCTableField('TIPO')]
    [MVCMaxLength(20)]
    fTipo: NullableString;
    [MVCTableField('AMBITO')]
    [MVCMaxLength(20)]
    fAmbito: NullableString;
  public
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    property PermisoId: NullableInt32 read fPermisoId write fPermisoId;
    property Motivo: NullableString read fMotivo write fMotivo;
    property FechaCreacion: NullableTDateTime read fFechaCreacion write fFechaCreacion;
    property Activo: NullableBoolean read fActivo write fActivo;
    property FechaModificacion: NullableTDateTime read fFechaModificacion write fFechaModificacion;
    property TipoExcepcionId: NullableInt32 read fTipoExcepcionId write fTipoExcepcionId;
    property AmbitoId: NullableInt32 read fAmbitoId write fAmbitoId;
    property Tipo: NullableString read fTipo write fTipo;
    property Ambito: NullableString read fAmbito write fAmbito;
  end;

implementation

end.
