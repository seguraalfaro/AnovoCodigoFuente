unit Anovo.Presentadores.Configuracion;

// Presentadores de Configuracion: la seccion, la
// ventana de conexion y el cambio de clave.

interface

uses
  System.SysUtils,
  Anovo.Api.Intf.Configuracion,
  Anovo.DTOs.Empresa,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Configuracion,
  Anovo.Vistas.Intf.Registro;

type
  TPresentadorPrueba = class(TPresentadorBase)
  protected
    FApi: IApiConfiguracion;
    procedure LanzarPrueba(const AVista: IVistaPruebaConexion;
      const AUrl: string);
  end;

  TPresentadorConfiguracion = class(TPresentadorPrueba)
  private
    FVista: IVistaConfiguracion;
    FEmpresa: TEmpresaDTO;
    procedure CargarCuenta;
    procedure CargarEmpresa;
    function PuedeEditarEmpresa: Boolean;
    function TextoPermisosPropios(const AAdicionales,
      AQuitados: Integer): string;
    procedure EnviarEmpresa(const ADto: TEmpresaDTO; const AAccion: string;
      const AListo, AFallo: TProc; const ALiberar: TProc = nil);
  public
    constructor Create(const AVista: IVistaConfiguracion;
      const AApi: IApiConfiguracion);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Probar;
    procedure GuardarEmpresa(const ADto: TEmpresaDTO);
    procedure DeshacerEmpresa;
    procedure GuardarParametros(const ADias, AMinutos: Integer);
  end;

  TPresentadorConexion = class(TPresentadorPrueba)
  private
    FVista: IVistaConexion;
    function UrlValida(const AUrl: string): Boolean;
  public
    constructor Create(const AVista: IVistaConexion;
      const AApi: IApiConfiguracion);
    procedure Probar(const AUrl: string);
    procedure Guardar(const AUrl: string);
  end;

  TPresentadorCambioClave = class(TPresentadorBase)
  private
    FVista: IVistaRegistro;
    FApi: IApiConfiguracion;
  public
    constructor Create(const AVista: IVistaRegistro;
      const AApi: IApiConfiguracion);
    procedure Guardar(const AActual, ANueva: string);
  end;

implementation

uses
  System.Diagnostics,
  Anovo.Config,
  Anovo.DTOs.Sesion,
  Anovo.Permisos,
  Anovo.Sesion,
  Anovo.Textos;

const
  PREFIJO_HTTPS = 'https://';

procedure TPresentadorPrueba.LanzarPrueba(const AVista: IVistaPruebaConexion;
  const AUrl: string);
var
  lApi: IApiConfiguracion;
  lResultado: TResultadoConexion;
  lVersion: TVersionDTO;
begin
  lApi := FApi;
  lResultado := Default(TResultadoConexion);
  lVersion := nil;
  AVista.MostrarProbando;

  Ejecutar(SAccionProbarConexion,
    procedure
    var
      lReloj: TStopwatch;
    begin
      lReloj := TStopwatch.StartNew;
      lVersion := lApi.Version(AUrl);
      lResultado.Milisegundos := lReloj.ElapsedMilliseconds;
    end,
    procedure
    begin
      lResultado.Conectado := True;
      lResultado.VersionServidor := lVersion.Servidor;
      lResultado.VersionMovil := lVersion.Movil;
      lResultado.VersionAviso := lVersion.AvisoPrivacidad;
      lResultado.VersionBaseDatos := lVersion.BaseDatos;
      AVista.MostrarConexion(lResultado);
    end,
    procedure(AMensaje: string)
    begin
      lResultado.Mensaje := AMensaje;
      AVista.MostrarConexion(lResultado);
    end, nil,
    procedure
    begin
      lVersion.Free;
    end);
end;

constructor TPresentadorConfiguracion.Create(const AVista: IVistaConfiguracion;
  const AApi: IApiConfiguracion);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
end;

destructor TPresentadorConfiguracion.Destroy;
begin
  FreeAndNil(FEmpresa);
  inherited;
end;

procedure TPresentadorConfiguracion.Iniciar;
begin
  FVista.MostrarMinutosAvisos(TConfig.MinutosAvisos);
  FVista.MostrarSeccionEmpresa(PuedeEditarEmpresa);
  CargarCuenta;
  Probar;
  if PuedeEditarEmpresa then
    CargarEmpresa;
end;

function TPresentadorConfiguracion.PuedeEditarEmpresa: Boolean;
begin
  Result := TSesion.TieneAlguno([PERMISO_EMPRESA_EDITAR,
    PERMISO_EMPRESA_ADMINISTRAR]);
end;

function TPresentadorConfiguracion.TextoPermisosPropios(const AAdicionales,
  AQuitados: Integer): string;
begin
  if (AAdicionales = 0) and (AQuitados = 0) then
    Result := SPermisosSoloRol
  else
    Result := Format(SPermisosPropios, [AAdicionales, AQuitados]);
end;

procedure TPresentadorConfiguracion.CargarEmpresa;
var
  lApi: IApiConfiguracion;
  lEmpresa: TEmpresaDTO;
begin
  lApi := FApi;
  lEmpresa := nil;

  Ejecutar(SAccionCargarEmpresa,
    procedure
    begin
      lEmpresa := lApi.Empresa;
    end,
    procedure
    begin
      FreeAndNil(FEmpresa);
      FEmpresa := lEmpresa;
      lEmpresa := nil;
      FVista.MostrarEmpresa(FEmpresa);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end,
    procedure
    begin
      lEmpresa.Free;
    end);
end;

procedure TPresentadorConfiguracion.EnviarEmpresa(const ADto: TEmpresaDTO;
  const AAccion: string; const AListo, AFallo, ALiberar: TProc);
var
  lApi: IApiConfiguracion;
begin
  lApi := FApi;

  Ejecutar(AAccion,
    procedure
    begin
      lApi.GuardarEmpresa(ADto);
    end,
    AListo,
    procedure(AMensaje: string)
    begin
      if Assigned(AFallo) then
        AFallo();
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end, ALiberar);
end;

procedure TPresentadorConfiguracion.GuardarEmpresa(const ADto: TEmpresaDTO);
var
  lDto: TEmpresaDTO;
  lAdoptado: Boolean;
begin
  if FEmpresa = nil then
  begin
    ADto.Free;
    Exit;
  end;

  lDto := ADto;
  lAdoptado := False;
  lDto.DiasSinRespuesta := FEmpresa.DiasSinRespuesta;
  EnviarEmpresa(lDto, SAccionGuardarEmpresa,
    procedure
    begin
      FEmpresa.Free;
      FEmpresa := lDto;
      lAdoptado := True;
      FVista.EmpresaGuardada;
    end, nil,
    procedure
    begin
      if not lAdoptado then
        lDto.Free;
    end);
end;

procedure TPresentadorConfiguracion.DeshacerEmpresa;
begin
  if FEmpresa <> nil then
    FVista.MostrarEmpresa(FEmpresa);
end;

procedure TPresentadorConfiguracion.GuardarParametros(const ADias,
  AMinutos: Integer);
var
  lAnterior: Integer;
begin
  if (AMinutos < MINUTOS_AVISOS_MINIMO) or
    (AMinutos > MINUTOS_AVISOS_MAXIMO) then
  begin
    FVista.MostrarError(Format(SMinutosAvisosFueraDeRango,
      [MINUTOS_AVISOS_MINIMO, MINUTOS_AVISOS_MAXIMO]));
    Exit;
  end;
  TConfig.GuardarMinutosAvisos(AMinutos);

  if (FEmpresa = nil) or (ADias = FEmpresa.DiasSinRespuesta) then
  begin
    FVista.ParametrosGuardados;
    Exit;
  end;

  lAnterior := FEmpresa.DiasSinRespuesta;
  FEmpresa.DiasSinRespuesta := ADias;
  EnviarEmpresa(FEmpresa, SAccionGuardarParametros,
    procedure
    begin
      FVista.ParametrosGuardados;
    end,
    procedure
    begin
      FEmpresa.DiasSinRespuesta := lAnterior;
    end);
end;

procedure TPresentadorConfiguracion.Probar;
begin
  LanzarPrueba(FVista, '');
end;

procedure TPresentadorConfiguracion.CargarCuenta;
var
  lApi: IApiConfiguracion;
begin
  lApi := FApi;

  Ejecutar<TCuentaDTO>(SAccionCargarCuenta,
    function: TCuentaDTO
    begin
      Result := lApi.Cuenta;
    end,
    procedure(ADatos: TCuentaDTO)
    begin
      FVista.MostrarCuenta(ADatos);
      FVista.MostrarPermisosPropios(TextoPermisosPropios(
        ADatos.PermisosAdicionales, ADatos.PermisosQuitados));
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end);
end;

constructor TPresentadorConexion.Create(const AVista: IVistaConexion;
  const AApi: IApiConfiguracion);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
end;

function TPresentadorConexion.UrlValida(const AUrl: string): Boolean;
begin
  Result := False;
  if AUrl.Trim.IsEmpty then
    FVista.MostrarUrlInvalida(SUrlVacia)
  else if not AUrl.Trim.StartsWith(PREFIJO_HTTPS, True) then
    FVista.MostrarUrlInvalida(SUrlSinHttps)
  else
    Result := True;
end;

procedure TPresentadorConexion.Probar(const AUrl: string);
begin
  if UrlValida(AUrl) then
    LanzarPrueba(FVista, AUrl.Trim);
end;

procedure TPresentadorConexion.Guardar(const AUrl: string);
begin
  if not UrlValida(AUrl) then
    Exit;
  TConfig.GuardarUrl(AUrl.Trim);
  FVista.UrlGuardada;
end;

constructor TPresentadorCambioClave.Create(const AVista: IVistaRegistro;
  const AApi: IApiConfiguracion);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
end;

procedure TPresentadorCambioClave.Guardar(const AActual, ANueva: string);
var
  lApi: IApiConfiguracion;
  lDto: TCambioClaveDTO;
begin
  lApi := FApi;
  lDto := TCambioClaveDTO.Create;
  lDto.ClaveActual := AActual;
  lDto.ClaveNueva := ANueva;

  Ejecutar(SAccionCambiarClave,
    procedure
    begin
      lApi.CambiarClave(lDto);
    end,
    procedure
    begin
      FVista.Guardado(0);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarGuardando(AActivo);
    end,
    procedure
    begin
      lDto.Free;
    end);
end;

end.
