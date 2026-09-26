unit Anovo.Entities.Vistas.Catalogos;

// Las tres proyecciones de catalogo con su precio vigente, para recibir el
// resultado de MATERIALES_CON_PRECIO y sus dos hermanas.
//
// No son tablas ni se generan con MVCEntGen: se escriben a mano y hay que
// mantenerlas a la par de esas consultas, porque el enganche es el nombre de
// la columna y nada mas. Si a una consulta se le agrega una columna y aqui no
// esta el campo, el dato se pierde sin error.
//
// Sin MVCTable y con eaRetrieve: no se guardan nunca. Escribir en el catalogo
// es cosa de TMateriales y compania. Por lo mismo no llevan validadores, que
// solo corren al guardar.
//
// El precio viene de un LEFT JOIN, asi que es nulo mientras el item no tenga
// precio cargado. De ahi que sea NullableCurrency y no Currency: un cero se
// confundiria con un precio de cero.

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
    // Viene del join con MANO_OBRA_CATEGORIA: la lista muestra el nombre, no
    // el numero.
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
    // Sin precio de venta: la mano de obra solo lleva costo.
    [MVCTableField('COSTO_UNITARIO')]
    fCostoUnitario: NullableCurrency;
    [MVCTableField('FECHA_VIGENCIA')]
    fFechaVigencia: NullableTDateTime;
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
    // La maquina se cobra por hora, no por unidad.
    [MVCTableField('COSTO_HORA')]
    fCostoHora: NullableCurrency;
    [MVCTableField('FECHA_VIGENCIA')]
    fFechaVigencia: NullableTDateTime;
  public
    property ID: NullableInt32 read fID write fID;
    property Codigo: String read fCodigo write fCodigo;
    property Nombre: String read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property Activo: NullableBoolean read fActivo write fActivo;
    property CostoHora: NullableCurrency read fCostoHora write fCostoHora;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
  end;

implementation

end.
