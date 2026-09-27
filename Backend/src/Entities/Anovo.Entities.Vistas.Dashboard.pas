unit Anovo.Entities.Vistas.Dashboard;

// Filas de solo lectura que devuelven las consultas
// de los dashboards.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  MVCFramework.ActiveRecord;

type

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TSolicitudAsesorVista = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('FECHA_CAPTURA')]
    fFechaCaptura: NullableTDateTime;
    [MVCTableField('CLIENTE_NOMBRE')]
    fClienteNombre: String;
    [MVCTableField('DESCRIPCION')]
    fDescripcion: String;
    [MVCTableField('ESTADO')]
    fEstado: String;
    [MVCTableField('COTIZACION_ID')]
    fCotizacionId: NullableInt32;
    [MVCTableField('MONTO_APROBADO')]
    fMontoAprobado: NullableCurrency;
  public
    property ID: NullableInt32 read fID write fID;
    property FechaCaptura: NullableTDateTime read fFechaCaptura
      write fFechaCaptura;
    property ClienteNombre: String read fClienteNombre write fClienteNombre;
    property Descripcion: String read fDescripcion write fDescripcion;
    property Estado: String read fEstado write fEstado;
    property CotizacionId: NullableInt32 read fCotizacionId
      write fCotizacionId;
    property MontoAprobado: NullableCurrency read fMontoAprobado
      write fMontoAprobado;
  end;

implementation

end.
