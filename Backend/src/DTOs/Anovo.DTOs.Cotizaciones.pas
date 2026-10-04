unit Anovo.DTOs.Cotizaciones;

// DTOs de cotizaciones y su detalle.
// Compartidos con el escritorio.

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
    fAsesorNombre: string;
    fElaboradaPorNombre: string;
    fAprobadaPorNombre: string;
    fTipoTrabajoNombre: string;
  public
    property ID: Integer read fID write fID;
    property Numero: Integer read fNumero write fNumero;
    property SolicitudId: Integer read fSolicitudId write fSolicitudId;
    property ClienteId: Integer read fClienteId write fClienteId;
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
    property AsesorNombre: string read fAsesorNombre write fAsesorNombre;
    property ElaboradaPorNombre: string read fElaboradaPorNombre
      write fElaboradaPorNombre;
    property AprobadaPorNombre: string read fAprobadaPorNombre
      write fAprobadaPorNombre;
    property TipoTrabajoNombre: string read fTipoTrabajoNombre
      write fTipoTrabajoNombre;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCotizacionNuevaDTO = class
  private
    fSolicitudId: Integer;
    fTipoTrabajoId: NullableInt32;
    fDescripcionTrabajo: string;
  public
    property SolicitudId: Integer read fSolicitudId write fSolicitudId;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId
      write fTipoTrabajoId;
    property DescripcionTrabajo: string read fDescripcionTrabajo
      write fDescripcionTrabajo;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCotizacionEdicionDTO = class
  private
    fTipoTrabajoId: NullableInt32;
    fDescripcionTrabajo: string;
    fObjVersion: NullableInt32;
  public
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId
      write fTipoTrabajoId;
    property DescripcionTrabajo: string read fDescripcionTrabajo
      write fDescripcionTrabajo;
    [MVCNameAs('objversion')]
    property ObjVersion: NullableInt32 read fObjVersion write fObjVersion;
  end;

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
    property Tipo: string read fTipo write fTipo;
    property MaterialId: NullableInt32 read fMaterialId write fMaterialId;
    property ManoObraId: NullableInt32 read fManoObraId write fManoObraId;
    property MaquinaId: NullableInt32 read fMaquinaId write fMaquinaId;
    property Descripcion: string read fDescripcion write fDescripcion;
    property UnidadMedida: NullableString read fUnidadMedida
      write fUnidadMedida;
    property Cantidad: NullableCurrency read fCantidad write fCantidad;
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
    property PrecioUnitario: NullableCurrency read fPrecioUnitario
      write fPrecioUnitario;
  end;

  [MVCNameCase(ncSnakeCase)]
  TAjusteDTO = class
  private
    fPorcentajeAjuste: Currency;
    fMotivoAjuste: NullableString;
  public
    property PorcentajeAjuste: Currency read fPorcentajeAjuste
      write fPorcentajeAjuste;
    property MotivoAjuste: NullableString read fMotivoAjuste
      write fMotivoAjuste;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMotivoDTO = class
  private
    fMotivo: string;
  public
    property Motivo: string read fMotivo write fMotivo;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCotizacionBandejaDTO = class
  private
    fID: Integer;
    fNumero: Integer;
    fClienteNombre: string;
    fAsesorNombre: string;
    fElaboradaPorNombre: string;
    fDescripcionTrabajo: string;
    fFechaModificacion: NullableTDateTime;
    fDiasEnEstado: NullableInt32;
    fMontoTotal: NullableCurrency;
  public
    property ID: Integer read fID write fID;
    property Numero: Integer read fNumero write fNumero;
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property AsesorNombre: string read fAsesorNombre write fAsesorNombre;
    property ElaboradaPorNombre: string read fElaboradaPorNombre
      write fElaboradaPorNombre;
    property DescripcionTrabajo: string read fDescripcionTrabajo
      write fDescripcionTrabajo;
    property FechaModificacion: NullableTDateTime read fFechaModificacion
      write fFechaModificacion;
    property DiasEnEstado: NullableInt32 read fDiasEnEstado
      write fDiasEnEstado;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
  end;

  [MVCNameCase(ncSnakeCase)]
  TBandejaPaginaDTO = class
  private
    fData: TObjectList<TCotizacionBandejaDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
    fPorAprobar: Integer;
    fDiasMasAntigua: Integer;
    fMontoPorAprobar: Currency;
  public
    constructor Create;
    destructor Destroy; override;
    property Data: TObjectList<TCotizacionBandejaDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
    property PorAprobar: Integer read fPorAprobar write fPorAprobar;
    property DiasMasAntigua: Integer read fDiasMasAntigua
      write fDiasMasAntigua;
    property MontoPorAprobar: Currency read fMontoPorAprobar
      write fMontoPorAprobar;
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

constructor TBandejaPaginaDTO.Create;
begin
  inherited Create;
  fData := TObjectList<TCotizacionBandejaDTO>.Create(True);
end;

destructor TBandejaPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

end.
