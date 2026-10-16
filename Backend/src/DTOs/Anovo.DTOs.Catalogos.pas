unit Anovo.DTOs.Catalogos;

// DTOs de catalogos y precios.
// Compartidos con el escritorio.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

const
  TIPO_MATERIAL = 'material';
  TIPO_MANO_OBRA = 'mano_obra';
  TIPO_MAQUINA = 'maquina';
  TIPO_NOTA = 'nota';

  MAGNITUD_TIEMPO = 'tiempo';
  MAGNITUD_PESO = 'peso';
  MAGNITUD_LONGITUD = 'longitud';
  MAGNITUD_AREA = 'area';
  MAGNITUD_VOLUMEN = 'volumen';
  MAGNITUD_UNIDADES = 'unidades';

  MAGNITUDES: array [0 .. 5] of string = (MAGNITUD_TIEMPO, MAGNITUD_PESO,
    MAGNITUD_LONGITUD, MAGNITUD_AREA, MAGNITUD_VOLUMEN, MAGNITUD_UNIDADES);

type

  [MVCNameCase(ncSnakeCase)]
  TMaterialDTO = class
  private
    fID: Integer;
    fCodigo: string;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedida: string;
    fUnidadMedidaId: Integer;
    fActivo: Boolean;
    fCostoUnitario: NullableCurrency;
    fPrecioUnitario: NullableCurrency;
    fFechaVigencia: NullableTDateTime;
    fProgramadoFecha: NullableTDateTime;
  public
    property ID: Integer read fID write fID;
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
    property UnidadMedidaId: Integer read fUnidadMedidaId write fUnidadMedidaId;
    property Activo: Boolean read fActivo write fActivo;
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
  TMaterialNuevoDTO = class
  private
    fCodigo: string;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedidaId: Integer;
  public
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedidaId: Integer read fUnidadMedidaId write fUnidadMedidaId;
  end;

  [MVCNameCase(ncSnakeCase)]
  TMaterialEdicionDTO = class
  private
    fCodigo: string;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedidaId: Integer;
  public
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedidaId: Integer read fUnidadMedidaId write fUnidadMedidaId;
  end;

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
    fUnidadMedidaId: Integer;
    fActivo: Boolean;
    fCostoUnitario: NullableCurrency;
    fFechaVigencia: NullableTDateTime;
    fProgramadoFecha: NullableTDateTime;
  public
    property ID: Integer read fID write fID;
    property Codigo: string read fCodigo write fCodigo;
    property CategoriaId: Integer read fCategoriaId write fCategoriaId;
    property CategoriaNombre: string read fCategoriaNombre
      write fCategoriaNombre;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
    property UnidadMedidaId: Integer read fUnidadMedidaId write fUnidadMedidaId;
    property Activo: Boolean read fActivo write fActivo;
    property CostoUnitario: NullableCurrency read fCostoUnitario
      write fCostoUnitario;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
    property ProgramadoFecha: NullableTDateTime read fProgramadoFecha
      write fProgramadoFecha;
  end;

  [MVCNameCase(ncSnakeCase)]
  TManoObraNuevaDTO = class
  private
    fCodigo: string;
    fCategoriaId: Integer;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedidaId: Integer;
  public
    property Codigo: string read fCodigo write fCodigo;
    property CategoriaId: Integer read fCategoriaId write fCategoriaId;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedidaId: Integer read fUnidadMedidaId write fUnidadMedidaId;
  end;

  [MVCNameCase(ncSnakeCase)]
  TManoObraEdicionDTO = class
  private
    fCodigo: string;
    fCategoriaId: Integer;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedidaId: Integer;
  public
    property Codigo: string read fCodigo write fCodigo;
    property CategoriaId: Integer read fCategoriaId write fCategoriaId;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedidaId: Integer read fUnidadMedidaId write fUnidadMedidaId;
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
    fProgramadoFecha: NullableTDateTime;
  public
    property ID: Integer read fID write fID;
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property Activo: Boolean read fActivo write fActivo;
    property CostoHora: NullableCurrency read fCostoHora write fCostoHora;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
    property ProgramadoFecha: NullableTDateTime read fProgramadoFecha
      write fProgramadoFecha;
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
  TCatalogoSimpleDTO = class
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
  TCatalogoSimpleNuevoDTO = class
  private
    fNombre: string;
  public
    property Nombre: string read fNombre write fNombre;
  end;

  [MVCNameCase(ncSnakeCase)]
  TTipoTrabajoNuevoDTO = class
  private
    fNombre: string;
  public
    property Nombre: string read fNombre write fNombre;
  end;

  [MVCNameCase(ncSnakeCase)]
  TUnidadMedidaDTO = class
  private
    fID: Integer;
    fNombre: string;
    fAbreviatura: NullableString;
    fMagnitud: string;
    fActivo: Boolean;
  public
    property ID: Integer read fID write fID;
    property Nombre: string read fNombre write fNombre;
    property Abreviatura: NullableString read fAbreviatura write fAbreviatura;
    property Magnitud: string read fMagnitud write fMagnitud;
    property Activo: Boolean read fActivo write fActivo;
  end;

  [MVCNameCase(ncSnakeCase)]
  TUnidadMedidaNuevaDTO = class
  private
    fNombre: string;
    fAbreviatura: NullableString;
    fMagnitud: string;
  public
    property Nombre: string read fNombre write fNombre;
    property Abreviatura: NullableString read fAbreviatura write fAbreviatura;
    property Magnitud: string read fMagnitud write fMagnitud;
  end;

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

  [MVCNameCase(ncSnakeCase)]
  TCatalogoItemDTO = class
  private
    fTipo: string;
    fID: Integer;
    fCodigo: string;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidadMedida: string;
    fUnidadMedidaId: NullableInt32;
    fCategoriaId: NullableInt32;
    fCostoUnitario: NullableCurrency;
    fPrecioUnitario: NullableCurrency;
    fCostoHora: NullableCurrency;
    fCosto: NullableCurrency;
    fFechaVigencia: NullableTDateTime;
    fActivo: Boolean;
    fProgramadoFecha: NullableTDateTime;
  public
    property Tipo: string read fTipo write fTipo;
    property ID: Integer read fID write fID;
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property UnidadMedida: string read fUnidadMedida write fUnidadMedida;
    property UnidadMedidaId: NullableInt32 read fUnidadMedidaId
      write fUnidadMedidaId;
    property CategoriaId: NullableInt32 read fCategoriaId write fCategoriaId;
    property CostoUnitario: NullableCurrency read fCostoUnitario
      write fCostoUnitario;
    property PrecioUnitario: NullableCurrency read fPrecioUnitario
      write fPrecioUnitario;
    property CostoHora: NullableCurrency read fCostoHora write fCostoHora;
    property Costo: NullableCurrency read fCosto write fCosto;
    property FechaVigencia: NullableTDateTime read fFechaVigencia
      write fFechaVigencia;
    property Activo: Boolean read fActivo write fActivo;
    property ProgramadoFecha: NullableTDateTime read fProgramadoFecha
      write fProgramadoFecha;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCatalogoItemsPaginaDTO = class
  private
    fData: TObjectList<TCatalogoItemDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
  public
    constructor Create(const AData: TObjectList<TCatalogoItemDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TCatalogoItemDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
  end;

implementation

constructor TCatalogoItemsPaginaDTO.Create
  (const AData: TObjectList<TCatalogoItemDTO>; const ATotal: Int64;
  const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TCatalogoItemsPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

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
