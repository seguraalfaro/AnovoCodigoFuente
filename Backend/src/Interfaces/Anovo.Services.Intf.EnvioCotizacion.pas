unit Anovo.Services.Intf.EnvioCotizacion;

// Contrato del envio de la cotizacion al cliente por correo.

interface

uses
  Anovo.DTOs.Correo;

type
  IEnvioCotizacionService = interface
    ['{9D3A6E17-5B42-4C88-A0F1-7E2B4C9D6A53}']
    procedure Enviar(const AId, AUsuarioId: Integer;
      const ARoles: TArray<string>; const ADto: TEnvioCorreoDTO);
  end;

implementation

end.
