unit Anovo.Api.Intf.Catalogos;

// Contrato de la API de catalogos, visto desde el escritorio.
//
// Devuelve los DTO del backend, no copias propias: si el servidor cambia un
// campo, esto deja de compilar en vez de recibir un dato vacio.
//
// Los cuatro catalogos van en un solo contrato porque asi los sirve el
// servidor: una sola ruta /api/catalogos con subrutas, y el mismo par de
// permisos para todos.
//
// Cambiar un precio no es editar el item: son dos rutas distintas porque el
// precio deja historial y el resto de los campos no.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Catalogos;

type
  IApiCatalogos = interface
    ['{7A1D5E92-4C08-4B36-9F71-D2E560A8C314}']

    // MATERIALES
    //
    // La lista es de quien llama y la libera el. ATotal va aparte: es el total
    // de la busqueda, no de la pagina. Un servidor caido llega como
    // EAnovoSinConexion; un 403, como EAnovoApiError con Status 403.
    function BuscarMateriales(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TMaterialDTO>;
    function ObtenerMaterial(const AId: Integer): TMaterialDTO;
    // Devuelve el numero que asigno la base, que viene en la cabecera
    // Location de la respuesta 201.
    function CrearMaterial(const ADto: TMaterialNuevoDTO): Integer;
    procedure ActualizarMaterial(const AId: Integer;
      const ADto: TMaterialEdicionDTO);
    procedure InactivarMaterial(const AId: Integer);
    // El anterior queda en el historial. Un nombre repetido llega como
    // EAnovoApiError con Status 422.
    procedure CambiarPrecioMaterial(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialPrecioMaterial(const AId: Integer)
      : TObjectList<TPrecioDTO>;

    // MANO DE OBRA. ACategoriaId en 0 son todas.
    function BuscarManoObra(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      const ACategoriaId: Integer; out ATotal: Int64)
      : TObjectList<TManoObraDTO>;
    function ObtenerManoObra(const AId: Integer): TManoObraDTO;
    function CrearManoObra(const ADto: TManoObraNuevaDTO): Integer;
    procedure ActualizarManoObra(const AId: Integer;
      const ADto: TManoObraEdicionDTO);
    procedure InactivarManoObra(const AId: Integer);
    procedure CambiarPrecioManoObra(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialPrecioManoObra(const AId: Integer)
      : TObjectList<TPrecioDTO>;
    // Catalogo fijo: se lee entero y no se edita desde aqui.
    function Categorias: TObjectList<TCategoriaDTO>;

    // MAQUINAS. El precio es costo por hora.
    // Los tres catalogos con precio en una sola lista, para la pestana Todos.
    function BuscarTodos(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TCatalogoItemDTO>;
    function BuscarMaquinas(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TMaquinaDTO>;
    function ObtenerMaquina(const AId: Integer): TMaquinaDTO;
    function CrearMaquina(const ADto: TMaquinaNuevaDTO): Integer;
    procedure ActualizarMaquina(const AId: Integer;
      const ADto: TMaquinaEdicionDTO);
    procedure InactivarMaquina(const AId: Integer);
    procedure CambiarCostoMaquina(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialCostoMaquina(const AId: Integer)
      : TObjectList<TPrecioDTO>;

    // TIPOS DE TRABAJO. Lista corta, sin paginar: llena un desplegable.
    function TiposTrabajo(const AIncluirInactivos: Boolean)
      : TObjectList<TTipoTrabajoDTO>;
    function CrearTipoTrabajo(const ADto: TTipoTrabajoNuevoDTO): Integer;
    procedure ActualizarTipoTrabajo(const AId: Integer;
      const ADto: TTipoTrabajoNuevoDTO);
    procedure InactivarTipoTrabajo(const AId: Integer);
  end;

implementation

end.
