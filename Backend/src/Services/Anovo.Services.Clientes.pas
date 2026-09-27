unit Anovo.Services.Clientes;

// Servicio de clientes: registro con contactos, consentimiento
// y reglas que miran la base.

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
  Anovo.Errors,
  Anovo.Textos;

const
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

function TClienteService.TraerVigente(const AId: Integer): TClientes;
begin
  Result := fRepo.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoCliente, AId);
end;

function TClienteService.TraerContacto(const AId, AContactoId: Integer)
  : TClienteContactos;
begin
  Result := fContactos.ContactoDe(AId, AContactoId);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoContacto, AContactoId);
end;

function TClienteService.ValidarUuidLocal(const AUuid: NullableString): Integer;
begin
  Result := fRepo.ExitsUuidLocal(AUuid);
end;

function TClienteService.VerificarImagen(const ABase64: string): Boolean;
begin
  Result := Length(TNetEncoding.Base64.DecodeStringToBytes(ABase64)) > 0;
end;

function TClienteService.Buscar(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  const AConsentimiento: string; out ATotal: Int64): TObjectList<TClienteDTO>;
var
  lEntidades: TObjectList<TClientes>;
  lConsentimiento: string;
begin
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

  if ADto.UuidLocal.HasValue and not ADto.UuidLocal.Value.IsEmpty then
  begin
    Result := ValidarUuidLocal(ADto.UuidLocal);
    if Result > 0 then
      Exit;
  end;

  lCliente := TClientes.Create;
  try
    TMapeo.Copiar(ADto, lCliente);
    FijarDetalle(Format(SDetalleRegistroCliente, [ADto.Nombre]));
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

  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create
      ('Falta la version del registro. Recargue el cliente y vuelva a editarlo.');

  lCliente := TraerVigente(AId);
  try
    if lCliente.Anonimizado then
      raise EConflictoDeEstado.Create('CLIENTE_ANONIMIZADO',
        'Este cliente fue anonimizado por politica de retencion de datos y ' +
        'ya no admite cambios.');

    if lCliente.ObjVersion <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create('el cliente', AId);

    TMapeo.Copiar(ADto, lCliente);
    FijarDetalle(SDetalleEdicionCliente);
    try
      fRepo.Update(lCliente);
    except
      on EMVCActiveRecordVersionedItemNotFound do
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
    if lCliente.Activo.ValueOrDefault = False then
      Exit;

    lCliente.Activo := False;
    FijarDetalle(SDetalleInactivacionCliente);
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
    raise EDatoInvalido.Create(SRegistroSinContacto);

  if not VerificarImagen(ADto.Firma.FirmaBase64) then
    raise EDatoInvalido.Create(SFirmaVacia);

  lImagen := TNetEncoding.Base64.DecodeStringToBytes(ADto.Firma.FirmaBase64);

  lCliente := nil;
  lContacto := nil;
  lFirma := nil;
  try
    try
      lCliente := TClientes.Create;
      TMapeo.Copiar(ADto.Cliente, lCliente);
      FijarDetalle(SDetalleRegistroCompletoMovil);
      fRepo.Insert(lCliente);
      lId := lCliente.ID.Value;

      for lDatos in ADto.Contactos do
      begin
        lContacto := TClienteContactos.Create;
        TMapeo.Copiar(lDatos, lContacto);
        lContacto.ClienteId := lId;
        fContactos.Insert(lContacto);
        FreeAndNil(lContacto);
      end;

      lFirma := TClienteConsentimientoHistorial.Create;
      TMapeo.Copiar(ADto.Firma, lFirma);
      lFirma.ClienteId := lId;
      lFirma.FirmaImagen.WriteBuffer(lImagen, Length(lImagen));
      fConsentimientos.Insert(lFirma);

      Result := lId;
    except
      on EAnovoError do
        raise;
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
    lContacto.ClienteId := AId;
    FijarDetalle(Format(SDetalleContactoNuevo, [AId]));
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

  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create
      ('Falta la version del registro. Recargue el contacto y vuelva a editarlo.');

  lContacto := TraerContacto(AId, AContactoId);
  try
    if lContacto.ObjVersion.ValueOrDefault <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create('el contacto', AContactoId);

    TMapeo.Copiar(ADto, lContacto);
    lContacto.ClienteId := AId;
    FijarDetalle(Format(SDetalleEdicionContacto, [AContactoId]));
    try
      fContactos.Update(lContacto);
    except
      on EMVCActiveRecordVersionedItemNotFound do
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
    if lContacto.Activo.ValueOrDefault = False then
      Exit;

    lContacto.Activo := False;
    FijarDetalle(Format(SDetalleInactivacionContacto, [AContactoId]));
    fContactos.Update(lContacto);
  finally
    lContacto.Free;
  end;
end;

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

    lFecha := Now;

    lFirma := TClienteConsentimientoHistorial.Create;
    TMapeo.Copiar(ADto, lFirma);
    lFirma.ClienteId := AId;
    lFirma.Accion := ACCION_REVOCADO;
    lFirma.VersionTexto := lCliente.ConsentimientoVersion.ValueOrDefault;
    lFirma.Fecha := lFecha;
    FijarDetalle(Format(SDetalleRevocacionConsentimiento,
      [ADto.FirmanteNombre]));
    fConsentimientos.Insert(lFirma);

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
