unit Anovo.Entities.Empresa;

// Entidad de EMPRESA, el emisor de la cotizacion.
// Generada por MVCEntGen; al regenerar, partir de Db/generado.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  MVCFramework.ActiveRecord,
  MVCFramework.Validators;

type

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('EMPRESA')]
  TEmpresa = class(TMVCActiveRecord)
  private
    [MVCTableField('ID', [foPrimaryKey])]
    [MVCRequired]
    fID: Int32;
    [MVCTableField('RAZON_SOCIAL')]
    [MVCRequired]
    [MVCMaxLength(120)]
    fRazonSocial: String;
    [MVCTableField('CEDULA_JURIDICA')]
    [MVCRequired]
    [MVCMaxLength(20)]
    fCedulaJuridica: String;
    [MVCTableField('DIRECCION')]
    [MVCMaxLength(500)]
    fDireccion: NullableString;
    [MVCTableField('TELEFONO_FIJO')]
    [MVCMaxLength(30)]
    fTelefonoFijo: NullableString;
    [MVCTableField('CELULAR')]
    [MVCMaxLength(30)]
    fCelular: NullableString;
    [MVCTableField('CORREO')]
    [MVCMaxLength(150)]
    fCorreo: NullableString;
    [MVCTableField('REPRESENTANTE_LEGAL')]
    [MVCMaxLength(120)]
    fRepresentanteLegal: NullableString;
    [MVCTableField('CUENTA_BANCARIA')]
    [MVCMaxLength(60)]
    fCuentaBancaria: NullableString;
    [MVCTableField('FECHA_MODIFICACION', [foRefresh])]
    fFechaModificacion: NullableTDateTime ;
  public
    property ID: Int32 read fID write fID;
    property RazonSocial: String read fRazonSocial write fRazonSocial;
    property CedulaJuridica: String read fCedulaJuridica write fCedulaJuridica;
    property Direccion: NullableString read fDireccion write fDireccion;
    property TelefonoFijo: NullableString read fTelefonoFijo write fTelefonoFijo;
    property Celular: NullableString read fCelular write fCelular;
    property Correo: NullableString read fCorreo write fCorreo;
    property RepresentanteLegal: NullableString read fRepresentanteLegal write fRepresentanteLegal;
    property CuentaBancaria: NullableString read fCuentaBancaria write fCuentaBancaria;
    property FechaModificacion: NullableTDateTime  read fFechaModificacion write fFechaModificacion;
  end;

implementation

initialization

ActiveRecordMappingRegistry.AddEntity('empresa', TEmpresa);

end.
