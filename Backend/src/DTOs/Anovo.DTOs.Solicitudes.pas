unit Anovo.DTOs.Solicitudes;

// El contrato de solicitudes: lo que viaja entre la API y sus clientes.
//
// Compartida con el escritorio, que la compila desde esta misma ruta.
//
// Los DTO de entrada espejan sus tablas para que TMapeo copie por nombre.
// Quedan fuera las columnas que genera la base y el contenido binario de los
// adjuntos, que viaja en base64 y no como bytes.
//
// UuidLocal va en los tres DTO de entrada: es lo que hace idempotente reenviar
// desde el telefono lo que se capturo sin conexion.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type

  // SOLICITUD

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
    // No sale de la tabla: lo llena el servicio para que el listado no tenga
    // que pedir el cliente por cada fila.
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property AsesorId: Integer read fAsesorId write fAsesorId;
    property Descripcion: string read fDescripcion write fDescripcion;
    property Observaciones: NullableString read fObservaciones
      write fObservaciones;
    // Cuando el asesor la capturo, que puede ser horas antes de que subiera.
    property FechaCaptura: TDateTime read fFechaCaptura write fFechaCaptura;
    // Cuando llego al servidor. Nula mientras no se haya recibido.
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
    // Si no viene, el servicio pone la hora del servidor. La manda el movil,
    // que sabe cuando fue de verdad.
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
    // Nullable a proposito: 0 es una version legitima, la de una solicitud
    // recien creada, asi que el cero no sirve como senal de que no vino.
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

  // MEDIDAS

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
    // El croquis del que cuelga, si cuelga de alguno.
    property CroquisId: NullableInt32 read fCroquisId write fCroquisId;
    // Correlaciona con un punto del croquis. No es unica.
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

  // ADJUNTOS

  // Solo los metadatos: es lo que devuelve el listado. El contenido se pide
  // adjunto por adjunto.
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
    // croquis o foto.
    property Tipo: string read fTipo write fTipo;
    property NombreArchivo: NullableString read fNombreArchivo
      write fNombreArchivo;
    property Mime: NullableString read fMime write fMime;
    property TamanoBytes: NullableInt32 read fTamanoBytes write fTamanoBytes;
    property Activo: Boolean read fActivo write fActivo;
    property FechaCreacion: NullableTDateTime read fFechaCreacion
      write fFechaCreacion;
  end;

  // Los metadatos mas el contenido. Es la descarga de un adjunto.
  [MVCNameCase(ncSnakeCase)]
  TAdjuntoContenidoDTO = class(TAdjuntoDTO)
  private
    fContenido: NullableString;
    fContenidoJson: NullableString;
  public
    // Los bytes en base64. JSON no lleva binario y el cliente B4A ya trabaja
    // asi con las fotos.
    property Contenido: NullableString read fContenido write fContenido;
    // Los trazos del croquis. Va aparte del binario porque un croquis puede
    // tener los dos: el JSON para reeditarlo y la imagen para mostrarlo.
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
    // Base64. El tamano se calcula al decodificar, no se recibe: un cliente
    // que mienta en el tamano no debe poder saltarse el limite de 3 MB.
    property Contenido: NullableString read fContenido write fContenido;
    property ContenidoJson: NullableString read fContenidoJson
      write fContenidoJson;
  end;

  // EL ENVIO COMPLETO DEL MOVIL

  // Solicitud, medidas y adjuntos en un solo envio. El telefono no manda tres
  // peticiones que podrian quedarse a medias: manda esta, y o entra entera o
  // no entra.
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

implementation

{ TSolicitudCompletaDTO }

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

{ TSolicitudesPaginaDTO }

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

end.
