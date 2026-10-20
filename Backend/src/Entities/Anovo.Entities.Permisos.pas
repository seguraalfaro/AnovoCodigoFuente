unit Anovo.Entities.Permisos;

// Entidades de PERMISOS y ROLES_PERMISOS.
// Generada por MVCEntGen; al regenerar, partir de Db/generado.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  MVCFramework.ActiveRecord,
  MVCFramework.Validators;

type

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('PERMISOS')]
  TPermisos = class(TMVCActiveRecord)
  private
    [MVCTableField('ID', [foPrimaryKey])]
    [MVCRequired]
    fID: Int32;
    [MVCTableField('CODIGO')]
    [MVCRequired]
    [MVCMaxLength(50)]
    fCodigo: String;
    [MVCTableField('NOMBRE')]
    [MVCRequired]
    [MVCMaxLength(120)]
    fNombre: String;
    [MVCTableField('MODULO_ID')]
    [MVCRequired]
    fModuloId: Int32;
    [MVCTableField('AMBITO_ID')]
    [MVCRequired]
    fAmbitoId: Int32;
    function GetAmbito: string;
    procedure SetAmbito(const AValor: string);
  public
    property ID: Int32 read fID write fID;
    property Codigo: String read fCodigo write fCodigo;
    property Nombre: String read fNombre write fNombre;
    property ModuloId: Int32 read fModuloId write fModuloId;
    property AmbitoId: Int32 read fAmbitoId write fAmbitoId;
    property Ambito: string read GetAmbito write SetAmbito;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('ROLES_PERMISOS')]
  TRolesPermisos = class(TMVCActiveRecord)
  private
    [MVCTableField('ROL_ID', [foPrimaryKey])]
    [MVCRequired]
    fRolId: Int32;
    [MVCTableField('PERMISO_ID', [foPrimaryKey])]
    [MVCRequired]
    fPermisoId: Int32;
    [MVCTableField('FECHA_CREACION', [foDoNotInsert, foDoNotUpdate, foRefresh])]
    fFechaCreacion: NullableTDateTime ;
    [MVCTableField('ACTIVO')]
    [MVCRequired]
    fActivo: Boolean;
    [MVCTableField('FECHA_MODIFICACION', [foDoNotInsert, foDoNotUpdate,
      foRefresh])]
    fFechaModificacion: NullableTDateTime;
    [MVCTableField('AMBITO_ID')]
    [MVCRequired]
    fAmbitoId: Int32;
    function GetAmbito: string;
    procedure SetAmbito(const AValor: string);
  public
    property RolId: Int32 read fRolId write fRolId;
    property PermisoId: Int32 read fPermisoId write fPermisoId;
    property FechaCreacion: NullableTDateTime
      read fFechaCreacion write fFechaCreacion;
    property Activo: Boolean read fActivo write fActivo;
    property FechaModificacion: NullableTDateTime
      read fFechaModificacion write fFechaModificacion;
    property AmbitoId: Int32 read fAmbitoId write fAmbitoId;
    property Ambito: string read GetAmbito write SetAmbito;
  end;

implementation

uses
  Anovo.Catalogos;

function TPermisos.GetAmbito: string;
begin
  Result := CodigoDeId(AMBITOS, fAmbitoId);
end;

procedure TPermisos.SetAmbito(const AValor: string);
begin
  fAmbitoId := IdDeCodigo(AMBITOS, AValor);
end;

function TRolesPermisos.GetAmbito: string;
begin
  Result := CodigoDeId(AMBITOS, fAmbitoId);
end;

procedure TRolesPermisos.SetAmbito(const AValor: string);
begin
  fAmbitoId := IdDeCodigo(AMBITOS, AValor);
end;

initialization

ActiveRecordMappingRegistry.AddEntity('permisos', TPermisos);
ActiveRecordMappingRegistry.AddEntity('roles_permisos', TRolesPermisos);

end.
