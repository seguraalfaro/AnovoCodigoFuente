unit Anovo.Vistas.Intf.Principal;

{ Lo que el presentador de la ventana principal necesita de la pantalla, y
  nada mas. TSeccion vive aqui y no en el formulario: el presentador la usa y
  no puede depender de VCL. }

interface

type
  TSeccion = (secDashboard, secDashboardCuentas, secSolicitudes, secBandeja,
    secCotizaciones, secGeneracion, secDetalle, secClientes, secMateriales,
    secReportes, secGerencia, secUsuarios, secRoles, secConfiguracion);
  TSecciones = set of TSeccion;

  IVistaPrincipal = interface
    ['{C4E81B27-9A3D-4F60-B5C2-7D19E0A4F638}']
    procedure MostrarUsuario(const ANombre, ARol, AIniciales: string);
    { Ya filtradas y en el orden del menu: la vista solo las dibuja. }
    procedure MostrarSecciones(const ASecciones: TArray<TSeccion>);
    procedure AbrirSeccion(const ASeccion: TSeccion);
  end;

implementation

end.
