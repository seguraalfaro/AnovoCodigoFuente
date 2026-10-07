unit Anovo.Vistas.Intf.Configuracion;

// Contratos de las vistas de Configuracion.

interface

uses
  Anovo.DTOs.Empresa,
  Anovo.DTOs.Sesion;

type
  TResultadoConexion = record
    Conectado: Boolean;
    Milisegundos: Int64;
    Mensaje: string;
    VersionServidor: string;
    VersionMovil: string;
    VersionAviso: string;
    VersionBaseDatos: string;
  end;

  IVistaPruebaConexion = interface
    ['{2A6C8E14-B35D-4F07-9C21-7E4D0B8A6F39}']
    procedure MostrarProbando;
    procedure MostrarConexion(const AResultado: TResultadoConexion);
  end;

  IVistaConexion = interface(IVistaPruebaConexion)
    ['{8D3E5A17-6B29-4C40-9F83-1E7A2C5D0B64}']
    procedure MostrarUrlInvalida(const AMensaje: string);
    procedure UrlGuardada;
  end;

  IVistaConfiguracion = interface(IVistaPruebaConexion)
    ['{5F1B3D72-8C94-4E26-A0B7-3D6E9F2C1A58}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarCuenta(const ADatos: TCuentaDTO);
    procedure MostrarPermisosPropios(const ATexto: string);
    procedure MostrarError(const AMensaje: string);
    procedure MostrarMinutosAvisos(const AMinutos: Integer);
    procedure MostrarSeccionEmpresa(const AVisible: Boolean);
    procedure MostrarEmpresa(const AEmpresa: TEmpresaDTO);
    procedure EmpresaGuardada;
    procedure ParametrosGuardados;
  end;

implementation

end.
