unit Anovo.Presentadores.Login;

{ La logica del login, fuera del formulario.

  Dos metodos a proposito:

    Resolver   sincronico. Llama a la API, abre la sesion y decide el destino.
               Es lo que se prueba con DUnitX, con una API y una vista falsas.
    Ingresar   lo que llama la pantalla. Ejecuta Resolver fuera del hilo de la
               interfaz y devuelve el resultado a la vista en el hilo principal.

  Asi la prueba no tiene que lidiar con hilos, y la ventana no se congela
  mientras el servidor contesta o tarda en rendirse. }

interface

uses
  Anovo.Api.Intf.Autenticacion,
  Anovo.Vistas.Intf.Login;

type
  TResultadoLogin = (rlCorrecto, rlDebeCambiarClave, rlSinAccesoEscritorio);

  TPresentadorLogin = class
  private
    FVista: IVistaLogin;
    FApi: IApiAutenticacion;
  public
    constructor Create(const AVista: IVistaLogin; const AApi: IApiAutenticacion);
    procedure Ingresar(const ACorreo, AClave: string);
    function Resolver(const ACorreo, AClave: string): TResultadoLogin;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  Anovo.Api.Base,
  Anovo.Sesion;

const
  MENSAJE_FALTAN_DATOS = 'Escriba su correo y su clave.';
  { El mismo texto para correo inexistente y clave incorrecta. El servidor ya
    responde igual en los dos casos para no delatar que correos existen; la
    pantalla no debe deshacerlo. }
  MENSAJE_CREDENCIALES = 'El correo o la clave no son correctos.';
  MENSAJE_SIN_ACCESO = 'Su perfil trabaja con la aplicacion movil. ' +
    'La aplicacion de escritorio no tiene modulos para asesores.';
  MENSAJE_INESPERADO = 'Ocurrio un error inesperado al ingresar. ' +
    'Intente de nuevo; si persiste, avise al administrador.';

constructor TPresentadorLogin.Create(const AVista: IVistaLogin;
  const AApi: IApiAutenticacion);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
end;

function TPresentadorLogin.Resolver(const ACorreo, AClave: string): TResultadoLogin;
begin
  TSesion.Abrir(FApi.IniciarSesion(ACorreo.Trim, AClave));

  { Primero la clave provisional: con ella el token trae el rol clave_vencida,
    que cae en asesor, y se le negaria el acceso a alguien que solo tiene que
    cambiar la clave. }
  if TSesion.DebeCambiarClave then
    Exit(rlDebeCambiarClave);

  if TSesion.Rol = rolAsesor then
  begin
    TSesion.Cerrar;
    Exit(rlSinAccesoEscritorio);
  end;

  Result := rlCorrecto;
end;

procedure TPresentadorLogin.Ingresar(const ACorreo, AClave: string);
var
  lCorreo, lClave: string;
begin
  lCorreo := ACorreo;
  lClave := AClave;

  if lCorreo.Trim.IsEmpty or lClave.IsEmpty then
  begin
    FVista.MostrarError(MENSAJE_FALTAN_DATOS);
    Exit;
  end;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lResultado: TResultadoLogin;
      lError: string;
    begin
      lResultado := rlCorrecto;
      lError := '';
      try
        lResultado := Resolver(lCorreo, lClave);
      except
        on E: EAnovoApiError do
          if E.Status = 401 then
            lError := MENSAJE_CREDENCIALES
          else
            lError := E.Message;
        { Sin conexion y sesion vencida ya traen su mensaje para la persona. }
        on E: EAnovoCliente do
          lError := E.Message;
        { Una excepcion que se escapa de TTask no la ve nadie: el hilo muere en
          silencio y el indicador de carga se queda girando para siempre. }
        on E: Exception do
          lError := MENSAJE_INESPERADO;
      end;

      { Los controles solo se tocan desde el hilo principal. }
      TThread.Queue(nil,
        procedure
        begin
          FVista.MostrarCargando(False);
          if not lError.IsEmpty then
            FVista.MostrarError(lError)
          else
            case lResultado of
              rlCorrecto:
                FVista.IrAPrincipal;
              rlDebeCambiarClave:
                FVista.IrACambioDeClave;
              rlSinAccesoEscritorio:
                FVista.MostrarError(MENSAJE_SIN_ACCESO);
            end;
        end);
    end);
end;

end.
