unit Anovo.DTOs.Cotizaciones;

// El contrato de cotizaciones: lo que viaja entre la API y sus clientes.
//
// Compartida con el escritorio, que la compila desde esta misma ruta.
//
// Los totales no se reciben nunca: los calcula el servidor a partir del
// detalle. Un cliente que pudiera mandar el total podria mandar uno que no
// cuadra con las lineas.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type

  [MVCNameCase(ncSnakeCase)]
  TCotizacionDTO = class
  private
    fID: Integer;
    fNumero: Integer;
    fSolicitudId: Integer;
    fClienteId: Integer;
    fClienteNombre: string;
    fTipoTrabajoId: NullableInt32;
    fDescripcionTrabajo: string;
    fElaboradaPor: Integer;
    fAprobadaPor: NullableInt32;
    fEstado: string;
    fSubtotalMateriales: NullableCurrency;
    fSubtotalManoObra: NullableCurrency;
    fSubtotalMaquina: NullableCurrency;
    fCostoTotal: NullableCurrency;
    fPorcentajeAjuste: Currency;
    fMotivoAjuste: NullableString;
    fPorcentajeIva: Currency;
    fMontoImpuesto: NullableCurrency;
    fMontoTotal: NullableCurrency;
    fMotivoRechazo: NullableString;
    fFechaElaboracion: NullableTDateTime;
    fFechaAprobacion: NullableTDateTime;
    fFechaEnvio: NullableTDateTime;
    fFechaModificacion: NullableTDateTime;
    fObjVersion: Integer;
  public
    property ID: Integer read fID write fID;
    // El consecutivo que ve el cliente. Unico e irrepetible.
    property Numero: Integer read fNumero write fNumero;
    property SolicitudId: Integer read fSolicitudId write fSolicitudId;
    property ClienteId: Integer read fClienteId write fClienteId;
    // No sale de la tabla: lo llena el servicio.
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId
      write fTipoTrabajoId;
    property DescripcionTrabajo: string read fDescripcionTrabajo
      write fDescripcionTrabajo;
    property ElaboradaPor: Integer read fElaboradaPor write fElaboradaPor;
    property AprobadaPor: NullableInt32 read fAprobadaPor write fAprobadaPor;
    property Estado: string read fEstado write fEstado;
    property SubtotalMateriales: NullableCurrency read fSubtotalMateriales
      write fSubtotalMateriales;
    property SubtotalManoObra: NullableCurrency read fSubtotalManoObra
      write fSubtotalManoObra;
    property SubtotalMaquina: NullableCurrency read fSubtotalMaquina
      write fSubtotalMaquina;
    property CostoTotal: NullableCurrency read fCostoTotal write fCostoTotal;
    property PorcentajeAjuste: Currency read fPorcentajeAjuste
      write fPorcentajeAjuste;
    property MotivoAjuste: NullableString read fMotivoAjuste
      write fMotivoAjuste;
    property PorcentajeIva: Currency read fPorcentajeIva write fPorcentajeIva;
    property MontoImpuesto: NullableCurrency read fMontoImpuesto
      write fMontoImpuesto;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property MotivoRechazo: NullableString read fMotivoRechazo
      write fMotivoRechazo;
    property FechaElaboracion: NullableTDateTime read fFechaElaboracion
      write fFechaElaboracion;
    property FechaAprobacion: NullableTDateTime read fFechaAprobacion
      write fFechaAprobacion;
    property FechaEnvio: NullableTDateTime read fFechaEnvio write fFechaEnvio;
    property FechaModificacion: NullableTDateTime read fFechaModificacion
      write fFechaModificacion;
    [MVCNameAs('objversion')]
    property ObjVersion: Integer read fObjVersion write fObjVersion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCotizacionNuevaDTO = class
  private
    fSolicitudId: Integer;
    fTipoTrabajoId: NullableInt32;
    fDescripcionTrabajo: string;
    fPorcentajeIva: Currency;
  public
    property SolicitudId: Integer read fSolicitudId write fSolicitudId;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId
      write fTipoTrabajoId;
    // Si viene vacia, el servicio copia la de la solicitud.
    property DescripcionTrabajo: string read fDescripcionTrabajo
      write fDescripcionTrabajo;
    property PorcentajeIva: Currency read fPorcentajeIva write fPorcentajeIva;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCotizacionEdicionDTO = class
  private
    fTipoTrabajoId: NullableInt32;
    fDescripcionTrabajo: string;
    fPorcentajeIva: Currency;
    fObjVersion: NullableInt32;
  public
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId
      write fTipoTrabajoId;
    property DescripcionTrabajo: string read fDescripcionTrabajo
      write fDescripcionTrabajo;
    property PorcentajeIva: Currency read fPorcentajeIva write fPorcentajeIva;
    [MVCNameAs('objversion')]
    property ObjVersion: NullableInt32 read fObjVersion write fObjVersion;
  end;

  // DETALLE

  [MVCNameCase(ncSnakeCase)]
  TLineaDTO = class
  private
    fID: Integer;
    fCotizacionId: Integer;
    fTipo: string;
    fMaterialId: NullableInt32;
    fManoObraId: NullableInt32;
    fMaquinaId: NullableInt32;
    fDescripcion: string;
    fUnidadMedida: NullableString;
    fCantidad: NullableCurrency;
    fPrecioUnitario: NullableCurrency;
    fSubtotal: NullableCurrency;
    fOrden: Integer;
  public
    property ID: Integer read fID write fID;
    property CotizacionId: Integer read fCotizacionId write fCotizacionId;
    // material, mano_obra, maquina o nota.
    property Tipo: string read fTipo write fTipo;
    property MaterialId: NullableInt32 read fMaterialId write fMaterialId;
    property ManoObraId: NullableInt32 read fManoObraId write fManoObraId;
    property MaquinaId: NullableInt32 read fMaquinaId write fMaquinaId;
    property Descripcion: string read fDescripcion write fDescripcion;
    property UnidadMedida: NullableString read fUnidadMedida
      write fUnidadMedida;
    property Cantidad: NullableCurrency read fCantidad write fCantidad;
    // Copiado del catalogo al agregar la linea, no referenciado: si manana
    // sube el material, la cotizacion aprobada no cambia.
    property PrecioUnitario: NullableCurrency read fPrecioUnitario
      write fPrecioUnitario;
    property Subtotal: NullableCurrency read fSubtotal write fSubtotal;
    property Orden: Integer read fOrden write fOrden;
  end;

  [MVCNameCase(ncSnakeCase)]
  TLineaNuevaDTO = class
  private
    fTipo: string;
    fMaterialId: NullableInt32;
    fManoObraId: NullableInt32;
    fMaquinaId: NullableInt32;
    fDescripcion: string;
    fUnidadMedida: NullableString;
    fCantidad: NullableCurrency;
    fPrecioUnitario: NullableCurrency;
  public
    property Tipo: string read fTipo write fTipo;
    property MaterialId: NullableInt32 read fMaterialId write fMaterialId;
    property ManoObraId: NullableInt32 read fManoObraId write fManoObraId;
    property MaquinaId: NullableInt32 read fMaquinaId write fMaquinaId;
    property Descripcion: string read fDescripcion write fDescripcion;
    property UnidadMedida: NullableString read fUnidadMedida
      write fUnidadMedida;
    property Cantidad: NullableCurrency read fCantidad write fCantidad;
    // Opcional: si no viene, el servicio toma el precio vigente del catalogo.
    // Viene cuando el asistente lo corrige a mano para esta cotizacion.
    property PrecioUnitario: NullableCurrency read fPrecioUnitario
      write fPrecioUnitario;
  end;

  // OPERACIONES

  [MVCNameCase(ncSnakeCase)]
  TAjusteDTO = class
  private
    fPorcentajeAjuste: Currency;
    fMotivoAjuste: NullableString;
  public
    property PorcentajeAjuste: Currency read fPorcentajeAjuste
      write fPorcentajeAjuste;
    // Obligatorio cuando el porcentaje no es cero. Lo exige la base con
    // CK_COTIZ_MOTIVO_AJUSTE y se comprueba antes para dar mejor mensaje.
    property MotivoAjuste: NullableString read fMotivoAjuste
      write fMotivoAjuste;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMotivoDTO = class
  private
    fMotivo: string;
  public
    // Sirve para rechazar y para devolver: en los dos el motivo es
    // obligatorio.
    property Motivo: string read fMotivo write fMotivo;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCotizacionesPaginaDTO = class
  private
    fData: TObjectList<TCotizacionDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
  public
    constructor Create(const AData: TObjectList<TCotizacionDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TCotizacionDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
  end;

implementation

{ TCotizacionesPaginaDTO }

constructor TCotizacionesPaginaDTO.Create(const AData
  : TObjectList<TCotizacionDTO>; const ATotal: Int64;
  const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TCotizacionesPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

end.
