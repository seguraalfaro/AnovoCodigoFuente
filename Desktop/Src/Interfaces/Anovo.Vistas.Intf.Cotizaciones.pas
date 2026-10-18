unit Anovo.Vistas.Intf.Cotizaciones;

// Contrato del listado de cotizaciones.

interface

uses
  Anovo.Vistas.Intf.Listado,
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones,
  Anovo.PeriodoBusqueda;

type
  TFiltroCotizaciones = (fcTodas, fcBorrador, fcPendiente, fcDevuelta,
    fcVistoBueno, fcEnviada, fcAprobada, fcRechazada, fcDescartada);

  TAccionListaCotizacion = (alcAbrir);
  TAccionesListaCotizacion = set of TAccionListaCotizacion;

  IVistaCotizaciones = interface(IVistaListado)
    ['{2F84B6D1-5C39-4E07-A812-7D0E9C3B5A64}']
    procedure MostrarAcciones(const AAcciones: TAccionesListaCotizacion);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure MostrarCotizaciones(const AFilas: TObjectList<TCotizacionDTO>);
    procedure AbrirCotizacion(const AId: Integer);
  end;

implementation

end.
