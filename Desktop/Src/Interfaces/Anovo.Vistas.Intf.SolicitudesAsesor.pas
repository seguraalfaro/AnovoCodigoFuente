unit Anovo.Vistas.Intf.SolicitudesAsesor;

// Contrato de la vista de la seccion Solicitudes.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Dashboard;

type
  IVistaSolicitudesAsesor = interface
    ['{01EEFFBF-6CAF-4626-BAB3-E7D3DC13325D}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarPeriodo(const AHistorial: Boolean;
      const ADesde: TDateTime);
    procedure MostrarSolicitudes(const AFilas: TObjectList<TSolicitudAsesorDTO>);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
