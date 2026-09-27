unit Anovo.Services.Sesion;

// Servicio de la cuenta propia: datos, cambio de clave con
// historial en USUARIOS_CLAVES y versiones.

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
    fClave: IClaveService;
    procedure ValidarClaveNueva(const AClave: string);
  public
    [MVCInject]
    constructor Create(AUsuarios: IUsuarioRepository;
      AClaves: IUsuarioClaveRepository; AClave: IClaveService); reintroduce;
    function Cuenta(const AUsuarioId: Integer; const ARol: string): TCuentaDTO;
    procedure CambiarClave(const AUsuarioId: Integer;
      const ADto: TCambioClaveDTO);
    function Versiones: TVersionDTO;
  end;

implementation

uses
  System.SysUtils,
  System.Character,
  MVCFramework.Commons,
  MVCFramework.Repository,
  Anovo.Entities.Usuarios,
  Anovo.Errors,
  Anovo.Textos;

const
  CLAVE_MINIMA = 10;

constructor TSesionService.Create(AUsuarios: IUsuarioRepository;
  AClaves: IUsuarioClaveRepository; AClave: IClaveService);
begin
  inherited Create;
  fUsuarios := AUsuarios;
  fClaves := AClaves;
  fClave := AClave;
end;

function TSesionService.Cuenta(const AUsuarioId: Integer;
  const ARol: string): TCuentaDTO;
var
  lUsuario: TUsuarios;
  lFila: TUsuariosClaves;
begin
  lUsuario := fUsuarios.GetByPK(AUsuarioId, False);
  if lUsuario = nil then
    raise ERecursoNoEncontrado.Create('el usuario', AUsuarioId);
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
    raise ERecursoNoEncontrado.Create('el usuario', AUsuarioId);
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
