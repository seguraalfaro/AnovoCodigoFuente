unit Anovo.Repositories.Intf.Auditoria;

// Solo consulta, a proposito: no hereda de IMVCRepository<TAuditoria>.
// El backend tiene GRANT SELECT sobre AUDITORIA y nada mas -quien escribe es
// el disparador, con los privilegios del dueno de la tabla-, asi que heredar
// el CRUD prometeria un Insert que el motor rechaza.
//
// La bitacora no se corrige ni se borra: esa es la garantia que la hace
// servir de evidencia.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Auditoria;

type

  IAuditoriaRepository = interface(IMVCRepository<TAuditoria>)
    ['{B25B2BBC-2DD4-4E00-828C-A2B2F784BE65}']

    // El rango de fechas no lleva valor por defecto a proposito: sin ventana,
    // la consulta barre la bitacora entera, que es la tabla que mas crece.
    // Quien llama decide el rango, aunque sea el mes corriente.
    //
    // Lo demas filtra si viene: 0 es cualquier usuario, vacio es cualquier
    // entidad o accion. ATexto busca dentro del detalle.
    function Buscar(const ADesde, AHasta: TDateTime;
      const APagina, APorPagina: Integer; const AUsuarioId: Integer = 0;
      const AEntidad: string = ''; const AAccion: string = '';
      const ATexto: string = ''): TObjectList<TAuditoria>;

    // El total de la busqueda, para saber cuantas paginas hay.
    function ContarBusqueda(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer = 0; const AEntidad: string = '';
      const AAccion: string = ''; const ATexto: string = ''): Int64;

    // La bitacora de una fila: quien la toco y cuando. Es lo que pide la ficha
    // del cliente o de la cotizacion, no la pantalla de auditoria.
    function DeLaEntidad(const AEntidad: string; const AEntidadId: Integer)
      : TObjectList<TAuditoria>;
  end;

implementation

end.
