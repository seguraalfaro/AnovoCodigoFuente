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
      const ADesde, AHasta: TDateTime; const ARoles: TArray<string>;
      const AUsuarioId, APagina, APorPagina: Integer; out ATotal: Int64)
      : TObjectList<TCotizacionDTO>;

    function Bandeja(const AUsuarioId: Integer; const ATexto: string;
      const APagina, APorPagina: Integer): TBandejaPaginaDTO;
    function Obtener(const AId, AUsuarioId: Integer;
      const ARoles: TArray<string>): TCotizacionDTO;
    function ObtenerPorNumero(const ANumero, AUsuarioId: Integer;
      const ARoles: TArray<string>): TCotizacionDTO;

    function CrearDesdeSolicitud(const ADto: TCotizacionNuevaDTO): Integer;

    procedure Actualizar(const AId: Integer;
      const ADto: TCotizacionEdicionDTO);

    function Detalle(const AId, AUsuarioId: Integer;
      const ARoles: TArray<string>): TObjectList<TLineaDTO>;
    function Estados(const AId, AUsuarioId: Integer;
      const ARoles: TArray<string>): TObjectList<TEstadoCotizacionDTO>;
    function AgregarLinea(const AId: Integer;
      const ADto: TLineaNuevaDTO): Integer;
    procedure ActualizarLinea(const AId, ALineaId: Integer;
      const ADto: TLineaNuevaDTO);
    procedure EliminarLinea(const AId, ALineaId: Integer);

    procedure Recalcular(const AId: Integer);

    procedure AplicarAjuste(const AId: Integer; const ADto: TAjusteDTO);

    procedure Presentar(const AId: Integer);
    procedure DarVistoBueno(const AId: Integer);
    procedure RegistrarRespuesta(const AId: Integer;
      const ADto: TRespuestaClienteDTO);
    procedure Devolver(const AId: Integer; const ADto: TMotivoDTO);
    procedure Enviar(const AId: Integer);

    function EnviadasSinRespuesta: TObjectList<TCotizacionDTO>;
  end;

implementation

end.
