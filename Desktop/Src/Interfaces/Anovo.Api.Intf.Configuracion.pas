unit Anovo.Api.Intf.Configuracion;

// Contrato de la API de Configuracion.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Clientes,
  Anovo.DTOs.Empresa,
  Anovo.DTOs.Sesion;

type
  IApiConfiguracion = interface
    ['{8D3F6B21-47AE-4C95-B0E8-1F2A9C5D7E43}']
    function Cuenta: TCuentaDTO;
    procedure CambiarClave(const ADto: TCambioClaveDTO);
    function Version(const AUrl: string = ''): TVersionDTO;
    function Empresa: TEmpresaDTO;
    procedure GuardarEmpresa(const ADto: TEmpresaDTO);
    function FormasPago: TObjectList<TCatalogoSimpleDTO>;
    function VersionesConsentimiento: TObjectList<TConsentimientoTextoDTO>;
    procedure PublicarConsentimiento(const ADto: TConsentimientoTextoNuevoDTO);
  end;

implementation

end.
