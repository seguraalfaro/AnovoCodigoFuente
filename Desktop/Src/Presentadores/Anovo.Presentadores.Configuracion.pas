unit Anovo.Presentadores.Configuracion;

// Presentadores de Configuracion: la seccion, la
// ventana de conexion y el cambio de clave.

interface

uses
  Anovo.Api.Intf.Configuracion,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.Configuracion,
  Anovo.Vistas.Intf.Registro;

type
  TPresentadorConfiguracion = class
  private
    FVista: IVistaConfiguracion;
    FApi: IApiConfiguracion;
    FCancelacion: ICancelacion;
    procedure CargarCuenta;
  public
    constructor Create(const AVista: IVistaConfiguracion;
      const AApi: IApiConfiguracion);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Probar;
  end;

  TPresentadorConexion = class
  private
    FVista: IVistaPruebaConexion;
    FApi: IApiConfiguracion;
    FCancelacion: ICancelacion;
  public
    constructor Create(const AVista: IVistaPruebaConexion;
      const AApi: IApiConfiguracion);
    destructor Destroy; override;
    procedure Probar(const AUrl: string);
  end;

  TPresentadorCambioClave = class
  private
    FVista: IVistaRegistro;
    FApi: IApiConfiguracion;
    FCancelacion: ICancelacion;
  public
    constructor Create(const AVista: IVistaRegistro;
      const AApi: IApiConfiguracion);
    destructor Destroy; override;
    procedure Guardar(const AActual, ANueva: string);
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  System.Diagnostics,
  Anovo.Api.Base,
  Anovo.DTOs.Sesion,
  Anovo.Textos;

procedure LanzarPrueba(const AVista: IVistaPruebaConexion;
  const AApi: IApiConfiguracion; const ACancelacion: ICancelacion;
  const AUrl: string);
begin
  AVista.MostrarProbando;

  TTask.Run(
    procedure
    var
      lResultado: TResultadoConexion;
      lReloj: TStopwatch;
      lVersion: TVersionDTO;
    begin
      lResultado := Default(TResultadoConexion);
      try
        lReloj := TStopwatch.StartNew;
        lVersion := AApi.Version(AUrl);
        try
          lResultado.Milisegundos := lReloj.ElapsedMilliseconds;
          lResultado.Conectado := True;
          lResultado.VersionServidor := lVersion.Servidor;
          lResultado.VersionMovil := lVersion.Movil;
          lResultado.VersionAviso := lVersion.AvisoPrivacidad;
        finally
          lVersion.Free;
        end;
      except
        on E: EAnovoCliente do
          lResultado.Mensaje := E.Message;
        on E: Exception do
          lResultado.Mensaje := Format(SErrorInesperado,
            [SAccionProbarConexion]);
      end;

      TThread.Queue(nil,
        procedure
        begin
          if not ACancelacion.Cancelada then
            AVista.MostrarConexion(lResultado);
        end);
    end);
end;

constructor TPresentadorConfiguracion.Create(const AVista: IVistaConfiguracion;
  const AApi: IApiConfiguracion);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
end;

destructor TPresentadorConfiguracion.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorConfiguracion.Iniciar;
begin
  CargarCuenta;
  Probar;
end;

procedure TPresentadorConfiguracion.Probar;
begin
  LanzarPrueba(FVista, FApi, FCancelacion, '');
end;

procedure TPresentadorConfiguracion.CargarCuenta;
var
  lCancelacion: ICancelacion;
  lApi: IApiConfiguracion;
  lVista: IVistaConfiguracion;
begin
  lCancelacion := FCancelacion;
  lApi := FApi;
  lVista := FVista;

  lVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lDatos: TCuentaDTO;
      lError: string;
    begin
      lDatos := nil;
      lError := '';
      try
        lDatos := lApi.Cuenta;
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := Format(SErrorInesperado, [SAccionCargarCuenta]);
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada then
              Exit;

            lVista.MostrarCargando(False);
            if not lError.IsEmpty then
            begin
              lVista.MostrarError(lError);
              Exit;
            end;

            lVista.MostrarCuenta(lDatos);
          finally
            lDatos.Free;
          end;
        end);
    end);
end;

constructor TPresentadorConexion.Create(const AVista: IVistaPruebaConexion;
  const AApi: IApiConfiguracion);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
end;

destructor TPresentadorConexion.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorConexion.Probar(const AUrl: string);
begin
  LanzarPrueba(FVista, FApi, FCancelacion, AUrl);
end;

constructor TPresentadorCambioClave.Create(const AVista: IVistaRegistro;
  const AApi: IApiConfiguracion);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
end;

destructor TPresentadorCambioClave.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorCambioClave.Guardar(const AActual, ANueva: string);
var
  lCancelacion: ICancelacion;
  lApi: IApiConfiguracion;
  lVista: IVistaRegistro;
begin
  lCancelacion := FCancelacion;
  lApi := FApi;
  lVista := FVista;

  lVista.MostrarGuardando(True);

  TTask.Run(
    procedure
    var
      lDto: TCambioClaveDTO;
      lError: string;
    begin
      lError := '';
      lDto := TCambioClaveDTO.Create;
      try
        lDto.ClaveActual := AActual;
        lDto.ClaveNueva := ANueva;
        try
          lApi.CambiarClave(lDto);
        except
          on E: EAnovoCliente do
            lError := E.Message;
          on E: Exception do
            lError := Format(SErrorInesperado, [SAccionCambiarClave]);
        end;
      finally
        lDto.Free;
      end;

      TThread.Queue(nil,
        procedure
        begin
          if lCancelacion.Cancelada then
            Exit;

          lVista.MostrarGuardando(False);
          if lError.IsEmpty then
            lVista.Guardado(0)
          else
            lVista.MostrarError(lError);
        end);
    end);
end;

end.
