unit Anovo.Services.Intf.Sesion;

// Contrato del servicio de la cuenta propia.

interface

uses
  Anovo.DTOs.Sesion;

type
  ISesionService = interface
    ['{3B7D2E91-5C48-4A6F-9E13-8D0F6A2C4B57}']
    function Cuenta(const AUsuarioId: Integer; const ARol: string): TCuentaDTO;

    procedure CambiarClave(const AUsuarioId: Integer;
      const ADto: TCambioClaveDTO);

    function Versiones: TVersionDTO;
  end;

implementation

end.
