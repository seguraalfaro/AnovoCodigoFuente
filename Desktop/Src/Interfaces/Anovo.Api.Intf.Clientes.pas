unit Anovo.Api.Intf.Clientes;

// Contrato de la API de clientes.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Clientes;

type
  IApiClientes = interface
    ['{2F6C9E14-8B3A-4D71-A5E2-0C94B7D1F386}']
    function Buscar(const ATexto, AConsentimiento: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TClienteDTO>;

    function Obtener(const AId: Integer): TClienteDTO;
    function Contactos(const AId: Integer): TObjectList<TContactoDTO>;
    function Consentimientos(const AId: Integer)
      : TObjectList<TConsentimientoDTO>;

    procedure Actualizar(const AId: Integer; const ADto: TClienteEdicionDTO);

    function Crear(const ADto: TClienteNuevoDTO): Integer;
    function CrearContacto(const AId: Integer;
      const ADto: TContactoNuevoDTO): Integer;
    procedure Anonimizar(const AId: Integer; const AMotivo: string);
  end;

implementation

end.
