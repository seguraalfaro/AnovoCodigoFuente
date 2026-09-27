unit Anovo.DTOs.Auditoria;

// DTOs de la bitacora de auditoria. Solo salida.

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
    property UsuarioId: NullableInt32 read fUsuarioId write fUsuarioId;
    property Usuario: string read fUsuario write fUsuario;
    property Accion: string read fAccion write fAccion;
    property Entidad: string read fEntidad write fEntidad;
    property EntidadId: NullableInt32 read fEntidadId write fEntidadId;
    property Detalle: NullableString read fDetalle write fDetalle;
    property Fecha: NullableTDateTime read fFecha write fFecha;
  end;

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
