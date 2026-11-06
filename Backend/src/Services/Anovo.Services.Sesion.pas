unit Anovo.Services.Sesion;

// Servicio de la cuenta propia: autenticacion, datos, cambio de clave
// con historial en USUARIOS_CLAVES y versiones.

interface

uses
  MVCFramework,
  Anovo.DTOs.Sesion,
  Anovo.Entities.Usuarios,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Repositories.Intf.Empresa,
  Anovo.Repositories.Intf.Clientes,
  Anovo.Services.Intf.Sesion,
  Anovo.Services.Intf.Permisos,
  Anovo.Services.Clave;

type
  TSesionService = class(TInterfacedObject, ISesionService)
  private
    fUsuarios: IUsuarioRepository;
    fClaves: IUsuarioClaveRepository;
    fRoles: IRolRepository;
    fClave: IClaveService;
    fExcepciones: IUsuarioPermisoRepository;
    fEmpresa: IEmpresaRepository;
    fTextos: IConsentimientoTextoRepository;
    fPermisos: IPermisoService;
    procedure ValidarClaveNueva(const AClave: string);
    procedure ExigirClaveNoUsada(const AUsuarioId: Integer;
      const AClave: string);
    procedure GuardarCambioClave(const AUsuarioId: Integer;
      const ADto: TCambioClaveDTO);
    function DatosDe(const AUsuario: TUsuarios): TAutenticacion;
  public
    [MVCInject]
    constructor Create(AUsuarios: IUsuarioRepository;
      AClaves: IUsuarioClaveRepository; ARoles: IRolRepository;
      AClave: IClaveService; AExcepciones: IUsuarioPermisoRepository;
      AEmpresa: IEmpresaRepository; ATextos: IConsentimientoTextoRepository;
      APermisos: IPermisoService); reintroduce;
    function Sesion(const AUsuarioId: Integer; const ARol: string): TSesionDTO;
    function Cuenta(const AUsuarioId: Integer; const ARol: string): TCuentaDTO;
    procedure CambiarClave(const AUsuarioId: Integer;
      const ADto: TCambioClaveDTO);
    function Versiones: TVersionDTO;
    function Autenticar(const ACorreo, AClave: string): TAutenticacion;
    function SesionDe(const AUsuarioId: Integer): TAutenticacion;
  end;

implementation

uses
  System.SysUtils,
  System.Character,
  System.Generics.Collections,
  Anovo.Repositories.Intf.Permisos,
  Anovo.Services.Consentimiento,
  Anovo.Auth.EstadoUsuarios,
  MVCFramework.Commons,
  MVCFramework.Repository,
  MVCFramework.Logger,
  Anovo.Auditoria.Contexto,
  Anovo.Errors,
  Anovo.Textos;

const
  CLAVE_MINIMA = 10;
  CLAVES_SIN_REPETIR = 5;

constructor TSesionService.Create(AUsuarios: IUsuarioRepository;
  AClaves: IUsuarioClaveRepository; ARoles: IRolRepository;
  AClave: IClaveService; AExcepciones: IUsuarioPermisoRepository;
  AEmpresa: IEmpresaRepository; ATextos: IConsentimientoTextoRepository;
  APermisos: IPermisoService);
begin
  inherited Create;
  fTextos := ATextos;
  fPermisos := APermisos;
  fUsuarios := AUsuarios;
  fClaves := AClaves;
  fRoles := ARoles;
  fClave := AClave;
  fExcepciones := AExcepciones;
  fEmpresa := AEmpresa;
end;

function TSesionService.Autenticar(const ACorreo, AClave: string)
  : TAutenticacion;
var
  lUsuario: TUsuarios;
  lFila: TUsuariosClaves;
begin
  Result := Default(TAutenticacion);

  lUsuario := fUsuarios.PorCorreo(ACorreo.Trim.ToLower);
  if lUsuario = nil then
  begin
    fClave.Hashear(AClave);
    LogW('Login fallido: correo no registrado');
    Exit;
  end;

  try
    lFila := fClaves.ClaveActivaDe(lUsuario.ID.Value);
    if lFila = nil then
    begin
      fClave.Hashear(AClave);
      LogW(Format('Login fallido: usuario %d sin clave activa',
        [lUsuario.ID.Value]));
      Exit;
    end;

    try
      if not fClave.Verificar(AClave, lFila.ClaveHash) then
      begin
        LogW(Format('Login fallido: clave incorrecta, usuario %d',
          [lUsuario.ID.Value]));
        Exit;
      end;

      if not lUsuario.Activo.ValueOrDefault then
      begin
        Result.CuentaInactiva := True;
        LogW(Format('Login rechazado: usuario %d inactivo', [lUsuario.ID.Value]));
        Exit;
      end;

      if fClave.RequiereRehash(lFila.ClaveHash) then
      begin
        FijarUsuario(lUsuario.ID.Value);
        try
          FijarDetalle(Format(SDetalleClaveRecifrada, [lUsuario.ID.Value]));
          lFila.ClaveHash := fClave.Hashear(AClave);
          fClaves.Update(lFila);
        finally
          LimpiarUsuario;
        end;
        LogI(Format('Clave rehasheada al costo vigente, usuario %d',
          [lUsuario.ID.Value]));
      end;
    finally
      lFila.Free;
    end;

    Result := DatosDe(lUsuario);
    if Result.Valido then
      LogI(Format('Login correcto, usuario %d', [lUsuario.ID.Value]));
  finally
    lUsuario.Free;
  end;
end;

function TSesionService.DatosDe(const AUsuario: TUsuarios): TAutenticacion;
var
  lRol: TRoles;
begin
  Result := Default(TAutenticacion);
  lRol := fRoles.GetByPK(AUsuario.RolID, False);
  if lRol = nil then
  begin
    LogE(Format('Usuario %d con ROL_ID %d inexistente', [AUsuario.ID.Value,
      AUsuario.RolID]));
    Exit;
  end;

  try
    Result.Rol := lRol.Codigo;
  finally
    lRol.Free;
  end;

  if AUsuario.DebeCambiarClave then
    Result.Rol := ROL_CLAVE_VENCIDA;
  Result.UsuarioId := AUsuario.ID.Value;
  Result.Correo := AUsuario.Correo;
  Result.Nombre := AUsuario.Nombre;
  Result.DebeCambiarClave := AUsuario.DebeCambiarClave;
  Result.Valido := True;
end;

function TSesionService.SesionDe(const AUsuarioId: Integer): TAutenticacion;
var
  lUsuario: TUsuarios;
begin
  Result := Default(TAutenticacion);
  lUsuario := fUsuarios.GetByPK(AUsuarioId, False);
  if lUsuario = nil then
    Exit;
  try
    if lUsuario.Activo.ValueOrDefault then
      Result := DatosDe(lUsuario);
  finally
    lUsuario.Free;
  end;
end;

function TSesionService.Sesion(const AUsuarioId: Integer;
  const ARol: string): TSesionDTO;
begin
  Result := TSesionDTO.Create;
  Result.Rol := ARol;
  Result.Permisos := fPermisos.PermisosDe(AUsuarioId, ARol);
end;

function TSesionService.Cuenta(const AUsuarioId: Integer;
  const ARol: string): TCuentaDTO;
var
  lUsuario: TUsuarios;
  lFila: TUsuariosClaves;
  lExcepciones: TObjectList<TUsuariosPermisos>;
  lExcepcion: TUsuariosPermisos;
begin
  lUsuario := fUsuarios.GetByPK(AUsuarioId, False);
  if lUsuario = nil then
    raise ERecursoNoEncontrado.Create(SRecursoUsuario, AUsuarioId);
  try
    Result := TCuentaDTO.Create;
    Result.Nombre := lUsuario.Nombre;
    Result.Correo := lUsuario.Correo;
    Result.Rol := ARol;
  finally
    lUsuario.Free;
  end;

  try
    lFila := fClaves.ClaveActivaDe(AUsuarioId);
    if lFila <> nil then
      try
        Result.ClaveCambiada := lFila.FechaCambio;
      finally
        lFila.Free;
      end;

    lExcepciones := fExcepciones.DeUsuario(AUsuarioId);
    try
      for lExcepcion in lExcepciones do
        if lExcepcion.Tipo = TIPO_OTORGADO then
          Result.PermisosAdicionales := Result.PermisosAdicionales + 1
        else
          Result.PermisosQuitados := Result.PermisosQuitados + 1;
    finally
      lExcepciones.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TSesionService.ValidarClaveNueva(const AClave: string);
var
  lCaracter: Char;
  lLetra, lNumero: Boolean;
begin
  if AClave.Length < CLAVE_MINIMA then
    raise EDatoInvalido.Create(Format(SClaveCorta, [CLAVE_MINIMA]));

  lLetra := False;
  lNumero := False;
  for lCaracter in AClave do
  begin
    lLetra := lLetra or lCaracter.IsLetter;
    lNumero := lNumero or lCaracter.IsDigit;
  end;
  if not (lLetra and lNumero) then
    raise EDatoInvalido.Create(SClaveSinLetrasONumeros);
end;

procedure TSesionService.CambiarClave(const AUsuarioId: Integer;
  const ADto: TCambioClaveDTO);
begin
  GuardarCambioClave(AUsuarioId, ADto);
  TEstadoUsuarios.Olvidar(AUsuarioId);
end;

procedure TSesionService.ExigirClaveNoUsada(const AUsuarioId: Integer;
  const AClave: string);
var
  lClaves: TObjectList<TUsuariosClaves>;
  lAnterior: TUsuariosClaves;
begin
  lClaves := fClaves.ClavesRecientesDe(AUsuarioId, CLAVES_SIN_REPETIR);
  try
    for lAnterior in lClaves do
      if fClave.Verificar(AClave, lAnterior.ClaveHash) then
        raise EDatoInvalido.Create(Format(SClaveYaUsada, [CLAVES_SIN_REPETIR]));
  finally
    lClaves.Free;
  end;
end;

procedure TSesionService.GuardarCambioClave(const AUsuarioId: Integer;
  const ADto: TCambioClaveDTO);
var
  lUsuario: TUsuarios;
  lVigente: TUsuariosClaves;
  lNueva: TUsuariosClaves;
begin
  if ADto.ClaveActual.IsEmpty then
    raise EDatoInvalido.Create(SFaltaClaveActual);
  ValidarClaveNueva(ADto.ClaveNueva);

  var
  lTx := TMVCRepository.UseTransactionContext;

  lUsuario := fUsuarios.GetByPK(AUsuarioId, False);
  if lUsuario = nil then
    raise ERecursoNoEncontrado.Create(SRecursoUsuario, AUsuarioId);
  try
    lVigente := fClaves.ClaveActivaDe(AUsuarioId);
    try
      if (lVigente = nil) or
        not fClave.Verificar(ADto.ClaveActual, lVigente.ClaveHash) then
        raise EDatoInvalido.Create(SClaveActualIncorrecta);

      if fClave.Verificar(ADto.ClaveNueva, lVigente.ClaveHash) then
        raise EDatoInvalido.Create(SClaveIgualALaActual);

      ExigirClaveNoUsada(AUsuarioId, ADto.ClaveNueva);

      FijarDetalle(Format(SDetalleCambioClavePropio, [AUsuarioId]));
      lVigente.Activo := False;
      fClaves.Update(lVigente);
    finally
      lVigente.Free;
    end;

    lNueva := TUsuariosClaves.Create;
    try
      lNueva.UsuarioId := AUsuarioId;
      lNueva.ClaveHash := fClave.Hashear(ADto.ClaveNueva);
      lNueva.Activo := True;
      lNueva.FechaCambio := Now;
      fClaves.Insert(lNueva);
    finally
      lNueva.Free;
    end;

    if lUsuario.DebeCambiarClave then
    begin
      lUsuario.DebeCambiarClave := False;
      fUsuarios.Update(lUsuario);
    end;
  finally
    lUsuario.Free;
  end;
end;

function TSesionService.Versiones: TVersionDTO;
var
  lMayor, lMenor, lCompilacion: Cardinal;
begin
  Result := TVersionDTO.Create;
  if GetProductVersion(ParamStr(0), lMayor, lMenor, lCompilacion) then
    Result.Servidor := Format('%d.%d.%d', [lMayor, lMenor, lCompilacion]);
  Result.Movil := dotEnv.Env('anovo.movil.version', '');
  Result.AvisoPrivacidad := VersionAvisoVigente(fTextos);
  Result.BaseDatos := Format(SVersionBaseDatos, [fEmpresa.VersionEsquema]);
end;

end.
