unit Anovo.Api.Intf.Clientes;

// Contrato de la API de clientes, visto desde el escritorio.
//
// Devuelve los DTO del backend, no copias propias: si el servidor cambia un
// campo, esto deja de compilar en vez de recibir un dato vacio.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Clientes;

type
  IApiClientes = interface
    ['{2F6C9E14-8B3A-4D71-A5E2-0C94B7D1F386}']
    // La lista es de quien llama y la libera el. ATotal va aparte, como en el
    // servicio del servidor: es el total de la busqueda, no de la pagina.
    // AConsentimiento vacio es todos. Un servidor caido llega como
    // EAnovoSinConexion; un 403, como EAnovoApiError con Status 403.
    function Buscar(const ATexto, AConsentimiento: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TClienteDTO>;

    // La ficha del cliente. Los tres devuelven objetos nuevos y los libera
    // quien los recibe. Un cliente que no existe llega como EAnovoApiError
    // con Status 404.
    function Obtener(const AId: Integer): TClienteDTO;
    function Contactos(const AId: Integer): TObjectList<TContactoDTO>;
    function Consentimientos(const AId: Integer)
      : TObjectList<TConsentimientoDTO>;

    // El DTO lleva la objversion que trajo la ficha: si otra persona lo
    // cambio en el medio, el servidor responde 409 y aqui llega como
    // EAnovoApiError con Status 409.
    procedure Actualizar(const AId: Integer; const ADto: TClienteEdicionDTO);

    // Los dos devuelven el numero que asigno la base, que viene en la
    // cabecera Location de la respuesta 201.
    function Crear(const ADto: TClienteNuevoDTO): Integer;
    function CrearContacto(const AId: Integer;
      const ADto: TContactoNuevoDTO): Integer;
  end;

implementation

end.
