unit Anovo.Api.Intf.Autenticacion;

// Contrato de la API de autenticacion.

interface

type
  IApiAutenticacion = interface
    ['{6E2B9A41-3C87-4D15-9F02-B8A4E7C1D356}']

    function IniciarSesion(const ACorreo, AClave: string): string;

    function ObtenerPermisos: TArray<string>;
  end;

implementation

end.
