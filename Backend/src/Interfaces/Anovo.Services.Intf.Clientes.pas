unit Anovo.Services.Intf.Clientes;

// Contrato del servicio de clientes.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Clientes;

type
  IClienteService = interface
    ['{8B3F0D51-6A27-4E94-A0C8-5F71D2B6E438}']

    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean; const AConsentimiento: string;
      out ATotal: Int64): TObjectList<TClienteDTO>;

    function Obtener(const AId: Integer): TClienteDTO;

    function Crear(const ADto: TClienteNuevoDTO): Integer;

    procedure Actualizar(const AId: Integer; const ADto: TClienteEdicionDTO);

    procedure Inactivar(const AId: Integer);
    procedure Anonimizar(const AId: Integer; const AMotivo: string);
    procedure AnonimizarContacto(const AId, AContactoId: Integer;
      const AMotivo: string);

    function RegistrarCompleto(const ADto: TClienteRegistroCompletoDTO)
      : Integer;

    function Contactos(const AId: Integer): TObjectList<TContactoDTO>;
    function CrearContacto(const AId: Integer;
      const ADto: TContactoNuevoDTO): Integer;
    procedure ActualizarContacto(const AId, AContactoId: Integer;
      const ADto: TContactoEdicionDTO);
    procedure InactivarContacto(const AId, AContactoId: Integer);

    function Consentimientos(const AId: Integer)
      : TObjectList<TConsentimientoDTO>;
    procedure Revocar(const AId: Integer; const ADto: TRevocacionDTO);

  end;

implementation

end.
