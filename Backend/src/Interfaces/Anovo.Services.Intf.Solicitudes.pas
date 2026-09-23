unit Anovo.Services.Intf.Solicitudes;

// Contrato del servicio de solicitudes.
//
// El servicio no sabe nada de HTTP: lanza las excepciones de Anovo.Errors y el
// manejador global las traduce.
//
// ASoloPropias y AAsesorId son el alcance. Quien tiene solicitudes.ver_propias
// y no ver_todas solo ve las suyas; lo decide el controller con los permisos
// de la sesion y el servicio filtra.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Solicitudes;

type
  ISolicitudService = interface
    ['{A25D8F63-70B4-49C1-8E06-3F91C7A4D052}']

    function Buscar(const ATexto, AEstado: string;
      const ADesde, AHasta: TDateTime; const ASoloPropias: Boolean;
      const AAsesorId, APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TSolicitudDTO>;

    function Obtener(const AId: Integer): TSolicitudDTO;

    // Devuelve el id. Si ya habia subido con ese uuid_local, devuelve el que
    // existe y no crea otra.
    function Crear(const ADto: TSolicitudNuevaDTO): Integer;

    procedure Actualizar(const AId: Integer; const ADto: TSolicitudEdicionDTO);

    // El envio del movil: solicitud, medidas y adjuntos en una transaccion,
    // idempotente por uuid_local en las tres tablas.
    function RegistrarCompleta(const ADto: TSolicitudCompletaDTO): Integer;

    // Sella FECHA_RECEPCION. Separa "se capturo en el campo" de "llego al
    // servidor", que es la diferencia con la que se miden los tiempos del
    // proceso.
    procedure MarcarRecibida(const AId: Integer);

    procedure CambiarEstado(const AId: Integer; const ADto: TCambioEstadoDTO);

    // Las que estan listas para cotizar y todavia no tienen cotizacion.
    function PendientesDeCotizar: TObjectList<TSolicitudDTO>;

    // MEDIDAS
    function Medidas(const AId: Integer): TObjectList<TMedidaDTO>;
    function AgregarMedida(const AId: Integer;
      const ADto: TMedidaNuevaDTO): Integer;
    procedure ActualizarMedida(const AId, AMedidaId: Integer;
      const ADto: TMedidaNuevaDTO);
    // Una medida si se borra: es un dato de captura, no un registro historico.
    procedure EliminarMedida(const AId, AMedidaId: Integer);

    // ADJUNTOS. La lista trae solo metadatos; el contenido se pide de a uno.
    function Adjuntos(const AId: Integer): TObjectList<TAdjuntoDTO>;
    function ObtenerAdjunto(const AId, AAdjuntoId: Integer)
      : TAdjuntoContenidoDTO;
    function AgregarAdjunto(const AId: Integer;
      const ADto: TAdjuntoNuevoDTO): Integer;
    // No se borra: se inactiva. Es la evidencia de lo que se midio.
    procedure InactivarAdjunto(const AId, AAdjuntoId: Integer);
  end;

implementation

end.
