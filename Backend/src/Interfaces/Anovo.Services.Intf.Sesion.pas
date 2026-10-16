unit Anovo.Services.Intf.Sesion;

// Contrato del servicio de la cuenta propia.

interface

uses
  Anovo.DTOs.Sesion;

const
  ROL_CLAVE_VENCIDA = 'clave_vencida';

type
  TAutenticacion = record
    Valido: Boolean;
    UsuarioId: Integer;
    Correo: string;
    Nombre: string;
    Rol: string;
    DebeCambiarClave: Boolean;
    CuentaInactiva: Boolean;
  end;

  ISesionService = interface
    ['{3B7D2E91-5C48-4A6F-9E13-8D0F6A2C4B57}']
    function Cuenta(const AUsuarioId: Integer; const ARol: string): TCuentaDTO;

    procedure CambiarClave(const AUsuarioId: Integer;
      const ADto: TCambioClaveDTO);

    function Versiones: TVersionDTO;

    function Autenticar(const ACorreo, AClave: string): TAutenticacion;

    function SesionDe(const AUsuarioId: Integer): TAutenticacion;
  end;

implementation

end.
