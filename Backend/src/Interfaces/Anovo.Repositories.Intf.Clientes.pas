unit Anovo.Repositories.Intf.Clientes;

// Contrato del repositorio de clientes.
//
// El CRUD directo -traer por id, guardar, borrar- ya lo da IMVCRepository<T>
// del framework y no hace falta escribirlo. Aqui van solo las consultas que
// tienen nombre propio en el negocio.
//
// El corte no es el tamano de la consulta sino si significa algo: ObtenerPorId
// es generico; BuscarPorUuidLocal no lo es, aunque sea un WHERE de una linea,
// porque es la pieza que hace idempotente reenviar un alta desde el telefono.
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
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AIncluirInactivos: Boolean = False): TObjectList<TClientes>;

    // El total de la busqueda, para que el cliente sepa cuantas paginas hay.
    function ContarBusqueda(const ATexto: string;
      const AIncluirInactivos: Boolean = False): Int64;

    // Devuelve nil si no existe. Es la clave de la sincronizacion: el telefono
    // reenvia altas que no sabe si llegaron, y sin esto crearia duplicados.
    function ObtenerPorUuidLocal(const AUuid: string): TClientes;

    function ContactosDe(const AClienteId: Integer): TObjectList<TClienteContactos>;
  end;

implementation

end.
