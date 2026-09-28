unit Anovo.Services.Intf.Cotizaciones;

// Contrato del servicio de cotizaciones.

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

    function Bandeja(const AUsuarioId: Integer; const ATexto: string;
      const APagina, APorPagina: Integer): TBandejaPaginaDTO;
    function Obtener(const AId: Integer): TCotizacionDTO;
    function ObtenerPorNumero(const ANumero: Integer): TCotizacionDTO;

    function CrearDesdeSolicitud(const ADto: TCotizacionNuevaDTO): Integer;

    procedure Actualizar(const AId: Integer;
      const ADto: TCotizacionEdicionDTO);

    function Detalle(const AId: Integer): TObjectList<TLineaDTO>;
    function AgregarLinea(const AId: Integer;
      const ADto: TLineaNuevaDTO): Integer;
    procedure ActualizarLinea(const AId, ALineaId: Integer;
      const ADto: TLineaNuevaDTO);
    procedure EliminarLinea(const AId, ALineaId: Integer);

    procedure Recalcular(const AId: Integer);

    procedure AplicarAjuste(const AId: Integer; const ADto: TAjusteDTO);

    procedure Presentar(const AId: Integer);
    procedure Aprobar(const AId: Integer);
    procedure Rechazar(const AId: Integer; const ADto: TMotivoDTO);
    procedure Devolver(const AId: Integer; const ADto: TMotivoDTO);
    procedure Enviar(const AId: Integer);

    function EnviadasSinRespuesta(const ADias: Integer)
      : TObjectList<TCotizacionDTO>;
  end;

implementation

end.
