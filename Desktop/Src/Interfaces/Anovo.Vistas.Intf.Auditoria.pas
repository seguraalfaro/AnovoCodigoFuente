unit Anovo.Vistas.Intf.Auditoria;

// Lo que el presentador de auditoria necesita de la pantalla, y nada mas.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Auditoria;

type
  // En el orden de las pestanas del frame: Todo, Clientes, Cotizaciones,
  // Cuentas. Filtran por la columna ENTIDAD de la bitacora.
  TFiltroEntidad = (feTodo, feClientes, feCotizaciones, feCuentas);

  IVistaAuditoria = interface
    ['{3B8D06F1-5C27-4E94-A6B0-D174E9C2538A}']

    // APuedeVerTodo en falso es el administrador, que solo ve la bitacora de
    // cuentas: la vista esconde las pestanas porque no hay donde escoger.
    procedure MostrarAlcance(const APuedeVerTodo: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    // La ventana de tiempo con la que se pidio, para que los selectores
    // muestren lo mismo que se consulto.
    procedure MostrarPeriodo(const ADesde, AHasta: TDateTime);
    // El texto que se esta buscando, y si hay busqueda que limpiar.
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    // La lista es del presentador y la libera al volver: la vista copia lo
    // que necesita y no se queda con ella.
    procedure MostrarAuditoria(const AFilas: TObjectList<TAuditoriaDTO>);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
