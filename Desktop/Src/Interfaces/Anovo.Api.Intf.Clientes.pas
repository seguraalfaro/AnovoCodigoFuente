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
  end;

implementation

end.
