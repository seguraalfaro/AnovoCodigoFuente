unit Anovo.Api.Intf.Catalogos;

// Contrato de la API de catalogos.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Importacion;

type
  TCatalogoSimple = (csTipoMaterial, csAcabado, csFormaPago);

  IApiCatalogos = interface
    ['{7A1D5E92-4C08-4B36-9F71-D2E560A8C314}']

    function BuscarMateriales(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TMaterialDTO>;
    function CrearMaterial(const ADto: TMaterialNuevoDTO): Integer;
    procedure ActualizarMaterial(const AId: Integer;
      const ADto: TMaterialEdicionDTO);
    procedure InactivarMaterial(const AId: Integer);
    procedure CambiarPrecioMaterial(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialPrecioMaterial(const AId: Integer)
      : TObjectList<TPrecioDTO>;

    function BuscarManoObra(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      const ACategoriaId: Integer; out ATotal: Int64)
      : TObjectList<TManoObraDTO>;
    function CrearManoObra(const ADto: TManoObraNuevaDTO): Integer;
    procedure ActualizarManoObra(const AId: Integer;
      const ADto: TManoObraEdicionDTO);
    procedure InactivarManoObra(const AId: Integer);
    procedure CambiarPrecioManoObra(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialPrecioManoObra(const AId: Integer)
      : TObjectList<TPrecioDTO>;
    function Categorias: TObjectList<TCategoriaDTO>;
    function Importar(const ACatalogo: TCatalogoImportacion;
      const ADatos: TImportacionDTO; const ASoloRevisar: Boolean)
      : TImportacionResultadoDTO;

    function BuscarTodos(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TCatalogoItemDTO>;
    function BuscarMaquinas(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TMaquinaDTO>;
    function CrearMaquina(const ADto: TMaquinaNuevaDTO): Integer;
    procedure ActualizarMaquina(const AId: Integer;
      const ADto: TMaquinaEdicionDTO);
    procedure InactivarMaquina(const AId: Integer);
    procedure CambiarCostoMaquina(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialCostoMaquina(const AId: Integer)
      : TObjectList<TPrecioDTO>;

    function TiposTrabajo(const AIncluirInactivos: Boolean;
      const ATexto: string = ''): TObjectList<TTipoTrabajoDTO>;
    function CrearTipoTrabajo(const ADto: TTipoTrabajoNuevoDTO): Integer;
    procedure ActualizarTipoTrabajo(const AId: Integer;
      const ADto: TTipoTrabajoNuevoDTO);
    procedure InactivarTipoTrabajo(const AId: Integer);

    function Simples(const ACatalogo: TCatalogoSimple;
      const AIncluirInactivos: Boolean; const ATexto: string = '')
      : TObjectList<TCatalogoSimpleDTO>;
    function CrearSimple(const ACatalogo: TCatalogoSimple;
      const ADto: TCatalogoSimpleNuevoDTO): Integer;
    procedure ActualizarSimple(const ACatalogo: TCatalogoSimple;
      const AId: Integer; const ADto: TCatalogoSimpleNuevoDTO);
    procedure InactivarSimple(const ACatalogo: TCatalogoSimple;
      const AId: Integer);

    function UnidadesMedida(const AIncluirInactivas: Boolean;
      const ATexto: string = ''): TObjectList<TUnidadMedidaDTO>;
    function CrearUnidadMedida(const ADto: TUnidadMedidaNuevaDTO): Integer;
    procedure ActualizarUnidadMedida(const AId: Integer;
      const ADto: TUnidadMedidaNuevaDTO);
    procedure InactivarUnidadMedida(const AId: Integer);
  end;

implementation

end.
