unit Anovo.Entities.Vistas.Permisos;

// Fila de solo lectura de la matriz rol-permiso.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord;

type

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TRolPermisoVista = class(TMVCActiveRecord)
  private
    [MVCTableField('ROL')]
    fRol: String;
    [MVCTableField('PERMISO')]
    fPermiso: String;
  public
    property Rol: String read fRol write fRol;
    property Permiso: String read fPermiso write fPermiso;
  end;

implementation

end.
