unit Anovo.Repositories.Intf.Cotizaciones;

// Contratos de los repositorios de cotizaciones y
// su detalle.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Cotizaciones;

type
  ICotizacionRepository = interface(IMVCRepository<TCotizaciones>)
    ['{D18C0374-6F92-4A5B-8E71-24B9C5063FA8}']

    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AEstado: string = ''; const AClienteId: Integer = 0;
      const AElaboradaPor: Integer = 0; const ADesde: TDateTime = 0;
      const AHasta: TDateTime = 0): TObjectList<TCotizaciones>;

    function ContarBusqueda(const ATexto: string; const AEstado: string = '';
      const AClienteId: Integer = 0; const AElaboradaPor: Integer = 0;
      const ADesde: TDateTime = 0; const AHasta: TDateTime = 0): Int64;

    function ObtenerPorNumero(const ANumero: Integer): TCotizaciones;

    function SiguienteNumero: Integer;

    function DeSolicitud(const ASolicitudId: Integer)
      : TObjectList<TCotizaciones>;

    function EnviadasSinRespuesta(const ADias: Integer)
      : TObjectList<TCotizaciones>;
  end;

  ICotizacionDetalleRepository = interface(IMVCRepository<TCotizacionDetalle>)
    ['{0B5E4A29-8C16-47D3-95F8-61A7D3C0E482}']

    function DetalleDe(const ACotizacionId: Integer)
      : TObjectList<TCotizacionDetalle>;
    function LineaDe(const ACotizacionId, ALineaId: Integer)
      : TCotizacionDetalle;
    function SiguienteOrden(const ACotizacionId: Integer): Integer;

    procedure SubtotalesDe(const ACotizacionId: Integer;
      out AMateriales, AManoObra, AMaquina: Currency);
  end;

implementation

end.
