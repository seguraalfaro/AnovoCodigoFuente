unit Anovo.Api.Intf.Autenticacion;

{ Contrato de la autenticacion contra el servidor.

  Detras de interfaz para que el presentador del login se pueda probar con una
  API falsa, sin servidor y sin red. }

interface

type
  IApiAutenticacion = interface
    ['{6E2B9A41-3C87-4D15-9F02-B8A4E7C1D356}']
    { Devuelve el token de sesion. Unas credenciales incorrectas llegan como
      EAnovoApiError con Status 401; un servidor caido, como EAnovoSinConexion. }
    function IniciarSesion(const ACorreo, AClave: string): string;
  end;

implementation

end.
