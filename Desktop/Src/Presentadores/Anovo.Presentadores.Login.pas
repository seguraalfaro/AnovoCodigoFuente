unit Anovo.Presentadores.Login;

// Presentador del login: abre la sesion y decide si va a la
// ventana principal o al cambio de clave.

interface

uses
  Anovo.Api.Intf.Autenticacion,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Login;

type
  TResultadoLogin = (rlCorrecto, rlDebeCambiarClave, rlSinAccesoEscritorio);

  TPresentadorLogin = class(TPresentadorBase)
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
  Anovo.Api.Base,
  Anovo.Sesion,
  Anovo.Textos;

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
  lResultado: TResultadoLogin;
begin
  lCorreo := ACorreo;
  lClave := AClave;

  if lCorreo.Trim.IsEmpty or lClave.IsEmpty then
  begin
    FVista.MostrarError(SFaltanCredenciales);
    Exit;
  end;

  lResultado := rlCorrecto;
  Ejecutar(SAccionIngresar,
    procedure
    begin
      try
        lResultado := Resolver(lCorreo, lClave);
      except
        on E: EAnovoApiError do
          if E.Status = 401 then
            raise EAnovoCliente.Create(SCredencialesInvalidas)
          else
            raise;
      end;
    end,
    procedure
    begin
      case lResultado of
        rlCorrecto:
          FVista.IrAPrincipal;
        rlDebeCambiarClave:
          Diferir(
            procedure
            begin
              FVista.IrACambioDeClave;
            end);
        rlSinAccesoEscritorio:
          FVista.MostrarError(SUsuarioSinPermisos);
      end;
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

end.
