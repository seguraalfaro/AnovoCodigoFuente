unit Anovo.Services.Intf.Documento;

// Contrato del servicio que arma el documento de la cotizacion.

interface

uses
  Anovo.DTOs.Documento;

type
  ICotizacionDocumentoService = interface
    ['{7C2E9A41-3D58-4B16-A0F7-5E8B1C64D392}']
    function Documento(const AId, AUsuarioId: Integer;
      const ARoles: TArray<string>): TCotizacionDocumentoDTO;
  end;

implementation

end.
