unit Anovo.DTOs.Catalogos;

// El contrato de catalogos: lo que viaja entre la API y sus clientes.
//
// Compartida con el escritorio, que la compila desde esta misma ruta.
//
// Los DTO de entrada espejan sus tablas para que TMapeo copie por nombre.
// Quedan fuera las columnas que genera la base: ID y fechas de creacion y
// modificacion.
//
// El precio no entra en el DTO de edicion del item. Cambiarlo es otra
// operacion, con su propia ruta, porque deja rastro en el historial.
//
// Sin validadores: lo obligatorio y el largo estan en las entidades.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type

  // MATERIALES

  [MVCNameCase(ncSnakeCase)]
  TMaterialDTO = class
  private
    fID: Integer;
    fCodigo: string;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedida: string;
    fActivo: Boolean;
    fCostoUnitario: NullableCurrency;
    fPrecioUnitario: NullableCurrency;
    fFechaVigencia: NullableTDateTime;
  public
    property ID: Integer read fID write fID;
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
    property Activo: Boolean read fActivo write fActivo;
    // Nulos mientras el material no tenga precio cargado.
    property CostoUnitario: NullableCurrency read fCostoUnitario
      write fCostoUnitario;
    property PrecioUnitario: NullableCurrency read fPrecioUnitario
      write fPrecioUnitario;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMaterialNuevoDTO = class
  private
    fCodigo: string;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedida: string;
  public
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMaterialEdicionDTO = class
  private
    fCodigo: string;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedida: string;
  public
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
  end;

  // MANO DE OBRA

  [MVCNameCase(ncSnakeCase)]
  TManoObraDTO = class
  private
    fID: Integer;
    fCodigo: string;
    fCategoriaId: Integer;
    fCategoriaNombre: string;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedida: string;
    fActivo: Boolean;
    fCostoUnitario: NullableCurrency;
    fFechaVigencia: NullableTDateTime;
  public
    property ID: Integer read fID write fID;
    property Codigo: string read fCodigo write fCodigo;
    property CategoriaId: Integer read fCategoriaId write fCategoriaId;
    property CategoriaNombre: string read fCategoriaNombre
      write fCategoriaNombre;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
    property Activo: Boolean read fActivo write fActivo;
    // Sin precio de venta: la mano de obra solo lleva costo.
    property CostoUnitario: NullableCurrency read fCostoUnitario
      write fCostoUnitario;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
  end;

  [MVCNameCase(ncSnakeCase)]
  TManoObraNuevaDTO = class
  private
    fCodigo: string;
    fCategoriaId: Integer;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedida: string;
  public
    property Codigo: string read fCodigo write fCodigo;
    property CategoriaId: Integer read fCategoriaId write fCategoriaId;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
  end;

  [MVCNameCase(ncSnakeCase)]
  TManoObraEdicionDTO = class
  private
    fCodigo: string;
    fCategoriaId: Integer;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedida: string;
  public
    property Codigo: string read fCodigo write fCodigo;
    property CategoriaId: Integer read fCategoriaId write fCategoriaId;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCategoriaDTO = class
  private
    fID: Integer;
    fCodigo: string;
    fNombre: string;
  public
    property ID: Integer read fID write fID;
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
  end;

  // MAQUINAS

  [MVCNameCase(ncSnakeCase)]
  TMaquinaDTO = class
  private
    fID: Integer;
    fCodigo: string;
    fNombre: string;
    fDescripcion: NullableString;
    fActivo: Boolean;
    fCostoHora: NullableCurrency;
    fFechaVigencia: NullableTDateTime;
  public
    property ID: Integer read fID write fID;
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property Activo: Boolean read fActivo write fActivo;
    property CostoHora: NullableCurrency read fCostoHora write fCostoHora;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMaquinaNuevaDTO = class
  private
    fCodigo: string;
    fNombre: string;
    fDescripcion: NullableString;
  public
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMaquinaEdicionDTO = class
  private
    fCodigo: string;
    fNombre: string;
    fDescripcion: NullableString;
  public
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
  end;

  // TIPOS DE TRABAJO

  [MVCNameCase(ncSnakeCase)]
  TTipoTrabajoDTO = class
  private
    fID: Integer;
    fNombre: string;
    fActivo: Boolean;
  public
    property ID: Integer read fID write fID;
    property Nombre: string read fNombre write fNombre;
    property Activo: Boolean read fActivo write fActivo;
  end;

  [MVCNameCase(ncSnakeCase)]
  TTipoTrabajoNuevoDTO = class
  private
    fNombre: string;
  public
    property Nombre: string read fNombre write fNombre;
  end;

  // PRECIOS

  // Una fila del historial. Sirve para los tres catalogos: el que no tiene
  // precio de venta ni costo por hora los deja nulos.
  [MVCNameCase(ncSnakeCase)]
  TPrecioDTO = class
  private
    fID: Integer;
    fCostoUnitario: NullableCurrency;
    fPrecioUnitario: NullableCurrency;
    fCostoHora: NullableCurrency;
    fActivo: Boolean;
    fFechaVigencia: NullableTDateTime;
    fModificadoPor: NullableInt32;
  public
    property ID: Integer read fID write fID;
    property CostoUnitario: NullableCurrency read fCostoUnitario
      write fCostoUnitario;
    property PrecioUnitario: NullableCurrency read fPrecioUnitario
      write fPrecioUnitario;
    property CostoHora: NullableCurrency read fCostoHora write fCostoHora;
    property Activo: Boolean read fActivo write fActivo;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
    property ModificadoPor: NullableInt32 read fModificadoPor
      write fModificadoPor;
  end;

  // Lo que se manda al cambiar un precio. La fecha de vigencia es opcional: si
  // no viene, rige desde ya.
  [MVCNameCase(ncSnakeCase)]
  TPrecioNuevoDTO = class
  private
    fCostoUnitario: NullableCurrency;
    fPrecioUnitario: NullableCurrency;
    fCostoHora: NullableCurrency;
    fFechaVigencia: NullableTDateTime;
  public
    property CostoUnitario: NullableCurrency read fCostoUnitario
      write fCostoUnitario;
    property PrecioUnitario: NullableCurrency read fPrecioUnitario
      write fPrecioUnitario;
    property CostoHora: NullableCurrency read fCostoHora write fCostoHora;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
  end;

  // SOBRES DE PAGINA

  [MVCNameCase(ncSnakeCase)]
  TMaterialesPaginaDTO = class
  private
    fData: TObjectList<TMaterialDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
  public
    constructor Create(const AData: TObjectList<TMaterialDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TMaterialDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
  end;

  [MVCNameCase(ncSnakeCase)]
  TManoObraPaginaDTO = class
  private
    fData: TObjectList<TManoObraDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
  public
    constructor Create(const AData: TObjectList<TManoObraDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TManoObraDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMaquinasPaginaDTO = class
  private
    fData: TObjectList<TMaquinaDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
  public
    constructor Create(const AData: TObjectList<TMaquinaDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TMaquinaDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
  end;

implementation

{ TMaterialesPaginaDTO }

constructor TMaterialesPaginaDTO.Create(const AData: TObjectList<TMaterialDTO>;
  const ATotal: Int64; const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TMaterialesPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

{ TManoObraPaginaDTO }

constructor TManoObraPaginaDTO.Create(const AData: TObjectList<TManoObraDTO>;
  const ATotal: Int64; const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TManoObraPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

{ TMaquinasPaginaDTO }

constructor TMaquinasPaginaDTO.Create(const AData: TObjectList<TMaquinaDTO>;
  const ATotal: Int64; const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TMaquinasPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

end.
