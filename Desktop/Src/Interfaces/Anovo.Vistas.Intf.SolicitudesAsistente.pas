unit Anovo.Vistas.Intf.SolicitudesAsistente;

// Contrato de la vista de solicitudes del asistente: la cola
// comun y las que tomo.

interface

uses
  Anovo.Vistas.Intf.Listado,
  System.Generics.Collections,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes;

type
  TModoSolicitudes = (msCola, msEnTrabajo);
  TAccionCola = (acTomar, acAbrir);
  TAccionesCola = set of TAccionCola;

  IVistaSolicitudesAsistente = interface(IVistaListado)
    ['{8346550D-2F58-4EDB-9829-B75763CB7E68}']
    procedure MostrarAcciones(const AAcciones: TAccionesCola);
    procedure MostrarModo(const AModo: TModoSolicitudes);
    procedure MostrarCola(const AFilas: TObjectList<TSolicitudPorCotizarDTO>);
    procedure MostrarEnTrabajo(const AFilas
      : TObjectList<TSolicitudEnTrabajoDTO>);
    procedure AbrirCotizacion(const AId: Integer);
    function Confirmar(const AMensaje: string): Boolean;
  end;

implementation

end.
