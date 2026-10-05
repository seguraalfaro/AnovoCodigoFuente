unit Anovo.DTOs.Importacion;

// DTOs de la importacion masiva de items nuevos a los catalogos.
// Compartidos con el escritorio.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type
  TCatalogoImportacion = (ciMateriales, ciManoObra, ciMaquinas);

  [MVCNameCase(ncSnakeCase)]
  TFilaImportacionDTO = class
  private
    fFila: Integer;
    fCodigo: string;
    fNombre: string;
    fDescripcion: NullableString;
    fUnidad: NullableString;
    fCategoria: NullableString;
    fCosto: NullableCurrency;
    fPrecio: NullableCurrency;
  public
    property Fila: Integer read fFila write fFila;
    property Codigo: string read fCodigo write fCodigo;
    property Nombre: string read fNombre write fNombre;
    property Descripcion: NullableString read fDescripcion write fDescripcion;
    property Unidad: NullableString read fUnidad write fUnidad;
    property Categoria: NullableString read fCategoria write fCategoria;
    property Costo: NullableCurrency read fCosto write fCosto;
    property Precio: NullableCurrency read fPrecio write fPrecio;
  end;

  [MVCNameCase(ncSnakeCase)]
  TImportacionDTO = class
  private
    fFilas: TObjectList<TFilaImportacionDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property Filas: TObjectList<TFilaImportacionDTO> read fFilas
      write fFilas;
  end;

  [MVCNameCase(ncSnakeCase)]
  TRevisionFilaDTO = class
  private
    fFila: Integer;
    fError: string;
    fExiste: Boolean;
  public
    property Fila: Integer read fFila write fFila;
    property Error: string read fError write fError;
    property Existe: Boolean read fExiste write fExiste;
  end;

  [MVCNameCase(ncSnakeCase)]
  TImportacionResultadoDTO = class
  private
    fRevisadas: Integer;
    fCreados: Integer;
    fErrores: TObjectList<TRevisionFilaDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property Revisadas: Integer read fRevisadas write fRevisadas;
    property Creados: Integer read fCreados write fCreados;
    property Errores: TObjectList<TRevisionFilaDTO> read fErrores
      write fErrores;
  end;

implementation

constructor TImportacionDTO.Create;
begin
  inherited Create;
  fFilas := TObjectList<TFilaImportacionDTO>.Create(True);
end;

destructor TImportacionDTO.Destroy;
begin
  fFilas.Free;
  inherited;
end;

constructor TImportacionResultadoDTO.Create;
begin
  inherited Create;
  fErrores := TObjectList<TRevisionFilaDTO>.Create(True);
end;

destructor TImportacionResultadoDTO.Destroy;
begin
  fErrores.Free;
  inherited;
end;

end.
