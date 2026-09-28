unit Anovo.Services.Sesion;

// Servicio de la cuenta propia: autenticacion, datos, cambio de clave
// con historial en USUARIOS_CLAVES y versiones.

interface

uses
  MVCFramework,
  Anovo.DTOs.Sesion,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Services.Intf.Sesion,
  Anovo.Services.Clave;

type
  TSesionService = class(TInterfacedObject, ISesionService)
  private
    fUsuarios: IUsuarioRepository;
    fClaves: IUsuarioClaveRepository;
    fRoles: IRolRepository;
    fClave: IClaveService;
    procedure ValidarClaveNueva(const AClave: string);
  public
    [MVCInject]
    constructor Create(AUsuarios: IUsuarioRepository;
      AClaves: IUsuarioClaveRepository; ARoles: IRolRepository;
      AClave: IClaveService); reintroduce;
    function Cuenta(const AUsuarioId: Integer; const ARol: string): TCuentaDTO;
    procedure CambiarClave(const AUsuarioId: Integer;
      const ADto: TCambioClaveDTO);
    function Versiones: TVersionDTO;
    function Autenticar(const ACorreo, AClave: string): TAutenticacion;
  end;

implementation

uses
  System.SysUtils,
  System.Character,
  MVCFramework.Commons,
  MVCFramework.Repository,
  MVCFramework.Logger,
  Anovo.Auditoria.Contexto,
  Anovo.Entities.Usuarios,
  Anovo.Errors,
  Anovo.Textos;

const
  CLAVE_MINIMA = 10;

constructor TSesionService.Create(AUsuarios: IUsuarioRepository;
  AClaves: IUsuarioClaveRepository; ARoles: IRolRepository;
  AClave: IClaveService);
begin
  inherited Create;
  fUsuarios := AUsuarios;
  fClaves := AClaves;
  fRoles := ARoles;
  fClave := AClave;
end;

function TSesionService.Autenticar(const ACorreo, AClave: string)
  : TAutenticacion;
var
  lUsuario: TUsuarios;
  lFila: TUsuariosClaves;
  lRol: TRoles;
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
    if not lUsuario.Activo.ValueOrDefault then
    begin
      fClave.Hashear(AClave);
      LogW(Format('Login fallido: usuario %d inactivo', [lUsuario.ID.Value]));
      Exit;
    end;

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

      if fClave.RequiereRehash(lFila.ClaveHash) then
      begin
        FijarUsuario(lUsuario.ID.Value);
        try
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

    lRol := fRoles.GetByPK(lUsuario.RolID, False);
    if lRol = nil then
    begin
      LogE(Format('Usuario %d con ROL_ID %d inexistente', [lUsuario.ID.Value,
        lUsuario.RolID]));
      Exit;
    end;

    try
      Result.Rol := lRol.Codigo;
    finally
      lRol.Free;
    end;

    if lUsuario.DebeCambiarClave then
      Result.Rol := ROL_CLAVE_VENCIDA;
    Result.UsuarioId := lUsuario.ID.Value;
    Result.Nombre := lUsuario.Nombre;
    Result.DebeCambiarClave := lUsuario.DebeCambiarClave;
    Result.Valido := True;
    LogI(Format('Login correcto, usuario %d', [lUsuario.ID.Value]));
  finally
    lUsuario.Free;
  end;
end;

function TSesionService.Cuenta(const AUsuarioId: Integer;
  const ARol: string): TCuentaDTO;
var
  lUsuario: TUsuarios;
  lFila: TUsuariosClaves;
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

  lFila := fClaves.ClaveActivaDe(AUsuarioId);
  if lFila <> nil then
    try
      Result.ClaveCambiada := lFila.FechaCambio;
    finally
      lFila.Free;
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
  Result.AvisoPrivacidad := dotEnv.Env('anovo.aviso_privacidad.version', '1.1');
end;

end.
