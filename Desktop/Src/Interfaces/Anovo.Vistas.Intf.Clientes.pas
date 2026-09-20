unit Anovo.Vistas.Intf.Clientes;

// Lo que el presentador de clientes necesita de la pantalla, y nada mas.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Clientes;

type
  // En el orden de las pestanas del frame: Todos, Con consentimiento,
  // Pendientes.
  TFiltroConsentimiento = (fcTodos, fcFirmado, fcPendiente);

  // Los botones de cada fila. Cuales se ven lo decide el presentador con los
  // permisos; como se ven, la vista.
  TAccionCliente = (acDetalles);
  TAccionesCliente = set of TAccionCliente;

  IVistaClientes = interface
    ['{7A1D4C92-3E58-4B06-9F27-C5E8B0A16D43}']
    procedure MostrarAcciones(const AAcciones: TAccionesCliente;
      const APuedeCrear: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    // El texto que se esta buscando, y si hay busqueda que limpiar.
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    // La lista es del presentador y la libera al volver: la vista copia lo
    // que necesita y no se queda con ella.
    procedure MostrarClientes(const AClientes: TObjectList<TClienteDTO>);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
    // Abre la ficha del cliente encima del listado.
    procedure MostrarDetalle(const AId: Integer);
  end;

implementation

end.
