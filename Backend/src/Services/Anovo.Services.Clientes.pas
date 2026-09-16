unit Anovo.Services.Clientes;

// Servicio de clientes: donde vive el negocio.
//
// Tres cosas pasan aqui y en ningun otro sitio: el mapeo entre DTO y entidad,
// las reglas que necesitan mirar la base, y la transaccion.
//
// El controller no toca la base y el repositorio no decide nada.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  Anovo.DTOs.Clientes,
  Anovo.Entities.Clientes,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Services.Intf.Clientes;

type
  TClienteService = class(TInterfacedObject, IClienteService)
  private
    fRepo: IClienteRepository;
    procedure AEntidad(const AOrigen: TClienteNuevoDTO;
      const ADestino: TClientes);
    function ADto(const AOrigen: TClientes): TClienteDTO;
    function TraerVigente(const AId: Integer): TClientes;
  public
    [MVCInject]
    constructor Create(ARepo: IClienteRepository); reintroduce;

    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TClienteDTO>;
    function Obtener(const AId: Integer): TClienteDTO;
    function Crear(const ADto: TClienteNuevoDTO): Integer;
    procedure Actualizar(const AId: Integer; const ADto: TClienteEdicionDTO);
    procedure Inactivar(const AId: Integer);
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.ActiveRecord,
  MVCFramework.Repository,
  Anovo.Errors;

const
  // Estado inicial del consentimiento. Lo pone el servidor, no el cliente: si
  // viajara en el cuerpo del POST, cualquiera podria darse por consentido.
  CONSENTIMIENTO_PENDIENTE = 'pendiente';

constructor TClienteService.Create(ARepo: IClienteRepository);
begin
  inherited Create;
  fRepo := ARepo;
end;

function TClienteService.TraerVigente(const AId: Integer): TClientes;
begin
  // El False es RaiseExceptionIfNotFound: se prefiere lanzar la excepcion
  // propia, que sale con el codigo y el mensaje del contrato, y no la del
  // framework, que saldria con otra forma.
  Result := fRepo.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('el cliente', AId);
end;

procedure TClienteService.AEntidad(const AOrigen: TClienteNuevoDTO;
  const ADestino: TClientes);
begin
  ADestino.UuidLocal := AOrigen.UuidLocal;
  ADestino.Nombre := AOrigen.Nombre;
  ADestino.Identificacion := AOrigen.Identificacion;
  ADestino.Telefono := AOrigen.Telefono;
  ADestino.Correo := AOrigen.Correo;
  ADestino.Direccion := AOrigen.Direccion;
  ADestino.Latitud := AOrigen.Latitud;
  ADestino.Longitud := AOrigen.Longitud;
  ADestino.Exonerado := AOrigen.Exonerado;
  ADestino.CodigoExoneracion := AOrigen.CodigoExoneracion;
  // Lo que NO se copia esta aqui a proposito: activo, anonimizado, las fechas
  // y los tres campos de consentimiento. El DTO de entrada ni siquiera los
  // trae, y por eso no hay forma de fijarlos desde afuera.
end;

function TClienteService.ADto(const AOrigen: TClientes): TClienteDTO;
begin
  Result := TClienteDTO.Create;
  Result.ID := AOrigen.ID.ValueOrDefault;
  Result.UuidLocal := AOrigen.UuidLocal;
  Result.Nombre := AOrigen.Nombre;
  Result.Identificacion := AOrigen.Identificacion;
  Result.Telefono := AOrigen.Telefono;
  Result.Correo := AOrigen.Correo;
  Result.Direccion := AOrigen.Direccion;
  Result.Latitud := AOrigen.Latitud;
  Result.Longitud := AOrigen.Longitud;
  Result.Activo := AOrigen.Activo.ValueOrDefault;
  Result.Exonerado := AOrigen.Exonerado;
  Result.CodigoExoneracion := AOrigen.CodigoExoneracion;
  Result.ConsentimientoEstado := AOrigen.ConsentimientoEstado;
  Result.ConsentimientoFecha := AOrigen.ConsentimientoFecha;
  Result.ConsentimientoVersion := AOrigen.ConsentimientoVersion;
  Result.Anonimizado := AOrigen.Anonimizado;
  Result.FechaCreacion := AOrigen.FechaCreacion.ValueOrDefault;
  Result.FechaModificacion := AOrigen.FechaModificacion.ValueOrDefault;
  Result.ObjVersion := AOrigen.ObjVersion;
end;

function TClienteService.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  out ATotal: Int64): TObjectList<TClienteDTO>;
var
  lEntidades: TObjectList<TClientes>;
  lEntidad: TClientes;
begin
  ATotal := fRepo.ContarBusqueda(ATexto, AIncluirInactivos);
  Result := TObjectList<TClienteDTO>.Create(True);
  try
    lEntidades := fRepo.Buscar(ATexto, APagina, APorPagina, AIncluirInactivos);
    try
      for lEntidad in lEntidades do
        Result.Add(ADto(lEntidad));
    finally
      lEntidades.Free;
    end;
  except
    // Si algo falla a mitad del mapeo, la lista a medio armar no la recibe
    // nadie que la pueda liberar.
    Result.Free;
    raise;
  end;
end;

function TClienteService.Obtener(const AId: Integer): TClienteDTO;
var
  lCliente: TClientes;
begin
  lCliente := TraerVigente(AId);
  try
    Result := ADto(lCliente);
  finally
    lCliente.Free;
  end;
end;

function TClienteService.Crear(const ADto: TClienteNuevoDTO): Integer;
var
  lExistente: TClientes;
  lCliente: TClientes;
begin
  var lTx := TMVCRepository.UseTransactionContext;

  // Idempotencia. El telefono guarda sin conexion y sube cuando puede; si la
  // respuesta se pierde de vuelta, reintenta. Sin esta comprobacion cada
  // reintento seria un cliente nuevo, y el asesor terminaria con el mismo
  // cliente tres veces en el listado sin haber hecho nada mal.
  if ADto.UuidLocal.HasValue and (ADto.UuidLocal.Value <> '') then
  begin
    lExistente := fRepo.ObtenerPorUuidLocal(ADto.UuidLocal.Value);
    if lExistente <> nil then
      try
        Exit(lExistente.ID.ValueOrDefault);
      finally
        lExistente.Free;
      end;
  end;

  lCliente := TClientes.Create;
  try
    AEntidad(ADto, lCliente);
    // Los tres los pone el servidor. Se asignan en vez de confiar en el DEFAULT
    // de la tabla porque el DEFAULT solo aplica cuando la columna no viaja en
    // el INSERT, y la ORM la manda igual.
    lCliente.Activo := True;
    lCliente.Anonimizado := False;
    lCliente.ConsentimientoEstado := CONSENTIMIENTO_PENDIENTE;

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
  var lTx := TMVCRepository.UseTransactionContext;

  // Nullable a proposito: 0 es una version legitima -la de un cliente recien
  // creado-, asi que el cero no sirve como senal de "no vino".
  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create(
      'Falta la version del registro. Recargue el cliente y vuelva a editarlo.');

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

    AEntidad(ADto, lCliente);
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
  var lTx := TMVCRepository.UseTransactionContext;

  lCliente := TraerVigente(AId);
  try
    // Ya inactivo no es un error: quien llamo queria que quedara inactivo, y lo
    // esta. Devolver 409 obligaria al cliente a distinguir dos casos que para
    // el son el mismo.
    if lCliente.Activo.ValueOrDefault = False then
      Exit;

    lCliente.Activo := False;
    fRepo.Update(lCliente);
  finally
    lCliente.Free;
  end;
end;

end.
