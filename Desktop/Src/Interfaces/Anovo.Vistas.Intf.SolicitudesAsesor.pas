unit Anovo.Vistas.Intf.SolicitudesAsesor;

// Contrato de la vista de la seccion Solicitudes.

interface

uses
  Anovo.Vistas.Intf.Listado,
  System.Generics.Collections,
  Anovo.DTOs.Dashboard,
  Anovo.PeriodoBusqueda;

type
  TAccionSolicitudAsesor = (asaVer);
  TAccionesSolicitudAsesor = set of TAccionSolicitudAsesor;

  IVistaSolicitudesAsesor = interface(IVistaListado)
    ['{01EEFFBF-6CAF-4626-BAB3-E7D3DC13325D}']
    procedure MostrarAcciones(const AAcciones: TAccionesSolicitudAsesor);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure AbrirCotizacion(const AId: Integer);
    procedure MostrarSolicitudes(const AFilas: TObjectList<TSolicitudAsesorDTO>);
  end;

implementation

end.
