unit Anovo.Repositories.Intf.Catalogos;

// Contratos de los repositorios de catalogos: uno por tabla.
//
// El CRUD directo lo da IMVCRepository<T> y no hace falta escribirlo. Aqui van
// las consultas que significan algo en el negocio.
//
// Los cuatro catalogos se repiten con la misma forma. No se unifican en un
// generico porque las columnas difieren -mano de obra no tiene NOMBRE,
// maquinas cobran por hora- y el generico acabaria recibiendo el nombre de la
// columna por parametro, que es peor que repetir.
//
// BuscarConPrecio devuelve las clases de Anovo.Entities.Vistas.Catalogos, no
// la entidad: el precio vive en otra tabla y la entidad no lo tiene. Pedirlo
// fila por fila serian 51 consultas por pagina.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Catalogos,
  Anovo.Entities.Vistas.Catalogos;

type
  IMaterialRepository = interface(IMVCRepository<TMateriales>)
    ['{2F7A9C14-5B60-4E83-9D27-A1C4E8F05B36}']

    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False): TObjectList<TMateriales>;

    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;

    // Lo que necesita la pantalla de armado de la cotizacion: nombre y precio
    // en una sola consulta.
    function BuscarConPrecio(const ATexto: string;
      const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False)
      : TObjectList<TMaterialConPrecio>;

    // Devuelve nil si no existe.
    function ObtenerPorCodigo(const ACodigo: string): TMateriales;

    // AExcluirId es el material que se esta editando, para que no choque
    // consigo mismo. Al crear se pasa 0.
    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  IMaterialPrecioRepository = interface(IMVCRepository<TMaterialesPrecios>)
    ['{6D3B08E5-4A91-47C2-B5F0-9E27C1A3D486}']

    // Nil si el material todavia no tiene precio cargado.
    function PrecioVigenteDe(const AMaterialId: Integer): TMaterialesPrecios;
    function HistorialDe(const AMaterialId: Integer)
      : TObjectList<TMaterialesPrecios>;
  end;

  IManoObraRepository = interface(IMVCRepository<TManoObra>)
    ['{8E51C7D0-3F26-4B94-A0D8-5C73B9E1F248}']

    // ACategoriaId en 0 son todas.
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False;
      const ACategoriaId: Integer = 0): TObjectList<TManoObra>;

    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False;
      const ACategoriaId: Integer = 0): Int64;

    function BuscarConPrecio(const ATexto: string;
      const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False;
      const ACategoriaId: Integer = 0): TObjectList<TManoObraConPrecio>;

    function ObtenerPorCodigo(const ACodigo: string): TManoObra;

    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  IManoObraPrecioRepository = interface(IMVCRepository<TManoObraPrecios>)
    ['{1A9F42B8-7C03-4D56-8E91-B4D06F2A5C73}']

    function PrecioVigenteDe(const AManoObraId: Integer): TManoObraPrecios;
    function HistorialDe(const AManoObraId: Integer)
      : TObjectList<TManoObraPrecios>;
  end;

  // Catalogo fijo: se lee entero y no se edita desde la API.
  IManoObraCategoriaRepository = interface(IMVCRepository<TManoObraCategoria>)
    ['{5C08E3A7-9B14-42F6-A7D3-0E85C61B9F42}']
    function Todas: TObjectList<TManoObraCategoria>;
  end;

  IMaquinaRepository = interface(IMVCRepository<TMaquinas>)
    ['{7B26D0F9-4E58-41A3-92C7-6D19B5E08A34}']

    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False): TObjectList<TMaquinas>;

    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;

    function BuscarConPrecio(const ATexto: string;
      const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False)
      : TObjectList<TMaquinaConPrecio>;

    function ObtenerPorCodigo(const ACodigo: string): TMaquinas;

    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  IMaquinaPrecioRepository = interface(IMVCRepository<TMaquinasPrecios>)
    ['{3D74B1C6-08A2-4F95-B6E0-8C53D271A9F5}']

    function PrecioVigenteDe(const AMaquinaId: Integer): TMaquinasPrecios;
    function HistorialDe(const AMaquinaId: Integer)
      : TObjectList<TMaquinasPrecios>;
  end;

  ITipoTrabajoRepository = interface(IMVCRepository<TTiposTrabajo>)
    ['{9F40A5E2-6C87-43B1-8D2A-17E95B0C4D68}']

    function Todos(const AIncluirInactivos: Boolean = False)
      : TObjectList<TTiposTrabajo>;

    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

implementation

end.
