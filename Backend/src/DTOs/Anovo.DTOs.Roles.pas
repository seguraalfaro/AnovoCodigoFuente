unit Anovo.DTOs.Roles;

// DTOs de roles y de la matriz de permisos.
// Compartidos con el escritorio.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons;

type

  [MVCNameCase(ncSnakeCase)]
  TRolDTO = class
  private
    fID: Integer;
    fCodigo: string;
    fNombre: string;
    fAmbito: string;
    fUsuariosActivos: Integer;
  public
    property ID: Integer read fID write fID;
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Ambito: string read fAmbito write fAmbito;
    property UsuariosActivos: Integer read fUsuariosActivos
      write fUsuariosActivos;
  end;

  [MVCNameCase(ncSnakeCase)]
  TPermisoDTO = class
  private
    fID: Integer;
    fCodigo: string;
    fNombre: string;
    fModulo: string;
    fAmbito: string;
  public
    property ID: Integer read fID write fID;
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Modulo: string read fModulo write fModulo;
    property Ambito: string read fAmbito write fAmbito;
  end;

  [MVCNameCase(ncSnakeCase)]
  TAsignacionDTO = class
  private
    fRolId: Integer;
    fPermisoId: Integer;
  public
    property RolId: Integer read fRolId write fRolId;
    property PermisoId: Integer read fPermisoId write fPermisoId;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMatrizPermisosDTO = class
  private
    fRoles: TObjectList<TRolDTO>;
    fPermisos: TObjectList<TPermisoDTO>;
    fAsignaciones: TObjectList<TAsignacionDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    [MVCListOf(TRolDTO)]
    property Roles: TObjectList<TRolDTO> read fRoles write fRoles;
    [MVCListOf(TPermisoDTO)]
    property Permisos: TObjectList<TPermisoDTO> read fPermisos
      write fPermisos;
    [MVCListOf(TAsignacionDTO)]
    property Asignaciones: TObjectList<TAsignacionDTO> read fAsignaciones
      write fAsignaciones;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCambioPermisoDTO = class
  private
    fRolId: Integer;
    fPermisoId: Integer;
    fAsignado: Boolean;
  public
    property RolId: Integer read fRolId write fRolId;
    property PermisoId: Integer read fPermisoId write fPermisoId;
    property Asignado: Boolean read fAsignado write fAsignado;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCambiosMatrizDTO = class
  private
    fMotivo: string;
    fCambios: TObjectList<TCambioPermisoDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property Motivo: string read fMotivo write fMotivo;
    [MVCListOf(TCambioPermisoDTO)]
    property Cambios: TObjectList<TCambioPermisoDTO> read fCambios
      write fCambios;
  end;

implementation

constructor TMatrizPermisosDTO.Create;
begin
  inherited Create;
  fRoles := TObjectList<TRolDTO>.Create(True);
  fPermisos := TObjectList<TPermisoDTO>.Create(True);
  fAsignaciones := TObjectList<TAsignacionDTO>.Create(True);
end;

destructor TMatrizPermisosDTO.Destroy;
begin
  fAsignaciones.Free;
  fPermisos.Free;
  fRoles.Free;
  inherited;
end;

constructor TCambiosMatrizDTO.Create;
begin
  inherited Create;
  fCambios := TObjectList<TCambioPermisoDTO>.Create(True);
end;

destructor TCambiosMatrizDTO.Destroy;
begin
  fCambios.Free;
  inherited;
end;

end.
