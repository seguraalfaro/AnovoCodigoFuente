unit Anovo.DTOs.Clientes;

// El contrato de clientes: lo que viaja entre la API y sus clientes.
//
// Compartida con el escritorio, que la compila desde esta misma ruta. Renombrar
// o quitar una propiedad rompe los dos proyectos a la vez, y es a proposito: un
// cambio de contrato que compila en un lado y no en el otro se ve en el acto,
// no en produccion con un campo que llega vacio.
//
// Los DTO de entrada espejan sus tablas: llevan todas las columnas que la app
// decide, y los nombres son los de las entidades para que TMapeo copie por
// nombre. Quedan fuera las que genera la base -ID, fechas y objversion- y las
// dos que no pueden viajar tal cual: el numero del cliente en un registro que
// lo esta creando, y la imagen de la firma, que va en base64.
//
// Sin validadores. Lo obligatorio y el largo de cada campo estan en las
// entidades, que salen de MVCEntGen con [MVCRequired] y [MVCMaxLength], y los
// aplica ActiveRecord al guardar. Aqui solo van los atributos de
// serializacion.
//
// Solo unidades de DMVC que el escritorio tambien tiene. Nada del servidor aqui.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type

  // SALIDA

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

  // Un contacto del cliente, tal como lo muestra la ficha. ObjVersion viaja
  // para la edicion: sin ella no hay forma de detectar que otro lo cambio en
  // el medio.
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

  // Una fila del historial de consentimiento. Sin la imagen de la firma: es
  // un BLOB, el listado no la muestra y la consulta ni siquiera la trae. Si
  // hace falta verla, se pide aparte. Sin ObjVersion: el historial no se
  // edita, cada cambio es una fila nueva.
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

  // ENTRADA

  // Espeja CLIENTES. El estado del consentimiento, activo y anonimizado los
  // manda la app: el control esta en el movil y en el escritorio, que son
  // parte del mismo sistema.
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

    // pendiente, firmado o revocado: lo comprueba el CHECK de la tabla.
    property ConsentimientoEstado: string read fConsentimientoEstado
      write fConsentimientoEstado;
    property ConsentimientoFecha: NullableTDateTime read fConsentimientoFecha
      write fConsentimientoFecha;
    property ConsentimientoVersion: NullableString read fConsentimientoVersion
      write fConsentimientoVersion;

    property Anonimizado: Boolean read fAnonimizado write fAnonimizado;
  end;

  // Nullable a proposito: 0 es una version legitima -la de un registro recien
  // creado-, asi que el cero no sirve como senal de "no vino".
  [MVCNameCase(ncSnakeCase)]
  TClienteEdicionDTO = class(TClienteNuevoDTO)
  private
    fObjVersion: NullableInt32;
  public
    [MVCNameAs('objversion')]
    property ObjVersion: NullableInt32 read fObjVersion write fObjVersion;
  end;

  // Espeja CLIENTE_CONTACTOS. uuid_local es obligatorio en el registro con
  // los datos completos: es como la firma dice quien firmo, porque el
  // telefono no conoce ids del servidor. Desde el escritorio no hace falta.
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

    // Lo manda la app cuando ya conoce el cliente. En el registro con los
    // datos completos llega en cero: el cliente se esta creando en esa misma
    // peticion y su numero lo da la base, asi que ahi lo pone el servidor.
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

  // Edicion de un contacto. Mismo criterio que la del cliente: objversion
  // obligatoria para detectar que otro lo cambio en el medio.
  [MVCNameCase(ncSnakeCase)]
  TContactoEdicionDTO = class(TContactoNuevoDTO)
  private
    fObjVersion: NullableInt32;
  public
    [MVCNameAs('objversion')]
    property ObjVersion: NullableInt32 read fObjVersion write fObjVersion;
  end;

  // Espeja CLIENTE_CONSENTIMIENTO_HISTORIAL. Dos campos no coinciden con la
  // tabla y no pueden: la imagen viaja en base64, y quien firmo viaja por
  // uuid porque el telefono no conoce los ids del servidor.
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

    // otorgado o revocado: lo comprueba el CHECK de la tabla.
    property Accion: string read fAccion write fAccion;
    property VersionTexto: string read fVersionTexto write fVersionTexto;

    // Hora en que se firmo en el telefono, que puede ser dias antes de subir.
    property Fecha: NullableTDateTime read fFecha write fFecha;

    // La cedula queda para que la empresa sepa que empleado firmo.
    property FirmanteNombre: string read fFirmanteNombre write fFirmanteNombre;
    property FirmanteIdentificacion: string read fFirmanteIdentificacion
      write fFirmanteIdentificacion;

    property FirmaBase64: string read fFirmaBase64 write fFirmaBase64;
    property FirmaMime: string read fFirmaMime write fFirmaMime;
    property Origen: NullableString read fOrigen write fOrigen;
  end;

    // La revocacion del consentimiento. ObjVersion es la del cliente, que
  // cambia de estado en la misma transaccion en que se agrega la fila al
  // historial. La fecha la pone el servidor: la revocacion ocurre cuando se
  // registra, no antes.
  [MVCNameCase(ncSnakeCase)]
  TRevocacionDTO = class
  private
    fClienteContactoId: NullableInt32;
    fFirmanteNombre: string;
    fFirmanteIdentificacion: string;
    fOrigen: NullableString;
    fObjVersion: NullableInt32;
  public
    // Quien pidio la revocacion, si es uno de los contactos del cliente.
    property ClienteContactoId: NullableInt32 read fClienteContactoId
      write fClienteContactoId;
    property FirmanteNombre: string read fFirmanteNombre write fFirmanteNombre;
    property FirmanteIdentificacion: string read fFirmanteIdentificacion
      write fFirmanteIdentificacion;
    // De donde viene: escritorio o movil. Lo dice quien llama.
    property Origen: NullableString read fOrigen write fOrigen;
    [MVCNameAs('objversion')]
    property ObjVersion: NullableInt32 read fObjVersion write fObjVersion;
  end;

  // Los datos del cliente completo entran todos o no entra nada.
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

  // SOBRE DE COLECCION

  // { "data": [...], "total", "pagina", "por_pagina" }.
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

// TClientesPaginaDTO

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

// TClienteRegistroCompletoDTO

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
