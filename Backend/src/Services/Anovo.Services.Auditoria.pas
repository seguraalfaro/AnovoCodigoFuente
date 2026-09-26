unit Anovo.Services.Auditoria;

// Servicio de auditoria: donde vive el negocio de la bitacora.
//
// Dos reglas y nada mas, porque la bitacora solo se consulta:
//
//   1. El alcance. Quien tiene auditoria.ver_cuentas y no auditoria.ver_toda
//      solo ve lo de USUARIOS y USUARIOS_CLAVES. Que ese sea el permiso lo
//      decide el controller; aqui se traduce a un filtro.
//
//   2. El nombre del usuario. La tabla guarda el numero; el nombre sale del
//      repositorio de usuarios, en una sola consulta por pagina.
//
// Recibe los dos repositorios, uno por tabla, y los junta: es lo que cruza
// tablas, que es justo lo que le toca al servicio.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  Anovo.DTOs.Auditoria,
  Anovo.Entities.Auditoria,
  Anovo.Repositories.Intf.Auditoria,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Services.Intf.Auditoria;

type
  TAuditoriaService = class(TInterfacedObject, IAuditoriaService)
  private
    fRepo: IAuditoriaRepository;
    fUsuarios: IUsuarioRepository;
    // De la lista de entidades a la de DTO, con el nombre del usuario puesto.
    function AListaDto(const AEntidades: TObjectList<TAuditoria>)
      : TObjectList<TAuditoriaDTO>;
    procedure PonerNombres(const ALista: TObjectList<TAuditoriaDTO>);
    function EntidadSegun(const AAlcance: TAlcanceAuditoria;
      const AEntidad: string): string;
  public
    [MVCInject]
    constructor Create(ARepo: IAuditoriaRepository;
      AUsuarios: IUsuarioRepository); reintroduce;

    function Buscar(const AAlcance: TAlcanceAuditoria;
      const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer;
      const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string;
      out ATotal: Int64): TObjectList<TAuditoriaDTO>;
    function DeLaEntidad(const AEntidad: string; const AEntidadId: Integer)
      : TObjectList<TAuditoriaDTO>;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Textos;

const
  // Las dos entidades que forman la bitacora de cuentas.
  ENTIDAD_USUARIOS = 'USUARIOS';
  ENTIDAD_USUARIOS_CLAVES = 'USUARIOS_CLAVES';

  // Lo que se muestra cuando la fila quedo de un usuario que ya no esta. La
  // fila no se borra ni se corrige: para eso es la bitacora.
  USUARIO_DESCONOCIDO = 'Usuario eliminado';
  USUARIO_SISTEMA = 'Sistema';

{ TAuditoriaService }

constructor TAuditoriaService.Create(ARepo: IAuditoriaRepository;
  AUsuarios: IUsuarioRepository);
begin
  inherited Create;
  fRepo := ARepo;
  fUsuarios := AUsuarios;
end;

function TAuditoriaService.EntidadSegun(const AAlcance: TAlcanceAuditoria;
  const AEntidad: string): string;
var
  lEntidad: string;
begin
  lEntidad := UpperCase(Trim(AEntidad));

  if AAlcance = aaTodo then
    Exit(lEntidad);

  // Quien solo ve cuentas: sin entidad pedida se le da USUARIOS, y si pide
  // otra cosa se le dice que no puede, en vez de devolverle una lista vacia
  // que parece que no paso nada.
  if lEntidad = '' then
    Exit(ENTIDAD_USUARIOS);
  if not MatchStr(lEntidad, [ENTIDAD_USUARIOS, ENTIDAD_USUARIOS_CLAVES]) then
    raise ESinPermiso.Create
      ('Con auditoria.ver_cuentas solo se consulta USUARIOS y ' +
      'USUARIOS_CLAVES.');
  Result := lEntidad;
end;

function TAuditoriaService.Buscar(const AAlcance: TAlcanceAuditoria;
  const ADesde, AHasta: TDateTime; const APagina, APorPagina: Integer;
  const AUsuarioId: Integer; const AEntidad, AAccion, ATexto: string;
  out ATotal: Int64): TObjectList<TAuditoriaDTO>;
var
  lEntidades: TObjectList<TAuditoria>;
  lEntidad: string;
begin
  if ADesde > AHasta then
    raise EDatoInvalido.Create(SPeriodoInvertido);

  lEntidad := EntidadSegun(AAlcance, AEntidad);

  ATotal := fRepo.ContarBusqueda(ADesde, AHasta, AUsuarioId, lEntidad,
    UpperCase(Trim(AAccion)), ATexto);
  lEntidades := fRepo.Buscar(ADesde, AHasta, APagina, APorPagina, AUsuarioId,
    lEntidad, UpperCase(Trim(AAccion)), ATexto);
  try
    Result := AListaDto(lEntidades);
  finally
    lEntidades.Free;
  end;
end;

function TAuditoriaService.DeLaEntidad(const AEntidad: string;
  const AEntidadId: Integer): TObjectList<TAuditoriaDTO>;
var
  lEntidades: TObjectList<TAuditoria>;
begin
  lEntidades := fRepo.DeLaEntidad(UpperCase(Trim(AEntidad)), AEntidadId);
  try
    Result := AListaDto(lEntidades);
  finally
    lEntidades.Free;
  end;
end;

function TAuditoriaService.AListaDto(const AEntidades
  : TObjectList<TAuditoria>): TObjectList<TAuditoriaDTO>;
begin
  // La lista a medio armar, si el mapeo falla, la libera TMapeo.
  Result := TMapeo.AListaDto<TAuditoria, TAuditoriaDTO>(AEntidades);
  try
    PonerNombres(Result);
  except
    Result.Free;
    raise;
  end;
end;

procedure TAuditoriaService.PonerNombres(const ALista
  : TObjectList<TAuditoriaDTO>);
var
  lIds: TArray<Integer>;
  lNombres: TDictionary<Integer, string>;
  lVistos: TList<Integer>;
  lFila: TAuditoriaDTO;
  lNombre: string;
begin
  // Los numeros distintos de la pagina. Un conjunto para no repetir: una
  // pagina de cincuenta filas suele ser de menos de diez personas.
  lVistos := TList<Integer>.Create;
  try
    for lFila in ALista do
      if lFila.UsuarioId.HasValue and
        (lVistos.IndexOf(lFila.UsuarioId.Value) < 0) then
        lVistos.Add(lFila.UsuarioId.Value);
    lIds := lVistos.ToArray;
  finally
    lVistos.Free;
  end;

  lNombres := fUsuarios.NombresDe(lIds);
  try
    for lFila in ALista do
    begin
      // Sin numero: la fila la puso algo que no era una sesion, como un
      // script de carga.
      if not lFila.UsuarioId.HasValue then
        lFila.Usuario := USUARIO_SISTEMA
      else if lNombres.TryGetValue(lFila.UsuarioId.Value, lNombre) then
        lFila.Usuario := lNombre
      else
        lFila.Usuario := USUARIO_DESCONOCIDO;
    end;
  finally
    lNombres.Free;
  end;
end;

end.
