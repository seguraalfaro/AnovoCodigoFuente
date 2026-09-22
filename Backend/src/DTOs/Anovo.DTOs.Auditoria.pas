unit Anovo.DTOs.Auditoria;

// El contrato de la bitacora de auditoria: lo que viaja entre la API y sus
// clientes.
//
// Solo salida. La bitacora no se escribe desde afuera -la ponen los
// disparadores- asi que no hay DTO de entrada; lo que el cliente manda son
// filtros, y esos viajan en la consulta de la URL.
//
// USUARIO no es columna de AUDITORIA: la tabla guarda el numero y el nombre lo
// resuelve el servicio. Va en el contrato porque una bitacora que dice
// "usuario 4" no sirve para rendir cuentas.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type

  [MVCNameCase(ncSnakeCase)]
  TAuditoriaDTO = class
  private
    fID: Integer;
    fUsuarioId: NullableInt32;
    fUsuario: string;
    fAccion: string;
    fEntidad: string;
    fEntidadId: NullableInt32;
    fDetalle: NullableString;
    fFecha: NullableTDateTime;
  public
    property ID: Integer read fID write fID;
    // Nulo cuando la fila quedo de un usuario que ya no esta.
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    // Lo pone el servicio, no la tabla.
    property Usuario: string read fUsuario write fUsuario;
    property Accion: string read fAccion write fAccion;
    property Entidad: string read fEntidad write fEntidad;
    property EntidadId: NullableInt32 read fEntidadId write fEntidadId;
    property Detalle: NullableString read fDetalle write fDetalle;
    property Fecha: NullableTDateTime read fFecha write fFecha;
  end;

  // El sobre de la pagina, igual que el de clientes: la lista mas lo que hace
  // falta para saber cuantas paginas hay.
  [MVCNameCase(ncSnakeCase)]
  TAuditoriaPaginaDTO = class
  private
    fData: TObjectList<TAuditoriaDTO>;
    fTotal: Int64;
    fPagina: Integer;
    fPorPagina: Integer;
  public
    constructor Create(const AData: TObjectList<TAuditoriaDTO>;
      const ATotal: Int64; const APagina, APorPagina: Integer); reintroduce;
    destructor Destroy; override;
    property Data: TObjectList<TAuditoriaDTO> read fData write fData;
    property Total: Int64 read fTotal write fTotal;
    property Pagina: Integer read fPagina write fPagina;
    property PorPagina: Integer read fPorPagina write fPorPagina;
  end;

implementation

// TAuditoriaPaginaDTO

constructor TAuditoriaPaginaDTO.Create(const AData: TObjectList<TAuditoriaDTO>;
  const ATotal: Int64; const APagina, APorPagina: Integer);
begin
  inherited Create;
  fData := AData;
  fTotal := ATotal;
  fPagina := APagina;
  fPorPagina := APorPagina;
end;

destructor TAuditoriaPaginaDTO.Destroy;
begin
  fData.Free;
  inherited;
end;

end.
