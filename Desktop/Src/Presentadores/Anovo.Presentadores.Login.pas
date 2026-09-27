unit Anovo.Presentadores.Login;

// Presentador del login: abre la sesion y decide si va a la
// ventana principal o al cambio de clave.

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
    constructor Create(const AVista: IVistaLogin;
      const AApi: IApiAutenticacion);
    procedure Ingresar(const ACorreo, AClave: string);
    function Resolver(const ACorreo, AClave: string): TResultadoLogin;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  Anovo.Api.Base,
  Anovo.Sesion,
  Anovo.Textos;

function MensajeInesperado: string;
begin
  Result := Format(SErrorInesperado, [SAccionIngresar]);
end;

constructor TPresentadorLogin.Create(const AVista: IVistaLogin;
  const AApi: IApiAutenticacion);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
end;

function TPresentadorLogin.Resolver(const ACorreo, AClave: string)
  : TResultadoLogin;
begin
  TSesion.Abrir(FApi.IniciarSesion(ACorreo.Trim, AClave));

  if TSesion.DebeCambiarClave then
    Exit(rlDebeCambiarClave);

  TSesion.AsignarPermisos(FApi.ObtenerPermisos);

  if Length(TSesion.Permisos) = 0 then
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
    FVista.MostrarError(SFaltanCredenciales);
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
            lError := SCredencialesInvalidas
          else
            lError := E.Message;
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MensajeInesperado;
      end;

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
                FVista.MostrarError(SUsuarioSinPermisos);
            end;
        end);
    end);
end;

end.
