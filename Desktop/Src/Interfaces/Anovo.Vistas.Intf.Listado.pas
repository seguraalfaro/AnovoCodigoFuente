unit Anovo.Vistas.Intf.Listado;

// Contrato comun de las vistas de listado: busqueda, paginacion,
// estado ocupado y errores.

interface

type
  IVistaListado = interface
    ['{5B0E3F7A-9C1D-4E62-8A47-2D3F6B8C1E90}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
