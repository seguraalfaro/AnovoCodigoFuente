unit Anovo.Services.Intf.Cotizaciones;

// Contrato del servicio de cotizaciones.
//
// El servicio no sabe nada de HTTP: lanza las excepciones de Anovo.Errors y el
// manejador global las traduce.
//
// ASoloPropias es el alcance: quien tiene ver_aprobadas_propias y no
// ver_todas solo ve las suyas. Lo decide el controller con los permisos.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones;

type
  ICotizacionService = interface
    ['{E3061B58-2D47-4F9A-B0C5-78A16D052C94}']

    function Buscar(const ATexto, AEstado: string; const AClienteId: Integer;
      const ADesde, AHasta: TDateTime; const ASoloPropias: Boolean;
      const AUsuarioId, APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TCotizacionDTO>;

    function Obtener(const AId: Integer): TCotizacionDTO;
    function ObtenerPorNumero(const ANumero: Integer): TCotizacionDTO;

    // Nace en borrador, con el consecutivo tomado del generador y el cliente
    // arrastrado de la solicitud.
    function CrearDesdeSolicitud(const ADto: TCotizacionNuevaDTO): Integer;

    procedure Actualizar(const AId: Integer;
      const ADto: TCotizacionEdicionDTO);

    // DETALLE. Cada cambio recalcula los totales de la cabecera.
    function Detalle(const AId: Integer): TObjectList<TLineaDTO>;
    function AgregarLinea(const AId: Integer;
      const ADto: TLineaNuevaDTO): Integer;
    procedure ActualizarLinea(const AId, ALineaId: Integer;
      const ADto: TLineaNuevaDTO);
    procedure EliminarLinea(const AId, ALineaId: Integer);

    // Vuelve a sumar el detalle y reescribe subtotales, impuesto y total.
    procedure Recalcular(const AId: Integer);

    // El ajuste comercial sobre el costo. Con porcentaje distinto de cero, el
    // motivo es obligatorio.
    procedure AplicarAjuste(const AId: Integer; const ADto: TAjusteDTO);

    // ESTADOS. borrador -> en_proceso -> enviada -> aprobada | rechazada.
    procedure Enviar(const AId: Integer);
    procedure Aprobar(const AId: Integer);
    procedure Rechazar(const AId: Integer; const ADto: TMotivoDTO);
    // Devolver al asistente con observaciones: vuelve a en_proceso.
    procedure Devolver(const AId: Integer; const ADto: TMotivoDTO);

    // El recordatorio de la HU-07.
    function EnviadasSinRespuesta(const ADias: Integer)
      : TObjectList<TCotizacionDTO>;
  end;

implementation

end.
