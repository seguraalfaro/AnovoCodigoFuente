unit Anovo.Repositories.Intf.Solicitudes;

// Contratos de los repositorios del modulo de solicitudes: uno por tabla.
//
// El CRUD directo lo da IMVCRepository<T>. Aqui van las consultas con nombre
// propio en el negocio.
//
// Los tres llevan ObtenerPorUuidLocal. No es una consulta mas: es la pieza que
// hace idempotente reenviar lo que capturo el telefono sin conexion. El movil
// guarda con un uuid propio y reintenta cuando hay senal, sin saber si el
// envio anterior llego.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Solicitudes;

type
  ISolicitudRepository = interface(IMVCRepository<TSolicitudes>)
    ['{B7E2049C-3A61-4D85-92F7-05C8B1E6A374}']

    // AAsesorId en 0 son todos: lo pone el servicio segun el permiso. Estado
    // vacio son todos. Las fechas en cero no filtran.
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AAsesorId: Integer = 0; const AEstado: string = '';
      const ADesde: TDateTime = 0; const AHasta: TDateTime = 0)
      : TObjectList<TSolicitudes>;

    function ContarBusqueda(const ATexto: string;
      const AAsesorId: Integer = 0; const AEstado: string = '';
      const ADesde: TDateTime = 0; const AHasta: TDateTime = 0): Int64;

    // Nil si no existe: no encontrarlo es el caso normal, significa que el
    // registro todavia no habia subido.
    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudes;
    function ExisteUuidLocal(const AUuid: string): Integer;

    // Las que estan en el estado dado y todavia no tienen cotizacion. Es la
    // bandeja del asistente.
    function PendientesDeCotizar(const AEstado: string)
      : TObjectList<TSolicitudes>;
  end;

  ISolicitudMedidaRepository = interface(IMVCRepository<TSolicitudMedidas>)
    ['{4F8A61D3-9C27-4E50-B6A9-2D73E05C1F86}']

    function MedidasDe(const ASolicitudId: Integer)
      : TObjectList<TSolicitudMedidas>;
    function MedidaDe(const ASolicitudId, AMedidaId: Integer)
      : TSolicitudMedidas;
    // Las que cuelgan de un croquis, para pintar sus etiquetas encima.
    function MedidasDeCroquis(const ACroquisId: Integer)
      : TObjectList<TSolicitudMedidas>;
    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudMedidas;
  end;

  ISolicitudAdjuntoRepository = interface(IMVCRepository<TSolicitudAdjuntos>)
    ['{6C05B9E1-7D43-42A8-95F0-8B1467A3D29C}']

    // Sin el BLOB: la consulta nombra sus columnas y deja fuera CONTENIDO y
    // CONTENIDO_JSON. Listar treinta fotos no debe mover treinta fotos.
    function AdjuntosDe(const ASolicitudId: Integer)
      : TObjectList<TSolicitudAdjuntos>;

    // Este si trae el contenido: es la descarga de un adjunto concreto.
    function AdjuntoDe(const ASolicitudId, AAdjuntoId: Integer)
      : TSolicitudAdjuntos;

    function CroquisDe(const ASolicitudId: Integer)
      : TObjectList<TSolicitudAdjuntos>;
    function ObtenerPorUuidLocal(const AUuid: string): TSolicitudAdjuntos;
  end;

implementation

end.
