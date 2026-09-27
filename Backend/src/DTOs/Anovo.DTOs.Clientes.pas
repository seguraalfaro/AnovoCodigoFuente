unit Anovo.DTOs.Clientes;

// DTOs de clientes, contactos y consentimiento.
// Compartidos con el escritorio.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type

  [MVCNameCase(ncSnakeCase)]
  TClienteDTO = class
  private
    fID: Integer;
    fUuidLocal: NullableString;
    fNombre: string;
    fIdentificacion: NullableString;
    fTipoIdentificacion: NullableInt16;
    fContacto: NullableString;
    fTelefono: NullableString;
    fCorreo: NullableString;
    fDireccion: NullableString;
    fLatitud: NullableDouble;
    fLongitud: NullableDouble;
    fActivo: Boolean;
    fExonerado: Boolean;
    fCodigoExoneracion: NullableString;
    fConsentimientoEstado: string;
    fConsentimientoFecha: NullableTDateTime;
    fConsentimientoVersion: NullableString;
    fAnonimizado: Boolean;
    fFechaCreacion: TDateTime;
    fFechaModificacion: TDateTime;
    fObjVersion: Integer;
  public
    property ID: Integer read fID write fID;

    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property Nombre: string read fNombre write fNombre;
    property Identificacion: NullableString read fIdentificacion
      write fIdentificacion;
    property TipoIdentificacion: NullableInt16 read fTipoIdentificacion
      write fTipoIdentificacion;
    property Contacto: NullableString read fContacto write fContacto;
    property Telefono: NullableString read fTelefono write fTelefono;
    property Correo: NullableString read fCorreo write fCorreo;
    property Direccion: NullableString read fDireccion write fDireccion;
    property Latitud: NullableDouble read fLatitud write fLatitud;
    property Longitud: NullableDouble read fLongitud write fLongitud;
    property Activo: Boolean read fActivo write fActivo;
    property Exonerado: Boolean read fExonerado write fExonerado;
    property CodigoExoneracion: NullableString read fCodigoExoneracion
      write fCodigoExoneracion;

    property ConsentimientoEstado: string read fConsentimientoEstado
      write fConsentimientoEstado;
    property ConsentimientoFecha: NullableTDateTime read fConsentimientoFecha
      write fConsentimientoFecha;
    property ConsentimientoVersion: NullableString read fConsentimientoVersion
      write fConsentimientoVersion;

    property Anonimizado: Boolean read fAnonimizado write fAnonimizado;
    property FechaCreacion: TDateTime read fFechaCreacion write fFechaCreacion;
    property FechaModificacion: TDateTime read fFechaModificacion
      write fFechaModificacion;
    [MVCNameAs('objversion')]
    property ObjVersion: Integer read fObjVersion write fObjVersion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TContactoDTO = class
  private
    fID: Integer;
    fUuidLocal: NullableString;
    fClienteId: Integer;
    fNombre: string;
    fArea: NullableString;
    fTelefono: NullableString;
    fCelular: NullableString;
    fCorreo: NullableString;
    fPrincipal: Boolean;
    fConsentimientoEstado: string;
    fConsentimientoFecha: NullableTDateTime;
    fConsentimientoVersion: NullableString;
    fAnonimizado: Boolean;
    fActivo: Boolean;
    fFechaCreacion: TDateTime;
    fObjVersion: Integer;
  public
    property ID: Integer read fID write fID;
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property ClienteId: Integer read fClienteId write fClienteId;
    property Nombre: string read fNombre write fNombre;
    property Area: NullableString read fArea write fArea;
    property Telefono: NullableString read fTelefono write fTelefono;
    property Celular: NullableString read fCelular write fCelular;
    property Correo: NullableString read fCorreo write fCorreo;
    property Principal: Boolean read fPrincipal write fPrincipal;

    property ConsentimientoEstado: string read fConsentimientoEstado
      write fConsentimientoEstado;
    property ConsentimientoFecha: NullableTDateTime read fConsentimientoFecha
      write fConsentimientoFecha;
    property ConsentimientoVersion: NullableString read fConsentimientoVersion
      write fConsentimientoVersion;

    property Anonimizado: Boolean read fAnonimizado write fAnonimizado;
    property Activo: Boolean read fActivo write fActivo;
    property FechaCreacion: TDateTime read fFechaCreacion write fFechaCreacion;
    [MVCNameAs('objversion')]
    property ObjVersion: Integer read fObjVersion write fObjVersion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TConsentimientoDTO = class
  private
    fID: Integer;
    fClienteId: Integer;
    fClienteContactoId: NullableInt32;
    fAccion: string;
    fVersionTexto: string;
    fFecha: TDateTime;
    fFirmanteNombre: NullableString;
    fFirmanteIdentificacion: NullableString;
    fFirmaMime: NullableString;
    fOrigen: NullableString;
  public
    property ID: Integer read fID write fID;
    property ClienteId: Integer read fClienteId write fClienteId;
    property ClienteContactoId: NullableInt32 read fClienteContactoId
      write fClienteContactoId;
    property Accion: string read fAccion write fAccion;
    property VersionTexto: string read fVersionTexto write fVersionTexto;
    property Fecha: TDateTime read fFecha write fFecha;
    property FirmanteNombre: NullableString read fFirmanteNombre
      write fFirmanteNombre;
    property FirmanteIdentificacion: NullableString
      read fFirmanteIdentificacion write fFirmanteIdentificacion;
    property FirmaMime: NullableString read fFirmaMime write fFirmaMime;
    property Origen: NullableString read fOrigen write fOrigen;
  end;

  [MVCNameCase(ncSnakeCase)]
  TClienteNuevoDTO = class
  private
    fUuidLocal: NullableString;
    fNombre: string;
    fIdentificacion: NullableString;
    fTipoIdentificacion: NullableInt16;
    fContacto: NullableString;
    fTelefono: NullableString;
    fCorreo: NullableString;
    fDireccion: NullableString;
    fLatitud: NullableDouble;
    fLongitud: NullableDouble;
    fActivo: Boolean;
    fExonerado: Boolean;
    fCodigoExoneracion: NullableString;
    fConsentimientoEstado: string;
    fConsentimientoFecha: NullableTDateTime;
    fConsentimientoVersion: NullableString;
    fAnonimizado: Boolean;
  public
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    property Nombre: string read fNombre write fNombre;
    property Identificacion: NullableString read fIdentificacion
      write fIdentificacion;
    property TipoIdentificacion: NullableInt16 read fTipoIdentificacion
      write fTipoIdentificacion;
    property Contacto: NullableString read fContacto write fContacto;
    property Telefono: NullableString read fTelefono write fTelefono;
    property Correo: NullableString read fCorreo write fCorreo;
    property Direccion: NullableString read fDireccion write fDireccion;
    property Latitud: NullableDouble read fLatitud write fLatitud;
    property Longitud: NullableDouble read fLongitud write fLongitud;
    property Activo: Boolean read fActivo write fActivo;
    property Exonerado: Boolean read fExonerado write fExonerado;
    property CodigoExoneracion: NullableString read fCodigoExoneracion
      write fCodigoExoneracion;

    property ConsentimientoEstado: string read fConsentimientoEstado
      write fConsentimientoEstado;
    property ConsentimientoFecha: NullableTDateTime read fConsentimientoFecha
      write fConsentimientoFecha;
    property ConsentimientoVersion: NullableString read fConsentimientoVersion
      write fConsentimientoVersion;

    property Anonimizado: Boolean read fAnonimizado write fAnonimizado;
  end;

  [MVCNameCase(ncSnakeCase)]
  TClienteEdicionDTO = class(TClienteNuevoDTO)
  private
    fObjVersion: NullableInt32;
  public
    [MVCNameAs('objversion')]
    property ObjVersion: NullableInt32 read fObjVersion write fObjVersion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TContactoNuevoDTO = class
  private
    fUuidLocal: NullableString;
    fClienteId: Integer;
    fNombre: string;
    fArea: NullableString;
    fTelefono: NullableString;
    fCelular: NullableString;
    fCorreo: NullableString;
    fPrincipal: Boolean;
    fConsentimientoEstado: string;
    fAnonimizado: Boolean;
    fActivo: Boolean;
  public
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;

    property ClienteId: Integer read fClienteId write fClienteId;

    property Nombre: string read fNombre write fNombre;
    property Area: NullableString read fArea write fArea;
    property Telefono: NullableString read fTelefono write fTelefono;
    property Celular: NullableString read fCelular write fCelular;
    property Correo: NullableString read fCorreo write fCorreo;
    property Principal: Boolean read fPrincipal write fPrincipal;

    property ConsentimientoEstado: string read fConsentimientoEstado
      write fConsentimientoEstado;
    property Anonimizado: Boolean read fAnonimizado write fAnonimizado;
    property Activo: Boolean read fActivo write fActivo;
  end;

  [MVCNameCase(ncSnakeCase)]
  TContactoEdicionDTO = class(TContactoNuevoDTO)
  private
    fObjVersion: NullableInt32;
  public
    [MVCNameAs('objversion')]
    property ObjVersion: NullableInt32 read fObjVersion write fObjVersion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TFirmaNuevaDTO = class
  private
    fClienteContactoUuid: NullableString;
    fAccion: string;
    fVersionTexto: string;
    fFecha: NullableTDateTime;
    fFirmanteNombre: string;
    fFirmanteIdentificacion: string;
    fFirmaBase64: string;
    fFirmaMime: string;
    fOrigen: NullableString;
  public
    property ClienteContactoUuid: NullableString read fClienteContactoUuid
      write fClienteContactoUuid;

    property Accion: string read fAccion write fAccion;
    property VersionTexto: string read fVersionTexto write fVersionTexto;

    property Fecha: NullableTDateTime read fFecha write fFecha;

    property FirmanteNombre: string read fFirmanteNombre write fFirmanteNombre;
    property FirmanteIdentificacion: string read fFirmanteIdentificacion
      write fFirmanteIdentificacion;

    property FirmaBase64: string read fFirmaBase64 write fFirmaBase64;
    property FirmaMime: string read fFirmaMime write fFirmaMime;
    property Origen: NullableString read fOrigen write fOrigen;
  end;

  [MVCNameCase(ncSnakeCase)]
  TRevocacionDTO = class
  private
    fClienteContactoId: NullableInt32;
    fFirmanteNombre: string;
    fFirmanteIdentificacion: string;
    fOrigen: NullableString;
    fObjVersion: NullableInt32;
  public
    property ClienteContactoId: NullableInt32 read fClienteContactoId
      write fClienteContactoId;
    property FirmanteNombre: string read fFirmanteNombre write fFirmanteNombre;
    property FirmanteIdentificacion: string read fFirmanteIdentificacion
      write fFirmanteIdentificacion;
    property Origen: NullableString read fOrigen write fOrigen;
    [MVCNameAs('objversion')]
    property ObjVersion: NullableInt32 read fObjVersion write fObjVersion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TClienteRegistroCompletoDTO = class
  private
    fCliente: TClienteNuevoDTO;
    fContactos: TObjectList<TContactoNuevoDTO>;
    fFirma: TFirmaNuevaDTO;
  public
    constructor Create;
    destructor Destroy; override;
    property Cliente: TClienteNuevoDTO read fCliente write fCliente;
    [MVCListOf(TContactoNuevoDTO)]
    property Contactos: TObjectList<TContactoNuevoDTO> read fContactos
      write fContactos;
    property Firma: TFirmaNuevaDTO read fFirma write fFirma;
  end;

  [MVCNameCase(ncSnakeCase)]
  TClientesPaginaDTO = class
  private
    fData: TObjectList<TClienteDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
  public
    constructor Create(const AData: TObjectList<TClienteDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TClienteDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
  end;

implementation

constructor TClientesPaginaDTO.Create(const AData: TObjectList<TClienteDTO>;
  const ATotal: Int64; const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TClientesPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

constructor TClienteRegistroCompletoDTO.Create;
begin
  inherited Create;
  fCliente := TClienteNuevoDTO.Create;
  fContactos := TObjectList<TContactoNuevoDTO>.Create(True);
  fFirma := TFirmaNuevaDTO.Create;
end;

destructor TClienteRegistroCompletoDTO.Destroy;
begin
  fFirma.Free;
  fContactos.Free;
  fCliente.Free;
  inherited;
end;

end.
