unit Anovo.Vistas.Intf.Principal;

// Contrato de la ventana principal y las secciones del menu.

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.DTOs.Cotizaciones;

type
  TSeccion = (secDashboardSupervisor, secDashboardCuentas, secDashboardAsesor,
    secDashboardAsistente,
    secSolicitudes, secBandeja,
    secCotizaciones, secGeneracion, secDetalle, secClientes, secMateriales,
    secReportes, secGerencia, secUsuarios, secRoles, secAuditoria,
    secConfiguracion);
  TSecciones = set of TSeccion;

  TAccionNotificacion = (anAbrir, anDescartar);
  TAccionesNotificacion = set of TAccionNotificacion;

  TDescartarNotificacion = reference to procedure(const AId, ANumero: Integer;
    const AListo: TProc; const AOcupado: TProc<Boolean>);

  IVistaPrincipal = interface
    ['{C4E81B27-9A3D-4F60-B5C2-7D19E0A4F638}']
    procedure MostrarUsuario(const ANombre, ARol, AIniciales: string);
    procedure MostrarSecciones(const ASecciones: TArray<TSeccion>);
    procedure AbrirSeccion(const ASeccion: TSeccion);
    procedure ProgramarAvisos(const AMinutos: Integer);
    procedure MostrarAviso(const ASeccion: TSeccion;
      const ACantidad: Integer);
    procedure MostrarCampana(const AVisible: Boolean);
    procedure MostrarNotificaciones(const ACantidad: Integer);
    procedure MostrarCampanaOcupada(const AOcupada: Boolean);
    function PreguntarNotificaciones(const ACantidad: Integer): Boolean;
    function AbrirNotificaciones(const ACotizaciones
      : TObjectList<TCotizacionDTO>;
      const AAcciones: TAccionesNotificacion): Integer;
    function Confirmar(const AMensaje: string): Boolean;
    procedure MostrarError(const AMensaje: string);
    procedure AbrirCotizacion(const AId: Integer);
  end;

implementation

end.
