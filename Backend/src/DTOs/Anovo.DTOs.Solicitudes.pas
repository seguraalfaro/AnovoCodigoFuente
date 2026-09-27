unit Anovo.DTOs.Solicitudes;

// DTOs de solicitudes, medidas y adjuntos.
// Compartidos con el escritorio.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  Anovo.DTOs.Dashboard;

type

  [MVCNameCase(ncSnakeCase)]
  TSolicitudDTO = class
  private
    fID: Integer;
    fUuidLocal: string;
    fClienteId: Integer;
    fClienteNombre: string;
    fAsesorId: Integer;
    fDescripcion: string;
    fObservaciones: NullableString;
    fFechaCaptura: TDateTime;
    fFechaRecepcion: NullableTDateTime;
    fEstado: string;
    fFechaModificacion: NullableTDateTime;
    fObjVersion: Integer;
  public
    property ID: Integer read fID write fID;
    property UuidLocal: string read fUuidLocal write fUuidLocal;
    property ClienteId: Integer read fClienteId write fClienteId;
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property AsesorId: Integer read fAsesorId write fAsesorId;
    property Descripcion: string read fDescripcion write fDescripcion;
    property Observaciones: NullableString read fObservaciones
      write fObservaciones;
    property FechaCaptura: TDateTime read fFechaCaptura write fFechaCaptura;
    property FechaRecepcion: NullableTDateTime read fFechaRecepcion
      write fFechaRecepcion;
    property Estado: string read fEstado write fEstado;
    property FechaModificacion: NullableTDateTime read fFechaModificacion
      write fFechaModificacion;
    [MVCNameAs('objversion')]
    property ObjVersion: Integer read fObjVersion write fObjVersion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TSolicitudNuevaDTO = class
  private
    fUuidLocal: string;
    fClienteId: Integer;
    fAsesorId: Integer;
    fDescripcion: string;
    fObservaciones: NullableString;
    fFechaCaptura: NullableTDateTime;
  public
    property UuidLocal: string read fUuidLocal write fUuidLocal;
    property ClienteId: Integer read fClienteId write fClienteId;
    property AsesorId: Integer read fAsesorId write fAsesorId;
    property Descripcion: string read fDescripcion write fDescripcion;
    property Observaciones: NullableString read fObservaciones
      write fObservaciones;
    property FechaCaptura: NullableTDateTime read fFechaCaptura
      write fFechaCaptura;
  end;

  [MVCNameCase(ncSnakeCase)]
  TSolicitudEdicionDTO = class
  private
    fDescripcion: string;
    fObservaciones: NullableString;
    fObjVersion: NullableInt32;
  public
    property Descripcion: string read fDescripcion write fDescripcion;
    property Observaciones: NullableString read fObservaciones
      write fObservaciones;
    [MVCNameAs('objversion')]
    property ObjVersion: NullableInt32 read fObjVersion write fObjVersion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCambioEstadoDTO = class
  private
    fEstado: string;
    fObservacion: NullableString;
  public
    property Estado: string read fEstado write fEstado;
    property Observacion: NullableString read fObservacion write fObservacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMedidaDTO = class
  private
    fID: Integer;
    fUuidLocal: NullableString;
    fSolicitudId: Integer;
    fCroquisId: NullableInt32;
    fEtiqueta: NullableString;
    fTipoMedida: string;
    fValor: NullableCurrency;
    fUnidadMedida: string;
    fObservacion: NullableString;
    fOrden: Integer;
  public
    property ID: Integer read fID write fID;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property SolicitudId: Integer read fSolicitudId write fSolicitudId;
    property CroquisId: NullableInt32 read fCroquisId write fCroquisId;
    property Etiqueta: NullableString read fEtiqueta write fEtiqueta;
    property TipoMedida: string read fTipoMedida write fTipoMedida;
    property Valor: NullableCurrency read fValor write fValor;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
    property Observacion: NullableString read fObservacion write fObservacion;
    property Orden: Integer read fOrden write fOrden;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMedidaNuevaDTO = class
  private
    fUuidLocal: NullableString;
    fCroquisId: NullableInt32;
    fEtiqueta: NullableString;
    fTipoMedida: string;
    fValor: NullableCurrency;
    fUnidadMedida: string;
    fObservacion: NullableString;
    fOrden: Integer;
  public
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property CroquisId: NullableInt32 read fCroquisId write fCroquisId;
    property Etiqueta: NullableString read fEtiqueta write fEtiqueta;
    property TipoMedida: string read fTipoMedida write fTipoMedida;
    property Valor: NullableCurrency read fValor write fValor;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
    property Observacion: NullableString read fObservacion write fObservacion;
    property Orden: Integer read fOrden write fOrden;
  end;

  [MVCNameCase(ncSnakeCase)]
  TAdjuntoDTO = class
  private
    fID: Integer;
    fUuidLocal: string;
    fSolicitudId: Integer;
    fTipo: string;
    fNombreArchivo: NullableString;
    fMime: NullableString;
    fTamanoBytes: NullableInt32;
    fActivo: Boolean;
    fFechaCreacion: NullableTDateTime;
  public
    property ID: Integer read fID write fID;
    property UuidLocal: string read fUuidLocal write fUuidLocal;
    property SolicitudId: Integer read fSolicitudId write fSolicitudId;
    property Tipo: string read fTipo write fTipo;
    property NombreArchivo: NullableString read fNombreArchivo
      write fNombreArchivo;
    property Mime: NullableString read fMime write fMime;
    property TamanoBytes: NullableInt32 read fTamanoBytes write fTamanoBytes;
    property Activo: Boolean read fActivo write fActivo;
    property FechaCreacion: NullableTDateTime read fFechaCreacion
      write fFechaCreacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TAdjuntoContenidoDTO = class(TAdjuntoDTO)
  private
    fContenido: NullableString;
    fContenidoJson: NullableString;
  public
    property Contenido: NullableString read fContenido write fContenido;
    property ContenidoJson: NullableString read fContenidoJson
      write fContenidoJson;
  end;

  [MVCNameCase(ncSnakeCase)]
  TAdjuntoNuevoDTO = class
  private
    fUuidLocal: string;
    fTipo: string;
    fNombreArchivo: NullableString;
    fMime: NullableString;
    fContenido: NullableString;
    fContenidoJson: NullableString;
  public
    property UuidLocal: string read fUuidLocal write fUuidLocal;
    property Tipo: string read fTipo write fTipo;
    property NombreArchivo: NullableString read fNombreArchivo
      write fNombreArchivo;
    property Mime: NullableString read fMime write fMime;
    property Contenido: NullableString read fContenido write fContenido;
    property ContenidoJson: NullableString read fContenidoJson
      write fContenidoJson;
  end;

  [MVCNameCase(ncSnakeCase)]
  TSolicitudCompletaDTO = class
  private
    fSolicitud: TSolicitudNuevaDTO;
    fMedidas: TObjectList<TMedidaNuevaDTO>;
    fAdjuntos: TObjectList<TAdjuntoNuevoDTO>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Solicitud: TSolicitudNuevaDTO read fSolicitud write fSolicitud;
    property Medidas: TObjectList<TMedidaNuevaDTO> read fMedidas
      write fMedidas;
    property Adjuntos: TObjectList<TAdjuntoNuevoDTO> read fAdjuntos
      write fAdjuntos;
  end;

  [MVCNameCase(ncSnakeCase)]
  TSolicitudesPaginaDTO = class
  private
    fData: TObjectList<TSolicitudDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
  public
    constructor Create(const AData: TObjectList<TSolicitudDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TSolicitudDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
  end;

  [MVCNameCase(ncSnakeCase)]
  TSeguimientoPaginaDTO = class
  private
    fData: TObjectList<TSolicitudAsesorDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
    fDesde: NullableTDateTime;
    fHasta: NullableTDateTime;
  public
    constructor Create(const AData: TObjectList<TSolicitudAsesorDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TSolicitudAsesorDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
    property Desde: NullableTDateTime read fDesde write fDesde;
    property Hasta: NullableTDateTime read fHasta write fHasta;
  end;

implementation

constructor TSolicitudCompletaDTO.Create;
begin
  inherited Create;
  fSolicitud := TSolicitudNuevaDTO.Create;
  fMedidas := TObjectList<TMedidaNuevaDTO>.Create(True);
  fAdjuntos := TObjectList<TAdjuntoNuevoDTO>.Create(True);
end;

destructor TSolicitudCompletaDTO.Destroy;
begin
  fSolicitud.Free;
  fMedidas.Free;
  fAdjuntos.Free;
  inherited;
end;

constructor TSolicitudesPaginaDTO.Create(const AData
  : TObjectList<TSolicitudDTO>; const ATotal: Int64;
  const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TSolicitudesPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

constructor TSeguimientoPaginaDTO.Create
  (const AData: TObjectList<TSolicitudAsesorDTO>; const ATotal: Int64;
  const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TSeguimientoPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

end.
