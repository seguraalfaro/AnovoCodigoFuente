unit Anovo.Repositories.Intf.Catalogos;

// Contratos de los repositorios de catalogos,
// uno por tabla, y el de la lista Todos.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Catalogos,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas;

type
  IMaterialRepository = interface(IMVCRepository<TMateriales>)
    ['{2F7A9C14-5B60-4E83-9D27-A1C4E8F05B36}']

    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;

    function BuscarConPrecio(const ATexto: string;
      const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False)
      : TObjectList<TMaterialesConPrecio>;

    function ObtenerPorCodigo(const ACodigo: string): TMateriales;

    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  IMaterialPrecioRepository = interface(IMVCRepository<TMaterialesPrecios>)
    ['{6D3B08E5-4A91-47C2-B5F0-9E27C1A3D486}']

    function PrecioVigenteDe(const AMaterialId: Integer): TMaterialesPrecios;
    function HistorialDe(const AMaterialId: Integer)
      : TObjectList<TMaterialesPrecios>;
  end;

  IManoObraRepository = interface(IMVCRepository<TManoObra>)
    ['{8E51C7D0-3F26-4B94-A0D8-5C73B9E1F248}']

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

  IManoObraCategoriaRepository = interface(IMVCRepository<TManoObraCategoria>)
    ['{5C08E3A7-9B14-42F6-A7D3-0E85C61B9F42}']
    function Todas: TObjectList<TManoObraCategoria>;
  end;

  IMaquinaRepository = interface(IMVCRepository<TMaquinas>)
    ['{7B26D0F9-4E58-41A3-92C7-6D19B5E08A34}']

    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;

    function BuscarConPrecio(const ATexto: string;
      const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False)
      : TObjectList<TMaquinasConPrecio>;

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

    function Todos(const AIncluirInactivos: Boolean = False;
      const ATexto: string = ''): TObjectList<TTiposTrabajo>;

    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  ITipoMaterialRepository = interface(IMVCRepository<TTiposMaterial>)
    ['{3D7B1E90-5A42-4C68-9F13-B2E06C85A1D4}']
  end;

  IAcabadoRepository = interface(IMVCRepository<TAcabados>)
    ['{E58C2A17-0B93-4D6F-8A41-7F2D96C3B05E}']
  end;

  IUnidadMedidaRepository = interface(IMVCRepository<TUnidadesMedida>)
    ['{9E801450-401D-40E7-9417-C11223CD9A02}']

    function Todas(const AIncluirInactivas: Boolean = False;
      const ATexto: string = ''): TObjectList<TUnidadesMedida>;

    function ExisteNombre(const ANombre: string;
      const AExcluirId: Integer = 0): Boolean;
  end;

  ICatalogoTodosRepository = interface(IMVCRepository<TMateriales>)
    ['{BC32AB29-783D-4B48-9AAA-EFFF014686AB}']
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False)
      : TObjectList<TCatalogoTodos>;
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;
  end;

  IPrecioProgramadoRepository = interface
    (IMVCRepository<TPreciosProgramados>)
    ['{BDF59790-0698-43C4-B4F5-10F9874A86CA}']

    function PendientesDeMaterial(const AMaterialId: Integer)
      : TObjectList<TPreciosProgramados>;
    function PendientesDeManoObra(const AManoObraId: Integer)
      : TObjectList<TPreciosProgramados>;
    function PendientesDeMaquina(const AMaquinaId: Integer)
      : TObjectList<TPreciosProgramados>;
    function PorAplicar: TObjectList<TPreciosProgramados>;
  end;

implementation

end.
