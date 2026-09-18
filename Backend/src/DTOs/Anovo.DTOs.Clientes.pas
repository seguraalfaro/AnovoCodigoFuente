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
  TClienteNuevoDTO = class(TMVCValidatable)
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
    fExonerado: Boolean;
    fCodigoExoneracion: NullableString;
  public
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;

    [MVCRequired('el nombre del cliente es obligatorio')]
    [MVCMaxLength(120, 'el nombre no puede pasar de 120 caracteres')]
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

    property Exonerado: Boolean read fExonerado write fExonerado;
    property CodigoExoneracion: NullableString read fCodigoExoneracion
      write fCodigoExoneracion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TClienteEdicionDTO = class(TClienteNuevoDTO)
  private
    fObjVersion: NullableInteger;
  public
    [MVCNameAs('objversion')]
    property ObjVersion: NullableInteger read fObjVersion write fObjVersion;
  end;

  // Un contacto del alta. uuid_local es obligatorio en la practica: es como la
  // firma dice quien firmo, porque el telefono no conoce ids del servidor.
  [MVCNameCase(ncSnakeCase)]
  TContactoNuevoDTO = class(TMVCValidatable)
  private
    fUuidLocal: NullableString;
    fNombre: string;
    fArea: NullableString;
    fTelefono: NullableString;
    fCelular: NullableString;
    fCorreo: NullableString;
    fPrincipal: Boolean;
  public
    property UuidLocal: NullableString read fUuidLocal write fUuidLocal;
    [MVCRequired('el nombre del contacto es obligatorio')]
    property Nombre: string read fNombre write fNombre;
    property Area: NullableString read fArea write fArea;
    property Telefono: NullableString read fTelefono write fTelefono;
    property Celular: NullableString read fCelular write fCelular;
    property Correo: NullableString read fCorreo write fCorreo;
    property Principal: Boolean read fPrincipal write fPrincipal;
  end;

  // La firma. La cedula queda para que la empresa sepa que empleado firmo.
  [MVCNameCase(ncSnakeCase)]
  TFirmaNuevaDTO = class(TMVCValidatable)
  private
    fClienteContactoUuid: NullableString;
    fFirmanteNombre: string;
    fFirmanteIdentificacion: string;
    fVersionTexto: string;
    fFecha: NullableTDateTime;
    fFirmaBase64: string;
    fMime: string;
  public
    property ClienteContactoUuid: NullableString read fClienteContactoUuid
      write fClienteContactoUuid;
    [MVCRequired('el nombre de quien firma es obligatorio')]
    property FirmanteNombre: string read fFirmanteNombre write fFirmanteNombre;
    [MVCRequired('la cedula de quien firma es obligatoria')]
    property FirmanteIdentificacion: string read fFirmanteIdentificacion
      write fFirmanteIdentificacion;
    [MVCRequired('la version del texto de consentimiento es obligatoria')]
    property VersionTexto: string read fVersionTexto write fVersionTexto;
    // Hora en que se firmo en el telefono, que puede ser dias antes de subir.
    property Fecha: NullableTDateTime read fFecha write fFecha;
    [MVCRequired('la imagen de la firma es obligatoria')]
    property FirmaBase64: string read fFirmaBase64 write fFirmaBase64;
    property Mime: string read fMime write fMime;
  end;

  // Los datos del cliente completo entra toda o no entra nada.
  [MVCNameCase(ncSnakeCase)]
  TClienteRegistroCompletoDTO = class(TMVCValidatable)
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

  fData.Free;
  inherited;
end;

{ TClienteRegistroCompletoDTO }

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
