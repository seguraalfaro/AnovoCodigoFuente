unit Anovo.Repositories.Intf.Cotizaciones;

// Contratos de los repositorios de cotizaciones: la cabecera y su detalle.
//
// El CRUD directo lo da IMVCRepository<T>. Aqui van las consultas con nombre
// propio en el negocio.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Cotizaciones;

type
  ICotizacionRepository = interface(IMVCRepository<TCotizaciones>)
    ['{D18C0374-6F92-4A5B-8E71-24B9C5063FA8}']

    // AElaboradaPor en 0 son todas: lo pone el servicio segun el permiso.
    function Buscar(const ATexto: string; const APagina, APorPagina: Integer;
      const AEstado: string = ''; const AClienteId: Integer = 0;
      const AElaboradaPor: Integer = 0; const ADesde: TDateTime = 0;
      const AHasta: TDateTime = 0): TObjectList<TCotizaciones>;

    function ContarBusqueda(const ATexto: string; const AEstado: string = '';
      const AClienteId: Integer = 0; const AElaboradaPor: Integer = 0;
      const ADesde: TDateTime = 0; const AHasta: TDateTime = 0): Int64;

    // Nil si no existe. El numero es el consecutivo que ve el cliente, no el
    // ID interno.
    function ObtenerPorNumero(const ANumero: Integer): TCotizaciones;

    // Del generador, no de un max(NUMERO): dos asistentes que graben a la vez
    // no pueden recibir el mismo numero.
    function SiguienteNumero: Integer;

    // Una solicitud puede acabar en varias si una se rechaza y se rehace.
    function DeSolicitud(const ASolicitudId: Integer)
      : TObjectList<TCotizaciones>;

    // El recordatorio de la HU-07: enviadas hace mas de los dias que se pidan
    // y sin respuesta.
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

    // Los tres subtotales de la cabecera, sin traer el detalle entero. Son
    // tres consultas y no una agrupada: el detalle de una cotizacion son unas
    // pocas lineas, y asi no hace falta una clase de proyeccion para recibir
    // el resultado.
    procedure SubtotalesDe(const ACotizacionId: Integer;
      out AMateriales, AManoObra, AMaquina: Currency);
  end;

implementation

end.
