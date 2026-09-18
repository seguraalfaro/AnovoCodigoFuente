unit Anovo.Vistas.Intf.Principal;

{ Lo que el presentador de la ventana principal necesita de la pantalla, y
  nada mas. TSeccion vive aqui y no en el formulario: el presentador la usa y
  no puede depender de VCL. }

interface

type
  TSeccion = (secDashboard, secCotizaciones, secGeneracion, secDetalle,
    secMateriales, secClientes, secReportes, secBandeja, secGerencia,
    secUsuarios, secRoles, secConfiguracion);
  TSecciones = set of TSeccion;

  IVistaPrincipal = interface
    ['{C4E81B27-9A3D-4F60-B5C2-7D19E0A4F638}']
    procedure MostrarUsuario(const ANombre, ARol, AIniciales: string);
    procedure MostrarSecciones(const ASecciones: TSecciones);
    procedure AbrirSeccion(const ASeccion: TSeccion);
  end;

implementation

end.
