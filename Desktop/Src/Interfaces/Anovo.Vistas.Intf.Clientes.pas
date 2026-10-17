unit Anovo.Vistas.Intf.Clientes;

// Contrato de la vista del listado de clientes.

interface

uses
  Anovo.Vistas.Intf.Listado,
  System.Generics.Collections,
  Anovo.DTOs.Clientes;

type
  TFiltroConsentimiento = (fcTodos, fcFirmado, fcPendiente);

  TAccionCliente = (acDetalles);
  TAccionesCliente = set of TAccionCliente;

  IVistaClientes = interface(IVistaListado)
    ['{7A1D4C92-3E58-4B06-9F27-C5E8B0A16D43}']
    procedure MostrarAcciones(const AAcciones: TAccionesCliente;
      const APuedeCrear: Boolean);
    procedure MostrarClientes(const AClientes: TObjectList<TClienteDTO>);
    procedure MostrarDetalle(const AId: Integer);
    procedure MostrarListado;
  end;

implementation

end.
