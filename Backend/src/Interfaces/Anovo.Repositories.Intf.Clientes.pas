unit Anovo.Repositories.Intf.Clientes;

// Contratos de los repositorios del modulo de clientes: uno por tabla.
//
// El CRUD directo -traer por id, guardar, borrar- ya lo da IMVCRepository<T>
// del framework y no hace falta escribirlo. Aqui van solo las consultas que
// tienen nombre propio en el negocio.
//
// El corte no es el tamano de la consulta sino si significa algo: ObtenerPorId
// es generico; BuscarPorUuidLocal no lo es, aunque sea un WHERE de una linea,
// porque es la pieza que hace idempotente reenviar un registro desde el
// telefono.
//
// Cada repositorio atiende solo su tabla. Lo que cruza tablas -que el cliente
// exista antes de listar sus contactos, que el registro con los datos
// completos entre junto- es regla de negocio y va en el servicio, que recibe
// los tres.
//
// El servicio depende de esto y no de la ORM: cambiar de motor o de forma de
// acceder a los datos no deberia propagarse hacia arriba.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Clientes;

type
  IClienteRepository = interface(IMVCRepository<TClientes>)
    ['{4C1E7A82-9D53-4F06-B7A4-1E85C3D920B6}']
    // Lo que el asesor escribe en el cuadro de busqueda del movil: tres letras
    // que pueden ser de un nombre, de una cedula o de un telefono.
    // AConsentimiento vacio es todos; si no, el estado a filtrar.
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False;
      const AConsentimiento: string = ''): TObjectList<TClientes>;

    // El total de la busqueda, para que el cliente sepa cuantas paginas hay.
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False;
      const AConsentimiento: string = ''): Int64;

    // Devuelve nil si no existe. Es la clave de la sincronizacion: el telefono
    // reenvia datos que no sabe si llegaron, y sin esto crearia duplicados.
    function ObtenerPorUuidLocal(const AUuid: string): TClientes;
    function ExitsUuidLocal(const AUuid: string): Integer;
  end;

  // CLIENTE_CONTACTOS
  IClienteContactoRepository = interface(IMVCRepository<TClienteContactos>)
    ['{E653F53C-69D0-4525-BDBB-5AAA283CD60C}']

    // Solo los activos, el principal primero. No comprueba que el cliente
    // exista: una lista vacia no distingue entre "no tiene" y "no existe", y
    // esa diferencia la resuelve el servicio.
    function ContactosDe(const AClienteId: Integer)
      : TObjectList<TClienteContactos>;
    function ContactoDe(const AClienteId, AContactoId: Integer)
      : TClienteContactos;
  end;

  // CLIENTE_CONSENTIMIENTO_HISTORIAL
  IConsentimientoRepository = interface
    (IMVCRepository<TClienteConsentimientoHistorial>)
    ['{A3119DD7-FEC7-467F-859F-4D0A6EE69C8B}']

    // El historial del cliente, el mas reciente primero.
    function HistorialDe(const AClienteId: Integer)
      : TObjectList<TClienteConsentimientoHistorial>;
  end;

implementation

end.
