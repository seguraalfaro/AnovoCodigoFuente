unit Anovo.Repositories.Intf.Cotizaciones;

// Contratos de los repositorios de cotizaciones y
// su detalle.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Cotizaciones,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas;

type
  ICotizacionRepository = interface(IMVCRepository<TCotizaciones>)
    ['{D18C0374-6F92-4A5B-8E71-24B9C5063FA8}']

    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AEstado: string = ''; const AClienteId: Integer = 0;
      const AAsesorId: Integer = 0; const ADesde: TDateTime = 0;
      const AHasta: TDateTime = 0; const AElaboradaPor: Integer = 0)
      : TObjectList<TVCotizacionesListado>;

    function ContarBusqueda(const ATexto: string; const AEstado: string = '';
      const AClienteId: Integer = 0; const AAsesorId: Integer = 0;
      const ADesde: TDateTime = 0; const AHasta: TDateTime = 0;
      const AElaboradaPor: Integer = 0): Int64;

    function ObtenerPorNumero(const ANumero: Integer): TCotizaciones;

    function SiguienteNumero: Integer;


    function EnviadasSinRespuesta(const AElaboradaPor: Integer)
      : TObjectList<TCotizacionSinRespuesta>;
    function TotalesDe(const AId: Integer): TTotalesDeCotizacion;
    function Bandeja(const AUsuarioId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer)
      : TObjectList<TBandejaCotizaciones>;
    function ContarBandeja(const AUsuarioId: Integer; const ATexto: string;
      const ADesde, AHasta: TDateTime): Int64;
    function ResumenBandeja(const AUsuarioId: Integer)
      : TTrabajoUsuario;
    function TieneEnCurso(const ASolicitudId: Integer): Boolean;
    function VistaDe(const AId: Integer): TCotizacionListada;
    function HistorialDe(const AId: Integer): TObjectList<THistorialCotizacion>;
  end;

  ICotizacionDetalleRepository = interface(IMVCRepository<TCotizacionDetalle>)
    ['{0B5E4A29-8C16-47D3-95F8-61A7D3C0E482}']

    function DetalleDe(const ACotizacionId: Integer)
      : TObjectList<TCotizacionDetalle>;
    function LineaDe(const ACotizacionId, ALineaId: Integer)
      : TCotizacionDetalle;
    function SiguienteOrden(const ACotizacionId: Integer): Integer;

    function SubtotalDeLinea(const ACantidad, APrecio: Currency): Currency;
  end;

  ICotizacionEnvioRepository = interface(IMVCRepository<TCotizacionEnvios>)
    ['{3E7C1A94-6D25-4B80-9F13-A5C8E2D47B06}']
  end;

implementation

end.
