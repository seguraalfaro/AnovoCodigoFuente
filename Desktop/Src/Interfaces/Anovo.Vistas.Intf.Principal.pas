unit Anovo.Vistas.Intf.Principal;

// Contrato de la ventana principal y las secciones del menu.

interface

type
  TSeccion = (secDashboardSupervisor, secDashboardCuentas, secDashboardAsesor,
    secDashboardAsistente,
    secSolicitudes, secBandeja,
    secCotizaciones, secGeneracion, secDetalle, secClientes, secMateriales,
    secReportes, secGerencia, secUsuarios, secRoles, secAuditoria,
    secConfiguracion);
  TSecciones = set of TSeccion;

  IVistaPrincipal = interface
    ['{C4E81B27-9A3D-4F60-B5C2-7D19E0A4F638}']
    procedure MostrarUsuario(const ANombre, ARol, AIniciales: string);
    procedure MostrarSecciones(const ASecciones: TArray<TSeccion>);
    procedure AbrirSeccion(const ASeccion: TSeccion);
    procedure ProgramarAvisos(const AMinutos: Integer);
    procedure MostrarAviso(const ASeccion: TSeccion;
      const ACantidad: Integer);
  end;

implementation

end.
