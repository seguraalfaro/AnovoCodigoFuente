unit Anovo.Services.Usuarios;

// Servicio de usuarios: cuentas, clave temporal y excepciones de permisos,
// con los controles sobre el administrador de la minuta 09 (tema 3).

interface

uses
  System.Generics.Collections,
  MVCFramework,
  Anovo.DTOs.Usuarios,
  Anovo.Entities.Usuarios,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Repositories.Intf.Permisos,
  Anovo.Services.Intf.Permisos,
  Anovo.Services.Intf.Usuarios,
  Anovo.Services.Clave;

type
  TUsuarioService = class(TInterfacedObject, IUsuarioService)
  private
    fUsuarios: IUsuarioRepository;
    fClaves: IUsuarioClaveRepository;
    fRoles: IRolRepository;
    fExcepciones: IUsuarioPermisoRepository;
    fCatalogo: IPermisoCatalogoRepository;
    fPermisos: IPermisoRepository;
    fClave: IClaveService;
    fCache: IPermisoCache;
    function TraerUsuario(const AId: Integer): TUsuarios;
    function TraerRol(const ARolId: Integer): TRoles;
    procedure ValidarDatos(const ADto: TUsuarioEdicionDTO;
      const AExcluirId: Integer);
    procedure ValidarClaveTemporal(const AClave: string);
    procedure GuardarClave(const AUsuarioId: Integer;
      const ANombre, AClave: string);
    procedure BorrarExcepciones(const AUsuario: TUsuarios);
    procedure GuardarEdicion(const AId: Integer;
      const ADto: TUsuarioEdicionDTO);
    procedure CambiarEstado(const AId: Integer; const AActivo: Boolean);
    procedure GuardarRestablecimiento(const AId: Integer; const AClave: string);
    procedure GuardarPedidoCambio(const AId: Integer);
    procedure AplicarExcepciones(const AId: Integer;
      const ADto: TCambiosExcepcionesDTO);
    procedure AplicarExcepcion(const AUsuario: TUsuarios; const ARol: TRoles;
      const ACambio: TCambioExcepcionDTO; const AMotivo: string);
  public
    [MVCInject]
    constructor Create(AUsuarios: IUsuarioRepository;
      AClaves: IUsuarioClaveRepository; ARoles: IRolRepository;
      AExcepciones: IUsuarioPermisoRepository;
      ACatalogo: IPermisoCatalogoRepository; APermisos: IPermisoRepository;
      AClave: IClaveService; ACache: IPermisoCache); reintroduce;
    function Buscar(const ATexto, AEstado: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TUsuarioDTO>;
    function Obtener(const AId: Integer): TUsuarioDTO;
    function Excepciones(const AId: Integer): TObjectList<TExcepcionDTO>;
    function Crear(const ADto: TUsuarioEdicionDTO): TUsuarioDTO;
    procedure Editar(const AId: Integer; const ADto: TUsuarioEdicionDTO);
    procedure Inactivar(const AId: Integer);
    procedure Activar(const AId: Integer);
    procedure RestablecerClave(const AId: Integer; const AClave: string);
    procedure PedirCambioClave(const AId: Integer);
    procedure CambiarExcepciones(const AId: Integer;
      const ADto: TCambiosExcepcionesDTO);
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Repository,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Textos,
  Anovo.Auditoria.Contexto,
  Anovo.Entities.Permisos,
  Anovo.Entities.Consultas,
  Anovo.Auth.EstadoUsuarios;

const
  LARGO_MINIMO_CLAVE_TEMPORAL = 12;

constructor TUsuarioService.Create(AUsuarios: IUsuarioRepository;
  AClaves: IUsuarioClaveRepository; ARoles: IRolRepository;
  AExcepciones: IUsuarioPermisoRepository;
  ACatalogo: IPermisoCatalogoRepository; APermisos: IPermisoRepository;
  AClave: IClaveService; ACache: IPermisoCache);
begin
  inherited Create;
  fUsuarios := AUsuarios;
  fClaves := AClaves;
  fRoles := ARoles;
  fExcepciones := AExcepciones;
  fCatalogo := ACatalogo;
  fPermisos := APermisos;
  fClave := AClave;
  fCache := ACache;
end;

function TUsuarioService.TraerUsuario(const AId: Integer): TUsuarios;
begin
  Result := fUsuarios.GetByPK(AId, False);
  if (Result = nil) or (AId = fUsuarios.IdSistema) then
  begin
    Result.Free;
    raise ERecursoNoEncontrado.Create(SRecursoUsuario, AId);
  end;
end;

function TUsuarioService.TraerRol(const ARolId: Integer): TRoles;
begin
  Result := fRoles.GetByPK(ARolId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoRol, ARolId);
end;

procedure TUsuarioService.ValidarDatos(const ADto: TUsuarioEdicionDTO;
  const AExcluirId: Integer);
var
  lCorreo: string;
  lArroba: Integer;
begin
  if ADto.Nombre.Trim.IsEmpty then
    raise EDatoInvalido.Create(SFaltaNombreUsuario);
  lCorreo := ADto.Correo.Trim.ToLower;
  lArroba := lCorreo.IndexOf('@');
  if (lArroba < 1) or (lCorreo.IndexOf('.', lArroba) < 0) or
    lCorreo.Contains(' ') then
    raise EDatoInvalido.Create(SCorreoInvalido);
  if fUsuarios.ExisteCorreo(lCorreo, AExcluirId) then
    raise EDatoInvalido.Create(Format(SCorreoDuplicado, [lCorreo]));
end;

procedure TUsuarioService.ValidarClaveTemporal(const AClave: string);
begin
  if (AClave.Length < LARGO_MINIMO_CLAVE_TEMPORAL) or AClave.Contains(' ') then
    raise EDatoInvalido.Create(Format(SClaveTemporalInvalida,
      [LARGO_MINIMO_CLAVE_TEMPORAL]));
end;

procedure TUsuarioService.GuardarClave(const AUsuarioId: Integer;
  const ANombre, AClave: string);
var
  lVigente, lNueva: TUsuariosClaves;
begin

  lVigente := fClaves.ClaveActivaDe(AUsuarioId);
  if lVigente <> nil then
    try
      FijarDetalle(Format(SDetalleClaveAnterior, [ANombre]));
      lVigente.Activo := False;
      fClaves.Update(lVigente);
    finally
      lVigente.Free;
    end;

  lNueva := TUsuariosClaves.Create;
  try
    lNueva.UsuarioId := AUsuarioId;
    lNueva.ClaveHash := fClave.Hashear(AClave);
    lNueva.Activo := True;
    lNueva.FechaCambio := Now;
    FijarDetalle(Format(SDetalleClaveRestablecida, [ANombre]));
    fClaves.Insert(lNueva);
  finally
    lNueva.Free;
  end;
end;

procedure TUsuarioService.BorrarExcepciones(const AUsuario: TUsuarios);
var
  lFilas: TObjectList<TUsuariosPermisos>;
  lFila: TUsuariosPermisos;
begin
  lFilas := fExcepciones.DeUsuario(AUsuario.ID.Value);
  try
    if lFilas.Count = 0 then
      Exit;
    FijarDetalle(Format(SDetalleExcepcionesPorCambioRol, [AUsuario.Nombre]));
    for lFila in lFilas do
      fExcepciones.Delete(lFila);
  finally
    lFilas.Free;
  end;
end;

function TUsuarioService.Buscar(const ATexto, AEstado: string;
  const APagina, APorPagina: Integer; out ATotal: Int64)
  : TObjectList<TUsuarioDTO>;
var
  lFilas: TObjectList<TUsuariosBuscados>;
begin
  if not (AEstado.IsEmpty or SameText(AEstado, ESTADO_USUARIOS_ACTIVOS) or
    SameText(AEstado, ESTADO_USUARIOS_INACTIVOS) or
    SameText(AEstado, ESTADO_USUARIOS_CLAVE_PENDIENTE) or
    SameText(AEstado, ESTADO_USUARIOS_CON_ADICIONALES)) then
    raise EDatoInvalido.Create(Format(SEstadoUsuarioInvalido, [AEstado]));

  ATotal := fUsuarios.ContarBusqueda(ATexto, AEstado);
  lFilas := fUsuarios.Buscar(ATexto, AEstado, APagina, APorPagina);
  try
    Result := TMapeo.AListaDto<TUsuariosBuscados, TUsuarioDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TUsuarioService.Obtener(const AId: Integer): TUsuarioDTO;
var
  lFila: TUsuariosBuscados;
begin
  lFila := fUsuarios.Vista(AId);
  if lFila = nil then
    raise ERecursoNoEncontrado.Create(SRecursoUsuario, AId);
  try
    Result := TMapeo.ADto<TUsuarioDTO>(lFila);
  finally
    lFila.Free;
  end;
end;

function TUsuarioService.Excepciones(const AId: Integer)
  : TObjectList<TExcepcionDTO>;
var
  lFilas: TObjectList<TExcepcionesDePermisos>;
begin
  TraerUsuario(AId).Free;
  lFilas := fExcepciones.ExcepcionesDe(AId);
  try
    Result := TMapeo.AListaDto<TExcepcionesDePermisos, TExcepcionDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TUsuarioService.Crear(const ADto: TUsuarioEdicionDTO): TUsuarioDTO;
var
  lRol: TRoles;
  lUsuario: TUsuarios;
  lId: Integer;
begin
  ValidarDatos(ADto, 0);
  ValidarClaveTemporal(ADto.ClaveTemporal);

  var
  lTx := TMVCRepository.UseTransactionContext;

  lRol := TraerRol(ADto.RolId);
  try
    lUsuario := TUsuarios.Create;
    try
      lUsuario.Correo := ADto.Correo.Trim.ToLower;
      lUsuario.Nombre := ADto.Nombre.Trim;
      lUsuario.RolId := lRol.ID;
      lUsuario.Ambito := lRol.Ambito;
      lUsuario.Activo := True;
      lUsuario.DebeCambiarClave := True;
      FijarDetalle(Format(SDetalleUsuarioCreado, [lUsuario.Nombre,
        lRol.Nombre]));
      fUsuarios.Insert(lUsuario);
      lId := lUsuario.ID.Value;
      GuardarClave(lId, lUsuario.Nombre, ADto.ClaveTemporal);
    finally
      lUsuario.Free;
    end;
  finally
    lRol.Free;
  end;

  Result := Obtener(lId);
end;

procedure TUsuarioService.GuardarEdicion(const AId: Integer;
  const ADto: TUsuarioEdicionDTO);
var
  lUsuario: TUsuarios;
  lAnterior, lNuevo: TRoles;
begin
  ValidarDatos(ADto, AId);

  var
  lTx := TMVCRepository.UseTransactionContext;

  lUsuario := TraerUsuario(AId);
  try
    if lUsuario.RolId <> ADto.RolId then
    begin
      if AId = UsuarioActual then
        raise ESinPermiso.Create(SAccionCambiarPropioRol);
      lNuevo := TraerRol(ADto.RolId);
      try
        lAnterior := TraerRol(lUsuario.RolId);
        try
          BorrarExcepciones(lUsuario);
          FijarDetalle(Format(SDetalleUsuarioCambioRol, [lUsuario.Nombre,
            lAnterior.Nombre, lNuevo.Nombre]));
        finally
          lAnterior.Free;
        end;
        lUsuario.RolId := lNuevo.ID;
        lUsuario.Ambito := lNuevo.Ambito;
      finally
        lNuevo.Free;
      end;
    end
    else
      FijarDetalle(Format(SDetalleUsuarioEditado, [lUsuario.Nombre]));

    lUsuario.Correo := ADto.Correo.Trim.ToLower;
    lUsuario.Nombre := ADto.Nombre.Trim;
    fUsuarios.Update(lUsuario);
  finally
    lUsuario.Free;
  end;
end;

procedure TUsuarioService.Editar(const AId: Integer;
  const ADto: TUsuarioEdicionDTO);
begin
  GuardarEdicion(AId, ADto);
  fCache.Invalidar;
  TEstadoUsuarios.Olvidar(AId);
end;

procedure TUsuarioService.CambiarEstado(const AId: Integer;
  const AActivo: Boolean);
var
  lUsuario: TUsuarios;
begin
  if not AActivo and (AId = UsuarioActual) then
    raise ESinPermiso.Create(SAccionInactivarPropiaCuenta);

  var
  lTx := TMVCRepository.UseTransactionContext;

  lUsuario := TraerUsuario(AId);
  try
    if lUsuario.Activo.ValueOrDefault = AActivo then
      Exit;
    lUsuario.Activo := AActivo;
    if AActivo then
      FijarDetalle(Format(SDetalleUsuarioActivado, [lUsuario.Nombre]))
    else
      FijarDetalle(Format(SDetalleUsuarioInactivado, [lUsuario.Nombre]));
    fUsuarios.Update(lUsuario);
  finally
    lUsuario.Free;
  end;
end;

procedure TUsuarioService.Inactivar(const AId: Integer);
begin
  CambiarEstado(AId, False);
  TEstadoUsuarios.Olvidar(AId);
end;

procedure TUsuarioService.Activar(const AId: Integer);
begin
  CambiarEstado(AId, True);
  TEstadoUsuarios.Olvidar(AId);
end;

procedure TUsuarioService.RestablecerClave(const AId: Integer;
  const AClave: string);
begin
  GuardarRestablecimiento(AId, AClave);
  TEstadoUsuarios.Olvidar(AId);
end;

procedure TUsuarioService.PedirCambioClave(const AId: Integer);
begin
  GuardarPedidoCambio(AId);
  TEstadoUsuarios.Olvidar(AId);
end;

procedure TUsuarioService.GuardarRestablecimiento(const AId: Integer;
  const AClave: string);
var
  lUsuario: TUsuarios;
begin
  if AId = UsuarioActual then
    raise ESinPermiso.Create(SAccionRestablecerPropiaClave);
  ValidarClaveTemporal(AClave);

  var
  lTx := TMVCRepository.UseTransactionContext;

  lUsuario := TraerUsuario(AId);
  try
    lUsuario.DebeCambiarClave := True;
    FijarDetalle(Format(SDetalleClaveRestablecida, [lUsuario.Nombre]));
    fUsuarios.Update(lUsuario);
    GuardarClave(AId, lUsuario.Nombre, AClave);
  finally
    lUsuario.Free;
  end;
end;

procedure TUsuarioService.GuardarPedidoCambio(const AId: Integer);
var
  lUsuario: TUsuarios;
begin
  if AId = UsuarioActual then
    raise ESinPermiso.Create(SAccionPedirCambioPropiaClave);

  var
  lTx := TMVCRepository.UseTransactionContext;

  lUsuario := TraerUsuario(AId);
  try
    if lUsuario.DebeCambiarClave then
      Exit;
    lUsuario.DebeCambiarClave := True;
    FijarDetalle(Format(SDetalleCambioClavePedido, [lUsuario.Nombre]));
    fUsuarios.Update(lUsuario);
  finally
    lUsuario.Free;
  end;
end;

procedure TUsuarioService.AplicarExcepcion(const AUsuario: TUsuarios;
  const ARol: TRoles; const ACambio: TCambioExcepcionDTO;
  const AMotivo: string);
var
  lPermiso: TPermisos;
  lActual, lNueva: TUsuariosPermisos;
  lTipo: string;
  lRolLoTiene: Boolean;
begin
  lTipo := ACambio.Tipo.Trim.ToLower;
  if not (lTipo.IsEmpty or (lTipo = TIPO_OTORGADO) or
    (lTipo = TIPO_QUITADO)) then
    raise EDatoInvalido.Create(Format(STipoExcepcionInvalido, [ACambio.Tipo]));

  lPermiso := fCatalogo.GetByPK(ACambio.PermisoId, False);
  if lPermiso = nil then
    raise ERecursoNoEncontrado.Create(SRecursoPermiso, ACambio.PermisoId);
  try
    if lPermiso.Ambito <> AUsuario.Ambito then
      raise EDatoInvalido.Create(Format(SPermisoFueraDeAmbito,
        [lPermiso.Nombre, ARol.Nombre]));

    lRolLoTiene := fPermisos.Exists([ARol.ID, lPermiso.ID]);
    if (lTipo = TIPO_OTORGADO) and lRolLoTiene then
      raise EDatoInvalido.Create(Format(SExcepcionSinEfecto,
        [ARol.Nombre, SRolYaTiene, lPermiso.Nombre]));
    if (lTipo = TIPO_QUITADO) and not lRolLoTiene then
      raise EDatoInvalido.Create(Format(SExcepcionSinEfecto,
        [ARol.Nombre, SRolNoTiene, lPermiso.Nombre]));

    lActual := fExcepciones.Una(AUsuario.ID.Value, lPermiso.ID);
    try
      if (lActual <> nil) and (lActual.Tipo = lTipo) then
        Exit;
      if lActual <> nil then
      begin
        FijarDetalle(Format(SDetalleBorraExcepcionUsuario,
          [lPermiso.Nombre, AUsuario.Nombre, AMotivo]));
        fExcepciones.Delete(lActual);
      end;
    finally
      lActual.Free;
    end;

    if lTipo.IsEmpty then
      Exit;

    lNueva := TUsuariosPermisos.Create;
    try
      lNueva.UsuarioId := AUsuario.ID.Value;
      lNueva.PermisoId := lPermiso.ID;
      lNueva.Ambito := AUsuario.Ambito;
      lNueva.Tipo := lTipo;
      lNueva.Motivo := AMotivo;
      if lTipo = TIPO_OTORGADO then
        FijarDetalle(Format(SDetalleOtorgaPermisoUsuario,
          [lPermiso.Nombre, AUsuario.Nombre, AMotivo]))
      else
        FijarDetalle(Format(SDetalleQuitaPermisoUsuario,
          [lPermiso.Nombre, AUsuario.Nombre, AMotivo]));
      fExcepciones.Insert(lNueva);
    finally
      lNueva.Free;
    end;
  finally
    lPermiso.Free;
  end;
end;

procedure TUsuarioService.AplicarExcepciones(const AId: Integer;
  const ADto: TCambiosExcepcionesDTO);
var
  lUsuario: TUsuarios;
  lRol: TRoles;
  lCambio: TCambioExcepcionDTO;
begin
  if ADto.Motivo.Trim.IsEmpty then
    raise EDatoInvalido.Create(SMotivoFalta);
  if ADto.Cambios.Count = 0 then
    raise EDatoInvalido.Create(SSinCambiosPermisos);
  if AId = UsuarioActual then
    raise ESinPermiso.Create(SAccionPermisosPropios);

  var
  lTx := TMVCRepository.UseTransactionContext;

  lUsuario := TraerUsuario(AId);
  try
    lRol := TraerRol(lUsuario.RolId);
    try
      for lCambio in ADto.Cambios do
        AplicarExcepcion(lUsuario, lRol, lCambio, ADto.Motivo.Trim);
    finally
      lRol.Free;
    end;
  finally
    lUsuario.Free;
  end;
end;

procedure TUsuarioService.CambiarExcepciones(const AId: Integer;
  const ADto: TCambiosExcepcionesDTO);
begin
  AplicarExcepciones(AId, ADto);
  fCache.Invalidar;
end;

end.
