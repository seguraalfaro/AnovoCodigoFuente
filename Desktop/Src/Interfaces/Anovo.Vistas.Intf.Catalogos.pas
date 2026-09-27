unit Anovo.Vistas.Intf.Catalogos;

// Contrato de la vista de catalogos.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Catalogos;

type
  TCatalogo = (ctTodos, ctMateriales, ctManoObra, ctMaquinas, ctTiposTrabajo,
    ctUnidadesMedida);

  TAccionCatalogo = (acEditar, acHistorial, acPrecio, acInactivar);
  TAccionesCatalogo = set of TAccionCatalogo;

  IVistaCatalogos = interface
    ['{5E2B9A70-1C46-4D83-B0F9-72A4E6C51D08}']

    procedure MostrarCatalogo(const ACatalogo: TCatalogo);
    procedure MostrarAcciones(const AAcciones: TAccionesCatalogo;
      const APuedeCrear: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);

    procedure MostrarMateriales(const AFilas: TObjectList<TMaterialDTO>);
    procedure MostrarManoObra(const AFilas: TObjectList<TManoObraDTO>);
    procedure MostrarMaquinas(const AFilas: TObjectList<TMaquinaDTO>);
    procedure MostrarTiposTrabajo(const AFilas: TObjectList<TTipoTrabajoDTO>);
    procedure MostrarUnidadesMedida(const AFilas: TObjectList<TUnidadMedidaDTO>);
    procedure MostrarUnidadesActivas(const AFilas: TObjectList<TUnidadMedidaDTO>);
    procedure MostrarTodos(const AFilas: TObjectList<TCatalogoItemDTO>);

    function CatalogoDeLaFila: TCatalogo;

    procedure MostrarCategorias(const ACategorias: TObjectList<TCategoriaDTO>);

    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);

    procedure MostrarFormularioItem(const ACatalogo: TCatalogo;
      const AId: Integer);
    procedure MostrarFormularioPrecio(const ACatalogo: TCatalogo;
      const AId: Integer);
    procedure MostrarHistorial(const AFilas: TObjectList<TPrecioDTO>);
  end;

implementation

end.
