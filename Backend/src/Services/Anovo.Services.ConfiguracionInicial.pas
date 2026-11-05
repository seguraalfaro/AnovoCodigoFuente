unit Anovo.Services.ConfiguracionInicial;

// Primer arranque: registra el primer administrador y la razon social de la
// empresa, con el usuario del sistema para la auditoria.

interface

type
  TDatosIniciales = record
    Nombre: string;
    Correo: string;
    Clave: string;
    RazonSocial: string;
    CedulaJuridica: string;
  end;

function FaltaConfigurar: Boolean;
procedure Configurar(const ADatos: TDatosIniciales);

implementation

uses
  System.SysUtils,
  MVCFramework.ActiveRecord,
  MVCFramework.Commons,
  MVCFramework.Logger,
  Anovo.Auditoria.Contexto,
  Anovo.Errors,
  Anovo.Textos,
  Anovo.DTOs.Empresa,
  Anovo.DTOs.Usuarios,
  Anovo.Entities.Usuarios,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Repositories.Usuarios,
  Anovo.Repositories.Permisos,
  Anovo.Repositories.Empresa,
  Anovo.Repositories.Catalogos,
  Anovo.Services.Intf.Empresa,
  Anovo.Services.Empresa,
  Anovo.Services.Intf.Usuarios,
  Anovo.Services.Usuarios,
  Anovo.Services.Clave,
  Anovo.Services.Permisos;

const
  ROL_ADMINISTRADOR = 'admin';

procedure Conectar;
begin
  ActiveRecordConnectionsRegistry.AddDefaultConnection
    (dotEnv.Env('firedac.connection_definition_name', 'AnovoDef'));
end;

procedure Desconectar;
begin
  ActiveRecordConnectionsRegistry.RemoveDefaultConnection;
end;

function FaltaConfigurar: Boolean;
var
  lUsuarios: IUsuarioRepository;
begin
  Conectar;
  try
    lUsuarios := TUsuarioRepository.Create;
    Result := not lUsuarios.HayAdministradorActivo;
    lUsuarios := nil;
  finally
    Desconectar;
  end;
end;

procedure GuardarEmpresa(const ADatos: TDatosIniciales);
var
  lServicio: IEmpresaService;
  lDto: TEmpresaDTO;
begin
  lServicio := TEmpresaService.Create(TEmpresaRepository.Create,
    TFormaPagoRepository.Create);
  lDto := lServicio.Obtener;
  try
    lDto.RazonSocial := ADatos.RazonSocial;
    lDto.CedulaJuridica := ADatos.CedulaJuridica;
    lServicio.Actualizar(lDto);
  finally
    lDto.Free;
  end;
end;

procedure CrearAdministrador(const ADatos: TDatosIniciales);
var
  lRoles: IRolRepository;
  lRol: TRoles;
  lServicio: IUsuarioService;
  lDto: TUsuarioEdicionDTO;
  lCreado: TUsuarioDTO;
begin
  lRoles := TRolRepository.Create;
  lDto := TUsuarioEdicionDTO.Create;
  try
    lRol := lRoles.PorCodigo(ROL_ADMINISTRADOR);
    if lRol = nil then
      raise EDatoInvalido.Create(SInicialFaltaRolAdmin);
    try
      lDto.RolId := lRol.ID;
    finally
      lRol.Free;
    end;
    lDto.Nombre := ADatos.Nombre;
    lDto.Correo := ADatos.Correo;
    lDto.ClaveTemporal := ADatos.Clave;

    lServicio := TUsuarioService.Create(TUsuarioRepository.Create,
      TUsuarioClaveRepository.Create, lRoles, TUsuarioPermisoRepository.Create,
      TPermisoCatalogoRepository.Create, TPermisoRepository.Create,
      TClaveService.Create, TPermisoCache.Create);
    lCreado := lServicio.Crear(lDto);
    lCreado.Free;
  finally
    lDto.Free;
  end;
end;

procedure Configurar(const ADatos: TDatosIniciales);
var
  lUsuarios: IUsuarioRepository;
  lSistema: Integer;
begin
  Conectar;
  try
    lUsuarios := TUsuarioRepository.Create;
    lSistema := lUsuarios.IdSistema;
    lUsuarios := nil;
    if lSistema = 0 then
      raise EDatoInvalido.Create(SInicialFaltaSistema);

    FijarUsuario(lSistema);
    try
      GuardarEmpresa(ADatos);
      CrearAdministrador(ADatos);
    finally
      LimpiarDetalle;
      LimpiarUsuario;
    end;
    LogI(Format(SLogConfiguracionInicial, [ADatos.Correo.Trim.ToLower]));
  finally
    Desconectar;
  end;
end;

end.
