unit Anovo.Vistas.Intf.Cotizaciones;

// Contrato del listado de cotizaciones.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones,
  Anovo.PeriodoBusqueda;

type
  TFiltroCotizaciones = (fcTodas, fcBorrador, fcPendiente, fcDevuelta,
    fcVistoBueno, fcEnviada, fcAprobada, fcRechazada);

  TAccionListaCotizacion = (alcAbrir);
  TAccionesListaCotizacion = set of TAccionListaCotizacion;

  IVistaCotizaciones = interface
    ['{2F84B6D1-5C39-4E07-A812-7D0E9C3B5A64}']
    procedure MostrarAcciones(const AAcciones: TAccionesListaCotizacion);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarCotizaciones(const AFilas: TObjectList<TCotizacionDTO>);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
    procedure AbrirCotizacion(const AId: Integer);
  end;

implementation

end.
