unit Anovo.Services.Intf.Catalogos;

// Contrato del servicio de catalogos.
//
// Un solo servicio para los cuatro catalogos y no cuatro: comparten el par de
// permisos catalogos.ver y catalogos.editar, y el escritorio los muestra como
// pestanas de una misma pantalla.
//
// El servicio no sabe nada de HTTP: lanza las excepciones de Anovo.Errors y el
// manejador global las traduce.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Catalogos;

type
  ICatalogoService = interface
    ['{C4A70E19-8D35-4B62-9F08-3E51A6D7C204}']

    // MATERIALES. ATotal sale aparte porque el cliente necesita saber cuantas
    // paginas hay.
    // Materiales, mano de obra y maquinas en una sola lista, para la pestana
    // Todos. Cada fila trae su tipo.
    function BuscarTodos(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TCatalogoItemDTO>;

    function BuscarMateriales(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TMaterialDTO>;
    function ObtenerMaterial(const AId: Integer): TMaterialDTO;
    function CrearMaterial(const ADto: TMaterialNuevoDTO): Integer;
    procedure ActualizarMaterial(const AId: Integer;
      const ADto: TMaterialEdicionDTO);
    // No se borra: las cotizaciones viejas lo siguen nombrando.
    procedure InactivarMaterial(const AId: Integer);
    // Desactiva el precio vigente e inserta el nuevo, en una transaccion.
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
    // Catalogo fijo, de solo lectura.
    function Categorias: TObjectList<TCategoriaDTO>;

    // MAQUINAS. El precio es costo por hora.
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

    // TIPOS DE TRABAJO. Lista corta, sin paginar.
    function TiposTrabajo(const AIncluirInactivos: Boolean)
      : TObjectList<TTipoTrabajoDTO>;
    function CrearTipoTrabajo(const ADto: TTipoTrabajoNuevoDTO): Integer;
    procedure ActualizarTipoTrabajo(const AId: Integer;
      const ADto: TTipoTrabajoNuevoDTO);
    procedure InactivarTipoTrabajo(const AId: Integer);
  end;

implementation

end.
