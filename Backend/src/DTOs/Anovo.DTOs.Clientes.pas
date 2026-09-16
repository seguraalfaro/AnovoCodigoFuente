unit Anovo.DTOs.Clientes;

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  MVCFramework.Validation,
  MVCFramework.Validators;

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

    [MVCLatitude('la latitud esta fuera de rango')]
    property Latitud: NullableDouble read fLatitud write fLatitud;

    [MVCLongitude('la longitud esta fuera de rango')]
    property Longitud: NullableDouble read fLongitud write fLongitud;

    property Exonerado: Boolean read fExonerado write fExonerado;

    // Espeja CK_CLIENTES_EXONERACION. Aqui rechaza antes de tocar la base y con
    // el nombre del campo; la entidad lo vuelve a comprobar al guardar, que es
    // lo que protege si manana se escribe por otra via que no sea la API.
    [MVCRequiredIf('Exonerado', roEquals, 'True',
      'un cliente exonerado necesita el codigo de exoneracion')]
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

  // El sobre de la coleccion: { "data": [...], "total", "pagina", "por_pagina" }.
  //
  // Es una clase y no un ObjectDict porque ObjectDict solo admite objetos y
  // datasets, y aqui hacen falta tres escalares. Siempre sobre, nunca un arreglo
  // desnudo en la raiz: el arreglo no deja sitio para el total sin romper el
  // contrato, y sin total el cliente no sabe si hay mas paginas.
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
  // El sobre se queda con la lista. El framework libera lo que devuelve la
  // accion, y al liberar el sobre cae con el la lista y sus elementos.
  fData.Free;
  inherited;
end;

end.
