unit Anovo.DTOs.Usuarios;

// DTOs de /api/usuarios: cuentas, clave temporal y excepciones de
// permisos por persona. Compartidos con el escritorio.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type

  [MVCNameCase(ncSnakeCase)]
  TUsuarioDTO = class
  private
    fID: Integer;
    fCorreo: string;
    fNombre: string;
    fRolId: Integer;
    fRol: string;
    fRolNombre: string;
    fAmbito: string;
    fActivo: Boolean;
    fDebeCambiarClave: Boolean;
    fFechaCreacion: NullableTDateTime;
    fFechaClave: NullableTDateTime;
    fExcepciones: Integer;
  public
    property ID: Integer read fID write fID;
    property Correo: string read fCorreo write fCorreo;
    property Nombre: string read fNombre write fNombre;
    property RolId: Integer read fRolId write fRolId;
    property Rol: string read fRol write fRol;
    property RolNombre: string read fRolNombre write fRolNombre;
    property Ambito: string read fAmbito write fAmbito;
    property Activo: Boolean read fActivo write fActivo;
    property DebeCambiarClave: Boolean read fDebeCambiarClave
      write fDebeCambiarClave;
    property FechaCreacion: NullableTDateTime read fFechaCreacion
      write fFechaCreacion;
    property FechaClave: NullableTDateTime read fFechaClave write fFechaClave;
    property Excepciones: Integer read fExcepciones write fExcepciones;
  end;

  [MVCNameCase(ncSnakeCase)]
  TUsuariosPaginaDTO = class
  private
    fData: TObjectList<TUsuarioDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
  public
    constructor Create(const AData: TObjectList<TUsuarioDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TUsuarioDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
  end;

  [MVCNameCase(ncSnakeCase)]
  TUsuarioEdicionDTO = class
  private
    fCorreo: string;
    fNombre: string;
    fRolId: Integer;
    fClaveTemporal: string;
  public
    property Correo: string read fCorreo write fCorreo;
    property Nombre: string read fNombre write fNombre;
    property RolId: Integer read fRolId write fRolId;
    property ClaveTemporal: string read fClaveTemporal write fClaveTemporal;
  end;

  [MVCNameCase(ncSnakeCase)]
  TClaveTemporalDTO = class
  private
    fClaveTemporal: string;
  public
    property ClaveTemporal: string read fClaveTemporal write fClaveTemporal;
  end;

  [MVCNameCase(ncSnakeCase)]
  TExcepcionDTO = class
  private
    fPermisoId: Integer;
    fPermiso: string;
    fNombre: string;
    fModulo: string;
    fTipo: string;
    fMotivo: string;
    fFechaCreacion: NullableTDateTime;
  public
    property PermisoId: Integer read fPermisoId write fPermisoId;
    property Permiso: string read fPermiso write fPermiso;
    property Nombre: string read fNombre write fNombre;
    property Modulo: string read fModulo write fModulo;
    property Tipo: string read fTipo write fTipo;
    property Motivo: string read fMotivo write fMotivo;
    property FechaCreacion: NullableTDateTime read fFechaCreacion
      write fFechaCreacion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCambioExcepcionDTO = class
  private
    fPermisoId: Integer;
    fTipo: string;
  public
    property PermisoId: Integer read fPermisoId write fPermisoId;
    property Tipo: string read fTipo write fTipo;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCambiosExcepcionesDTO = class
  private
    fMotivo: string;
    fCambios: TObjectList<TCambioExcepcionDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property Motivo: string read fMotivo write fMotivo;
    [MVCListOf(TCambioExcepcionDTO)]
    property Cambios: TObjectList<TCambioExcepcionDTO> read fCambios
      write fCambios;
  end;

implementation

constructor TUsuariosPaginaDTO.Create(const AData: TObjectList<TUsuarioDTO>;
  const ATotal: Int64; const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TUsuariosPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

constructor TCambiosExcepcionesDTO.Create;
begin
  inherited Create;
  fCambios := TObjectList<TCambioExcepcionDTO>.Create(True);
end;

destructor TCambiosExcepcionesDTO.Destroy;
begin
  fCambios.Free;
  inherited;
end;

end.
