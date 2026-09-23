unit Anovo.Api.Intf.Auditoria;

// Contrato de la API de auditoria, visto desde el escritorio.
//
// Devuelve los DTO del backend, no copias propias: si el servidor cambia un
// campo, esto deja de compilar en vez de recibir un dato vacio.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Auditoria;

type
  IApiAuditoria = interface
    ['{9C4E7B03-1A58-4F26-B8D1-6E05A93C7F24}']

    // La lista es de quien llama y la libera el. ATotal va aparte: es el total
    // de la busqueda, no de la pagina.
    //
    // ASoloCuentas escoge la ruta, no un filtro: quien tiene
    // auditoria.ver_cuentas y no auditoria.ver_toda solo puede pedir
    // /api/auditoria/cuentas, y la otra le responde 403. Lo decide el
    // presentador con los permisos de la sesion.
    //
    // AEntidad y AAccion vacios son todas. Un servidor caido llega como
    // EAnovoSinConexion; un 403, como EAnovoApiError con Status 403.
    function Buscar(const ASoloCuentas: Boolean;
      const ADesde, AHasta: TDateTime;
      const AEntidad, AAccion, ATexto: string;
      const APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TAuditoriaDTO>;

    // La bitacora de una fila, sin paginar: la de un cliente o una cotizacion
    // es corta por definicion.
    function DeLaEntidad(const AEntidad: string; const AEntidadId: Integer)
      : TObjectList<TAuditoriaDTO>;
  end;

implementation

end.
