unit Anovo.Vistas.Intf.Catalogos;

// Contrato de la vista de catalogos.

interface

uses
  Anovo.Vistas.Intf.Listado,
  System.Generics.Collections,
  Anovo.Api.Intf.Catalogos,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Importacion;

type
  TCatalogo = (ctTodos, ctMateriales, ctManoObra, ctMaquinas, ctTiposTrabajo,
    ctUnidadesMedida, ctTiposMaterial, ctAcabados, ctFormasPago);

  TAccionCatalogo = (acEditar, acHistorial, acPrecio, acInactivar);
  TAccionesCatalogo = set of TAccionCatalogo;

  IVistaCatalogos = interface(IVistaListado)
    ['{5E2B9A70-1C46-4D83-B0F9-72A4E6C51D08}']

    procedure MostrarCatalogo(const ACatalogo: TCatalogo);
    procedure MostrarImportar(const AVisible, AHabilitado: Boolean);
    procedure MostrarFormularioImportacion(
      const ACatalogo: TCatalogoImportacion);
    procedure MostrarAcciones(const AAcciones: TAccionesCatalogo;
      const APuedeCrear: Boolean);

    procedure MostrarMateriales(const AFilas: TObjectList<TMaterialDTO>);
    procedure MostrarManoObra(const AFilas: TObjectList<TManoObraDTO>);
    procedure MostrarMaquinas(const AFilas: TObjectList<TMaquinaDTO>);
    procedure MostrarTiposTrabajo(const AFilas: TObjectList<TTipoTrabajoDTO>);
    procedure MostrarSimples(const AFilas: TObjectList<TCatalogoSimpleDTO>);
    procedure MostrarUnidadesMedida(const AFilas: TObjectList<TUnidadMedidaDTO>);
    procedure MostrarUnidadesActivas(const AFilas: TObjectList<TUnidadMedidaDTO>);
    procedure MostrarTodos(const AFilas: TObjectList<TCatalogoItemDTO>);

    function CatalogoDeLaFila: TCatalogo;

    procedure MostrarCategorias(const ACategorias: TObjectList<TCategoriaDTO>);

    function Confirmar(const AMensaje: string): Boolean;

    procedure MostrarFormularioItem(const ACatalogo: TCatalogo;
      const AId: Integer);
    procedure MostrarFormularioPrecio(const ACatalogo: TCatalogo;
      const AId: Integer);
    procedure MostrarHistorial(const ACatalogo: TCatalogo;
      const AFilas: TObjectList<TPrecioDTO>);
  end;

const
  CATALOGOS_SIMPLES = [ctTiposMaterial, ctAcabados, ctFormasPago];
  CATALOGOS_SIN_PRECIO = [ctTiposTrabajo, ctUnidadesMedida] + CATALOGOS_SIMPLES;

function CatalogoSimpleDe(const ACatalogo: TCatalogo): TCatalogoSimple;

implementation

function CatalogoSimpleDe(const ACatalogo: TCatalogo): TCatalogoSimple;
begin
  case ACatalogo of
    ctAcabados:
      Result := csAcabado;
    ctFormasPago:
      Result := csFormaPago;
  else
    Result := csTipoMaterial;
  end;
end;

end.
