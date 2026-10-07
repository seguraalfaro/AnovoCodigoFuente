unit Anovo.DTOs.Sesion;

// DTOs de /api/sesion y /api/version.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type
  [MVCNameCase(ncSnakeCase)]
  TSesionDTO = class
  private
    fRol: string;
    fPermisos: TArray<string>;
  public
    property Rol: string read fRol write fRol;
    property Permisos: TArray<string> read fPermisos write fPermisos;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCuentaDTO = class
  private
    fNombre: string;
    fCorreo: string;
    fRol: string;
    fClaveCambiada: NullableTDateTime;
    fPermisosAdicionales: Integer;
    fPermisosQuitados: Integer;
  public
    property Nombre: string read fNombre write fNombre;
    property Correo: string read fCorreo write fCorreo;
    property Rol: string read fRol write fRol;
    property ClaveCambiada: NullableTDateTime read fClaveCambiada
      write fClaveCambiada;
    property PermisosAdicionales: Integer read fPermisosAdicionales
      write fPermisosAdicionales;
    property PermisosQuitados: Integer read fPermisosQuitados
      write fPermisosQuitados;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCambioClaveDTO = class
  private
    fClaveActual: string;
    fClaveNueva: string;
  public
    property ClaveActual: string read fClaveActual write fClaveActual;
    property ClaveNueva: string read fClaveNueva write fClaveNueva;
  end;

  [MVCNameCase(ncSnakeCase)]
  TVersionDTO = class
  private
    fServidor: string;
    fMovil: string;
    fAvisoPrivacidad: string;
    fBaseDatos: string;
  public
    property Servidor: string read fServidor write fServidor;
    property Movil: string read fMovil write fMovil;
    property AvisoPrivacidad: string read fAvisoPrivacidad
      write fAvisoPrivacidad;
    property BaseDatos: string read fBaseDatos write fBaseDatos;
  end;

implementation

end.
