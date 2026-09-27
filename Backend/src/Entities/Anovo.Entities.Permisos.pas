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
    [MVCTableField('MODULO')]
    [MVCRequired]
    [MVCMaxLength(30)]
    fModulo: String;
    [MVCTableField('AMBITO')]
    [MVCRequired]
    [MVCMaxLength(15)]
    fAmbito: String;
  public
    property ID: Int32 read fID write fID;
    property Codigo: String read fCodigo write fCodigo;
    property Nombre: String read fNombre write fNombre;
    property Modulo: String read fModulo write fModulo;
    property Ambito: String read fAmbito write fAmbito;
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
    [MVCTableField('AMBITO')]
    [MVCRequired]
    [MVCMaxLength(15)]
    fAmbito: String;
    [MVCTableField('FECHA_CREACION', [foDoNotInsert, foDoNotUpdate, foRefresh])]
    fFechaCreacion: NullableTDateTime ;
  public
    property RolId: Int32 read fRolId write fRolId;
    property PermisoId: Int32 read fPermisoId write fPermisoId;
    property Ambito: String read fAmbito write fAmbito;
    property FechaCreacion: NullableTDateTime
      read fFechaCreacion write fFechaCreacion;
  end;

implementation

initialization

ActiveRecordMappingRegistry.AddEntity('permisos', TPermisos);
ActiveRecordMappingRegistry.AddEntity('roles_permisos', TRolesPermisos);

end.
