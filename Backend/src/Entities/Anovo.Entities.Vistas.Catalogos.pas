unit Anovo.Entities.Vistas.Catalogos;

// Filas de solo lectura de los catalogos con su precio
// vigente. Escritas a mano, no por MVCEntGen.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  MVCFramework.ActiveRecord;

type

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TMaterialConPrecio = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('CODIGO')]
    fCodigo: String;
    [MVCTableField('NOMBRE')]
    fNombre: String;
    [MVCTableField('DESCRIPCION')]
    fDescripcion: NullableString;
    [MVCTableField('UNIDAD_MEDIDA')]
    fUnidadMedida: String;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('COSTO_UNITARIO')]
    fCostoUnitario: NullableCurrency;
    [MVCTableField('PRECIO_UNITARIO')]
    fPrecioUnitario: NullableCurrency;
    [MVCTableField('FECHA_VIGENCIA')]
    fFechaVigencia: NullableTDateTime;
    [MVCTableField('PROGRAMADO_FECHA')]
    fProgramadoFecha: NullableTDateTime;
  public
    property ID: NullableInt32 read fID write fID;
    property Codigo: String read fCodigo write fCodigo;
    property Nombre: String read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: String read fUnidadMedida write fUnidadMedida;
    property Activo: NullableBoolean read fActivo write fActivo;
    property CostoUnitario: NullableCurrency read fCostoUnitario
      write fCostoUnitario;
    property PrecioUnitario: NullableCurrency read fPrecioUnitario
      write fPrecioUnitario;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
    property ProgramadoFecha: NullableTDateTime read fProgramadoFecha
      write fProgramadoFecha;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TManoObraConPrecio = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('CODIGO')]
    fCodigo: String;
    [MVCTableField('CATEGORIA_ID')]
    fCategoriaId: Int32;
    [MVCTableField('CATEGORIA_NOMBRE')]
    fCategoriaNombre: String;
    [MVCTableField('NOMBRE')]
    fNombre: String;
    [MVCTableField('DESCRIPCION')]
    fDescripcion: NullableString;
    [MVCTableField('UNIDAD_MEDIDA')]
    fUnidadMedida: String;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('COSTO_UNITARIO')]
    fCostoUnitario: NullableCurrency;
    [MVCTableField('FECHA_VIGENCIA')]
    fFechaVigencia: NullableTDateTime;
    [MVCTableField('PROGRAMADO_FECHA')]
    fProgramadoFecha: NullableTDateTime;
  public
    property ID: NullableInt32 read fID write fID;
    property Codigo: String read fCodigo write fCodigo;
    property CategoriaId: Int32 read fCategoriaId write fCategoriaId;
    property CategoriaNombre: String read fCategoriaNombre
      write fCategoriaNombre;
    property Nombre: String read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: String read fUnidadMedida write fUnidadMedida;
    property Activo: NullableBoolean read fActivo write fActivo;
    property CostoUnitario: NullableCurrency read fCostoUnitario
      write fCostoUnitario;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
    property ProgramadoFecha: NullableTDateTime read fProgramadoFecha
      write fProgramadoFecha;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TMaquinaConPrecio = class(TMVCActiveRecord)
  private
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('CODIGO')]
    fCodigo: String;
    [MVCTableField('NOMBRE')]
    fNombre: String;
    [MVCTableField('DESCRIPCION')]
    fDescripcion: NullableString;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('COSTO_HORA')]
    fCostoHora: NullableCurrency;
    [MVCTableField('FECHA_VIGENCIA')]
    fFechaVigencia: NullableTDateTime;
    [MVCTableField('PROGRAMADO_FECHA')]
    fProgramadoFecha: NullableTDateTime;
  public
    property ID: NullableInt32 read fID write fID;
    property Codigo: String read fCodigo write fCodigo;
    property Nombre: String read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property Activo: NullableBoolean read fActivo write fActivo;
    property CostoHora: NullableCurrency read fCostoHora write fCostoHora;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
    property ProgramadoFecha: NullableTDateTime read fProgramadoFecha
      write fProgramadoFecha;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  TCatalogoItemConPrecio = class(TMVCActiveRecord)
  private
    [MVCTableField('TIPO')]
    fTipo: String;
    [MVCTableField('ID')]
    fID: NullableInt32;
    [MVCTableField('CODIGO')]
    fCodigo: String;
    [MVCTableField('NOMBRE')]
    fNombre: String;
    [MVCTableField('DESCRIPCION')]
    fDescripcion: NullableString;
    [MVCTableField('UNIDAD_MEDIDA')]
    fUnidadMedida: String;
    [MVCTableField('CATEGORIA_ID')]
    fCategoriaId: NullableInt32;
    [MVCTableField('COSTO_UNITARIO')]
    fCostoUnitario: NullableCurrency;
    [MVCTableField('PRECIO_UNITARIO')]
    fPrecioUnitario: NullableCurrency;
    [MVCTableField('COSTO_HORA')]
    fCostoHora: NullableCurrency;
    [MVCTableField('COSTO')]
    fCosto: NullableCurrency;
    [MVCTableField('FECHA_VIGENCIA')]
    fFechaVigencia: NullableTDateTime;
    [MVCTableField('ACTIVO')]
    fActivo: NullableBoolean;
    [MVCTableField('PROGRAMADO_FECHA')]
    fProgramadoFecha: NullableTDateTime;
  public
    property Tipo: String read fTipo write fTipo;
    property ID: NullableInt32 read fID write fID;
    property Codigo: String read fCodigo write fCodigo;
    property Nombre: String read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: String read fUnidadMedida write fUnidadMedida;
    property CategoriaId: NullableInt32 read fCategoriaId write fCategoriaId;
    property CostoUnitario: NullableCurrency read fCostoUnitario
      write fCostoUnitario;
    property PrecioUnitario: NullableCurrency read fPrecioUnitario
      write fPrecioUnitario;
    property CostoHora: NullableCurrency read fCostoHora write fCostoHora;
    property Costo: NullableCurrency read fCosto write fCosto;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
    property Activo: NullableBoolean read fActivo write fActivo;
    property ProgramadoFecha: NullableTDateTime read fProgramadoFecha
      write fProgramadoFecha;
  end;

implementation

end.
