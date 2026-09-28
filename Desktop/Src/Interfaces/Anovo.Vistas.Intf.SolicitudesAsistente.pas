unit Anovo.Vistas.Intf.SolicitudesAsistente;

// Contrato de la vista de solicitudes del asistente: la cola
// comun y las que tomo.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes;

type
  TModoSolicitudes = (msCola, msEnTrabajo);

  IVistaSolicitudesAsistente = interface
    ['{8346550D-2F58-4EDB-9829-B75763CB7E68}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarBusqueda(const ATexto: string;
      const APuedeLimpiar: Boolean);
    procedure MostrarModo(const AModo: TModoSolicitudes);
    procedure MostrarCola(const AFilas: TObjectList<TSolicitudPorCotizarDTO>);
    procedure MostrarEnTrabajo(const AFilas
      : TObjectList<TSolicitudEnTrabajoDTO>);
    procedure MostrarPaginacion(const APagina, ATotalPaginas: Integer;
      const ATotal: Int64);
    procedure MostrarError(const AMensaje: string);
  end;

implementation

end.
