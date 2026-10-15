unit Anovo.DTOs.Solicitudes;

// DTOs de solicitudes, piezas, medidas y adjuntos.
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
    fClienteContactoId: NullableInt32;
    fNombreProyecto: NullableString;
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
    property ClienteContactoId: NullableInt32 read fClienteContactoId
      write fClienteContactoId;
    property NombreProyecto: NullableString read fNombreProyecto
      write fNombreProyecto;
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
    fClienteUuid: NullableString;
    fClienteContactoId: NullableInt32;
    fClienteContactoUuid: NullableString;
    fNombreProyecto: NullableString;
  public
    property UuidLocal: string read fUuidLocal write fUuidLocal;
    property ClienteId: Integer read fClienteId write fClienteId;
    property ClienteUuid: NullableString read fClienteUuid write fClienteUuid;
    property ClienteContactoId: NullableInt32 read fClienteContactoId
      write fClienteContactoId;
    property ClienteContactoUuid: NullableString read fClienteContactoUuid
      write fClienteContactoUuid;
    property AsesorId: Integer read fAsesorId write fAsesorId;
    property Descripcion: string read fDescripcion write fDescripcion;
    property NombreProyecto: NullableString read fNombreProyecto
      write fNombreProyecto;
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
    fNombreProyecto: NullableString;
  public
    property Descripcion: string read fDescripcion write fDescripcion;
    property Observaciones: NullableString read fObservaciones
      write fObservaciones;
    property NombreProyecto: NullableString read fNombreProyecto
      write fNombreProyecto;
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
    fPiezaId: Integer;
    fPiezaNombre: string;
    fCroquisId: NullableInt32;
    fEtiqueta: NullableString;
    fTipoMedida: string;
    fValor: NullableCurrency;
    fUnidadMedida: string;
    fObservacion: NullableString;
    fOrden: Integer;
    fCantidad: Integer;
  public
    property ID: Integer read fID write fID;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property SolicitudId: Integer read fSolicitudId write fSolicitudId;
    property PiezaId: Integer read fPiezaId write fPiezaId;
    property PiezaNombre: string read fPiezaNombre write fPiezaNombre;
    property CroquisId: NullableInt32 read fCroquisId write fCroquisId;
    property Etiqueta: NullableString read fEtiqueta write fEtiqueta;
    property TipoMedida: string read fTipoMedida write fTipoMedida;
    property Valor: NullableCurrency read fValor write fValor;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
    property Observacion: NullableString read fObservacion write fObservacion;
    property Orden: Integer read fOrden write fOrden;
    property Cantidad: Integer read fCantidad write fCantidad;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMedidaNuevaDTO = class
  private
    fUuidLocal: NullableString;
    fPiezaId: NullableInt32;
    fPiezaUuid: NullableString;
    fCroquisId: NullableInt32;
    fCroquisUuid: NullableString;
    fEtiqueta: NullableString;
    fTipoMedida: string;
    fValor: NullableCurrency;
    fUnidadMedida: string;
    fObservacion: NullableString;
    fOrden: Integer;
    fCantidad: Integer;
  public
    constructor Create;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property PiezaId: NullableInt32 read fPiezaId write fPiezaId;
    property PiezaUuid: NullableString read fPiezaUuid write fPiezaUuid;
    property CroquisId: NullableInt32 read fCroquisId write fCroquisId;
    property CroquisUuid: NullableString read fCroquisUuid write fCroquisUuid;
    property Etiqueta: NullableString read fEtiqueta write fEtiqueta;
    property TipoMedida: string read fTipoMedida write fTipoMedida;
    property Valor: NullableCurrency read fValor write fValor;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
    property Observacion: NullableString read fObservacion write fObservacion;
    property Orden: Integer read fOrden write fOrden;
    property Cantidad: Integer read fCantidad write fCantidad;
  end;

  [MVCNameCase(ncSnakeCase)]
  TAdjuntoDTO = class
  private
    fID: Integer;
    fUuidLocal: string;
    fSolicitudId: Integer;
    fPiezaId: Integer;
    fPiezaNombre: string;
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
    property PiezaId: Integer read fPiezaId write fPiezaId;
    property PiezaNombre: string read fPiezaNombre write fPiezaNombre;
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
    fPiezaId: NullableInt32;
    fPiezaUuid: NullableString;
    fTipo: string;
    fNombreArchivo: NullableString;
    fMime: NullableString;
    fContenido: NullableString;
    fContenidoJson: NullableString;
  public
    property UuidLocal: string read fUuidLocal write fUuidLocal;
    property PiezaId: NullableInt32 read fPiezaId write fPiezaId;
    property PiezaUuid: NullableString read fPiezaUuid write fPiezaUuid;
    property Tipo: string read fTipo write fTipo;
    property NombreArchivo: NullableString read fNombreArchivo
      write fNombreArchivo;
    property Mime: NullableString read fMime write fMime;
    property Contenido: NullableString read fContenido write fContenido;
    property ContenidoJson: NullableString read fContenidoJson
      write fContenidoJson;
  end;

  [MVCNameCase(ncSnakeCase)]
  TPiezaDTO = class
  private
    fID: Integer;
    fSolicitudId: Integer;
    fUuidLocal: string;
    fNombre: string;
    fOrden: Integer;
    fTipoTrabajoId: NullableInt32;
    fTipoTrabajoNombre: NullableString;
    fTipoMaterialId: NullableInt32;
    fTipoMaterialNombre: NullableString;
    fAcabadoId: NullableInt32;
    fAcabadoNombre: NullableString;
    fMedidas: Integer;
    fFotos: Integer;
    fCroquis: Integer;
  public
    property ID: Integer read fID write fID;
    property SolicitudId: Integer read fSolicitudId write fSolicitudId;
    property UuidLocal: string read fUuidLocal write fUuidLocal;
    property Nombre: string read fNombre write fNombre;
    property Orden: Integer read fOrden write fOrden;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId
      write fTipoTrabajoId;
    property TipoTrabajoNombre: NullableString read fTipoTrabajoNombre
      write fTipoTrabajoNombre;
    property TipoMaterialId: NullableInt32 read fTipoMaterialId
      write fTipoMaterialId;
    property TipoMaterialNombre: NullableString read fTipoMaterialNombre
      write fTipoMaterialNombre;
    property AcabadoId: NullableInt32 read fAcabadoId write fAcabadoId;
    property AcabadoNombre: NullableString read fAcabadoNombre
      write fAcabadoNombre;
    property Medidas: Integer read fMedidas write fMedidas;
    property Fotos: Integer read fFotos write fFotos;
    property Croquis: Integer read fCroquis write fCroquis;
  end;

  [MVCNameCase(ncSnakeCase)]
  TPiezaNuevaDTO = class
  private
    fUuidLocal: string;
    fNombre: string;
    fOrden: Integer;
    fTipoTrabajoId: NullableInt32;
    fTipoMaterialId: NullableInt32;
    fAcabadoId: NullableInt32;
    fMedidas: TObjectList<TMedidaNuevaDTO>;
    fAdjuntos: TObjectList<TAdjuntoNuevoDTO>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property UuidLocal: string read fUuidLocal write fUuidLocal;
    property Nombre: string read fNombre write fNombre;
    property Orden: Integer read fOrden write fOrden;
    property TipoTrabajoId: NullableInt32 read fTipoTrabajoId
      write fTipoTrabajoId;
    property TipoMaterialId: NullableInt32 read fTipoMaterialId
      write fTipoMaterialId;
    property AcabadoId: NullableInt32 read fAcabadoId write fAcabadoId;
    [MVCListOf(TMedidaNuevaDTO)]
    property Medidas: TObjectList<TMedidaNuevaDTO> read fMedidas
      write fMedidas;
    [MVCListOf(TAdjuntoNuevoDTO)]
    property Adjuntos: TObjectList<TAdjuntoNuevoDTO> read fAdjuntos
      write fAdjuntos;
  end;

  [MVCNameCase(ncSnakeCase)]
  TSolicitudCompletaDTO = class
  private
    fSolicitud: TSolicitudNuevaDTO;
    fPiezas: TObjectList<TPiezaNuevaDTO>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Solicitud: TSolicitudNuevaDTO read fSolicitud write fSolicitud;
    [MVCListOf(TPiezaNuevaDTO)]
    property Piezas: TObjectList<TPiezaNuevaDTO> read fPiezas write fPiezas;
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
  TSolicitudEnTrabajoDTO = class
  private
    fID: Integer;
    fSolicitudId: Integer;
    fNumero: Integer;
    fClienteNombre: string;
    fAsesorNombre: string;
    fDescripcionTrabajo: string;
    fEstado: string;
    fDevuelta: Boolean;
    fMotivoRechazo: string;
    fFechaModificacion: NullableTDateTime;
  public
    property ID: Integer read fID write fID;
    property SolicitudId: Integer read fSolicitudId write fSolicitudId;
    property Numero: Integer read fNumero write fNumero;
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property AsesorNombre: string read fAsesorNombre write fAsesorNombre;
    property DescripcionTrabajo: string read fDescripcionTrabajo
      write fDescripcionTrabajo;
    property Estado: string read fEstado write fEstado;
    property Devuelta: Boolean read fDevuelta write fDevuelta;
    property MotivoRechazo: string read fMotivoRechazo write fMotivoRechazo;
    property FechaModificacion: NullableTDateTime read fFechaModificacion
      write fFechaModificacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TColaPaginaDTO = class
  private
    fData: TObjectList<TSolicitudPorCotizarDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
  public
    constructor Create(const AData: TObjectList<TSolicitudPorCotizarDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TSolicitudPorCotizarDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
  end;

  [MVCNameCase(ncSnakeCase)]
  TEnTrabajoPaginaDTO = class
  private
    fData: TObjectList<TSolicitudEnTrabajoDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
  public
    constructor Create(const AData: TObjectList<TSolicitudEnTrabajoDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TSolicitudEnTrabajoDTO> read fData write fData;
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

const
  CANTIDAD_POR_DEFECTO = 1;

constructor TMedidaNuevaDTO.Create;
begin
  inherited Create;
  fCantidad := CANTIDAD_POR_DEFECTO;
end;

constructor TPiezaNuevaDTO.Create;
begin
  inherited Create;
  fMedidas := TObjectList<TMedidaNuevaDTO>.Create(True);
  fAdjuntos := TObjectList<TAdjuntoNuevoDTO>.Create(True);
end;

destructor TPiezaNuevaDTO.Destroy;
begin
  fMedidas.Free;
  fAdjuntos.Free;
  inherited;
end;

constructor TSolicitudCompletaDTO.Create;
begin
  inherited Create;
  fSolicitud := TSolicitudNuevaDTO.Create;
  fPiezas := TObjectList<TPiezaNuevaDTO>.Create(True);
end;

destructor TSolicitudCompletaDTO.Destroy;
begin
  fSolicitud.Free;
  fPiezas.Free;
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

constructor TColaPaginaDTO.Create(const AData: TObjectList<TSolicitudPorCotizarDTO>;
  const ATotal: Int64; const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TColaPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

constructor TEnTrabajoPaginaDTO.Create(const AData: TObjectList<TSolicitudEnTrabajoDTO>;
  const ATotal: Int64; const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TEnTrabajoPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

end.
