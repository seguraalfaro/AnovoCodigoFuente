unit Anovo.Vistas.Intf.SolicitudesAsistente;

// Contrato de la vista de solicitudes de la oficina: la cola comun de las
// que nadie ha tomado.

interface

uses
  Anovo.Vistas.Intf.Listado,
  System.Generics.Collections,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes,
  Anovo.PeriodoBusqueda;

type
  TAccionCola = (acTomar);
  TAccionesCola = set of TAccionCola;

  IVistaSolicitudesAsistente = interface(IVistaListado)
    ['{8346550D-2F58-4EDB-9829-B75763CB7E68}']
    procedure MostrarAcciones(const AAcciones: TAccionesCola);
    procedure MostrarPeriodo(const APeriodo: TPeriodoBusqueda);
    procedure MostrarCola(const AFilas: TObjectList<TSolicitudPorCotizarDTO>);
    procedure AbrirCotizacion(const AId: Integer);
    function Confirmar(const AMensaje: string): Boolean;
  end;

implementation

end.
