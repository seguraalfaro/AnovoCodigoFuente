unit Anovo.Vistas.Intf.Importacion;

// Contrato de la vista de importacion masiva a un catalogo y la fila de la
// carga tal como se revisa en pantalla (todo en texto, como vino del archivo).

interface

uses
  System.Generics.Collections;

type
  TFilaCarga = class
  private
    FFila: Integer;
    FCodigo: string;
    FNombre: string;
    FDescripcion: string;
    FUnidad: string;
    FCategoria: string;
    FCosto: string;
    FPrecio: string;
    FRevision: string;
    FConError: Boolean;
  public
    property Fila: Integer read FFila write FFila;
    property Codigo: string read FCodigo write FCodigo;
    property Nombre: string read FNombre write FNombre;
    property Descripcion: string read FDescripcion write FDescripcion;
    property Unidad: string read FUnidad write FUnidad;
    property Categoria: string read FCategoria write FCategoria;
    property Costo: string read FCosto write FCosto;
    property Precio: string read FPrecio write FPrecio;
    property Revision: string read FRevision write FRevision;
    property ConError: Boolean read FConError write FConError;
  end;

  IVistaImportacion = interface
    ['{5F9A1C27-B4E3-4D80-9A6F-0C83E2B71D45}']
    procedure PrepararCatalogo(const ATitulo: string;
      const ARotulos: TArray<string>; const AObligatorios: TArray<Boolean>;
      const AConUnidad, AConCategoria, AConPrecio: Boolean;
      const ARotuloCosto: string);
    procedure MostrarArchivo(const ARuta: string);
    procedure MostrarHojas(const AHojas: TArray<string>;
      const AIndice: Integer);
    procedure MostrarColumnas(const AColumnas: TArray<string>;
      const ASeleccion: TArray<Integer>);
    procedure MostrarFilas(const AFilas: TObjectList<TFilaCarga>);
    procedure MostrarResumen(const ALeidas, AListas, AConError: Integer;
      const ARevisando: Boolean);
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    function Confirmar(const AMensaje: string): Boolean;
    procedure Terminar(const AMensaje: string);
  end;

implementation

end.
