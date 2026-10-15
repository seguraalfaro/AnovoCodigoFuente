unit Anovo.DTOs.Sincronizacion;

// DTOs de /api/sincronizacion: lo que baja al movil desde una fecha, con la
// hora del servidor que el movil manda en la siguiente bajada.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type
  [MVCNameCase(ncSnakeCase)]
  TClienteBajadaDTO = class
  private
    fId: Integer;
    fUuidLocal: string;
    fNombre: string;
    fIdentificacion: string;
    fTipoIdentificacion: NullableInt32;
    fTelefono: string;
    fCorreo: string;
    fContacto: string;
    fDireccion: string;
    fLatitud: NullableDouble;
    fLongitud: NullableDouble;
    fConsentimientoEstado: string;
    fActivo: Boolean;
    fObjVersion: Integer;
  public
    property Id: Integer read fId write fId;
    property UuidLocal: string read fUuidLocal write fUuidLocal;
    property Nombre: string read fNombre write fNombre;
    property Identificacion: string read fIdentificacion write fIdentificacion;
    property TipoIdentificacion: NullableInt32 read fTipoIdentificacion
      write fTipoIdentificacion;
    property Telefono: string read fTelefono write fTelefono;
    property Correo: string read fCorreo write fCorreo;
    property Contacto: string read fContacto write fContacto;
    property Direccion: string read fDireccion write fDireccion;
    property Latitud: NullableDouble read fLatitud write fLatitud;
    property Longitud: NullableDouble read fLongitud write fLongitud;
    property ConsentimientoEstado: string read fConsentimientoEstado
      write fConsentimientoEstado;
    property Activo: Boolean read fActivo write fActivo;
    property ObjVersion: Integer read fObjVersion write fObjVersion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TContactoBajadaDTO = class
  private
    fId: Integer;
    fUuidLocal: string;
    fClienteId: Integer;
    fClienteUuid: string;
    fNombre: string;
    fArea: string;
    fTelefono: string;
    fCelular: string;
    fCorreo: string;
    fPrincipal: Boolean;
    fConsentimientoEstado: string;
    fConsentimientoVersion: string;
    fConsentimientoFecha: NullableTDateTime;
    fActivo: Boolean;
    fObjVersion: Integer;
  public
    property Id: Integer read fId write fId;
    property UuidLocal: string read fUuidLocal write fUuidLocal;
    property ClienteId: Integer read fClienteId write fClienteId;
    property ClienteUuid: string read fClienteUuid write fClienteUuid;
    property Nombre: string read fNombre write fNombre;
    property Area: string read fArea write fArea;
    property Telefono: string read fTelefono write fTelefono;
    property Celular: string read fCelular write fCelular;
    property Correo: string read fCorreo write fCorreo;
    property Principal: Boolean read fPrincipal write fPrincipal;
    property ConsentimientoEstado: string read fConsentimientoEstado
      write fConsentimientoEstado;
    property ConsentimientoVersion: string read fConsentimientoVersion
      write fConsentimientoVersion;
    property ConsentimientoFecha: NullableTDateTime read fConsentimientoFecha
      write fConsentimientoFecha;
    property Activo: Boolean read fActivo write fActivo;
    property ObjVersion: Integer read fObjVersion write fObjVersion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCatalogoBajadaDTO = class
  private
    fId: Integer;
    fNombre: string;
    fActivo: Boolean;
  public
    property Id: Integer read fId write fId;
    property Nombre: string read fNombre write fNombre;
    property Activo: Boolean read fActivo write fActivo;
  end;

  [MVCNameCase(ncSnakeCase)]
  TSolicitudBajadaDTO = class
  private
    fId: Integer;
    fUuidLocal: string;
    fNombreProyecto: string;
    fDescripcion: string;
    fClienteNombre: string;
    fFechaCaptura: NullableTDateTime;
    fEstado: string;
    fCotizacionId: NullableInt32;
    fCotizacionNumero: NullableInt32;
    fMontoAprobado: NullableCurrency;
  public
    property Id: Integer read fId write fId;
    property UuidLocal: string read fUuidLocal write fUuidLocal;
    property NombreProyecto: string read fNombreProyecto write fNombreProyecto;
    property Descripcion: string read fDescripcion write fDescripcion;
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property FechaCaptura: NullableTDateTime read fFechaCaptura
      write fFechaCaptura;
    property Estado: string read fEstado write fEstado;
    property CotizacionId: NullableInt32 read fCotizacionId
      write fCotizacionId;
    property CotizacionNumero: NullableInt32 read fCotizacionNumero
      write fCotizacionNumero;
    property MontoAprobado: NullableCurrency read fMontoAprobado
      write fMontoAprobado;
  end;

  [MVCNameCase(ncSnakeCase)]
  TBajadaDTO = class
  private
    fServidorAhora: TDateTime;
    fCompleta: Boolean;
    fClientes: TObjectList<TClienteBajadaDTO>;
    fContactos: TObjectList<TContactoBajadaDTO>;
    fTiposTrabajo: TObjectList<TCatalogoBajadaDTO>;
    fTiposMaterial: TObjectList<TCatalogoBajadaDTO>;
    fAcabados: TObjectList<TCatalogoBajadaDTO>;
    fSolicitudes: TObjectList<TSolicitudBajadaDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property ServidorAhora: TDateTime read fServidorAhora write fServidorAhora;
    property Completa: Boolean read fCompleta write fCompleta;
    [MVCListOf(TClienteBajadaDTO)]
    property Clientes: TObjectList<TClienteBajadaDTO> read fClientes
      write fClientes;
    [MVCListOf(TContactoBajadaDTO)]
    property Contactos: TObjectList<TContactoBajadaDTO> read fContactos
      write fContactos;
    [MVCListOf(TCatalogoBajadaDTO)]
    property TiposTrabajo: TObjectList<TCatalogoBajadaDTO> read fTiposTrabajo
      write fTiposTrabajo;
    [MVCListOf(TCatalogoBajadaDTO)]
    property TiposMaterial: TObjectList<TCatalogoBajadaDTO> read fTiposMaterial
      write fTiposMaterial;
    [MVCListOf(TCatalogoBajadaDTO)]
    property Acabados: TObjectList<TCatalogoBajadaDTO> read fAcabados
      write fAcabados;
    [MVCListOf(TSolicitudBajadaDTO)]
    property Solicitudes: TObjectList<TSolicitudBajadaDTO> read fSolicitudes
      write fSolicitudes;
  end;

implementation

constructor TBajadaDTO.Create;
begin
  inherited Create;
  fClientes := TObjectList<TClienteBajadaDTO>.Create;
  fContactos := TObjectList<TContactoBajadaDTO>.Create;
  fTiposTrabajo := TObjectList<TCatalogoBajadaDTO>.Create;
  fTiposMaterial := TObjectList<TCatalogoBajadaDTO>.Create;
  fAcabados := TObjectList<TCatalogoBajadaDTO>.Create;
  fSolicitudes := TObjectList<TSolicitudBajadaDTO>.Create;
end;

destructor TBajadaDTO.Destroy;
begin
  fClientes.Free;
  fContactos.Free;
  fTiposTrabajo.Free;
  fTiposMaterial.Free;
  fAcabados.Free;
  fSolicitudes.Free;
  inherited;
end;

end.
