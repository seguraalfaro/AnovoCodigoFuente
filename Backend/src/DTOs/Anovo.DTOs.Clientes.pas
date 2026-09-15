unit Anovo.DTOs.Clientes;

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  MVCFramework.Validation;

type

  [MVCNameCase(ncSnakeCase)]
  TClienteDTO = class
  private
    fID: Integer;
    fUuidLocal: NullableString;
    fNombre: string;
    fIdentificacion: NullableString;
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
    property Identificacion: NullableString read fIdentificacion write fIdentificacion;
    property Telefono: NullableString read fTelefono write fTelefono;
    property Correo: NullableString read fCorreo write fCorreo;
    property Direccion: NullableString read fDireccion write fDireccion;
    property Latitud: NullableDouble read fLatitud write fLatitud;
    property Longitud: NullableDouble read fLongitud write fLongitud;
    property Activo: Boolean read fActivo write fActivo;
    property Exonerado: Boolean read fExonerado write fExonerado;
    property CodigoExoneracion: NullableString read fCodigoExoneracion write fCodigoExoneracion;

    property ConsentimientoEstado: string read fConsentimientoEstado write fConsentimientoEstado;
    property ConsentimientoFecha: NullableTDateTime read fConsentimientoFecha write fConsentimientoFecha;
    property ConsentimientoVersion: NullableString read fConsentimientoVersion write fConsentimientoVersion;

    property Anonimizado: Boolean read fAnonimizado write fAnonimizado;
    property FechaCreacion: TDateTime read fFechaCreacion write fFechaCreacion;
    property FechaModificacion: TDateTime read fFechaModificacion write fFechaModificacion;
    [MVCNameAs('objversion')]
    property ObjVersion: Integer read fObjVersion write fObjVersion;
  end;


  [MVCNameCase(ncSnakeCase)]
  TClienteNuevoDTO = class(TMVCValidatable)
  private
    fUuidLocal: NullableString;
    fNombre: string;
    fIdentificacion: NullableString;
    fTelefono: NullableString;
    fCorreo: NullableString;
    fDireccion: NullableString;
    fLatitud: NullableDouble;
    fLongitud: NullableDouble;
    fExonerado: Boolean;
    fCodigoExoneracion: NullableString;
  public
    [MVCMaxLength(36, 'el identificador local no puede pasar de 36 caracteres')]
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;

    [MVCRequired('el nombre del cliente es obligatorio')]
    [MVCMaxLength(120, 'el nombre no puede pasar de 120 caracteres')]
    property Nombre: string read fNombre write fNombre;

    [MVCMaxLength(30, 'la identificacion no puede pasar de 30 caracteres')]
    property Identificacion: NullableString read fIdentificacion write fIdentificacion;

    [MVCMaxLength(30, 'el telefono no puede pasar de 30 caracteres')]
    property Telefono: NullableString read fTelefono write fTelefono;

    [MVCEmail('el correo no tiene formato valido')]
    [MVCMaxLength(150, 'el correo no puede pasar de 150 caracteres')]
    property Correo: NullableString read fCorreo write fCorreo;

    [MVCMaxLength(500, 'la direccion no puede pasar de 500 caracteres')]
    property Direccion: NullableString read fDireccion write fDireccion;

    [MVCRange(-90, 90, 'la latitud esta fuera de rango')]
    property Latitud: NullableDouble read fLatitud write fLatitud;

    [MVCRange(-180, 180, 'la longitud esta fuera de rango')]
    property Longitud: NullableDouble read fLongitud write fLongitud;

    property Exonerado: Boolean read fExonerado write fExonerado;

    [MVCMaxLength(30, 'el codigo de exoneracion no puede pasar de 30 caracteres')]
    property CodigoExoneracion: NullableString read fCodigoExoneracion write fCodigoExoneracion;
  end;


  [MVCNameCase(ncSnakeCase)]
  TClienteEdicionDTO = class(TClienteNuevoDTO)
  private
    fObjVersion: NullableInteger;
  public
    [MVCNameAs('objversion')]
    property ObjVersion: NullableInteger read fObjVersion write fObjVersion;
  end;

implementation

end.
