unit Anovo.Services.Permisos;

// Cache de la matriz rol-permiso y de las excepciones por usuario,
// y el servicio que resuelve los permisos efectivos.

interface

uses
  MVCFramework,
  System.SyncObjs,
  System.Generics.Collections,
  Anovo.Repositories.Intf.Permisos,
  Anovo.Services.Intf.Permisos;

type
  TPermisoCache = class(TInterfacedObject, IPermisoCache)
  private
    fCandado: TCriticalSection;
    fPares: TArray<TRolPermiso>;
    fIndice: TDictionary<string, Boolean>;
    fExcepciones: TDictionary<string, Boolean>;
    fCargada: Boolean;
    class function Llave(const ARol, APermiso: string): string; static;
    class function LlaveUsuario(const AUsuarioId: Integer;
      const APermiso: string): string; static;
  public
    constructor Create;
    destructor Destroy; override;
    function Cargada: Boolean;
    procedure Cargar(const AMatriz: TArray<TRolPermiso>;
      const AExcepciones: TArray<TExcepcionPermiso>);
    procedure Invalidar;
    function Tiene(const AUsuarioId: Integer;
      const ARol, APermiso: string): Boolean;
    function PermisosDe(const AUsuarioId: Integer;
      const ARol: string): TArray<string>;
  end;

  TPermisoService = class(TInterfacedObject, IPermisoService)
  private
    fRepo: IPermisoRepository;
    fCache: IPermisoCache;
    procedure AsegurarCargada;
  public
    [MVCInject]
    constructor Create(ARepo: IPermisoRepository; ACache: IPermisoCache);
      reintroduce;
    function Tiene(const AUsuarioId: Integer;
      const ARol, APermiso: string): Boolean;
    function PermisosDe(const AUsuarioId: Integer;
      const ARol: string): TArray<string>;
  end;

implementation

uses
  System.SysUtils;

constructor TPermisoCache.Create;
begin
  inherited Create;
  fCandado := TCriticalSection.Create;
  fIndice := TDictionary<string, Boolean>.Create;
  fExcepciones := TDictionary<string, Boolean>.Create;
end;

destructor TPermisoCache.Destroy;
begin
  fExcepciones.Free;
  fIndice.Free;
  fCandado.Free;
  inherited;
end;

class function TPermisoCache.Llave(const ARol, APermiso: string): string;
begin
  Result := LowerCase(ARol) + #9 + LowerCase(APermiso);
end;

class function TPermisoCache.LlaveUsuario(const AUsuarioId: Integer;
  const APermiso: string): string;
begin
  Result := AUsuarioId.ToString + #9 + LowerCase(APermiso);
end;

function TPermisoCache.Cargada: Boolean;
begin
  fCandado.Enter;
  try
    Result := fCargada;
  finally
    fCandado.Leave;
  end;
end;

procedure TPermisoCache.Cargar(const AMatriz: TArray<TRolPermiso>;
  const AExcepciones: TArray<TExcepcionPermiso>);
var
  lPar: TRolPermiso;
  lExcepcion: TExcepcionPermiso;
begin
  fCandado.Enter;
  try
    fIndice.Clear;
    for lPar in AMatriz do
      fIndice.AddOrSetValue(Llave(lPar.Rol, lPar.Permiso), True);
    fExcepciones.Clear;
    for lExcepcion in AExcepciones do
      fExcepciones.AddOrSetValue(LlaveUsuario(lExcepcion.UsuarioId,
        lExcepcion.Permiso), lExcepcion.Otorgado);
    fPares := AMatriz;
    fCargada := True;
  finally
    fCandado.Leave;
  end;
end;

procedure TPermisoCache.Invalidar;
begin
  fCandado.Enter;
  try
    fCargada := False;
  finally
    fCandado.Leave;
  end;
end;

function TPermisoCache.Tiene(const AUsuarioId: Integer;
  const ARol, APermiso: string): Boolean;
var
  lOtorgado: Boolean;
begin
  fCandado.Enter;
  try
    if fExcepciones.TryGetValue(LlaveUsuario(AUsuarioId, APermiso), lOtorgado)
    then
      Exit(lOtorgado);
    Result := fIndice.ContainsKey(Llave(ARol, APermiso));
  finally
    fCandado.Leave;
  end;
end;

function TPermisoCache.PermisosDe(const AUsuarioId: Integer;
  const ARol: string): TArray<string>;
var
  lPar: TRolPermiso;
  lExcepcion: TPair<string, Boolean>;
  lPrefijo: string;
  lLista: TList<string>;
  lOtorgado: Boolean;
begin
  lPrefijo := AUsuarioId.ToString + #9;
  fCandado.Enter;
  try
    lLista := TList<string>.Create;
    try
      for lPar in fPares do
        if SameText(lPar.Rol, ARol) and not (fExcepciones.TryGetValue
          (LlaveUsuario(AUsuarioId, lPar.Permiso), lOtorgado) and
          not lOtorgado) then
          lLista.Add(lPar.Permiso);
      for lExcepcion in fExcepciones do
        if lExcepcion.Value and lExcepcion.Key.StartsWith(lPrefijo) then
          lLista.Add(lExcepcion.Key.Substring(lPrefijo.Length));
      Result := lLista.ToArray;
    finally
      lLista.Free;
    end;
  finally
    fCandado.Leave;
  end;
end;

constructor TPermisoService.Create(ARepo: IPermisoRepository;
  ACache: IPermisoCache);
begin
  inherited Create;
  fRepo := ARepo;
  fCache := ACache;
end;

procedure TPermisoService.AsegurarCargada;
begin
  if not fCache.Cargada then
    fCache.Cargar(fRepo.Matriz, fRepo.Excepciones);
end;

function TPermisoService.Tiene(const AUsuarioId: Integer;
  const ARol, APermiso: string): Boolean;
begin
  AsegurarCargada;
  Result := fCache.Tiene(AUsuarioId, ARol, APermiso);
end;

function TPermisoService.PermisosDe(const AUsuarioId: Integer;
  const ARol: string): TArray<string>;
begin
  AsegurarCargada;
  Result := fCache.PermisosDe(AUsuarioId, ARol);
end;

end.
