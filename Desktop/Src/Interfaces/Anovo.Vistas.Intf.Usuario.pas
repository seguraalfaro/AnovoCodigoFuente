unit Anovo.Vistas.Intf.Usuario;

// Contrato de la ventana de un usuario: datos de la cuenta, sus telefonos y
// permisos adicionales o quitados sobre el paquete basico de su rol.

interface

uses
  System.Generics.Collections,
  MVCFramework.Nullables,
  Anovo.DTOs.Usuarios,
  Anovo.DTOs.Roles;

type
  TFilaPermiso = class
  private
    FPermisoId: Integer;
    FModulo: string;
    FNombre: string;
    FTiene: Boolean;
    FDelRol: Boolean;
    FTieneOriginal: Boolean;
    FMotivo: string;
  public
    property PermisoId: Integer read FPermisoId write FPermisoId;
    property Modulo: string read FModulo write FModulo;
    property Nombre: string read FNombre write FNombre;
    property Tiene: Boolean read FTiene write FTiene;
    property DelRol: Boolean read FDelRol write FDelRol;
    property TieneOriginal: Boolean read FTieneOriginal write FTieneOriginal;
    property Motivo: string read FMotivo write FMotivo;
  end;

  TFilaTelefono = class
  private
    FID: Integer;
    FNombre: string;
    FActivo: Boolean;
    FMotivo: string;
    FFechaCreacion: NullableTDateTime;
    FFechaUltimoUso: NullableTDateTime;
    FInactivar: NullableBoolean;
  public
    property ID: Integer read FID write FID;
    property Nombre: string read FNombre write FNombre;
    property Activo: Boolean read FActivo write FActivo;
    property Motivo: string read FMotivo write FMotivo;
    property FechaCreacion: NullableTDateTime read FFechaCreacion
      write FFechaCreacion;
    property FechaUltimoUso: NullableTDateTime read FFechaUltimoUso
      write FFechaUltimoUso;
    property Inactivar: NullableBoolean read FInactivar write FInactivar;
  end;

  IVistaUsuario = interface
    ['{E6A41C83-2B97-4D05-8F3A-C17D92B0E658}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarRoles(const ARoles: TObjectList<TRolDTO>);
    procedure MostrarUsuario(const AUsuario: TUsuarioDTO);
    procedure MostrarPermisos(const AFilas: TObjectList<TFilaPermiso>);
    procedure MostrarTelefonos(const AFilas: TObjectList<TFilaTelefono>);
    procedure MostrarGuardando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    procedure Guardado;
  end;

implementation

end.
