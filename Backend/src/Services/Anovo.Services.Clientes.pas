unit Anovo.Services.Clientes;


// Servicio de clientes: donde vive el negocio.
//
// Tres cosas pasan aqui y en ningun otro sitio: el mapeo entre DTO y entidad,
// las reglas que necesitan mirar la base, y la transaccion.
//
// El mapeo lo hace TMapeo por nombre de propiedad. Los DTO de entrada espejan
// sus tablas, asi que lo que la app decide llega copiado. El servidor solo
// pone lo que la app no puede saber: el numero del cliente recien creado, los
// bytes de la firma y el estado cuando se revoca por este servicio.
//
// Recibe un repositorio por tabla del modulo (clientes, contactos e
// historial de consentimiento). El controller no toca la base y los
// repositorios no deciden nada.

interface

uses
  System.Generics.Collections,
  System.NetEncoding,
  MVCFramework,
  MVCFramework.Nullables,
  Anovo.Mapeo,
  Anovo.DTOs.Clientes,
  Anovo.Entities.Clientes,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Services.Intf.Clientes;

type
  TClienteService = class(TInterfacedObject, IClienteService)
  private
    fRepo: IClienteRepository;
    fContactos: IClienteContactoRepository;
    fConsentimientos: IConsentimientoRepository;
    function TraerVigente(const AId: Integer): TClientes;
    function TraerContacto(const AId, AContactoId: Integer): TClienteContactos;
    function ValidarUuidLocal(const AUuid: NullableString): Integer;
    function VerificarImagen(const ABase64: string): Boolean;
  public
    // Un repositorio por tabla. El servicio es el que los junta: las reglas
    // que cruzan tablas y la transaccion que las abarca viven aqui.
    [MVCInject]
    constructor Create(ARepo: IClienteRepository;
      AContactos: IClienteContactoRepository;
      AConsentimientos: IConsentimientoRepository); reintroduce;

    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean; const AConsentimiento: string;
      out ATotal: Int64): TObjectList<TClienteDTO>;
    function Obtener(const AId: Integer): TClienteDTO;
    function Crear(const ADto: TClienteNuevoDTO): Integer;
    procedure Actualizar(const AId: Integer; const ADto: TClienteEdicionDTO);
    procedure Inactivar(const AId: Integer);
    function RegistrarCompleto(const ADto: TClienteRegistroCompletoDTO)
      : Integer;

    function Contactos(const AId: Integer): TObjectList<TContactoDTO>;
    function CrearContacto(const AId: Integer;
      const ADto: TContactoNuevoDTO): Integer;
    procedure ActualizarContacto(const AId, AContactoId: Integer;
      const ADto: TContactoEdicionDTO);
    procedure InactivarContacto(const AId, AContactoId: Integer);

    function Consentimientos(const AId: Integer)
      : TObjectList<TConsentimientoDTO>;
    procedure Revocar(const AId: Integer; const ADto: TRevocacionDTO);
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  MVCFramework.ActiveRecord,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Errors;

const
  // Los tres estados del consentimiento, para validar el filtro del listado.
  CONSENTIMIENTO_PENDIENTE = 'pendiente';
  CONSENTIMIENTO_FIRMADO = 'firmado';
  CONSENTIMIENTO_REVOCADO = 'revocado';
  ACCION_REVOCADO = 'revocado';


constructor TClienteService.Create(ARepo: IClienteRepository;
  AContactos: IClienteContactoRepository;
  AConsentimientos: IConsentimientoRepository);
begin
  inherited Create;
  fRepo := ARepo;
  fContactos := AContactos;
  fConsentimientos := AConsentimientos;
end;

// Apoyo

function TClienteService.TraerVigente(const AId: Integer): TClientes;
begin
  // El False es RaiseExceptionIfNotFound: se prefiere lanzar la excepcion
  // propia, que sale con el codigo y el mensaje del contrato, y no la del
  // framework, que saldria con otra forma.
  Result := fRepo.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('el cliente', AId);
end;

function TClienteService.TraerContacto(const AId, AContactoId: Integer)
  : TClienteContactos;
begin
  Result := fContactos.ContactoDe(AId, AContactoId);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('el contacto', AContactoId);
end;

function TClienteService.ValidarUuidLocal(const AUuid: NullableString): Integer;
begin
  // Cero si todavia no habia subido.
  Result := fRepo.ExitsUuidLocal(AUuid);
end;

function TClienteService.VerificarImagen(const ABase64: string): Boolean;
begin
  Result := Length(TNetEncoding.Base64.DecodeStringToBytes(ABase64)) > 0;
end;

// Clientes

function TClienteService.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  const AConsentimiento: string; out ATotal: Int64): TObjectList<TClienteDTO>;
var
  lEntidades: TObjectList<TClientes>;
  lConsentimiento: string;
begin
  // Lo valida el servicio y no la base: sin esto, un valor mal escrito no da
  // error, devuelve una lista vacia y parece que no hay clientes.
  lConsentimiento := LowerCase(Trim(AConsentimiento));
  if (lConsentimiento <> '') and not MatchStr(lConsentimiento,
    [CONSENTIMIENTO_PENDIENTE, CONSENTIMIENTO_FIRMADO, CONSENTIMIENTO_REVOCADO])
  then
    raise EDatoInvalido.Create
      ('consentimiento debe ser pendiente, firmado o revocado.');

  ATotal := fRepo.ContarBusqueda(ATexto, AIncluirInactivos, lConsentimiento);
  lEntidades := fRepo.Buscar(ATexto, APagina, APorPagina, AIncluirInactivos,
    lConsentimiento);
  try
    // La lista a medio armar, si el mapeo falla, la libera TMapeo.
    Result := TMapeo.AListaDto<TClientes, TClienteDTO>(lEntidades);
  finally
    lEntidades.Free;
  end;
end;

function TClienteService.Obtener(const AId: Integer): TClienteDTO;
var
  lCliente: TClientes;
begin
  lCliente := TraerVigente(AId);
  try
    Result := TMapeo.ADto<TClienteDTO>(lCliente);
  finally
    lCliente.Free;
  end;
end;

function TClienteService.Crear(const ADto: TClienteNuevoDTO): Integer;
var
  lCliente: TClientes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  // Idempotencia. El telefono guarda sin conexion y sube cuando puede; si la
  // respuesta se pierde de vuelta, reintenta. Sin esta comprobacion cada
  // reintento seria un cliente nuevo, y el asesor terminaria con el mismo
  // cliente tres veces en el listado sin haber hecho nada mal.
  if ADto.UuidLocal.HasValue and not ADto.UuidLocal.Value.IsEmpty then
  begin
    Result := ValidarUuidLocal(ADto.UuidLocal);
    if Result > 0 then
      Exit;
  end;

  lCliente := TClientes.Create;
  try
    TMapeo.Copiar(ADto, lCliente);
    FijarDetalle('Registro del cliente ' + ADto.Nombre);
    fRepo.Insert(lCliente);
    Result := lCliente.ID.ValueOrDefault;
  finally
    lCliente.Free;
  end;
end;

procedure TClienteService.Actualizar(const AId: Integer;
  const ADto: TClienteEdicionDTO);
var
  lCliente: TClientes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  // Nullable a proposito: 0 es una version legitima -la de un cliente recien
  // creado-, asi que el cero no sirve como senal de "no vino".
  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create
      ('Falta la version del registro. Recargue el cliente y vuelva a editarlo.');

  lCliente := TraerVigente(AId);
  try
    if lCliente.Anonimizado then
      raise EConflictoDeEstado.Create('CLIENTE_ANONIMIZADO',
        'Este cliente fue anonimizado por politica de retencion de datos y ' +
        'ya no admite cambios.');

    // La comparacion se hace aqui, y no se deja solo a foVersion, para que el
    // caso corriente -alguien edito hace rato y este no lo sabia- salga con 409
    // y un mensaje que diga que hacer.
    if lCliente.ObjVersion <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create('el cliente', AId);

    // PUT reemplaza: lo que el DTO trae en null queda en null.
    TMapeo.Copiar(ADto, lCliente);
    FijarDetalle('Edicion de los datos del cliente');
    try
      fRepo.Update(lCliente);
    except
      on EMVCActiveRecordVersionedItemNotFound do
        // La carrera entre el SELECT de arriba y este UPDATE. Son
        // milisegundos, pero son justo los que la comprobacion previa no puede
        // cubrir. El framework lo detecta porque el UPDATE lleva
        // AND OBJVERSION = :vieja y afecta cero filas.
        raise EVersionVencida.Create('el cliente', AId);
    end;
  finally
    lCliente.Free;
  end;
end;

procedure TClienteService.Inactivar(const AId: Integer);
var
  lCliente: TClientes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lCliente := TraerVigente(AId);
  try
    // Ya inactivo no es un error: quien llamo queria que quedara inactivo, y lo
    // esta. Devolver 409 obligaria al cliente a distinguir dos casos que para
    // el son el mismo.
    if lCliente.Activo.ValueOrDefault = False then
      Exit;

    lCliente.Activo := False;
    FijarDetalle('Inactivacion del cliente');
    fRepo.Update(lCliente);
  finally
    lCliente.Free;
  end;
end;

function TClienteService.RegistrarCompleto(const ADto
  : TClienteRegistroCompletoDTO): Integer;
var
  lCliente: TClientes;
  lContacto: TClienteContactos;
  lFirma: TClienteConsentimientoHistorial;
  lDatos: TContactoNuevoDTO;
  lImagen: TBytes;
  lId: Integer;
begin
  // Una sola transaccion para las tres tablas. Si falla la firma, el cliente y
  // sus contactos tampoco quedan: un cliente sin consentimiento no puede
  // existir. Los tres repositorios comparten la conexion, asi que la
  // transaccion los abarca a todos.
  var
  lTx := TMVCRepository.UseTransactionContext;

  if not ADto.Cliente.UuidLocal.HasValue or ADto.Cliente.UuidLocal.Value.IsEmpty
  then
    raise EDatoInvalido.Create
      ('El registro no contiene informacion del UuidLocal .');

  lId := ValidarUuidLocal(ADto.Cliente.UuidLocal);
  if lId > 0 then
    Exit(lId);

  if ADto.Contactos.Count = 0 then
    raise EDatoInvalido.Create('El registro debe traer al menos un contacto.');

  if not VerificarImagen(ADto.Firma.FirmaBase64) then
    raise EDatoInvalido.Create('La imagen de la firma viene vacia.');

  lImagen := TNetEncoding.Base64.DecodeStringToBytes(ADto.Firma.FirmaBase64);

  // Los tres INSERT en un solo try: el finally libera las entidades pase lo
  // que pase, y el except traduce el fallo de la base a un error del
  // contrato. En nil por si algo falla antes de crear la siguiente.
  lCliente := nil;
  lContacto := nil;
  lFirma := nil;
  try
    try
      // 1. El cliente. Todo viene en el DTO, incluido el estado del
      // consentimiento: el control esta en el movil y en el escritorio.
      lCliente := TClientes.Create;
      TMapeo.Copiar(ADto.Cliente, lCliente);
      FijarDetalle('Registro con los datos completos desde el movil');
      fRepo.Insert(lCliente);
      lId := lCliente.ID.Value;

      // 2. Los contactos. Lo unico que pone el backend es el numero del
      // cliente, que lo acaba de dar la base y la app no podia conocer.
      for lDatos in ADto.Contactos do
      begin
        lContacto := TClienteContactos.Create;
        TMapeo.Copiar(lDatos, lContacto);
        lContacto.ClienteId := lId;
        fContactos.Insert(lContacto);
        // Uno por vuelta: el de la vuelta anterior ya se guardo.
        FreeAndNil(lContacto);
      end;

      // 3. La firma. Igual: el numero del cliente y los bytes de la imagen,
      // que viaja en base64 y la entidad guarda como BLOB.
      lFirma := TClienteConsentimientoHistorial.Create;
      TMapeo.Copiar(ADto.Firma, lFirma);
      lFirma.ClienteId := lId;
      lFirma.FirmaImagen.WriteBuffer(lImagen, Length(lImagen));
      fConsentimientos.Insert(lFirma);

      Result := lId;
    except
      // Las propias ya traen codigo, estado y un mensaje para la persona.
      on EAnovoError do
        raise;
      // Las de la base y la ORM no: sin esto, la app recibe un 500 con un
      // texto de Firebird y no hay forma de saber que registro fallo.
      on E: Exception do
        raise EConflictoDeEstado.Create('REGISTRO_NO_GUARDADO',
          Format('No se pudo guardar el registro de %s: %s',
          [ADto.Cliente.Nombre, E.Message]));
    end;
  finally
    lFirma.Free;
    lContacto.Free;
    lCliente.Free;
  end;
end;

// Contactos

function TClienteService.Contactos(const AId: Integer)
  : TObjectList<TContactoDTO>;
var
  lEntidades: TObjectList<TClienteContactos>;
begin
  lEntidades := fContactos.ContactosDe(AId);
  try
    Result := TMapeo.AListaDto<TClienteContactos, TContactoDTO>(lEntidades);
  finally
    lEntidades.Free;
  end;
end;

function TClienteService.CrearContacto(const AId: Integer;
  const ADto: TContactoNuevoDTO): Integer;
var
  lContacto: TClienteContactos;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lContacto := TClienteContactos.Create;
  try
    TMapeo.Copiar(ADto, lContacto);
    // El de la ruta manda sobre el del cuerpo: la ruta es la que dice de que
    // cliente es el contacto.
    lContacto.ClienteId := AId;
    FijarDetalle('Contacto nuevo del cliente ' + AId.ToString);
    fContactos.Insert(lContacto);
    Result := lContacto.ID.Value;
  finally
    lContacto.Free;
  end;
end;

procedure TClienteService.ActualizarContacto(const AId, AContactoId: Integer;
  const ADto: TContactoEdicionDTO);
var
  lContacto: TClienteContactos;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  // Nullable a proposito: 0 es una version legitima -la de un registro recien
  // creado-, asi que el cero no sirve como senal de "no vino".
  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create
      ('Falta la version del registro. Recargue el contacto y vuelva a editarlo.');

  lContacto := TraerContacto(AId, AContactoId);
  try
    if lContacto.ObjVersion.ValueOrDefault <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create('el contacto', AContactoId);

    TMapeo.Copiar(ADto, lContacto);
    lContacto.ClienteId := AId;
    FijarDetalle('Edicion del contacto ' + AContactoId.ToString);
    try
      fContactos.Update(lContacto);
    except
      on EMVCActiveRecordVersionedItemNotFound do
        // La carrera entre el SELECT de arriba y este UPDATE: el UPDATE lleva
        // AND OBJVERSION = :vieja y afecta cero filas.
        raise EVersionVencida.Create('el contacto', AContactoId);
    end;
  finally
    lContacto.Free;
  end;
end;

procedure TClienteService.InactivarContacto(const AId, AContactoId: Integer);
var
  lContacto: TClienteContactos;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lContacto := TraerContacto(AId, AContactoId);
  try
    // Ya inactivo no es un error: quien llamo queria que quedara inactivo, y
    // lo esta.
    if lContacto.Activo.ValueOrDefault = False then
      Exit;

    lContacto.Activo := False;
    FijarDetalle('Inactivacion del contacto ' + AContactoId.ToString);
    fContactos.Update(lContacto);
  finally
    lContacto.Free;
  end;
end;

// Consentimiento

function TClienteService.Consentimientos(const AId: Integer)
  : TObjectList<TConsentimientoDTO>;
var
  lEntidades: TObjectList<TClienteConsentimientoHistorial>;
begin
  lEntidades := fConsentimientos.HistorialDe(AId);
  try
    Result := TMapeo.AListaDto<TClienteConsentimientoHistorial,
      TConsentimientoDTO>(lEntidades);
  finally
    lEntidades.Free;
  end;
end;

procedure TClienteService.Revocar(const AId: Integer;
  const ADto: TRevocacionDTO);
var
  lCliente: TClientes;
  lFirma: TClienteConsentimientoHistorial;
  lFecha: TDateTime;
begin
  // El historial y el estado del cliente cambian juntos o no cambia ninguno:
  // un cliente en revocado sin la fila que lo respalde no sirve como prueba.
  var
  lTx := TMVCRepository.UseTransactionContext;

  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create
      ('Falta la version del registro. Recargue el cliente y vuelva a intentarlo.');

  lCliente := TraerVigente(AId);
  lFirma := nil;
  try
    if lCliente.ObjVersion <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create('el cliente', AId);
    if lCliente.ConsentimientoEstado = CONSENTIMIENTO_REVOCADO then
      raise EConflictoDeEstado.Create('CONSENTIMIENTO_YA_REVOCADO',
        'El consentimiento de este cliente ya estaba revocado.');

    // A diferencia de la firma, aqui no hay un momento anterior que guardar:
    // la revocacion ocurre cuando se registra.
    lFecha := Now;

    // La fila del historial. Del DTO viene quien la pidio y de donde; el
    // servidor pone lo que la app no decide: de que cliente es, que es una
    // revocacion, y que version del texto se estaba revocando.
    lFirma := TClienteConsentimientoHistorial.Create;
    TMapeo.Copiar(ADto, lFirma);
    lFirma.ClienteId := AId;
    lFirma.Accion := ACCION_REVOCADO;
    lFirma.VersionTexto := lCliente.ConsentimientoVersion.ValueOrDefault;
    lFirma.Fecha := lFecha;
    FijarDetalle('Revocacion del consentimiento pedida por ' +
      ADto.FirmanteNombre);
    fConsentimientos.Insert(lFirma);

    // Y el estado del cliente, que es lo que este endpoint significa.
    lCliente.ConsentimientoEstado := CONSENTIMIENTO_REVOCADO;
    lCliente.ConsentimientoFecha := lFecha;
    try
      fRepo.Update(lCliente);
    except
      on EMVCActiveRecordVersionedItemNotFound do
        raise EVersionVencida.Create('el cliente', AId);
    end;
  finally
    lFirma.Free;
    lCliente.Free;
  end;

end;

end.
