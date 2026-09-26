unit Anovo.Vistas.Intf.Catalogos;

// Lo que el presentador de catalogos necesita de la pantalla, y nada mas.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Catalogos;

type
  // En el orden de las pestanas del frame, que se traducen por posicion.
  //
  // ctTodos no es un catalogo: es la lista unificada de los tres con precio.
  // Nunca llega a una ventana de item ni a una llamada de escritura; antes de
  // eso el presentador la cambia por el catalogo real de la fila.
  TCatalogo = (ctTodos, ctMateriales, ctManoObra, ctMaquinas, ctTiposTrabajo);

  // Los botones de cada fila. Cuales se ven lo decide el presentador con los
  // permisos; como se ven, la vista.
  //
  // acPrecio y acHistorial no aplican a tipos de trabajo, que no lleva precio.
  TAccionCatalogo = (acEditar, acHistorial, acPrecio, acInactivar);
  TAccionesCatalogo = set of TAccionCatalogo;

  IVistaCatalogos = interface
    ['{5E2B9A70-1C46-4D83-B0F9-72A4E6C51D08}']

    // Cual pestana se esta viendo. La vista cambia columnas y titulo: cada
    // catalogo muestra campos distintos.
    procedure MostrarCatalogo(const ACatalogo: TCatalogo);
    procedure MostrarAcciones(const AAcciones: TAccionesCatalogo;
      const APuedeCrear: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    // El texto que se esta buscando, y si hay busqueda que limpiar.
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);

    // Una por catalogo y no una generica: los DTO son distintos y con un
    // TObject la vista tendria que adivinar cual llego.
    //
    // La lista es del presentador y la libera al volver: la vista copia lo
    // que necesita y no se queda con ella.
    procedure MostrarMateriales(const AFilas: TObjectList<TMaterialDTO>);
    procedure MostrarManoObra(const AFilas: TObjectList<TManoObraDTO>);
    procedure MostrarMaquinas(const AFilas: TObjectList<TMaquinaDTO>);
    procedure MostrarTiposTrabajo(const AFilas: TObjectList<TTipoTrabajoDTO>);
    procedure MostrarTodos(const AFilas: TObjectList<TCatalogoItemDTO>);

    // En la pestana Todos, de que catalogo es la fila seleccionada. La vista
    // lo sabe porque tiene la fila; el presentador lo pregunta para saber que
    // ventana abrir o a que ruta llamar.
    function CatalogoDeLaFila: TCatalogo;

    // Llena el desplegable de categorias de la pestana de mano de obra. Se
    // pide una vez: es catalogo fijo.
    procedure MostrarCategorias(const ACategorias: TObjectList<TCategoriaDTO>);

    // Tipos de trabajo no pagina: la vista esconde los controles cuando
    // ATotalPaginas es cero.
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);

    // Abre el formulario del item. AId en 0 es uno nuevo. No lleva precio:
    // cambiarlo es otra operacion, con su propio rastro.
    procedure MostrarFormularioItem(const ACatalogo: TCatalogo;
      const AId: Integer);
    // Abre el formulario de cambio de precio del item.
    procedure MostrarFormularioPrecio(const ACatalogo: TCatalogo;
      const AId: Integer);
    // El historial de precios del item, el mas reciente primero.
    procedure MostrarHistorial(const AFilas: TObjectList<TPrecioDTO>);
  end;

implementation

end.
