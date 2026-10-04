unit Anovo.Presentadores.Configuracion;

// Presentadores de Configuracion: la seccion, la
// ventana de conexion y el cambio de clave.

interface

uses
  Anovo.Api.Intf.Configuracion,
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
    procedure CargarCuenta;
  public
    constructor Create(const AVista: IVistaConfiguracion;
      const AApi: IApiConfiguracion);
    procedure Iniciar;
    procedure Probar;
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
  System.SysUtils,
  System.Diagnostics,
  Anovo.Config,
  Anovo.DTOs.Sesion,
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

procedure TPresentadorConfiguracion.Iniciar;
begin
  CargarCuenta;
  Probar;
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
