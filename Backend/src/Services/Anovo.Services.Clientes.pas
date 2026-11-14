unit Anovo.Services.Clientes;

// Servicio de clientes: registro con contactos, consentimiento,
// anonimizacion (Ley 8968) y reglas que miran la base.

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
  Anovo.Repositories.Intf.Solicitudes,
  Anovo.Services.Intf.Clientes;

type
  TClienteService = class(TInterfacedObject, IClienteService)
  private
    fRepo: IClienteRepository;
    fContactos: IClienteContactoRepository;
    fConsentimientos: IConsentimientoRepository;
    fAdjuntos: ISolicitudAdjuntoRepository;
    function TraerVigente(const AId: Integer): TClientes;
    function TraerContacto(const AId, AContactoId: Integer): TClienteContactos;
    procedure ExigirClienteEditable(const AId: Integer);
    function ValidarUuidLocal(const AUuid: NullableString): Integer;
    function VerificarImagen(const ABase64: string): Boolean;
    procedure EstadoInicial(const ACliente: TClientes); overload;
    procedure EstadoInicial(const AContacto: TClienteContactos); overload;
    procedure CopiarEstado(const AOrigen, ADestino: TClientes); overload;
    procedure CopiarEstado(const AOrigen, ADestino: TClienteContactos); overload;
    procedure ExigirPersonaFisica(const ACliente: TClientes);
    procedure ExigirNoRepetido(const ACliente: TClientes;
      const AExcluirId: Integer);
    procedure AnonimizarContactos(const AClienteId: Integer);
    procedure VaciarContacto(const AContacto: TClienteContactos);
    procedure DejarUnSoloPrincipal(const AClienteId, AContactoId: Integer);
    procedure AnonimizarAdjuntos(const AClienteId: Integer);
  public
    [MVCInject]
    constructor Create(ARepo: IClienteRepository;
      AContactos: IClienteContactoRepository;
      AConsentimientos: IConsentimientoRepository;
      AAdjuntos: ISolicitudAdjuntoRepository); reintroduce;

    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean; const AConsentimiento: string;
      out ATotal: Int64): TObjectList<TClienteDTO>;
    function Obtener(const AId: Integer): TClienteDTO;
    function Crear(const ADto: TClienteNuevoDTO): Integer;
    procedure Actualizar(const AId: Integer; const ADto: TClienteEdicionDTO);
    procedure Inactivar(const AId: Integer);
    procedure Anonimizar(const AId: Integer; const AMotivo: string);
    procedure AnonimizarContacto(const AId, AContactoId: Integer;
      const AMotivo: string);
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
    function Otorgar(const AId: Integer; const ADto: TFirmaNuevaDTO): Integer;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  MVCFramework.ActiveRecord,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Entities.Consultas,
  Anovo.Entities.Solicitudes,
  Anovo.Errors,
  Anovo.Textos;

const
  CONSENTIMIENTO_PENDIENTE = 'pendiente';
  CONSENTIMIENTO_FIRMADO = 'firmado';
  CONSENTIMIENTO_REVOCADO = 'revocado';
  ACCION_REVOCADO = 'revocado';
  ACCION_OTORGADO = 'otorgado';
  TIPO_IDENT_FISICA = 1;
  TIPO_IDENT_DIMEX = 3;

constructor TClienteService.Create(ARepo: IClienteRepository;
  AContactos: IClienteContactoRepository;
  AConsentimientos: IConsentimientoRepository;
  AAdjuntos: ISolicitudAdjuntoRepository);
begin
  inherited Create;
  fRepo := ARepo;
  fContactos := AContactos;
  fConsentimientos := AConsentimientos;
  fAdjuntos := AAdjuntos;
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

procedure TClienteService.ExigirClienteEditable(const AId: Integer);
var
  lCliente: TClientes;
begin
  lCliente := TraerVigente(AId);
  try
    if lCliente.Anonimizado then
      raise EConflictoDeEstado.Create('CLIENTE_ANONIMIZADO',
        SClienteAnonimizado);
    if not lCliente.Activo.ValueOrDefault then
      raise EConflictoDeEstado.Create('CLIENTE_INACTIVO',
        SClienteInactivoEdicion);
  finally
    lCliente.Free;
  end;
end;

function TClienteService.ValidarUuidLocal(const AUuid: NullableString): Integer;
begin
  Result := fRepo.ExitsUuidLocal(AUuid);
end;

function TClienteService.VerificarImagen(const ABase64: string): Boolean;
begin
  Result := Length(TNetEncoding.Base64.DecodeStringToBytes(ABase64)) > 0;
end;

procedure TClienteService.EstadoInicial(const ACliente: TClientes);
begin
  ACliente.Activo := True;
  ACliente.ConsentimientoEstado := CONSENTIMIENTO_PENDIENTE;
  ACliente.ConsentimientoFecha := nil;
  ACliente.ConsentimientoVersion := nil;
  ACliente.Anonimizado := False;
end;

procedure TClienteService.EstadoInicial(const AContacto: TClienteContactos);
begin
  AContacto.Activo := True;
  AContacto.ConsentimientoEstado := CONSENTIMIENTO_PENDIENTE;
  AContacto.ConsentimientoFecha := nil;
  AContacto.ConsentimientoVersion := nil;
  AContacto.Anonimizado := False;
end;

procedure TClienteService.CopiarEstado(const AOrigen, ADestino: TClientes);
begin
  ADestino.UuidLocal := AOrigen.UuidLocal;
  ADestino.Activo := AOrigen.Activo;
  ADestino.ConsentimientoEstado := AOrigen.ConsentimientoEstado;
  ADestino.ConsentimientoFecha := AOrigen.ConsentimientoFecha;
  ADestino.ConsentimientoVersion := AOrigen.ConsentimientoVersion;
  ADestino.Anonimizado := AOrigen.Anonimizado;
end;

procedure TClienteService.CopiarEstado(const AOrigen,
  ADestino: TClienteContactos);
begin
  ADestino.UuidLocal := AOrigen.UuidLocal;
  ADestino.Activo := AOrigen.Activo;
  ADestino.ConsentimientoEstado := AOrigen.ConsentimientoEstado;
  ADestino.ConsentimientoFecha := AOrigen.ConsentimientoFecha;
  ADestino.ConsentimientoVersion := AOrigen.ConsentimientoVersion;
  ADestino.Anonimizado := AOrigen.Anonimizado;
end;

procedure TClienteService.ExigirPersonaFisica(const ACliente: TClientes);
begin
  if not ACliente.TipoIdentificacion.HasValue then
    raise EDatoInvalido.Create(SAnonimizarSinTipo);
  if (ACliente.TipoIdentificacion.Value <> TIPO_IDENT_FISICA) and
    (ACliente.TipoIdentificacion.Value <> TIPO_IDENT_DIMEX) then
    raise EDatoInvalido.Create(SAnonimizarSoloFisica);
end;

procedure TClienteService.ExigirNoRepetido(const ACliente: TClientes;
  const AExcluirId: Integer);
var
  lNumero: string;
  lOtro: TClientes;
begin
  if ACliente.Identificacion.HasValue and
    ACliente.TipoIdentificacion.HasValue then
  begin
    lNumero := ACliente.Identificacion.Value.Replace('-', '', [rfReplaceAll])
      .Replace(' ', '', [rfReplaceAll]);
    if not lNumero.IsEmpty then
    begin
      lOtro := fRepo.ConIdentificacion(ACliente.TipoIdentificacion.Value,
        lNumero, AExcluirId);
      if lOtro <> nil then
        try
          raise EConflictoDeEstado.Create('CLIENTE_IDENTIFICACION_REPETIDA',
            Format(SClienteIdentificacionRepetida,
            [ACliente.Identificacion.Value, lOtro.Nombre]));
        finally
          lOtro.Free;
        end;
    end;
  end;

  if fRepo.NombreRepetido(ACliente.Nombre.Trim, AExcluirId) then
    raise EConflictoDeEstado.Create('CLIENTE_DUPLICADO',
      Format(SClienteNombreRepetido, [ACliente.Nombre.Trim]));
end;

procedure TClienteService.AnonimizarContactos(const AClienteId: Integer);
var
  lContactos: TObjectList<TClienteContactos>;
  lContacto: TClienteContactos;
begin
  lContactos := fContactos.TodosDe(AClienteId);
  try
    for lContacto in lContactos do
      VaciarContacto(lContacto);
  finally
    lContactos.Free;
  end;
end;

procedure TClienteService.VaciarContacto(const AContacto: TClienteContactos);
begin
  AContacto.Nombre := SContactoAnonimizadoNombre;
  AContacto.Area := nil;
  AContacto.Telefono := nil;
  AContacto.Celular := nil;
  AContacto.Correo := nil;
  AContacto.Anonimizado := True;
  AContacto.Activo := False;
  fContactos.Update(AContacto);
end;

procedure TClienteService.AnonimizarContacto(const AId, AContactoId: Integer;
  const AMotivo: string);
var
  lContacto: TClienteContactos;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if AMotivo.Trim.IsEmpty then
    raise EDatoInvalido.Create(SMotivoFalta);

  lContacto := TraerContacto(AId, AContactoId);
  try
    if lContacto.Anonimizado then
      raise EConflictoDeEstado.Create('CONTACTO_ANONIMIZADO',
        SContactoYaAnonimizado);
    FijarDetalle(Format(SDetalleAnonimizacionContacto,
      [AContactoId, AId, AMotivo.Trim]));
    VaciarContacto(lContacto);
  finally
    lContacto.Free;
  end;
end;

procedure TClienteService.AnonimizarAdjuntos(const AClienteId: Integer);
var
  lAdjuntos: TObjectList<TSolicitudAdjuntos>;
  lAdjunto: TSolicitudAdjuntos;
begin
  lAdjuntos := fAdjuntos.DeCliente(AClienteId);
  try
    for lAdjunto in lAdjuntos do
    begin
      if Assigned(lAdjunto.Contenido) then
        lAdjunto.Contenido.Size := 0;
      lAdjunto.ContenidoJson := nil;
      lAdjunto.TamanoBytes := 0;
      lAdjunto.Activo := False;
      fAdjuntos.Update(lAdjunto);
    end;
  finally
    lAdjuntos.Free;
  end;
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
    raise EDatoInvalido.Create(SFiltroConsentimientoInvalido);

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
    ExigirLargoUuid(ADto.UuidLocal.Value);
    Result := ValidarUuidLocal(ADto.UuidLocal);
    if Result > 0 then
      Exit;
  end;

  lCliente := TClientes.Create;
  try
    TMapeo.Copiar(ADto, lCliente);
    EstadoInicial(lCliente);
    ExigirNoRepetido(lCliente, 0);
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
  lCliente, lAntes: TClientes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create(Format(SFaltaVersion, [SRecursoCliente]));

  lCliente := TraerVigente(AId);
  lAntes := TClientes.Create;
  try
    if lCliente.Anonimizado then
      raise EConflictoDeEstado.Create('CLIENTE_ANONIMIZADO',
        SClienteAnonimizado);

    if lCliente.ObjVersion <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create(SRecursoCliente, AId);

    CopiarEstado(lCliente, lAntes);
    TMapeo.Copiar(ADto, lCliente);
    CopiarEstado(lAntes, lCliente);
    ExigirNoRepetido(lCliente, AId);
    FijarDetalle(SDetalleEdicionCliente);
    try
      fRepo.Update(lCliente);
    except
      on EMVCActiveRecordVersionedItemNotFound do
        raise EVersionVencida.Create(SRecursoCliente, AId);
    end;
  finally
    lAntes.Free;
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

procedure TClienteService.Anonimizar(const AId: Integer;
  const AMotivo: string);
var
  lCliente: TClientes;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if AMotivo.Trim.IsEmpty then
    raise EDatoInvalido.Create(SMotivoFalta);

  lCliente := TraerVigente(AId);
  try
    if lCliente.Anonimizado then
      raise EConflictoDeEstado.Create('CLIENTE_ANONIMIZADO',
        SClienteAnonimizado);
    ExigirPersonaFisica(lCliente);

    FijarDetalle(Format(SDetalleAnonimizacionCliente, [AId, AMotivo.Trim]));
    lCliente.Nombre := Format(SClienteAnonimizadoNombre, [AId]);
    lCliente.Identificacion := nil;
    lCliente.Contacto := nil;
    lCliente.Telefono := nil;
    lCliente.Correo := nil;
    lCliente.Direccion := nil;
    lCliente.Latitud := nil;
    lCliente.Longitud := nil;
    lCliente.Exonerado := False;
    lCliente.CodigoExoneracion := nil;
    lCliente.Anonimizado := True;
    lCliente.Activo := False;
    fRepo.Update(lCliente);

    AnonimizarContactos(AId);
    AnonimizarAdjuntos(AId);
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
    raise EDatoInvalido.Create(SFaltaUuidLocal);

  ExigirLargoUuid(ADto.Cliente.UuidLocal.Value);
  for lDatos in ADto.Contactos do
    if lDatos.UuidLocal.HasValue then
      ExigirLargoUuid(lDatos.UuidLocal.Value);

  lId := ValidarUuidLocal(ADto.Cliente.UuidLocal);
  if lId > 0 then
    Exit(lId);

  if ADto.Contactos.Count = 0 then
    raise EDatoInvalido.Create(SRegistroSinContacto);

  if not VerificarImagen(ADto.Firma.FirmaBase64) then
    raise EDatoInvalido.Create(SFirmaVacia);

  lImagen := TNetEncoding.Base64.DecodeStringToBytes(ADto.Firma.FirmaBase64);

  lCliente := TClientes.Create;
  try
    TMapeo.Copiar(ADto.Cliente, lCliente);
    ExigirNoRepetido(lCliente, 0);
  finally
    lCliente.Free;
  end;

  lCliente := nil;
  lContacto := nil;
  lFirma := nil;
  try
    lCliente := TClientes.Create;
    TMapeo.Copiar(ADto.Cliente, lCliente);
    EstadoInicial(lCliente);
    if ADto.Firma.Accion = ACCION_OTORGADO then
    begin
      lCliente.ConsentimientoEstado := CONSENTIMIENTO_FIRMADO;
      lCliente.ConsentimientoVersion := ADto.Firma.VersionTexto;
      if ADto.Firma.Fecha.HasValue then
        lCliente.ConsentimientoFecha := ADto.Firma.Fecha.Value
      else
        lCliente.ConsentimientoFecha := Now;
    end;
    FijarDetalle(SDetalleRegistroCompletoMovil);
    fRepo.Insert(lCliente);
    lId := lCliente.ID.Value;

    for lDatos in ADto.Contactos do
    begin
      lContacto := TClienteContactos.Create;
      TMapeo.Copiar(lDatos, lContacto);
      EstadoInicial(lContacto);
      if (ADto.Firma.Accion = ACCION_OTORGADO) and
        ADto.Firma.ClienteContactoUuid.HasValue and lDatos.UuidLocal.HasValue
        and (ADto.Firma.ClienteContactoUuid.Value = lDatos.UuidLocal.Value) then
      begin
        lContacto.ConsentimientoEstado := CONSENTIMIENTO_FIRMADO;
        lContacto.ConsentimientoVersion := ADto.Firma.VersionTexto;
        lContacto.ConsentimientoFecha := lCliente.ConsentimientoFecha;
      end;
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

  if ADto.UuidLocal.HasValue then
    ExigirLargoUuid(ADto.UuidLocal.Value);
  ExigirClienteEditable(AId);

  if ADto.UuidLocal.HasValue and not ADto.UuidLocal.Value.Trim.IsEmpty then
  begin
    lContacto := fContactos.PorUuidLocal(ADto.UuidLocal.Value.Trim);
    if lContacto <> nil then
      try
        if lContacto.ClienteId <> AId then
          raise EConflictoDeEstado.Create('UUID_LOCAL_REPETIDO',
            SContactoUuidOtroCliente);
        Exit(lContacto.ID.Value);
      finally
        lContacto.Free;
      end;
  end;

  lContacto := TClienteContactos.Create;
  try
    TMapeo.Copiar(ADto, lContacto);
    EstadoInicial(lContacto);
    lContacto.ClienteId := AId;
    FijarDetalle(Format(SDetalleContactoNuevo, [AId]));
    fContactos.Insert(lContacto);
    Result := lContacto.ID.Value;
    if lContacto.Principal then
      DejarUnSoloPrincipal(AId, Result);
  finally
    lContacto.Free;
  end;
end;

procedure TClienteService.ActualizarContacto(const AId, AContactoId: Integer;
  const ADto: TContactoEdicionDTO);
var
  lContacto, lAntes: TClienteContactos;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if not ADto.ObjVersion.HasValue then
    raise EDatoInvalido.Create(Format(SFaltaVersion, [SRecursoContacto]));
  ExigirClienteEditable(AId);

  lContacto := TraerContacto(AId, AContactoId);
  lAntes := TClienteContactos.Create;
  try
    if lContacto.Anonimizado then
      raise EConflictoDeEstado.Create('CONTACTO_ANONIMIZADO',
        SContactoAnonimizado);
    if lContacto.ObjVersion <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create(SRecursoContacto, AContactoId);
    if (lContacto.ConsentimientoEstado = CONSENTIMIENTO_FIRMADO) and
      not SameText(Trim(ADto.Nombre), Trim(lContacto.Nombre)) then
      raise EConflictoDeEstado.Create('CONTACTO_FIRMADO',
        SContactoFirmadoNombre);

    CopiarEstado(lContacto, lAntes);
    TMapeo.Copiar(ADto, lContacto);
    CopiarEstado(lAntes, lContacto);
    lContacto.ClienteId := AId;
    FijarDetalle(Format(SDetalleEdicionContacto, [AContactoId]));
    try
      fContactos.Update(lContacto);
    except
      on EMVCActiveRecordVersionedItemNotFound do
        raise EVersionVencida.Create(SRecursoContacto, AContactoId);
    end;
    if lContacto.Principal then
      DejarUnSoloPrincipal(AId, AContactoId);
  finally
    lAntes.Free;
    lContacto.Free;
  end;
end;

procedure TClienteService.DejarUnSoloPrincipal(const AClienteId,
  AContactoId: Integer);
var
  lContactos: TObjectList<TClienteContactos>;
  lOtro: TClienteContactos;
begin
  lContactos := fContactos.ContactosDe(AClienteId);
  try
    for lOtro in lContactos do
      if lOtro.Principal and (lOtro.ID.ValueOrDefault <> AContactoId) then
      begin
        lOtro.Principal := False;
        FijarDetalle(Format(SDetallePrincipalContacto,
          [lOtro.ID.ValueOrDefault]));
        fContactos.Update(lOtro);
      end;
  finally
    lContactos.Free;
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
    if lContacto.Principal then
      raise EConflictoDeEstado.Create('CONTACTO_PRINCIPAL',
        SContactoPrincipalNoSeQuita);

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
  lEntidades: TObjectList<TConsentimientosDeCliente>;
begin
  lEntidades := fConsentimientos.HistorialDe(AId);
  try
    Result := TMapeo.AListaDto<TConsentimientosDeCliente,
      TConsentimientoDTO>(lEntidades);
  finally
    lEntidades.Free;
  end;
end;

function TClienteService.Otorgar(const AId: Integer;
  const ADto: TFirmaNuevaDTO): Integer;
var
  lCliente: TClientes;
  lContacto: TClienteContactos;
  lFirma: TClienteConsentimientoHistorial;
  lImagen: TBytes;
  lFecha: TDateTime;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  ExigirClienteEditable(AId);
  if ADto.VersionTexto.Trim.IsEmpty or ADto.FirmanteNombre.Trim.IsEmpty or
    ADto.FirmanteIdentificacion.Trim.IsEmpty then
    raise EDatoInvalido.Create(SFaltanDatosFirma);
  if not VerificarImagen(ADto.FirmaBase64) then
    raise EDatoInvalido.Create(SFirmaVacia);

  if ADto.Fecha.HasValue then
    lFecha := ADto.Fecha.Value
  else
    lFecha := Now;

  Result := fConsentimientos.FirmaRepetida(AId, lFecha,
    ADto.FirmanteNombre.Trim);
  if Result > 0 then
    Exit;

  lImagen := TNetEncoding.Base64.DecodeStringToBytes(ADto.FirmaBase64);
  lCliente := TraerVigente(AId);
  lContacto := nil;
  lFirma := nil;
  try
    if lCliente.ConsentimientoEstado = CONSENTIMIENTO_FIRMADO then
      raise EConflictoDeEstado.Create('CONSENTIMIENTO_YA_FIRMADO',
        SConsentimientoYaFirmado);

    FijarDetalle(Format(SDetalleFirmaConsentimiento,
      [ADto.FirmanteNombre.Trim]));
    lFirma := TClienteConsentimientoHistorial.Create;
    TMapeo.Copiar(ADto, lFirma);
    lFirma.ClienteId := AId;
    lFirma.Accion := ACCION_OTORGADO;
    lFirma.Fecha := lFecha;
    lFirma.FirmaImagen.WriteBuffer(lImagen, Length(lImagen));
    fConsentimientos.Insert(lFirma);
    Result := lFirma.ID.Value;

    lCliente.ConsentimientoEstado := CONSENTIMIENTO_FIRMADO;
    lCliente.ConsentimientoVersion := ADto.VersionTexto;
    lCliente.ConsentimientoFecha := lFecha;
    fRepo.Update(lCliente);

    if ADto.ClienteContactoUuid.HasValue and
      not ADto.ClienteContactoUuid.Value.Trim.IsEmpty then
    begin
      lContacto := fContactos.PorUuidLocal(ADto.ClienteContactoUuid.Value.Trim);
      if (lContacto <> nil) and (lContacto.ClienteId = AId) and
        not lContacto.Anonimizado then
      begin
        lContacto.ConsentimientoEstado := CONSENTIMIENTO_FIRMADO;
        lContacto.ConsentimientoVersion := ADto.VersionTexto;
        lContacto.ConsentimientoFecha := lFecha;
        fContactos.Update(lContacto);
      end;
    end;
  finally
    lContacto.Free;
    lFirma.Free;
    lCliente.Free;
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
    raise EDatoInvalido.Create(Format(SFaltaVersion, [SRecursoCliente]));

  lCliente := TraerVigente(AId);
  lFirma := nil;
  try
    if lCliente.ObjVersion <> ADto.ObjVersion.Value then
      raise EVersionVencida.Create(SRecursoCliente, AId);
    if lCliente.ConsentimientoEstado = CONSENTIMIENTO_REVOCADO then
      raise EConflictoDeEstado.Create('CONSENTIMIENTO_YA_REVOCADO',
        SConsentimientoYaRevocado);
    if lCliente.ConsentimientoEstado <> CONSENTIMIENTO_FIRMADO then
      raise EConflictoDeEstado.Create('CONSENTIMIENTO_NO_FIRMADO',
        SConsentimientoNoFirmado);

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
        raise EVersionVencida.Create(SRecursoCliente, AId);
    end;
  finally
    lFirma.Free;
    lCliente.Free;
  end;

end;

end.
